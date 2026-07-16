unit RelatorioProduto;

{ Filtro para Relatorio de Produtos (mesmas regras do RelatorioCliente).

  Filtros disponiveis:
    1 - Ordem do resultado: alfabetica (DESCRICAO) ou por CODIGO (radio);
    2 - Faixa de codigo (inicial/final);
    3 - Referencia (prefixo, sem diferenciar maiusculas);
    4 - Marca (prefixo, sem diferenciar maiusculas);
    5 - Grupo (prefixo, sem diferenciar maiusculas).

  O botao Pesquisar monta a QueryProduto com os filtros informados e
  atualiza a DBGridProduto, exibindo o percentual da tarefa executada.
  A impressao e feita pelo FastReport com o layout guardado na tabela
  RELATORIO (campo BLOB ARQUIVO), usando a QueryProduto como fonte. }

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
  NOME_RELATORIO_PRODUTO = 'RELATORIO_PRODUTO';
  ARQUIVO_FR3            = 'Relatorio_Produto.fr3';
  PASTA_FR3              = 'C:\Avaliacao Delphi_Firebird\Andre_luis\Projeto\Fr3';
  PASTA_FR3_RELATIVA     = 'Fr3';

type
  TForm_RelatorioProduto = class(TForm)
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

    DBGridProduto: TDBGrid;

    PanelRodape: TPanel;
    BtnPesquisar: TBitBtn;
    BtnLimpar: TBitBtn;
    BtnImprimir: TBitBtn;
    BtnSair: TBitBtn;

    QueryProduto: TIBQuery;
    DsProduto: TDataSource;
    frxDBDatasetProduto: TfrxDBDataset;
    frxReportProduto: TfrxReport;
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
    procedure DBGridProdutoDrawColumnCell(Sender: TObject;
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
    procedure GravarRelatorioNoBanco(const ANome, ACaminhoArquivo: string);
    function CarregarRelatorioDoBanco(const ANome: string;
      Stream: TStream): Boolean;
    procedure ExibirRelatorio;
  public
    { Public declarations }
  end;

var
  Form_RelatorioProduto: TForm_RelatorioProduto;

implementation

uses DataModule, Mensagens, RelatorioExportacaoFast, UITheme;

{$R *.dfm}

{ Utilitarios visuais (mesmo padrao do RelatorioCliente) }

procedure TForm_RelatorioProduto.ConfigurarGlyphsBotoes;
begin
  AplicarBotaoBootstrap(BtnPesquisar, bbkOutline, ICN_PESQUISA);
  AplicarBotaoBootstrap(BtnLimpar, bbkOutline, ICN_LIMPAR);
  AplicarBotaoBootstrap(BtnImprimir, bbkPrimary, ICN_IMPRIMIR);
  AplicarBotaoBootstrap(BtnSair, bbkSecondary, ICN_SAIR);
end;

{ Ciclo de vida }

procedure TForm_RelatorioProduto.FormCreate(Sender: TObject);
begin
  Color := COR_PAGE;
  AplicarHeaderPrimary(Panel_Titulo);
  AplicarFormEstiloWeb(Self);
  AplicarPainelCard(PanelFiltros);
  ConfigurarGlyphsBotoes;
  TRelatorioExportacaoFast.VincularExportacoes(frxReportProduto, frxExportPDF,
    frxExportExcel, frxExportWord, frxExportCSV);

  // Abre listando todos os produtos na ordem padrao (alfabetica).
  Pesquisar;
end;

procedure TForm_RelatorioProduto.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  QueryProduto.Close;
  Action := caFree;
  Form_RelatorioProduto := nil;
end;

{ Navegacao por teclado }

procedure TForm_RelatorioProduto.FormKeyDown(Sender: TObject; var Key: Word;
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

procedure TForm_RelatorioProduto.EditFocoEnter(Sender: TObject);
begin
  if Sender is TEdit then
    TEdit(Sender).Color := COR_EDIT_FOCO;
end;

procedure TForm_RelatorioProduto.EditFocoExit(Sender: TObject);
begin
  if Sender is TEdit then
    TEdit(Sender).Color := COR_EDIT_NORMAL;
end;

procedure TForm_RelatorioProduto.EditNumericoKeyPress(Sender: TObject;
  var Key: Char);
begin
  // Faixa de codigo aceita apenas digitos (e backspace).
  if not CharInSet(Key, ['0'..'9', #8]) then
    Key := #0;
end;

{ Grid - linhas com cores alternadas (zebra) }

procedure TForm_RelatorioProduto.DBGridProdutoDrawColumnCell(Sender: TObject;
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

function TForm_RelatorioProduto.ValidarFaixaCodigo(out ACodigoDe,
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

procedure TForm_RelatorioProduto.AjustarFormatoCampos;

  procedure Formatar(const NomeCampo, Formato: string);
  var
    Fld: TField;
  begin
    Fld := QueryProduto.FindField(NomeCampo);
    if Fld is TBCDField then
      TBCDField(Fld).DisplayFormat := Formato
    else if Fld is TFloatField then
      TFloatField(Fld).DisplayFormat := Formato;
  end;

begin
  Formatar('PRECO_VENDA',   '#,##0.00');
  Formatar('ESTOQUE_ATUAL', '#,##0.000');
end;

procedure TForm_RelatorioProduto.AtualizarProgresso(Percentual: Integer);
begin
  ProgressBarPesquisa.Position := Percentual;
  LabelProgresso.Caption := Format('Executando pesquisa: %d%%', [Percentual]);
  // Update forca o repaint imediato sem reentrar no loop de mensagens.
  ProgressBarPesquisa.Update;
  LabelProgresso.Update;
end;

procedure TForm_RelatorioProduto.DestacarColunaOrdenacao;
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
  for I := 0 to DBGridProduto.Columns.Count - 1 do
    if SameText(DBGridProduto.Columns[I].FieldName, CampoOrdem) then
    begin
      DBGridProduto.Columns[I].Title.Color      := COR_PRIMARY;
      DBGridProduto.Columns[I].Title.Font.Color := clWhite;
    end
    else
    begin
      DBGridProduto.Columns[I].Title.Color      := clBtnFace;
      DBGridProduto.Columns[I].Title.Font.Color := COR_PRIMARY;
    end;
end;

procedure TForm_RelatorioProduto.Pesquisar;
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
  Sql := 'select CODIGO, DESCRICAO, REFERENCIA, MARCA, GRUPO, ' +
         'PRECO_VENDA, ESTOQUE_ATUAL' + Where;
  if RadioGrupoOrdem.ItemIndex = 1 then
    Sql := Sql + ' order by CODIGO'
  else
    Sql := Sql + ' order by DESCRICAO';

  // Total de registros esperados: base do calculo do percentual.
  Total := 0;
  QueryContagem := TIBQuery.Create(nil);
  try
    QueryContagem.Database    := QueryProduto.Database;
    QueryContagem.Transaction := QueryProduto.Transaction;
    QueryContagem.SQL.Text    := 'select count(*)' + Where;
    PreencherParametros(QueryContagem);
    QueryContagem.Open;
    Total := QueryContagem.Fields[0].AsInteger;
    QueryContagem.Close;
  finally
    QueryContagem.Free;
  end;
  AtualizarProgresso(15);

  QueryProduto.DisableControls;
  try
    QueryProduto.Close;
    QueryProduto.SQL.Text := Sql;
    PreencherParametros(QueryProduto);
    QueryProduto.Open;
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
      while not QueryProduto.Eof do
      begin
        Inc(Lidos);
        if (Lidos mod Passo) = 0 then
          AtualizarProgresso(25 + (Lidos * 70 div Total));
        QueryProduto.Next;
      end;
      QueryProduto.First;
    end;

    AtualizarProgresso(100);
    LabelProgresso.Caption := Format('Pesquisa concluida: %d produto(s)',
      [Total]);
  finally
    QueryProduto.EnableControls;
  end;

  DestacarColunaOrdenacao;
end;

procedure TForm_RelatorioProduto.BtnPesquisarClick(Sender: TObject);
begin
  Pesquisar;

  if QueryProduto.Active and QueryProduto.IsEmpty then
    MensagemDlg('Nenhum produto encontrado para os filtros informados.',
      mtInformation, [mbOK], 0);
end;

procedure TForm_RelatorioProduto.BtnLimparClick(Sender: TObject);
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

{ Impressao - layout FastReport guardado na tabela RELATORIO }

function TForm_RelatorioProduto.LocalizarArquivoFr3: string;
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

procedure TForm_RelatorioProduto.GravarRelatorioNoBanco(const ANome,
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
      Query.Database    := QueryProduto.Database;
      Query.Transaction := QueryProduto.Transaction;
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
        'Relatorio de Produtos com filtros';
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

function TForm_RelatorioProduto.CarregarRelatorioDoBanco(const ANome: string;
  Stream: TStream): Boolean;
var
  Query: TIBQuery;
begin
  Query := TIBQuery.Create(nil);
  try
    Query.Database    := QueryProduto.Database;
    Query.Transaction := QueryProduto.Transaction;
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

procedure TForm_RelatorioProduto.ExibirRelatorio;
var
  Stream: TMemoryStream;
  CaminhoFr3: string;
begin
  Stream := TMemoryStream.Create;
  try
    // O layout mora na tabela RELATORIO. Se ainda nao foi gravado
    // (primeira execucao), alimenta a tabela a partir do .fr3 em disco.
    if not CarregarRelatorioDoBanco(NOME_RELATORIO_PRODUTO, Stream) then
    begin
      CaminhoFr3 := LocalizarArquivoFr3;
      if CaminhoFr3 = '' then
      begin
        MensagemDlg('Relatorio "' + NOME_RELATORIO_PRODUTO + '" nao ' +
          'encontrado na tabela RELATORIO e o arquivo ' + ARQUIVO_FR3 +
          ' nao foi localizado em disco.', mtWarning, [mbOK], 0);
        Exit;
      end;

      GravarRelatorioNoBanco(NOME_RELATORIO_PRODUTO, CaminhoFr3);
      if not CarregarRelatorioDoBanco(NOME_RELATORIO_PRODUTO, Stream) then
      begin
        MensagemDlg('Nao foi possivel carregar o relatorio gravado na ' +
          'tabela RELATORIO.', mtError, [mbOK], 0);
        Exit;
      end;
    end;

    frxReportProduto.LoadFromStream(Stream);
    TRelatorioExportacaoFast.VincularExportacoes(frxReportProduto, frxExportPDF,
      frxExportExcel, frxExportWord, frxExportCSV);
    frxReportProduto.ShowReport;
  finally
    Stream.Free;
  end;
end;

procedure TForm_RelatorioProduto.BtnImprimirClick(Sender: TObject);
begin
  if not QueryProduto.Active or QueryProduto.IsEmpty then
  begin
    MensagemDlg('Nao ha produtos para imprimir. Utilize o botao ' +
      'Pesquisar primeiro.', mtInformation, [mbOK], 0);
    Exit;
  end;

  // Impressao via FastReport: o layout vem da tabela RELATORIO e os dados
  // da QueryProduto (ja filtrada pela pesquisa).
  try
    ExibirRelatorio;
  except
    on E: Exception do
      MensagemDlg('Erro ao abrir o relatorio.' + sLineBreak + E.Message,
        mtError, [mbOK], 0);
  end;
end;

procedure TForm_RelatorioProduto.BtnSairClick(Sender: TObject);
begin
  Close;
end;

end.
