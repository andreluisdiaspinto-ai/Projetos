unit LoadingBusy;

{ Overlay de carregamento com spinner circular animado por thread.
  API: IniciarCarregamento / FinalizarCarregamento / CarregamentoAtivo.
  Contagem de referencias para chamadas aninhadas. }

interface

uses
  System.SysUtils, Vcl.Forms;

procedure IniciarCarregamento(OwnerForm: TCustomForm);
procedure FinalizarCarregamento;
procedure AbortarCarregamento;
procedure ExecutarComCarregamento(OwnerForm: TCustomForm; const AAction: TProc);
function CarregamentoAtivo: Boolean;

implementation

uses
  Winapi.Windows,
  System.Classes, System.Types, System.Math, System.SyncObjs,
  Vcl.Controls, Vcl.Graphics, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Dialogs,
  Vcl.Imaging.GIFImg,
  UITheme;

type
  TFormLoadingOverlay = class;

  TSpinnerThread = class(TThread)
  private
    FAngle: Integer;
    FOverlay: TFormLoadingOverlay;
    procedure InvalidateOverlay;
  protected
    procedure Execute; override;
  public
    constructor Create(AOverlay: TFormLoadingOverlay);
    property Angle: Integer read FAngle;
  end;

  TFormLoadingOverlay = class(TForm)
  private
    FPaintBox: TPaintBox;
    FImage: TImage;
    FCaption: TLabel;
    FUseGif: Boolean;
    FAngle: Integer;
    FAngleLock: TCriticalSection;
    procedure PaintBoxPaint(Sender: TObject);
    procedure DesenharSpinner(ACanvas: TCanvas; const ACenter: TPoint;
      ARadius: Integer; AAngle: Integer);
    function MisturarCor(ACor: TColor; AFator: Double): TColor;
    procedure SetAngle(AValue: Integer);
    function GetAngle: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AplicarModoVisual;
    procedure InvalidarSpinner;
    property Angle: Integer read GetAngle write SetAngle;
    property UseGif: Boolean read FUseGif;
  end;

var
  GRefCount: Integer = 0;
  GOverlay: TFormLoadingOverlay = nil;
  GThread: TSpinnerThread = nil;
  GOwnerForm: TCustomForm = nil;

function CaminhoGifLoading: string;
var
  LBase: string;
  LCand: string;
begin
  Result := '';
  LBase := ExtractFilePath(ParamStr(0));
  LCand := LBase + 'Imagens\loading.gif';
  if FileExists(LCand) then
  begin
    Result := LCand;
    Exit;
  end;
  LCand := ExtractFilePath(ParamStr(0)) + '..\Imagens\loading.gif';
  if FileExists(LCand) then
  begin
    Result := ExpandFileName(LCand);
    Exit;
  end;
  LCand := GetCurrentDir + '\Imagens\loading.gif';
  if FileExists(LCand) then
    Result := LCand;
end;

constructor TSpinnerThread.Create(AOverlay: TFormLoadingOverlay);
begin
  FOverlay := AOverlay;
  FAngle := 0;
  inherited Create(False);
  FreeOnTerminate := False;
end;

procedure TSpinnerThread.InvalidateOverlay;
begin
  if (FOverlay <> nil) and not FOverlay.UseGif then
  begin
    FOverlay.Angle := FAngle;
    FOverlay.InvalidarSpinner;
  end;
end;

procedure TSpinnerThread.Execute;
begin
  try
    while not Terminated do
    begin
      FAngle := (FAngle + 8) mod 360;
      try
        Synchronize(InvalidateOverlay);
      except
        Terminate;
        Exit;
      end;
      Sleep(30);
    end;
  except
    Terminate;
  end;
end;

constructor TFormLoadingOverlay.Create(AOwner: TComponent);
begin
  inherited CreateNew(AOwner);
  FAngleLock := TCriticalSection.Create;
  FAngle := 0;
  FUseGif := False;

  BorderStyle := bsNone;
  FormStyle := fsStayOnTop;
  Position := poDesigned;
  Color := clBlack;
  AlphaBlend := True;
  AlphaBlendValue := 180;
  BorderIcons := [];
  DoubleBuffered := True;

  FPaintBox := TPaintBox.Create(Self);
  FPaintBox.Parent := Self;
  FPaintBox.Align := alClient;
  FPaintBox.OnPaint := PaintBoxPaint;

  FImage := TImage.Create(Self);
  FImage.Parent := Self;
  FImage.Transparent := True;
  FImage.Center := True;
  FImage.Proportional := True;
  FImage.Visible := False;
  FImage.SetBounds(0, 0, 64, 64);

  FCaption := TLabel.Create(Self);
  FCaption.Parent := Self;
  FCaption.Caption := 'Carregando...';
  FCaption.Alignment := taCenter;
  FCaption.Font.Color := clWhite;
  FCaption.Font.Size := 10;
  FCaption.Font.Name := 'Segoe UI';
  FCaption.Transparent := True;
  FCaption.AutoSize := True;
end;

destructor TFormLoadingOverlay.Destroy;
begin
  FAngleLock.Free;
  inherited Destroy;
end;

procedure TFormLoadingOverlay.SetAngle(AValue: Integer);
begin
  FAngleLock.Enter;
  try
    FAngle := AValue;
  finally
    FAngleLock.Leave;
  end;
end;

function TFormLoadingOverlay.GetAngle: Integer;
begin
  FAngleLock.Enter;
  try
    Result := FAngle;
  finally
    FAngleLock.Leave;
  end;
end;

function TFormLoadingOverlay.MisturarCor(ACor: TColor; AFator: Double): TColor;
var
  LR, LG, LB: Byte;
begin
  if AFator < 0 then
    AFator := 0;
  if AFator > 1 then
    AFator := 1;
  ACor := ColorToRGB(ACor);
  LR := Round(GetRValue(ACor) * AFator);
  LG := Round(GetGValue(ACor) * AFator);
  LB := Round(GetBValue(ACor) * AFator);
  Result := RGB(LR, LG, LB);
end;

procedure TFormLoadingOverlay.InvalidarSpinner;
begin
  Invalidate;
  if FPaintBox <> nil then
    FPaintBox.Invalidate;
end;

procedure TFormLoadingOverlay.DesenharSpinner(ACanvas: TCanvas; const ACenter: TPoint;
  ARadius: Integer; AAngle: Integer);
const
  SEGMENTS = 12;
  ARC_SWEEP = 18; // graus por segmento
var
  LI: Integer;
  LFator: Double;
  LCor: TColor;
  LStartDeg: Double;
  LEndDeg: Double;
  LPen: HPEN;
  LOld: HGDIOBJ;
  LBrush: LOGBRUSH;
  LX3, LY3, LX4, LY4: Integer;
  LRadMid: Integer;
  LThickness: Integer;
begin
  LThickness := Max(3, ARadius div 6);
  LRadMid := ARadius - (LThickness div 2);
  if LRadMid < 8 then
    LRadMid := 8;

  ACanvas.Brush.Style := bsClear;

  for LI := 0 to SEGMENTS - 1 do
  begin
    // Segmento 0 = mais opaco (ponta do spinner); demais desvanecem.
    LFator := 1.0 - (LI / SEGMENTS);
    if LFator < 0.12 then
      LFator := 0.12;
    LCor := MisturarCor(COR_PRIMARY, LFator);

    // Angulo: 0 = direita; Arc avanca no sentido anti-horario.
    LStartDeg := AAngle - (LI * (360 / SEGMENTS));
    LEndDeg := LStartDeg - ARC_SWEEP;

    LX3 := ACenter.X + Round(LRadMid * Cos(DegToRad(LStartDeg)));
    LY3 := ACenter.Y - Round(LRadMid * Sin(DegToRad(LStartDeg)));
    LX4 := ACenter.X + Round(LRadMid * Cos(DegToRad(LEndDeg)));
    LY4 := ACenter.Y - Round(LRadMid * Sin(DegToRad(LEndDeg)));

    FillChar(LBrush, SizeOf(LBrush), 0);
    LBrush.lbStyle := BS_SOLID;
    LBrush.lbColor := ColorToRGB(LCor);
    LPen := ExtCreatePen(PS_GEOMETRIC or PS_SOLID or PS_ENDCAP_ROUND or PS_JOIN_ROUND,
      LThickness, LBrush, 0, nil);
    if LPen <> 0 then
    begin
      LOld := SelectObject(ACanvas.Handle, LPen);
      try
        Arc(ACanvas.Handle,
          ACenter.X - LRadMid, ACenter.Y - LRadMid,
          ACenter.X + LRadMid, ACenter.Y + LRadMid,
          LX3, LY3, LX4, LY4);
      finally
        SelectObject(ACanvas.Handle, LOld);
        DeleteObject(LPen);
      end;
    end
    else
    begin
      ACanvas.Pen.Color := LCor;
      ACanvas.Pen.Width := LThickness;
      ACanvas.Arc(
        ACenter.X - LRadMid, ACenter.Y - LRadMid,
        ACenter.X + LRadMid, ACenter.Y + LRadMid,
        LX3, LY3, LX4, LY4);
    end;
  end;
end;

procedure TFormLoadingOverlay.PaintBoxPaint(Sender: TObject);
var
  LCenter: TPoint;
  LRadius: Integer;
  LAngle: Integer;
begin
  if FUseGif then
    Exit;

  LCenter.X := FPaintBox.Width div 2;
  LCenter.Y := (FPaintBox.Height div 2) - 10;
  LRadius := Min(48, Min(FPaintBox.Width, FPaintBox.Height) div 5);
  if LRadius < 18 then
    LRadius := 18;

  LAngle := Angle;
  DesenharSpinner(FPaintBox.Canvas, LCenter, LRadius, LAngle);

  // Reposiciona caption sob o spinner
  if FCaption <> nil then
  begin
    FCaption.Left := (ClientWidth - FCaption.Width) div 2;
    FCaption.Top := LCenter.Y + LRadius + 16;
  end;
end;

procedure TFormLoadingOverlay.AplicarModoVisual;
var
  LGifPath: string;
  LGif: TGIFImage;
begin
  LGifPath := CaminhoGifLoading;
  FUseGif := LGifPath <> '';

  if FUseGif then
  begin
    GIFImageDefaultAnimate := True;
    LGif := TGIFImage.Create;
    try
      LGif.LoadFromFile(LGifPath);
      LGif.Animate := True;
      FImage.Picture.Assign(LGif);
    finally
      LGif.Free;
    end;
    FPaintBox.Visible := False;
    FImage.Visible := True;
    FImage.SetBounds((ClientWidth - 64) div 2, (ClientHeight - 64) div 2 - 12, 64, 64);
    FCaption.Left := (ClientWidth - FCaption.Width) div 2;
    FCaption.Top := FImage.Top + FImage.Height + 12;
  end
  else
  begin
    FImage.Visible := False;
    FPaintBox.Visible := True;
  end;
end;

procedure PosicionarSobreOwner(AOverlay: TForm; AOwner: TCustomForm);
var
  LOwner: TCustomForm;
  LP: TPoint;
begin
  LOwner := AOwner;
  if LOwner = nil then
    LOwner := Application.MainForm;
  if LOwner = nil then
  begin
    AOverlay.SetBounds(
      (Screen.Width - 120) div 2,
      (Screen.Height - 120) div 2,
      120, 120);
    Exit;
  end;

  // Cobre a area cliente do owner (Principal / MDI client).
  LP := LOwner.ClientToScreen(Point(0, 0));
  AOverlay.SetBounds(LP.X, LP.Y, LOwner.ClientWidth, LOwner.ClientHeight);
end;

procedure PararThread;
begin
  if GThread <> nil then
  begin
    GThread.Terminate;
    GThread.WaitFor;
    FreeAndNil(GThread);
  end;
end;

procedure LiberarOverlay;
begin
  PararThread;
  if GOverlay <> nil then
  begin
    GOverlay.Hide;
    FreeAndNil(GOverlay);
  end;
  GOwnerForm := nil;
end;

procedure AbortarCarregamento;
begin
  GRefCount := 0;
  LiberarOverlay;
end;

procedure ExecutarComCarregamento(OwnerForm: TCustomForm; const AAction: TProc);
begin
  try
    try
      IniciarCarregamento(OwnerForm);
      if Assigned(AAction) then
        AAction;
    except
      on E: Exception do
      begin
        AbortarCarregamento;
        ShowMessage('Erro durante o carregamento:' + sLineBreak + sLineBreak +
          E.Message);
        Application.Terminate;
      end;
    end;
  finally
    FinalizarCarregamento;
  end;
end;

procedure IniciarCarregamento(OwnerForm: TCustomForm);
begin
  Inc(GRefCount);
  if GRefCount > 1 then
  begin
    if (GOverlay <> nil) and GOverlay.Visible then
    begin
      PosicionarSobreOwner(GOverlay, OwnerForm);
      GOverlay.BringToFront;
      Application.ProcessMessages;
    end;
    Exit;
  end;

  GOwnerForm := OwnerForm;
  if GOwnerForm = nil then
    GOwnerForm := Application.MainForm;

  if GOverlay = nil then
    GOverlay := TFormLoadingOverlay.Create(nil);

  PosicionarSobreOwner(GOverlay, GOwnerForm);
  GOverlay.AplicarModoVisual;
  GOverlay.Show;
  GOverlay.BringToFront;

  if (not GOverlay.UseGif) and (GThread = nil) then
    GThread := TSpinnerThread.Create(GOverlay);

  Application.ProcessMessages;
end;

procedure FinalizarCarregamento;
begin
  if GRefCount <= 0 then
  begin
    GRefCount := 0;
    Exit;
  end;

  Dec(GRefCount);
  if GRefCount > 0 then
    Exit;

  LiberarOverlay;
end;

function CarregamentoAtivo: Boolean;
begin
  Result := GRefCount > 0;
end;

initialization

finalization
  GRefCount := 0;
  LiberarOverlay;

end.
