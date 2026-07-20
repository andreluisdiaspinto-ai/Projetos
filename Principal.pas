unit Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  System.Actions, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus,
  Vcl.ExtCtrls, Vcl.Buttons, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.ActnList,
  Vcl.Imaging.jpeg, Vcl.Imaging.pngimage;

type
  TForm_Principal = class(TForm)
    Panel_Titulo: TPanel;
    PanelSidebar: TPanel;
    PanelSidebarHeader: TPanel;
    LabelIconeToggle: TLabel;
    LabelTituloSidebar: TLabel;
    PanelSeparador: TPanel;
    PanelItemClientes: TPanel;
    LabelIconeClientes: TLabel;
    LabelTextoClientes: TLabel;
    PanelItemProdutos: TPanel;
    LabelIconeProdutos: TLabel;
    LabelTextoProdutos: TLabel;
    PanelItemVendas: TPanel;
    LabelIconeVendas: TLabel;
    LabelTextoVendas: TLabel;
    PanelItemRelatorios: TPanel;
    LabelIconeRelatorios: TLabel;
    LabelTextoRelatorios: TLabel;
    PanelItemUtilitarios: TPanel;
    LabelIconeUtilitarios: TLabel;
    LabelTextoUtilitarios: TLabel;
    PanelItemSobre: TPanel;
    LabelIconeSobre: TLabel;
    LabelTextoSobre: TLabel;
    PanelItemSair: TPanel;
    LabelIconeSair: TLabel;
    LabelTextoSair: TLabel;
    StatusBarPrincipal: TStatusBar;
    TimerRelogio: TTimer;
    TimerSidebar: TTimer;
    ActionListPrincipal: TActionList;
    ActClientes: TAction;
    ActProdutos: TAction;
    ActVendas: TAction;
    ActRelatorios: TAction;
    ActUtilitarios: TAction;
    ActSobre: TAction;
    ActSair: TAction;
    ActToggleSidebar: TAction;
    PopupMenuRelatorios: TPopupMenu;
    PopupMenuUtilitarios: TPopupMenu;
    MenuItemUsuarios: TMenuItem;
    MenuItemTemas: TMenuItem;
    MenuItemRelClientes: TMenuItem;
    MenuItemRelProdutos: TMenuItem;
    MenuItemRelVendas: TMenuItem;
    MenuItemRelVendasAnalitico: TMenuItem;
    MenuItemRelVendasCliente: TMenuItem;
    MenuItemRelVendasProduto: TMenuItem;
    MenuItemRelVendasSinteticaCliente: TMenuItem;
    MenuItemRelVendasClienteGrade: TMenuItem;
    MenuItemEtiquetaProduto: TMenuItem;
    MenuItemEtiquetaCliente: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TimerRelogioTimer(Sender: TObject);
    procedure TimerSidebarTimer(Sender: TObject);
    procedure ActClientesExecute(Sender: TObject);
    procedure ActProdutosExecute(Sender: TObject);
    procedure ActVendasExecute(Sender: TObject);
    procedure ActRelatoriosExecute(Sender: TObject);
    procedure ActUtilitariosExecute(Sender: TObject);
    procedure MenuItemUsuariosClick(Sender: TObject);
    procedure MenuItemTemasClick(Sender: TObject);
    procedure MenuItemRelClientesClick(Sender: TObject);
    procedure MenuItemRelProdutosClick(Sender: TObject);
    procedure MenuItemRelTabelaPrecosClick(Sender: TObject);
    procedure MenuItemRelLucratividadeClick(Sender: TObject);
    procedure MenuItemRelVendasClick(Sender: TObject);
    procedure MenuItemRelVendasAnaliticoClick(Sender: TObject);
    procedure MenuItemRelVendasClienteClick(Sender: TObject);
    procedure MenuItemRelVendasProdutoClick(Sender: TObject);
    procedure MenuItemRelVendasSinteticaClienteClick(Sender: TObject);
    procedure MenuItemRelVendasClienteGradeClick(Sender: TObject);
    procedure MenuItemEtiquetaProdutoClick(Sender: TObject);
    procedure MenuItemEtiquetaClienteClick(Sender: TObject);
    procedure ActSobreExecute(Sender: TObject);
    procedure ActSairExecute(Sender: TObject);
    procedure ActToggleSidebarExecute(Sender: TObject);
    procedure ItemMouseEnter(Sender: TObject);
    procedure ItemMouseLeave(Sender: TObject);
  private
    FBitmapFundo: TBitmap;
    FMDIClientInstance: Pointer;
    FOldMDIClientProc: Pointer;
    FSidebarExpandida: Boolean;
    FSidebarLarguraDestino: Integer;
    FLoginVerificado: Boolean;
    procedure ExecutarLogin;
    procedure MDIClientWndProc(var Message: TMessage);
    procedure CarregarImagemFundo;
    procedure DesenharFundo(DC: HDC);
    procedure ConfigurarIconesMDL2;
    procedure AtualizarVisibilidadeTextosSidebar;
    function ObterPanelDoItem(Ctrl: TObject): TPanel;
    procedure AbrirFormularioMDI(Form: TForm);
  public
    { Public declarations }
  end;

function ObterVersaoExecutavel: string;

const
  ARQUIVO_FUNDO          = 'Ganso_Sistemas.jpg';
  // Pasta absoluta opcional (vazia = so caminhos relativos ao exe / projeto).
  PASTA_IMAGENS          = '';
  PASTA_IMAGENS_RELATIVA = 'Imagens';
  EMPRESA_NOME           = 'Ganso Sistemas';
  APP_DESCRICAO          = 'Sistema de Gerenciamento de Retaguarda';
  // Fallback se o executavel nao tiver VERSIONINFO embutido.
  APP_VERSAO             = '2.0.0.1';

  // Larguras da sidebar (padrao web: expandida x colapsada com apenas icones)
  SIDEBAR_LARGURA_EXPANDIDA = 240;
  SIDEBAR_LARGURA_COLAPSADA = 56;
  SIDEBAR_PASSO_ANIMACAO    = 18;

  // Icones Segoe MDL2 Assets (Windows 10/11)
  MDL2_MENU     = #$E700; // GlobalNavButton (hamburguer)
  MDL2_PESSOAS  = #$E716; // People
  MDL2_CAIXA    = #$E7B8; // Package
  MDL2_CARRINHO = #$E7BF; // Shop / ShoppingCart
  MDL2_RELATORIO = #$E9F9; // ReportDocument
  MDL2_UTIL = #$E713; // Settings
  MDL2_INFO     = #$E946; // Info
  MDL2_SAIR     = #$F3B1; // SignOut (Fluent) - fallback: #$E7E8

var
  Form_Principal: TForm_Principal;

implementation

uses Cliente, Produto, Venda, RelatorioCliente, RelatorioProduto,
  RelatorioTabelaPrecos, RelatorioLucratividade,
  RelatorioVenda, RelatorioVendaAnalitica, RelatorioVendaCliente,
  RelatorioVendaProduto, RelatorioVendaSinteticaCliente,
  RelatorioVendaClienteGrade,
  EmiteEtiquetaProdutoGondula, EmiteEtiquetaCliente, Login,
  Usuario, UsuarioAuth, Temas,
  Mensagens, InteractionLogger, ObserveHooks, ObserveJson, ScenarioPlayer,
  UITheme, LoadingBusy;

{$R *.dfm}

function ObterVersaoExecutavel: string;
var
  InfoSize, HandleDummy: DWORD;
  Buffer: Pointer;
  FixedFileInfo: PVSFixedFileInfo;
  Len: UINT;
  CaminhoExe: string;
begin
  // Le FileVersion do recurso VERSIONINFO do .exe (Project Options).
  Result := APP_VERSAO;
  CaminhoExe := Application.ExeName;
  InfoSize := GetFileVersionInfoSize(PChar(CaminhoExe), HandleDummy);
  if InfoSize = 0 then
    Exit;

  GetMem(Buffer, InfoSize);
  try
    if not GetFileVersionInfo(PChar(CaminhoExe), HandleDummy, InfoSize, Buffer) then
      Exit;
    if not VerQueryValue(Buffer, '\', Pointer(FixedFileInfo), Len) then
      Exit;
    if (FixedFileInfo = nil) or (Len = 0) then
      Exit;

    Result := Format('%d.%d.%d.%d',
      [HiWord(FixedFileInfo^.dwFileVersionMS),
       LoWord(FixedFileInfo^.dwFileVersionMS),
       HiWord(FixedFileInfo^.dwFileVersionLS),
       LoWord(FixedFileInfo^.dwFileVersionLS)]);
  finally
    FreeMem(Buffer);
  end;
end;

// ============================================================================
//   Ciclo de vida
// ============================================================================

procedure TForm_Principal.FormCreate(Sender: TObject);
begin
  FLoginVerificado := False;

  // Garante tema do INI antes de pintar (init de UITheme pode ja ter carregado).
  CarregarTemaSalvo;

  Color := COR_PAGE;
  Constraints.MinWidth := 900;
  Constraints.MinHeight := 560;
  Panel_Titulo.Caption :=
    'GANSO SISTEMAS  -  Sistema de Gerenciamento de Retaguarda';
  AplicarTemaNoForm(Self);

  StatusBarPrincipal.Panels[0].Text := EMPRESA_NOME;
  StatusBarPrincipal.Panels[1].Text := APP_DESCRICAO;
  StatusBarPrincipal.Panels[2].Text := 'Versao: ' + ObterVersaoExecutavel;
  TimerRelogioTimer(nil);

  ConfigurarIconesMDL2;

  FSidebarExpandida       := True;
  FSidebarLarguraDestino  := SIDEBAR_LARGURA_EXPANDIDA;
  PanelSidebar.Width      := SIDEBAR_LARGURA_EXPANDIDA;
  AtualizarVisibilidadeTextosSidebar;

  FBitmapFundo := TBitmap.Create;
  CarregarImagemFundo;

  // Subclasseia a janela filha do MDI (ClientHandle) para pintar o fundo
  // atras dos MDI childs. Sem isso, o MDIClient nativo cobre o form todo.
  FMDIClientInstance := MakeObjectInstance(MDIClientWndProc);
  FOldMDIClientProc  := Pointer(GetWindowLongPtr(ClientHandle, GWLP_WNDPROC));
  SetWindowLongPtr(ClientHandle, GWLP_WNDPROC, NativeInt(FMDIClientInstance));
end;

procedure TForm_Principal.ExecutarLogin;
begin
  Form_Login := TForm_Login.Create(Self);
  try
    if Form_Login.ShowModal <> mrOk then
    begin

    end;
  finally
    Form_Login.Free;
    Form_Login := nil;
  end;

  // Usuario autenticado: exibe o nome na StatusBar.
  StatusBarPrincipal.Panels[3].Text := 'Usuario: ' + UsuarioLogadoNome;
  if InteractionLog.IsActive then
  begin
    InteractionLog.SetUser(UsuarioLogadoNome, UsuarioLogadoLogin);
    InteractionLog.Emit('UI.Action', [
      JsonPairStr('form', 'TForm_Principal'),
      JsonPairStr('action', 'LoginOk'),
      JsonPairStr('control', 'BtnEntrar'),
      JsonPairStr('appVersion', ObterVersaoExecutavel)
    ]);
    // Torna o caminho do log visivel (evita achar que "nao gerou").
    StatusBarPrincipal.Panels[2].Text := 'Observe: ' +
      ExtractFileName(InteractionLog.LogFileName);
    StatusBarPrincipal.Hint := InteractionLog.LogFileName;
    StatusBarPrincipal.ShowHint := True;
  end;
  if ReplayModeActive then
  begin
    StatusBarPrincipal.Panels[2].Text := 'Replay...';
    ScheduleReplayAfterLogin;
  end;
end;

procedure TForm_Principal.FormShow(Sender: TObject);
begin
  // Login obrigatorio antes de ativar o menu principal (executa apenas
  // uma vez, na primeira exibicao do form).

  if FLoginVerificado then
    Exit;
  FLoginVerificado := True;
  ExecutarLogin;
end;

procedure TForm_Principal.FormDestroy(Sender: TObject);
begin
  if (ClientHandle <> 0) and (FOldMDIClientProc <> nil) then
    SetWindowLongPtr(ClientHandle, GWLP_WNDPROC, NativeInt(FOldMDIClientProc));
  if FMDIClientInstance <> nil then
    FreeObjectInstance(FMDIClientInstance);
  FBitmapFundo.Free;
  ObserveUninstall;
  InteractionLog.Stop;
end;

// ============================================================================
//   Sidebar - configuracao de icones
// ============================================================================

procedure TForm_Principal.ConfigurarIconesMDL2;
begin
  LabelIconeToggle.Caption   := MDL2_MENU;
  LabelIconeClientes.Caption := MDL2_PESSOAS;
  LabelIconeProdutos.Caption := MDL2_CAIXA;
  LabelIconeVendas.Caption   := MDL2_CARRINHO;
  LabelIconeRelatorios.Caption := MDL2_RELATORIO;
  LabelIconeUtilitarios.Caption := MDL2_UTIL;
  LabelIconeSobre.Caption    := MDL2_INFO;
  LabelIconeSair.Caption     := MDL2_SAIR;
end;

procedure TForm_Principal.AtualizarVisibilidadeTextosSidebar;
var
  MostrarTexto: Boolean;
begin
  MostrarTexto := PanelSidebar.Width >= (SIDEBAR_LARGURA_EXPANDIDA - 20);
  LabelTituloSidebar.Visible := MostrarTexto;
  LabelTextoClientes.Visible := MostrarTexto;
  LabelTextoProdutos.Visible := MostrarTexto;
  LabelTextoVendas.Visible   := MostrarTexto;
  LabelTextoRelatorios.Visible := MostrarTexto;
  LabelTextoUtilitarios.Visible := MostrarTexto;
  LabelTextoSobre.Visible    := MostrarTexto;
  LabelTextoSair.Visible     := MostrarTexto;
end;

// ============================================================================
//   Sidebar - toggle e animacao
// ============================================================================

procedure TForm_Principal.ActToggleSidebarExecute(Sender: TObject);
begin
  if FSidebarExpandida then
    FSidebarLarguraDestino := SIDEBAR_LARGURA_COLAPSADA
  else
    FSidebarLarguraDestino := SIDEBAR_LARGURA_EXPANDIDA;
  FSidebarExpandida := not FSidebarExpandida;

  // Esconde os textos antes de comecar a encolher; mostra depois de expandir.
  if not FSidebarExpandida then
    AtualizarVisibilidadeTextosSidebar;

  TimerSidebar.Enabled := True;
end;

procedure TForm_Principal.TimerSidebarTimer(Sender: TObject);
var
  Diff, NovaLargura: Integer;
begin
  Diff := FSidebarLarguraDestino - PanelSidebar.Width;
  if Abs(Diff) <= SIDEBAR_PASSO_ANIMACAO then
    NovaLargura := FSidebarLarguraDestino
  else if Diff > 0 then
    NovaLargura := PanelSidebar.Width + SIDEBAR_PASSO_ANIMACAO
  else
    NovaLargura := PanelSidebar.Width - SIDEBAR_PASSO_ANIMACAO;

  PanelSidebar.Width := NovaLargura;

  if NovaLargura = FSidebarLarguraDestino then
  begin
    TimerSidebar.Enabled := False;
    AtualizarVisibilidadeTextosSidebar;
    if ClientHandle <> 0 then
      InvalidateRect(ClientHandle, nil, True);
  end;
end;

// ============================================================================
//   Sidebar - hover
// ============================================================================

function TForm_Principal.ObterPanelDoItem(Ctrl: TObject): TPanel;
var
  C: TControl;
begin
  Result := nil;
  if Ctrl is TPanel then
  begin
    Result := TPanel(Ctrl);
    Exit;
  end;
  if Ctrl is TControl then
  begin
    C := TControl(Ctrl).Parent;
    while (C <> nil) and not (C is TPanel) do
      C := C.Parent;
    if C is TPanel then
      Result := TPanel(C);
  end;
end;

procedure TForm_Principal.AbrirFormularioMDI(Form: TForm);
begin
  if Form = nil then
    Exit;

  IniciarCarregamento(Self);
  try
    try
      Application.ProcessMessages;

      if Form.FormStyle <> fsMDIChild then
        Form.FormStyle := fsMDIChild;

      Form.Show;
      AplicarFormEstiloWeb(Form);
      Form.BringToFront;
    except
      on E: Exception do
      begin
        AbortarCarregamento;
        raise;
      end;
    end;
  finally
    FinalizarCarregamento;
  end;
end;

procedure TForm_Principal.ItemMouseEnter(Sender: TObject);
var
  P: TPanel;
begin
  P := ObterPanelDoItem(Sender);
  if (P <> nil) and (P <> PanelSidebar) and (P <> PanelSidebarHeader) then
    // Hover com toque Primary (mistura leve via cor dedicada)
    P.Color := COR_ITEM_HOVER;
end;

procedure TForm_Principal.ItemMouseLeave(Sender: TObject);
var
  P: TPanel;
begin
  P := ObterPanelDoItem(Sender);
  if (P <> nil) and (P <> PanelSidebar) and (P <> PanelSidebarHeader) then
    P.Color := COR_SIDEBAR_BG;
end;

// ============================================================================
//   Actions dos itens de menu
// ============================================================================

procedure TForm_Principal.ActClientesExecute(Sender: TObject);
begin
  ObserveLogAction(Self, 'ActClientes', 'PanelItemClientes');
  ExecutarComCarregamento(Self,
    procedure
    begin
      if not Assigned(Form_Cliente) then
        Form_Cliente := TForm_Cliente.Create(Self);
      AbrirFormularioMDI(Form_Cliente);
    end);
end;

procedure TForm_Principal.ActProdutosExecute(Sender: TObject);
begin
  ObserveLogAction(Self, 'ActProdutos', 'PanelItemProdutos');
  ExecutarComCarregamento(Self,
    procedure
    begin
      if not Assigned(Form_Produto) then
        Form_Produto := TForm_Produto.Create(Self);
      AbrirFormularioMDI(Form_Produto);
    end);
end;

procedure TForm_Principal.ActVendasExecute(Sender: TObject);
begin
  ObserveLogAction(Self, 'ActVendas', 'PanelItemVendas');
  ExecutarComCarregamento(Self,
    procedure
    begin
      if not Assigned(Form_Venda) then
        Form_Venda := TForm_Venda.Create(Self);
      AbrirFormularioMDI(Form_Venda);
    end);
end;

procedure TForm_Principal.ActRelatoriosExecute(Sender: TObject);
var
  Ponto: TPoint;
begin
  // Abre o submenu de relatorios ao lado do item da sidebar.
  Ponto := PanelItemRelatorios.ClientToScreen(
    Point(PanelItemRelatorios.Width, 0));
  PopupMenuRelatorios.Popup(Ponto.X, Ponto.Y);
end;

procedure TForm_Principal.ActUtilitariosExecute(Sender: TObject);
var
  Ponto: TPoint;
begin
  Ponto := PanelItemUtilitarios.ClientToScreen(
    Point(PanelItemUtilitarios.Width, 0));
  PopupMenuUtilitarios.Popup(Ponto.X, Ponto.Y);
end;

procedure TForm_Principal.MenuItemUsuariosClick(Sender: TObject);
begin
  ObserveLogAction(Self, 'ActUsuarios', 'MenuItemUsuarios');
  if not UsuarioPodeGerenciarUsuarios(UsuarioLogadoLogin) then
  begin
    MensagemDlg('Acesso restrito ao cadastro de usuarios.' + sLineBreak +
      'Utilize o usuario MASTER (senha MASTER) ou admin.',
      mtWarning, [mbOK], 0);
    Exit;
  end;
  ExecutarComCarregamento(Self,
    procedure
    begin
      if not Assigned(Form_Usuario) then
        Form_Usuario := TForm_Usuario.Create(Self);
      AbrirFormularioMDI(Form_Usuario);
    end);
end;

procedure TForm_Principal.MenuItemTemasClick(Sender: TObject);
begin
  ObserveLogAction(Self, 'ActTemas', 'MenuItemTemas');
  ExecutarComCarregamento(Self,
    procedure
    begin
      if not Assigned(Form_Temas) then
        Form_Temas := TForm_Temas.Create(Self);
      AbrirFormularioMDI(Form_Temas);
    end);
end;

procedure TForm_Principal.MenuItemRelClientesClick(Sender: TObject);
begin
  ExecutarComCarregamento(Self,
    procedure
    begin
      if not Assigned(Form_RelatorioCliente) then
        Form_RelatorioCliente := TForm_RelatorioCliente.Create(Self);
      AbrirFormularioMDI(Form_RelatorioCliente);
    end);
end;

procedure TForm_Principal.MenuItemRelProdutosClick(Sender: TObject);
begin
  ExecutarComCarregamento(Self,
    procedure
    begin
      if not Assigned(Form_RelatorioProduto) then
        Form_RelatorioProduto := TForm_RelatorioProduto.Create(Self);
      AbrirFormularioMDI(Form_RelatorioProduto);
    end);
end;

procedure TForm_Principal.MenuItemRelTabelaPrecosClick(Sender: TObject);
begin
  ExecutarComCarregamento(Self,
    procedure
    begin
      if not Assigned(Form_RelatorioTabelaPrecos) then
        Form_RelatorioTabelaPrecos := TForm_RelatorioTabelaPrecos.Create(Self);
      AbrirFormularioMDI(Form_RelatorioTabelaPrecos);
    end);
end;

procedure TForm_Principal.MenuItemRelLucratividadeClick(Sender: TObject);
begin
  ExecutarComCarregamento(Self,
    procedure
    begin
      if not Assigned(Form_RelatorioLucratividade) then
        Form_RelatorioLucratividade := TForm_RelatorioLucratividade.Create(Self);
      AbrirFormularioMDI(Form_RelatorioLucratividade);
    end);
end;

procedure TForm_Principal.MenuItemRelVendasClick(Sender: TObject);
begin
  ExecutarComCarregamento(Self,
    procedure
    begin
      if not Assigned(Form_RelatorioVenda) then
        Form_RelatorioVenda := TForm_RelatorioVenda.Create(Self);
      AbrirFormularioMDI(Form_RelatorioVenda);
    end);
end;

procedure TForm_Principal.MenuItemRelVendasAnaliticoClick(Sender: TObject);
begin
  ExecutarComCarregamento(Self,
    procedure
    begin
      if not Assigned(Form_RelatorioVendaAnalitica) then
        Form_RelatorioVendaAnalitica := TForm_RelatorioVendaAnalitica.Create(Self);
      AbrirFormularioMDI(Form_RelatorioVendaAnalitica);
    end);
end;

procedure TForm_Principal.MenuItemRelVendasClienteClick(Sender: TObject);
begin
  ExecutarComCarregamento(Self,
    procedure
    begin
      if not Assigned(Form_RelatorioVendaCliente) then
        Form_RelatorioVendaCliente := TForm_RelatorioVendaCliente.Create(Self);
      AbrirFormularioMDI(Form_RelatorioVendaCliente);
    end);
end;

procedure TForm_Principal.MenuItemRelVendasProdutoClick(Sender: TObject);
begin
  ExecutarComCarregamento(Self,
    procedure
    begin
      if not Assigned(Form_RelatorioVendaProduto) then
        Form_RelatorioVendaProduto := TForm_RelatorioVendaProduto.Create(Self);
      AbrirFormularioMDI(Form_RelatorioVendaProduto);
    end);
end;

procedure TForm_Principal.MenuItemRelVendasSinteticaClienteClick(Sender: TObject);
begin
  ExecutarComCarregamento(Self,
    procedure
    begin
      if not Assigned(Form_RelatorioVendaSinteticaCliente) then
        Form_RelatorioVendaSinteticaCliente :=
          TForm_RelatorioVendaSinteticaCliente.Create(Self);
      AbrirFormularioMDI(Form_RelatorioVendaSinteticaCliente);
    end);
end;

procedure TForm_Principal.MenuItemRelVendasClienteGradeClick(Sender: TObject);
begin
  ExecutarComCarregamento(Self,
    procedure
    begin
      if not Assigned(Form_RelatorioVendaClienteGrade) then
        Form_RelatorioVendaClienteGrade :=
          TForm_RelatorioVendaClienteGrade.Create(Self);
      AbrirFormularioMDI(Form_RelatorioVendaClienteGrade);
    end);
end;

procedure TForm_Principal.MenuItemEtiquetaProdutoClick(Sender: TObject);
begin
  ExecutarComCarregamento(Self,
    procedure
    begin
      if not Assigned(Form_EmiteEtiquetaProdutoGondula) then
        Form_EmiteEtiquetaProdutoGondula :=
          TForm_EmiteEtiquetaProdutoGondula.Create(Self);
      AbrirFormularioMDI(Form_EmiteEtiquetaProdutoGondula);
    end);
end;

procedure TForm_Principal.MenuItemEtiquetaClienteClick(Sender: TObject);
begin
  ExecutarComCarregamento(Self,
    procedure
    begin
      if not Assigned(Form_EmiteEtiquetaCliente) then
        Form_EmiteEtiquetaCliente :=
          TForm_EmiteEtiquetaCliente.Create(Self);
      AbrirFormularioMDI(Form_EmiteEtiquetaCliente);
    end);
end;

procedure TForm_Principal.ActSobreExecute(Sender: TObject);
begin
  MensagemDlg(
    EMPRESA_NOME + sLineBreak +
    APP_DESCRICAO + sLineBreak +
    'Versao ' + ObterVersaoExecutavel + sLineBreak + sLineBreak +
    'Avaliacao de Conhecimento em Delphi com Firebird' + sLineBreak +
    'Desenvolvido por: Andre Luis',
    mtInformation, [mbOK], 0);
end;

procedure TForm_Principal.ActSairExecute(Sender: TObject);
begin
  if MensagemDlg('Deseja realmente sair do sistema?', mtConfirmation,
     [mbYes, mbNo], 0) = mrYes then
    Application.Terminate;
end;

// ============================================================================
//   Relogio da StatusBar
// ============================================================================

procedure TForm_Principal.TimerRelogioTimer(Sender: TObject);
begin
  StatusBarPrincipal.Panels[4].Text :=
    FormatDateTime('dddd", "dd/mm/yyyy" - "hh:nn:ss', Now);
end;

// ============================================================================
//   Imagem de fundo no MDIClient
// ============================================================================

function TForm_Principal_EhCaminhoAbsoluto(const Caminho: string): Boolean;
begin
  Result := (Length(Caminho) >= 3) and
            CharInSet(UpCase(Caminho[1]), ['A'..'Z']) and
            (Caminho[2] = ':') and
            ((Caminho[3] = '\') or (Caminho[3] = '/'));
  if not Result then
    Result := (Length(Caminho) >= 2) and (Caminho[1] = '\') and (Caminho[2] = '\');
end;

function TForm_Principal_LocalizarArquivoFundo(out Encontrado: string): Boolean;
var
  PastaExe: string;
  PastaAtual: string;
  Bases: array of string;
  Extensoes: array of string;
  NomeBase: string;
  I, J: Integer;
  Tentativa: string;
  PastaRel: string;
begin
  Result     := False;
  Encontrado := '';
  NomeBase   := ChangeFileExt(ExtractFileName(ARQUIVO_FUNDO), '');
  PastaExe   := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName));
  PastaAtual := IncludeTrailingPathDelimiter(GetCurrentDir);
  PastaRel   := PASTA_IMAGENS_RELATIVA + PathDelim;

  // Ordem: ao lado do exe (distribuicao), pasta do projeto (exe em D:\Andre),
  // subindo niveis (Win32\Debug) e diretorio corrente do IDE.
  SetLength(Bases, 0);
  if (PASTA_IMAGENS <> '') and TForm_Principal_EhCaminhoAbsoluto(PASTA_IMAGENS) then
    Bases := Bases + [IncludeTrailingPathDelimiter(PASTA_IMAGENS)];

  Bases := Bases + [
    PastaExe + PastaRel,
    PastaExe,
    PastaExe + 'Projeto' + PathDelim + PastaRel,
    PastaExe + '..' + PathDelim + PastaRel,
    PastaExe + '..' + PathDelim + 'Projeto' + PathDelim + PastaRel,
    PastaExe + '..' + PathDelim + '..' + PathDelim + PastaRel,
    PastaExe + '..' + PathDelim + '..' + PathDelim + '..' + PathDelim + PastaRel,
    PastaAtual + PastaRel,
    PastaAtual + 'Projeto' + PathDelim + PastaRel
  ];

  Extensoes := ['.jpg', '.jpeg', '.png', '.bmp'];

  for I := Low(Bases) to High(Bases) do
    for J := Low(Extensoes) to High(Extensoes) do
    begin
      Tentativa := ExpandFileName(Bases[I] + NomeBase + Extensoes[J]);
      if FileExists(Tentativa) then
      begin
        Encontrado := Tentativa;
        Exit(True);
      end;
    end;
end;

function TForm_Principal_CriarGraficoPeloHeader(Stream: TStream): TGraphic;
var
  Header: array [0..7] of Byte;
  Lidos: Integer;
begin
  Result := nil;
  FillChar(Header, SizeOf(Header), 0);
  Lidos := Stream.Read(Header, SizeOf(Header));
  Stream.Position := 0;
  if Lidos < 4 then
    Exit;

  // JPEG: FF D8 FF
  if (Header[0] = $FF) and (Header[1] = $D8) and (Header[2] = $FF) then
    Result := TJPEGImage.Create
  // PNG: 89 50 4E 47 0D 0A 1A 0A
  else if (Header[0] = $89) and (Header[1] = $50) and
          (Header[2] = $4E) and (Header[3] = $47) then
    Result := TPngImage.Create
  // BMP: 42 4D
  else if (Header[0] = $42) and (Header[1] = $4D) then
    Result := TBitmap.Create;
end;

procedure TForm_Principal.CarregarImagemFundo;
var
  Caminho: string;
  Stream: TFileStream;
  Grafico: TGraphic;
begin
  if not TForm_Principal_LocalizarArquivoFundo(Caminho) then
    Exit;
  try
    Stream := TFileStream.Create(Caminho, fmOpenRead or fmShareDenyWrite);
    try
      Grafico := TForm_Principal_CriarGraficoPeloHeader(Stream);
      if Grafico = nil then
        Exit;
      try
        Grafico.LoadFromStream(Stream);
        FBitmapFundo.SetSize(Grafico.Width, Grafico.Height);
        FBitmapFundo.Canvas.Brush.Color := clWhite;
        FBitmapFundo.Canvas.FillRect(Rect(0, 0, Grafico.Width, Grafico.Height));
        FBitmapFundo.Canvas.Draw(0, 0, Grafico);
      finally
        Grafico.Free;
      end;
    finally
      Stream.Free;
    end;
  except
    FBitmapFundo.SetSize(0, 0);
  end;
end;

procedure TForm_Principal.DesenharFundo(DC: HDC);
var
  R: TRect;
  X, Y: Integer;
  Cnv: TCanvas;
  Msg: string;
begin
  Winapi.Windows.GetClientRect(ClientHandle, R);
  Cnv := TCanvas.Create;
  try
    Cnv.Handle := DC;
    Cnv.Brush.Color := COR_PAGE;
    Cnv.FillRect(R);
    if (FBitmapFundo <> nil) and (not FBitmapFundo.Empty) then
    begin
      X := ((R.Right - R.Left) - FBitmapFundo.Width) div 2;
      Y := ((R.Bottom - R.Top) - FBitmapFundo.Height) div 2;
      Cnv.Draw(X, Y, FBitmapFundo);
    end
    else
    begin
      Cnv.Font.Name  := 'Segoe UI';
      Cnv.Font.Size  := 32;
      Cnv.Font.Style := [fsBold];
      Cnv.Font.Color := $00A0A0A0;
      Cnv.Brush.Style := bsClear;
      Msg := EMPRESA_NOME;
      DrawText(Cnv.Handle, PChar(Msg), -1, R,
        DT_CENTER or DT_VCENTER or DT_SINGLELINE);
    end;
  finally
    Cnv.Handle := 0;
    Cnv.Free;
  end;
end;

procedure TForm_Principal.MDIClientWndProc(var Message: TMessage);
begin
  case Message.Msg of
    WM_ERASEBKGND:
      begin
        DesenharFundo(HDC(Message.WParam));
        Message.Result := 1;
        Exit;
      end;
    WM_SIZE:
      begin
        Message.Result := CallWindowProc(FOldMDIClientProc, ClientHandle,
          Message.Msg, Message.WParam, Message.LParam);
        InvalidateRect(ClientHandle, nil, True);
        Exit;
      end;
  end;
  Message.Result := CallWindowProc(FOldMDIClientProc, ClientHandle,
    Message.Msg, Message.WParam, Message.LParam);
end;

end.
