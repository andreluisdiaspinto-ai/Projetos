unit RelatorioVendaClienteGrade;

{ Relatorio de Venda por Cliente em formato de Grade (Cross-tab).

  Consulta agregada com um unico join:

    VENDA  +  CLIENTE

  Uma linha por (Cliente x Dia), somando os totais das vendas:

    select vc.CODIGO_CLIENTE, cli.NOME,
           cast(vc.DATA_HORA_VENDA as date) as DATA,
           coalesce(sum(vc.TOTAL_BRUTO),0)   as TOTAL_BRUTO,
           coalesce(sum(vc.TOTAL_LIQUIDO),0) as TOTAL_VENDA
      from VENDA vc
      inner join CLIENTE cli on cli.CODIGO = vc.CODIGO_CLIENTE
     group by vc.CODIGO_CLIENTE, cli.NOME, cast(vc.DATA_HORA_VENDA as date)

  Impressao com aspecto de planilha eletronica via Cross-tab do FastReport
  (TfrxDBCrossView):
    - Linha (vertical)   : DATA da venda;
    - Coluna (horizontal): NOME do cliente;
    - Celula             : Total Bruto e Total Liquido (empilhados),
                           totalizados por linha, coluna e geral.

  Filtros disponiveis (mesmos do relatorio sintetico):
    1 - Situacao da venda: Todas (padrao), Abertas ou Fechadas;
    2 - Faixa de codigo da venda (inicial/final);
    3 - Faixa de data da venda (inicial/final), dd/mm/yyyy;
    4 - Cliente: por codigo ou por nome (com lupa abrindo ConsultaCliente).

  O layout FastReport fica guardado na tabela RELATORIO (campo BLOB ARQUIVO)
  e tambem em disco (Fr3\RelatorioVendaClienteGrade.fr3). O cabecalho, o
  rodape e o grafico de pizza (total liquido por cliente) seguem o mesmo
  padrao do restante do sistema. }

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls,
  Vcl.Grids, Vcl.DBGrids,
  Data.DB, IBX.IBQuery, IBX.IBCustomDataSet,
  frxClass, frxDBSet, frxChart, frxCross,
  frxExportPDF, frxExportXML, frxExportRTF,
  frxExportCSV, frxExportBaseDialog;

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
  ICN_LUPA     = #$E721; // Search

  // Layout FastReport guardado na tabela RELATORIO (campo BLOB ARQUIVO).
  NOME_RELATORIO_VENDA_CLIENTE = 'Relatorio_Venda_Cliente_Grade';
  ARQUIVO_FR3                    = 'RelatorioVendaClienteGrade.fr3';
  PASTA_FR3          = 'C:\Avaliacao Delphi_Firebird\Andre_luis\Projeto\Fr3';
  PASTA_FR3_RELATIVA = 'Fr3';

type
  TForm_RelatorioVendaClienteGrade = class(TForm)
    Panel_Titulo: TPanel;

    PanelFiltros: TPanel;
    RadioGrupoOrdem: TRadioGroup;
    RadioGrupoSituacao: TRadioGroup;
    LabelCodigoDe: TLabel;
    EditCodigoDe: TEdit;
    LabelCodigoAte: TLabel;
    EditCodigoAte: TEdit;
    LabelDataDe: TLabel;
    EditDataDe: TEdit;
    LabelDataAte: TLabel;
    EditDataAte: TEdit;
    LabelCodigoCliente: TLabel;
    EditCodigoCliente: TEdit;
    EditNomeCliente: TEdit;
    BtnLupaCliente: TBitBtn;
    LabelProgresso: TLabel;
    ProgressBarPesquisa: TProgressBar;

    DBGridVendaCliente: TDBGrid;

    PanelRodape: TPanel;
    BtnPesquisar: TBitBtn;
    BtnLimpar: TBitBtn;
    BtnImprimir: TBitBtn;
    BtnSair: TBitBtn;

    QueryVendaCliente: TIBQuery;
    DsVendaCliente: TDataSource;
    frxDBDatasetVendaCliente: TfrxDBDataset;
    QueryGraficoPorCliente: TIBQuery;
    frxDBDatasetGraficoPorCliente: TfrxDBDataset;
    frxReportVendaCliente: TfrxReport;
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
    procedure DBGridVendaClienteDrawColumnCell(Sender: TObject;
      const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);
    procedure BtnLupaClienteClick(Sender: TObject);
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
    procedure AtualizarProgresso(APercentual: Integer);
    function LocalizarArquivoFr3: string;
    procedure GravarRelatorioNoBanco(const ANome, ACaminhoArquivo: string);
    procedure GravarRelatorioEmbutidoNoBanco(const ANome: string);
    function CarregarRelatorioDoBanco(const ANome: string;
      AStream: TStream): Boolean;
    procedure SincronizarLayoutFr3NoBanco;
    function DescricaoFiltros: string;
    procedure AplicarCabecalhoRelatorio;
    procedure ConfigurarGraficoPizzaPorCliente;
    procedure ExibirRelatorio;
  public
    { Public declarations }
  end;

var
  Form_RelatorioVendaClienteGrade: TForm_RelatorioVendaClienteGrade;

implementation

uses DataModule, Mensagens, ConsultaCliente,
  RelatorioExportacaoFast, UITheme;

{$R *.dfm}

{ Utilitarios visuais }

procedure TForm_RelatorioVendaClienteGrade.ConfigurarGlyphsBotoes;
begin
  AplicarBotaoBootstrap(BtnPesquisar, bbkOutline, ICN_PESQUISA);
  AplicarBotaoBootstrap(BtnLimpar, bbkOutline, ICN_LIMPAR);
  AplicarBotaoBootstrap(BtnImprimir, bbkPrimary, ICN_IMPRIMIR);
  AplicarBotaoBootstrap(BtnSair, bbkSecondary, ICN_SAIR);
  AplicarBotaoBootstrap(BtnLupaCliente, bbkOutline, ICN_LUPA);
end;

{ Ciclo de vida }

procedure TForm_RelatorioVendaClienteGrade.FormCreate(Sender: TObject);
var
  lCaminhoFr3: string;
begin
  Color := COR_PAGE;
  AplicarHeaderPrimary(Panel_Titulo);
  AplicarFormEstiloWeb(Self);
  AplicarPainelCard(PanelFiltros);
  ConfigurarGlyphsBotoes;
  TRelatorioExportacaoFast.VincularExportacoes(frxReportVendaCliente,
    frxExportPDF, frxExportExcel, frxExportWord, frxExportCSV);

  // Atualiza a tabela RELATORIO com o .fr3 + titulo + grafico.
  lCaminhoFr3 := LocalizarArquivoFr3;
  if lCaminhoFr3 <> '' then
  begin
    frxReportVendaCliente.LoadFromFile(lCaminhoFr3);
    AplicarCabecalhoRelatorio;
    ConfigurarGraficoPizzaPorCliente;
    GravarRelatorioEmbutidoNoBanco(NOME_RELATORIO_VENDA_CLIENTE);
  end
  else
    SincronizarLayoutFr3NoBanco;

  // Abre listando todas as vendas agregadas por cliente/dia.
  Pesquisar;
end;

procedure TForm_RelatorioVendaClienteGrade.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  QueryVendaCliente.Close;
  QueryGraficoPorCliente.Close;
  Action := caFree;
  Form_RelatorioVendaClienteGrade := nil;
end;

{ Navegacao por teclado }

procedure TForm_RelatorioVendaClienteGrade.FormKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    Key := 0;
    Close;
  end
  else if (Key = VK_RETURN) and not (ActiveControl is TCustomButton) then
  begin
    Key := 0;
    if ActiveControl is TCustomDBGrid then
      Exit;
    if ActiveControl = EditNomeCliente then
      BtnPesquisar.Click
    else
      SelectNext(ActiveControl, True, True);
  end;
end;

{ Cores de foco }

procedure TForm_RelatorioVendaClienteGrade.EditFocoEnter(Sender: TObject);
begin
  if Sender is TEdit then
    TEdit(Sender).Color := COR_EDIT_FOCO;
end;

procedure TForm_RelatorioVendaClienteGrade.EditFocoExit(Sender: TObject);
begin
  if Sender is TEdit then
    TEdit(Sender).Color := COR_EDIT_NORMAL;
end;

procedure TForm_RelatorioVendaClienteGrade.EditNumericoKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not CharInSet(Key, ['0'..'9', #8]) then
    Key := #0;
end;

procedure TForm_RelatorioVendaClienteGrade.EditDataKeyPress(Sender: TObject;
  var Key: Char);
var
  lEdit: TEdit;
begin
  if not CharInSet(Key, ['0'..'9', '/', #8]) then
  begin
    Key := #0;
    Exit;
  end;

  if CharInSet(Key, ['0'..'9']) and (Sender is TEdit) then
  begin
    lEdit := TEdit(Sender);
    if ((Length(lEdit.Text) = 2) or (Length(lEdit.Text) = 5)) and
       (lEdit.SelLength = 0) and (lEdit.SelStart = Length(lEdit.Text)) then
    begin
      lEdit.Text := lEdit.Text + '/';
      lEdit.SelStart := Length(lEdit.Text);
    end;
  end;
end;

{ Grid - linhas com cores alternadas (zebra) }

procedure TForm_RelatorioVendaClienteGrade.DBGridVendaClienteDrawColumnCell(
  Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
var
  lGrid: TDBGrid;
begin
  lGrid := TDBGrid(Sender);

  if not (gdSelected in State) then
  begin
    if Odd(lGrid.DataSource.DataSet.RecNo) then
      lGrid.Canvas.Brush.Color := COR_GRID_LINHA_IMPAR
    else
      lGrid.Canvas.Brush.Color := COR_GRID_LINHA_PAR;
    lGrid.Canvas.Font.Color := COR_GRID_TEXTO;
  end;

  lGrid.DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;

{ Lookup Cliente (reaproveitando o form de consulta) }

procedure TForm_RelatorioVendaClienteGrade.BtnLupaClienteClick(Sender: TObject);
var
  lCodigo: Integer;
  lNome: string;
begin
  if TForm_ConsultaCliente.Selecionar(lCodigo, lNome) then
  begin
    EditCodigoCliente.Text := IntToStr(lCodigo);
    EditNomeCliente.Text   := lNome;
  end;
end;

{ Pesquisa }

function TForm_RelatorioVendaClienteGrade.ValidarFaixaCodigo(out ACodigoDe,
  ACodigoAte: Integer; out ATemDe, ATemAte: Boolean): Boolean;
begin
  Result  := True;
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

function TForm_RelatorioVendaClienteGrade.ValidarFaixaData(out ADataDe,
  ADataAte: TDateTime; out ATemDataDe, ATemDataAte: Boolean): Boolean;
var
  lFmt: TFormatSettings;

  function ConverterData(AEdit: TEdit; out AValor: TDateTime;
    out ATem: Boolean): Boolean;
  begin
    Result := True;
    ATem   := False;
    AValor := 0;
    if Trim(AEdit.Text) = '' then
      Exit;

    ATem := TryStrToDate(Trim(AEdit.Text), AValor, lFmt);
    if not ATem then
    begin
      MensagemDlg('Data invalida: "' + Trim(AEdit.Text) + '". Informe a ' +
        'data no formato dd/mm/yyyy.', mtWarning, [mbOK], 0);
      if AEdit.CanFocus then
        AEdit.SetFocus;
      Result := False;
    end;
  end;

begin
  lFmt := TFormatSettings.Create;
  lFmt.DateSeparator   := '/';
  lFmt.ShortDateFormat := 'dd/mm/yyyy';

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

procedure TForm_RelatorioVendaClienteGrade.AjustarFormatoCampos;

  procedure Formatar(const ANomeCampo, AFormato: string);
  var
    lFld: TField;
  begin
    lFld := QueryVendaCliente.FindField(ANomeCampo);
    if lFld is TBCDField then
      TBCDField(lFld).DisplayFormat := AFormato
    else if lFld is TFMTBCDField then
      TFMTBCDField(lFld).DisplayFormat := AFormato
    else if lFld is TFloatField then
      TFloatField(lFld).DisplayFormat := AFormato
    else if lFld is TIntegerField then
      TIntegerField(lFld).DisplayFormat := AFormato
    else if lFld is TDateTimeField then
      TDateTimeField(lFld).DisplayFormat := AFormato
    else if lFld is TDateField then
      TDateField(lFld).DisplayFormat := AFormato;
  end;

begin
  Formatar('CODIGO_CLIENTE',    '00000');
  Formatar('DATA',              'dd/mm/yyyy');
  Formatar('TOTAL_BRUTO',       '#,##0.00');
  Formatar('TOTAL_VENDA',       '#,##0.00');
end;

procedure TForm_RelatorioVendaClienteGrade.AtualizarProgresso(APercentual: Integer);
begin
  ProgressBarPesquisa.Position := APercentual;
  LabelProgresso.Caption := Format('Executando pesquisa: %d%%', [APercentual]);
  ProgressBarPesquisa.Update;
  LabelProgresso.Update;
end;

procedure TForm_RelatorioVendaClienteGrade.Pesquisar;
var
  lWhere, lGroup, lSql: string;
  lCodigoDe, lCodigoAte: Integer;
  lTemDe, lTemAte: Boolean;
  lDataDe, lDataAte: TDateTime;
  lTemDataDe, lTemDataAte: Boolean;
  lCodigoCliente: Integer;
  lTemCodCliente, lTemNomeCliente: Boolean;
  lSituacao: string;
  lQueryContagem: TIBQuery;
  lTotal, lLidos, lPasso: Integer;

  procedure PreencherParametros(AQuery: TIBQuery);
  begin
    if lTemDe then
      AQuery.ParamByName('PCODIGO_DE').AsInteger := lCodigoDe;
    if lTemAte then
      AQuery.ParamByName('PCODIGO_ATE').AsInteger := lCodigoAte;
    if lTemDataDe then
      AQuery.ParamByName('PDATA_DE').AsDateTime := lDataDe;
    if lTemDataAte then
      AQuery.ParamByName('PDATA_ATE').AsDateTime := lDataAte + 1;
    if lSituacao <> '' then
      AQuery.ParamByName('PSITUACAO').AsString := lSituacao;
    if lTemCodCliente then
      AQuery.ParamByName('PCODIGO_CLIENTE').AsInteger := lCodigoCliente
    else if lTemNomeCliente then
      AQuery.ParamByName('PNOME_CLIENTE').AsString :=
        Trim(EditNomeCliente.Text) + '%';
  end;

begin
  if not ValidarFaixaCodigo(lCodigoDe, lCodigoAte, lTemDe, lTemAte) then
    Exit;
  if not ValidarFaixaData(lDataDe, lDataAte, lTemDataDe, lTemDataAte) then
    Exit;

  lTemCodCliente  := TryStrToInt(Trim(EditCodigoCliente.Text), lCodigoCliente);
  lTemNomeCliente := (not lTemCodCliente) and (Trim(EditNomeCliente.Text) <> '');

  case RadioGrupoSituacao.ItemIndex of
    1: lSituacao := 'A';
    2: lSituacao := 'F';
  else
    lSituacao := '';
  end;

  AtualizarProgresso(0);

  // FROM/JOIN/WHERE reutilizado pela contagem e pela consulta principal.
  lWhere :=
    ' from VENDA vc' +
    '  inner join CLIENTE cli    on cli.CODIGO = vc.CODIGO_CLIENTE' +
    ' where 1 = 1';
  if lTemDe then
    lWhere := lWhere + ' and vc.CODIGO >= :PCODIGO_DE';
  if lTemAte then
    lWhere := lWhere + ' and vc.CODIGO <= :PCODIGO_ATE';
  if lTemDataDe then
    lWhere := lWhere + ' and vc.DATA_HORA_VENDA >= :PDATA_DE';
  if lTemDataAte then
    lWhere := lWhere + ' and vc.DATA_HORA_VENDA <  :PDATA_ATE';
  if lSituacao <> '' then
    lWhere := lWhere + ' and vc.SITUACAO = :PSITUACAO';
  if lTemCodCliente then
    lWhere := lWhere + ' and vc.CODIGO_CLIENTE = :PCODIGO_CLIENTE'
  else if lTemNomeCliente then
    lWhere := lWhere + ' and upper(cli.NOME) like upper(:PNOME_CLIENTE)';

  lGroup :=
    ' group by vc.CODIGO_CLIENTE, cli.NOME, cast(vc.DATA_HORA_VENDA as date)';

  // Consulta agregada por Cliente x Dia (base do Cross-tab).
  lSql :=
    'select' +
    '  vc.CODIGO_CLIENTE,' +
    '  cli.NOME as NOME,' +
    '  cast(vc.DATA_HORA_VENDA as date) as DATA,' +
    '  coalesce(sum(vc.TOTAL_BRUTO),0) as TOTAL_BRUTO,' +
    '  coalesce(sum(vc.TOTAL_LIQUIDO),0) as TOTAL_VENDA' +
    lWhere +
    lGroup +
    ' order by cast(vc.DATA_HORA_VENDA as date), cli.NOME';

  // Total de grupos (Cliente x Dia): base do calculo do percentual.
  lQueryContagem := TIBQuery.Create(nil);
  try
    lQueryContagem.Database    := QueryVendaCliente.Database;
    lQueryContagem.Transaction := QueryVendaCliente.Transaction;
    lQueryContagem.SQL.Text    :=
      'select count(*) from (' +
      '  select vc.CODIGO_CLIENTE, cast(vc.DATA_HORA_VENDA as date) as DATA' +
      lWhere +
      lGroup +
      ') x';
    PreencherParametros(lQueryContagem);
    lQueryContagem.Open;
    lTotal := lQueryContagem.Fields[0].AsInteger;
    lQueryContagem.Close;
  finally
    lQueryContagem.Free;
  end;
  AtualizarProgresso(15);

  QueryVendaCliente.DisableControls;
  try
    QueryVendaCliente.Close;
    QueryVendaCliente.SQL.Text := lSql;
    PreencherParametros(QueryVendaCliente);
    QueryVendaCliente.Open;
    AjustarFormatoCampos;
    AtualizarProgresso(25);

    // Dataset agregado por cliente (mesmos filtros) para o grafico de pizza.
    QueryGraficoPorCliente.Close;
    QueryGraficoPorCliente.SQL.Text :=
      'with G as (' +
      '  select' +
      '    cli.CODIGO as CODIGO_CLIENTE,' +
      '    cli.NOME as NOME_CLIENTE,' +
      '    sum(vc.TOTAL_LIQUIDO) as TOTAL_CLIENTE' +
      lWhere +
      '  group by cli.CODIGO, cli.NOME)' +
      'select' +
      '  g.CODIGO_CLIENTE,' +
      '  g.NOME_CLIENTE,' +
      '  g.TOTAL_CLIENTE,' +
      '  g.NOME_CLIENTE || '' ('' ||' +
      '    replace(cast(cast(' +
      '      case' +
      '        when (select coalesce(sum(t.TOTAL_CLIENTE), 0) from G t) = 0' +
      '          then 0' +
      '        else g.TOTAL_CLIENTE * 100.00 /' +
      '             (select sum(t.TOTAL_CLIENTE) from G t)' +
      '      end as numeric(15,1)) as varchar(20)), ''.'', '','') ||' +
      '    ''%)'' as LEGENDA_CLIENTE' +
      ' from G g' +
      ' order by g.NOME_CLIENTE';
    PreencherParametros(QueryGraficoPorCliente);
    QueryGraficoPorCliente.Open;
    AtualizarProgresso(30);

    if lTotal > 0 then
    begin
      lLidos := 0;
      lPasso := lTotal div 20;
      if lPasso < 1 then
        lPasso := 1;
      while not QueryVendaCliente.Eof do
      begin
        Inc(lLidos);
        if (lLidos mod lPasso) = 0 then
          AtualizarProgresso(30 + (lLidos * 65 div lTotal));
        QueryVendaCliente.Next;
      end;
      QueryVendaCliente.First;
    end;

    AtualizarProgresso(100);
    LabelProgresso.Caption := Format('Pesquisa concluida: %d linha(s)',
      [lTotal]);
  finally
    QueryVendaCliente.EnableControls;
  end;
end;

procedure TForm_RelatorioVendaClienteGrade.BtnPesquisarClick(Sender: TObject);
begin
  Pesquisar;

  if QueryVendaCliente.Active and QueryVendaCliente.IsEmpty then
    MensagemDlg('Nenhuma venda encontrada para os filtros informados.',
      mtInformation, [mbOK], 0);
end;

procedure TForm_RelatorioVendaClienteGrade.BtnLimparClick(Sender: TObject);
begin
  EditCodigoDe.Clear;
  EditCodigoAte.Clear;
  EditDataDe.Clear;
  EditDataAte.Clear;
  EditCodigoCliente.Clear;
  EditNomeCliente.Clear;
  RadioGrupoOrdem.ItemIndex    := 0;
  RadioGrupoSituacao.ItemIndex := 0;

  BtnPesquisar.Click;

  ProgressBarPesquisa.Position := 0;
  LabelProgresso.Caption := '';

  if EditCodigoDe.CanFocus then
    EditCodigoDe.SetFocus;
end;

{ Impressao - layout FastReport na tabela RELATORIO com fallback embutido }

function TForm_RelatorioVendaClienteGrade.LocalizarArquivoFr3: string;
var
  lPastaExe: string;
  lBases: array of string;
  lI: Integer;
  lTentativa: string;
begin
  Result   := '';
  lPastaExe := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName));

  lBases := [
    IncludeTrailingPathDelimiter(PASTA_FR3),
    lPastaExe + PASTA_FR3_RELATIVA + PathDelim,
    lPastaExe,
    lPastaExe + '..' + PathDelim + PASTA_FR3_RELATIVA + PathDelim,
    lPastaExe + '..' + PathDelim + '..' + PathDelim + PASTA_FR3_RELATIVA + PathDelim
  ];

  for lI := Low(lBases) to High(lBases) do
  begin
    lTentativa := lBases[lI] + ARQUIVO_FR3;
    if FileExists(lTentativa) then
      Exit(lTentativa);
  end;
end;

procedure TForm_RelatorioVendaClienteGrade.GravarRelatorioNoBanco(const ANome,
  ACaminhoArquivo: string);
var
  lQuery: TIBQuery;
  lStream: TFileStream;
begin
  lStream := TFileStream.Create(ACaminhoArquivo,
    fmOpenRead or fmShareDenyWrite);
  try
    lQuery := TIBQuery.Create(nil);
    try
      lQuery.Database    := QueryVendaCliente.Database;
      lQuery.Transaction := QueryVendaCliente.Transaction;
      lQuery.SQL.Text :=
        'update or insert into RELATORIO ' +
        '  (NOME, DESCRICAO, ARQUIVO, DATA_ALTERACAO) ' +
        'values ' +
        '  (:PNOME, :PDESCRICAO, :PARQUIVO, CURRENT_TIMESTAMP) ' +
        'matching (NOME)';
      lQuery.ParamByName('PNOME').AsString      := ANome;
      lQuery.ParamByName('PDESCRICAO').AsString :=
        'Relatorio de Venda por Cliente em Grade (Cross-tab)';
      lQuery.ParamByName('PARQUIVO').LoadFromStream(lStream, ftBlob);
      lQuery.ExecSQL;
      Dm.IBTransaction1.CommitRetaining;
    finally
      lQuery.Free;
    end;
  finally
    lStream.Free;
  end;
end;

procedure TForm_RelatorioVendaClienteGrade.GravarRelatorioEmbutidoNoBanco(
  const ANome: string);
var
  lQuery: TIBQuery;
  lStream: TMemoryStream;
begin
  lStream := TMemoryStream.Create;
  try
    frxReportVendaCliente.SaveToStream(lStream);
    lStream.Position := 0;

    lQuery := TIBQuery.Create(nil);
    try
      lQuery.Database    := QueryVendaCliente.Database;
      lQuery.Transaction := QueryVendaCliente.Transaction;
      lQuery.SQL.Text :=
        'update or insert into RELATORIO ' +
        '  (NOME, DESCRICAO, ARQUIVO, DATA_ALTERACAO) ' +
        'values ' +
        '  (:PNOME, :PDESCRICAO, :PARQUIVO, CURRENT_TIMESTAMP) ' +
        'matching (NOME)';
      lQuery.ParamByName('PNOME').AsString      := ANome;
      lQuery.ParamByName('PDESCRICAO').AsString :=
        'Relatorio de Venda por Cliente em Grade (Cross-tab)';
      lQuery.ParamByName('PARQUIVO').LoadFromStream(lStream, ftBlob);
      lQuery.ExecSQL;
      Dm.IBTransaction1.CommitRetaining;
    finally
      lQuery.Free;
    end;
  finally
    lStream.Free;
  end;
end;

procedure TForm_RelatorioVendaClienteGrade.SincronizarLayoutFr3NoBanco;
var
  lCaminhoFr3: string;
begin
  lCaminhoFr3 := LocalizarArquivoFr3;
  if lCaminhoFr3 = '' then
    Exit;

  GravarRelatorioNoBanco(NOME_RELATORIO_VENDA_CLIENTE, lCaminhoFr3);
end;

function TForm_RelatorioVendaClienteGrade.CarregarRelatorioDoBanco(
  const ANome: string; AStream: TStream): Boolean;
var
  lQuery: TIBQuery;
begin
  lQuery := TIBQuery.Create(nil);
  try
    lQuery.Database    := QueryVendaCliente.Database;
    lQuery.Transaction := QueryVendaCliente.Transaction;
    lQuery.SQL.Text :=
      'select ARQUIVO from RELATORIO where NOME = :PNOME';
    lQuery.ParamByName('PNOME').AsString := ANome;
    lQuery.Open;

    Result := not (lQuery.IsEmpty or lQuery.FieldByName('ARQUIVO').IsNull);
    if Result then
    begin
      TBlobField(lQuery.FieldByName('ARQUIVO')).SaveToStream(AStream);
      AStream.Position := 0;
    end;
    lQuery.Close;
  finally
    lQuery.Free;
  end;
end;

function TForm_RelatorioVendaClienteGrade.DescricaoFiltros: string;

  procedure Acrescentar(const ATexto: string);
  begin
    if Result <> '' then
      Result := Result + '  |  ';
    Result := Result + ATexto;
  end;

begin
  Result := '';

  Acrescentar('Grade: Data (linha) x Cliente (coluna)');

  case RadioGrupoSituacao.ItemIndex of
    1: Acrescentar('Situacao: Abertas');
    2: Acrescentar('Situacao: Fechadas');
  else
    Acrescentar('Situacao: Todas');
  end;

  if Trim(EditCodigoDe.Text) <> '' then
    Acrescentar('Codigo de: ' + Trim(EditCodigoDe.Text));
  if Trim(EditCodigoAte.Text) <> '' then
    Acrescentar('Codigo ate: ' + Trim(EditCodigoAte.Text));
  if Trim(EditDataDe.Text) <> '' then
    Acrescentar('Data de: ' + Trim(EditDataDe.Text));
  if Trim(EditDataAte.Text) <> '' then
    Acrescentar('Data ate: ' + Trim(EditDataAte.Text));
  if Trim(EditCodigoCliente.Text) <> '' then
    Acrescentar('Cliente cod.: ' + Trim(EditCodigoCliente.Text))
  else if Trim(EditNomeCliente.Text) <> '' then
    Acrescentar('Cliente: ' + Trim(EditNomeCliente.Text));

  if Result = '' then
    Result := 'Todos os registros';
end;

procedure TForm_RelatorioVendaClienteGrade.AplicarCabecalhoRelatorio;
var
  lMemo: TfrxMemoView;
  lTitle: TfrxBand;
  lI: Integer;

  function GarantirMemo(const ANome: string; ALeft, ATop, AWidth,
    AHeight: Extended): TfrxMemoView;
  begin
    Result := frxReportVendaCliente.FindObject(ANome) as TfrxMemoView;
    if Assigned(Result) then
      Exit;
    if not Assigned(lTitle) then
      Exit;
    Result := TfrxMemoView.Create(lTitle);
    Result.Name := ANome;
    Result.Left := ALeft;
    Result.Top := ATop;
    Result.Width := AWidth;
    Result.Height := AHeight;
    Result.Font.Name := 'Arial';
    Result.Font.Height := -11;
    Result.ParentFont := False;
    Result.WordWrap := False;
  end;

  procedure PosicionarCabecalho(const ANome: string; ALeft, ATop,
    AWidth: Extended; const ATexto: string; AAlinharDireita: Boolean);
  begin
    lMemo := GarantirMemo(ANome, ALeft, ATop, AWidth, 18.89765);
    if not Assigned(lMemo) then
      Exit;
    lMemo.Visible := True;
    lMemo.Left := ALeft;
    lMemo.Top := ATop;
    lMemo.Width := AWidth;
    if AAlinharDireita then
      lMemo.HAlign := haRight
    else
      lMemo.HAlign := haLeft;
    if ATexto <> '' then
      lMemo.Text := ATexto;
  end;

const
  MEMOS_CABECALHO_LEGADO: array[0..6] of string = (
    'MemoData', 'MemoHora', 'MemoDataEmis', 'Date', 'Time', 'Page', 'TotalPages');
begin
  lTitle := frxReportVendaCliente.FindObject('ReportTitle1') as TfrxBand;

  for lI := Low(MEMOS_CABECALHO_LEGADO) to High(MEMOS_CABECALHO_LEGADO) do
  begin
    lMemo := frxReportVendaCliente.FindObject(MEMOS_CABECALHO_LEGADO[lI])
      as TfrxMemoView;
    if Assigned(lMemo) then
      lMemo.Visible := False;
  end;

  PosicionarCabecalho('MemoDataLabel',   560, 3.77953,  55, 'Data....:', False);
  PosicionarCabecalho('MemoDataValor',   618, 3.77953,  95, '[Date]', True);
  PosicionarCabecalho('MemoHoraLabel',   560, 22.67718, 55, 'Hora....:', False);
  PosicionarCabecalho('MemoHoraValor',   618, 22.67718, 95, '[Time]', True);
  PosicionarCabecalho('MemoPaginaLabel', 560, 41.57483, 55, 'P'#225'gina.:', False);
  PosicionarCabecalho('MemoPaginaValor', 618, 41.57483, 95,
    '[Page#]/[TotalPages#]', True);

  lMemo := frxReportVendaCliente.FindObject('MemoDataValor') as TfrxMemoView;
  if Assigned(lMemo) then
  begin
    lMemo.DisplayFormat.Kind := fkDateTime;
    lMemo.DisplayFormat.FormatStr := 'dd/mm/yyyy';
  end;

  lMemo := frxReportVendaCliente.FindObject('MemoHoraValor') as TfrxMemoView;
  if Assigned(lMemo) then
  begin
    lMemo.DisplayFormat.Kind := fkDateTime;
    lMemo.DisplayFormat.FormatStr := 'hh:mm:ss';
  end;

  lMemo := frxReportVendaCliente.FindObject('MemoFiltroValor') as TfrxMemoView;
  if Assigned(lMemo) then
  begin
    lMemo.Width := 500;
    lMemo.Text := DescricaoFiltros;
  end;

  lMemo := frxReportVendaCliente.FindObject('MemoTituloRelatorio') as TfrxMemoView;
  if Assigned(lMemo) then
  begin
    lMemo.Left := 160;
    lMemo.Width := 390;
    lMemo.HAlign := haCenter;
    lMemo.WordWrap := False;
    lMemo.Text := 'Relat'#243'rio de Venda Cliente (Grade)';
  end;
end;

procedure TForm_RelatorioVendaClienteGrade.ConfigurarGraficoPizzaPorCliente;
var
  lChart: TfrxChartView;
  lSerie: TfrxSeriesItem;
  lBand: TfrxBand;
  lMemo: TfrxMemoView;
begin
  if frxReportVendaCliente.DataSets.Find(frxDBDatasetGraficoPorCliente) = nil then
    frxReportVendaCliente.DataSets.Add(frxDBDatasetGraficoPorCliente);

  lMemo := frxReportVendaCliente.FindObject('MemoTituloGrafico') as TfrxMemoView;
  if Assigned(lMemo) then
    lMemo.Text := 'Grafico de pizza - total liquido por cliente';

  lChart := frxReportVendaCliente.FindObject('ChartPizzaPorCliente') as TfrxChartView;
  if not Assigned(lChart) then
    lChart := frxReportVendaCliente.FindObject('ChartBarrasPorCliente') as TfrxChartView;
  if not Assigned(lChart) then
  begin
    lBand := frxReportVendaCliente.FindObject('ReportSummary1') as TfrxBand;
    if not Assigned(lBand) then
      Exit;

    lBand.Height := 380;
    lChart := TfrxChartView.Create(lBand);
    lChart.Name := 'ChartPizzaPorCliente';
    lChart.Left := 3.77953;
    lChart.Top := 94;
    lChart.Width := 710;
    lChart.Height := 280;
  end
  else
  begin
    lChart.Name := 'ChartPizzaPorCliente';
    if lChart.Height < 280 then
      lChart.Height := 280;
  end;

  lChart.ClearSeries;
  lChart.AddSeries(csPie);
  if lChart.SeriesData.Count = 0 then
    Exit;

  lSerie := lChart.SeriesData[0];
  lSerie.DataType := dtDBData;
  lSerie.DataSet := frxDBDatasetGraficoPorCliente;
  lSerie.DataSetName := 'frxDBDatasetGraficoPorCliente';
  lSerie.XType := xtText;
  lSerie.Source1 := '<frxDBDatasetGraficoPorCliente."LEGENDA_CLIENTE">';
  lSerie.Source2 := '<frxDBDatasetGraficoPorCliente."TOTAL_CLIENTE">';

  if Assigned(lChart.Chart) then
  begin
    lChart.Chart.Title.Text.Text := 'Total liquido por cliente';
    lChart.Chart.Title.Visible := True;
    lChart.Chart.View3D := False;
    lChart.Chart.Legend.Visible := True;
    lChart.Chart.Legend.Font.Name := 'Arial';
    lChart.Chart.Legend.Font.Size := 6;
    if lChart.Chart.SeriesCount > 0 then
    begin
      lChart.Chart.Series[0].Title := 'Total liquido';
      lChart.Chart.Series[0].ColorEachPoint := True;
      lChart.Chart.Series[0].Marks.Visible := True;
      lChart.Chart.Series[0].Marks.Transparent := True;
      lChart.Chart.Series[0].Marks.Font.Name := 'Arial';
      lChart.Chart.Series[0].Marks.Font.Size := 5;
    end;
  end;
end;

procedure TForm_RelatorioVendaClienteGrade.ExibirRelatorio;
var
  lStream: TMemoryStream;
  lCaminhoFr3: string;
begin
  frxReportVendaCliente.EngineOptions.DoublePass := True;

  lStream := TMemoryStream.Create;
  try
    lCaminhoFr3 := LocalizarArquivoFr3;
    if lCaminhoFr3 <> '' then
    begin
      frxReportVendaCliente.LoadFromFile(lCaminhoFr3);
      GravarRelatorioNoBanco(NOME_RELATORIO_VENDA_CLIENTE, lCaminhoFr3);
    end
    else if CarregarRelatorioDoBanco(NOME_RELATORIO_VENDA_CLIENTE, lStream) then
      frxReportVendaCliente.LoadFromStream(lStream)
    else
    begin
      MensagemDlg('Nao foi possivel carregar o relatorio "' +
        NOME_RELATORIO_VENDA_CLIENTE +
        '" (arquivo .fr3 e tabela RELATORIO).',
        mtError, [mbOK], 0);
      Exit;
    end;

    AplicarCabecalhoRelatorio;
    ConfigurarGraficoPizzaPorCliente;
    GravarRelatorioEmbutidoNoBanco(NOME_RELATORIO_VENDA_CLIENTE);
    TRelatorioExportacaoFast.VincularExportacoes(frxReportVendaCliente,
      frxExportPDF, frxExportExcel, frxExportWord, frxExportCSV);
    frxReportVendaCliente.ShowReport;
  finally
    lStream.Free;
  end;
end;

procedure TForm_RelatorioVendaClienteGrade.BtnImprimirClick(Sender: TObject);
begin
  if not QueryVendaCliente.Active or QueryVendaCliente.IsEmpty then
  begin
    MensagemDlg('Nao ha vendas para imprimir. Utilize o botao ' +
      'Pesquisar primeiro.', mtInformation, [mbOK], 0);
    Exit;
  end;

  try
    ExibirRelatorio;
  except
    on E: Exception do
      MensagemDlg('Erro ao abrir o relatorio.' + sLineBreak + E.Message,
        mtError, [mbOK], 0);
  end;
end;

procedure TForm_RelatorioVendaClienteGrade.BtnSairClick(Sender: TObject);
begin
  Close;
end;

end.
