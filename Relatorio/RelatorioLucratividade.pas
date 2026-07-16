unit RelatorioLucratividade;

{ Filtro para Relatorio de Lucratividade (mesmas regras do RelatorioProduto).

  Campos: CODIGO, DESCRICAO, ESTOQUE_ATUAL, PRECO_CUSTO, PRECO_VENDA,
  MARGEM_LUCRO, LUCRO_PRODUTO, TOTAL_CUSTO_ESTOQUE, TOTAL_VENDA_ESTOQUE. }

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
  NOME_RELATORIO_LUCRATIVIDADE = 'RELATORIO_LUCRATIVIDADE';
  ARQUIVO_FR3                   = 'Relatorio_Lucratividade.fr3';
  PASTA_FR3              = 'C:\Avaliacao Delphi_Firebird\Andre_luis\Projeto\Fr3';
  PASTA_FR3_RELATIVA     = 'Fr3';

type
  TForm_RelatorioLucratividade = class(TForm)
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

    DBGridLucratividade: TDBGrid;

    PanelRodape: TPanel;
    BtnPesquisar: TBitBtn;
    BtnLimpar: TBitBtn;
    BtnImprimir: TBitBtn;
    BtnSair: TBitBtn;

    QueryLucratividade: TIBQuery;
    DsLucratividade: TDataSource;
    frxDBDatasetLucratividade: TfrxDBDataset;
    frxReportLucratividade: TfrxReport;
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
    procedure DBGridLucratividadeDrawColumnCell(Sender: TObject;
      const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);
    procedure BtnPesquisarClick(Sender: TObject);
    procedure BtnLimparClick(Sender: TObject);
    procedure BtnImprimirClick(Sender: TObject);
    procedure BtnSairClick(Sender: TObject);
  private
    FQtdItens: Integer;
    FTotalCusto: Double;
    FTotalVenda: Double;
    FTotalLucro: Double;
    FMargemTotal: Double;
    FLinhaZebra: Integer;
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
    function CarregarRelatorioDoBanco(const ANome: string;
      Stream: TStream): Boolean;
    function DescricaoFiltros: string;
    procedure AplicarCabecalhoRelatorio;
    procedure AplicarTotaisRelatorio;
    procedure PrepararLayoutParaImpressao;
    function CampoFloatSeguro(const ANomeCampo: string): Double;
    function CampoStringSeguro(const ANomeCampo: string): string;
    procedure frxReportLucratividadeBeforePrint(Sender: TfrxReportComponent);
    procedure ExibirRelatorio;
  public
    { Public declarations }
  end;

var
  Form_RelatorioLucratividade: TForm_RelatorioLucratividade;

implementation

uses DataModule, Mensagens, RelatorioExportacaoFast, UITheme;

{$R *.dfm}

{ Utilitarios visuais (mesmo padrao do RelatorioCliente) }

procedure TForm_RelatorioLucratividade.ConfigurarGlyphsBotoes;
begin
  AplicarBotaoBootstrap(BtnPesquisar, bbkOutline, ICN_PESQUISA);
  AplicarBotaoBootstrap(BtnLimpar, bbkOutline, ICN_LIMPAR);
  AplicarBotaoBootstrap(BtnImprimir, bbkPrimary, ICN_IMPRIMIR);
  AplicarBotaoBootstrap(BtnSair, bbkSecondary, ICN_SAIR);
end;

{ Ciclo de vida }

procedure TForm_RelatorioLucratividade.FormCreate(Sender: TObject);
var
  CaminhoFr3: string;
begin
  FQtdItens := 0;
  FTotalCusto := 0;
  FTotalVenda := 0;
  FTotalLucro := 0;
  FMargemTotal := 0;
  FLinhaZebra := 0;

  Color := COR_PAGE;
  AplicarHeaderPrimary(Panel_Titulo);
  AplicarFormEstiloWeb(Self);
  AplicarPainelCard(PanelFiltros);
  ConfigurarGlyphsBotoes;
  TRelatorioExportacaoFast.VincularExportacoes(frxReportLucratividade, frxExportPDF,
    frxExportExcel, frxExportWord, frxExportCSV);
  frxReportLucratividade.OnBeforePrint := frxReportLucratividadeBeforePrint;

  CaminhoFr3 := LocalizarArquivoFr3;
  if CaminhoFr3 <> '' then
  begin
    frxReportLucratividade.LoadFromFile(CaminhoFr3);
    PrepararLayoutParaImpressao;
    GravarRelatorioEmbutidoNoBanco(NOME_RELATORIO_LUCRATIVIDADE);
  end
  else
    SincronizarLayoutFr3NoBanco;

  Pesquisar;
end;

procedure TForm_RelatorioLucratividade.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  QueryLucratividade.Close;
  Action := caFree;
  Form_RelatorioLucratividade := nil;
end;

{ Navegacao por teclado }

procedure TForm_RelatorioLucratividade.FormKeyDown(Sender: TObject; var Key: Word;
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

procedure TForm_RelatorioLucratividade.EditFocoEnter(Sender: TObject);
begin
  if Sender is TEdit then
    TEdit(Sender).Color := COR_EDIT_FOCO;
end;

procedure TForm_RelatorioLucratividade.EditFocoExit(Sender: TObject);
begin
  if Sender is TEdit then
    TEdit(Sender).Color := COR_EDIT_NORMAL;
end;

procedure TForm_RelatorioLucratividade.EditNumericoKeyPress(Sender: TObject;
  var Key: Char);
begin
  // Faixa de codigo aceita apenas digitos (e backspace).
  if not CharInSet(Key, ['0'..'9', #8]) then
    Key := #0;
end;

{ Grid - linhas com cores alternadas (zebra) }

procedure TForm_RelatorioLucratividade.DBGridLucratividadeDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
var
  Grid: TDBGrid;
begin
  Grid := TDBGrid(Sender);

  if not Assigned(Grid.DataSource) or not Assigned(Grid.DataSource.DataSet) or
     not Grid.DataSource.DataSet.Active or Grid.DataSource.DataSet.IsEmpty then
  begin
    Grid.DefaultDrawColumnCell(Rect, DataCol, Column, State);
    Exit;
  end;

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

function TForm_RelatorioLucratividade.ValidarFaixaCodigo(out ACodigoDe,
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

procedure TForm_RelatorioLucratividade.AjustarFormatoCampos;

  procedure Formatar(const NomeCampo, Formato: string);
  var
    Fld: TField;
  begin
    Fld := QueryLucratividade.FindField(NomeCampo);
    if Fld is TNumericField then
      TNumericField(Fld).DisplayFormat := Formato;
  end;

begin
  Formatar('ESTOQUE_ATUAL',       '#,##0.000');
  Formatar('PRECO_CUSTO',         '#,##0.00');
  Formatar('PRECO_VENDA',         '#,##0.00');
  Formatar('MARGEM_LUCRO',        '#,##0.00');
  Formatar('LUCRO_PRODUTO',       '#,##0.00');
  Formatar('TOTAL_CUSTO_ESTOQUE', '#,##0.00');
  Formatar('TOTAL_VENDA_ESTOQUE', '#,##0.00');
end;

procedure TForm_RelatorioLucratividade.AtualizarProgresso(Percentual: Integer);
begin
  ProgressBarPesquisa.Position := Percentual;
  LabelProgresso.Caption := Format('Executando pesquisa: %d%%', [Percentual]);
  // Update forca o repaint imediato sem reentrar no loop de mensagens.
  ProgressBarPesquisa.Update;
  LabelProgresso.Update;
end;

procedure TForm_RelatorioLucratividade.DestacarColunaOrdenacao;
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
  for I := 0 to DBGridLucratividade.Columns.Count - 1 do
    if SameText(DBGridLucratividade.Columns[I].FieldName, CampoOrdem) then
    begin
      DBGridLucratividade.Columns[I].Title.Color      := COR_PRIMARY;
      DBGridLucratividade.Columns[I].Title.Font.Color := clWhite;
    end
    else
    begin
      DBGridLucratividade.Columns[I].Title.Color      := clBtnFace;
      DBGridLucratividade.Columns[I].Title.Font.Color := COR_PRIMARY;
    end;
end;

procedure TForm_RelatorioLucratividade.Pesquisar;
var
  Where, Sql: string;
  CodigoDe, CodigoAte: Integer;
  TemDe, TemAte: Boolean;
  QueryContagem: TIBQuery;
  Total, Lidos, Passo: Integer;
  TotalCusto, TotalVenda, TotalLucro, MargemTotal: Double;

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
  TotalCusto := 0;
  TotalVenda := 0;
  TotalLucro := 0;
  MargemTotal := 0;

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
  // coalesce em todos os numericos: evita NULL no FastReport (Null -> Integer).
  Sql := 'select coalesce(CODIGO, 0) as CODIGO, ' +
         'coalesce(DESCRICAO, '''') as DESCRICAO, ' +
         'coalesce(ESTOQUE_ATUAL, 0) as ESTOQUE_ATUAL, ' +
         'coalesce(PRECO_CUSTO, 0) as PRECO_CUSTO, ' +
         'coalesce(PRECO_VENDA, 0) as PRECO_VENDA, ' +
         'coalesce(MARGEM_LUCRO, 0) as MARGEM_LUCRO, ' +
         '(coalesce(PRECO_VENDA, 0) * coalesce(ESTOQUE_ATUAL, 0)) - ' +
         '(coalesce(PRECO_CUSTO, 0) * coalesce(ESTOQUE_ATUAL, 0)) as LUCRO_PRODUTO, ' +
         '(coalesce(PRECO_CUSTO, 0) * coalesce(ESTOQUE_ATUAL, 0)) as TOTAL_CUSTO_ESTOQUE, ' +
         '(coalesce(PRECO_VENDA, 0) * coalesce(ESTOQUE_ATUAL, 0)) as TOTAL_VENDA_ESTOQUE' + Where;
  if RadioGrupoOrdem.ItemIndex = 1 then
    Sql := Sql + ' order by CODIGO'
  else
    Sql := Sql + ' order by DESCRICAO';

  // Total de registros esperados: base do calculo do percentual.
  Total := 0;
  QueryContagem := TIBQuery.Create(nil);
  try
    QueryContagem.Database    := QueryLucratividade.Database;
    QueryContagem.Transaction := QueryLucratividade.Transaction;
    QueryContagem.SQL.Text    := 'select count(*)' + Where;
    PreencherParametros(QueryContagem);
    QueryContagem.Open;
    Total := QueryContagem.Fields[0].AsInteger;
    QueryContagem.Close;
  finally
    QueryContagem.Free;
  end;
  AtualizarProgresso(15);

  QueryLucratividade.DisableControls;
  try
    QueryLucratividade.Close;
    QueryLucratividade.SQL.Text := Sql;
    PreencherParametros(QueryLucratividade);
    QueryLucratividade.Open;
    AjustarFormatoCampos;
    AtualizarProgresso(25);

    // Percorre o resultado trazendo os registros do servidor e avancando
    // o percentual proporcionalmente a quantidade ja carregada.
    if Total > 0 then
    begin
      TotalCusto := 0;
      TotalVenda := 0;
      TotalLucro := 0;
      Lidos := 0;
      Passo := Total div 20;
      if Passo < 1 then
        Passo := 1;
      while not QueryLucratividade.Eof do
      begin
        TotalCusto := TotalCusto + CampoFloatSeguro('TOTAL_CUSTO_ESTOQUE');
        TotalVenda := TotalVenda + CampoFloatSeguro('TOTAL_VENDA_ESTOQUE');
        TotalLucro := TotalLucro + CampoFloatSeguro('LUCRO_PRODUTO');
        Inc(Lidos);
        if (Lidos mod Passo) = 0 then
          AtualizarProgresso(25 + (Lidos * 70 div Total));
        QueryLucratividade.Next;
      end;
      QueryLucratividade.First;
    end;

    AtualizarProgresso(100);
    if TotalCusto > 0 then
      MargemTotal := Round(((TotalVenda - TotalCusto) / TotalCusto) * 10000) / 100
    else
      MargemTotal := 0;

    FQtdItens := Total;
    FTotalCusto := TotalCusto;
    FTotalVenda := TotalVenda;
    FTotalLucro := TotalLucro;
    FMargemTotal := MargemTotal;

    LabelProgresso.Caption :=
      Format('Pesquisa concluida: %d produto(s) | Custo est.: %s | Venda est.: %s | ' +
        'Lucro: %s | Margem total: %s%%',
        [Total, FormatFloat('#,##0.00', TotalCusto),
         FormatFloat('#,##0.00', TotalVenda), FormatFloat('#,##0.00', TotalLucro),
         FormatFloat('0.00', MargemTotal)]);
  finally
    QueryLucratividade.EnableControls;
  end;

  DestacarColunaOrdenacao;
end;

function TForm_RelatorioLucratividade.CampoFloatSeguro(
  const ANomeCampo: string): Double;
var
  Fld: TField;
begin
  Result := 0;
  Fld := QueryLucratividade.FindField(ANomeCampo);
  if Assigned(Fld) and not Fld.IsNull then
    Result := Fld.AsFloat;
end;

function TForm_RelatorioLucratividade.CampoStringSeguro(
  const ANomeCampo: string): string;
var
  Fld: TField;
begin
  Result := '';
  Fld := QueryLucratividade.FindField(ANomeCampo);
  if Assigned(Fld) and not Fld.IsNull then
    Result := Trim(Fld.AsString);
end;

procedure TForm_RelatorioLucratividade.PrepararLayoutParaImpressao;
var
  I: Integer;
  Obj: TObject;
  Memo: TfrxMemoView;
  Band: TfrxMasterData;
begin
  // Remove script e bindings que quebram com NULL (Null -> String/Integer).
  frxReportLucratividade.ScriptText.Text := 'begin' + sLineBreak + 'end.';
  frxReportLucratividade.OnBeforePrint := frxReportLucratividadeBeforePrint;

  Band := frxReportLucratividade.FindObject('MasterData1') as TfrxMasterData;
  if Assigned(Band) then
    Band.OnBeforePrint := '';

  for I := 0 to frxReportLucratividade.AllObjects.Count - 1 do
  begin
    Obj := frxReportLucratividade.AllObjects[I];
    if not (Obj is TfrxMemoView) then
      Continue;
    Memo := TfrxMemoView(Obj);
    if Pos('MemoItem', Memo.Name) <> 1 then
      Continue;
    Memo.DataSet := nil;
    Memo.DataSetName := '';
    Memo.DataField := '';
    Memo.DisplayFormat.Kind := fkText;
    Memo.DisplayFormat.FormatStr := '';
    Memo.Text := '';
  end;
end;

procedure TForm_RelatorioLucratividade.frxReportLucratividadeBeforePrint(
  Sender: TfrxReportComponent);
var
  Memo: TfrxMemoView;
  Descricao: string;
  CorZebra: TColor;
  BrushFill: TfrxBrushFill;
begin
  if Sender is TfrxMasterData then
  begin
    Inc(FLinhaZebra);
    Exit;
  end;

  if not (Sender is TfrxMemoView) then
    Exit;

  Memo := TfrxMemoView(Sender);
  if Pos('MemoItem', Memo.Name) <> 1 then
    Exit;

  if Odd(FLinhaZebra) then
    CorZebra := COR_GRID_LINHA_IMPAR
  else
    CorZebra := COR_GRID_LINHA_PAR;

  if Memo.Fill is TfrxBrushFill then
  begin
    BrushFill := TfrxBrushFill(Memo.Fill);
    BrushFill.BackColor := CorZebra;
  end;

  if SameText(Memo.Name, 'MemoItemCodigo') then
    Memo.Text := FormatFloat('000000', CampoFloatSeguro('CODIGO'))
  else if SameText(Memo.Name, 'MemoItemDescricao') then
  begin
    Descricao := CampoStringSeguro('DESCRICAO');
    if Length(Descricao) > 38 then
      Descricao := Copy(Descricao, 1, 38);
    Memo.Text := Descricao;
  end
  else if SameText(Memo.Name, 'MemoItemEstoque') then
    Memo.Text := FormatFloat('#,##0.000', CampoFloatSeguro('ESTOQUE_ATUAL'))
  else if SameText(Memo.Name, 'MemoItemCusto') then
    Memo.Text := FormatFloat('#,##0.00', CampoFloatSeguro('PRECO_CUSTO'))
  else if SameText(Memo.Name, 'MemoItemVenda') then
    Memo.Text := FormatFloat('#,##0.00', CampoFloatSeguro('PRECO_VENDA'))
  else if SameText(Memo.Name, 'MemoItemMargem') then
    Memo.Text := FormatFloat('#,##0.00', CampoFloatSeguro('MARGEM_LUCRO'))
  else if SameText(Memo.Name, 'MemoItemLucro') then
    Memo.Text := FormatFloat('#,##0.00', CampoFloatSeguro('LUCRO_PRODUTO'))
  else if SameText(Memo.Name, 'MemoItemTotCusto') then
    Memo.Text := FormatFloat('#,##0.00', CampoFloatSeguro('TOTAL_CUSTO_ESTOQUE'))
  else if SameText(Memo.Name, 'MemoItemTotVenda') then
    Memo.Text := FormatFloat('#,##0.00', CampoFloatSeguro('TOTAL_VENDA_ESTOQUE'));
end;

procedure TForm_RelatorioLucratividade.BtnPesquisarClick(Sender: TObject);
begin
  Pesquisar;

  if QueryLucratividade.Active and QueryLucratividade.IsEmpty then
    MensagemDlg('Nenhum produto encontrado para os filtros informados.',
      mtInformation, [mbOK], 0);
end;

procedure TForm_RelatorioLucratividade.BtnLimparClick(Sender: TObject);
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

function TForm_RelatorioLucratividade.LocalizarArquivoFr3: string;
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

procedure TForm_RelatorioLucratividade.SincronizarLayoutFr3NoBanco;
var
  CaminhoFr3: string;
begin
  CaminhoFr3 := LocalizarArquivoFr3;
  if CaminhoFr3 = '' then
    Exit;

  frxReportLucratividade.LoadFromFile(CaminhoFr3);
  PrepararLayoutParaImpressao;
  GravarRelatorioEmbutidoNoBanco(NOME_RELATORIO_LUCRATIVIDADE);
end;

procedure TForm_RelatorioLucratividade.GravarRelatorioEmbutidoNoBanco(
  const ANome: string);
var
  Query: TIBQuery;
  Stream: TMemoryStream;
begin
  Stream := TMemoryStream.Create;
  try
    frxReportLucratividade.SaveToStream(Stream);
    Stream.Position := 0;

    Query := TIBQuery.Create(nil);
    try
      Query.Database    := QueryLucratividade.Database;
      Query.Transaction := QueryLucratividade.Transaction;
      Query.SQL.Text :=
        'update or insert into RELATORIO ' +
        '  (NOME, DESCRICAO, ARQUIVO, DATA_ALTERACAO) ' +
        'values ' +
        '  (:PNOME, :PDESCRICAO, :PARQUIVO, CURRENT_TIMESTAMP) ' +
        'matching (NOME)';
      Query.ParamByName('PNOME').AsString      := ANome;
      Query.ParamByName('PDESCRICAO').AsString :=
        'Relatorio de Lucratividade';
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

function TForm_RelatorioLucratividade.CarregarRelatorioDoBanco(const ANome: string;
  Stream: TStream): Boolean;
var
  Query: TIBQuery;
begin
  Query := TIBQuery.Create(nil);
  try
    Query.Database    := QueryLucratividade.Database;
    Query.Transaction := QueryLucratividade.Transaction;
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

function TForm_RelatorioLucratividade.DescricaoFiltros: string;

  procedure Acrescentar(const ATexto: string);
  begin
    if Result <> '' then
      Result := Result + '  |  ';
    Result := Result + ATexto;
  end;

begin
  Result := '';

  if RadioGrupoOrdem.ItemIndex = 1 then
    Acrescentar('Ordem: Codigo')
  else
    Acrescentar('Ordem: Alfabetica');

  if Trim(EditCodigoDe.Text) <> '' then
    Acrescentar('Codigo de: ' + Trim(EditCodigoDe.Text));
  if Trim(EditCodigoAte.Text) <> '' then
    Acrescentar('Codigo ate: ' + Trim(EditCodigoAte.Text));
  if Trim(EditReferencia.Text) <> '' then
    Acrescentar('Referencia: ' + Trim(EditReferencia.Text));
  if Trim(EditMarca.Text) <> '' then
    Acrescentar('Marca: ' + Trim(EditMarca.Text));
  if Trim(EditGrupo.Text) <> '' then
    Acrescentar('Grupo: ' + Trim(EditGrupo.Text));

  if Result = '' then
    Result := 'Todos os registros';
end;

procedure TForm_RelatorioLucratividade.AplicarCabecalhoRelatorio;
var
  Memo: TfrxMemoView;
  Title: TfrxBand;
  I: Integer;

  function GarantirMemo(const ANome: string; ALeft, ATop, AWidth,
    AHeight: Extended): TfrxMemoView;
  begin
    Result := frxReportLucratividade.FindObject(ANome) as TfrxMemoView;
    if Assigned(Result) then
      Exit;
    if not Assigned(Title) then
      Exit;
    Result := TfrxMemoView.Create(Title);
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
    Memo := GarantirMemo(ANome, ALeft, ATop, AWidth, 18.89765);
    if not Assigned(Memo) then
      Exit;
    Memo.Visible := True;
    Memo.Left := ALeft;
    Memo.Top := ATop;
    Memo.Width := AWidth;
    if AAlinharDireita then
      Memo.HAlign := haRight
    else
      Memo.HAlign := haLeft;
    if ATexto <> '' then
      Memo.Text := ATexto;
  end;

const
  MEMOS_CABECALHO_LEGADO: array[0..6] of string = (
    'MemoData', 'MemoHora', 'MemoDataEmis', 'Date', 'Time', 'Page', 'TotalPages');
begin
  Title := frxReportLucratividade.FindObject('ReportTitle1') as TfrxBand;

  for I := Low(MEMOS_CABECALHO_LEGADO) to High(MEMOS_CABECALHO_LEGADO) do
  begin
    Memo := frxReportLucratividade.FindObject(MEMOS_CABECALHO_LEGADO[I])
      as TfrxMemoView;
    if Assigned(Memo) then
      Memo.Visible := False;
  end;

  PosicionarCabecalho('MemoDataLabel',   560, 3.77953,  55, 'Data....:', False);
  PosicionarCabecalho('MemoDataValor',   618, 3.77953,  95, '[Date]', True);
  PosicionarCabecalho('MemoHoraLabel',   560, 22.67718, 55, 'Hora....:', False);
  PosicionarCabecalho('MemoHoraValor',   618, 22.67718, 95, '[Time]', True);
  PosicionarCabecalho('MemoPaginaLabel', 560, 41.57483, 55, 'Pagina.:', False);
  PosicionarCabecalho('MemoPaginaValor', 618, 41.57483, 95,
    '[Page#]/[TotalPages#]', True);

  Memo := frxReportLucratividade.FindObject('MemoDataValor') as TfrxMemoView;
  if Assigned(Memo) then
  begin
    Memo.DisplayFormat.Kind := fkDateTime;
    Memo.DisplayFormat.FormatStr := 'dd/mm/yyyy';
  end;

  Memo := frxReportLucratividade.FindObject('MemoHoraValor') as TfrxMemoView;
  if Assigned(Memo) then
  begin
    Memo.DisplayFormat.Kind := fkDateTime;
    Memo.DisplayFormat.FormatStr := 'hh:mm:ss';
  end;

  Memo := frxReportLucratividade.FindObject('MemoFiltroValor') as TfrxMemoView;
  if Assigned(Memo) then
  begin
    Memo.Width := 500;
    Memo.Text := DescricaoFiltros;
  end;

  Memo := frxReportLucratividade.FindObject('MemoTituloRelatorio') as TfrxMemoView;
  if Assigned(Memo) then
  begin
    Memo.Left := 160;
    Memo.Width := 390;
    Memo.Text := 'Relatorio de Lucratividade';
  end;

  Memo := frxReportLucratividade.FindObject('MemoColDescricao') as TfrxMemoView;
  if Assigned(Memo) then
    Memo.Text := 'Descri'#231#227'o do Produto';
end;

procedure TForm_RelatorioLucratividade.AplicarTotaisRelatorio;
var
  Memo: TfrxMemoView;

  procedure PreencherMemo(const ANome, ATexto: string);
  begin
    Memo := frxReportLucratividade.FindObject(ANome) as TfrxMemoView;
    if Assigned(Memo) then
      Memo.Text := ATexto;
  end;

  procedure PosicionarMemo(const ANome: string; ALeft, ATop, AWidth: Extended;
    AAlinharDireita: Boolean);
  begin
    Memo := frxReportLucratividade.FindObject(ANome) as TfrxMemoView;
    if not Assigned(Memo) then
      Exit;
    Memo.Left := ALeft;
    Memo.Top := ATop;
    Memo.Width := AWidth;
    Memo.Height := 15;
    if AAlinharDireita then
      Memo.HAlign := haRight
    else
      Memo.HAlign := haLeft;
  end;

begin
  // Coluna 1: Itens impressos / Lucratividade (valores alinhados).
  // Coluna 2: Custo estoque / Margem total (mesma coluna de valores).
  PosicionarMemo('MemoQtdItensLabel', 6, 26, 100, False);
  PosicionarMemo('MemoQtdItens', 108, 26, 90, True);
  PosicionarMemo('MemoLblCusto', 210, 26, 90, False);
  PosicionarMemo('MemoTotalCusto', 302, 26, 80, True);
  PosicionarMemo('MemoLblVenda', 390, 26, 90, False);
  PosicionarMemo('MemoTotalVenda', 482, 26, 80, True);
  PosicionarMemo('MemoLblLucro', 6, 44, 100, False);
  PosicionarMemo('MemoTotalLucro', 108, 44, 90, True);
  PosicionarMemo('MemoLblMargem', 210, 44, 90, False);
  PosicionarMemo('MemoMargemTotal', 302, 44, 80, True);

  PreencherMemo('MemoQtdItens', IntToStr(FQtdItens));
  PreencherMemo('MemoTotalCusto', FormatFloat('#,##0.00', FTotalCusto));
  PreencherMemo('MemoTotalVenda', FormatFloat('#,##0.00', FTotalVenda));
  PreencherMemo('MemoTotalLucro', FormatFloat('#,##0.00', FTotalLucro));
  PreencherMemo('MemoMargemTotal', FormatFloat('0.00', FMargemTotal) + '%');
end;

procedure TForm_RelatorioLucratividade.ExibirRelatorio;
var
  Stream: TMemoryStream;
  CaminhoFr3: string;
begin
  Stream := TMemoryStream.Create;
  try
    // Impressao: prioriza .fr3 em disco; senao carrega da tabela RELATORIO.
    CaminhoFr3 := LocalizarArquivoFr3;
    if CaminhoFr3 <> '' then
      frxReportLucratividade.LoadFromFile(CaminhoFr3)
    else if CarregarRelatorioDoBanco(NOME_RELATORIO_LUCRATIVIDADE, Stream) then
      frxReportLucratividade.LoadFromStream(Stream)
    else
    begin
      MensagemDlg('Nao foi possivel carregar o relatorio "' +
        NOME_RELATORIO_LUCRATIVIDADE +
        '" (arquivo .fr3 e tabela RELATORIO).',
        mtError, [mbOK], 0);
      Exit;
    end;

    PrepararLayoutParaImpressao;
    // Persiste o layout limpo (sem bindings/script) na tabela RELATORIO.
    GravarRelatorioEmbutidoNoBanco(NOME_RELATORIO_LUCRATIVIDADE);
    FLinhaZebra := 0;

    TRelatorioExportacaoFast.VincularExportacoes(frxReportLucratividade, frxExportPDF,
      frxExportExcel, frxExportWord, frxExportCSV);
    AplicarCabecalhoRelatorio;
    AplicarTotaisRelatorio;
    frxReportLucratividade.ShowReport;
  finally
    Stream.Free;
  end;
end;

procedure TForm_RelatorioLucratividade.BtnImprimirClick(Sender: TObject);
begin
  if not QueryLucratividade.Active or QueryLucratividade.IsEmpty then
  begin
    MensagemDlg('Nao ha produtos para imprimir. Utilize o botao ' +
      'Pesquisar primeiro.', mtInformation, [mbOK], 0);
    Exit;
  end;

  // Impressao via FastReport: o layout vem da tabela RELATORIO e os dados
  // da QueryLucratividade (ja filtrada pela pesquisa).
  try
    ExibirRelatorio;
  except
    on E: Exception do
      MensagemDlg('Erro ao abrir o relatorio.' + sLineBreak + E.Message,
        mtError, [mbOK], 0);
  end;
end;

procedure TForm_RelatorioLucratividade.BtnSairClick(Sender: TObject);
begin
  Close;
end;

end.
