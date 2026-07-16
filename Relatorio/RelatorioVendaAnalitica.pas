unit RelatorioVendaAnalitica;

{ Relatorio de Vendas Analitico (mestre x detalhe).

  Estrutura mestre/detalhe montada por uma unica consulta com joins:

    VENDA (mestre)  ->  VENDA_ITEM (detalhe)
      + CLIENTE (nome do cliente)
      + PRODUTO (descricao do produto)

  Filtros disponiveis:
    1 - Ordem do resultado: por Data, por Codigo da venda ou alfabetica
        (nome do cliente);
    2 - Situacao da venda: Todas (padrao), Abertas ou Fechadas;
    3 - Faixa de codigo da venda (inicial/final);
    4 - Faixa de data da venda (inicial/final), dd/mm/yyyy;
    5 - Cliente: por codigo ou por nome (with lookup - lupa abrindo
        ConsultaCliente);
    6 - Produto: por codigo ou por descricao (with lookup - lupa abrindo
        ConsultaProduto).

  Quando ambos "codigo" e "texto" estao preenchidos para cliente ou
  produto, o codigo tem preferencia (mais especifico).

  O botao Pesquisar monta a QueryVendaAnalitica com os filtros informados
  e atualiza o DBGridVendaMestreDetalhe, exibindo o percentual da tarefa.
  A impressao usa o FastReport com o layout guardado na tabela RELATORIO
  (campo BLOB ARQUIVO); caso nem o banco nem o arquivo em disco tenham
  o layout, o layout embutido no proprio TfrxReport (dfm) e usado.

  Quebras/subtotais do relatorio:
    - Detalhe (por venda): soma VALOR_BRUTO, DESCONTO, ACRESCIMO,
      TOTAL_LIQUIDO dos itens.
    - Subtotal por dia (DATA_VENDA): idem, agregado no dia.
    - Total geral (Mestre): TOTAL_BRUTO e TOTAL_LIQUIDO da venda +
      quantidade de vendas impressas (acumulado via script no rodape
      de grupo da venda, evitando duplicacao).
    - Grafico de barras no rodape: total liquido por dia
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
  NOME_RELATORIO_VENDA_ANALITICA = 'Relatorio_Venda_Analitica';
  ARQUIVO_FR3                    = 'RelatorioVendasAnalitico.fr3';
  PASTA_FR3          = 'C:\Avaliacao Delphi_Firebird\Andre_luis\Projeto\Fr3';
  PASTA_FR3_RELATIVA = 'Fr3';

type
  TForm_RelatorioVendaAnalitica = class(TForm)
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

    DBGridVendaMestreDetalhe: TDBGrid;

    PanelRodape: TPanel;
    BtnPesquisar: TBitBtn;
    BtnLimpar: TBitBtn;
    BtnImprimir: TBitBtn;
    BtnSair: TBitBtn;

    QueryVendaAnalitica: TIBQuery;
    DsVendaAnalitica: TDataSource;
    frxDBDatasetVendaAnalitica: TfrxDBDataset;
    QueryGraficoPorDia: TIBQuery;
    frxDBDatasetGraficoPorDia: TfrxDBDataset;
    frxReportVendaAnalitica: TfrxReport;
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
    procedure DBGridVendaMestreDetalheDrawColumnCell(Sender: TObject;
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
    procedure ConfigurarGraficoBarrasPorDia;
    procedure ExibirRelatorio;
  public
    { Public declarations }
  end;

var
  Form_RelatorioVendaAnalitica: TForm_RelatorioVendaAnalitica;

implementation

uses DataModule, Mensagens, ConsultaCliente, ConsultaProduto,
  RelatorioExportacaoFast, UITheme;

{$R *.dfm}

{ Utilitarios visuais (mesmo padrao do RelatorioVenda sintetico) }

procedure TForm_RelatorioVendaAnalitica.ConfigurarGlyphsBotoes;
begin
  AplicarBotaoBootstrap(BtnPesquisar, bbkOutline, ICN_PESQUISA);
  AplicarBotaoBootstrap(BtnLimpar, bbkOutline, ICN_LIMPAR);
  AplicarBotaoBootstrap(BtnImprimir, bbkPrimary, ICN_IMPRIMIR);
  AplicarBotaoBootstrap(BtnSair, bbkSecondary, ICN_SAIR);
  AplicarBotaoBootstrap(BtnLupaCliente, bbkOutline, ICN_LUPA);
  AplicarBotaoBootstrap(BtnLupaProduto, bbkOutline, ICN_LUPA);
end;

{ Ciclo de vida }

procedure TForm_RelatorioVendaAnalitica.FormCreate(Sender: TObject);
begin
  Color := COR_PAGE;
  AplicarHeaderPrimary(Panel_Titulo);
  AplicarFormEstiloWeb(Self);
  AplicarPainelCard(PanelFiltros);
  ConfigurarGlyphsBotoes;
  TRelatorioExportacaoFast.VincularExportacoes(frxReportVendaAnalitica,
    frxExportPDF, frxExportExcel, frxExportWord, frxExportCSV);
  SincronizarLayoutFr3NoBanco;

  // Abre listando todas as vendas na ordem padrao (por Data).
  Pesquisar;
end;

procedure TForm_RelatorioVendaAnalitica.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  QueryVendaAnalitica.Close;
  QueryGraficoPorDia.Close;
  Action := caFree;
  Form_RelatorioVendaAnalitica := nil;
end;

{ Navegacao por teclado }

procedure TForm_RelatorioVendaAnalitica.FormKeyDown(Sender: TObject;
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

procedure TForm_RelatorioVendaAnalitica.EditFocoEnter(Sender: TObject);
begin
  if Sender is TEdit then
    TEdit(Sender).Color := COR_EDIT_FOCO;
end;

procedure TForm_RelatorioVendaAnalitica.EditFocoExit(Sender: TObject);
begin
  if Sender is TEdit then
    TEdit(Sender).Color := COR_EDIT_NORMAL;
end;

procedure TForm_RelatorioVendaAnalitica.EditNumericoKeyPress(Sender: TObject;
  var Key: Char);
begin
  // Campos numericos aceitam apenas digitos (e backspace).
  if not CharInSet(Key, ['0'..'9', #8]) then
    Key := #0;
end;

procedure TForm_RelatorioVendaAnalitica.EditDataKeyPress(Sender: TObject;
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

procedure TForm_RelatorioVendaAnalitica.DBGridVendaMestreDetalheDrawColumnCell(
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

procedure TForm_RelatorioVendaAnalitica.BtnLupaClienteClick(Sender: TObject);
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

procedure TForm_RelatorioVendaAnalitica.BtnLupaProdutoClick(Sender: TObject);
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

function TForm_RelatorioVendaAnalitica.ValidarFaixaCodigo(out ACodigoDe,
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

function TForm_RelatorioVendaAnalitica.ValidarFaixaData(out ADataDe,
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

procedure TForm_RelatorioVendaAnalitica.AjustarFormatoCampos;

  procedure Formatar(const ANomeCampo, AFormato: string);
  var
    lFld: TField;
  begin
    lFld := QueryVendaAnalitica.FindField(ANomeCampo);
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

procedure TForm_RelatorioVendaAnalitica.AtualizarProgresso(APercentual: Integer);
begin
  ProgressBarPesquisa.Position := APercentual;
  LabelProgresso.Caption := Format('Executando pesquisa: %d%%', [APercentual]);
  // Update forca o repaint imediato sem reentrar no loop de mensagens.
  ProgressBarPesquisa.Update;
  LabelProgresso.Update;
end;

procedure TForm_RelatorioVendaAnalitica.DestacarColunaOrdenacao;
var
  lI: Integer;
  lCampoOrdem: string;
begin
  // Campo de ordenacao escolhido no Filtro 1 (radio).
  case RadioGrupoOrdem.ItemIndex of
    1: lCampoOrdem := 'CODIGO';
    2: lCampoOrdem := 'NOME_CLIENTE';
  else
    lCampoOrdem := 'DATA_HORA_VENDA';
  end;

  // Titulo da coluna ordenada em destaque (invertido: fundo navy, texto
  // branco); as demais voltam ao visual padrao.
  for lI := 0 to DBGridVendaMestreDetalhe.Columns.Count - 1 do
    if SameText(DBGridVendaMestreDetalhe.Columns[lI].FieldName, lCampoOrdem) then
    begin
      DBGridVendaMestreDetalhe.Columns[lI].Title.Color      := COR_PRIMARY;
      DBGridVendaMestreDetalhe.Columns[lI].Title.Font.Color := clWhite;
    end
    else
    begin
      DBGridVendaMestreDetalhe.Columns[lI].Title.Color      := clBtnFace;
      DBGridVendaMestreDetalhe.Columns[lI].Title.Font.Color := COR_PRIMARY;
    end;
end;

procedure TForm_RelatorioVendaAnalitica.Pesquisar;
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

  // SELECT do relatorio analitico. Uma linha por item; o cabecalho da
  // venda vem repetido em cada item (FastReport agrupa por CODIGO da
  // venda e por DATA_VENDA - ver script no rodape do grupo de venda).
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

  case RadioGrupoOrdem.ItemIndex of
    1: lSql := lSql + ' order by vc.CODIGO, vi.CODIGO';
    2: lSql := lSql + ' order by cli.NOME, vc.CODIGO, vi.CODIGO';
  else
    lSql := lSql + ' order by vc.DATA_HORA_VENDA, vc.CODIGO, vi.CODIGO';
  end;

  // Total de registros esperados: base do calculo do percentual.
  lQueryContagem := TIBQuery.Create(nil);
  try
    lQueryContagem.Database    := QueryVendaAnalitica.Database;
    lQueryContagem.Transaction := QueryVendaAnalitica.Transaction;
    lQueryContagem.SQL.Text    := 'select count(*)' + lWhere;
    PreencherParametros(lQueryContagem);
    lQueryContagem.Open;
    lTotal := lQueryContagem.Fields[0].AsInteger;
    lQueryContagem.Close;
  finally
    lQueryContagem.Free;
  end;
  AtualizarProgresso(15);

  QueryVendaAnalitica.DisableControls;
  try
    QueryVendaAnalitica.Close;
    QueryVendaAnalitica.SQL.Text := lSql;
    PreencherParametros(QueryVendaAnalitica);
    QueryVendaAnalitica.Open;
    AjustarFormatoCampos;
    AtualizarProgresso(25);

    // Dataset agregado por dia (mesmos filtros) para o grafico de barras.
    QueryGraficoPorDia.Close;
    QueryGraficoPorDia.SQL.Text :=
      'select' +
      '  cast(vc.DATA_HORA_VENDA as date) as DATA_VENDA,' +
      '  sum(vi.TOTAL_LIQUIDO) as TOTAL_DIA' +
      lWhere +
      ' group by cast(vc.DATA_HORA_VENDA as date)' +
      ' order by 1';
    PreencherParametros(QueryGraficoPorDia);
    QueryGraficoPorDia.Open;
    AtualizarProgresso(30);

    // Percorre o resultado trazendo os registros do servidor e avancando
    // o percentual proporcionalmente a quantidade ja carregada.
    if lTotal > 0 then
    begin
      lLidos := 0;
      lPasso := lTotal div 20;
      if lPasso < 1 then
        lPasso := 1;
      while not QueryVendaAnalitica.Eof do
      begin
        Inc(lLidos);
        if (lLidos mod lPasso) = 0 then
          AtualizarProgresso(30 + (lLidos * 65 div lTotal));
        QueryVendaAnalitica.Next;
      end;
      QueryVendaAnalitica.First;
    end;

    AtualizarProgresso(100);
    LabelProgresso.Caption := Format('Pesquisa concluida: %d item(ns)',
      [lTotal]);
  finally
    QueryVendaAnalitica.EnableControls;
  end;

  DestacarColunaOrdenacao;
end;

procedure TForm_RelatorioVendaAnalitica.BtnPesquisarClick(Sender: TObject);
begin
  Pesquisar;

  if QueryVendaAnalitica.Active and QueryVendaAnalitica.IsEmpty then
    MensagemDlg('Nenhuma venda encontrada para os filtros informados.',
      mtInformation, [mbOK], 0);
end;

procedure TForm_RelatorioVendaAnalitica.BtnLimparClick(Sender: TObject);
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

function TForm_RelatorioVendaAnalitica.LocalizarArquivoFr3: string;
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

procedure TForm_RelatorioVendaAnalitica.GravarRelatorioNoBanco(const ANome,
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
      lQuery.Database    := QueryVendaAnalitica.Database;
      lQuery.Transaction := QueryVendaAnalitica.Transaction;
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
        'Relatorio de Vendas Analitico';
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

procedure TForm_RelatorioVendaAnalitica.GravarRelatorioEmbutidoNoBanco(
  const ANome: string);
var
  lQuery: TIBQuery;
  lStream: TMemoryStream;
begin
  lStream := TMemoryStream.Create;
  try
    frxReportVendaAnalitica.SaveToStream(lStream);
    lStream.Position := 0;

    lQuery := TIBQuery.Create(nil);
    try
      lQuery.Database    := QueryVendaAnalitica.Database;
      lQuery.Transaction := QueryVendaAnalitica.Transaction;
      lQuery.SQL.Text :=
        'update or insert into RELATORIO ' +
        '  (NOME, DESCRICAO, ARQUIVO, DATA_ALTERACAO) ' +
        'values ' +
        '  (:PNOME, :PDESCRICAO, :PARQUIVO, CURRENT_TIMESTAMP) ' +
        'matching (NOME)';
      lQuery.ParamByName('PNOME').AsString      := ANome;
      lQuery.ParamByName('PDESCRICAO').AsString :=
        'Relatorio de Vendas Analitico';
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

procedure TForm_RelatorioVendaAnalitica.SincronizarLayoutFr3NoBanco;
var
  lCaminhoFr3: string;
begin
  lCaminhoFr3 := LocalizarArquivoFr3;
  if lCaminhoFr3 = '' then
    Exit;

  GravarRelatorioNoBanco(NOME_RELATORIO_VENDA_ANALITICA, lCaminhoFr3);
end;

function TForm_RelatorioVendaAnalitica.CarregarRelatorioDoBanco(
  const ANome: string; AStream: TStream): Boolean;
var
  lQuery: TIBQuery;
begin
  lQuery := TIBQuery.Create(nil);
  try
    lQuery.Database    := QueryVendaAnalitica.Database;
    lQuery.Transaction := QueryVendaAnalitica.Transaction;
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

function TForm_RelatorioVendaAnalitica.DescricaoFiltros: string;

  procedure Acrescentar(const ATexto: string);
  begin
    if Result <> '' then
      Result := Result + '  |  ';
    Result := Result + ATexto;
  end;

begin
  Result := '';

  case RadioGrupoOrdem.ItemIndex of
    1: Acrescentar('Ordem: Codigo');
    2: Acrescentar('Ordem: Alfabetica (Cliente)');
  else
    Acrescentar('Ordem: Data');
  end;

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

procedure TForm_RelatorioVendaAnalitica.AplicarCabecalhoRelatorio;
var
  lMemo: TfrxMemoView;
  lTitle: TfrxBand;
  lI: Integer;

  function GarantirMemo(const ANome: string; ALeft, ATop, AWidth,
    AHeight: Extended): TfrxMemoView;
  begin
    Result := frxReportVendaAnalitica.FindObject(ANome) as TfrxMemoView;
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
  lTitle := frxReportVendaAnalitica.FindObject('ReportTitle1') as TfrxBand;

  for lI := Low(MEMOS_CABECALHO_LEGADO) to High(MEMOS_CABECALHO_LEGADO) do
  begin
    lMemo := frxReportVendaAnalitica.FindObject(MEMOS_CABECALHO_LEGADO[lI])
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

  lMemo := frxReportVendaAnalitica.FindObject('MemoDataValor') as TfrxMemoView;
  if Assigned(lMemo) then
  begin
    lMemo.DisplayFormat.Kind := fkDateTime;
    lMemo.DisplayFormat.FormatStr := 'dd/mm/yyyy';
  end;

  lMemo := frxReportVendaAnalitica.FindObject('MemoHoraValor') as TfrxMemoView;
  if Assigned(lMemo) then
  begin
    lMemo.DisplayFormat.Kind := fkDateTime;
    lMemo.DisplayFormat.FormatStr := 'hh:mm:ss';
  end;

  lMemo := frxReportVendaAnalitica.FindObject('MemoFiltroValor') as TfrxMemoView;
  if Assigned(lMemo) then
  begin
    lMemo.Width := 500;
    lMemo.Text := DescricaoFiltros;
  end;
end;

procedure TForm_RelatorioVendaAnalitica.ConfigurarGraficoBarrasPorDia;
var
  lChart: TfrxChartView;
  lSerie: TfrxSeriesItem;
  lBand: TfrxBand;
begin
  // Garante o dataset do grafico no relatorio apos LoadFromStream.
  if frxReportVendaAnalitica.DataSets.Find(frxDBDatasetGraficoPorDia) = nil then
    frxReportVendaAnalitica.DataSets.Add(frxDBDatasetGraficoPorDia);

  lChart := frxReportVendaAnalitica.FindObject('ChartBarrasPorDia') as TfrxChartView;
  if not Assigned(lChart) then
  begin
    lBand := frxReportVendaAnalitica.FindObject('ReportSummary1') as TfrxBand;
    if not Assigned(lBand) then
      Exit;

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

procedure TForm_RelatorioVendaAnalitica.ExibirRelatorio;
var
  lStream: TMemoryStream;
begin
  frxReportVendaAnalitica.EngineOptions.DoublePass := True;
  SincronizarLayoutFr3NoBanco;

  lStream := TMemoryStream.Create;
  try
    if not CarregarRelatorioDoBanco(NOME_RELATORIO_VENDA_ANALITICA, lStream) then
    begin
      MensagemDlg('Nao foi possivel carregar o relatorio "' +
        NOME_RELATORIO_VENDA_ANALITICA + '" da tabela RELATORIO.',
        mtError, [mbOK], 0);
      Exit;
    end;

    frxReportVendaAnalitica.LoadFromStream(lStream);
    AplicarCabecalhoRelatorio;
    ConfigurarGraficoBarrasPorDia;
    // Persiste o layout ja corrigido (Data/Hora/Pagina + grafico) na tabela.
    GravarRelatorioEmbutidoNoBanco(NOME_RELATORIO_VENDA_ANALITICA);
    TRelatorioExportacaoFast.VincularExportacoes(frxReportVendaAnalitica,
      frxExportPDF, frxExportExcel, frxExportWord, frxExportCSV);
    frxReportVendaAnalitica.ShowReport;
  finally
    lStream.Free;
  end;
end;

procedure TForm_RelatorioVendaAnalitica.BtnImprimirClick(Sender: TObject);
begin
  if not QueryVendaAnalitica.Active or QueryVendaAnalitica.IsEmpty then
  begin
    MensagemDlg('Nao ha vendas para imprimir. Utilize o botao ' +
      'Pesquisar primeiro.', mtInformation, [mbOK], 0);
    Exit;
  end;

  // Impressao via FastReport: layout do banco/disco/embutido, dados da
  // QueryVendaAnalitica (ja filtrada pela pesquisa).
  try
    ExibirRelatorio;
  except
    on E: Exception do
      MensagemDlg('Erro ao abrir o relatorio.' + sLineBreak + E.Message,
        mtError, [mbOK], 0);
  end;
end;

procedure TForm_RelatorioVendaAnalitica.BtnSairClick(Sender: TObject);
begin
  Close;
end;

end.
