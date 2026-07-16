unit RelatorioVenda;

{ Filtro para Relatorio de Vendas Sintetico (mesmas regras dos relatorios
  de Cliente e Produto).

  Filtros disponiveis:
    1 - Ordem do resultado: alfabetica (nome do cliente), por CODIGO
        da venda ou por DATA da venda (radio);
    2 - Faixa de codigo da venda (inicial/final);
    3 - Faixa de data da venda (inicial/final), somente no formato
        dd/mm/yyyy, aplicada sobre DATA_HORA_VENDA.

  Campos: CODIGO da venda (zeros a esquerda, 6 casas), CODIGO_CLIENTE
  (zeros a esquerda, 5 casas) com o NOME buscado na tabela CLIENTE,
  DATA_HORA_VENDA (somente dd/mm/yyyy), TOTAL_BRUTO, DESCONTO_PERC,
  ACRESCIMO_PER e TOTAL_LIQUIDO.

  O botao Pesquisar monta a QueryVenda com os filtros informados e
  atualiza a DBGridVenda, exibindo o percentual da tarefa executada.
  A impressao e feita pelo FastReport com o layout guardado na tabela
  RELATORIO (campo BLOB ARQUIVO); no final o relatorio soma TOTAL_BRUTO,
  TOTAL_LIQUIDO e o total de vendas impressas.
  Grafico de barras no rodape: total liquido por dia
  (QueryGraficoPorDia + TfrxChartView). }

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls,
  Vcl.Grids, Vcl.DBGrids,
  Data.DB, IBX.IBQuery, IBX.IBCustomDataSet,
  frxClass, frxDBSet, frxChart, frxExportPDF, frxExportXML, frxExportRTF,
  frxExportCSV;

const
  // Cores dos campos de entrada (TColor = 0x00BBGGRR)
  COR_EDIT_NORMAL = clWhite;
  COR_EDIT_FOCO   = $00FFF5EA;

  // Cores alternadas das linhas do grid (zebra)
  COR_GRID_LINHA_PAR   = clWhite;
  COR_GRID_LINHA_IMPAR = $00F3E9DC;
  COR_GRID_TEXTO       = $00333333;

  // Icones Segoe MDL2 Assets (Windows 10/11)
  ICN_PESQUISA = #$E721; // Search
  ICN_LIMPAR   = #$E75C; // ClearSelection
  ICN_IMPRIMIR = #$E749; // Print
  ICN_SAIR     = #$E8BB; // ChromeClose

  // Layout FastReport guardado na tabela RELATORIO (campo BLOB ARQUIVO).
  // O arquivo .fr3 em disco e usado apenas na primeira execucao, para
  // alimentar a tabela.
  NOME_RELATORIO_VENDA = 'Relatorio_Venda_Sintetica';
  ARQUIVO_FR3          = 'Relatorio_Venda_Sintetica.fr3';
  PASTA_FR3            = 'C:\Avaliacao Delphi_Firebird\Andre_luis\Projeto\Fr3';
  PASTA_FR3_RELATIVA   = 'Fr3';

type
  TForm_RelatorioVenda = class(TForm)
    Panel_Titulo: TPanel;

    PanelFiltros: TPanel;
    RadioGrupoOrdem: TRadioGroup;
    LabelCodigoDe: TLabel;
    EditCodigoDe: TEdit;
    LabelCodigoAte: TLabel;
    EditCodigoAte: TEdit;
    LabelDataDe: TLabel;
    EditDataDe: TEdit;
    LabelDataAte: TLabel;
    EditDataAte: TEdit;
    LabelProgresso: TLabel;
    ProgressBarPesquisa: TProgressBar;

    DBGridVenda: TDBGrid;

    PanelRodape: TPanel;
    BtnPesquisar: TBitBtn;
    BtnLimpar: TBitBtn;
    BtnImprimir: TBitBtn;
    BtnSair: TBitBtn;

    QueryVenda: TIBQuery;
    DsVenda: TDataSource;
    frxDBDatasetVenda: TfrxDBDataset;
    QueryGraficoPorDia: TIBQuery;
    frxDBDatasetGraficoPorDia: TfrxDBDataset;
    frxReportVenda: TfrxReport;
    frxExportPDF: TfrxPDFExport;
    frxExportExcel: TfrxXMLExport;
    frxExportWord: TfrxRTFExport;
    frxExportCSV: TfrxCSVExport;

    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditFocoEnter(Sender: TObject);
    procedure EditFocoExit(Sender: TObject);
    procedure EditNumericoKeyPress(Sender: TObject; var Key: Char);
    procedure EditDataKeyPress(Sender: TObject; var Key: Char);
    procedure DBGridVendaDrawColumnCell(Sender: TObject;
      const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);
    procedure BtnPesquisarClick(Sender: TObject);
    procedure BtnLimparClick(Sender: TObject);
    procedure BtnImprimirClick(Sender: TObject);
    procedure BtnSairClick(Sender: TObject);
  private
    procedure ConfigurarGlyphsBotoes;
    function ValidarFaixaCodigo(out ACodigoDe, ACodigoAte: Integer;
      out ATemDe, ATemAte: Boolean): Boolean;
    function ValidarFaixaData(out ADataDe, ADataAte: TDateTime;
      out ATemDataDe, ATemDataAte: Boolean): Boolean;
    procedure Pesquisar;
    procedure AjustarFormatoCampos;
    procedure AtualizarProgresso(Percentual: Integer);
    procedure DestacarColunaOrdenacao;
    function LocalizarArquivoFr3: string;
    procedure GravarRelatorioNoBanco(const ANome, ACaminhoArquivo: string);
    function CarregarRelatorioDoBanco(const ANome: string;
      Stream: TStream): Boolean;
    procedure ConfigurarGraficoBarrasPorDia;
    procedure ExibirRelatorio;
  public
    { Public declarations }
  end;

var
  Form_RelatorioVenda: TForm_RelatorioVenda;

implementation

uses DataModule, Mensagens, RelatorioExportacaoFast, UITheme;

{$R *.dfm}

{ Utilitarios visuais (mesmo padrao do RelatorioCliente) }

procedure TForm_RelatorioVenda.ConfigurarGlyphsBotoes;
begin
  AplicarBotaoBootstrap(BtnPesquisar, bbkOutline, ICN_PESQUISA);
  AplicarBotaoBootstrap(BtnLimpar, bbkOutline, ICN_LIMPAR);
  AplicarBotaoBootstrap(BtnImprimir, bbkPrimary, ICN_IMPRIMIR);
  AplicarBotaoBootstrap(BtnSair, bbkSecondary, ICN_SAIR);
end;

{ Ciclo de vida }

procedure TForm_RelatorioVenda.FormCreate(Sender: TObject);
begin
  Color := COR_PAGE;
  AplicarHeaderPrimary(Panel_Titulo);
  AplicarFormEstiloWeb(Self);
  AplicarPainelCard(PanelFiltros);
  ConfigurarGlyphsBotoes;
  TRelatorioExportacaoFast.VincularExportacoes(frxReportVenda, frxExportPDF,
    frxExportExcel, frxExportWord, frxExportCSV);

  // Abre listando todas as vendas na ordem padrao (nome do cliente).
  Pesquisar;
end;

procedure TForm_RelatorioVenda.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  QueryVenda.Close;
  QueryGraficoPorDia.Close;
  Action := caFree;
  Form_RelatorioVenda := nil;
end;

{ Navegacao por teclado }

procedure TForm_RelatorioVenda.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    Key := 0;
    Close;
  end
  else if (Key = VK_RETURN) and not (ActiveControl is TCustomButton) then
  begin
    Key := 0;
    // ENTER na grade nao navega; nos filtros dispara a pesquisa quando o
    // ultimo campo (Data final) esta focado, senao segue ao proximo.
    if ActiveControl is TCustomDBGrid then
      Exit;
    if ActiveControl = EditDataAte then
      BtnPesquisar.Click
    else
      SelectNext(ActiveControl, True, True);
  end;
end;

{ Cores de foco }

procedure TForm_RelatorioVenda.EditFocoEnter(Sender: TObject);
begin
  if Sender is TEdit then
    TEdit(Sender).Color := COR_EDIT_FOCO;
end;

procedure TForm_RelatorioVenda.EditFocoExit(Sender: TObject);
begin
  if Sender is TEdit then
    TEdit(Sender).Color := COR_EDIT_NORMAL;
end;

procedure TForm_RelatorioVenda.EditNumericoKeyPress(Sender: TObject;
  var Key: Char);
begin
  // Faixa de codigo aceita apenas digitos (e backspace).
  if not CharInSet(Key, ['0'..'9', #8]) then
    Key := #0;
end;

procedure TForm_RelatorioVenda.EditDataKeyPress(Sender: TObject;
  var Key: Char);
var
  Edit: TEdit;
begin
  // Faixa de data aceita apenas digitos, a barra e backspace (dd/mm/yyyy).
  if not CharInSet(Key, ['0'..'9', '/', #8]) then
  begin
    Key := #0;
    Exit;
  end;

  // Insere a barra automaticamente apos o dia e o mes.
  if CharInSet(Key, ['0'..'9']) and (Sender is TEdit) then
  begin
    Edit := TEdit(Sender);
    if ((Length(Edit.Text) = 2) or (Length(Edit.Text) = 5)) and
       (Edit.SelLength = 0) and (Edit.SelStart = Length(Edit.Text)) then
    begin
      Edit.Text := Edit.Text + '/';
      Edit.SelStart := Length(Edit.Text);
    end;
  end;
end;

{ Grid - linhas com cores alternadas (zebra) }

procedure TForm_RelatorioVenda.DBGridVendaDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
var
  Grid: TDBGrid;
begin
  Grid := TDBGrid(Sender);

  if not (gdSelected in State) then
  begin
    if Odd(Grid.DataSource.DataSet.RecNo) then
      Grid.Canvas.Brush.Color := COR_GRID_LINHA_IMPAR
    else
      Grid.Canvas.Brush.Color := COR_GRID_LINHA_PAR;
    Grid.Canvas.Font.Color := COR_GRID_TEXTO;
  end;

  Grid.DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;

{ Pesquisa }

function TForm_RelatorioVenda.ValidarFaixaCodigo(out ACodigoDe,
  ACodigoAte: Integer; out ATemDe, ATemAte: Boolean): Boolean;
begin
  Result := True;
  ATemDe  := TryStrToInt(Trim(EditCodigoDe.Text),  ACodigoDe);
  ATemAte := TryStrToInt(Trim(EditCodigoAte.Text), ACodigoAte);

  if ATemDe and ATemAte and (ACodigoDe > ACodigoAte) then
  begin
    MensagemDlg('Faixa de codigo invalida: o codigo inicial e maior ' +
      'que o codigo final.', mtWarning, [mbOK], 0);
    if EditCodigoDe.CanFocus then
      EditCodigoDe.SetFocus;
    Result := False;
  end;
end;

function TForm_RelatorioVenda.ValidarFaixaData(out ADataDe,
  ADataAte: TDateTime; out ATemDataDe, ATemDataAte: Boolean): Boolean;
var
  Fmt: TFormatSettings;

  function ConverterData(Edit: TEdit; out Valor: TDateTime;
    out Tem: Boolean): Boolean;
  begin
    Result := True;
    Tem    := False;
    Valor  := 0;
    if Trim(Edit.Text) = '' then
      Exit;

    Tem := TryStrToDate(Trim(Edit.Text), Valor, Fmt);
    if not Tem then
    begin
      MensagemDlg('Data invalida: "' + Trim(Edit.Text) + '". Informe a ' +
        'data no formato dd/mm/yyyy.', mtWarning, [mbOK], 0);
      if Edit.CanFocus then
        Edit.SetFocus;
      Result := False;
    end;
  end;

begin
  // As datas sao aceitas somente no formato dd/mm/yyyy, independente da
  // configuracao regional do Windows.
  Fmt := TFormatSettings.Create;
  Fmt.DateSeparator   := '/';
  Fmt.ShortDateFormat := 'dd/mm/yyyy';

  Result := ConverterData(EditDataDe, ADataDe, ATemDataDe) and
            ConverterData(EditDataAte, ADataAte, ATemDataAte);
  if not Result then
    Exit;

  if ATemDataDe and ATemDataAte and (ADataDe > ADataAte) then
  begin
    MensagemDlg('Faixa de data invalida: a data inicial e maior que a ' +
      'data final.', mtWarning, [mbOK], 0);
    if EditDataDe.CanFocus then
      EditDataDe.SetFocus;
    Result := False;
  end;
end;

procedure TForm_RelatorioVenda.AjustarFormatoCampos;

  procedure Formatar(const NomeCampo, Formato: string);
  var
    Fld: TField;
  begin
    Fld := QueryVenda.FindField(NomeCampo);
    if Fld is TBCDField then
      TBCDField(Fld).DisplayFormat := Formato
    else if Fld is TFloatField then
      TFloatField(Fld).DisplayFormat := Formato
    else if Fld is TIntegerField then
      TIntegerField(Fld).DisplayFormat := Formato
    else if Fld is TDateTimeField then
      TDateTimeField(Fld).DisplayFormat := Formato;
  end;

begin
  // Zeros a esquerda: venda com 6 casas e cliente com 5 casas.
  Formatar('CODIGO',          '000000');
  Formatar('CODIGO_CLIENTE',  '00000');
  // Somente a data, sem a hora.
  Formatar('DATA_HORA_VENDA', 'dd/mm/yyyy');
  Formatar('TOTAL_BRUTO',     '#,##0.00');
  Formatar('DESCONTO_PERC',   '#,##0.00');
  Formatar('ACRESCIMO_PER',   '#,##0.00');
  Formatar('TOTAL_LIQUIDO',   '#,##0.00');
end;

procedure TForm_RelatorioVenda.AtualizarProgresso(Percentual: Integer);
begin
  ProgressBarPesquisa.Position := Percentual;
  LabelProgresso.Caption := Format('Executando pesquisa: %d%%', [Percentual]);
  // Update forca o repaint imediato sem reentrar no loop de mensagens.
  ProgressBarPesquisa.Update;
  LabelProgresso.Update;
end;

procedure TForm_RelatorioVenda.DestacarColunaOrdenacao;
var
  I: Integer;
  CampoOrdem: string;
begin
  // Campo de ordenacao escolhido no Filtro 1 (radio).
  case RadioGrupoOrdem.ItemIndex of
    1: CampoOrdem := 'CODIGO';
    2: CampoOrdem := 'DATA_HORA_VENDA';
  else
    CampoOrdem := 'NOME_CLIENTE';
  end;

  // Titulo da coluna ordenada em destaque (invertido: fundo navy, texto
  // branco); as demais voltam ao visual padrao.
  for I := 0 to DBGridVenda.Columns.Count - 1 do
    if SameText(DBGridVenda.Columns[I].FieldName, CampoOrdem) then
    begin
      DBGridVenda.Columns[I].Title.Color      := COR_PRIMARY;
      DBGridVenda.Columns[I].Title.Font.Color := clWhite;
    end
    else
    begin
      DBGridVenda.Columns[I].Title.Color      := clBtnFace;
      DBGridVenda.Columns[I].Title.Font.Color := COR_PRIMARY;
    end;
end;

procedure TForm_RelatorioVenda.Pesquisar;
var
  Where, Sql: string;
  CodigoDe, CodigoAte: Integer;
  TemDe, TemAte: Boolean;
  DataDe, DataAte: TDateTime;
  TemDataDe, TemDataAte: Boolean;
  QueryContagem: TIBQuery;
  Total, Lidos, Passo: Integer;

  procedure PreencherParametros(Query: TIBQuery);
  begin
    if TemDe then
      Query.ParamByName('PCODIGO_DE').AsInteger := CodigoDe;
    if TemAte then
      Query.ParamByName('PCODIGO_ATE').AsInteger := CodigoAte;
    if TemDataDe then
      Query.ParamByName('PDATA_DE').AsDateTime := DataDe;
    if TemDataAte then
      // DATA_HORA_VENDA e timestamp: soma um dia e compara com "menor
      // que" para incluir todas as vendas do dia final informado.
      Query.ParamByName('PDATA_ATE').AsDateTime := DataAte + 1;
  end;

begin
  if not ValidarFaixaCodigo(CodigoDe, CodigoAte, TemDe, TemAte) then
    Exit;
  if not ValidarFaixaData(DataDe, DataAte, TemDataDe, TemDataAte) then
    Exit;

  AtualizarProgresso(0);

  // Monta o WHERE somente com os filtros efetivamente preenchidos.
  // O nome do cliente vem da tabela CLIENTE (join pelo codigo).
  Where := ' from VENDA V ' +
           'left join CLIENTE C on C.CODIGO = V.CODIGO_CLIENTE ' +
           'where 1 = 1';
  if TemDe then
    Where := Where + ' and V.CODIGO >= :PCODIGO_DE';
  if TemAte then
    Where := Where + ' and V.CODIGO <= :PCODIGO_ATE';
  if TemDataDe then
    Where := Where + ' and V.DATA_HORA_VENDA >= :PDATA_DE';
  if TemDataAte then
    Where := Where + ' and V.DATA_HORA_VENDA < :PDATA_ATE';

  // Filtro 1: ordem alfabetica (nome do cliente), por codigo ou por data.
  Sql := 'select V.CODIGO, V.CODIGO_CLIENTE, C.NOME as NOME_CLIENTE, ' +
         'V.DATA_HORA_VENDA, V.TOTAL_BRUTO, V.DESCONTO_PERC, ' +
         'V.ACRESCIMO_PER, V.TOTAL_LIQUIDO' + Where;
  case RadioGrupoOrdem.ItemIndex of
    1: Sql := Sql + ' order by V.CODIGO';
    2: Sql := Sql + ' order by V.DATA_HORA_VENDA, V.CODIGO';
  else
    Sql := Sql + ' order by C.NOME, V.CODIGO';
  end;

  // Total de registros esperados: base do calculo do percentual.
  Total := 0;
  QueryContagem := TIBQuery.Create(nil);
  try
    QueryContagem.Database    := QueryVenda.Database;
    QueryContagem.Transaction := QueryVenda.Transaction;
    QueryContagem.SQL.Text    := 'select count(*)' + Where;
    PreencherParametros(QueryContagem);
    QueryContagem.Open;
    Total := QueryContagem.Fields[0].AsInteger;
    QueryContagem.Close;
  finally
    QueryContagem.Free;
  end;
  AtualizarProgresso(15);

  QueryVenda.DisableControls;
  try
    QueryVenda.Close;
    QueryVenda.SQL.Text := Sql;
    PreencherParametros(QueryVenda);
    QueryVenda.Open;
    AjustarFormatoCampos;
    AtualizarProgresso(25);

    // Dataset agregado por dia (mesmos filtros) para o grafico de barras.
    QueryGraficoPorDia.Close;
    QueryGraficoPorDia.SQL.Text :=
      'select' +
      '  cast(V.DATA_HORA_VENDA as date) as DATA_VENDA,' +
      '  sum(V.TOTAL_LIQUIDO) as TOTAL_DIA' +
      Where +
      ' group by cast(V.DATA_HORA_VENDA as date)' +
      ' order by 1';
    PreencherParametros(QueryGraficoPorDia);
    QueryGraficoPorDia.Open;
    AtualizarProgresso(30);

    // Percorre o resultado trazendo os registros do servidor e avancando
    // o percentual proporcionalmente a quantidade ja carregada.
    if Total > 0 then
    begin
      Lidos := 0;
      Passo := Total div 20;
      if Passo < 1 then
        Passo := 1;
      while not QueryVenda.Eof do
      begin
        Inc(Lidos);
        if (Lidos mod Passo) = 0 then
          AtualizarProgresso(30 + (Lidos * 65 div Total));
        QueryVenda.Next;
      end;
      QueryVenda.First;
    end;

    AtualizarProgresso(100);
    LabelProgresso.Caption := Format('Pesquisa concluida: %d venda(s)',
      [Total]);
  finally
    QueryVenda.EnableControls;
  end;

  DestacarColunaOrdenacao;
end;

procedure TForm_RelatorioVenda.BtnPesquisarClick(Sender: TObject);
begin
  Pesquisar;

  if QueryVenda.Active and QueryVenda.IsEmpty then
    MensagemDlg('Nenhuma venda encontrada para os filtros informados.',
      mtInformation, [mbOK], 0);
end;

procedure TForm_RelatorioVenda.BtnLimparClick(Sender: TObject);
begin
  // Volta os filtros ao estado original do formulario.
  EditCodigoDe.Clear;
  EditCodigoAte.Clear;
  EditDataDe.Clear;
  EditDataAte.Clear;
  RadioGrupoOrdem.ItemIndex := 0;

  // Refaz a pesquisa sem filtros (lista completa em ordem alfabetica).
  BtnPesquisar.Click;

  // No Limpar o indicador de progresso desaparece, voltando o formulario
  // ao estado original.
  ProgressBarPesquisa.Position := 0;
  LabelProgresso.Caption := '';

  if EditCodigoDe.CanFocus then
    EditCodigoDe.SetFocus;
end;

{ Impressao - layout FastReport guardado na tabela RELATORIO }

function TForm_RelatorioVenda.LocalizarArquivoFr3: string;
var
  PastaExe: string;
  Bases: array of string;
  I: Integer;
  Tentativa: string;
begin
  Result   := '';
  PastaExe := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName));

  Bases := [
    IncludeTrailingPathDelimiter(PASTA_FR3),
    PastaExe + PASTA_FR3_RELATIVA + PathDelim,
    PastaExe,
    PastaExe + '..' + PathDelim + PASTA_FR3_RELATIVA + PathDelim,
    PastaExe + '..' + PathDelim + '..' + PathDelim + PASTA_FR3_RELATIVA + PathDelim
  ];

  for I := Low(Bases) to High(Bases) do
  begin
    Tentativa := Bases[I] + ARQUIVO_FR3;
    if FileExists(Tentativa) then
      Exit(Tentativa);
  end;
end;

procedure TForm_RelatorioVenda.GravarRelatorioNoBanco(const ANome,
  ACaminhoArquivo: string);
var
  Query: TIBQuery;
  Stream: TFileStream;
begin
  Stream := TFileStream.Create(ACaminhoArquivo,
    fmOpenRead or fmShareDenyWrite);
  try
    Query := TIBQuery.Create(nil);
    try
      Query.Database    := QueryVenda.Database;
      Query.Transaction := QueryVenda.Transaction;
      // UPDATE OR INSERT: grava na primeira vez e substitui o layout nas
      // execucoes seguintes (versionamento pelo NOME).
      Query.SQL.Text :=
        'update or insert into RELATORIO ' +
        '  (NOME, DESCRICAO, ARQUIVO, DATA_ALTERACAO) ' +
        'values ' +
        '  (:PNOME, :PDESCRICAO, :PARQUIVO, CURRENT_TIMESTAMP) ' +
        'matching (NOME)';
      Query.ParamByName('PNOME').AsString      := ANome;
      Query.ParamByName('PDESCRICAO').AsString :=
        'Relatorio de Vendas Sintetico';
      Query.ParamByName('PARQUIVO').LoadFromStream(Stream, ftBlob);
      Query.ExecSQL;
      Dm.IBTransaction1.CommitRetaining;
    finally
      Query.Free;
    end;
  finally
    Stream.Free;
  end;
end;

function TForm_RelatorioVenda.CarregarRelatorioDoBanco(const ANome: string;
  Stream: TStream): Boolean;
var
  Query: TIBQuery;
begin
  Query := TIBQuery.Create(nil);
  try
    Query.Database    := QueryVenda.Database;
    Query.Transaction := QueryVenda.Transaction;
    Query.SQL.Text :=
      'select ARQUIVO from RELATORIO where NOME = :PNOME';
    Query.ParamByName('PNOME').AsString := ANome;
    Query.Open;

    Result := not (Query.IsEmpty or Query.FieldByName('ARQUIVO').IsNull);
    if Result then
    begin
      TBlobField(Query.FieldByName('ARQUIVO')).SaveToStream(Stream);
      Stream.Position := 0;
    end;
    Query.Close;
  finally
    Query.Free;
  end;
end;

procedure TForm_RelatorioVenda.ConfigurarGraficoBarrasPorDia;
var
  lChart: TfrxChartView;
  lSerie: TfrxSeriesItem;
  lBand: TfrxBand;
  lI: Integer;
  lComp: TfrxComponent;
begin
  // Garante o dataset do grafico no relatorio apos LoadFromStream.
  if frxReportVenda.DataSets.Find(frxDBDatasetGraficoPorDia) = nil then
    frxReportVenda.DataSets.Add(frxDBDatasetGraficoPorDia);

  lChart := frxReportVenda.FindObject('ChartBarrasPorDia') as TfrxChartView;
  if not Assigned(lChart) then
  begin
    lBand := frxReportVenda.FindObject('ReportSummary1') as TfrxBand;
    if not Assigned(lBand) then
    begin
      // Layout do banco pode usar outro nome de banda de rodape.
      lI := 0;
      while (lI < frxReportVenda.AllObjects.Count) and (not Assigned(lBand)) do
      begin
        lComp := TfrxComponent(frxReportVenda.AllObjects[lI]);
        if lComp is TfrxReportSummary then
          lBand := TfrxBand(lComp);
        Inc(lI);
      end;
    end;
    if not Assigned(lBand) then
      Exit;

    if lBand.Height < 300 then
      lBand.Height := 300;
    lChart := TfrxChartView.Create(lBand);
    lChart.Name := 'ChartBarrasPorDia';
    lChart.Left := 3.77953;
    lChart.Top := 94;
    lChart.Width := 710;
    lChart.Height := 200;
  end;

  lChart.ClearSeries;
  lChart.AddSeries(csBar);
  if lChart.SeriesData.Count = 0 then
    Exit;

  lSerie := lChart.SeriesData[0];
  lSerie.DataType := dtDBData;
  lSerie.DataSet := frxDBDatasetGraficoPorDia;
  lSerie.DataSetName := 'frxDBDatasetGraficoPorDia';
  lSerie.XType := xtText;
  lSerie.Source1 :=
    'FormatDateTime(''dd/mm/yyyy'', <frxDBDatasetGraficoPorDia."DATA_VENDA">)';
  lSerie.Source2 := '<frxDBDatasetGraficoPorDia."TOTAL_DIA">';

  if Assigned(lChart.Chart) then
  begin
    lChart.Chart.Title.Text.Text := 'Total liquido por dia';
    lChart.Chart.Title.Visible := True;
    lChart.Chart.Legend.Visible := False;
    lChart.Chart.View3D := False;
    if lChart.Chart.SeriesCount > 0 then
    begin
      lChart.Chart.Series[0].Title := 'Total liquido';
      lChart.Chart.Series[0].ColorEachPoint := True;
    end;
  end;
end;

procedure TForm_RelatorioVenda.ExibirRelatorio;
var
  Stream: TMemoryStream;
  CaminhoFr3: string;
begin
  Stream := TMemoryStream.Create;
  try
    // O layout mora na tabela RELATORIO. Se ainda nao foi gravado
    // (primeira execucao), alimenta a tabela a partir do .fr3 em disco.
    if not CarregarRelatorioDoBanco(NOME_RELATORIO_VENDA, Stream) then
    begin
      CaminhoFr3 := LocalizarArquivoFr3;
      if CaminhoFr3 = '' then
      begin
        MensagemDlg('Relatorio "' + NOME_RELATORIO_VENDA + '" nao ' +
          'encontrado na tabela RELATORIO e o arquivo ' + ARQUIVO_FR3 +
          ' nao foi localizado em disco.', mtWarning, [mbOK], 0);
        Exit;
      end;

      GravarRelatorioNoBanco(NOME_RELATORIO_VENDA, CaminhoFr3);
      if not CarregarRelatorioDoBanco(NOME_RELATORIO_VENDA, Stream) then
      begin
        MensagemDlg('Nao foi possivel carregar o relatorio gravado na ' +
          'tabela RELATORIO.', mtError, [mbOK], 0);
        Exit;
      end;
    end;

    frxReportVenda.LoadFromStream(Stream);
    ConfigurarGraficoBarrasPorDia;
    TRelatorioExportacaoFast.VincularExportacoes(frxReportVenda, frxExportPDF,
      frxExportExcel, frxExportWord, frxExportCSV);
    frxReportVenda.ShowReport;
  finally
    Stream.Free;
  end;
end;

procedure TForm_RelatorioVenda.BtnImprimirClick(Sender: TObject);
begin
  if not QueryVenda.Active or QueryVenda.IsEmpty then
  begin
    MensagemDlg('Nao ha vendas para imprimir. Utilize o botao ' +
      'Pesquisar primeiro.', mtInformation, [mbOK], 0);
    Exit;
  end;

  // Impressao via FastReport: o layout vem da tabela RELATORIO e os dados
  // da QueryVenda (ja filtrada pela pesquisa).
  try
    ExibirRelatorio;
  except
    on E: Exception do
      MensagemDlg('Erro ao abrir o relatorio.' + sLineBreak + E.Message,
        mtError, [mbOK], 0);
  end;
end;

procedure TForm_RelatorioVenda.BtnSairClick(Sender: TObject);
begin
  Close;
end;

end.
