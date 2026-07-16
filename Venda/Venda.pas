unit Venda;

{ Tela de venda mestre-detalhe integrada.

  Mestre  : cabecalho da venda (SqlVenda) - codigo, data/hora, situacao
            e cliente.
  Detalhe : itens da venda (SqlVendaItem, vinculado por CODIGO_VENDA via
            DataSource = DSVenda no DataModule) digitados diretamente
            nesta tela, em estilo PDV.

  Ao inserir a venda o cabecalho e gravado assim que o cliente e
  validado e a area de itens ja fica liberada para digitacao continua.
  Cada item adicionado recalcula e grava os totais acumulados da venda
  (Total Bruto, Desconto R$, Acrescimo R$ e Total Liquido). }

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Classes, System.Actions,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Mask, Vcl.DBCtrls,
  Vcl.Buttons, Vcl.ActnList, Vcl.WinXCtrls,
  Vcl.Grids, Vcl.DBGrids,
  Data.DB, IBX.IBCustomDataSet, IBX.IBQuery;

const
  // Mensagem custom usada para reagendar o foco no proprio campo,
  // saindo do fluxo do OnExit corrente (evita loop e efeitos colaterais).
  WM_REFOCAR = WM_USER + $100;

  // Cores dos campos de entrada (TColor = 0x00BBGGRR)
  COR_EDIT_NORMAL   = clWhite;
  COR_EDIT_FOCO     = $00FFF5EA;
  COR_EDIT_ERRO     = $00D6D6FF;
  COR_EDIT_READONLY = $00F0F0F0;

  // Cores alternadas das linhas do grid de itens (zebra)
  COR_GRID_LINHA_PAR   = clWhite;     // linhas pares
  COR_GRID_LINHA_IMPAR = $00F3E9DC;   // azul bem claro (linhas impares)
  COR_GRID_TEXTO       = $00333333;

  // Icones Segoe MDL2 Assets (Windows 10/11)
  ICN_PRIMEIRO  = #$E892;
  ICN_ANTERIOR  = #$E76B;
  ICN_PROXIMO   = #$E76C;
  ICN_ULTIMO    = #$E893;
  ICN_INSERIR   = #$E710;
  ICN_EDITAR    = #$E70F;
  ICN_GRAVAR    = #$E74E;
  ICN_CANCELAR  = #$E711;
  ICN_EXCLUIR   = #$E74D;
  ICN_SAIR      = #$E8BB;
  ICN_TRAVA     = #$E72E; // Lock (Fechar/Abrir venda)
  ICN_ADICIONAR = #$E73E; // CheckMark (Adicionar item)
  ICN_REMOVER   = #$E74D; // Delete (Remover item)
  ICN_PESQUISA  = #$E721; // Search (Pesquisar cliente)

type
  TForm_Venda = class(TForm)
    Panel_Titulo: TPanel;
    PanelEstado: TPanel;
    LabelSituacaoVenda: TLabel;
    LabelEstadoAtual: TLabel;

    GroupBoxDados: TGroupBox;
    LabelCodigo: TLabel;
    DBEditCodigoVenda: TDBEdit;
    LabelDataHora: TLabel;
    DBEditDataHora: TDBEdit;
    LabelSituacao: TLabel;
    DBEditSituacao: TDBEdit;
    LabelDescSituacao: TLabel;
    LabelCodigoCliente: TLabel;
    LabelCodigoClienteAst: TLabel;
    DBEditCodigoCliente: TDBEdit;
    DBEditNome: TDBEdit;
    BtnPesquisarCliente: TBitBtn;

    GroupBoxItem: TGroupBox;
    LabelItemProduto: TLabel;
    LabelItemProdutoAst: TLabel;
    EditCodigoProduto: TEdit;
    LabelItemDescricao: TLabel;
    EditDescricaoProduto: TEdit;
    LabelItemPreco: TLabel;
    EditPrecoUnitario: TEdit;
    LabelItemQuantidade: TLabel;
    LabelItemQuantidadeAst: TLabel;
    EditQuantidade: TEdit;
    LabelItemDesconto: TLabel;
    EditDesconto: TEdit;
    LabelItemAcrescimo: TLabel;
    EditAcrescimo: TEdit;
    LabelItemTotal: TLabel;
    EditTotalItem: TEdit;
    BtnAdicionarItem: TBitBtn;
    BtnRemoverItem: TBitBtn;

    GroupBoxItens: TGroupBox;
    DBGridVendaItem: TDBGrid;
    BtnPesquisarProduto: TBitBtn;

    GroupBoxFechamento: TGroupBox;
    LabelTotalProduto: TLabel;
    DBEditTotalProduto: TDBEdit;
    LabelDesconto: TLabel;
    DBEditDesconto: TDBEdit;
    LabelAcrescimo: TLabel;
    DBEditAcrescimo: TDBEdit;
    LabelTotalLiquido: TLabel;
    DBEditTotalLiquido: TDBEdit;

    PanelRodape: TPanel;
    BtnPrimeiro: TBitBtn;
    BtnAnterior: TBitBtn;
    BtnProximo: TBitBtn;
    BtnUltimo: TBitBtn;
    ShapeSep: TBevel;
    BtnFecharVenda: TBitBtn;
    BtnInserir: TBitBtn;
    BtnEditar: TBitBtn;
    BtnGravar: TBitBtn;
    BtnCancelar: TBitBtn;
    BtnExcluir: TBitBtn;
    BtnSair: TBitBtn;

    Query: TIBQuery;
    QueryAtualizaEstoque: TIBQuery;
    ActionList: TActionList;
    ActPrimeiro: TAction;
    ActAnterior: TAction;
    ActProximo: TAction;
    ActUltimo: TAction;
    ActInserir: TAction;
    ActEditar: TAction;
    ActGravar: TAction;
    ActCancelar: TAction;
    ActExcluir: TAction;
    QueryAtualizar: TIBQuery;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormActivate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormResize(Sender: TObject);

    procedure BtnPrimeiroClick(Sender: TObject);
    procedure BtnAnteriorClick(Sender: TObject);
    procedure BtnProximoClick(Sender: TObject);
    procedure BtnUltimoClick(Sender: TObject);
    procedure BtnInserirClick(Sender: TObject);
    procedure BtnEditarClick(Sender: TObject);
    procedure BtnGravarClick(Sender: TObject);
    procedure BtnCancelarClick(Sender: TObject);
    procedure BtnCancelarMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BtnExcluirClick(Sender: TObject);
    procedure BtnSairClick(Sender: TObject);
    procedure BtnSairMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BtnFecharVendaClick(Sender: TObject);
    procedure BtnAdicionarItemClick(Sender: TObject);
    procedure BtnRemoverItemClick(Sender: TObject);
    procedure BtnPesquisarClienteClick(Sender: TObject);
    procedure BtnPesquisarClienteMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure BtnPesquisarProdutoClick(Sender: TObject);
    procedure BtnPesquisarProdutoMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure DBGridVendaItemDrawColumnCell(Sender: TObject;
      const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);

    procedure ActPrimeiroExecute(Sender: TObject);
    procedure ActAnteriorExecute(Sender: TObject);
    procedure ActProximoExecute(Sender: TObject);
    procedure ActUltimoExecute(Sender: TObject);
    procedure ActInserirExecute(Sender: TObject);
    procedure ActEditarExecute(Sender: TObject);
    procedure ActGravarExecute(Sender: TObject);
    procedure ActCancelarExecute(Sender: TObject);
    procedure ActExcluirExecute(Sender: TObject);

    procedure DBEditCodigoClienteKeyPress(Sender: TObject; var Key: Char);
    procedure DBEditCodigoClienteExit(Sender: TObject);
    procedure EditCodigoProdutoKeyPress(Sender: TObject; var Key: Char);
    procedure EditCodigoProdutoExit(Sender: TObject);
    procedure EditNumericoKeyPress(Sender: TObject; var Key: Char);
    procedure EditItemValorChange(Sender: TObject);
    procedure EditFocoEnter(Sender: TObject);
    procedure EditFocoExit(Sender: TObject);
  private
    FValidando: Boolean;
    FIgnorarValidacao: Boolean;
    FOldDataChange: TDataChangeEvent;
    FOldStateChange: TNotifyEvent;
    FBalloonHint: TBalloonHint;
    FCampoComErro: TWinControl;
    FObserveEnterControl: string;
    FObserveEnterValue: string;

    procedure ConfigurarGlyphsBotoes;
    procedure AplicarLayoutInicial;
    procedure AjustarLayoutResponsivo;
    procedure AtualizarEstadoUI;

    procedure DsVendaDataChangeChained(Sender: TObject; Field: TField);
    procedure DsVendaStateChangeChained(Sender: TObject);

    function VendaAberta: Boolean;
    function ValidarCliente(ComBalao: Boolean): Boolean;
    procedure GravarCabecalho;
    procedure RecalcularTotais;
    procedure LimparAreaItem;
    procedure CalcularTotalItem;
    function ValorDoEdit(Edit: TEdit): Double;

    procedure MostrarBaloonErro(Edit: TCustomEdit; const Titulo, Texto: string);
    procedure ReagendarFocoNoCampo(Edit: TWinControl);
    procedure FocarControleSeguro(Ctrl: TWinControl);
    procedure DefinirCorFundo(Ctrl: TWinControl; Cor: TColor);
    function ControleEmSomenteLeitura(Ctrl: TWinControl): Boolean;

    procedure WMRefocar(var Msg: TMessage); message WM_REFOCAR;
  public
    { Public declarations }
  end;

var
  Form_Venda: TForm_Venda;

implementation

uses DataModule, Mensagens, ConsultaCliente, ConsultaProduto, ObserveHooks, UITheme;

{$R *.dfm}

{ Utilitarios locais }

procedure TForm_Venda.ConfigurarGlyphsBotoes;
begin
  AplicarBotaoBootstrap(BtnPrimeiro, bbkOutline, ICN_PRIMEIRO);
  AplicarBotaoBootstrap(BtnAnterior, bbkOutline, ICN_ANTERIOR);
  AplicarBotaoBootstrap(BtnProximo, bbkOutline, ICN_PROXIMO);
  AplicarBotaoBootstrap(BtnUltimo, bbkOutline, ICN_ULTIMO);
  AplicarBotaoBootstrap(BtnPesquisarCliente, bbkOutline, ICN_PESQUISA);
  AplicarBotaoBootstrap(BtnPesquisarProduto, bbkOutline, ICN_PESQUISA);
  AplicarBotaoBootstrap(BtnInserir, bbkSuccess, ICN_INSERIR);
  AplicarBotaoBootstrap(BtnAdicionarItem, bbkSuccess, ICN_ADICIONAR);
  AplicarBotaoBootstrap(BtnFecharVenda, bbkSuccess, ICN_TRAVA);
  AplicarBotaoBootstrap(BtnEditar, bbkWarning, ICN_EDITAR);
  AplicarBotaoBootstrap(BtnGravar, bbkPrimary, ICN_GRAVAR);
  AplicarBotaoBootstrap(BtnCancelar, bbkSecondary, ICN_CANCELAR);
  AplicarBotaoBootstrap(BtnSair, bbkSecondary, ICN_SAIR);
  AplicarBotaoBootstrap(BtnExcluir, bbkDanger, ICN_EXCLUIR);
  AplicarBotaoBootstrap(BtnRemoverItem, bbkDanger, ICN_REMOVER);
end;

procedure TForm_Venda.AplicarLayoutInicial;
begin
  Color := COR_PAGE;
  Constraints.MinWidth := 1000;
  Constraints.MinHeight := 620;
  AplicarHeaderPrimary(Panel_Titulo);
  AplicarFormEstiloWeb(Self);
  AplicarGrupoCard(GroupBoxDados);
  AplicarGrupoCard(GroupBoxItem);
  AplicarGrupoCard(GroupBoxItens);
  AplicarGrupoCard(GroupBoxFechamento);
  PanelRodape.ParentBackground := False;
  PanelRodape.BevelOuter := bvNone;
  PanelRodape.Color := COR_PAGE;
  PanelEstado.ParentBackground := False;
  PanelEstado.BevelOuter := bvNone;
  LabelCodigoClienteAst.Font.Color  := clRed;
  LabelItemProdutoAst.Font.Color    := clRed;
  LabelItemQuantidadeAst.Font.Color := clRed;
  AjustarLayoutResponsivo;
end;

procedure TForm_Venda.AjustarLayoutResponsivo;
const
  MARGEM = 14;
  GAP = 6;
  GAP_GRUPO = 14;
  PAD = 16;
var
  X: Integer;
  WUtil: Integer;
  ColW: Integer;
  GapMid: Integer;
  RightEdge: Integer;
begin
  if not Assigned(PanelRodape) then
    Exit;

  // Rodape: nav + Fechar + CRUD a esquerda; Sair a direita.
  X := MARGEM;
  BtnPrimeiro.Left := X;
  Inc(X, BtnPrimeiro.Width + GAP);
  BtnAnterior.Left := X;
  Inc(X, BtnAnterior.Width + GAP);
  BtnProximo.Left := X;
  Inc(X, BtnProximo.Width + GAP);
  BtnUltimo.Left := X;
  Inc(X, BtnUltimo.Width + GAP_GRUPO);
  ShapeSep.Left := X;
  Inc(X, ShapeSep.Width + GAP_GRUPO);
  BtnFecharVenda.Left := X;
  Inc(X, BtnFecharVenda.Width + GAP);
  BtnInserir.Left := X;
  Inc(X, BtnInserir.Width + GAP);
  BtnEditar.Left := X;
  Inc(X, BtnEditar.Width + GAP);
  BtnGravar.Left := X;
  Inc(X, BtnGravar.Width + GAP);
  BtnCancelar.Left := X;
  Inc(X, BtnCancelar.Width + GAP);
  BtnExcluir.Left := X;
  Inc(X, BtnExcluir.Width + GAP);
  BtnSair.Left := PanelRodape.ClientWidth - BtnSair.Width - MARGEM;
  if BtnSair.Left < X then
    BtnSair.Left := X;

  // Dados da venda: nome estica; botao pesquisar a direita.
  if Assigned(GroupBoxDados) and (GroupBoxDados.ClientWidth > 40) then
  begin
    RightEdge := GroupBoxDados.ClientWidth - PAD;
    BtnPesquisarCliente.Left := RightEdge - BtnPesquisarCliente.Width;
    DBEditNome.Left := DBEditCodigoCliente.Left + DBEditCodigoCliente.Width + GAP;
    DBEditNome.Width := BtnPesquisarCliente.Left - GAP - DBEditNome.Left;
    if DBEditNome.Width < 120 then
      DBEditNome.Width := 120;
  end;

  // Digitar item: descricao estica; preco/qtd/pesquisar ancorados a direita.
  if Assigned(GroupBoxItem) and (GroupBoxItem.ClientWidth > 40) then
  begin
    RightEdge := GroupBoxItem.ClientWidth - PAD;
    BtnPesquisarProduto.Left := RightEdge - BtnPesquisarProduto.Width;
    EditQuantidade.Left := BtnPesquisarProduto.Left - GAP - EditQuantidade.Width;
    LabelItemQuantidade.Left := EditQuantidade.Left;
    LabelItemQuantidadeAst.Left := LabelItemQuantidade.Left +
      LabelItemQuantidade.Width + 4;
    EditPrecoUnitario.Left := EditQuantidade.Left - GAP - EditPrecoUnitario.Width;
    LabelItemPreco.Left := EditPrecoUnitario.Left;
    EditDescricaoProduto.Left := EditCodigoProduto.Left + EditCodigoProduto.Width + GAP;
    EditDescricaoProduto.Width := EditPrecoUnitario.Left - GAP - EditDescricaoProduto.Left;
    if EditDescricaoProduto.Width < 100 then
      EditDescricaoProduto.Width := 100;
    LabelItemDescricao.Left := EditDescricaoProduto.Left;

    // Segunda linha: totais + botoes de item a direita.
    BtnRemoverItem.Left := RightEdge - BtnRemoverItem.Width;
    BtnAdicionarItem.Left := BtnRemoverItem.Left - GAP - BtnAdicionarItem.Width;
  end;

  // Fechamento: quatro colunas proporcionais.
  if Assigned(GroupBoxFechamento) and (GroupBoxFechamento.ClientWidth > 40) then
  begin
    GapMid := 20;
    WUtil := GroupBoxFechamento.ClientWidth - (PAD * 2) - (GapMid * 3);
    ColW := WUtil div 4;
    if ColW < 120 then
      ColW := 120;
    DBEditTotalProduto.Left := PAD;
    DBEditTotalProduto.Width := ColW;
    LabelTotalProduto.Left := DBEditTotalProduto.Left;
    DBEditDesconto.Left := DBEditTotalProduto.Left + ColW + GapMid;
    DBEditDesconto.Width := ColW;
    LabelDesconto.Left := DBEditDesconto.Left;
    DBEditAcrescimo.Left := DBEditDesconto.Left + ColW + GapMid;
    DBEditAcrescimo.Width := ColW;
    LabelAcrescimo.Left := DBEditAcrescimo.Left;
    DBEditTotalLiquido.Left := DBEditAcrescimo.Left + ColW + GapMid;
    DBEditTotalLiquido.Width := ColW;
    LabelTotalLiquido.Left := DBEditTotalLiquido.Left;
  end;

  // Grid: coluna Descricao ocupa o espaco restante.
  if Assigned(DBGridVendaItem) and (DBGridVendaItem.Columns.Count > 0) then
  begin
    WUtil := 0;
    for X := 0 to DBGridVendaItem.Columns.Count - 1 do
      if not SameText(DBGridVendaItem.Columns[X].FieldName, 'DescricaoProduto') then
        Inc(WUtil, DBGridVendaItem.Columns[X].Width);
    ColW := DBGridVendaItem.ClientWidth - WUtil - 28;
    if ColW < 120 then
      ColW := 120;
    for X := 0 to DBGridVendaItem.Columns.Count - 1 do
      if SameText(DBGridVendaItem.Columns[X].FieldName, 'DescricaoProduto') then
        DBGridVendaItem.Columns[X].Width := ColW;
  end;
end;

procedure TForm_Venda.FormResize(Sender: TObject);
begin
  AjustarLayoutResponsivo;
end;

function TForm_Venda.ControleEmSomenteLeitura(Ctrl: TWinControl): Boolean;
begin
  Result := False;
  if Ctrl is TDBEdit then
    Result := TDBEdit(Ctrl).ReadOnly
  else if Ctrl is TDBMemo then
    Result := TDBMemo(Ctrl).ReadOnly
  else if Ctrl is TEdit then
    Result := TEdit(Ctrl).ReadOnly;
end;

procedure TForm_Venda.DefinirCorFundo(Ctrl: TWinControl; Cor: TColor);
begin
  if Ctrl is TDBEdit then
    TDBEdit(Ctrl).Color := Cor
  else if Ctrl is TDBMemo then
    TDBMemo(Ctrl).Color := Cor
  else if Ctrl is TEdit then
    TEdit(Ctrl).Color := Cor;
end;

procedure TForm_Venda.EditFocoEnter(Sender: TObject);
begin
  if not (Sender is TWinControl) then
    Exit;
  if Sender is TControl then
  begin
    FObserveEnterControl := TControl(Sender).Name;
    if Sender is TCustomEdit then
      FObserveEnterValue := TCustomEdit(Sender).Text
    else
      FObserveEnterValue := '';
  end;
  if ControleEmSomenteLeitura(TWinControl(Sender)) then
    Exit;
  // Campo re-focado por erro de validacao permanece em vermelho claro.
  if Sender = FCampoComErro then
    DefinirCorFundo(TWinControl(Sender), COR_EDIT_ERRO)
  else
    DefinirCorFundo(TWinControl(Sender), COR_EDIT_FOCO);
end;

procedure TForm_Venda.EditFocoExit(Sender: TObject);
var
  Novo: string;
begin
  if not (Sender is TWinControl) then
    Exit;
  if (Sender is TCustomEdit) and (TControl(Sender).Name = FObserveEnterControl) then
  begin
    Novo := TCustomEdit(Sender).Text;
    ObserveLogFill(Self, TControl(Sender).Name, FObserveEnterValue, Novo);
  end;
  if ControleEmSomenteLeitura(TWinControl(Sender)) then
    Exit;
  DefinirCorFundo(TWinControl(Sender), COR_EDIT_NORMAL);
end;

function TForm_Venda.ValorDoEdit(Edit: TEdit): Double;
var
  Texto: string;
begin
  Texto := Trim(Edit.Text);
  Texto := StringReplace(Texto, '.', FormatSettings.DecimalSeparator, []);
  Result := StrToFloatDef(Texto, 0);
end;

{ Estado da UI }

function TForm_Venda.VendaAberta: Boolean;
begin
  Result := Assigned(Dm) and Assigned(Dm.SqlVenda) and
    Dm.SqlVenda.Active and (not Dm.SqlVenda.IsEmpty) and
    (Dm.SqlVendaSITUACAO.AsString = 'A');
end;

procedure TForm_Venda.AtualizarEstadoUI;
var
  Estado: TDataSetState;
  ModoTexto: string;
  CorFundo, CorTexto: TColor;
  EmEdicao, AreaItensLiberada: Boolean;
begin
  if not Assigned(Dm) or not Assigned(Dm.SqlVenda) then
    Exit;

  Estado   := Dm.SqlVenda.State;
  EmEdicao := Estado in [dsInsert, dsEdit];

  case Estado of
    dsInsert:
      begin
        ModoTexto := 'MODO: INSERINDO';
        CorFundo  := $00CDF6DF;
        CorTexto  := $00107C10;
      end;
    dsEdit:
      begin
        ModoTexto := 'MODO: EDITANDO';
        CorFundo  := $00CEF4FF;
        CorTexto  := $00007297;
      end;
    dsBrowse:
      begin
        ModoTexto := 'MODO: NAVEGACAO';
        CorFundo  := $00E8E8E8;
        CorTexto  := $00505050;
      end;
  else
    ModoTexto := 'MODO: ' + IntToStr(Ord(Estado));
    CorFundo  := $00E8E8E8;
    CorTexto  := $00505050;
  end;

  PanelEstado.Color           := CorFundo;
  LabelEstadoAtual.Caption    := ModoTexto;
  LabelEstadoAtual.Font.Color := CorTexto;

  // Badge da situacao da venda.
  if Dm.SqlVenda.IsEmpty and not EmEdicao then
  begin
    LabelSituacaoVenda.Caption    := '   SEM VENDA';
    LabelSituacaoVenda.Font.Color := $00505050;
    LabelDescSituacao.Caption     := '-';
    LabelDescSituacao.Font.Color  := $00505050;
  end
  else if VendaAberta or (Estado = dsInsert) then
  begin
    LabelSituacaoVenda.Caption    := '   VENDA ABERTA';
    LabelSituacaoVenda.Font.Color := $00107C10;
    LabelDescSituacao.Caption     := 'Aberta';
    LabelDescSituacao.Font.Color  := $00107C10;
  end
  else
  begin
    LabelSituacaoVenda.Caption    := '   VENDA FECHADA';
    LabelSituacaoVenda.Font.Color := clRed;
    LabelDescSituacao.Caption     := 'Fechada';
    LabelDescSituacao.Font.Color  := clRed;
  end;

  // Cliente editavel apenas em Insert/Edit de venda aberta.
  DBEditCodigoCliente.ReadOnly := not EmEdicao;
  if EmEdicao then
    DBEditCodigoCliente.Color := COR_EDIT_NORMAL
  else
    DBEditCodigoCliente.Color := COR_EDIT_READONLY;

  // Area de digitacao de itens: venda gravada (dsBrowse) e aberta.
  AreaItensLiberada := VendaAberta and (Estado = dsBrowse);
  GroupBoxItem.Enabled := AreaItensLiberada;
  if AreaItensLiberada then
  begin
    EditCodigoProduto.Color := COR_EDIT_NORMAL;
    EditQuantidade.Color    := COR_EDIT_NORMAL;
    EditDesconto.Color      := COR_EDIT_NORMAL;
    EditAcrescimo.Color     := COR_EDIT_NORMAL;
  end
  else
  begin
    EditCodigoProduto.Color := COR_EDIT_READONLY;
    EditQuantidade.Color    := COR_EDIT_READONLY;
    EditDesconto.Color      := COR_EDIT_READONLY;
    EditAcrescimo.Color     := COR_EDIT_READONLY;
  end;

  // Caption do Fechar/Abrir acompanha a situacao do registro corrente.
  if (not Dm.SqlVenda.IsEmpty) and (Dm.SqlVendaSITUACAO.AsString = 'F') then
  begin
    BtnFecharVenda.Caption := 'Abrir Venda';
    AplicarBotaoBootstrap(BtnFecharVenda, bbkWarning, ICN_TRAVA);
  end
  else
  begin
    BtnFecharVenda.Caption := 'Fechar Venda';
    AplicarBotaoBootstrap(BtnFecharVenda, bbkSuccess, ICN_TRAVA);
  end;
  BtnFecharVenda.Enabled :=
    (Estado = dsBrowse) and (not Dm.SqlVenda.IsEmpty);
end;

{ Chained events do DataSource }

procedure TForm_Venda.DsVendaDataChangeChained(Sender: TObject; Field: TField);
begin
  if Assigned(FOldDataChange) then
    FOldDataChange(Sender, Field);
  AtualizarEstadoUI;
end;

procedure TForm_Venda.DsVendaStateChangeChained(Sender: TObject);
begin
  if Assigned(FOldStateChange) then
    FOldStateChange(Sender);
  AtualizarEstadoUI;
end;

{ Balao / refoco }

procedure TForm_Venda.MostrarBaloonErro(Edit: TCustomEdit;
  const Titulo, Texto: string);
begin
  if not Assigned(Edit) or not Assigned(FBalloonHint) then
    Exit;
  FBalloonHint.HideHint;
  FBalloonHint.Title       := Titulo;
  FBalloonHint.Description := Texto;
  FBalloonHint.ShowHint(Edit);
end;

procedure TForm_Venda.ReagendarFocoNoCampo(Edit: TWinControl);
begin
  if Assigned(Edit) then
    PostMessage(Self.Handle, WM_REFOCAR, WPARAM(Pointer(Edit)), 0);
end;

procedure TForm_Venda.FocarControleSeguro(Ctrl: TWinControl);
begin
  if (Ctrl = nil) or (not Ctrl.Showing) or (not Ctrl.CanFocus) then
    Exit;
  try
    Ctrl.SetFocus;
  except
    on EInvalidOperation do
      ; // Janela ainda invisivel/desabilitada (comum em MDI bsNone).
  end;
end;

procedure TForm_Venda.WMRefocar(var Msg: TMessage);
var
  Ctrl: TWinControl;
begin
  Ctrl := TWinControl(Pointer(Msg.WParam));
  if not Assigned(Ctrl) then
    Exit;
  FValidando := True;
  try
    FocarControleSeguro(Ctrl);
  finally
    FValidando := False;
  end;
end;

{ Validacao do cliente (mestre) }

procedure TForm_Venda.DBEditCodigoClienteKeyPress(Sender: TObject;
  var Key: Char);
begin
  if CharInSet(Key, [#8, #9, #13, #27]) then
    Exit;
  if not CharInSet(Key, ['0'..'9']) then
    Key := #0;
end;

function TForm_Venda.ValidarCliente(ComBalao: Boolean): Boolean;
var
  Codigo: Integer;

  procedure Falhar(const Titulo, Texto: string);
  begin
    DBEditCodigoCliente.Color := COR_EDIT_ERRO;
    FCampoComErro             := DBEditCodigoCliente;
    if ComBalao then
      MostrarBaloonErro(DBEditCodigoCliente, Titulo, Texto);
    ReagendarFocoNoCampo(DBEditCodigoCliente);
  end;

begin
  Result := True;

  if Trim(DBEditCodigoCliente.Text) = '' then
  begin
    Falhar('Campo obrigatorio', 'O codigo do cliente deve ser informado.');
    Exit(False);
  end;

  if not TryStrToInt(Trim(DBEditCodigoCliente.Text), Codigo) or
     not Dm.SqlCliente.Locate('CODIGO', Codigo, []) then
  begin
    Falhar('Cliente nao cadastrado',
      'O cliente informado nao existe no cadastro.');
    Exit(False);
  end;
end;

procedure TForm_Venda.DBEditCodigoClienteExit(Sender: TObject);
begin
  if FValidando then
    Exit;

  DBEditCodigoCliente.Color := COR_EDIT_NORMAL;
  if FCampoComErro = DBEditCodigoCliente then
    FCampoComErro := nil;

  if FIgnorarValidacao then
    Exit;
  if csDestroying in ComponentState then
    Exit;
  if not Assigned(Dm) or not Assigned(Dm.SqlVenda) then
    Exit;
  if not (Dm.SqlVenda.State in [dsInsert, dsEdit]) then
    Exit;
  // Permite sair sem validacao quando o proximo foco for Cancelar ou Sair
  // (MouseDown do botao pode ocorrer apos o OnExit).
  if (GetFocus <> 0) and
     ((BtnCancelar.HandleAllocated and (GetFocus = BtnCancelar.Handle)) or
      (BtnSair.HandleAllocated and (GetFocus = BtnSair.Handle))) then
    Exit;

  if not ValidarCliente(True) then
    Exit;

  // Cliente valido: grava o cabecalho e libera a digitacao dos itens.
  GravarCabecalho;
  if GroupBoxItem.Enabled and EditCodigoProduto.CanFocus then
    ReagendarFocoNoCampo(EditCodigoProduto);
end;

procedure TForm_Venda.BtnPesquisarClienteMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  // Evita que o OnExit do DBEditCodigoCliente valide/refoque enquanto o
  // usuario esta apenas abrindo a consulta (mesmo padrao do Cancelar).
  FIgnorarValidacao := True;
end;

procedure TForm_Venda.BtnPesquisarClienteClick(Sender: TObject);
var
  Codigo: Integer;
  Nome: string;
begin
  try
    // A consulta preenche o cliente do cabecalho, entao exige a venda
    // em Insercao/Edicao.
    if not (Dm.SqlVenda.State in [dsInsert, dsEdit]) then
    begin
      MensagemDlg('Inicie uma venda (Inserir) ou entre em edicao antes ' +
        'de pesquisar o cliente.', mtInformation, [mbOK], 0);
      Exit;
    end;

    if not TForm_ConsultaCliente.Selecionar(Codigo, Nome) then
      Exit;

    // Cliente confirmado na consulta: aplica no cabecalho da venda.
    Dm.SqlVendaCODIGO_CLIENTE.AsInteger := Codigo;
    DBEditCodigoCliente.Color := COR_EDIT_NORMAL;
    if FCampoComErro = DBEditCodigoCliente then
      FCampoComErro := nil;

    // Mesmo fluxo do OnExit validado: grava o cabecalho e libera os itens.
    GravarCabecalho;
    if GroupBoxItem.Enabled and EditCodigoProduto.CanFocus then
      ReagendarFocoNoCampo(EditCodigoProduto);
  finally
    FIgnorarValidacao := False;
  end;
end;

procedure TForm_Venda.BtnPesquisarProdutoMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  // Evita que o OnExit do EditCodigoProduto valide/refoque enquanto o
  // usuario esta apenas abrindo a consulta.
  FIgnorarValidacao := True;
end;

procedure TForm_Venda.BtnPesquisarProdutoClick(Sender: TObject);
var
  Codigo: Integer;
  Descricao: string;
begin
  try
    if not GroupBoxItem.Enabled then
      Exit;

    if not TForm_ConsultaProduto.Selecionar(Codigo, Descricao) then
      Exit;
    if not Dm.SqlProduto.Locate('CODIGO', Codigo, []) then
      Exit;

    // Produto confirmado na consulta: preenche a area do item.
    EditCodigoProduto.Text  := IntToStr(Codigo);
    EditCodigoProduto.Color := COR_EDIT_NORMAL;
    if FCampoComErro = EditCodigoProduto then
      FCampoComErro := nil;
    EditDescricaoProduto.Text :=
      Dm.SqlProduto.FieldByName('DESCRICAO').AsString;
    EditPrecoUnitario.Text := FormatFloat('#,##0.00',
      Dm.SqlProduto.FieldByName('PRECO_VENDA').AsFloat);
    CalcularTotalItem;

    // Segue direto para a quantidade, agilizando a digitacao do item.
    if EditQuantidade.CanFocus then
      ReagendarFocoNoCampo(EditQuantidade);
  finally
    FIgnorarValidacao := False;
  end;
end;

{ Cabecalho (mestre) }

procedure TForm_Venda.GravarCabecalho;
begin
  if not (Dm.SqlVenda.State in [dsInsert, dsEdit]) then
    Exit;

  ObserveEmitSnapshot(Self, Dm.SqlVenda);
  try
    Dm.SqlVenda.Post;
    ObserveLogPost(Self, 'Venda');
    Dm.SqlVenda.ApplyUpdates;
    ObserveLogApplyUpdates(Self, 'Venda');
    Dm.IBTransaction1.CommitRetaining;
    ObserveLogCommit(Self, 'Venda');
  except
    on E: Exception do
    begin
      if Dm.IBTransaction1.InTransaction then
        Dm.IBTransaction1.Rollback;
      ObserveLogRollback(Self, 'Venda', E.Message);
      ObserveLogException(E.Message, 'GravarCabecalho', ClassName);
      MensagemDlg('Erro na gravacao da venda: ' + E.Message,
        mtError, [mbOK], 0);
    end;
  end;
end;

procedure TForm_Venda.RecalcularTotais;
begin
  if Dm.SqlVenda.IsEmpty then
    Exit;
  if not (Dm.SqlVenda.State = dsBrowse) then
    Exit;

  // Totais acumulados a partir dos itens gravados:
  //   Total Bruto = soma(Qtd x Preco)
  //   Desconto R$ = soma(Qtd x Preco x Desc% / 100)
  //   Acrescimo R$ = soma(Qtd x Preco x Acr% / 100)
  //   Total Liquido = soma(Total_Liquido dos itens)
  if Query.Active then
    Query.Close;
  Query.SQL.Text :=
    'select ' +
    ' coalesce(sum(Quantidade * Preco_Unitario), 0) as Total_Bruto, ' +
    ' coalesce(sum(Quantidade * Preco_Unitario * Desconto  / 100), 0) ' +
    '   as Total_Desconto, ' +
    ' coalesce(sum(Quantidade * Preco_Unitario * Acrescimo / 100), 0) ' +
    '   as Total_Acrescimo, ' +
    ' coalesce(sum(Total_Liquido), 0) as Total_Liquido ' +
    'from Venda_Item where CODIGO_VENDA = :CODIGO_VENDA';
  Query.ParamByName('CODIGO_VENDA').AsInteger := Dm.SqlVendaCODIGO.AsInteger;
  Query.Open;
  try
    try
      Dm.SqlVenda.Edit;
      Dm.SqlVendaTOTAL_BRUTO.AsFloat   := Query.FieldByName('Total_Bruto').AsFloat;
      Dm.SqlVendaDESCONTO_PERC.AsFloat := Query.FieldByName('Total_Desconto').AsFloat;
      Dm.SqlVendaACRESCIMO_PER.AsFloat := Query.FieldByName('Total_Acrescimo').AsFloat;
      Dm.SqlVendaTOTAL_LIQUIDO.AsFloat := Query.FieldByName('Total_Liquido').AsFloat;
      Dm.SqlVenda.Post;
      Dm.SqlVenda.ApplyUpdates;
      Dm.IBTransaction1.CommitRetaining;
    except
      on E: Exception do
      begin
        if Dm.SqlVenda.State in [dsInsert, dsEdit] then
          Dm.SqlVenda.Cancel;
        if Dm.IBTransaction1.InTransaction then
          Dm.IBTransaction1.Rollback;
        MensagemDlg('Erro ao atualizar os totais da venda: ' + E.Message,
          mtError, [mbOK], 0);
      end;
    end;
  finally
    Query.Close;
  end;
end;

{ Grid de itens - linhas com cores alternadas (zebra) }

procedure TForm_Venda.DBGridVendaItemDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
var
  Grid: TDBGrid;
begin
  Grid := TDBGrid(Sender);

  // Linha selecionada mantem o destaque padrao; as demais alternam a
  // cor de fundo conforme a posicao do registro (par/impar).
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

{ Area de digitacao do item (detalhe) }

procedure TForm_Venda.LimparAreaItem;
begin
  EditCodigoProduto.Text    := '';
  EditDescricaoProduto.Text := '';
  EditPrecoUnitario.Text    := '';
  EditQuantidade.Text       := '1';
  EditDesconto.Text         := '0';
  EditAcrescimo.Text        := '0';
  EditTotalItem.Text        := FormatFloat('#,##0.00', 0);
end;

procedure TForm_Venda.CalcularTotalItem;
var
  Quantidade, Preco, DescPerc, AcrPerc: Double;
  TotalBruto, ValorDesc, ValorAcr: Double;
begin
  Quantidade := ValorDoEdit(EditQuantidade);
  Preco      := ValorDoEdit(EditPrecoUnitario);
  DescPerc   := ValorDoEdit(EditDesconto);
  AcrPerc    := ValorDoEdit(EditAcrescimo);

  TotalBruto := Quantidade * Preco;
  ValorDesc  := TotalBruto * DescPerc / 100;
  ValorAcr   := TotalBruto * AcrPerc / 100;

  EditTotalItem.Text :=
    FormatFloat('#,##0.00', TotalBruto - ValorDesc + ValorAcr);
end;

procedure TForm_Venda.EditItemValorChange(Sender: TObject);
begin
  CalcularTotalItem;
end;

procedure TForm_Venda.EditCodigoProdutoKeyPress(Sender: TObject;
  var Key: Char);
begin
  if CharInSet(Key, [#8, #9, #13, #27]) then
    Exit;
  if not CharInSet(Key, ['0'..'9']) then
    Key := #0;
end;

procedure TForm_Venda.EditNumericoKeyPress(Sender: TObject; var Key: Char);
begin
  if CharInSet(Key, [#8, #9, #13, #27]) then
    Exit;
  if Key = '.' then
    Key := FormatSettings.DecimalSeparator;
  if Key = FormatSettings.DecimalSeparator then
  begin
    if Pos(FormatSettings.DecimalSeparator, TEdit(Sender).Text) > 0 then
      Key := #0;
    Exit;
  end;
  if not CharInSet(Key, ['0'..'9']) then
    Key := #0;
end;

procedure TForm_Venda.EditCodigoProdutoExit(Sender: TObject);
var
  Codigo: Integer;

  procedure Falhar(const Titulo, Texto: string);
  begin
    EditDescricaoProduto.Text := '';
    EditPrecoUnitario.Text    := '';
    EditCodigoProduto.Color   := COR_EDIT_ERRO;
    FCampoComErro             := EditCodigoProduto;
    MostrarBaloonErro(EditCodigoProduto, Titulo, Texto);
    ReagendarFocoNoCampo(EditCodigoProduto);
  end;

begin
  if FValidando then
    Exit;

  EditCodigoProduto.Color := COR_EDIT_NORMAL;
  if FCampoComErro = EditCodigoProduto then
    FCampoComErro := nil;

  if FIgnorarValidacao then
    Exit;
  if csDestroying in ComponentState then
    Exit;
  if not GroupBoxItem.Enabled then
    Exit;
  if (GetFocus <> 0) and
     ((BtnCancelar.HandleAllocated and (GetFocus = BtnCancelar.Handle)) or
      (BtnSair.HandleAllocated and (GetFocus = BtnSair.Handle))) then
    Exit;

  // Campo vazio: nao valida na saida (usuario pode estar apenas
  // passando pela area); a obrigatoriedade e cobrada no Adicionar.
  if Trim(EditCodigoProduto.Text) = '' then
    Exit;

  if not TryStrToInt(Trim(EditCodigoProduto.Text), Codigo) or
     not Dm.SqlProduto.Locate('CODIGO', Codigo, []) then
  begin
    Falhar('Produto nao cadastrado',
      'O produto informado nao existe no cadastro.');
    Exit;
  end;

  // Produto encontrado: carrega descricao e preco de venda.
  EditDescricaoProduto.Text :=
    Dm.SqlProduto.FieldByName('DESCRICAO').AsString;
  EditPrecoUnitario.Text := FormatFloat('#,##0.00',
    Dm.SqlProduto.FieldByName('PRECO_VENDA').AsFloat);
  CalcularTotalItem;
end;

procedure TForm_Venda.BtnAdicionarItemClick(Sender: TObject);
var
  CodigoProduto: Integer;
  Quantidade, Preco, DescPerc, AcrPerc: Double;
  TotalBruto, TotalLiquido: Double;
begin
  if not GroupBoxItem.Enabled then
    Exit;

  // Validacoes do item.
  if (Trim(EditCodigoProduto.Text) = '') or
     not TryStrToInt(Trim(EditCodigoProduto.Text), CodigoProduto) or
     not Dm.SqlProduto.Locate('CODIGO', CodigoProduto, []) then
  begin
    EditCodigoProduto.Color := COR_EDIT_ERRO;
    FCampoComErro           := EditCodigoProduto;
    MostrarBaloonErro(EditCodigoProduto, 'Produto invalido',
      'Informe um produto cadastrado antes de adicionar o item.');
    ReagendarFocoNoCampo(EditCodigoProduto);
    Exit;
  end;

  Quantidade := ValorDoEdit(EditQuantidade);
  if Quantidade <= 0 then
  begin
    EditQuantidade.Color := COR_EDIT_ERRO;
    FCampoComErro        := EditQuantidade;
    MostrarBaloonErro(EditQuantidade, 'Quantidade invalida',
      'A quantidade deve ser maior que zero.');
    ReagendarFocoNoCampo(EditQuantidade);
    Exit;
  end;

  DescPerc := ValorDoEdit(EditDesconto);
  if DescPerc < 0 then
  begin
    EditDesconto.Color := COR_EDIT_ERRO;
    FCampoComErro      := EditDesconto;
    MostrarBaloonErro(EditDesconto, 'Valor invalido',
      'O desconto nao pode ser negativo.');
    ReagendarFocoNoCampo(EditDesconto);
    Exit;
  end;

  AcrPerc := ValorDoEdit(EditAcrescimo);
  if AcrPerc < 0 then
  begin
    EditAcrescimo.Color := COR_EDIT_ERRO;
    FCampoComErro       := EditAcrescimo;
    MostrarBaloonErro(EditAcrescimo, 'Valor invalido',
      'O acrescimo nao pode ser negativo.');
    ReagendarFocoNoCampo(EditAcrescimo);
    Exit;
  end;

  Preco        := Dm.SqlProduto.FieldByName('PRECO_VENDA').AsFloat;
  TotalBruto   := Quantidade * Preco;
  TotalLiquido := TotalBruto
    - (TotalBruto * DescPerc / 100)
    + (TotalBruto * AcrPerc  / 100);

  // Grava o item vinculado a venda corrente.
  try
    Dm.SqlVendaItem.Insert;
    if Dm.QueryId.Active then
      Dm.QueryId.Close;
    Dm.QueryId.SQL.Text :=
      'SELECT COALESCE(MAX(CODIGO),0) + 1 AS CODIGO FROM VENDA_ITEM';
    Dm.QueryId.Open;
    try
      Dm.SQLVendaItemCODIGO.AsInteger :=
        Dm.QueryId.FieldByName('CODIGO').AsInteger;
    finally
      Dm.QueryId.Close;
    end;
    Dm.SQLVendaItemCODIGO_VENDA.AsInteger   := Dm.SqlVendaCODIGO.AsInteger;
    Dm.SQLVendaItemCODIGO_PRODUTO.AsInteger := CodigoProduto;
    Dm.SQLVendaItemQUANTIDADE.AsFloat       := Quantidade;
    Dm.SQLVendaItemPRECO_UNITARIO.AsFloat   := Preco;
    Dm.SQLVendaItemDESCONTO.AsFloat         := DescPerc;
    Dm.SQLVendaItemACRESCIMO.AsFloat        := AcrPerc;
    Dm.SQLVendaItemTOTAL_LIQUIDO.AsFloat    := TotalLiquido;
    Dm.SqlVendaItem.Post;
    Dm.SqlVendaItem.ApplyUpdates;
    Dm.IBTransaction1.CommitRetaining;
  except
    on E: Exception do
    begin
      if Dm.SqlVendaItem.State in [dsInsert, dsEdit] then
        Dm.SqlVendaItem.Cancel;
      if Dm.IBTransaction1.InTransaction then
        Dm.IBTransaction1.Rollback;
      MensagemDlg('Erro ao adicionar o item: ' + E.Message,
        mtError, [mbOK], 0);
      Exit;
    end;
  end;

  // Acumula os totais no cabecalho e prepara o proximo item.
  RecalcularTotais;
  LimparAreaItem;
  ReagendarFocoNoCampo(EditCodigoProduto);
end;

procedure TForm_Venda.BtnRemoverItemClick(Sender: TObject);
var
  Produto: string;
begin
  if not GroupBoxItem.Enabled then
    Exit;
  if Dm.SqlVendaItem.IsEmpty then
  begin
    ShowMessage('Nao ha item selecionado para remover.');
    Exit;
  end;

  Produto := Dm.SqlVendaItem.FieldByName('DescricaoProduto').AsString;
  if MensagemDlg(
       'Remover o item "' + Produto + '" da venda?',
       mtWarning, [mbYes, mbNo], 0, mbNo) <> mrYes then
    Exit;

  try
    Dm.SqlVendaItem.Delete;
    Dm.SqlVendaItem.ApplyUpdates;
    Dm.IBTransaction1.CommitRetaining;
  except
    on E: Exception do
    begin
      if Dm.IBTransaction1.InTransaction then
        Dm.IBTransaction1.Rollback;
      MensagemDlg('Erro ao remover o item: ' + E.Message,
        mtError, [mbOK], 0);
      Exit;
    end;
  end;

  RecalcularTotais;
end;

{ Ciclo de vida }

procedure TForm_Venda.FormCreate(Sender: TObject);
begin
  FValidando        := False;
  FIgnorarValidacao := False;

  FBalloonHint := TBalloonHint.Create(Self);
  FBalloonHint.Style     := bhsStandard;
  FBalloonHint.Delay     := 0;
  FBalloonHint.HideAfter := 4000;

  if not Dm.SqlCliente.Active then
    Dm.SqlCliente.Open;
  if not Dm.SqlProduto.Active then
    Dm.SqlProduto.Open;
  if not Dm.SqlVenda.Active then
    Dm.SqlVenda.Open;
  if not Dm.SqlVendaItem.Active then
    Dm.SqlVendaItem.Open;

  ConfigurarGlyphsBotoes;
  AplicarLayoutInicial;
  LimparAreaItem;

  FOldDataChange  := Dm.DSVenda.OnDataChange;
  FOldStateChange := Dm.DSVenda.OnStateChange;
  Dm.DSVenda.OnDataChange  := DsVendaDataChangeChained;
  Dm.DSVenda.OnStateChange := DsVendaStateChangeChained;

  AtualizarEstadoUI;
  ObserveLogOpenForm(Self);
  ObserveEmitSnapshot(Self, Dm.SqlVenda);
end;

procedure TForm_Venda.FormDestroy(Sender: TObject);
begin
  if Assigned(Dm) and Assigned(Dm.DSVenda) then
  begin
    if TMethod(Dm.DSVenda.OnDataChange).Data = Self then
      Dm.DSVenda.OnDataChange := FOldDataChange;
    if TMethod(Dm.DSVenda.OnStateChange).Data = Self then
      Dm.DSVenda.OnStateChange := FOldStateChange;
  end;
end;

procedure TForm_Venda.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ObserveLogCloseForm(Self);
  Action     := caFree;
  Form_Venda := nil;
end;

procedure TForm_Venda.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := True;
  if Assigned(Dm) and Assigned(Dm.SqlVenda) and
     (Dm.SqlVenda.State in [dsInsert, dsEdit]) then
  begin
    case MensagemDlg(
      'Existem alteracoes nao gravadas. Deseja descarta-las e fechar?',
      mtConfirmation, [mbYes, mbNo], 0) of
      mrYes:
        begin
          Dm.SqlVenda.Cancel;
          CanClose := True;
        end;
    else
      CanClose := False;
    end;
  end;
end;

procedure TForm_Venda.FormActivate(Sender: TObject);
begin
  if not Dm.SqlCliente.Active then
    Dm.SqlCliente.Open;
  if not Dm.SqlProduto.Active then
    Dm.SqlProduto.Open;

  AtualizarEstadoUI;

  // Adia o foco: com bsNone/MDI o SetFocus sincrono gera EInvalidOperation.
  if GroupBoxItem.Enabled then
    ReagendarFocoNoCampo(EditCodigoProduto)
  else if Dm.SqlVenda.State = dsBrowse then
    ReagendarFocoNoCampo(BtnInserir);
end;

procedure TForm_Venda.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  // ENTER navega para o proximo campo.
  if (Key = VK_RETURN) and (Shift = []) then
  begin
    if (ActiveControl <> nil) and
       not (ActiveControl is TCustomMemo) and
       not (ActiveControl is TCustomButton) and
       not (ActiveControl is TCustomDBGrid) then
    begin
      Key := 0;
      SelectNext(ActiveControl, True, True);
      Exit;
    end;
  end;

  // Seta para CIMA volta ao campo anterior ignorando a validacao.
  if (Key = VK_UP) and (Shift = []) then
  begin
    if (ActiveControl <> nil) and
       not (ActiveControl is TCustomMemo) and
       not (ActiveControl is TCustomButton) and
       not (ActiveControl is TCustomDBGrid) then
    begin
      Key := 0;
      FIgnorarValidacao := True;
      try
        SelectNext(ActiveControl, False, True);
      finally
        FIgnorarValidacao := False;
      end;
      Exit;
    end;
  end;

  // ESC so fecha o form quando nao ha edicao pendente do cabecalho.
  if Key = VK_ESCAPE then
  begin
    if Assigned(Dm) and Assigned(Dm.SqlVenda) and
       (Dm.SqlVenda.State in [dsInsert, dsEdit]) then
      Exit;
    Close;
  end;
end;

{ Navegacao (o detalhe acompanha o mestre automaticamente) }

procedure TForm_Venda.BtnPrimeiroClick(Sender: TObject);
begin
  Dm.SqlVenda.First;
end;

procedure TForm_Venda.BtnAnteriorClick(Sender: TObject);
begin
  Dm.SqlVenda.Prior;
end;

procedure TForm_Venda.BtnProximoClick(Sender: TObject);
begin
  Dm.SqlVenda.Next;
end;

procedure TForm_Venda.BtnUltimoClick(Sender: TObject);
begin
  Dm.SqlVenda.Last;
end;

{ CRUD do cabecalho }

procedure TForm_Venda.BtnInserirClick(Sender: TObject);
begin
  if Dm.QueryId.Active then
    Dm.QueryId.Close;
  Dm.QueryId.SQL.Text :=
    'SELECT COALESCE(MAX(CODIGO),0) + 1 AS CODIGO FROM VENDA';
  Dm.QueryId.Open;
  Dm.SqlVenda.Insert;
  try
    Dm.SqlVendaCODIGO.AsInteger :=
      Dm.QueryId.FieldByName('CODIGO').AsInteger;
  finally
    Dm.QueryId.Close;
  end;
  Dm.SqlVendaDATA_HORA_VENDA.AsDateTime := Now;
  Dm.SqlVendaSITUACAO.AsString          := 'A';
  Dm.SqlVendaTOTAL_BRUTO.AsFloat        := 0;
  Dm.SqlVendaDESCONTO_PERC.AsFloat      := 0;
  Dm.SqlVendaACRESCIMO_PER.AsFloat      := 0;
  Dm.SqlVendaTOTAL_LIQUIDO.AsFloat      := 0;

  LimparAreaItem;
  ReagendarFocoNoCampo(DBEditCodigoCliente);
end;

procedure TForm_Venda.BtnEditarClick(Sender: TObject);
begin
  if Dm.SqlVenda.IsEmpty then
    Exit;
  if Dm.SqlVendaSITUACAO.AsString = 'F' then
  begin
    MensagemDlg('A venda esta fechada. Use "Abrir Venda" para reabri-la ' +
      'antes de alterar.', mtInformation, [mbOK], 0);
    Exit;
  end;
  Dm.SqlVenda.Edit;
  ReagendarFocoNoCampo(DBEditCodigoCliente);
end;

procedure TForm_Venda.BtnGravarClick(Sender: TObject);
begin
  if not (Dm.SqlVenda.State in [dsInsert, dsEdit]) then
    Exit;
  if not ValidarCliente(True) then
    Exit;
  GravarCabecalho;
  if Dm.SqlVenda.State = dsBrowse then
  begin
    ObserveLogShowMessage('Venda gravada com sucesso.');
    ShowMessage('Venda gravada com sucesso.');
    ObserveEmitSnapshot(Self, Dm.SqlVenda);
  end;
end;

procedure TForm_Venda.BtnCancelarMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FIgnorarValidacao := True;
end;

procedure TForm_Venda.BtnCancelarClick(Sender: TObject);
begin
  try
    if Dm.SqlVenda.State in [dsInsert, dsEdit] then
    begin
      if MensagemDlg('Descartar as alteracoes desta venda?',
           mtConfirmation, [mbYes, mbNo], 0) = mrYes then
        Dm.SqlVenda.Cancel;
    end;
  finally
    FIgnorarValidacao := False;
  end;
end;

procedure TForm_Venda.BtnExcluirClick(Sender: TObject);
var
  Codigo, Cliente, Total: string;
  Resposta: Integer;
begin
  if not Assigned(Dm) or not Assigned(Dm.SqlVenda) or
     Dm.SqlVenda.IsEmpty then
  begin
    ObserveLogShowMessage('Nao ha venda selecionada para excluir.');
    ShowMessage('Nao ha venda selecionada para excluir.');
    Exit;
  end;

  Codigo  := Dm.SqlVendaCODIGO.AsString;
  Cliente := Dm.SqlVendaNOMECLIENTTE.AsString;
  Total   := FormatFloat('#,##0.00', Dm.SqlVendaTOTAL_LIQUIDO.AsFloat);

  Resposta := MensagemDlg(
    Format(
      'Deseja realmente excluir a venda abaixo e todos os seus itens?' +
      sLineBreak + sLineBreak +
      '   Codigo : %s' + sLineBreak +
      '   Cliente: %s' + sLineBreak +
      '   Total  : R$ %s' + sLineBreak + sLineBreak +
      'Essa operacao nao podera ser desfeita.',
      [Codigo, Cliente, Total]),
    mtWarning, [mbYes, mbNo], 0, mbNo);

  if Resposta <> mrYes then
    Exit;

  try
    // Remove primeiro os itens (detalhe), depois o cabecalho.
    if Query.Active then
      Query.Close;
    Query.SQL.Text :=
      'delete from Venda_Item where CODIGO_VENDA = :CODIGO_VENDA';
    Query.ParamByName('CODIGO_VENDA').AsInteger :=
      Dm.SqlVendaCODIGO.AsInteger;
    Query.ExecSQL;

    Dm.SqlVenda.Delete;
    ObserveLogDelete(Self, 'Venda');
    Dm.SqlVenda.ApplyUpdates;
    ObserveLogApplyUpdates(Self, 'Venda');
    Dm.IBTransaction1.CommitRetaining;
    ObserveLogCommit(Self, 'Venda');
    ObserveLogShowMessage('Venda excluida com sucesso.');
    ShowMessage('Venda excluida com sucesso.');
  except
    on E: Exception do
    begin
      if Dm.IBTransaction1.InTransaction then
        Dm.IBTransaction1.Rollback;
      ObserveLogRollback(Self, 'Venda', E.Message);
      ObserveLogException(E.Message, 'BtnExcluir', ClassName);
      MensagemDlg('Erro ao excluir: ' + E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

procedure TForm_Venda.BtnSairMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FIgnorarValidacao := True;
end;

procedure TForm_Venda.BtnSairClick(Sender: TObject);
begin
  try
    // Sair abandona qualquer edicao pendente e fecha imediatamente.
    if Assigned(Dm) and Assigned(Dm.SqlVenda) and
       (Dm.SqlVenda.State in [dsInsert, dsEdit]) then
      Dm.SqlVenda.Cancel;
    Close;
  finally
    FIgnorarValidacao := False;
  end;
end;

{ Fechar / Abrir venda }

procedure TForm_Venda.BtnFecharVendaClick(Sender: TObject);
var
  NovaSituacao: string;
begin
  if Dm.SqlVenda.IsEmpty then
    Exit;
  if Dm.SqlVenda.State in [dsInsert, dsEdit] then
    Exit;

  if Dm.SqlVendaSITUACAO.AsString = 'A' then
  begin
    // Fechar: exige total liquido maior que zero.
    if Dm.SqlVendaTOTAL_LIQUIDO.AsFloat <= 0 then
    begin
      MensagemDlg('A venda nao possui itens. Adicione ao menos um item ' +
        'antes de fechar.', mtInformation, [mbOK], 0);
      Exit;
    end;
    NovaSituacao := 'F';
  end
  else
    NovaSituacao := 'A';

  try
    Dm.SqlVenda.Edit;
    Dm.SqlVendaSITUACAO.AsString := NovaSituacao;
    Dm.SqlVenda.Post;
    Dm.SqlVenda.ApplyUpdates;
    Dm.IBTransaction1.CommitRetaining;

    // Log de estoque via stored procedure (mesma regra original).
    Try
      QueryAtualizaEstoque.SQL.Text :=
      'EXECUTE PROCEDURE SP_LOG_ESTOQUE (:CODIGO_VENDA)';
      QueryAtualizaEstoque.ParamByName('CODIGO_VENDA').AsInteger :=
        Dm.SqlVendaCODIGO.AsInteger;
      QueryAtualizaEstoque.ExecSQL;
      Dm.IBTransaction1.CommitRetaining;
    except
      on E: Exception do
      begin
        if Dm.IBTransaction1.InTransaction then
          Dm.IBTransaction1.Rollback;
        MensagemDlg('Erro ao atualizar LOG Estoque: ' + E.Message, mtError, [mbOK], 0);
      end;
    end;
    try
      QueryAtualizar.SQL.Text :=
      'EXECUTE PROCEDURE SP_ATUALIZAR_TT_COMPRAS (:CODIGO_CLIENTE)';
      QueryAtualizar.ParamByName('CODIGO_CLIENTE').AsInteger := Dm.SqlVendaCODIGO_CLIENTE.AsInteger;
      QueryAtualizar.ExecSQL;
      Dm.IBTransaction1.CommitRetaining;
    except
      on E: Exception do
      begin
        if Dm.IBTransaction1.InTransaction then
          Dm.IBTransaction1.Rollback;
        MensagemDlg('Erro ao atualizar Compras CLIENTE: ' + E.Message, mtError, [mbOK], 0);
      end;
    end;
  except
    on E: Exception do
    begin
      if Dm.SqlVenda.State in [dsInsert, dsEdit] then
        Dm.SqlVenda.Cancel;
      if Dm.IBTransaction1.InTransaction then
        Dm.IBTransaction1.Rollback;
      MensagemDlg('Erro ao alterar a situacao da venda: ' + E.Message,
        mtError, [mbOK], 0);
      Exit;
    end;
  end;

  AtualizarEstadoUI;
  if NovaSituacao = 'A' then
    ReagendarFocoNoCampo(EditCodigoProduto);
end;

{ Actions }

procedure TForm_Venda.ActPrimeiroExecute(Sender: TObject);
begin
  ObserveLogAction(Self, 'ActPrimeiro', 'BtnPrimeiro');
  if BtnPrimeiro.Enabled then
    BtnPrimeiroClick(BtnPrimeiro);
end;

procedure TForm_Venda.ActAnteriorExecute(Sender: TObject);
begin
  ObserveLogAction(Self, 'ActAnterior', 'BtnAnterior');
  if BtnAnterior.Enabled then
    BtnAnteriorClick(BtnAnterior);
end;

procedure TForm_Venda.ActProximoExecute(Sender: TObject);
begin
  ObserveLogAction(Self, 'ActProximo', 'BtnProximo');
  if BtnProximo.Enabled then
    BtnProximoClick(BtnProximo);
end;

procedure TForm_Venda.ActUltimoExecute(Sender: TObject);
begin
  ObserveLogAction(Self, 'ActUltimo', 'BtnUltimo');
  if BtnUltimo.Enabled then
    BtnUltimoClick(BtnUltimo);
end;

procedure TForm_Venda.ActInserirExecute(Sender: TObject);
begin
  ObserveLogAction(Self, 'ActInserir', 'BtnInserir');
  if BtnInserir.Enabled then
    BtnInserirClick(BtnInserir);
end;

procedure TForm_Venda.ActEditarExecute(Sender: TObject);
begin
  ObserveLogAction(Self, 'ActEditar', 'BtnEditar');
  if BtnEditar.Enabled then
    BtnEditarClick(BtnEditar);
end;

procedure TForm_Venda.ActGravarExecute(Sender: TObject);
begin
  ObserveLogAction(Self, 'ActGravar', 'BtnGravar');
  if BtnGravar.Enabled then
    BtnGravarClick(BtnGravar);
end;

procedure TForm_Venda.ActCancelarExecute(Sender: TObject);
begin
  ObserveLogAction(Self, 'ActCancelar', 'BtnCancelar');
  if BtnCancelar.Enabled then
  begin
    FIgnorarValidacao := True;
    try
      BtnCancelarClick(BtnCancelar);
    finally
      FIgnorarValidacao := False;
    end;
  end;
end;

procedure TForm_Venda.ActExcluirExecute(Sender: TObject);
begin
  ObserveLogAction(Self, 'ActExcluir', 'BtnExcluir');
  if BtnExcluir.Enabled then
    BtnExcluirClick(BtnExcluir);
end;

end.
