unit UITheme;

{ Temas visuais VCL (flat / cara de web).
  Cores em TColor BGR Delphi (0x00BBGGRR).
  COR_* sao var para permitir troca de tema em runtime.
  Botoes: owner-draw flat com hover (nao usa o chrome 3D do Windows). }

interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.UxTheme,
  System.Classes, System.SysUtils, System.Types,
  Vcl.Graphics, Vcl.Controls, Vcl.ExtCtrls, Vcl.Buttons, Vcl.StdCtrls,
  Vcl.Forms;

type
  TBootstrapBtnKind = (
    bbkPrimary,
    bbkSecondary,
    bbkSuccess,
    bbkWarning,
    bbkDanger,
    bbkOutline
  );

  TAppThemeId = (
    thClaroBootstrap,
    thEscuro,
    thVerde,
    thAzulEscuro,
    thLaranja,
    thRosa,
    thCiano,
    thRoxo
  );

var
  // Fundos / tipografia
  COR_PAGE: TColor;
  COR_CARD: TColor;
  COR_BORDER: TColor;
  COR_TEXTO: TColor;
  COR_TEXTO_MUTED: TColor;

  // Brand
  COR_PRIMARY: TColor;
  COR_SUCCESS: TColor;
  COR_WARNING: TColor;
  COR_DANGER: TColor;
  COR_SECONDARY: TColor;

  // Hover
  COR_PRIMARY_HOVER: TColor;
  COR_SUCCESS_HOVER: TColor;
  COR_WARNING_HOVER: TColor;
  COR_DANGER_HOVER: TColor;
  COR_SECONDARY_HOVER: TColor;
  COR_OUTLINE_HOVER: TColor;

  // Headers / foco
  COR_HEADER_PRIMARY: TColor;
  COR_HEADER_CLARO: TColor;
  COR_EDIT_FOCO_BS: TColor;

  // Estado (badges)
  COR_ESTADO_INSERT_BG: TColor;
  COR_ESTADO_INSERT_FG: TColor;
  COR_ESTADO_EDIT_BG: TColor;
  COR_ESTADO_EDIT_FG: TColor;
  COR_ESTADO_BROWSE_BG: TColor;
  COR_ESTADO_BROWSE_FG: TColor;

  // Shell (Principal / sidebar)
  COR_SIDEBAR_BG: TColor;
  COR_SIDEBAR_HEADER: TColor;
  COR_ITEM_HOVER: TColor;
  COR_ITEM_ATIVO: TColor;
  COR_TEXTO_CLARO: TColor;
  COR_TITULO_BAR: TColor;

const
  // Raios (Bootstrap-like)
  RAIO_FORM = 16;
  RAIO_CARD = 12;
  RAIO_FRAME = 10;

function NomeTema(Id: TAppThemeId): string;
function DescricaoTema(Id: TAppThemeId): string;
function TemaAtual: TAppThemeId;
procedure DefinirTema(Id: TAppThemeId; AplicarNosForms: Boolean = True);
procedure CarregarTemaSalvo;
procedure SalvarTemaAtual;
procedure AplicarTemaNoForm(Form: TForm);
procedure AplicarTemaGlobal;
function CaminhoIniTema: string;
procedure ObterAmostraTema(Id: TAppThemeId; out Primary, Page, Card: TColor);

procedure AplicarBotaoBootstrap(Btn: TBitBtn; Kind: TBootstrapBtnKind;
  const Icone: string = '');
procedure AplicarPainelCard(Panel: TPanel);
procedure AplicarGrupoCard(Grupo: TGroupBox);
procedure AplicarHeaderClaro(Panel: TPanel; Primary: Boolean = False);
procedure AplicarHeaderPrimary(Panel: TPanel);
procedure AplicarBotaoMaximizarHeader(Form: TForm; Header: TPanel);
procedure AplicarCantosArredondados(WinCtrl: TWinControl; Raio: Integer = RAIO_CARD);
procedure AplicarFormArredondado(Form: TForm; Raio: Integer = RAIO_FORM);
procedure RemoverChromeJanela(Form: TForm);
procedure AplicarFormEstiloWeb(Form: TForm; Raio: Integer = RAIO_FORM);
procedure DefinirGlyphMDL2(Btn: TBitBtn; const Icone: string; CorIcone: TColor);
procedure AlternarMaximizarForm(Form: TForm);

implementation

uses
  System.IniFiles;

const
  BS_OWNERDRAW = $0000000B;
  BTN_RADIUS   = 6;
  ICN_MAXIMIZAR = #$E922; // ChromeMaximize (Segoe MDL2)
  ICN_RESTAURAR = #$E923; // ChromeRestore
  NOME_BTN_MAX  = 'LblMaximizarHeader';

type
  TControlCracker = class(TControl);

  THeaderMaxHelper = class(TComponent)
  private
    FForm: TForm;
    FBtn: TLabel;
    FOldWndProc: TWndMethod;
    procedure WndProc(var Message: TMessage);
    procedure BtnClick(Sender: TObject);
  public
    constructor CreateFor(AForm: TForm; AHeader: TPanel);
    destructor Destroy; override;
    procedure AtualizarIcone;
  end;

  TRoundClipHelper = class(TComponent)
  private
    FTarget: TWinControl;
    FRaio: Integer;
    FOldWndProc: TWndMethod;
    procedure WndProc(var Message: TMessage);
    procedure AtualizarRegiao;
  public
    constructor CreateFor(ATarget: TWinControl; ARaio: Integer);
    destructor Destroy; override;
    procedure DefinirRaio(ARaio: Integer);
  end;

  TWebButtonPainter = class(TComponent)
  private
    FBtn: TBitBtn;
    FKind: TBootstrapBtnKind;
    FIcone: string;
    FHover: Boolean;
    FPressed: Boolean;
    FOldWndProc: TWndMethod;
    procedure WndProc(var Message: TMessage);
    procedure AplicarEstiloNativo;
    procedure ObterCores(out CorFundo, CorTexto, CorBorda: TColor);
    procedure Pintar(DC: HDC);
  public
    constructor CreateFor(AOwner: TBitBtn; AKind: TBootstrapBtnKind;
      const AIcone: string);
    destructor Destroy; override;
    procedure Reaplicar(AKind: TBootstrapBtnKind; const AIcone: string);
  end;

function AcharPainter(Btn: TBitBtn): TWebButtonPainter;
var
  I: Integer;
begin
  Result := nil;
  if Btn = nil then
    Exit;
  for I := 0 to Btn.ComponentCount - 1 do
    if Btn.Components[I] is TWebButtonPainter then
    begin
      Result := TWebButtonPainter(Btn.Components[I]);
      Exit;
    end;
end;

function AcharRoundHelper(WinCtrl: TWinControl): TRoundClipHelper;
var
  I: Integer;
begin
  Result := nil;
  if WinCtrl = nil then
    Exit;
  for I := 0 to WinCtrl.ComponentCount - 1 do
    if WinCtrl.Components[I] is TRoundClipHelper then
    begin
      Result := TRoundClipHelper(WinCtrl.Components[I]);
      Exit;
    end;
end;

function AcharHeaderMaxHelper(Form: TForm): THeaderMaxHelper;
var
  I: Integer;
begin
  Result := nil;
  if Form = nil then
    Exit;
  for I := 0 to Form.ComponentCount - 1 do
    if Form.Components[I] is THeaderMaxHelper then
    begin
      Result := THeaderMaxHelper(Form.Components[I]);
      Exit;
    end;
end;

procedure AlternarMaximizarForm(Form: TForm);
var
  RoundHelper: TRoundClipHelper;
begin
  if Form = nil then
    Exit;

  if Form.WindowState = wsMaximized then
  begin
    Form.WindowState := wsNormal;
    AplicarFormArredondado(Form, RAIO_FORM);
  end
  else
  begin
    RoundHelper := AcharRoundHelper(Form);
    if RoundHelper <> nil then
      RoundHelper.Free;
    if Form.HandleAllocated then
      SetWindowRgn(Form.Handle, 0, True);
    Form.WindowState := wsMaximized;
  end;
end;

constructor THeaderMaxHelper.CreateFor(AForm: TForm; AHeader: TPanel);
var
  Existente: TComponent;
begin
  inherited Create(AForm);
  FForm := AForm;

  Existente := AHeader.FindComponent(NOME_BTN_MAX);
  if Existente is TLabel then
    FBtn := TLabel(Existente)
  else
  begin
    FBtn := TLabel.Create(AHeader);
    FBtn.Name := NOME_BTN_MAX;
    FBtn.Parent := AHeader;
    FBtn.Align := alRight;
    FBtn.Width := 48;
    FBtn.AutoSize := False;
    FBtn.Alignment := taCenter;
    FBtn.Layout := tlCenter;
    FBtn.Transparent := True;
    FBtn.ParentFont := False;
    FBtn.Font.Name := 'Segoe MDL2 Assets';
    FBtn.Font.Height := -16;
    FBtn.Font.Color := clWhite;
    FBtn.Font.Style := [];
    FBtn.Cursor := crHandPoint;
    FBtn.ShowHint := True;
    FBtn.OnClick := BtnClick;
  end;

  FOldWndProc := FForm.WindowProc;
  FForm.WindowProc := WndProc;
  AtualizarIcone;
end;

destructor THeaderMaxHelper.Destroy;
begin
  if Assigned(FForm) and Assigned(FOldWndProc) then
    FForm.WindowProc := FOldWndProc;
  inherited;
end;

procedure THeaderMaxHelper.AtualizarIcone;
begin
  if (FBtn = nil) or (FForm = nil) then
    Exit;
  if FForm.WindowState = wsMaximized then
  begin
    FBtn.Caption := ICN_RESTAURAR;
    FBtn.Hint := 'Restaurar tamanho';
  end
  else
  begin
    FBtn.Caption := ICN_MAXIMIZAR;
    FBtn.Hint := 'Maximizar';
  end;
end;

procedure THeaderMaxHelper.BtnClick(Sender: TObject);
begin
  AlternarMaximizarForm(FForm);
  AtualizarIcone;
end;

procedure THeaderMaxHelper.WndProc(var Message: TMessage);
begin
  FOldWndProc(Message);
  case Message.Msg of
    WM_SIZE, WM_WINDOWPOSCHANGED:
      AtualizarIcone;
  end;
end;

constructor TRoundClipHelper.CreateFor(ATarget: TWinControl; ARaio: Integer);
begin
  inherited Create(ATarget);
  FTarget := ATarget;
  FRaio := ARaio;
  FOldWndProc := FTarget.WindowProc;
  FTarget.WindowProc := WndProc;
  AtualizarRegiao;
end;

destructor TRoundClipHelper.Destroy;
begin
  if Assigned(FTarget) and Assigned(FOldWndProc) then
  begin
    FTarget.WindowProc := FOldWndProc;
    if FTarget.HandleAllocated then
      SetWindowRgn(FTarget.Handle, 0, True);
  end;
  inherited;
end;

procedure TRoundClipHelper.DefinirRaio(ARaio: Integer);
begin
  FRaio := ARaio;
  AtualizarRegiao;
end;

procedure TRoundClipHelper.AtualizarRegiao;
var
  Rgn: HRGN;
  W, H: Integer;
  Form: TForm;
begin
  if (FTarget = nil) or (not FTarget.HandleAllocated) then
    Exit;

  // Form maximizado: sem mascara (evita "buracos" no desktop).
  if FTarget is TForm then
  begin
    Form := TForm(FTarget);
    if Form.WindowState = wsMaximized then
    begin
      SetWindowRgn(Form.Handle, 0, True);
      Exit;
    end;
    W := Form.Width;
    H := Form.Height;
  end
  else
  begin
    W := FTarget.Width;
    H := FTarget.Height;
  end;

  if (W < 4) or (H < 4) or (FRaio <= 0) then
  begin
    SetWindowRgn(FTarget.Handle, 0, True);
    Exit;
  end;

  // +1 no right/bottom: CreateRoundRectRgn e exclusivo no canto inferior direito.
  Rgn := CreateRoundRectRgn(0, 0, W + 1, H + 1, FRaio * 2, FRaio * 2);
  SetWindowRgn(FTarget.Handle, Rgn, True);
end;

procedure TRoundClipHelper.WndProc(var Message: TMessage);
begin
  FOldWndProc(Message);
  case Message.Msg of
    WM_SIZE, WM_WINDOWPOSCHANGED, CM_SHOWINGCHANGED:
      AtualizarRegiao;
    CM_RECREATEWND:
      AtualizarRegiao;
  end;
end;

function MisturarCor(Base, Alvo: TColor; PercentAlvo: Integer): TColor;
var
  R1, G1, B1, R2, G2, B2: Integer;
begin
  Base := ColorToRGB(Base);
  Alvo := ColorToRGB(Alvo);
  R1 := GetRValue(Base);
  G1 := GetGValue(Base);
  B1 := GetBValue(Base);
  R2 := GetRValue(Alvo);
  G2 := GetGValue(Alvo);
  B2 := GetBValue(Alvo);
  Result := RGB(
    R1 + ((R2 - R1) * PercentAlvo) div 100,
    G1 + ((G2 - G1) * PercentAlvo) div 100,
    B1 + ((B2 - B1) * PercentAlvo) div 100);
end;

constructor TWebButtonPainter.CreateFor(AOwner: TBitBtn; AKind: TBootstrapBtnKind;
  const AIcone: string);
begin
  inherited Create(AOwner);
  FBtn := AOwner;
  FKind := AKind;
  FIcone := AIcone;
  FHover := False;
  FPressed := False;
  FOldWndProc := FBtn.WindowProc;
  FBtn.WindowProc := WndProc;
  AplicarEstiloNativo;
  FBtn.Invalidate;
end;

destructor TWebButtonPainter.Destroy;
begin
  if Assigned(FBtn) then
  begin
    if Assigned(FOldWndProc) then
      FBtn.WindowProc := FOldWndProc;
  end;
  inherited;
end;

procedure TWebButtonPainter.Reaplicar(AKind: TBootstrapBtnKind; const AIcone: string);
begin
  FKind := AKind;
  FIcone := AIcone;
  AplicarEstiloNativo;
  FBtn.Invalidate;
end;

procedure TWebButtonPainter.AplicarEstiloNativo;
var
  Style: NativeInt;
begin
  if (FBtn = nil) or (not FBtn.HandleAllocated) then
    Exit;

  SetWindowTheme(FBtn.Handle, '', '');
  Style := GetWindowLong(FBtn.Handle, GWL_STYLE);
  if (Style and BS_OWNERDRAW) = 0 then
    SetWindowLong(FBtn.Handle, GWL_STYLE, Style or BS_OWNERDRAW);

  FBtn.ParentFont := False;
  FBtn.Font.Name := 'Segoe UI';
  FBtn.Font.Height := -13;
  FBtn.Font.Style := [];
  FBtn.Cursor := crHandPoint;
  FBtn.Margin := 0;
  FBtn.Spacing := 0;
  FBtn.Glyph.Assign(nil);
end;

procedure TWebButtonPainter.ObterCores(out CorFundo, CorTexto, CorBorda: TColor);
begin
  CorBorda := COR_BORDER;
  case FKind of
    bbkPrimary:
      begin
        CorFundo := COR_PRIMARY;
        CorTexto := clWhite;
        CorBorda := COR_PRIMARY;
        if FHover then
          CorFundo := COR_PRIMARY_HOVER;
      end;
    bbkSecondary:
      begin
        CorFundo := COR_SECONDARY;
        CorTexto := clWhite;
        CorBorda := COR_SECONDARY;
        if FHover then
          CorFundo := COR_SECONDARY_HOVER;
      end;
    bbkSuccess:
      begin
        CorFundo := COR_SUCCESS;
        CorTexto := clWhite;
        CorBorda := COR_SUCCESS;
        if FHover then
          CorFundo := COR_SUCCESS_HOVER;
      end;
    bbkWarning:
      begin
        CorFundo := COR_WARNING;
        CorTexto := COR_TEXTO;
        CorBorda := COR_WARNING;
        if FHover then
          CorFundo := COR_WARNING_HOVER;
      end;
    bbkDanger:
      begin
        CorFundo := COR_DANGER;
        CorTexto := clWhite;
        CorBorda := COR_DANGER;
        if FHover then
          CorFundo := COR_DANGER_HOVER;
      end;
  else
    begin
      CorFundo := COR_CARD;
      CorTexto := COR_TEXTO;
      CorBorda := COR_BORDER;
      if FHover then
        CorFundo := COR_OUTLINE_HOVER;
    end;
  end;

  if FPressed then
    CorFundo := MisturarCor(CorFundo, clBlack, 12);

  if not FBtn.Enabled then
  begin
    CorFundo := MisturarCor(CorFundo, COR_PAGE, 55);
    CorTexto := COR_TEXTO_MUTED;
    CorBorda := COR_BORDER;
  end;
end;

procedure TWebButtonPainter.Pintar(DC: HDC);
var
  Cnv: TCanvas;
  R: TRect;
  CorFundo, CorTexto, CorBorda: TColor;
  CaptionTxt: string;
  TemIcone: Boolean;
  IconW, Gap, TotalW: Integer;
  X, Y: Integer;
  SzCap, SzIcon: TSize;
begin
  Cnv := TCanvas.Create;
  try
    Cnv.Handle := DC;
    R := FBtn.ClientRect;
    ObterCores(CorFundo, CorTexto, CorBorda);

    // Fundo do parent (cantos arredondados sem "sujeira")
    Cnv.Brush.Color := COR_PAGE;
    if Assigned(FBtn.Parent) then
      Cnv.Brush.Color := TControlCracker(FBtn.Parent).Color;
    Cnv.FillRect(R);

    // Corpo flat arredondado (cara Bootstrap)
    Cnv.Brush.Color := CorFundo;
    Cnv.Pen.Color := CorBorda;
    Cnv.Pen.Width := 1;
    Cnv.RoundRect(R.Left, R.Top, R.Right, R.Bottom, BTN_RADIUS * 2, BTN_RADIUS * 2);

    CaptionTxt := FBtn.Caption;
    // Remove acelerador visual (&) apenas na medicao; DrawText trata &.
    TemIcone := FIcone <> '';

    Cnv.Font.Name := 'Segoe UI';
    Cnv.Font.Height := -13;
    Cnv.Font.Style := [];
    Cnv.Font.Color := CorTexto;
    Cnv.Brush.Style := bsClear;
    SzCap := Cnv.TextExtent(StringReplace(CaptionTxt, '&', '', [rfReplaceAll]));

    IconW := 0;
    Gap := 0;
    SzIcon.cx := 0;
    SzIcon.cy := 0;
    if TemIcone then
    begin
      Cnv.Font.Name := 'Segoe MDL2 Assets';
      Cnv.Font.Height := -14;
      SzIcon := Cnv.TextExtent(FIcone);
      IconW := SzIcon.cx;
      if CaptionTxt <> '' then
        Gap := 8;
      Cnv.Font.Name := 'Segoe UI';
      Cnv.Font.Height := -13;
    end;

    if (CaptionTxt = '') and TemIcone then
    begin
      // Botao so icone (navegacao)
      Cnv.Font.Name := 'Segoe MDL2 Assets';
      Cnv.Font.Height := -14;
      Cnv.Font.Color := CorTexto;
      X := (R.Width - SzIcon.cx) div 2;
      Y := (R.Height - SzIcon.cy) div 2;
      Cnv.TextOut(X, Y, FIcone);
    end
    else
    begin
      TotalW := IconW + Gap + SzCap.cx;
      X := (R.Width - TotalW) div 2;
      if TemIcone then
      begin
        Cnv.Font.Name := 'Segoe MDL2 Assets';
        Cnv.Font.Height := -14;
        Cnv.Font.Color := CorTexto;
        Y := (R.Height - SzIcon.cy) div 2;
        Cnv.TextOut(X, Y, FIcone);
        Inc(X, IconW + Gap);
      end;
      Cnv.Font.Name := 'Segoe UI';
      Cnv.Font.Height := -13;
      Cnv.Font.Style := [];
      Cnv.Font.Color := CorTexto;
      Y := (R.Height - SzCap.cy) div 2;
      Cnv.TextOut(X, Y, StringReplace(CaptionTxt, '&', '', [rfReplaceAll]));
    end;
  finally
    Cnv.Handle := 0;
    Cnv.Free;
  end;
end;

procedure TWebButtonPainter.WndProc(var Message: TMessage);
var
  DrawItem: TWMDrawItem;
begin
  case Message.Msg of
    CN_DRAWITEM:
      begin
        DrawItem := TWMDrawItem(Message);
        if DrawItem.DrawItemStruct <> nil then
          Pintar(DrawItem.DrawItemStruct^.hDC);
        Message.Result := 1;
        Exit;
      end;
    WM_ERASEBKGND:
      begin
        Message.Result := 1;
        Exit;
      end;
    WM_PAINT:
      begin
        // Com BS_OWNERDRAW o Windows envia DRAWITEM; ainda assim
        // forca repaint limpo se chegar WM_PAINT direto.
        FOldWndProc(Message);
        Exit;
      end;
    CM_MOUSEENTER:
      begin
        FHover := True;
        FBtn.Invalidate;
      end;
    CM_MOUSELEAVE:
      begin
        FHover := False;
        FPressed := False;
        FBtn.Invalidate;
      end;
    WM_LBUTTONDOWN:
      begin
        FPressed := True;
        FBtn.Invalidate;
      end;
    WM_LBUTTONUP, WM_CANCELMODE:
      begin
        FPressed := False;
        FBtn.Invalidate;
      end;
    CM_ENABLEDCHANGED, CM_TEXTCHANGED, WM_SIZE:
      FBtn.Invalidate;
    CM_RECREATEWND:
      begin
        FOldWndProc(Message);
        AplicarEstiloNativo;
        Exit;
      end;
  end;
  FOldWndProc(Message);
  if Message.Msg = CM_SHOWINGCHANGED then
    AplicarEstiloNativo;
end;

procedure DefinirGlyphMDL2(Btn: TBitBtn; const Icone: string; CorIcone: TColor);
begin
  // Mantido por compatibilidade; o painter web desenha o icone diretamente.
  if (Btn = nil) or (Icone = '') then
    Exit;
  Btn.Glyph.Assign(nil);
end;

procedure AplicarBotaoBootstrap(Btn: TBitBtn; Kind: TBootstrapBtnKind;
  const Icone: string);
var
  Painter: TWebButtonPainter;
  CorTexto: TColor;
begin
  if Btn = nil then
    Exit;

  case Kind of
    bbkWarning:
      CorTexto := COR_TEXTO;
    bbkOutline:
      CorTexto := COR_TEXTO;
  else
    CorTexto := clWhite;
  end;
  Btn.Font.Color := CorTexto;

  Painter := AcharPainter(Btn);
  if Painter = nil then
    TWebButtonPainter.CreateFor(Btn, Kind, Icone)
  else
    Painter.Reaplicar(Kind, Icone);
end;

procedure AplicarPainelCard(Panel: TPanel);
begin
  if Panel = nil then
    Exit;
  Panel.ParentBackground := False;
  Panel.BevelOuter := bvNone;
  Panel.BevelInner := bvNone;
  Panel.Color := COR_CARD;
  // Sem SetWindowRgn no painel: filhos (DBEdit) falham no SetFocus com
  // EInvalidOperation em forms MDI bsNone.
end;

procedure AplicarGrupoCard(Grupo: TGroupBox);
begin
  if Grupo = nil then
    Exit;
  Grupo.ParentBackground := False;
  Grupo.Color := COR_CARD;
  Grupo.Font.Color := COR_PRIMARY;
  // Nao aplica SetWindowRgn em TGroupBox: quebra CanFocus/SetFocus dos filhos
  // (EInvalidOperation: Cannot focus a disabled or invisible window).
end;

procedure AplicarCantosArredondados(WinCtrl: TWinControl; Raio: Integer);
var
  Helper: TRoundClipHelper;
begin
  if WinCtrl = nil then
    Exit;
  Helper := AcharRoundHelper(WinCtrl);
  if Helper = nil then
    TRoundClipHelper.CreateFor(WinCtrl, Raio)
  else
    Helper.DefinirRaio(Raio);
end;

procedure AplicarFormArredondado(Form: TForm; Raio: Integer);
begin
  if Form = nil then
    Exit;
  // Maximizado: sem mascara (cantos "furados" na area MDI/desktop).
  if Form.WindowState = wsMaximized then
    Exit;
  AplicarCantosArredondados(Form, Raio);
end;

procedure RemoverChromeJanela(Form: TForm);
var
  Style, ExStyle: NativeInt;
begin
  // bsNone no VCL nao basta em MDI child: o Windows ainda desenha
  // caption/borda. Remove o non-client via estilos nativos.
  if (Form = nil) or (not Form.HandleAllocated) then
    Exit;

  Style := GetWindowLong(Form.Handle, GWL_STYLE);
  Style := Style and not (WS_CAPTION or WS_THICKFRAME or WS_MINIMIZEBOX or
    WS_MAXIMIZEBOX or WS_SYSMENU or WS_BORDER or WS_DLGFRAME);
  // Preserva filho MDI: sem WS_CHILD a janela "escapa" da area cliente.
  if Form.FormStyle = fsMDIChild then
    Style := Style or WS_CHILD or WS_CLIPSIBLINGS or WS_CLIPCHILDREN;
  SetWindowLong(Form.Handle, GWL_STYLE, Style);

  ExStyle := GetWindowLong(Form.Handle, GWL_EXSTYLE);
  ExStyle := ExStyle and not (WS_EX_DLGMODALFRAME or WS_EX_CLIENTEDGE or
    WS_EX_STATICEDGE or WS_EX_WINDOWEDGE);
  SetWindowLong(Form.Handle, GWL_EXSTYLE, ExStyle);

  SetWindowPos(Form.Handle, 0, 0, 0, 0, 0,
    SWP_NOMOVE or SWP_NOSIZE or SWP_NOZORDER or SWP_NOOWNERZORDER or
    SWP_FRAMECHANGED or SWP_NOACTIVATE);
end;

procedure AplicarHeaderClaro(Panel: TPanel; Primary: Boolean);
begin
  if Panel = nil then
    Exit;
  Panel.ParentBackground := False;
  Panel.BevelOuter := bvNone;
  Panel.ParentFont := False;
  Panel.Font.Name := 'Segoe UI Semibold';
  Panel.Font.Height := -20;
  Panel.Font.Style := [fsBold];
  if Primary then
  begin
    Panel.Color := COR_HEADER_PRIMARY;
    Panel.Font.Color := clWhite;
  end
  else
  begin
    Panel.Color := COR_HEADER_CLARO;
    Panel.Font.Color := COR_TEXTO;
  end;
end;

procedure AplicarHeaderPrimary(Panel: TPanel);
begin
  AplicarHeaderClaro(Panel, True);
end;

procedure AplicarBotaoMaximizarHeader(Form: TForm; Header: TPanel);
begin
  if (Form = nil) or (Header = nil) then
    Exit;
  if AcharHeaderMaxHelper(Form) = nil then
    THeaderMaxHelper.CreateFor(Form, Header)
  else
    // Garante icone sincronizado se o helper ja existir.
    AcharHeaderMaxHelper(Form).AtualizarIcone;
end;

procedure AplicarFormEstiloWeb(Form: TForm; Raio: Integer);
var
  Header: TComponent;
begin
  if Form = nil then
    Exit;

  // Principal (MDI form): nao remove chrome do SO.
  if Form.FormStyle = fsMDIForm then
    Exit;

  Form.BorderIcons := [];
  Form.BorderStyle := bsNone;
  RemoverChromeJanela(Form);

  if Form.FormStyle = fsMDIChild then
  begin
    Form.BringToFront;
    Header := Form.FindComponent('Panel_Titulo');
    if Header is TPanel then
      AplicarBotaoMaximizarHeader(Form, TPanel(Header));
  end;

  // Cantos arredondados apenas em wsNormal (maximizado limpa a mascara).
  AplicarFormArredondado(Form, Raio);
end;

// ============================================================================
//   Temas (paletas + persistencia INI)
// ============================================================================

var
  GTemaAtual: TAppThemeId = thClaroBootstrap;

procedure AplicarPaleta(Id: TAppThemeId);
begin
  case Id of
    thEscuro:
      begin
        COR_PAGE := $00201A16;
        COR_CARD := $00322B26;
        COR_BORDER := $00453C36;
        COR_TEXTO := $00F3F0ED;
        COR_TEXTO_MUTED := $00A89F98;
        COR_PRIMARY := $00FF9F4A; // azul claro (#4A9FFF)
        COR_SUCCESS := $0058B86A;
        COR_WARNING := $0000C8F0;
        COR_DANGER := $005555E0;
        COR_SECONDARY := $008A8078;
        COR_PRIMARY_HOVER := $00E08A3A;
        COR_SUCCESS_HOVER := $0048A058;
        COR_WARNING_HOVER := $0000B0D8;
        COR_DANGER_HOVER := $004444C8;
        COR_SECONDARY_HOVER := $00787068;
        COR_OUTLINE_HOVER := $003A322C;
        COR_HEADER_PRIMARY := COR_PRIMARY;
        COR_HEADER_CLARO := $00322B26;
        COR_EDIT_FOCO_BS := $00402E20;
        COR_ESTADO_INSERT_BG := $00284030;
        COR_ESTADO_INSERT_FG := $0090E0B0;
        COR_ESTADO_EDIT_BG := $00383820;
        COR_ESTADO_EDIT_FG := $00F0E080;
        COR_ESTADO_BROWSE_BG := $00383028;
        COR_ESTADO_BROWSE_FG := $00C0B8B0;
        COR_SIDEBAR_BG := $0014100E;
        COR_SIDEBAR_HEADER := $000C0A08;
        COR_ITEM_HOVER := $0028221E;
        COR_ITEM_ATIVO := COR_PRIMARY;
        COR_TEXTO_CLARO := $00F3F0ED;
        COR_TITULO_BAR := $00603018; // azul escuro
      end;
    thVerde:
      begin
        COR_PAGE := $00F4F8F2;
        COR_CARD := clWhite;
        COR_BORDER := $00D0DED0;
        COR_TEXTO := $00201E18;
        COR_TEXTO_MUTED := $00687868;
        COR_PRIMARY := $00548719; // #198754
        COR_SUCCESS := $00406E14;
        COR_WARNING := $0007C1FF;
        COR_DANGER := $004535DC;
        COR_SECONDARY := $00687868;
        COR_PRIMARY_HOVER := $00477315;
        COR_SUCCESS_HOVER := $00355C10;
        COR_WARNING_HOVER := $0000B0FF;
        COR_DANGER_HOVER := $00312ABB;
        COR_SECONDARY_HOVER := $00586858;
        COR_OUTLINE_HOVER := $00E8F0E4;
        COR_HEADER_PRIMARY := COR_PRIMARY;
        COR_HEADER_CLARO := clWhite;
        COR_EDIT_FOCO_BS := $00DDF0D8;
        COR_ESTADO_INSERT_BG := $00D1E7DD;
        COR_ESTADO_INSERT_FG := $000F5132;
        COR_ESTADO_EDIT_BG := $00FFF3CD;
        COR_ESTADO_EDIT_FG := $00664D03;
        COR_ESTADO_BROWSE_BG := $00E2E8E0;
        COR_ESTADO_BROWSE_FG := $00384838;
        COR_SIDEBAR_BG := $001E2E1A;
        COR_SIDEBAR_HEADER := $00141E12;
        COR_ITEM_HOVER := $002E3E28;
        COR_ITEM_ATIVO := COR_PRIMARY;
        COR_TEXTO_CLARO := $00F4F8F2;
        COR_TITULO_BAR := $003E6A14;
      end;
    thAzulEscuro:
      begin
        COR_PAGE := $00F4F2F0;
        COR_CARD := clWhite;
        COR_BORDER := $00DED8D4;
        COR_TEXTO := $00221E1A;
        COR_TEXTO_MUTED := $00706A64;
        COR_PRIMARY := $00A1470D; // #0D47A1
        COR_SUCCESS := $00548719;
        COR_WARNING := $0007C1FF;
        COR_DANGER := $004535DC;
        COR_SECONDARY := $00706A64;
        COR_PRIMARY_HOVER := $00883A0A;
        COR_SUCCESS_HOVER := $00477315;
        COR_WARNING_HOVER := $0000B0FF;
        COR_DANGER_HOVER := $00312ABB;
        COR_SECONDARY_HOVER := $005C5650;
        COR_OUTLINE_HOVER := $00ECE8E4;
        COR_HEADER_PRIMARY := COR_PRIMARY;
        COR_HEADER_CLARO := clWhite;
        COR_EDIT_FOCO_BS := $00FFE2CF;
        COR_ESTADO_INSERT_BG := $00D1E7DD;
        COR_ESTADO_INSERT_FG := $000F5132;
        COR_ESTADO_EDIT_BG := $00FFF3CD;
        COR_ESTADO_EDIT_FG := $00664D03;
        COR_ESTADO_BROWSE_BG := $00E2E3E5;
        COR_ESTADO_BROWSE_FG := $00414A53;
        COR_SIDEBAR_BG := $00281E14;
        COR_SIDEBAR_HEADER := $001C140E;
        COR_ITEM_HOVER := $00382C20;
        COR_ITEM_ATIVO := COR_PRIMARY;
        COR_TEXTO_CLARO := $00F4F2F0;
        COR_TITULO_BAR := $00A1470D;
      end;
    thLaranja:
      begin
        COR_PAGE := $00F8F6F2;
        COR_CARD := clWhite;
        COR_BORDER := $00E4DCD4;
        COR_TEXTO := $00241E18;
        COR_TEXTO_MUTED := $00787068;
        COR_PRIMARY := $00007AF0; // #F07A00
        COR_SUCCESS := $00548719;
        COR_WARNING := $0007C1FF;
        COR_DANGER := $004535DC;
        COR_SECONDARY := $00787068;
        COR_PRIMARY_HOVER := $000068D0;
        COR_SUCCESS_HOVER := $00477315;
        COR_WARNING_HOVER := $0000B0FF;
        COR_DANGER_HOVER := $00312ABB;
        COR_SECONDARY_HOVER := $00605850;
        COR_OUTLINE_HOVER := $00F4ECE4;
        COR_HEADER_PRIMARY := COR_PRIMARY;
        COR_HEADER_CLARO := clWhite;
        COR_EDIT_FOCO_BS := $00D8EEFF;
        COR_ESTADO_INSERT_BG := $00D1E7DD;
        COR_ESTADO_INSERT_FG := $000F5132;
        COR_ESTADO_EDIT_BG := $00FFF3CD;
        COR_ESTADO_EDIT_FG := $00664D03;
        COR_ESTADO_BROWSE_BG := $00E8E4E0;
        COR_ESTADO_BROWSE_FG := $00484038;
        COR_SIDEBAR_BG := $00241C14;
        COR_SIDEBAR_HEADER := $00181410;
        COR_ITEM_HOVER := $0034281C;
        COR_ITEM_ATIVO := COR_PRIMARY;
        COR_TEXTO_CLARO := $00F8F6F2;
        COR_TITULO_BAR := $00005AB8;
      end;
    thRosa:
      begin
        COR_PAGE := $00FBF6F8;
        COR_CARD := clWhite;
        COR_BORDER := $00E8D8E0;
        COR_TEXTO := $00241A20;
        COR_TEXTO_MUTED := $00786870;
        COR_PRIMARY := $00631EE9; // #E91E63
        COR_SUCCESS := $00548719;
        COR_WARNING := $0007C1FF;
        COR_DANGER := $004535DC;
        COR_SECONDARY := $00786870;
        COR_PRIMARY_HOVER := $005018C8;
        COR_SUCCESS_HOVER := $00477315;
        COR_WARNING_HOVER := $0000B0FF;
        COR_DANGER_HOVER := $00312ABB;
        COR_SECONDARY_HOVER := $00605860;
        COR_OUTLINE_HOVER := $00F8ECF0;
        COR_HEADER_PRIMARY := COR_PRIMARY;
        COR_HEADER_CLARO := clWhite;
        COR_EDIT_FOCO_BS := $00F0D8EC;
        COR_ESTADO_INSERT_BG := $00D1E7DD;
        COR_ESTADO_INSERT_FG := $000F5132;
        COR_ESTADO_EDIT_BG := $00FFF3CD;
        COR_ESTADO_EDIT_FG := $00664D03;
        COR_ESTADO_BROWSE_BG := $00EDE4E8;
        COR_ESTADO_BROWSE_FG := $00483848;
        COR_SIDEBAR_BG := $00281820;
        COR_SIDEBAR_HEADER := $001C1018;
        COR_ITEM_HOVER := $00382430;
        COR_ITEM_ATIVO := COR_PRIMARY;
        COR_TEXTO_CLARO := $00FBF6F8;
        COR_TITULO_BAR := $005018C0;
      end;
    thCiano:
      begin
        COR_PAGE := $00F4F8F8;
        COR_CARD := clWhite;
        COR_BORDER := $00D0E0E0;
        COR_TEXTO := $00182020;
        COR_TEXTO_MUTED := $00607070;
        COR_PRIMARY := $0088940D; // #0D9488 teal
        COR_SUCCESS := $00548719;
        COR_WARNING := $0007C1FF;
        COR_DANGER := $004535DC;
        COR_SECONDARY := $00607070;
        COR_PRIMARY_HOVER := $0070780B;
        COR_SUCCESS_HOVER := $00477315;
        COR_WARNING_HOVER := $0000B0FF;
        COR_DANGER_HOVER := $00312ABB;
        COR_SECONDARY_HOVER := $00505858;
        COR_OUTLINE_HOVER := $00E4F0F0;
        COR_HEADER_PRIMARY := COR_PRIMARY;
        COR_HEADER_CLARO := clWhite;
        COR_EDIT_FOCO_BS := $00D8F0EC;
        COR_ESTADO_INSERT_BG := $00D1E7DD;
        COR_ESTADO_INSERT_FG := $000F5132;
        COR_ESTADO_EDIT_BG := $00FFF3CD;
        COR_ESTADO_EDIT_FG := $00664D03;
        COR_ESTADO_BROWSE_BG := $00E0E8E8;
        COR_ESTADO_BROWSE_FG := $00384848;
        COR_SIDEBAR_BG := $001C2828;
        COR_SIDEBAR_HEADER := $00141C1C;
        COR_ITEM_HOVER := $002C3838;
        COR_ITEM_ATIVO := COR_PRIMARY;
        COR_TEXTO_CLARO := $00F4F8F8;
        COR_TITULO_BAR := $0070780B;
      end;
    thRoxo:
      begin
        COR_PAGE := $00F8F6FA;
        COR_CARD := clWhite;
        COR_BORDER := $00E0D8E8;
        COR_TEXTO := $00201828;
        COR_TEXTO_MUTED := $00706878;
        COR_PRIMARY := $00ED3A7C; // #7C3AED
        COR_SUCCESS := $00548719;
        COR_WARNING := $0007C1FF;
        COR_DANGER := $004535DC;
        COR_SECONDARY := $00706878;
        COR_PRIMARY_HOVER := $00D03268;
        COR_SUCCESS_HOVER := $00477315;
        COR_WARNING_HOVER := $0000B0FF;
        COR_DANGER_HOVER := $00312ABB;
        COR_SECONDARY_HOVER := $005C5860;
        COR_OUTLINE_HOVER := $00F0ECF4;
        COR_HEADER_PRIMARY := COR_PRIMARY;
        COR_HEADER_CLARO := clWhite;
        COR_EDIT_FOCO_BS := $00F0E0F8;
        COR_ESTADO_INSERT_BG := $00D1E7DD;
        COR_ESTADO_INSERT_FG := $000F5132;
        COR_ESTADO_EDIT_BG := $00FFF3CD;
        COR_ESTADO_EDIT_FG := $00664D03;
        COR_ESTADO_BROWSE_BG := $00E8E4EC;
        COR_ESTADO_BROWSE_FG := $00484050;
        COR_SIDEBAR_BG := $00201828;
        COR_SIDEBAR_HEADER := $0014101C;
        COR_ITEM_HOVER := $00302838;
        COR_ITEM_ATIVO := COR_PRIMARY;
        COR_TEXTO_CLARO := $00F8F6FA;
        COR_TITULO_BAR := $00C02860;
      end;
  else
    // thClaroBootstrap (padrao)
    begin
      COR_PAGE := $00FAF9F8;
      COR_CARD := clWhite;
      COR_BORDER := $00E6E2DE;
      COR_TEXTO := $00292521;
      COR_TEXTO_MUTED := $007D756C;
      COR_PRIMARY := $00FD6E0D; // #0D6EFD
      COR_SUCCESS := $00548719;
      COR_WARNING := $0007C1FF;
      COR_DANGER := $004535DC;
      COR_SECONDARY := $007D756C;
      COR_PRIMARY_HOVER := $00D75E0B;
      COR_SUCCESS_HOVER := $00477315;
      COR_WARNING_HOVER := $0000B0FF;
      COR_DANGER_HOVER := $00312ABB;
      COR_SECONDARY_HOVER := $00656A65;
      COR_OUTLINE_HOVER := $00F8F9FA;
      COR_HEADER_PRIMARY := COR_PRIMARY;
      COR_HEADER_CLARO := clWhite;
      COR_EDIT_FOCO_BS := $00FFE2CF;
      COR_ESTADO_INSERT_BG := $00D1E7DD;
      COR_ESTADO_INSERT_FG := $000F5132;
      COR_ESTADO_EDIT_BG := $00FFF3CD;
      COR_ESTADO_EDIT_FG := $00664D03;
      COR_ESTADO_BROWSE_BG := $00E2E3E5;
      COR_ESTADO_BROWSE_FG := $00414A53;
      COR_SIDEBAR_BG := $001F2937;
      COR_SIDEBAR_HEADER := $00111827;
      COR_ITEM_HOVER := $00374151;
      COR_ITEM_ATIVO := COR_PRIMARY;
      COR_TEXTO_CLARO := $00F9FAFB;
      COR_TITULO_BAR := $00A1470D;
    end;
  end;
end;

function NomeTema(Id: TAppThemeId): string;
begin
  case Id of
    thEscuro:     Result := 'Escuro';
    thVerde:      Result := 'Verde';
    thAzulEscuro: Result := 'Azul escuro';
    thLaranja:    Result := 'Laranja';
    thRosa:       Result := 'Rosa';
    thCiano:      Result := 'Ciano';
    thRoxo:       Result := 'Roxo';
  else
    Result := 'Claro (Bootstrap)';
  end;
end;

function DescricaoTema(Id: TAppThemeId): string;
begin
  case Id of
    thEscuro:
      Result := 'Fundo escuro, texto claro e destaque azul.';
    thVerde:
      Result := 'Primaria verde, pagina em tom verde-cinza.';
    thAzulEscuro:
      Result := 'Primaria azul escuro, pagina cinza frio.';
    thLaranja:
      Result := 'Primaria laranja, pagina em tom quente.';
    thRosa:
      Result := 'Primaria rosa, pagina em tom suave.';
    thCiano:
      Result := 'Primaria ciano/teal, pagina fresca.';
    thRoxo:
      Result := 'Primaria roxa, pagina em tom lavanda.';
  else
    Result := 'Tema claro padrao alinhado ao Bootstrap 5.';
  end;
end;

function TemaAtual: TAppThemeId;
begin
  Result := GTemaAtual;
end;

function CaminhoIniTema: string;
begin
  Result := ExtractFilePath(ParamStr(0)) + 'Projeto_Avaliacao.ini';
end;

procedure SalvarTemaAtual;
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(CaminhoIniTema);
  try
    Ini.WriteInteger('Tema', 'Id', Ord(GTemaAtual));
  finally
    Ini.Free;
  end;
end;

procedure CarregarTemaSalvo;
var
  Ini: TIniFile;
  Valor: Integer;
  Id: TAppThemeId;
begin
  Id := thClaroBootstrap;
  Ini := TIniFile.Create(CaminhoIniTema);
  try
    Valor := Ini.ReadInteger('Tema', 'Id', Ord(thClaroBootstrap));
    if (Valor >= Ord(Low(TAppThemeId))) and (Valor <= Ord(High(TAppThemeId))) then
      Id := TAppThemeId(Valor);
  finally
    Ini.Free;
  end;
  // Apenas define cores; nao toca Screen.Forms (init precoce).
  DefinirTema(Id, False);
end;

procedure ObterAmostraTema(Id: TAppThemeId; out Primary, Page, Card: TColor);
begin
  case Id of
    thEscuro:
      begin
        Primary := $00FF9F4A;
        Page := $00201A16;
        Card := $00322B26;
      end;
    thVerde:
      begin
        Primary := $00548719;
        Page := $00F4F8F2;
        Card := clWhite;
      end;
    thAzulEscuro:
      begin
        Primary := $00A1470D;
        Page := $00F4F2F0;
        Card := clWhite;
      end;
    thLaranja:
      begin
        Primary := $00007AF0;
        Page := $00F8F6F2;
        Card := clWhite;
      end;
    thRosa:
      begin
        Primary := $00631EE9;
        Page := $00FBF6F8;
        Card := clWhite;
      end;
    thCiano:
      begin
        Primary := $0088940D;
        Page := $00F4F8F8;
        Card := clWhite;
      end;
    thRoxo:
      begin
        Primary := $00ED3A7C;
        Page := $00F8F6FA;
        Card := clWhite;
      end;
  else
    begin
      Primary := $00FD6E0D;
      Page := $00FAF9F8;
      Card := clWhite;
    end;
  end;
end;

procedure DefinirTema(Id: TAppThemeId; AplicarNosForms: Boolean);
begin
  GTemaAtual := Id;
  AplicarPaleta(Id);
  // Grava apenas na escolha do usuario (AplicarNosForms=True).
  // Init usa False para nao sobrescrever o INI antes de CarregarTemaSalvo.
  if AplicarNosForms then
  begin
    SalvarTemaAtual;
    AplicarTemaGlobal;
  end;
end;

procedure AplicarPainelPorNome(Form: TForm; const Nome: string; Cor: TColor;
  ComoCard: Boolean);
var
  C: TComponent;
begin
  C := Form.FindComponent(Nome);
  if not (C is TPanel) then
    Exit;
  if ComoCard then
    AplicarPainelCard(TPanel(C))
  else
  begin
    TPanel(C).ParentBackground := False;
    TPanel(C).BevelOuter := bvNone;
    TPanel(C).Color := Cor;
  end;
end;

procedure AplicarTemaNoForm(Form: TForm);
var
  C: TComponent;
  I: Integer;
  Lbl: TLabel;
begin
  if Form = nil then
    Exit;

  Form.Color := COR_PAGE;
  Form.Font.Color := COR_TEXTO;

  C := Form.FindComponent('Panel_Titulo');
  if C is TPanel then
  begin
    if Form.FormStyle = fsMDIForm then
    begin
      TPanel(C).ParentBackground := False;
      TPanel(C).BevelOuter := bvNone;
      TPanel(C).Color := COR_TITULO_BAR;
      TPanel(C).Font.Color := clWhite;
    end
    else
      AplicarHeaderPrimary(TPanel(C));
  end;

  AplicarPainelPorNome(Form, 'PanelRodape', COR_PAGE, False);
  AplicarPainelPorNome(Form, 'PanelDados', COR_PAGE, False);
  AplicarPainelPorNome(Form, 'PanelEstado', COR_ESTADO_BROWSE_BG, False);
  AplicarPainelPorNome(Form, 'PanelIdentificacao', COR_CARD, True);
  AplicarPainelPorNome(Form, 'PanelObservacao', COR_CARD, True);

  C := Form.FindComponent('LabelEstadoAtual');
  if C is TLabel then
  begin
    Lbl := TLabel(C);
    Lbl.Font.Color := COR_ESTADO_BROWSE_FG;
  end;

  for I := 0 to Form.ComponentCount - 1 do
    if Form.Components[I] is TGroupBox then
      AplicarGrupoCard(TGroupBox(Form.Components[I]));

  if Form.FormStyle = fsMDIForm then
  begin
    AplicarPainelPorNome(Form, 'PanelSidebar', COR_SIDEBAR_BG, False);
    AplicarPainelPorNome(Form, 'PanelSidebarHeader', COR_SIDEBAR_HEADER, False);
    AplicarPainelPorNome(Form, 'PanelSeparador', COR_SIDEBAR_HEADER, False);
    for I := 0 to Form.ComponentCount - 1 do
    begin
      C := Form.Components[I];
      if (C is TPanel) and (Pos('PanelItem', C.Name) = 1) then
      begin
        TPanel(C).ParentBackground := False;
        TPanel(C).Color := COR_SIDEBAR_BG;
      end
      else if (C is TLabel) and
        ((Pos('LabelTexto', C.Name) = 1) or (Pos('LabelIcone', C.Name) = 1) or
         (C.Name = 'LabelTituloSidebar')) then
        TLabel(C).Font.Color := COR_TEXTO_CLARO;
    end;
  end;

  Form.Invalidate;
end;

procedure AplicarTemaGlobal;
var
  I: Integer;
begin
  if Screen = nil then
    Exit;
  for I := 0 to Screen.FormCount - 1 do
    AplicarTemaNoForm(Screen.Forms[I]);
end;

initialization
  DefinirTema(thClaroBootstrap, False);
  CarregarTemaSalvo;

end.
