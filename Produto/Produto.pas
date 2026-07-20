unit Produto;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Classes, System.Actions,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Mask, Vcl.DBCtrls,
  Vcl.Buttons, Vcl.ActnList, Vcl.WinXCtrls, Vcl.ComCtrls,
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

  // Cores alternadas das linhas do grid (zebra)
  COR_GRID_LINHA_PAR   = clWhite;
  COR_GRID_LINHA_IMPAR = $00F3E9DC;
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

type
  TForm_Produto = class(TForm)
    Panel_Titulo: TPanel;
    PanelEstado: TPanel;
    LabelEstadoAtual: TLabel;

    PanelDados: TPanel;
    PageControlProduto: TPageControl;
    TabCadastro: TTabSheet;
    TabMovimentacao: TTabSheet;

    PanelIdentificacao: TPanel;
    LabelSecaoIdent: TLabel;

    LabelCodigo: TLabel;
    DBEditCodigo: TDBEdit;

    LabelDescricao: TLabel;
    LabelDescricaoAst: TLabel;
    DBEditDescricao: TDBEdit;

    LabelReferencia: TLabel;
    LabelReferenciaAst: TLabel;
    DBEditReferencia: TDBEdit;

    LabelCodigoBarras: TLabel;
    LabelCodigoBarrasAst: TLabel;
    DBEditCodigoBarras: TDBEdit;

    LabelMarca: TLabel;
    DBEditMarca: TDBEdit;

    LabelGrupo: TLabel;
    DBEditGrupo: TDBEdit;

    GroupBoxValores: TGroupBox;
    LabelUnd: TLabel;
    LabelUndAst: TLabel;
    DBEditUnd: TDBEdit;
    LabelPrecoCusto: TLabel;
    DBEditPrecoCusto: TDBEdit;
    LabelPrecoVenda: TLabel;
    DBEditPrecoVenda: TDBEdit;
    LabelEstoqueAtual: TLabel;
    DBEditEstoqueAtual: TDBEdit;
    LabelMargemLucro: TLabel;
    DBEditMargemLucro: TDBEdit;

    DBGridVndaItem: TDBGrid;
    PanelTotaisMov: TPanel;
    LabelTotalItens: TLabel;
    EditTotalItens: TEdit;
    LabelTotalLiquidoMov: TLabel;
    EditTotalLiquidoMov: TEdit;
    QueryMovProduto: TIBQuery;
    DsMovProduto: TDataSource;

    PanelRodape: TPanel;
    BtnPrimeiro: TBitBtn;
    BtnAnterior: TBitBtn;
    BtnProximo: TBitBtn;
    BtnUltimo: TBitBtn;
    ShapeSep: TBevel;
    BtnInserir: TBitBtn;
    BtnEditar: TBitBtn;
    BtnGravar: TBitBtn;
    BtnCancelar: TBitBtn;
    BtnExcluir: TBitBtn;
    BtnSair: TBitBtn;

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

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormActivate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);

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

    procedure ActPrimeiroExecute(Sender: TObject);
    procedure ActAnteriorExecute(Sender: TObject);
    procedure ActProximoExecute(Sender: TObject);
    procedure ActUltimoExecute(Sender: TObject);
    procedure ActInserirExecute(Sender: TObject);
    procedure ActEditarExecute(Sender: TObject);
    procedure ActGravarExecute(Sender: TObject);
    procedure ActCancelarExecute(Sender: TObject);
    procedure ActExcluirExecute(Sender: TObject);

    procedure DBEditObrigatorioExit(Sender: TObject);
    procedure DBEditCodigoBarrasKeyPress(Sender: TObject; var Key: Char);
    procedure DBEditValorPositivoExit(Sender: TObject);
    procedure DBEditPrecoCustoExit(Sender: TObject);
    procedure EditFocoEnter(Sender: TObject);
    procedure EditFocoExit(Sender: TObject);
    procedure PageControlProdutoChange(Sender: TObject);
    procedure DBGridVndaItemDrawColumnCell(Sender: TObject;
      const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);
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
    procedure AtualizarEstadoUI;
    procedure RecalcularMargemLucro;
    procedure ConfigurarQueryMovimentacao;
    procedure CarregarMovimentacao;
    procedure AtualizarTotaisMovimentacao;

    procedure DsProdutoDataChangeChained(Sender: TObject; Field: TField);
    procedure DsProdutoStateChangeChained(Sender: TObject);

    function ValidarCamposObrigatorios: Boolean;
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
  Form_Produto: TForm_Produto;

implementation

uses DataModule, Mensagens, ObserveHooks, UITheme;

{$R *.dfm}

{ Utilitarios locais }

procedure TForm_Produto.ConfigurarGlyphsBotoes;
begin
  AplicarBotaoBootstrap(BtnPrimeiro, bbkOutline, ICN_PRIMEIRO);
  AplicarBotaoBootstrap(BtnAnterior, bbkOutline, ICN_ANTERIOR);
  AplicarBotaoBootstrap(BtnProximo, bbkOutline, ICN_PROXIMO);
  AplicarBotaoBootstrap(BtnUltimo, bbkOutline, ICN_ULTIMO);
  AplicarBotaoBootstrap(BtnInserir, bbkSuccess, ICN_INSERIR);
  AplicarBotaoBootstrap(BtnEditar, bbkWarning, ICN_EDITAR);
  AplicarBotaoBootstrap(BtnGravar, bbkPrimary, ICN_GRAVAR);
  AplicarBotaoBootstrap(BtnCancelar, bbkSecondary, ICN_CANCELAR);
  AplicarBotaoBootstrap(BtnExcluir, bbkDanger, ICN_EXCLUIR);
  AplicarBotaoBootstrap(BtnSair, bbkSecondary, ICN_SAIR);
end;

procedure TForm_Produto.AplicarLayoutInicial;
begin
  Color := COR_PAGE;
  AplicarHeaderPrimary(Panel_Titulo);
  AplicarFormEstiloWeb(Self);
  AplicarPainelCard(PanelIdentificacao);
  AplicarGrupoCard(GroupBoxValores);
  LabelDescricaoAst.Font.Color    := clRed;
  LabelReferenciaAst.Font.Color   := clRed;
  LabelCodigoBarrasAst.Font.Color := clRed;
  LabelUndAst.Font.Color          := clRed;
end;

function TForm_Produto.ControleEmSomenteLeitura(Ctrl: TWinControl): Boolean;
begin
  Result := False;
  if Ctrl is TDBEdit then
    Result := TDBEdit(Ctrl).ReadOnly
  else if Ctrl is TDBMemo then
    Result := TDBMemo(Ctrl).ReadOnly;
end;

procedure TForm_Produto.DefinirCorFundo(Ctrl: TWinControl; Cor: TColor);
begin
  if Ctrl is TDBEdit then
    TDBEdit(Ctrl).Color := Cor
  else if Ctrl is TDBMemo then
    TDBMemo(Ctrl).Color := Cor;
end;

procedure TForm_Produto.EditFocoEnter(Sender: TObject);
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
  // Campo re-focado por erro de validacao permanece em vermelho claro
  // (sem isso, o realce de foco apagaria a cor de erro aplicada no OnExit).
  if Sender = FCampoComErro then
    DefinirCorFundo(TWinControl(Sender), COR_EDIT_ERRO)
  else
    DefinirCorFundo(TWinControl(Sender), COR_EDIT_FOCO);
end;

procedure TForm_Produto.EditFocoExit(Sender: TObject);
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

procedure TForm_Produto.AtualizarEstadoUI;
var
  Estado: TDataSetState;
  ModoTexto: string;
  CorFundo, CorTexto: TColor;
  EmEdicao: Boolean;
  CorCampos: TColor;
begin
  if not Assigned(Dm) or not Assigned(Dm.SqlProduto) then
    Exit;

  Estado   := Dm.SqlProduto.State;
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

  DBEditDescricao.ReadOnly    := not EmEdicao;
  DBEditReferencia.ReadOnly   := not EmEdicao;
  DBEditCodigoBarras.ReadOnly := not EmEdicao;
  DBEditMarca.ReadOnly        := not EmEdicao;
  DBEditGrupo.ReadOnly        := not EmEdicao;
  DBEditUnd.ReadOnly          := not EmEdicao;
  DBEditPrecoCusto.ReadOnly   := not EmEdicao;
  DBEditPrecoVenda.ReadOnly   := not EmEdicao;
  DBEditEstoqueAtual.ReadOnly := not EmEdicao;
  DBEditMargemLucro.ReadOnly  := True;

  if EmEdicao then
    CorCampos := COR_EDIT_NORMAL
  else
    CorCampos := COR_EDIT_READONLY;

  DBEditDescricao.Color    := CorCampos;
  DBEditReferencia.Color   := CorCampos;
  DBEditCodigoBarras.Color := CorCampos;
  DBEditMarca.Color        := CorCampos;
  DBEditGrupo.Color        := CorCampos;
  DBEditUnd.Color          := CorCampos;
  DBEditPrecoCusto.Color   := CorCampos;
  DBEditPrecoVenda.Color   := CorCampos;
  DBEditEstoqueAtual.Color := CorCampos;
  DBEditMargemLucro.Color  := COR_EDIT_READONLY;
end;

procedure TForm_Produto.RecalcularMargemLucro;
var
  lCusto, lVenda, lMargem: Double;
begin
  if not Assigned(Dm) or not Assigned(Dm.SqlProduto) then
    Exit;
  if not (Dm.SqlProduto.State in [dsInsert, dsEdit]) then
    Exit;

  lCusto := Dm.SqlProduto.FieldByName('PRECO_CUSTO').AsFloat;
  lVenda := Dm.SqlProduto.FieldByName('PRECO_VENDA').AsFloat;
  if lCusto > 0 then
    lMargem := ((lVenda - lCusto) / lCusto) * 100
  else
    lMargem := 0;

  lMargem := Round(lMargem * 100) / 100;
  Dm.SqlProduto.FieldByName('MARGEM_LUCRO').AsFloat := lMargem;
end;

procedure TForm_Produto.ConfigurarQueryMovimentacao;
begin
  if not Assigned(QueryMovProduto) then
    Exit;

  if QueryMovProduto.Active then
    QueryMovProduto.Close;

  // SQL definido em codigo para o IBX criar o parametro via ParamCheck
  // (mesmo padrao de ConsultaProduto).
  QueryMovProduto.SQL.Text :=
    'select vc.codigo, vc.data_hora_venda, vi.codigo_produto, pr.descricao, ' +
    'vi.quantidade, vi.preco_unitario, vi.total_liquido ' +
    'from venda vc ' +
    'inner join venda_item vi on vi.codigo_venda = vc.codigo ' +
    'inner join produto pr on pr.codigo = vi.codigo_produto ' +
    'where vi.codigo_produto = :CODIGO_PRODUTO ' +
    'order by vc.data_hora_venda desc, vc.codigo desc';
end;

procedure TForm_Produto.CarregarMovimentacao;
begin
  if not Assigned(QueryMovProduto) then
    Exit;

  if QueryMovProduto.Active then
    QueryMovProduto.Close;

  if QueryMovProduto.SQL.Text = '' then
    ConfigurarQueryMovimentacao;

  if (not Assigned(Dm)) or (not Assigned(Dm.SqlProduto)) or
     Dm.SqlProduto.IsEmpty or (Dm.SqlProduto.State = dsInsert) or
     (Dm.SqlProduto.FieldByName('CODIGO').AsInteger <= 0) then
  begin
    AtualizarTotaisMovimentacao;
    Exit;
  end;

  if QueryMovProduto.Params.FindParam('CODIGO_PRODUTO') = nil then
    ConfigurarQueryMovimentacao;

  QueryMovProduto.ParamByName('CODIGO_PRODUTO').AsInteger :=
    Dm.SqlProduto.FieldByName('CODIGO').AsInteger;
  QueryMovProduto.Open;

  if QueryMovProduto.FindField('DATA_HORA_VENDA') is TDateTimeField then
    TDateTimeField(QueryMovProduto.FieldByName('DATA_HORA_VENDA')).DisplayFormat :=
      'dd/mm/yyyy hh:nn';
  if QueryMovProduto.FindField('QUANTIDADE') is TNumericField then
    TNumericField(QueryMovProduto.FieldByName('QUANTIDADE')).DisplayFormat :=
      '#,##0.000';
  if QueryMovProduto.FindField('PRECO_UNITARIO') is TNumericField then
    TNumericField(QueryMovProduto.FieldByName('PRECO_UNITARIO')).DisplayFormat :=
      '#,##0.00';
  if QueryMovProduto.FindField('TOTAL_LIQUIDO') is TNumericField then
    TNumericField(QueryMovProduto.FieldByName('TOTAL_LIQUIDO')).DisplayFormat :=
      '#,##0.00';

  AtualizarTotaisMovimentacao;
end;

procedure TForm_Produto.AtualizarTotaisMovimentacao;
var
  lTotItens, lTotLiquido: Double;
begin
  lTotItens   := 0;
  lTotLiquido := 0;

  if Assigned(QueryMovProduto) and QueryMovProduto.Active and
     (not QueryMovProduto.IsEmpty) then
  begin
    QueryMovProduto.DisableControls;
    try
      QueryMovProduto.First;
      while not QueryMovProduto.Eof do
      begin
        lTotItens   := lTotItens +
          QueryMovProduto.FieldByName('QUANTIDADE').AsFloat;
        lTotLiquido := lTotLiquido +
          QueryMovProduto.FieldByName('TOTAL_LIQUIDO').AsFloat;
        QueryMovProduto.Next;
      end;
      QueryMovProduto.First;
    finally
      QueryMovProduto.EnableControls;
    end;
  end;

  EditTotalItens.Text       := FormatFloat('#,##0.000', lTotItens);
  EditTotalLiquidoMov.Text  := FormatFloat('#,##0.00', lTotLiquido);
end;

procedure TForm_Produto.PageControlProdutoChange(Sender: TObject);
begin
  if PageControlProduto.ActivePage = TabMovimentacao then
    CarregarMovimentacao;
end;

procedure TForm_Produto.DBGridVndaItemDrawColumnCell(Sender: TObject;
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

{ Chained events do DataSource }

procedure TForm_Produto.DsProdutoDataChangeChained(Sender: TObject;
  Field: TField);
begin
  if Assigned(FOldDataChange) then
    FOldDataChange(Sender, Field);
  if Assigned(Field) and
     ((Field.FieldName = 'PRECO_CUSTO') or (Field.FieldName = 'PRECO_VENDA')) then
    RecalcularMargemLucro;
  if (Field = nil) or SameText(Field.FieldName, 'CODIGO') then
    CarregarMovimentacao;
  AtualizarEstadoUI;
end;

procedure TForm_Produto.DsProdutoStateChangeChained(Sender: TObject);
begin
  if Assigned(FOldStateChange) then
    FOldStateChange(Sender);
  AtualizarEstadoUI;
end;

{ Validacoes }

procedure TForm_Produto.MostrarBaloonErro(Edit: TCustomEdit;
  const Titulo, Texto: string);
begin
  if not Assigned(Edit) or not Assigned(FBalloonHint) then
    Exit;
  FBalloonHint.HideHint;
  FBalloonHint.Title       := Titulo;
  FBalloonHint.Description := Texto;
  FBalloonHint.ShowHint(Edit);
end;

procedure TForm_Produto.ReagendarFocoNoCampo(Edit: TWinControl);
begin
  if Assigned(Edit) then
    PostMessage(Self.Handle, WM_REFOCAR, WPARAM(Pointer(Edit)), 0);
end;

procedure TForm_Produto.FocarControleSeguro(Ctrl: TWinControl);
begin
  if (Ctrl = nil) or (not Ctrl.Showing) or (not Ctrl.CanFocus) then
    Exit;
  try
    Ctrl.SetFocus;
  except
    on EInvalidOperation do
      ;
  end;
end;

procedure TForm_Produto.WMRefocar(var Msg: TMessage);
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

procedure TForm_Produto.DBEditObrigatorioExit(Sender: TObject);
var
  Edit: TDBEdit;
  Rotulo: string;
  FocoDestino: HWND;
begin
  if FValidando then
    Exit;

  Edit := Sender as TDBEdit;
  Edit.Color := COR_EDIT_NORMAL;
  if FCampoComErro = Edit then
    FCampoComErro := nil;

  if FIgnorarValidacao then
    Exit;
  if csDestroying in ComponentState then
    Exit;
  if not Assigned(Dm) or not Assigned(Dm.SqlProduto) then
    Exit;
  if not (Dm.SqlProduto.State in [dsInsert, dsEdit]) then
    Exit;

  // Permite sair sem validacao quando o proximo foco for Cancelar ou Sair
  // (MouseDown do botao pode ocorrer apos o OnExit).
  FocoDestino := GetFocus;
  if (FocoDestino <> 0) and
     ((BtnCancelar.HandleAllocated and (FocoDestino = BtnCancelar.Handle)) or
      (BtnSair.HandleAllocated and (FocoDestino = BtnSair.Handle))) then
    Exit;

  if Edit.Hint <> '' then
    Rotulo := Edit.Hint
  else
    Rotulo := Edit.Name;

  if Trim(Edit.Text) = '' then
  begin
    Edit.Color    := COR_EDIT_ERRO;
    FCampoComErro := Edit;
    MostrarBaloonErro(Edit, 'Campo obrigatorio',
      'O campo ' + Rotulo + ' deve ser preenchido.');
    ReagendarFocoNoCampo(Edit);
  end
  else if Edit.Name = FObserveEnterControl then
    ObserveLogFill(Self, Edit.Name, FObserveEnterValue, Edit.Text);
end;

procedure TForm_Produto.DBEditCodigoBarrasKeyPress(Sender: TObject;
  var Key: Char);
begin
  // Codigo de barras e Int64 (TLargeintField) - aceita somente digitos.
  if CharInSet(Key, [#8, #9, #13, #27]) then
    Exit;
  if not CharInSet(Key, ['0'..'9']) then
    Key := #0;
end;

procedure TForm_Produto.DBEditValorPositivoExit(Sender: TObject);
var
  Edit: TDBEdit;
  Valor: Double;
  FocoDestino: HWND;
  Rotulo: string;
begin
  if FValidando then
    Exit;

  Edit := Sender as TDBEdit;
  Edit.Color := COR_EDIT_NORMAL;
  if FCampoComErro = Edit then
    FCampoComErro := nil;

  if FIgnorarValidacao then
    Exit;
  if csDestroying in ComponentState then
    Exit;
  if not Assigned(Dm) or not Assigned(Dm.SqlProduto) then
    Exit;
  if not (Dm.SqlProduto.State in [dsInsert, dsEdit]) then
    Exit;
  if not Assigned(Edit.Field) then
    Exit;

  FocoDestino := GetFocus;
  if (FocoDestino <> 0) and
     ((BtnCancelar.HandleAllocated and (FocoDestino = BtnCancelar.Handle)) or
      (BtnSair.HandleAllocated and (FocoDestino = BtnSair.Handle))) then
    Exit;

  Valor := Edit.Field.AsFloat;
  if Valor < 0 then
  begin
    if Edit.Hint <> '' then
      Rotulo := Edit.Hint
    else
      Rotulo := Edit.Name;
    Edit.Color    := COR_EDIT_ERRO;
    FCampoComErro := Edit;
    MostrarBaloonErro(Edit, 'Valor invalido',
      Rotulo + ' nao pode ser negativo.');
    ReagendarFocoNoCampo(Edit);
  end
  else if Edit.Name = FObserveEnterControl then
    ObserveLogFill(Self, Edit.Name, FObserveEnterValue, Edit.Text);

  if (Edit = DBEditPrecoVenda) or (Edit = DBEditPrecoCusto) then
    RecalcularMargemLucro;
end;

procedure TForm_Produto.DBEditPrecoCustoExit(Sender: TObject);
begin
  DBEditValorPositivoExit(Sender);
end;

function TForm_Produto.ValidarCamposObrigatorios: Boolean;

  function CampoVazio(Edit: TDBEdit): Boolean;
  begin
    Result := (Edit.Field = nil) or (Trim(Edit.Field.AsString) = '');
  end;

  function FalharEm(Edit: TDBEdit; const Rotulo: string): Boolean;
  begin
    Edit.Color    := COR_EDIT_ERRO;
    FCampoComErro := Edit;
    MostrarBaloonErro(Edit, 'Campo obrigatorio',
      'O campo ' + Rotulo + ' deve ser preenchido.');
    ReagendarFocoNoCampo(Edit);
    Result := False;
  end;

begin
  Result := True;
  if CampoVazio(DBEditDescricao)    then Exit(FalharEm(DBEditDescricao,    'Descricao'));
  if CampoVazio(DBEditReferencia)   then Exit(FalharEm(DBEditReferencia,   'Referencia'));
  if CampoVazio(DBEditCodigoBarras) then Exit(FalharEm(DBEditCodigoBarras, 'Codigo de Barras'));
  if CampoVazio(DBEditUnd)          then Exit(FalharEm(DBEditUnd,          'UND'));

  if Assigned(DBEditPrecoCusto.Field) and (DBEditPrecoCusto.Field.AsFloat < 0) then
  begin
    DBEditPrecoCusto.Color := COR_EDIT_ERRO;
    FCampoComErro          := DBEditPrecoCusto;
    MostrarBaloonErro(DBEditPrecoCusto, 'Valor invalido',
      'O preco de custo nao pode ser negativo.');
    ReagendarFocoNoCampo(DBEditPrecoCusto);
    Result := False;
    Exit;
  end;

  if Assigned(DBEditPrecoVenda.Field) and (DBEditPrecoVenda.Field.AsFloat < 0) then
  begin
    DBEditPrecoVenda.Color := COR_EDIT_ERRO;
    FCampoComErro          := DBEditPrecoVenda;
    MostrarBaloonErro(DBEditPrecoVenda, 'Valor invalido',
      'O preco de venda nao pode ser negativo.');
    ReagendarFocoNoCampo(DBEditPrecoVenda);
    Result := False;
    Exit;
  end;

  if Assigned(DBEditEstoqueAtual.Field) and (DBEditEstoqueAtual.Field.AsFloat < 0) then
  begin
    DBEditEstoqueAtual.Color := COR_EDIT_ERRO;
    FCampoComErro            := DBEditEstoqueAtual;
    MostrarBaloonErro(DBEditEstoqueAtual, 'Valor invalido',
      'O estoque atual nao pode ser negativo.');
    ReagendarFocoNoCampo(DBEditEstoqueAtual);
    Result := False;
  end;
end;

{ Ciclo de vida }

procedure TForm_Produto.FormCreate(Sender: TObject);
begin
  FValidando        := False;
  FIgnorarValidacao := False;

  FBalloonHint := TBalloonHint.Create(Self);
  FBalloonHint.Style     := bhsStandard;
  FBalloonHint.Delay     := 0;
  FBalloonHint.HideAfter := 4000;

  if not Dm.SqlProduto.Active then
    Dm.SqlProduto.Open;

  ConfigurarGlyphsBotoes;
  AplicarLayoutInicial;

  FOldDataChange  := Dm.DsProduto.OnDataChange;
  FOldStateChange := Dm.DsProduto.OnStateChange;
  Dm.DsProduto.OnDataChange  := DsProdutoDataChangeChained;
  Dm.DsProduto.OnStateChange := DsProdutoStateChangeChained;

  AtualizarEstadoUI;
  ConfigurarQueryMovimentacao;
  CarregarMovimentacao;
  ObserveLogOpenForm(Self);
  ObserveEmitSnapshot(Self, Dm.SqlProduto);
end;

procedure TForm_Produto.FormDestroy(Sender: TObject);
begin
  if Assigned(QueryMovProduto) and QueryMovProduto.Active then
    QueryMovProduto.Close;

  if Assigned(Dm) and Assigned(Dm.DsProduto) then
  begin
    if TMethod(Dm.DsProduto.OnDataChange).Data = Self then
      Dm.DsProduto.OnDataChange := FOldDataChange;
    if TMethod(Dm.DsProduto.OnStateChange).Data = Self then
      Dm.DsProduto.OnStateChange := FOldStateChange;
  end;
end;

procedure TForm_Produto.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ObserveLogCloseForm(Self);
  Action       := caFree;
  Form_Produto := nil;
end;

procedure TForm_Produto.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := True;
  if Assigned(Dm) and Assigned(Dm.SqlProduto) and
     (Dm.SqlProduto.State in [dsInsert, dsEdit]) then
  begin
    case MensagemDlg(
      'Existem alteracoes nao gravadas. Deseja descarta-las e fechar?',
      mtConfirmation, [mbYes, mbNo], 0) of
      mrYes:
        begin
          Dm.SqlProduto.Cancel;
          CanClose := True;
        end;
    else
      CanClose := False;
    end;
  end;
end;

procedure TForm_Produto.FormActivate(Sender: TObject);
begin
  ReagendarFocoNoCampo(BtnInserir);
end;

procedure TForm_Produto.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
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

  // Seta para CIMA volta ao campo anterior, mesmo que o campo atual
  // esteja invalido (rota de escape da validacao imediata).
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

  if Key = VK_ESCAPE then
  begin
    if Assigned(Dm) and Assigned(Dm.SqlProduto) and
       (Dm.SqlProduto.State in [dsInsert, dsEdit]) then
      Exit;
    Close;
  end;
end;

{ Navegacao }

procedure TForm_Produto.BtnPrimeiroClick(Sender: TObject);
begin
  Dm.SqlProduto.First;
end;

procedure TForm_Produto.BtnAnteriorClick(Sender: TObject);
begin
  Dm.SqlProduto.Prior;
end;

procedure TForm_Produto.BtnProximoClick(Sender: TObject);
begin
  Dm.SqlProduto.Next;
end;

procedure TForm_Produto.BtnUltimoClick(Sender: TObject);
begin
  Dm.SqlProduto.Last;
end;

{ CRUD }

procedure TForm_Produto.BtnInserirClick(Sender: TObject);
begin
  Dm.SqlProduto.Insert;
  DBEditPrecoCusto.Field.AsFloat   := 0.00;
  DBEditPrecoVenda.Field.AsFloat   := 0.00;
  DBEditMargemLucro.Field.AsFloat  := 0.00;
  DBEditEstoqueAtual.Field.AsFloat := 0.00;
  DBEditUnd.Field.AsString         := '';
  if Dm.QueryId.Active then
    Dm.QueryId.Close;
  Dm.QueryId.SQL.Text :=
    'SELECT COALESCE(MAX(CODIGO),0) + 1 AS CODIGO FROM PRODUTO';
  Dm.QueryId.Open;
  try
    if Dm.SqlProduto.State = dsInsert then
      DBEditCodigo.Field.AsString :=
        Dm.QueryId.FieldByName('CODIGO').AsString;
  finally
    Dm.QueryId.Close;
  end;

  ReagendarFocoNoCampo(DBEditDescricao);
end;

procedure TForm_Produto.BtnEditarClick(Sender: TObject);
begin
  Dm.SqlProduto.Edit;
  ReagendarFocoNoCampo(DBEditDescricao);
end;

procedure TForm_Produto.BtnGravarClick(Sender: TObject);
begin
  if not (Dm.SqlProduto.State in [dsInsert, dsEdit]) then
    Exit;

  if not ValidarCamposObrigatorios then
    Exit;

  RecalcularMargemLucro;

  ObserveEmitSnapshot(Self, Dm.SqlProduto);
  try
    Dm.SqlProduto.Post;
    ObserveLogPost(Self, 'Produto');
    Dm.SqlProduto.ApplyUpdates;
    ObserveLogApplyUpdates(Self, 'Produto');
    Dm.IBTransaction1.CommitRetaining;
    ObserveLogCommit(Self, 'Produto');
    ObserveLogShowMessage('Produto gravado com sucesso.');
    ShowMessage('Produto gravado com sucesso.');
    ObserveEmitSnapshot(Self, Dm.SqlProduto);
  except
    on E: Exception do
    begin
      if Dm.IBTransaction1.InTransaction then
        Dm.IBTransaction1.Rollback;
      ObserveLogRollback(Self, 'Produto', E.Message);
      ObserveLogException(E.Message, 'BtnGravar', ClassName);
      MensagemDlg('Erro na gravacao: ' + E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

procedure TForm_Produto.BtnCancelarMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FIgnorarValidacao := True;
end;

procedure TForm_Produto.BtnCancelarClick(Sender: TObject);
begin
  try
    if Dm.SqlProduto.State in [dsInsert, dsEdit] then
    begin
      if MensagemDlg('Descartar as alteracoes deste registro?',
           mtConfirmation, [mbYes, mbNo], 0) = mrYes then
        Dm.SqlProduto.Cancel;
    end;
  finally
    FIgnorarValidacao := False;
  end;
end;

procedure TForm_Produto.BtnSairMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  // Como no BtnCancelar: o usuario pode sair mesmo com um campo
  // invalido focado - suprime a validacao OnExit durante o clique.
  FIgnorarValidacao := True;
end;

procedure TForm_Produto.BtnSairClick(Sender: TObject);
begin
  try
    // Sair abandona qualquer edicao pendente e fecha imediatamente,
    // sem confirmacao. Com o dataset de volta em dsBrowse, o
    // FormCloseQuery nao pergunta nada.
    if Assigned(Dm) and Assigned(Dm.SqlProduto) and
       (Dm.SqlProduto.State in [dsInsert, dsEdit]) then
      Dm.SqlProduto.Cancel;
    Close;
  finally
    FIgnorarValidacao := False;
  end;
end;

procedure TForm_Produto.BtnExcluirClick(Sender: TObject);
var
  Descricao, Codigo: string;
  Resposta: Integer;
begin
  if not Assigned(Dm) or not Assigned(Dm.SqlProduto) or
     Dm.SqlProduto.IsEmpty then
  begin
    ObserveLogShowMessage('Nao ha produto selecionado para excluir.');
    ShowMessage('Nao ha produto selecionado para excluir.');
    Exit;
  end;

  Codigo    := Dm.SqlProduto.FieldByName('CODIGO').AsString;
  Descricao := Dm.SqlProduto.FieldByName('DESCRICAO').AsString;

  Resposta := MensagemDlg(
    Format(
      'Deseja realmente excluir o produto abaixo?' + sLineBreak + sLineBreak +
      '   Codigo   : %s' + sLineBreak +
      '   Descricao: %s' + sLineBreak + sLineBreak +
      'Essa operacao nao podera ser desfeita.',
      [Codigo, Descricao]),
    mtWarning, [mbYes, mbNo], 0, mbNo);

  if Resposta <> mrYes then
    Exit;

  try
    Dm.SqlProduto.Delete;
    ObserveLogDelete(Self, 'Produto');
    Dm.SqlProduto.ApplyUpdates;
    ObserveLogApplyUpdates(Self, 'Produto');
    Dm.IBTransaction1.CommitRetaining;
    ObserveLogCommit(Self, 'Produto');
    ObserveLogShowMessage('Produto excluido com sucesso.');
    ShowMessage('Produto excluido com sucesso.');
  except
    on E: Exception do
    begin
      if Dm.IBTransaction1.InTransaction then
        Dm.IBTransaction1.Rollback;
      ObserveLogRollback(Self, 'Produto', E.Message);
      ObserveLogException(E.Message, 'BtnExcluir', ClassName);
      MensagemDlg('Erro ao excluir: ' + E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

{ Actions }

procedure TForm_Produto.ActPrimeiroExecute(Sender: TObject);
begin
  ObserveLogAction(Self, 'ActPrimeiro', 'BtnPrimeiro');
  if BtnPrimeiro.Enabled then
    BtnPrimeiroClick(BtnPrimeiro);
end;

procedure TForm_Produto.ActAnteriorExecute(Sender: TObject);
begin
  ObserveLogAction(Self, 'ActAnterior', 'BtnAnterior');
  if BtnAnterior.Enabled then
    BtnAnteriorClick(BtnAnterior);
end;

procedure TForm_Produto.ActProximoExecute(Sender: TObject);
begin
  ObserveLogAction(Self, 'ActProximo', 'BtnProximo');
  if BtnProximo.Enabled then
    BtnProximoClick(BtnProximo);
end;

procedure TForm_Produto.ActUltimoExecute(Sender: TObject);
begin
  ObserveLogAction(Self, 'ActUltimo', 'BtnUltimo');
  if BtnUltimo.Enabled then
    BtnUltimoClick(BtnUltimo);
end;

procedure TForm_Produto.ActInserirExecute(Sender: TObject);
begin
  ObserveLogAction(Self, 'ActInserir', 'BtnInserir');
  if BtnInserir.Enabled then
    BtnInserirClick(BtnInserir);
end;

procedure TForm_Produto.ActEditarExecute(Sender: TObject);
begin
  ObserveLogAction(Self, 'ActEditar', 'BtnEditar');
  if BtnEditar.Enabled then
    BtnEditarClick(BtnEditar);
end;

procedure TForm_Produto.ActGravarExecute(Sender: TObject);
begin
  ObserveLogAction(Self, 'ActGravar', 'BtnGravar');
  if BtnGravar.Enabled then
    BtnGravarClick(BtnGravar);
end;

procedure TForm_Produto.ActCancelarExecute(Sender: TObject);
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

procedure TForm_Produto.ActExcluirExecute(Sender: TObject);
begin
  ObserveLogAction(Self, 'ActExcluir', 'BtnExcluir');
  if BtnExcluir.Enabled then
    BtnExcluirClick(BtnExcluir);
end;

end.








