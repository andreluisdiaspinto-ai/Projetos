unit RelatorioTabelaPrecos;

{ Filtro para Relatorio de Tabela de Precos (mesmas regras do RelatorioProduto).

  Campos: CODIGO, CODIGO_BARRAS, DESCRICAO, PRECO_VENDA. }

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls,
  Vcl.Grids, Vcl.DBGrids,
  Data.DB, IBX.IBQuery, IBX.IBCustomDataSet,
  frxClass, frxDBSet, frxExportPDF, frxExportXML, frxExportRTF, frxExportCSV;

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
  NOME_RELATORIO_TABELA_PRECOS = 'RELATORIO_TABELA_PRECOS';
  ARQUIVO_FR3                  = 'Relatorio_Tabela_Precos.fr3';
  PASTA_FR3              = 'C:\Avaliacao Delphi_Firebird\Andre_luis\Projeto\Fr3';
  PASTA_FR3_RELATIVA     = 'Fr3';

type
  TForm_RelatorioTabelaPrecos = class(TForm)
    Panel_Titulo: TPanel;

    PanelFiltros: TPanel;
    RadioGrupoOrdem: TRadioGroup;
    LabelCodigoDe: TLabel;
    EditCodigoDe: TEdit;
    LabelCodigoAte: TLabel;
    EditCodigoAte: TEdit;
    LabelReferencia: TLabel;
    EditReferencia: TEdit;
    LabelMarca: TLabel;
    EditMarca: TEdit;
    LabelGrupo: TLabel;
    EditGrupo: TEdit;
    LabelProgresso: TLabel;
    ProgressBarPesquisa: TProgressBar;

    DBGridTabelaPrecos: TDBGrid;

    PanelRodape: TPanel;
    BtnPesquisar: TBitBtn;
    BtnLimpar: TBitBtn;
    BtnImprimir: TBitBtn;
    BtnSair: TBitBtn;

    QueryTabelaPrecos: TIBQuery;
    DsTabelaPrecos: TDataSource;
    frxDBDatasetTabelaPrecos: TfrxDBDataset;
    frxReportTabelaPrecos: TfrxReport;
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
    procedure DBGridTabelaPrecosDrawColumnCell(Sender: TObject;
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
    procedure Pesquisar;
    procedure AjustarFormatoCampos;
    procedure AtualizarProgresso(Percentual: Integer);
    procedure DestacarColunaOrdenacao;
    function LocalizarArquivoFr3: string;
    procedure GravarRelatorioEmbutidoNoBanco(const ANome: string);
    procedure SincronizarLayoutFr3NoBanco;
    procedure GravarRelatorioNoBanco(const ANome, ACaminhoArquivo: string);
    function CarregarRelatorioDoBanco(const ANome: string;
      Stream: TStream): Boolean;
    procedure ExibirRelatorio;
  public
    { Public declarations }
  end;

var
  Form_RelatorioTabelaPrecos: TForm_RelatorioTabelaPrecos;

implementation

uses DataModule, Mensagens, RelatorioExportacaoFast, UITheme;

{$R *.dfm}

{ Utilitarios visuais (mesmo padrao do RelatorioCliente) }

procedure TForm_RelatorioTabelaPrecos.ConfigurarGlyphsBotoes;
begin
  AplicarBotaoBootstrap(BtnPesquisar, bbkOutline, ICN_PESQUISA);
  AplicarBotaoBootstrap(BtnLimpar, bbkOutline, ICN_LIMPAR);
  AplicarBotaoBootstrap(BtnImprimir, bbkPrimary, ICN_IMPRIMIR);
  AplicarBotaoBootstrap(BtnSair, bbkSecondary, ICN_SAIR);
end;

{ Ciclo de vida }

procedure TForm_RelatorioTabelaPrecos.FormCreate(Sender: TObject);
var
  CaminhoFr3: string;
begin
  Color := COR_PAGE;
  AplicarHeaderPrimary(Panel_Titulo);
  AplicarFormEstiloWeb(Self);
  AplicarPainelCard(PanelFiltros);
  ConfigurarGlyphsBotoes;
  TRelatorioExportacaoFast.VincularExportacoes(frxReportTabelaPrecos, frxExportPDF,
    frxExportExcel, frxExportWord, frxExportCSV);

  CaminhoFr3 := LocalizarArquivoFr3;
  if CaminhoFr3 <> '' then
  begin
    frxReportTabelaPrecos.LoadFromFile(CaminhoFr3);
    GravarRelatorioEmbutidoNoBanco(NOME_RELATORIO_TABELA_PRECOS);
  end
  else
    SincronizarLayoutFr3NoBanco;

  Pesquisar;
end;

procedure TForm_RelatorioTabelaPrecos.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  QueryTabelaPrecos.Close;
  Action := caFree;
  Form_RelatorioTabelaPrecos := nil;
end;

{ Navegacao por teclado }

procedure TForm_RelatorioTabelaPrecos.FormKeyDown(Sender: TObject; var Key: Word;
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
    // ultimo campo (Grupo) esta focado, senao segue ao proximo campo.
    if ActiveControl is TCustomDBGrid then
      Exit;
    if ActiveControl = EditGrupo then
      BtnPesquisar.Click
    else
      SelectNext(ActiveControl, True, True);
  end;
end;

{ Cores de foco }

procedure TForm_RelatorioTabelaPrecos.EditFocoEnter(Sender: TObject);
begin
  if Sender is TEdit then
    TEdit(Sender).Color := COR_EDIT_FOCO;
end;

procedure TForm_RelatorioTabelaPrecos.EditFocoExit(Sender: TObject);
begin
  if Sender is TEdit then
    TEdit(Sender).Color := COR_EDIT_NORMAL;
end;

procedure TForm_RelatorioTabelaPrecos.EditNumericoKeyPress(Sender: TObject;
  var Key: Char);
begin
  // Faixa de codigo aceita apenas digitos (e backspace).
  if not CharInSet(Key, ['0'..'9', #8]) then
    Key := #0;
end;

{ Grid - linhas com cores alternadas (zebra) }

procedure TForm_RelatorioTabelaPrecos.DBGridTabelaPrecosDrawColumnCell(Sender: TObject;
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

function TForm_RelatorioTabelaPrecos.ValidarFaixaCodigo(out ACodigoDe,
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

procedure TForm_RelatorioTabelaPrecos.AjustarFormatoCampos;

  procedure Formatar(const NomeCampo, Formato: string);
  var
    Fld: TField;
  begin
    Fld := QueryTabelaPrecos.FindField(NomeCampo);
    if Fld is TBCDField then
      TBCDField(Fld).DisplayFormat := Formato
    else if Fld is TFloatField then
      TFloatField(Fld).DisplayFormat := Formato;
  end;

begin
  Formatar('PRECO_VENDA', '#,##0.00');
end;

procedure TForm_RelatorioTabelaPrecos.AtualizarProgresso(Percentual: Integer);
begin
  ProgressBarPesquisa.Position := Percentual;
  LabelProgresso.Caption := Format('Executando pesquisa: %d%%', [Percentual]);
  // Update forca o repaint imediato sem reentrar no loop de mensagens.
  ProgressBarPesquisa.Update;
  LabelProgresso.Update;
end;

procedure TForm_RelatorioTabelaPrecos.DestacarColunaOrdenacao;
var
  I: Integer;
  CampoOrdem: string;
begin
  // Campo de ordenacao escolhido no Filtro 1 (radio).
  if RadioGrupoOrdem.ItemIndex = 1 then
    CampoOrdem := 'CODIGO'
  else
    CampoOrdem := 'DESCRICAO';

  // Titulo da coluna ordenada em destaque (invertido: fundo navy, texto
  // branco); as demais voltam ao visual padrao.
  for I := 0 to DBGridTabelaPrecos.Columns.Count - 1 do
    if SameText(DBGridTabelaPrecos.Columns[I].FieldName, CampoOrdem) then
    begin
      DBGridTabelaPrecos.Columns[I].Title.Color      := COR_PRIMARY;
      DBGridTabelaPrecos.Columns[I].Title.Font.Color := clWhite;
    end
    else
    begin
      DBGridTabelaPrecos.Columns[I].Title.Color      := clBtnFace;
      DBGridTabelaPrecos.Columns[I].Title.Font.Color := COR_PRIMARY;
    end;
end;

procedure TForm_RelatorioTabelaPrecos.Pesquisar;
var
  Where, Sql: string;
  CodigoDe, CodigoAte: Integer;
  TemDe, TemAte: Boolean;
  QueryContagem: TIBQuery;
  Total, Lidos, Passo: Integer;

  procedure PreencherParametros(Query: TIBQuery);
  begin
    if TemDe then
      Query.ParamByName('PCODIGO_DE').AsInteger := CodigoDe;
    if TemAte then
      Query.ParamByName('PCODIGO_ATE').AsInteger := CodigoAte;
    if Trim(EditReferencia.Text) <> '' then
      Query.ParamByName('PREFERENCIA').AsString :=
        Trim(EditReferencia.Text) + '%';
    if Trim(EditMarca.Text) <> '' then
      Query.ParamByName('PMARCA').AsString := Trim(EditMarca.Text) + '%';
    if Trim(EditGrupo.Text) <> '' then
      Query.ParamByName('PGRUPO').AsString := Trim(EditGrupo.Text) + '%';
  end;

begin
  if not ValidarFaixaCodigo(CodigoDe, CodigoAte, TemDe, TemAte) then
    Exit;

  AtualizarProgresso(0);

  // Monta o WHERE somente com os filtros efetivamente preenchidos.
  Where := ' from PRODUTO where 1 = 1';
  if TemDe then
    Where := Where + ' and CODIGO >= :PCODIGO_DE';
  if TemAte then
    Where := Where + ' and CODIGO <= :PCODIGO_ATE';
  if Trim(EditReferencia.Text) <> '' then
    Where := Where + ' and UPPER(REFERENCIA) like UPPER(:PREFERENCIA)';
  if Trim(EditMarca.Text) <> '' then
    Where := Where + ' and UPPER(MARCA) like UPPER(:PMARCA)';
  if Trim(EditGrupo.Text) <> '' then
    Where := Where + ' and UPPER(GRUPO) like UPPER(:PGRUPO)';

  // Filtro 1: ordem alfabetica ou por codigo.
  Sql := 'select CODIGO, CODIGO_BARRAS, DESCRICAO, PRECO_VENDA' + Where;
  if RadioGrupoOrdem.ItemIndex = 1 then
    Sql := Sql + ' order by CODIGO'
  else
    Sql := Sql + ' order by DESCRICAO';

  // Total de registros esperados: base do calculo do percentual.
  Total := 0;
  QueryContagem := TIBQuery.Create(nil);
  try
    QueryContagem.Database    := QueryTabelaPrecos.Database;
    QueryContagem.Transaction := QueryTabelaPrecos.Transaction;
    QueryContagem.SQL.Text    := 'select count(*)' + Where;
    PreencherParametros(QueryContagem);
    QueryContagem.Open;
    Total := QueryContagem.Fields[0].AsInteger;
    QueryContagem.Close;
  finally
    QueryContagem.Free;
  end;
  AtualizarProgresso(15);

  QueryTabelaPrecos.DisableControls;
  try
    QueryTabelaPrecos.Close;
    QueryTabelaPrecos.SQL.Text := Sql;
    PreencherParametros(QueryTabelaPrecos);
    QueryTabelaPrecos.Open;
    AjustarFormatoCampos;
    AtualizarProgresso(25);

    // Percorre o resultado trazendo os registros do servidor e avancando
    // o percentual proporcionalmente a quantidade ja carregada.
    if Total > 0 then
    begin
      Lidos := 0;
      Passo := Total div 20;
      if Passo < 1 then
        Passo := 1;
      while not QueryTabelaPrecos.Eof do
      begin
        Inc(Lidos);
        if (Lidos mod Passo) = 0 then
          AtualizarProgresso(25 + (Lidos * 70 div Total));
        QueryTabelaPrecos.Next;
      end;
      QueryTabelaPrecos.First;
    end;

    AtualizarProgresso(100);
    LabelProgresso.Caption := Format('Pesquisa concluida: %d produto(s)',
      [Total]);
  finally
    QueryTabelaPrecos.EnableControls;
  end;

  DestacarColunaOrdenacao;
end;

procedure TForm_RelatorioTabelaPrecos.BtnPesquisarClick(Sender: TObject);
begin
  Pesquisar;

  if QueryTabelaPrecos.Active and QueryTabelaPrecos.IsEmpty then
    MensagemDlg('Nenhum produto encontrado para os filtros informados.',
      mtInformation, [mbOK], 0);
end;

procedure TForm_RelatorioTabelaPrecos.BtnLimparClick(Sender: TObject);
begin
  // Volta os filtros ao estado original do formulario.
  EditCodigoDe.Clear;
  EditCodigoAte.Clear;
  EditReferencia.Clear;
  EditMarca.Clear;
  EditGrupo.Clear;
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

{ Impressao - layout FastReport na tabela RELATORIO com fallback embutido }

function TForm_RelatorioTabelaPrecos.LocalizarArquivoFr3: string;
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
    PastaExe + 'Projeto\' + PASTA_FR3_RELATIVA + PathDelim,
    PastaExe,
    PastaExe + '..' + PathDelim + PASTA_FR3_RELATIVA + PathDelim,
    PastaExe + '..' + PathDelim + '..' + PathDelim + PASTA_FR3_RELATIVA + PathDelim
  ];

  for I := Low(Bases) to High(Bases) do
  begin
    Tentativa := Bases[I] + ARQUIVO_FR3;
    if FileExists(Tentativa) then
      Exit(ExpandFileName(Tentativa));
  end;
end;

procedure TForm_RelatorioTabelaPrecos.SincronizarLayoutFr3NoBanco;
var
  CaminhoFr3: string;
begin
  CaminhoFr3 := LocalizarArquivoFr3;
  if CaminhoFr3 = '' then
    Exit;

  GravarRelatorioNoBanco(NOME_RELATORIO_TABELA_PRECOS, CaminhoFr3);
end;

procedure TForm_RelatorioTabelaPrecos.GravarRelatorioEmbutidoNoBanco(
  const ANome: string);
var
  Query: TIBQuery;
  Stream: TMemoryStream;
begin
  Stream := TMemoryStream.Create;
  try
    frxReportTabelaPrecos.SaveToStream(Stream);
    Stream.Position := 0;

    Query := TIBQuery.Create(nil);
    try
      Query.Database    := QueryTabelaPrecos.Database;
      Query.Transaction := QueryTabelaPrecos.Transaction;
      Query.SQL.Text :=
        'update or insert into RELATORIO ' +
        '  (NOME, DESCRICAO, ARQUIVO, DATA_ALTERACAO) ' +
        'values ' +
        '  (:PNOME, :PDESCRICAO, :PARQUIVO, CURRENT_TIMESTAMP) ' +
        'matching (NOME)';
      Query.ParamByName('PNOME').AsString      := ANome;
      Query.ParamByName('PDESCRICAO').AsString :=
        'Relatorio de Tabela de Precos';
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

procedure TForm_RelatorioTabelaPrecos.GravarRelatorioNoBanco(const ANome,
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
      Query.Database    := QueryTabelaPrecos.Database;
      Query.Transaction := QueryTabelaPrecos.Transaction;
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
        'Relatorio de Tabela de Precos com filtros';
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

function TForm_RelatorioTabelaPrecos.CarregarRelatorioDoBanco(const ANome: string;
  Stream: TStream): Boolean;
var
  Query: TIBQuery;
begin
  Query := TIBQuery.Create(nil);
  try
    Query.Database    := QueryTabelaPrecos.Database;
    Query.Transaction := QueryTabelaPrecos.Transaction;
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

procedure TForm_RelatorioTabelaPrecos.ExibirRelatorio;
var
  Stream: TMemoryStream;
  CaminhoFr3: string;
begin
  Stream := TMemoryStream.Create;
  try
    CaminhoFr3 := LocalizarArquivoFr3;
    if CaminhoFr3 <> '' then
    begin
      frxReportTabelaPrecos.LoadFromFile(CaminhoFr3);
      GravarRelatorioNoBanco(NOME_RELATORIO_TABELA_PRECOS, CaminhoFr3);
    end
    else if CarregarRelatorioDoBanco(NOME_RELATORIO_TABELA_PRECOS, Stream) then
      frxReportTabelaPrecos.LoadFromStream(Stream)
    else
    begin
      MensagemDlg('Nao foi possivel carregar o relatorio "' +
        NOME_RELATORIO_TABELA_PRECOS +
        '" (arquivo .fr3 e tabela RELATORIO).',
        mtError, [mbOK], 0);
      Exit;
    end;

    TRelatorioExportacaoFast.VincularExportacoes(frxReportTabelaPrecos, frxExportPDF,
      frxExportExcel, frxExportWord, frxExportCSV);
    frxReportTabelaPrecos.ShowReport;
  finally
    Stream.Free;
  end;
end;

procedure TForm_RelatorioTabelaPrecos.BtnImprimirClick(Sender: TObject);
begin
  if not QueryTabelaPrecos.Active or QueryTabelaPrecos.IsEmpty then
  begin
    MensagemDlg('Nao ha produtos para imprimir. Utilize o botao ' +
      'Pesquisar primeiro.', mtInformation, [mbOK], 0);
    Exit;
  end;

  // Impressao via FastReport: o layout vem da tabela RELATORIO e os dados
  // da QueryTabelaPrecos (ja filtrada pela pesquisa).
  try
    ExibirRelatorio;
  except
    on E: Exception do
      MensagemDlg('Erro ao abrir o relatorio.' + sLineBreak + E.Message,
        mtError, [mbOK], 0);
  end;
end;

procedure TForm_RelatorioTabelaPrecos.BtnSairClick(Sender: TObject);
begin
  Close;
end;

end.
