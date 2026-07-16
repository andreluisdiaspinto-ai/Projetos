unit Login;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons,
  Data.DB, IBX.IBQuery, IBX.IBCustomDataSet;

const
  // Mensagem custom usada para reagendar o foco no proprio campo,
  // saindo do fluxo do OnExit corrente (mesmo padrao do Form_Cliente).
  WM_REFOCAR = WM_USER + $100;
  WM_AUTOLOGIN = WM_USER + $101;

  // Cores dos campos de entrada (TColor = 0x00BBGGRR)
  COR_EDIT_NORMAL = clWhite;    // branco padrao
  COR_EDIT_FOCO   = $00FFE2CF;  // azul Bootstrap claro (foco ativo)
  COR_EDIT_ERRO   = $00D6D6FF;  // vermelho claro (erro de validacao)

  // Icones Segoe MDL2 Assets (Windows 10/11)
  ICN_USUARIO = #$E77B; // Contact
  ICN_ENTRAR  = #$E8D7; // Permissions (chave)
  ICN_SAIR    = #$E8BB; // ChromeClose

  // Limite de tentativas de autenticacao
  MAX_TENTATIVAS = 3;

type
  TForm_Login = class(TForm)
    Panel_Titulo: TPanel;

    PanelDados: TPanel;
    LabelIconeUsuario: TLabel;
    LabelInstrucao: TLabel;
    LabelLogin: TLabel;
    LabelLoginAst: TLabel;
    EditLogin: TEdit;
    LabelSenha: TLabel;
    LabelSenhaAst: TLabel;
    EditSenha: TEdit;
    LabelTentativas: TLabel;

    PanelRodape: TPanel;
    BtnEntrar: TBitBtn;
    BtnSair: TBitBtn;

    QueryLogin: TIBQuery;
    Label1: TLabel;

    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure BtnEntrarClick(Sender: TObject);
    procedure BtnSairClick(Sender: TObject);
    procedure EditFocoEnter(Sender: TObject);
    procedure EditFocoExit(Sender: TObject);
    procedure EditLoginChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FTentativas: Integer;
    FBalloonHint: TBalloonHint;
    FCampoComErro: TWinControl;

    procedure ConfigurarGlyphsBotoes;
    procedure AjustarLayoutResponsivo;
    procedure MostrarBaloonErro(Edit: TCustomEdit; const Titulo, Texto: string);
    procedure ReagendarFocoNoCampo(Edit: TWinControl);
    function ValidarCampos: Boolean;
    function AutenticarUsuario: Boolean;
    procedure AtualizarLabelTentativas;

    procedure WMRefocar(var Msg: TMessage); message WM_REFOCAR;
    procedure WMAutoLogin(var Msg: TMessage); message WM_AUTOLOGIN;
  public
    { Public declarations }
  end;

var
  Form_Login: TForm_Login;

  // Dados do usuario autenticado, consumidos pelo restante da aplicacao
  // (ex.: StatusBar do Form_Principal).
  UsuarioLogadoCodigo: Integer = 0;
  UsuarioLogadoLogin: string = '';
  UsuarioLogadoNome: string = '';

implementation

uses DataModule, Mensagens, Principal, ScenarioPlayer, UITheme, UsuarioAuth;

{$R *.dfm}

{ Utilitarios visuais (mesmo padrao do Form_Cliente) }

procedure TForm_Login.ConfigurarGlyphsBotoes;
begin
  AplicarBotaoBootstrap(BtnEntrar, bbkPrimary, ICN_ENTRAR);
  AplicarBotaoBootstrap(BtnSair, bbkSecondary, ICN_SAIR);
end;

procedure TForm_Login.AjustarLayoutResponsivo;
const
  MARGEM_H = 48;
  GAP_BTN = 16;
var
  LarguraCampo: Integer;
  TotalBotoes: Integer;
  XBtn: Integer;
begin
  if not Assigned(PanelDados) then
    Exit;

  // Labels full-width no card.
  LabelIconeUsuario.Width := PanelDados.ClientWidth;
  Label1.Width := PanelDados.ClientWidth;
  LabelInstrucao.Width := PanelDados.ClientWidth;
  LabelTentativas.Width := PanelDados.ClientWidth;

  // Campos centralizados com margem lateral.
  LarguraCampo := PanelDados.ClientWidth - (MARGEM_H * 2);
  if LarguraCampo < 180 then
    LarguraCampo := 180;
  EditLogin.Left := MARGEM_H;
  EditLogin.Width := LarguraCampo;
  EditSenha.Left := MARGEM_H;
  EditSenha.Width := LarguraCampo;
  LabelLogin.Left := MARGEM_H;
  LabelLoginAst.Left := LabelLogin.Left + LabelLogin.Width + 4;
  LabelSenha.Left := MARGEM_H;
  LabelSenhaAst.Left := LabelSenha.Left + LabelSenha.Width + 4;

  // Botoes centralizados no rodape.
  TotalBotoes := BtnEntrar.Width + GAP_BTN + BtnSair.Width;
  XBtn := (PanelRodape.ClientWidth - TotalBotoes) div 2;
  if XBtn < 12 then
    XBtn := 12;
  BtnEntrar.Left := XBtn;
  BtnSair.Left := BtnEntrar.Left + BtnEntrar.Width + GAP_BTN;
end;

procedure TForm_Login.FormResize(Sender: TObject);
begin
  AjustarLayoutResponsivo;
end;

procedure TForm_Login.MostrarBaloonErro(Edit: TCustomEdit;
  const Titulo, Texto: string);
begin
  if not Assigned(Edit) or not Assigned(FBalloonHint) then
    Exit;

  FBalloonHint.HideHint;
  FBalloonHint.Title       := Titulo;
  FBalloonHint.Description := Texto;
  FBalloonHint.ShowHint(Edit);
end;

procedure TForm_Login.ReagendarFocoNoCampo(Edit: TWinControl);
begin
  // PostMessage garante que o fluxo corrente termine antes do foco mudar.
  if Assigned(Edit) then
    PostMessage(Self.Handle, WM_REFOCAR, WPARAM(Pointer(Edit)), 0);
end;

procedure TForm_Login.WMRefocar(var Msg: TMessage);
var
  Ctrl: TWinControl;
begin
  Ctrl := TWinControl(Pointer(Msg.WParam));
  if Assigned(Ctrl) and Ctrl.CanFocus then
  begin
    Ctrl.SetFocus;
    if Ctrl is TCustomEdit then
      TCustomEdit(Ctrl).SelectAll;
  end;
end;

procedure TForm_Login.WMAutoLogin(var Msg: TMessage);
begin
{$IFDEF DEBUG}
  BtnEntrar.Click;
{$ELSE}
  if ReplayModeActive then
    BtnEntrar.Click;
{$ENDIF}
end;

{ Ciclo de vida }

procedure TForm_Login.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  close;
end;

procedure TForm_Login.FormCreate(Sender: TObject);
begin
  FTentativas   := 0;
  FCampoComErro := nil;

  FBalloonHint           := TBalloonHint.Create(Self);
  FBalloonHint.HideAfter := 4000;
  FBalloonHint.Delay     := 0;

  // Tema Bootstrap claro (header Primary + card com margens + rodape).
  // Sem chrome de janela (BorderStyle bsNone / BorderIcons vazios).
  BorderStyle := bsNone;
  BorderIcons := [];
  Constraints.MinWidth := 420;
  Constraints.MinHeight := 430;
  Color := COR_PAGE;
  AplicarHeaderPrimary(Panel_Titulo);
  AplicarFormEstiloWeb(Self);
  AplicarPainelCard(PanelDados);
  PanelDados.AlignWithMargins := True;
  PanelDados.Margins.SetBounds(24, 16, 24, 8);
  PanelDados.Color := COR_CARD;
  PanelRodape.ParentBackground := False;
  PanelRodape.BevelOuter := bvNone;
  PanelRodape.Color := COR_PAGE;
  LabelIconeUsuario.Font.Color := COR_PRIMARY;
  Label1.Font.Color := COR_PRIMARY;
  LabelInstrucao.Font.Color := COR_TEXTO_MUTED;

  ConfigurarGlyphsBotoes;
  AjustarLayoutResponsivo;

  // Icone grande de usuario e asteriscos de campo obrigatorio.
  LabelIconeUsuario.Caption := ICN_USUARIO;
  LabelLoginAst.Font.Color  := clRed;
  LabelSenhaAst.Font.Color  := clRed;
  LabelTentativas.Caption   := '';

  // Larguras conforme a tabela USUARIO.
  EditLogin.MaxLength := 20;
  EditSenha.MaxLength := 15;

{$IFDEF DEBUG}
  EditLogin.Text := 'admin';
  EditSenha.Text := 'admin';
{$ENDIF}

  QueryLogin.SQL.Text :=
    'select CODIGO, LOGIN, NOME_USUARIO from USUARIO ' +
    'where UPPER(LOGIN) = UPPER(:PLOGIN) and SENHA = :PSENHA';

  // Garante a conexao antes da primeira tentativa de autenticacao.
  try
    if not Dm.Conexao.Connected then
      Dm.Conexao.Open;
    GarantirUsuarioMaster(Dm.Conexao, Dm.IBTransaction1);
  except
    on E: Exception do
      MensagemDlg('Nao foi possivel conectar ao banco de dados.' +
        sLineBreak + E.Message, mtError, [mbOK], 0);
  end;
end;

procedure TForm_Login.FormShow(Sender: TObject);
begin
{$IFDEF DEBUG}
  PostMessage(Handle, WM_AUTOLOGIN, 0, 0);
{$ELSE}
  if ReplayModeActive then
    PostMessage(Handle, WM_AUTOLOGIN, 0, 0);
{$ENDIF}
end;

procedure TForm_Login.FormDestroy(Sender: TObject);
begin
  // Esconde o balao antes do desmonte para o timer interno dele nao
  // disparar apontando para controles ja destruidos.
  if Assigned(FBalloonHint) then
    FBalloonHint.HideHint;
  QueryLogin.Close;
end;

{ Navegacao por teclado }

procedure TForm_Login.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_RETURN) and not (ActiveControl is TCustomButton) then
  begin
    Key := 0;
    // ENTER na senha ja dispara a autenticacao; nos demais campos navega.
    if ActiveControl = EditSenha then
      BtnEntrar.Click
    else
      SelectNext(ActiveControl, True, True);
  end
  else if (Key = VK_UP) and (ActiveControl is TCustomEdit) then
  begin
    Key := 0;
    SelectNext(ActiveControl, False, True);
  end
  else if Key = VK_ESCAPE then
  begin
    Key := 0;
    BtnSair.Click;
  end;
end;

{ Cores de foco/erro }

procedure TForm_Login.EditFocoEnter(Sender: TObject);
begin
  if not (Sender is TEdit) then
    Exit;
  if Sender = FCampoComErro then
    TEdit(Sender).Color := COR_EDIT_ERRO
  else
    TEdit(Sender).Color := COR_EDIT_FOCO;
end;

procedure TForm_Login.EditFocoExit(Sender: TObject);
begin
  if Sender is TEdit then
    TEdit(Sender).Color := COR_EDIT_NORMAL;
end;

procedure TForm_Login.EditLoginChange(Sender: TObject);
begin
  // Digitar novamente limpa o estado visual de erro do campo.
  if (Sender = FCampoComErro) and (Sender is TEdit) then
  begin
    FCampoComErro := nil;
    TEdit(Sender).Color := COR_EDIT_FOCO;
  end;
end;

{ Validacao e autenticacao }

function TForm_Login.ValidarCampos: Boolean;
begin
  Result := False;

  if Trim(EditLogin.Text) = '' then
  begin
    FCampoComErro   := EditLogin;
    EditLogin.Color := COR_EDIT_ERRO;
    MostrarBaloonErro(EditLogin, 'Campo obrigatorio',
      'Informe o login do usuario.');
    ReagendarFocoNoCampo(EditLogin);
    Exit;
  end;

  if Trim(EditSenha.Text) = '' then
  begin
    FCampoComErro   := EditSenha;
    EditSenha.Color := COR_EDIT_ERRO;
    MostrarBaloonErro(EditSenha, 'Campo obrigatorio',
      'Informe a senha do usuario.');
    ReagendarFocoNoCampo(EditSenha);
    Exit;
  end;

  Result := True;
end;

function TForm_Login.AutenticarUsuario: Boolean;
begin
  QueryLogin.Close;
  QueryLogin.ParamByName('PLOGIN').AsString := Trim(EditLogin.Text);
  QueryLogin.ParamByName('PSENHA').AsString := EditSenha.Text;
  QueryLogin.Open;
  try
    Result := not QueryLogin.IsEmpty;
    if Result then
    begin
      UsuarioLogadoCodigo := QueryLogin.FieldByName('CODIGO').AsInteger;
      UsuarioLogadoLogin  := QueryLogin.FieldByName('LOGIN').AsString;
      UsuarioLogadoNome   := QueryLogin.FieldByName('NOME_USUARIO').AsString;
    end;
  finally
    QueryLogin.Close;
  end;
end;

procedure TForm_Login.AtualizarLabelTentativas;
begin
  LabelTentativas.Caption := Format('Tentativa %d de %d',
    [FTentativas, MAX_TENTATIVAS]);
end;

{ Botoes }

procedure TForm_Login.BtnEntrarClick(Sender: TObject);
begin
  if not ValidarCampos then
    Exit;

  try
    if AutenticarUsuario then
    begin
  
      ModalResult := mrOk;
      Exit;
    end;
  except
    on E: Exception do
    begin
      // Falha de banco nao consome tentativa do usuario.
      MensagemDlg('Erro ao validar o usuario no banco de dados.' +
        sLineBreak + E.Message, mtError, [mbOK], 0);
      Exit;
    end;
  end;

  Inc(FTentativas);
  AtualizarLabelTentativas;

  if FTentativas >= MAX_TENTATIVAS then
  begin
    MensagemDlg('Numero maximo de tentativas excedido.' + sLineBreak +
      'O sistema sera encerrado.', mtError, [mbOK], 0);
    ModalResult := mrCancel;
    //Exit;
    Application.Terminate;
  end;
  
  MensagemDlg('Usuario ou senha invalidos.' + sLineBreak +
    Format('Voce ainda tem %d tentativa(s).', [MAX_TENTATIVAS - FTentativas]),
    mtWarning, [mbOK], 0);
  
  
  EditSenha.Clear;
  FCampoComErro   := EditLogin;
  EditLogin.Color := COR_EDIT_ERRO;
  ReagendarFocoNoCampo(EditLogin);
end;

procedure TForm_Login.BtnSairClick(Sender: TObject);
begin
  // Fecha o programa imediatamente. O Terminate e seguro aqui porque o
  // login agora e chamado no OnShow do Form_Principal, com o MainForm ja
  // criado e o loop de mensagens da aplicacao ativo.
  if Assigned(FBalloonHint) then
    FBalloonHint.HideHint;
  ModalResult := mrCancel;
  Application.Terminate;
end;

end.
