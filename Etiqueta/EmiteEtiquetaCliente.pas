unit EmiteEtiquetaCliente;

{ Gerador de Etiquetas de Cliente - padrao de 3 colunas.

  Baseado no RelatorioCliente (mesmas regras de filtro e o mesmo fluxo de
  gravacao/carga do layout FastReport na tabela RELATORIO).

  Filtros disponiveis:
    1 - Ordem do resultado: alfabetica (NOME) ou por CODIGO (radio);
    2 - Faixa de codigo (de/ate);
    3 - Bairro (prefixo, sem diferenciar maiusculas);
    4 - Cidade (prefixo, sem diferenciar maiusculas).

  O botao Pesquisar monta a QueryCliente com os filtros informados e
  atualiza a DBGridCliente. O botao Imprimir gera as etiquetas via
  FastReport (layout guardado na tabela RELATORIO, campo BLOB ARQUIVO),
  uma etiqueta por cliente, dispostas em tres colunas na folha A4.

  Cada etiqueta exibe: CODIGO, NOME, ENDERECO, BAIRRO, CIDADE, TELEFONE. }

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls,
  Vcl.Grids, Vcl.DBGrids,
  Data.DB, IBX.IBQuery, IBX.IBCustomDataSet,
  frxClass, frxDBSet, frxExportPDF, frxExportXML, frxExportRTF, frxExportCSV,
  frxExportBaseDialog;

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
  NOME_RELATORIO_ETIQUETA_CLIENTE = 'ETIQUETA_CLIENTE';
  ARQUIVO_FR3                     = 'EtiquetaCliente.fr3';
  PASTA_FR3                       = 'C:\Avaliacao Delphi_Firebird\Andre_luis\Projeto\Fr3';
  PASTA_FR3_RELATIVA              = 'Fr3';

type
  TForm_EmiteEtiquetaCliente = class(TForm)
    Panel_Titulo: TPanel;

    PanelFiltros: TPanel;
    RadioGrupoOrdem: TRadioGroup;
    LabelCodigoDe: TLabel;
    EditCodigoDe: TEdit;
    LabelCodigoAte: TLabel;
    EditCodigoAte: TEdit;
    LabelBairro: TLabel;
    EditBairro: TEdit;
    LabelCidade: TLabel;
    EditCidade: TEdit;
    LabelProgresso: TLabel;
    ProgressBarPesquisa: TProgressBar;

    DBGridCliente: TDBGrid;

    PanelRodape: TPanel;
    BtnPesquisar: TBitBtn;
    BtnLimpar: TBitBtn;
    BtnImprimir: TBitBtn;
    BtnSair: TBitBtn;

    QueryCliente: TIBQuery;
    DsCliente: TDataSource;
    frxDBDatasetCliente: TfrxDBDataset;
    frxReportCliente: TfrxReport;
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
    procedure DBGridClienteDrawColumnCell(Sender: TObject;
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
    procedure AtualizarProgresso(Percentual: Integer);
    procedure DestacarColunaOrdenacao;
    function LocalizarArquivoFr3: string;
    procedure GravarRelatorioNoBanco(const ANome, ACaminhoArquivo: string);
    function CarregarRelatorioDoBanco(const ANome: string;
      Stream: TStream): Boolean;
    procedure ExibirRelatorio;
  public
    { Public declarations }
  end;

var
  Form_EmiteEtiquetaCliente: TForm_EmiteEtiquetaCliente;

implementation

uses DataModule, Mensagens, RelatorioExportacaoFast, UITheme;

{$R *.dfm}

{ Utilitarios visuais (mesmo padrao do RelatorioCliente) }

procedure TForm_EmiteEtiquetaCliente.ConfigurarGlyphsBotoes;
begin
  AplicarBotaoBootstrap(BtnPesquisar, bbkOutline, ICN_PESQUISA);
  AplicarBotaoBootstrap(BtnLimpar, bbkOutline, ICN_LIMPAR);
  AplicarBotaoBootstrap(BtnImprimir, bbkPrimary, ICN_IMPRIMIR);
  AplicarBotaoBootstrap(BtnSair, bbkSecondary, ICN_SAIR);
end;

{ Ciclo de vida }

procedure TForm_EmiteEtiquetaCliente.FormCreate(Sender: TObject);
begin
  Color := COR_PAGE;
  AplicarHeaderPrimary(Panel_Titulo);
  AplicarFormEstiloWeb(Self);
  AplicarPainelCard(PanelFiltros);
  ConfigurarGlyphsBotoes;
  TRelatorioExportacaoFast.VincularExportacoes(frxReportCliente, frxExportPDF,
    frxExportExcel, frxExportWord, frxExportCSV);

  // Abre listando todos os clientes na ordem padrao (alfabetica).
  Pesquisar;
end;

procedure TForm_EmiteEtiquetaCliente.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  QueryCliente.Close;
  Action := caFree;
  Form_EmiteEtiquetaCliente := nil;
end;

{ Navegacao por teclado }

procedure TForm_EmiteEtiquetaCliente.FormKeyDown(Sender: TObject; var Key: Word;
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
    // ultimo campo (Cidade) esta focado, senao segue ao proximo campo.
    if ActiveControl is TCustomDBGrid then
      Exit;
    if ActiveControl = EditCidade then
      BtnPesquisar.Click
    else
      SelectNext(ActiveControl, True, True);
  end;
end;

{ Cores de foco }

procedure TForm_EmiteEtiquetaCliente.EditFocoEnter(Sender: TObject);
begin
  if Sender is TEdit then
    TEdit(Sender).Color := COR_EDIT_FOCO;
end;

procedure TForm_EmiteEtiquetaCliente.EditFocoExit(Sender: TObject);
begin
  if Sender is TEdit then
    TEdit(Sender).Color := COR_EDIT_NORMAL;
end;

procedure TForm_EmiteEtiquetaCliente.EditNumericoKeyPress(Sender: TObject;
  var Key: Char);
begin
  // Faixa de codigo aceita apenas digitos (e backspace).
  if not CharInSet(Key, ['0'..'9', #8]) then
    Key := #0;
end;

{ Grid - linhas com cores alternadas (zebra) }

procedure TForm_EmiteEtiquetaCliente.DBGridClienteDrawColumnCell(
  Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn;
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

function TForm_EmiteEtiquetaCliente.ValidarFaixaCodigo(out ACodigoDe,
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

procedure TForm_EmiteEtiquetaCliente.AtualizarProgresso(Percentual: Integer);
begin
  ProgressBarPesquisa.Position := Percentual;
  LabelProgresso.Caption := Format('Executando pesquisa: %d%%', [Percentual]);
  // Update forca o repaint imediato sem reentrar no loop de mensagens.
  ProgressBarPesquisa.Update;
  LabelProgresso.Update;
end;

procedure TForm_EmiteEtiquetaCliente.DestacarColunaOrdenacao;
var
  I: Integer;
  CampoOrdem: string;
begin
  // Campo de ordenacao escolhido no Filtro 1 (radio).
  if RadioGrupoOrdem.ItemIndex = 1 then
    CampoOrdem := 'CODIGO'
  else
    CampoOrdem := 'NOME';

  // Titulo da coluna ordenada em destaque (invertido: fundo navy, texto
  // branco); as demais voltam ao visual padrao.
  for I := 0 to DBGridCliente.Columns.Count - 1 do
    if SameText(DBGridCliente.Columns[I].FieldName, CampoOrdem) then
    begin
      DBGridCliente.Columns[I].Title.Color      := COR_PRIMARY;
      DBGridCliente.Columns[I].Title.Font.Color := clWhite;
    end
    else
    begin
      DBGridCliente.Columns[I].Title.Color      := clBtnFace;
      DBGridCliente.Columns[I].Title.Font.Color := COR_PRIMARY;
    end;
end;

procedure TForm_EmiteEtiquetaCliente.Pesquisar;
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
    if Trim(EditBairro.Text) <> '' then
      Query.ParamByName('PBAIRRO').AsString := Trim(EditBairro.Text) + '%';
    if Trim(EditCidade.Text) <> '' then
      Query.ParamByName('PCIDADE').AsString := Trim(EditCidade.Text) + '%';
  end;

begin
  if not ValidarFaixaCodigo(CodigoDe, CodigoAte, TemDe, TemAte) then
    Exit;

  AtualizarProgresso(0);

  // Monta o WHERE somente com os filtros efetivamente preenchidos.
  Where := ' from CLIENTE where 1 = 1';
  if TemDe then
    Where := Where + ' and CODIGO >= :PCODIGO_DE';
  if TemAte then
    Where := Where + ' and CODIGO <= :PCODIGO_ATE';
  if Trim(EditBairro.Text) <> '' then
    Where := Where + ' and UPPER(BAIRRO) like UPPER(:PBAIRRO)';
  if Trim(EditCidade.Text) <> '' then
    Where := Where + ' and UPPER(CIDADE) like UPPER(:PCIDADE)';

  // Filtro 1: ordem alfabetica ou por codigo.
  Sql := 'select CODIGO, NOME, ENDERECO, BAIRRO, CIDADE, TELEFONE' + Where;
  if RadioGrupoOrdem.ItemIndex = 1 then
    Sql := Sql + ' order by CODIGO'
  else
    Sql := Sql + ' order by NOME';

  // Total de registros esperados: base do calculo do percentual.
  Total := 0;
  QueryContagem := TIBQuery.Create(nil);
  try
    QueryContagem.Database    := QueryCliente.Database;
    QueryContagem.Transaction := QueryCliente.Transaction;
    QueryContagem.SQL.Text    := 'select count(*)' + Where;
    PreencherParametros(QueryContagem);
    QueryContagem.Open;
    Total := QueryContagem.Fields[0].AsInteger;
    QueryContagem.Close;
  finally
    QueryContagem.Free;
  end;
  AtualizarProgresso(15);

  QueryCliente.DisableControls;
  try
    QueryCliente.Close;
    QueryCliente.SQL.Text := Sql;
    PreencherParametros(QueryCliente);
    QueryCliente.Open;
    AtualizarProgresso(25);

    // Percorre o resultado trazendo os registros do servidor e avancando
    // o percentual proporcionalmente a quantidade ja carregada.
    if Total > 0 then
    begin
      Lidos := 0;
      Passo := Total div 20;
      if Passo < 1 then
        Passo := 1;
      while not QueryCliente.Eof do
      begin
        Inc(Lidos);
        if (Lidos mod Passo) = 0 then
          AtualizarProgresso(25 + (Lidos * 70 div Total));
        QueryCliente.Next;
      end;
      QueryCliente.First;
    end;

    AtualizarProgresso(100);
    LabelProgresso.Caption := Format('Pesquisa concluida: %d cliente(s)',
      [Total]);
  finally
    QueryCliente.EnableControls;
  end;

  DestacarColunaOrdenacao;
end;

procedure TForm_EmiteEtiquetaCliente.BtnPesquisarClick(Sender: TObject);
begin
  Pesquisar;

  if QueryCliente.Active and QueryCliente.IsEmpty then
    MensagemDlg('Nenhum cliente encontrado para os filtros informados.',
      mtInformation, [mbOK], 0);
end;

procedure TForm_EmiteEtiquetaCliente.BtnLimparClick(Sender: TObject);
begin
  // Volta os filtros ao estado original do formulario.
  EditCodigoDe.Clear;
  EditCodigoAte.Clear;
  EditBairro.Clear;
  EditCidade.Clear;
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

function TForm_EmiteEtiquetaCliente.LocalizarArquivoFr3: string;
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

procedure TForm_EmiteEtiquetaCliente.GravarRelatorioNoBanco(const ANome,
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
      Query.Database    := QueryCliente.Database;
      Query.Transaction := QueryCliente.Transaction;
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
        'Etiquetas de Cliente (3 colunas)';
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

function TForm_EmiteEtiquetaCliente.CarregarRelatorioDoBanco(
  const ANome: string; Stream: TStream): Boolean;
var
  Query: TIBQuery;
begin
  Query := TIBQuery.Create(nil);
  try
    Query.Database    := QueryCliente.Database;
    Query.Transaction := QueryCliente.Transaction;
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

procedure TForm_EmiteEtiquetaCliente.ExibirRelatorio;
var
  Stream: TMemoryStream;
  CaminhoFr3: string;
begin
  Stream := TMemoryStream.Create;
  try
    // O layout mora na tabela RELATORIO. Se ainda nao foi gravado
    // (primeira execucao), alimenta a tabela a partir do .fr3 em disco.
    if not CarregarRelatorioDoBanco(NOME_RELATORIO_ETIQUETA_CLIENTE, Stream) then
    begin
      CaminhoFr3 := LocalizarArquivoFr3;
      if CaminhoFr3 = '' then
      begin
        MensagemDlg('Layout "' + NOME_RELATORIO_ETIQUETA_CLIENTE + '" nao ' +
          'encontrado na tabela RELATORIO e o arquivo ' + ARQUIVO_FR3 +
          ' nao foi localizado em disco.', mtWarning, [mbOK], 0);
        Exit;
      end;

      GravarRelatorioNoBanco(NOME_RELATORIO_ETIQUETA_CLIENTE, CaminhoFr3);
      if not CarregarRelatorioDoBanco(NOME_RELATORIO_ETIQUETA_CLIENTE, Stream) then
      begin
        MensagemDlg('Nao foi possivel carregar o layout gravado na ' +
          'tabela RELATORIO.', mtError, [mbOK], 0);
        Exit;
      end;
    end;

    frxReportCliente.LoadFromStream(Stream);
    TRelatorioExportacaoFast.VincularExportacoes(frxReportCliente, frxExportPDF,
      frxExportExcel, frxExportWord, frxExportCSV);
    frxReportCliente.ShowReport;
  finally
    Stream.Free;
  end;
end;

procedure TForm_EmiteEtiquetaCliente.BtnImprimirClick(Sender: TObject);
begin
  if not QueryCliente.Active or QueryCliente.IsEmpty then
  begin
    MensagemDlg('Nao ha clientes para gerar etiquetas. Utilize o botao ' +
      'Pesquisar primeiro.', mtInformation, [mbOK], 0);
    Exit;
  end;

  // Impressao via FastReport: o layout vem da tabela RELATORIO e os dados
  // da QueryCliente (ja filtrada pela pesquisa).
  try
    ExibirRelatorio;
  except
    on E: Exception do
      MensagemDlg('Erro ao abrir as etiquetas.' + sLineBreak + E.Message,
        mtError, [mbOK], 0);
  end;
end;

procedure TForm_EmiteEtiquetaCliente.BtnSairClick(Sender: TObject);
begin
  Close;
end;

end.
