unit RelatorioVendaProduto;

{ Relatorio de Vendas por Produto (mestre x detalhe).

  Estrutura mestre/detalhe montada por uma unica consulta com joins:

    VENDA (mestre)  ->  VENDA_ITEM (detalhe)
      + CLIENTE (nome do cliente)
      + PRODUTO (descricao do produto)

  Filtros disponiveis:
    1 - Ordem do resultado: por Data, por Codigo da venda ou alfabetica
        (nome do cliente) - UI mantida; ordenacao efetiva e fixa;
    2 - Situacao da venda: Todas (padrao), Abertas ou Fechadas;
    3 - Faixa de codigo da venda (inicial/final);
    4 - Faixa de data da venda (inicial/final), dd/mm/yyyy;
    5 - Cliente: por codigo ou por nome (with lookup - lupa abrindo
        ConsultaCliente);
    6 - Produto: por codigo ou por descricao (with lookup - lupa abrindo
        ConsultaProduto).

  Quando ambos "codigo" e "texto" estao preenchidos para cliente ou
  produto, o codigo tem preferencia (mais especifico).

  O botao Pesquisar monta a QueryVendaProduto com os filtros informados
  e atualiza o DBGridVendaProduto, exibindo o percentual da tarefa.
  A impressao usa o FastReport com o layout guardado na tabela RELATORIO
  (campo BLOB ARQUIVO); caso nem o banco nem o arquivo em disco tenham
  o layout, o layout embutido no proprio TfrxReport (dfm) e usado.

  Quebras/subtotais do relatorio:
    - Quebra por produto (DESCRICAO_PRODUTO).
    - Detalhe (por venda): soma VALOR_BRUTO, DESCONTO, ACRESCIMO,
      TOTAL_LIQUIDO dos itens.
    - Subtotal por produto; total geral no rodape.
    - Ordenacao fixa: Descricao do produto + Data.
    - Grafico de barras 3D no rodape: total liquido por produto
      (QueryGraficoPorProduto + TfrxChartView). }

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls,
  Vcl.Grids, Vcl.DBGrids,
  Data.DB, IBX.IBQuery, IBX.IBCustomDataSet,
  frxClass, frxDBSet, frxChart, frxExportPDF, frxExportXML, frxExportRTF,
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
  ICN_LUPA     = #$E721; // Search (mesmo usado no BtnPesquisar da Venda)

  // Layout FastReport guardado na tabela RELATORIO (campo BLOB ARQUIVO).
  // Se nem o banco nem o arquivo .fr3 forem localizados, o layout
  // embutido no proprio TfrxReport (no dfm) e usado como fallback.
  NOME_RELATORIO_VENDA_PRODUTO = 'Relatorio_Venda_Produto';
  ARQUIVO_FR3                    = 'RelatorioVendasPorProduto.fr3';
  PASTA_FR3          = 'C:\Avaliacao Delphi_Firebird\Andre_luis\Projeto\Fr3';
  PASTA_FR3_RELATIVA = 'Fr3';

type
  TForm_RelatorioVendaProduto = class(TForm)
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
    LabelCodigoProduto: TLabel;
    EditCodigoProduto: TEdit;
    EditDescricaoProduto: TEdit;
    BtnLupaProduto: TBitBtn;
    LabelProgresso: TLabel;
    ProgressBarPesquisa: TProgressBar;

    DBGridVendaProduto: TDBGrid;

    PanelRodape: TPanel;
    BtnPesquisar: TBitBtn;
    BtnLimpar: TBitBtn;
    BtnImprimir: TBitBtn;
    BtnSair: TBitBtn;

    QueryVendaProduto: TIBQuery;
    DsVendaProduto: TDataSource;
    frxDBDatasetVendaProduto: TfrxDBDataset;
    QueryGraficoPorProduto: TIBQuery;
    frxDBDatasetGraficoPorProduto: TfrxDBDataset;
    frxReportVendaProduto: TfrxReport;
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
    procedure DBGridVendaProdutoDrawColumnCell(Sender: TObject;
      const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);
    procedure BtnLupaClienteClick(Sender: TObject);
    procedure BtnLupaProdutoClick(Sender: TObject);
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
    procedure DestacarColunaOrdenacao;
    function LocalizarArquivoFr3: string;
    procedure GravarRelatorioNoBanco(const ANome, ACaminhoArquivo: string);
    procedure GravarRelatorioEmbutidoNoBanco(const ANome: string);
    function CarregarRelatorioDoBanco(const ANome: string;
      AStream: TStream): Boolean;
    procedure SincronizarLayoutFr3NoBanco;
    function DescricaoFiltros: string;
    procedure AplicarCabecalhoRelatorio;
    procedure ConfigurarGraficoBarrasPorProduto;
    procedure ExibirRelatorio;
  public
    { Public declarations }
  end;

var
  Form_RelatorioVendaProduto: TForm_RelatorioVendaProduto;

implementation

uses DataModule, Mensagens, ConsultaCliente, ConsultaProduto,
  RelatorioExportacaoFast, UITheme;

{$R *.dfm}

{ Utilitarios visuais (mesmo padrao do RelatorioVenda sintetico) }

procedure TForm_RelatorioVendaProduto.ConfigurarGlyphsBotoes;
begin
  AplicarBotaoBootstrap(BtnPesquisar, bbkOutline, ICN_PESQUISA);
  AplicarBotaoBootstrap(BtnLimpar, bbkOutline, ICN_LIMPAR);
  AplicarBotaoBootstrap(BtnImprimir, bbkPrimary, ICN_IMPRIMIR);
  AplicarBotaoBootstrap(BtnSair, bbkSecondary, ICN_SAIR);
  AplicarBotaoBootstrap(BtnLupaCliente, bbkOutline, ICN_LUPA);
  AplicarBotaoBootstrap(BtnLupaProduto, bbkOutline, ICN_LUPA);
end;

{ Ciclo de vida }

procedure TForm_RelatorioVendaProduto.FormCreate(Sender: TObject);
var
  lCaminhoFr3: string;
begin
  Color := COR_PAGE;
  AplicarHeaderPrimary(Panel_Titulo);
  AplicarFormEstiloWeb(Self);
  AplicarPainelCard(PanelFiltros);
  ConfigurarGlyphsBotoes;
  TRelatorioExportacaoFast.VincularExportacoes(frxReportVendaProduto,
    frxExportPDF, frxExportExcel, frxExportWord, frxExportCSV);

  // Atualiza a tabela RELATORIO com o .fr3 + titulo + grafico de barras 3D.
  lCaminhoFr3 := LocalizarArquivoFr3;
  if lCaminhoFr3 <> '' then
  begin
    frxReportVendaProduto.LoadFromFile(lCaminhoFr3);
    AplicarCabecalhoRelatorio;
    ConfigurarGraficoBarrasPorProduto;
    GravarRelatorioEmbutidoNoBanco(NOME_RELATORIO_VENDA_PRODUTO);
  end
  else
    SincronizarLayoutFr3NoBanco;

  // Abre listando todas as vendas na ordem padrao (por Data).
  Pesquisar;
end;

procedure TForm_RelatorioVendaProduto.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  QueryVendaProduto.Close;
  QueryGraficoPorProduto.Close;
  Action := caFree;
  Form_RelatorioVendaProduto := nil;
end;

{ Navegacao por teclado }

procedure TForm_RelatorioVendaProduto.FormKeyDown(Sender: TObject;
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
    // ENTER na grade nao navega; nos filtros dispara a pesquisa quando o
    // ultimo campo (Descricao Produto) esta focado, senao segue ao proximo.
    if ActiveControl is TCustomDBGrid then
      Exit;
    if ActiveControl = EditDescricaoProduto then
      BtnPesquisar.Click
    else
      SelectNext(ActiveControl, True, True);
  end;
end;

{ Cores de foco }

procedure TForm_RelatorioVendaProduto.EditFocoEnter(Sender: TObject);
begin
  if Sender is TEdit then
    TEdit(Sender).Color := COR_EDIT_FOCO;
end;

procedure TForm_RelatorioVendaProduto.EditFocoExit(Sender: TObject);
begin
  if Sender is TEdit then
    TEdit(Sender).Color := COR_EDIT_NORMAL;
end;

procedure TForm_RelatorioVendaProduto.EditNumericoKeyPress(Sender: TObject;
  var Key: Char);
begin
  // Campos numericos aceitam apenas digitos (e backspace).
  if not CharInSet(Key, ['0'..'9', #8]) then
    Key := #0;
end;

procedure TForm_RelatorioVendaProduto.EditDataKeyPress(Sender: TObject;
  var Key: Char);
var
  lEdit: TEdit;
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

procedure TForm_RelatorioVendaProduto.DBGridVendaProdutoDrawColumnCell(
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

{ Lookups Cliente/Produto (reaproveitando os forms de consulta) }

procedure TForm_RelatorioVendaProduto.BtnLupaClienteClick(Sender: TObject);
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

procedure TForm_RelatorioVendaProduto.BtnLupaProdutoClick(Sender: TObject);
var
  lCodigo: Integer;
  lDescricao: string;
begin
  if TForm_ConsultaProduto.Selecionar(lCodigo, lDescricao) then
  begin
    EditCodigoProduto.Text    := IntToStr(lCodigo);
    EditDescricaoProduto.Text := lDescricao;
  end;
end;

{ Pesquisa }

function TForm_RelatorioVendaProduto.ValidarFaixaCodigo(out ACodigoDe,
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

function TForm_RelatorioVendaProduto.ValidarFaixaData(out ADataDe,
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
  // As datas sao aceitas somente no formato dd/mm/yyyy, independente da
  // configuracao regional do Windows.
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

procedure TForm_RelatorioVendaProduto.AjustarFormatoCampos;

  procedure Formatar(const ANomeCampo, AFormato: string);
  var
    lFld: TField;
  begin
    lFld := QueryVendaProduto.FindField(ANomeCampo);
    if lFld is TBCDField then
      TBCDField(lFld).DisplayFormat := AFormato
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
  // Zeros a esquerda: venda com 6 casas, cliente e produto com 5/6 casas.
  Formatar('CODIGO',            '000000');
  Formatar('CODIGO_CLIENTE',    '00000');
  Formatar('CODIGO_PRODUTO',    '000000');
  Formatar('CODIGO_ITEM',       '000000');
  // Datas
  Formatar('DATA_HORA_VENDA',   'dd/mm/yyyy');
  Formatar('DATA_VENDA',        'dd/mm/yyyy');
  // Numericos
  Formatar('QUANTIDADE',        '#,##0.000');
  Formatar('PRECO_UNITARIO',    '#,##0.00');
  Formatar('VALOR_BRUTO',       '#,##0.00');
  Formatar('DESCONTO',          '#,##0.00');
  Formatar('ACRESCIMO',         '#,##0.00');
  Formatar('TOTAL_LIQUIDO',     '#,##0.00');
  Formatar('TOTAL_BRUTO_VENDA', '#,##0.00');
  Formatar('TOTAL_VENDA',       '#,##0.00');
end;

procedure TForm_RelatorioVendaProduto.AtualizarProgresso(APercentual: Integer);
begin
  ProgressBarPesquisa.Position := APercentual;
  LabelProgresso.Caption := Format('Executando pesquisa: %d%%', [APercentual]);
  // Update forca o repaint imediato sem reentrar no loop de mensagens.
  ProgressBarPesquisa.Update;
  LabelProgresso.Update;
end;

procedure TForm_RelatorioVendaProduto.DestacarColunaOrdenacao;
var
  lI: Integer;
begin
  // Destaque na coluna da ordenacao principal: Produto.
  for lI := 0 to DBGridVendaProduto.Columns.Count - 1 do
    if SameText(DBGridVendaProduto.Columns[lI].FieldName, 'DESCRICAO_PRODUTO') then
    begin
      DBGridVendaProduto.Columns[lI].Title.Color      := COR_PRIMARY;
      DBGridVendaProduto.Columns[lI].Title.Font.Color := clWhite;
    end
    else
    begin
      DBGridVendaProduto.Columns[lI].Title.Color      := clBtnFace;
      DBGridVendaProduto.Columns[lI].Title.Font.Color := COR_PRIMARY;
    end;
end;

procedure TForm_RelatorioVendaProduto.Pesquisar;
var
  lWhere, lSql: string;
  lCodigoDe, lCodigoAte: Integer;
  lTemDe, lTemAte: Boolean;
  lDataDe, lDataAte: TDateTime;
  lTemDataDe, lTemDataAte: Boolean;
  lCodigoCliente, lCodigoProduto: Integer;
  lTemCodCliente, lTemNomeCliente: Boolean;
  lTemCodProduto, lTemDescProduto: Boolean;
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
      // DATA_HORA_VENDA e timestamp: soma um dia e compara com "menor
      // que" para incluir todas as vendas do dia final informado.
      AQuery.ParamByName('PDATA_ATE').AsDateTime := lDataAte + 1;
    if lSituacao <> '' then
      AQuery.ParamByName('PSITUACAO').AsString := lSituacao;
    if lTemCodCliente then
      AQuery.ParamByName('PCODIGO_CLIENTE').AsInteger := lCodigoCliente
    else if lTemNomeCliente then
      AQuery.ParamByName('PNOME_CLIENTE').AsString :=
        Trim(EditNomeCliente.Text) + '%';
    if lTemCodProduto then
      AQuery.ParamByName('PCODIGO_PRODUTO').AsInteger := lCodigoProduto
    else if lTemDescProduto then
      AQuery.ParamByName('PDESC_PRODUTO').AsString :=
        Trim(EditDescricaoProduto.Text) + '%';
  end;

begin
  if not ValidarFaixaCodigo(lCodigoDe, lCodigoAte, lTemDe, lTemAte) then
    Exit;
  if not ValidarFaixaData(lDataDe, lDataAte, lTemDataDe, lTemDataAte) then
    Exit;

  // Cliente: codigo tem preferencia sobre nome.
  lTemCodCliente  := TryStrToInt(Trim(EditCodigoCliente.Text), lCodigoCliente);
  lTemNomeCliente := (not lTemCodCliente) and (Trim(EditNomeCliente.Text) <> '');

  // Produto: codigo tem preferencia sobre descricao.
  lTemCodProduto  := TryStrToInt(Trim(EditCodigoProduto.Text), lCodigoProduto);
  lTemDescProduto := (not lTemCodProduto) and
                     (Trim(EditDescricaoProduto.Text) <> '');

  case RadioGrupoSituacao.ItemIndex of
    1: lSituacao := 'A';
    2: lSituacao := 'F';
  else
    lSituacao := '';
  end;

  AtualizarProgresso(0);

  // Monta o WHERE somente com os filtros efetivamente preenchidos.
  lWhere :=
    ' from VENDA vc' +
    '  inner join CLIENTE cli    on cli.CODIGO = vc.CODIGO_CLIENTE' +
    '  inner join VENDA_ITEM vi  on vi.CODIGO_VENDA = vc.CODIGO' +
    '  inner join PRODUTO pr     on pr.CODIGO = vi.CODIGO_PRODUTO' +
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
  if lTemCodProduto then
    lWhere := lWhere + ' and vi.CODIGO_PRODUTO = :PCODIGO_PRODUTO'
  else if lTemDescProduto then
    lWhere := lWhere + ' and upper(pr.DESCRICAO) like upper(:PDESC_PRODUTO)';

  // SELECT do relatorio. Uma linha por item; o cabecalho da
  // venda vem repetido em cada item (FastReport agrupa por
  // DESCRICAO_PRODUTO e por CODIGO da venda).
  lSql :=
    'select' +
    '  vc.CODIGO,' +
    '  vc.DATA_HORA_VENDA,' +
    '  cast(vc.DATA_HORA_VENDA as date) as DATA_VENDA,' +
    '  vc.SITUACAO,' +
    '  vc.CODIGO_CLIENTE,' +
    '  cli.NOME as NOME_CLIENTE,' +
    '  vi.CODIGO as CODIGO_ITEM,' +
    '  vi.CODIGO_PRODUTO,' +
    '  pr.DESCRICAO as DESCRICAO_PRODUTO,' +
    '  vi.QUANTIDADE,' +
    '  vi.PRECO_UNITARIO,' +
    '  (vi.TOTAL_LIQUIDO + vi.DESCONTO - vi.ACRESCIMO) as VALOR_BRUTO,' +
    '  vi.DESCONTO,' +
    '  vi.ACRESCIMO,' +
    '  vi.TOTAL_LIQUIDO,' +
    '  vc.TOTAL_BRUTO as TOTAL_BRUTO_VENDA,' +
    '  vc.TOTAL_LIQUIDO as TOTAL_VENDA' +
    lWhere;

  // Vendas por Produto: ordenacao fixa Descricao (+ Data para leitura).
  lSql := lSql +
    ' order by pr.DESCRICAO, vc.DATA_HORA_VENDA, vc.CODIGO, vi.CODIGO';

  // Total de registros esperados: base do calculo do percentual.
  lQueryContagem := TIBQuery.Create(nil);
  try
    lQueryContagem.Database    := QueryVendaProduto.Database;
    lQueryContagem.Transaction := QueryVendaProduto.Transaction;
    lQueryContagem.SQL.Text    := 'select count(*)' + lWhere;
    PreencherParametros(lQueryContagem);
    lQueryContagem.Open;
    lTotal := lQueryContagem.Fields[0].AsInteger;
    lQueryContagem.Close;
  finally
    lQueryContagem.Free;
  end;
  AtualizarProgresso(15);

  QueryVendaProduto.DisableControls;
  try
    QueryVendaProduto.Close;
    QueryVendaProduto.SQL.Text := lSql;
    PreencherParametros(QueryVendaProduto);
    QueryVendaProduto.Open;
    AjustarFormatoCampos;
    AtualizarProgresso(25);

    // Dataset agregado por produto (mesmos filtros) para o grafico de barras.
    // LEGENDA_PRODUTO = "Descricao (xx,x%)" sobre o total liquido filtrado.
    QueryGraficoPorProduto.Close;
    QueryGraficoPorProduto.SQL.Text :=
      'with G as (' +
      '  select' +
      '    pr.CODIGO as CODIGO_PRODUTO,' +
      '    pr.DESCRICAO as DESCRICAO_PRODUTO,' +
      '    sum(vi.TOTAL_LIQUIDO) as TOTAL_PRODUTO' +
      lWhere +
      '  group by pr.CODIGO, pr.DESCRICAO)' +
      'select' +
      '  g.CODIGO_PRODUTO,' +
      '  g.DESCRICAO_PRODUTO,' +
      '  g.TOTAL_PRODUTO,' +
      '  g.DESCRICAO_PRODUTO || '' ('' ||' +
      '    replace(cast(cast(' +
      '      case' +
      '        when (select coalesce(sum(t.TOTAL_PRODUTO), 0) from G t) = 0' +
      '          then 0' +
      '        else g.TOTAL_PRODUTO * 100.00 /' +
      '             (select sum(t.TOTAL_PRODUTO) from G t)' +
      '      end as numeric(15,1)) as varchar(20)), ''.'', '','') ||' +
      '    ''%)'' as LEGENDA_PRODUTO' +
      ' from G g' +
      ' order by g.DESCRICAO_PRODUTO';
    PreencherParametros(QueryGraficoPorProduto);
    QueryGraficoPorProduto.Open;
    AtualizarProgresso(30);

    // Percorre o resultado trazendo os registros do servidor e avancando
    // o percentual proporcionalmente a quantidade ja carregada.
    if lTotal > 0 then
    begin
      lLidos := 0;
      lPasso := lTotal div 20;
      if lPasso < 1 then
        lPasso := 1;
      while not QueryVendaProduto.Eof do
      begin
        Inc(lLidos);
        if (lLidos mod lPasso) = 0 then
          AtualizarProgresso(30 + (lLidos * 65 div lTotal));
        QueryVendaProduto.Next;
      end;
      QueryVendaProduto.First;
    end;

    AtualizarProgresso(100);
    LabelProgresso.Caption := Format('Pesquisa concluida: %d item(ns)',
      [lTotal]);
  finally
    QueryVendaProduto.EnableControls;
  end;

  DestacarColunaOrdenacao;
end;

procedure TForm_RelatorioVendaProduto.BtnPesquisarClick(Sender: TObject);
begin
  Pesquisar;

  if QueryVendaProduto.Active and QueryVendaProduto.IsEmpty then
    MensagemDlg('Nenhuma venda encontrada para os filtros informados.',
      mtInformation, [mbOK], 0);
end;

procedure TForm_RelatorioVendaProduto.BtnLimparClick(Sender: TObject);
begin
  // Volta os filtros ao estado original do formulario.
  EditCodigoDe.Clear;
  EditCodigoAte.Clear;
  EditDataDe.Clear;
  EditDataAte.Clear;
  EditCodigoCliente.Clear;
  EditNomeCliente.Clear;
  EditCodigoProduto.Clear;
  EditDescricaoProduto.Clear;
  RadioGrupoOrdem.ItemIndex    := 0;
  RadioGrupoSituacao.ItemIndex := 0;

  // Refaz a pesquisa sem filtros (lista completa em ordem de data).
  BtnPesquisar.Click;

  // No Limpar o indicador de progresso desaparece, voltando o formulario
  // ao estado original.
  ProgressBarPesquisa.Position := 0;
  LabelProgresso.Caption := '';

  if EditCodigoDe.CanFocus then
    EditCodigoDe.SetFocus;
end;

{ Impressao - layout FastReport na tabela RELATORIO com fallback embutido }

function TForm_RelatorioVendaProduto.LocalizarArquivoFr3: string;
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

procedure TForm_RelatorioVendaProduto.GravarRelatorioNoBanco(const ANome,
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
      lQuery.Database    := QueryVendaProduto.Database;
      lQuery.Transaction := QueryVendaProduto.Transaction;
      // UPDATE OR INSERT: grava na primeira vez e substitui o layout nas
      // execucoes seguintes (versionamento pelo NOME).
      lQuery.SQL.Text :=
        'update or insert into RELATORIO ' +
        '  (NOME, DESCRICAO, ARQUIVO, DATA_ALTERACAO) ' +
        'values ' +
        '  (:PNOME, :PDESCRICAO, :PARQUIVO, CURRENT_TIMESTAMP) ' +
        'matching (NOME)';
      lQuery.ParamByName('PNOME').AsString      := ANome;
      lQuery.ParamByName('PDESCRICAO').AsString :=
        'Relatorio de Vendas por Produto';
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

procedure TForm_RelatorioVendaProduto.GravarRelatorioEmbutidoNoBanco(
  const ANome: string);
var
  lQuery: TIBQuery;
  lStream: TMemoryStream;
begin
  lStream := TMemoryStream.Create;
  try
    frxReportVendaProduto.SaveToStream(lStream);
    lStream.Position := 0;

    lQuery := TIBQuery.Create(nil);
    try
      lQuery.Database    := QueryVendaProduto.Database;
      lQuery.Transaction := QueryVendaProduto.Transaction;
      lQuery.SQL.Text :=
        'update or insert into RELATORIO ' +
        '  (NOME, DESCRICAO, ARQUIVO, DATA_ALTERACAO) ' +
        'values ' +
        '  (:PNOME, :PDESCRICAO, :PARQUIVO, CURRENT_TIMESTAMP) ' +
        'matching (NOME)';
      lQuery.ParamByName('PNOME').AsString      := ANome;
      lQuery.ParamByName('PDESCRICAO').AsString :=
        'Relatorio de Vendas por Produto';
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

procedure TForm_RelatorioVendaProduto.SincronizarLayoutFr3NoBanco;
var
  lCaminhoFr3: string;
begin
  lCaminhoFr3 := LocalizarArquivoFr3;
  if lCaminhoFr3 = '' then
    Exit;

  GravarRelatorioNoBanco(NOME_RELATORIO_VENDA_PRODUTO, lCaminhoFr3);
end;

function TForm_RelatorioVendaProduto.CarregarRelatorioDoBanco(
  const ANome: string; AStream: TStream): Boolean;
var
  lQuery: TIBQuery;
begin
  lQuery := TIBQuery.Create(nil);
  try
    lQuery.Database    := QueryVendaProduto.Database;
    lQuery.Transaction := QueryVendaProduto.Transaction;
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

function TForm_RelatorioVendaProduto.DescricaoFiltros: string;

  procedure Acrescentar(const ATexto: string);
  begin
    if Result <> '' then
      Result := Result + '  |  ';
    Result := Result + ATexto;
  end;

begin
  Result := '';

  Acrescentar('Ordem: Descricao do produto');

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
  if Trim(EditCodigoProduto.Text) <> '' then
    Acrescentar('Produto cod.: ' + Trim(EditCodigoProduto.Text))
  else if Trim(EditDescricaoProduto.Text) <> '' then
    Acrescentar('Produto: ' + Trim(EditDescricaoProduto.Text));

  if Result = '' then
    Result := 'Todos os registros';
end;

procedure TForm_RelatorioVendaProduto.AplicarCabecalhoRelatorio;
var
  lMemo: TfrxMemoView;
  lTitle: TfrxBand;
  lI: Integer;

  function GarantirMemo(const ANome: string; ALeft, ATop, AWidth,
    AHeight: Extended): TfrxMemoView;
  begin
    Result := frxReportVendaProduto.FindObject(ANome) as TfrxMemoView;
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
  lTitle := frxReportVendaProduto.FindObject('ReportTitle1') as TfrxBand;

  for lI := Low(MEMOS_CABECALHO_LEGADO) to High(MEMOS_CABECALHO_LEGADO) do
  begin
    lMemo := frxReportVendaProduto.FindObject(MEMOS_CABECALHO_LEGADO[lI])
      as TfrxMemoView;
    if Assigned(lMemo) then
      lMemo.Visible := False;
  end;

  // Reposiciona dentro da largura util da pagina A4 (~718).
  PosicionarCabecalho('MemoDataLabel',   560, 3.77953,  55, 'Data....:', False);
  PosicionarCabecalho('MemoDataValor',   618, 3.77953,  95, '[Date]', True);
  PosicionarCabecalho('MemoHoraLabel',   560, 22.67718, 55, 'Hora....:', False);
  PosicionarCabecalho('MemoHoraValor',   618, 22.67718, 95, '[Time]', True);
  PosicionarCabecalho('MemoPaginaLabel', 560, 41.57483, 55, 'P'#225'gina.:', False);
  PosicionarCabecalho('MemoPaginaValor', 618, 41.57483, 95,
    '[Page#]/[TotalPages#]', True);

  lMemo := frxReportVendaProduto.FindObject('MemoDataValor') as TfrxMemoView;
  if Assigned(lMemo) then
  begin
    lMemo.DisplayFormat.Kind := fkDateTime;
    lMemo.DisplayFormat.FormatStr := 'dd/mm/yyyy';
  end;

  lMemo := frxReportVendaProduto.FindObject('MemoHoraValor') as TfrxMemoView;
  if Assigned(lMemo) then
  begin
    lMemo.DisplayFormat.Kind := fkDateTime;
    lMemo.DisplayFormat.FormatStr := 'hh:mm:ss';
  end;

  lMemo := frxReportVendaProduto.FindObject('MemoFiltroValor') as TfrxMemoView;
  if Assigned(lMemo) then
  begin
    lMemo.Width := 500;
    lMemo.Text := DescricaoFiltros;
  end;

  // Titulo completo (evita corte "Relatorio de Venda por").
  lMemo := frxReportVendaProduto.FindObject('MemoTituloRelatorio') as TfrxMemoView;
  if Assigned(lMemo) then
  begin
    lMemo.Left := 160;
    lMemo.Width := 390;
    lMemo.HAlign := haCenter;
    lMemo.WordWrap := False;
    lMemo.Text := 'Relat'#243'rio de Venda por Produto';
  end;
end;

procedure TForm_RelatorioVendaProduto.ConfigurarGraficoBarrasPorProduto;
var
  lChart: TfrxChartView;
  lSerie: TfrxSeriesItem;
  lBand: TfrxBand;
  lMemo: TfrxMemoView;
  lComp: TfrxComponent;
begin
  // Garante o dataset do grafico no relatorio apos LoadFromFile/Stream.
  if frxReportVendaProduto.DataSets.Find(frxDBDatasetGraficoPorProduto) = nil then
    frxReportVendaProduto.DataSets.Add(frxDBDatasetGraficoPorProduto);

  lMemo := frxReportVendaProduto.FindObject('MemoTituloGrafico') as TfrxMemoView;
  if Assigned(lMemo) then
    lMemo.Text := 'Grafico de barras 3D - total liquido por produto';

  // Remove grafico antigo (pizza/barras) para nao reaproveitar serie csPie.
  lComp := frxReportVendaProduto.FindObject('ChartPizzaPorProduto');
  if Assigned(lComp) then
    lComp.Free;
  lComp := frxReportVendaProduto.FindObject('ChartBarrasPorProduto');
  if Assigned(lComp) then
    lComp.Free;

  lBand := frxReportVendaProduto.FindObject('ReportSummary1') as TfrxBand;
  if not Assigned(lBand) then
    Exit;
  if lBand.Height < 380 then
    lBand.Height := 380;

  lChart := TfrxChartView.Create(lBand);
  lChart.Name := 'ChartBarrasPorProduto';
  lChart.Left := 3.77953;
  lChart.Top := 94;
  lChart.Width := 710;
  lChart.Height := 280;

  lChart.ClearSeries;
  lChart.AddSeries(csBar);
  if lChart.SeriesData.Count = 0 then
    Exit;

  lSerie := lChart.SeriesData[0];
  lSerie.DataType := dtDBData;
  lSerie.DataSet := frxDBDatasetGraficoPorProduto;
  lSerie.DataSetName := 'frxDBDatasetGraficoPorProduto';
  lSerie.XType := xtText;
  lSerie.Source1 := '<frxDBDatasetGraficoPorProduto."LEGENDA_PRODUTO">';
  lSerie.Source2 := '<frxDBDatasetGraficoPorProduto."TOTAL_PRODUTO">';

  if Assigned(lChart.Chart) then
  begin
    lChart.Chart.Title.Text.Text := 'Total liquido por produto';
    lChart.Chart.Title.Visible := True;
    lChart.Chart.Title.Font.Name := 'Arial';
    lChart.Chart.Title.Font.Size := 8;
    lChart.Chart.View3D := True;
    lChart.Chart.Legend.Visible := False;
    lChart.Chart.BottomAxis.LabelsFont.Name := 'Arial';
    lChart.Chart.BottomAxis.LabelsFont.Size := 5;
    lChart.Chart.LeftAxis.LabelsFont.Name := 'Arial';
    lChart.Chart.LeftAxis.LabelsFont.Size := 5;
    if lChart.Chart.SeriesCount > 0 then
    begin
      lChart.Chart.Series[0].Title := 'Total liquido';
      lChart.Chart.Series[0].ColorEachPoint := True;
      lChart.Chart.Series[0].Marks.Visible := True;
      lChart.Chart.Series[0].Marks.Transparent := True;
      lChart.Chart.Series[0].Marks.Font.Name := 'Arial';
      lChart.Chart.Series[0].Marks.Font.Size := 4;
    end;
  end;
end;

procedure TForm_RelatorioVendaProduto.ExibirRelatorio;
var
  lStream: TMemoryStream;
  lCaminhoFr3: string;
begin
  frxReportVendaProduto.EngineOptions.DoublePass := True;

  lStream := TMemoryStream.Create;
  try
    // Prioriza o .fr3 em disco (fonte da verdade) e grava na RELATORIO.
    // Assim alteracoes de layout (quebra, titulo, etc.) sobrescrevem o BLOB antigo.
    lCaminhoFr3 := LocalizarArquivoFr3;
    if lCaminhoFr3 <> '' then
    begin
      frxReportVendaProduto.LoadFromFile(lCaminhoFr3);
      GravarRelatorioNoBanco(NOME_RELATORIO_VENDA_PRODUTO, lCaminhoFr3);
    end
    else if CarregarRelatorioDoBanco(NOME_RELATORIO_VENDA_PRODUTO, lStream) then
      frxReportVendaProduto.LoadFromStream(lStream)
    else
    begin
      MensagemDlg('Nao foi possivel carregar o relatorio "' +
        NOME_RELATORIO_VENDA_PRODUTO +
        '" (arquivo .fr3 e tabela RELATORIO).',
        mtError, [mbOK], 0);
      Exit;
    end;

    AplicarCabecalhoRelatorio;
    ConfigurarGraficoBarrasPorProduto;
    // Persiste o layout ja corrigido (cabecalho + grafico barras 3D) na tabela.
    GravarRelatorioEmbutidoNoBanco(NOME_RELATORIO_VENDA_PRODUTO);
    TRelatorioExportacaoFast.VincularExportacoes(frxReportVendaProduto,
      frxExportPDF, frxExportExcel, frxExportWord, frxExportCSV);
    frxReportVendaProduto.ShowReport;
  finally
    lStream.Free;
  end;
end;

procedure TForm_RelatorioVendaProduto.BtnImprimirClick(Sender: TObject);
begin
  if not QueryVendaProduto.Active or QueryVendaProduto.IsEmpty then
  begin
    MensagemDlg('Nao ha vendas para imprimir. Utilize o botao ' +
      'Pesquisar primeiro.', mtInformation, [mbOK], 0);
    Exit;
  end;

  // Impressao via FastReport: layout do banco/disco/embutido, dados da
  // QueryVendaProduto (ja filtrada pela pesquisa).
  try
    ExibirRelatorio;
  except
    on E: Exception do
      MensagemDlg('Erro ao abrir o relatorio.' + sLineBreak + E.Message,
        mtError, [mbOK], 0);
  end;
end;

procedure TForm_RelatorioVendaProduto.BtnSairClick(Sender: TObject);
begin
  Close;
end;

end.
