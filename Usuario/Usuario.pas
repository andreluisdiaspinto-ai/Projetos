unit Usuario;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Classes, System.Actions,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Mask, Vcl.DBCtrls,
  Vcl.Buttons, Vcl.ActnList,
  Data.DB, IBX.IBCustomDataSet, IBX.IBQuery, IBX.IBUpdateSQL;

const
  WM_REFOCAR = WM_USER + $100;

  COR_EDIT_NORMAL   = clWhite;
  COR_EDIT_FOCO     = $00FFF5EA;
  COR_EDIT_ERRO     = $00D6D6FF;
  COR_EDIT_READONLY = $00F0F0F0;

  ICN_PRIMEIRO = #$E892;
  ICN_ANTERIOR = #$E76B;
  ICN_PROXIMO  = #$E76C;
  ICN_ULTIMO   = #$E893;
  ICN_INSERIR  = #$E710;
  ICN_EDITAR   = #$E70F;
  ICN_GRAVAR   = #$E74E;
  ICN_CANCELAR = #$E711;
  ICN_EXCLUIR  = #$E74D;
  ICN_SAIR     = #$E8BB;

type
  TForm_Usuario = class(TForm)
    Panel_Titulo: TPanel;
    PanelEstado: TPanel;
    LabelEstadoAtual: TLabel;

    PanelDados: TPanel;
    PanelIdentificacao: TPanel;
    LabelSecaoIdent: TLabel;

    LabelCodigo: TLabel;
    DBEditCodigo: TDBEdit;

    LabelLogin: TLabel;
    LabelLoginAst: TLabel;
    DBEditLogin: TDBEdit;

    LabelSenha: TLabel;
    LabelSenhaAst: TLabel;
    DBEditSenha: TDBEdit;

    LabelConfirmaSenha: TLabel;
    LabelConfirmaSenhaAst: TLabel;
    EditConfirmaSenha: TEdit;

    LabelNome: TLabel;
    LabelNomeAst: TLabel;
    DBEditNome: TDBEdit;

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

    SqlUsuario: TIBQuery;
    UpdUsuario: TIBUpdateSQL;
    DsUsuario: TDataSource;
    SqlUsuarioCODIGO: TIntegerField;
    SqlUsuarioLOGIN: TIBStringField;
    SqlUsuarioSENHA: TIBStringField;
    SqlUsuarioNOME_USUARIO: TIBStringField;

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
    procedure EditConfirmaSenhaExit(Sender: TObject);
    procedure EditFocoEnter(Sender: TObject);
    procedure EditFocoExit(Sender: TObject);
    procedure DsUsuarioDataChange(Sender: TObject; Field: TField);
    procedure DsUsuarioStateChange(Sender: TObject);
  private
    FValidando: Boolean;
    FIgnorarValidacao: Boolean;
    FBalloonHint: TBalloonHint;
    FCampoComErro: TWinControl;
    FObserveEnterControl: string;
    FObserveEnterValue: string;
    FLoginOriginal: string;

    procedure ConfigurarGlyphsBotoes;
    procedure AplicarLayoutInicial;
    procedure AtualizarEstadoUI;
    procedure HabilitarBotoes;
    procedure LimparConfirmacaoSenha;
    procedure SincronizarConfirmacaoSenha;

    function ValidarCamposObrigatorios: Boolean;
    function LoginAtualEhMaster: Boolean;
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
  Form_Usuario: TForm_Usuario;

implementation

uses DataModule, Mensagens, Login, UsuarioAuth, ObserveHooks, UITheme;

{$R *.dfm}

procedure TForm_Usuario.ConfigurarGlyphsBotoes;
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

procedure TForm_Usuario.AplicarLayoutInicial;
begin
  Color := COR_PAGE;
  AplicarHeaderPrimary(Panel_Titulo);
  AplicarFormEstiloWeb(Self);
  AplicarPainelCard(PanelIdentificacao);
  PanelEstado.ParentBackground := False;
  PanelEstado.BevelOuter := bvNone;
  PanelRodape.Color := COR_PAGE;
  LabelLoginAst.Font.Color := clRed;
  LabelSenhaAst.Font.Color := clRed;
  LabelConfirmaSenhaAst.Font.Color := clRed;
  LabelNomeAst.Font.Color := clRed;

  DBEditLogin.MaxLength := USUARIO_LOGIN_MAX;
  DBEditSenha.MaxLength := USUARIO_SENHA_MAX;
  DBEditNome.MaxLength := USUARIO_NOME_MAX;
  EditConfirmaSenha.MaxLength := USUARIO_SENHA_MAX;
end;

function TForm_Usuario.ControleEmSomenteLeitura(Ctrl: TWinControl): Boolean;
begin
  Result := False;
  if Ctrl is TDBEdit then
    Result := TDBEdit(Ctrl).ReadOnly
  else if Ctrl is TEdit then
    Result := TEdit(Ctrl).ReadOnly;
end;

procedure TForm_Usuario.DefinirCorFundo(Ctrl: TWinControl; Cor: TColor);
begin
  if Ctrl is TDBEdit then
    TDBEdit(Ctrl).Color := Cor
  else if Ctrl is TEdit then
    TEdit(Ctrl).Color := Cor;
end;

procedure TForm_Usuario.EditFocoEnter(Sender: TObject);
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
  if Sender = FCampoComErro then
    DefinirCorFundo(TWinControl(Sender), COR_EDIT_ERRO)
  else
    DefinirCorFundo(TWinControl(Sender), COR_EDIT_FOCO);
end;

procedure TForm_Usuario.EditFocoExit(Sender: TObject);
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

function TForm_Usuario.LoginAtualEhMaster: Boolean;
begin
  Result := False;
  if not Assigned(SqlUsuario) or not SqlUsuario.Active or SqlUsuario.IsEmpty then
    Exit;
  Result := UsuarioEhMaster(SqlUsuario.FieldByName('LOGIN').AsString);
end;

procedure TForm_Usuario.LimparConfirmacaoSenha;
begin
  EditConfirmaSenha.Text := '';
  EditConfirmaSenha.Color := COR_EDIT_READONLY;
end;

procedure TForm_Usuario.SincronizarConfirmacaoSenha;
begin
  if Assigned(SqlUsuario) and SqlUsuario.Active and
     Assigned(SqlUsuario.FindField('SENHA')) then
    EditConfirmaSenha.Text := SqlUsuario.FieldByName('SENHA').AsString
  else
    EditConfirmaSenha.Text := '';
  EditConfirmaSenha.Color := COR_EDIT_NORMAL;
end;

procedure TForm_Usuario.HabilitarBotoes;
var
  EmBrowse: Boolean;
  TemReg: Boolean;
  EhMaster: Boolean;
begin
  if not Assigned(SqlUsuario) or not SqlUsuario.Active then
    Exit;

  EmBrowse := SqlUsuario.State = dsBrowse;
  TemReg := not SqlUsuario.IsEmpty;
  EhMaster := LoginAtualEhMaster;

  BtnPrimeiro.Enabled := EmBrowse and (not SqlUsuario.Bof) and TemReg;
  BtnAnterior.Enabled := EmBrowse and (not SqlUsuario.Bof) and TemReg;
  BtnProximo.Enabled := EmBrowse and (not SqlUsuario.Eof) and TemReg;
  BtnUltimo.Enabled := EmBrowse and (not SqlUsuario.Eof) and TemReg;
  BtnInserir.Enabled := EmBrowse;
  BtnEditar.Enabled := EmBrowse and TemReg;
  BtnExcluir.Enabled := EmBrowse and TemReg and (not EhMaster);
  BtnCancelar.Enabled := not EmBrowse;
  BtnGravar.Enabled := not EmBrowse;
end;

procedure TForm_Usuario.AtualizarEstadoUI;
var
  Estado: TDataSetState;
  ModoTexto: string;
  CorFundo, CorTexto: TColor;
  EmEdicao: Boolean;
  CorCampos: TColor;
  BloquearLoginMaster: Boolean;
begin
  if not Assigned(SqlUsuario) or not SqlUsuario.Active then
    Exit;

  Estado := SqlUsuario.State;
  EmEdicao := Estado in [dsInsert, dsEdit];

  case Estado of
    dsInsert:
      begin
        ModoTexto := 'MODO: INSERINDO';
        CorFundo := $00CDF6DF;
        CorTexto := $00107C10;
      end;
    dsEdit:
      begin
        ModoTexto := 'MODO: EDITANDO';
        CorFundo := $00CEF4FF;
        CorTexto := $00007297;
      end;
    dsBrowse:
      begin
        ModoTexto := 'MODO: NAVEGACAO';
        CorFundo := $00E8E8E8;
        CorTexto := $00505050;
      end;
  else
    ModoTexto := 'MODO: ' + IntToStr(Ord(Estado));
    CorFundo := $00E8E8E8;
    CorTexto := $00505050;
  end;

  PanelEstado.Color := CorFundo;
  LabelEstadoAtual.Caption := ModoTexto;
  LabelEstadoAtual.Font.Color := CorTexto;

  BloquearLoginMaster := (Estado = dsEdit) and UsuarioEhMaster(FLoginOriginal);

  DBEditLogin.ReadOnly := (not EmEdicao) or BloquearLoginMaster;
  DBEditSenha.ReadOnly := not EmEdicao;
  DBEditNome.ReadOnly := not EmEdicao;
  EditConfirmaSenha.ReadOnly := not EmEdicao;

  if EmEdicao then
    CorCampos := COR_EDIT_NORMAL
  else
    CorCampos := COR_EDIT_READONLY;

  if BloquearLoginMaster then
    DBEditLogin.Color := COR_EDIT_READONLY
  else
    DBEditLogin.Color := CorCampos;
  DBEditSenha.Color := CorCampos;
  DBEditNome.Color := CorCampos;
  EditConfirmaSenha.Color := CorCampos;

  HabilitarBotoes;
end;

procedure TForm_Usuario.DsUsuarioDataChange(Sender: TObject; Field: TField);
begin
  AtualizarEstadoUI;
end;

procedure TForm_Usuario.DsUsuarioStateChange(Sender: TObject);
begin
  AtualizarEstadoUI;
end;

procedure TForm_Usuario.MostrarBaloonErro(Edit: TCustomEdit;
  const Titulo, Texto: string);
begin
  if not Assigned(Edit) or not Assigned(FBalloonHint) then
    Exit;
  FBalloonHint.HideHint;
  FBalloonHint.Title := Titulo;
  FBalloonHint.Description := Texto;
  FBalloonHint.ShowHint(Edit);
end;

procedure TForm_Usuario.ReagendarFocoNoCampo(Edit: TWinControl);
begin
  if Assigned(Edit) then
    PostMessage(Self.Handle, WM_REFOCAR, WPARAM(Pointer(Edit)), 0);
end;

procedure TForm_Usuario.FocarControleSeguro(Ctrl: TWinControl);
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

procedure TForm_Usuario.WMRefocar(var Msg: TMessage);
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

procedure TForm_Usuario.DBEditObrigatorioExit(Sender: TObject);
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
  if not Assigned(SqlUsuario) then
    Exit;
  if not (SqlUsuario.State in [dsInsert, dsEdit]) then
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
    Edit.Color := COR_EDIT_ERRO;
    FCampoComErro := Edit;
    MostrarBaloonErro(Edit, 'Campo obrigatorio',
      'O campo ' + Rotulo + ' deve ser preenchido.');
    ReagendarFocoNoCampo(Edit);
  end
  else if Edit.Name = FObserveEnterControl then
    ObserveLogFill(Self, Edit.Name, FObserveEnterValue, Edit.Text);
end;

procedure TForm_Usuario.EditConfirmaSenhaExit(Sender: TObject);
var
  FocoDestino: HWND;
begin
  if FValidando then
    Exit;

  EditConfirmaSenha.Color := COR_EDIT_NORMAL;
  if FCampoComErro = EditConfirmaSenha then
    FCampoComErro := nil;

  if FIgnorarValidacao then
    Exit;
  if csDestroying in ComponentState then
    Exit;
  if not Assigned(SqlUsuario) then
    Exit;
  if not (SqlUsuario.State in [dsInsert, dsEdit]) then
    Exit;

  FocoDestino := GetFocus;
  if (FocoDestino <> 0) and
     ((BtnCancelar.HandleAllocated and (FocoDestino = BtnCancelar.Handle)) or
      (BtnSair.HandleAllocated and (FocoDestino = BtnSair.Handle))) then
    Exit;

  if Trim(EditConfirmaSenha.Text) = '' then
  begin
    EditConfirmaSenha.Color := COR_EDIT_ERRO;
    FCampoComErro := EditConfirmaSenha;
    MostrarBaloonErro(EditConfirmaSenha, 'Campo obrigatorio',
      'Confirme a senha.');
    ReagendarFocoNoCampo(EditConfirmaSenha);
  end
  else if Trim(EditConfirmaSenha.Text) <> Trim(DBEditSenha.Text) then
  begin
    EditConfirmaSenha.Color := COR_EDIT_ERRO;
    FCampoComErro := EditConfirmaSenha;
    MostrarBaloonErro(EditConfirmaSenha, 'Senha invalida',
      'A confirmacao nao confere com a senha.');
    ReagendarFocoNoCampo(EditConfirmaSenha);
  end
  else if EditConfirmaSenha.Name = FObserveEnterControl then
    ObserveLogFill(Self, EditConfirmaSenha.Name, FObserveEnterValue,
      EditConfirmaSenha.Text);
end;

function TForm_Usuario.ValidarCamposObrigatorios: Boolean;

  function CampoVazio(Edit: TDBEdit): Boolean;
  begin
    Result := (Edit.Field = nil) or (Trim(Edit.Field.AsString) = '');
  end;

  function FalharEm(Edit: TCustomEdit; const Rotulo: string): Boolean;
  begin
    DefinirCorFundo(Edit, COR_EDIT_ERRO);
    FCampoComErro := Edit;
    MostrarBaloonErro(Edit, 'Campo obrigatorio',
      'O campo ' + Rotulo + ' deve ser preenchido.');
    ReagendarFocoNoCampo(Edit);
    Result := False;
  end;

begin
  Result := True;
  if CampoVazio(DBEditLogin) then
    Exit(FalharEm(DBEditLogin, 'Login'));
  if CampoVazio(DBEditSenha) then
    Exit(FalharEm(DBEditSenha, 'Senha'));
  if Trim(EditConfirmaSenha.Text) = '' then
    Exit(FalharEm(EditConfirmaSenha, 'Confirmacao de senha'));
  if Trim(EditConfirmaSenha.Text) <> Trim(DBEditSenha.Text) then
  begin
    EditConfirmaSenha.Color := COR_EDIT_ERRO;
    FCampoComErro := EditConfirmaSenha;
    MostrarBaloonErro(EditConfirmaSenha, 'Senha invalida',
      'A confirmacao nao confere com a senha.');
    ReagendarFocoNoCampo(EditConfirmaSenha);
    Result := False;
    Exit;
  end;
  if CampoVazio(DBEditNome) then
    Exit(FalharEm(DBEditNome, 'Nome'));

  if (SqlUsuario.State = dsEdit) and UsuarioEhMaster(FLoginOriginal) and
     (not UsuarioEhMaster(Trim(DBEditLogin.Text))) then
  begin
    DBEditLogin.Color := COR_EDIT_ERRO;
    FCampoComErro := DBEditLogin;
    MostrarBaloonErro(DBEditLogin, 'Operacao nao permitida',
      'O login MASTER nao pode ser alterado.');
    ReagendarFocoNoCampo(DBEditLogin);
    Result := False;
  end;
end;

procedure TForm_Usuario.FormCreate(Sender: TObject);
begin
  FValidando := False;
  FIgnorarValidacao := False;
  FLoginOriginal := '';

  FBalloonHint := TBalloonHint.Create(Self);
  FBalloonHint.Style := bhsStandard;
  FBalloonHint.Delay := 0;
  FBalloonHint.HideAfter := 4000;

  SqlUsuario.Database := Dm.Conexao;
  SqlUsuario.Transaction := Dm.IBTransaction1;
  if not SqlUsuario.Active then
    SqlUsuario.Open;

  ConfigurarGlyphsBotoes;
  AplicarLayoutInicial;
  LimparConfirmacaoSenha;
  AtualizarEstadoUI;
  ObserveLogOpenForm(Self);
  ObserveEmitSnapshot(Self, SqlUsuario);
end;

procedure TForm_Usuario.FormDestroy(Sender: TObject);
begin
  if Assigned(FBalloonHint) then
    FBalloonHint.HideHint;
  if Assigned(SqlUsuario) and SqlUsuario.Active then
    SqlUsuario.Close;
end;

procedure TForm_Usuario.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ObserveLogCloseForm(Self);
  Action := caFree;
  Form_Usuario := nil;
end;

procedure TForm_Usuario.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := True;
  if Assigned(SqlUsuario) and (SqlUsuario.State in [dsInsert, dsEdit]) then
  begin
    case MensagemDlg(
      'Existem alteracoes nao gravadas. Deseja descarta-las e fechar?',
      mtConfirmation, [mbYes, mbNo], 0) of
      mrYes:
        begin
          SqlUsuario.Cancel;
          LimparConfirmacaoSenha;
          CanClose := True;
        end;
    else
      CanClose := False;
    end;
  end;
end;

procedure TForm_Usuario.FormActivate(Sender: TObject);
begin
  ReagendarFocoNoCampo(BtnInserir);
end;

procedure TForm_Usuario.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_RETURN) and (Shift = []) then
  begin
    if (ActiveControl <> nil) and
       not (ActiveControl is TCustomMemo) and
       not (ActiveControl is TCustomButton) then
    begin
      Key := 0;
      SelectNext(ActiveControl, True, True);
      Exit;
    end;
  end;

  if (Key = VK_UP) and (Shift = []) then
  begin
    if (ActiveControl <> nil) and
       not (ActiveControl is TCustomMemo) and
       not (ActiveControl is TCustomButton) then
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
    if Assigned(SqlUsuario) and (SqlUsuario.State in [dsInsert, dsEdit]) then
      Exit;
    Close;
  end;
end;

procedure TForm_Usuario.BtnPrimeiroClick(Sender: TObject);
begin
  SqlUsuario.First;
end;

procedure TForm_Usuario.BtnAnteriorClick(Sender: TObject);
begin
  SqlUsuario.Prior;
end;

procedure TForm_Usuario.BtnProximoClick(Sender: TObject);
begin
  SqlUsuario.Next;
end;

procedure TForm_Usuario.BtnUltimoClick(Sender: TObject);
begin
  SqlUsuario.Last;
end;

procedure TForm_Usuario.BtnInserirClick(Sender: TObject);
var
  Q: TIBQuery;
  ProxCodigo: Integer;
begin
  SqlUsuario.Insert;
  FLoginOriginal := '';
  LimparConfirmacaoSenha;
  EditConfirmaSenha.Color := COR_EDIT_NORMAL;

  Q := TIBQuery.Create(nil);
  try
    Q.Database := Dm.Conexao;
    Q.Transaction := Dm.IBTransaction1;
    Q.SQL.Text := 'select coalesce(Max(Codigo),0)+1 as Codigo from USUARIO';
    Q.Open;
    ProxCodigo := Q.FieldByName('Codigo').AsInteger;
  finally
    Q.Free;
  end;

  if SqlUsuario.State = dsInsert then
    SqlUsuario.FieldByName('CODIGO').AsInteger := ProxCodigo;

  ReagendarFocoNoCampo(DBEditLogin);
end;

procedure TForm_Usuario.BtnEditarClick(Sender: TObject);
begin
  if SqlUsuario.IsEmpty then
    Exit;
  FLoginOriginal := SqlUsuario.FieldByName('LOGIN').AsString;
  SqlUsuario.Edit;
  SincronizarConfirmacaoSenha;
  if UsuarioEhMaster(FLoginOriginal) then
    ReagendarFocoNoCampo(DBEditSenha)
  else
    ReagendarFocoNoCampo(DBEditLogin);
end;

procedure TForm_Usuario.BtnGravarClick(Sender: TObject);
begin
  if not (SqlUsuario.State in [dsInsert, dsEdit]) then
    Exit;

  if not ValidarCamposObrigatorios then
    Exit;

  ObserveEmitSnapshot(Self, SqlUsuario);
  try
    SqlUsuario.Post;
    ObserveLogPost(Self, 'Usuario');
    SqlUsuario.ApplyUpdates;
    ObserveLogApplyUpdates(Self, 'Usuario');
    Dm.IBTransaction1.CommitRetaining;
    ObserveLogCommit(Self, 'Usuario');
    LimparConfirmacaoSenha;
    FLoginOriginal := '';
    ObserveLogShowMessage('Usuario gravado com sucesso.');
    ShowMessage('Usuario gravado com sucesso.');
    ObserveEmitSnapshot(Self, SqlUsuario);
  except
    on E: Exception do
    begin
      if Dm.IBTransaction1.InTransaction then
        Dm.IBTransaction1.Rollback;
      ObserveLogRollback(Self, 'Usuario', E.Message);
      ObserveLogException(E.Message, 'BtnGravar', ClassName);
      MensagemDlg('Erro na gravacao: ' + E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

procedure TForm_Usuario.BtnCancelarMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FIgnorarValidacao := True;
end;

procedure TForm_Usuario.BtnCancelarClick(Sender: TObject);
begin
  try
    if SqlUsuario.State in [dsInsert, dsEdit] then
    begin
      if MensagemDlg('Descartar as alteracoes deste registro?',
           mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      begin
        SqlUsuario.Cancel;
        LimparConfirmacaoSenha;
        FLoginOriginal := '';
      end;
    end;
  finally
    FIgnorarValidacao := False;
  end;
end;

procedure TForm_Usuario.BtnSairMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FIgnorarValidacao := True;
end;

procedure TForm_Usuario.BtnSairClick(Sender: TObject);
begin
  try
    if Assigned(SqlUsuario) and (SqlUsuario.State in [dsInsert, dsEdit]) then
      SqlUsuario.Cancel;
    LimparConfirmacaoSenha;
    Close;
  finally
    FIgnorarValidacao := False;
  end;
end;

procedure TForm_Usuario.BtnExcluirClick(Sender: TObject);
var
  LoginUsr, NomeUsr, Codigo: string;
  Resposta: Integer;
begin
  if not Assigned(SqlUsuario) or not SqlUsuario.Active or SqlUsuario.IsEmpty then
  begin
    ObserveLogShowMessage('Nao ha usuario selecionado para excluir.');
    ShowMessage('Nao ha usuario selecionado para excluir.');
    Exit;
  end;

  LoginUsr := SqlUsuario.FieldByName('LOGIN').AsString;
  if UsuarioEhMaster(LoginUsr) then
  begin
    ObserveLogShowMessage('O usuario MASTER nao pode ser excluido.');
    ShowMessage('O usuario MASTER nao pode ser excluido.');
    Exit;
  end;

  Codigo := SqlUsuario.FieldByName('CODIGO').AsString;
  NomeUsr := SqlUsuario.FieldByName('NOME_USUARIO').AsString;

  Resposta := MensagemDlg(
    Format(
      'Deseja realmente excluir o usuario abaixo?' + sLineBreak + sLineBreak +
      '   Codigo: %s' + sLineBreak +
      '   Login : %s' + sLineBreak +
      '   Nome  : %s' + sLineBreak + sLineBreak +
      'Essa operacao nao podera ser desfeita.',
      [Codigo, LoginUsr, NomeUsr]),
    mtWarning, [mbYes, mbNo], 0, mbNo);

  if Resposta <> mrYes then
    Exit;

  try
    SqlUsuario.Delete;
    ObserveLogDelete(Self, 'Usuario');
    SqlUsuario.ApplyUpdates;
    ObserveLogApplyUpdates(Self, 'Usuario');
    Dm.IBTransaction1.CommitRetaining;
    ObserveLogCommit(Self, 'Usuario');
    ObserveLogShowMessage('Usuario excluido com sucesso.');
    ShowMessage('Usuario excluido com sucesso.');
  except
    on E: Exception do
    begin
      if Dm.IBTransaction1.InTransaction then
        Dm.IBTransaction1.Rollback;
      ObserveLogRollback(Self, 'Usuario', E.Message);
      ObserveLogException(E.Message, 'BtnExcluir', ClassName);
      MensagemDlg('Erro ao excluir: ' + E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

procedure TForm_Usuario.ActPrimeiroExecute(Sender: TObject);
begin
  ObserveLogAction(Self, 'ActPrimeiro', 'BtnPrimeiro');
  if BtnPrimeiro.Enabled then
    BtnPrimeiroClick(BtnPrimeiro);
end;

procedure TForm_Usuario.ActAnteriorExecute(Sender: TObject);
begin
  ObserveLogAction(Self, 'ActAnterior', 'BtnAnterior');
  if BtnAnterior.Enabled then
    BtnAnteriorClick(BtnAnterior);
end;

procedure TForm_Usuario.ActProximoExecute(Sender: TObject);
begin
  ObserveLogAction(Self, 'ActProximo', 'BtnProximo');
  if BtnProximo.Enabled then
    BtnProximoClick(BtnProximo);
end;

procedure TForm_Usuario.ActUltimoExecute(Sender: TObject);
begin
  ObserveLogAction(Self, 'ActUltimo', 'BtnUltimo');
  if BtnUltimo.Enabled then
    BtnUltimoClick(BtnUltimo);
end;

procedure TForm_Usuario.ActInserirExecute(Sender: TObject);
begin
  ObserveLogAction(Self, 'ActInserir', 'BtnInserir');
  if BtnInserir.Enabled then
    BtnInserirClick(BtnInserir);
end;

procedure TForm_Usuario.ActEditarExecute(Sender: TObject);
begin
  ObserveLogAction(Self, 'ActEditar', 'BtnEditar');
  if BtnEditar.Enabled then
    BtnEditarClick(BtnEditar);
end;

procedure TForm_Usuario.ActGravarExecute(Sender: TObject);
begin
  ObserveLogAction(Self, 'ActGravar', 'BtnGravar');
  if BtnGravar.Enabled then
    BtnGravarClick(BtnGravar);
end;

procedure TForm_Usuario.ActCancelarExecute(Sender: TObject);
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

procedure TForm_Usuario.ActExcluirExecute(Sender: TObject);
begin
  ObserveLogAction(Self, 'ActExcluir', 'BtnExcluir');
  if BtnExcluir.Enabled then
    BtnExcluirClick(BtnExcluir);
end;

end.
