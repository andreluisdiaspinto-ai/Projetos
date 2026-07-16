unit ScenarioPlayer;

(* Player de scenario JSON gerado a partir do Interaction Recorder.
   Ativacao: Projeto_Avaliacao.exe -observe -replay <arquivo.scenario.json>
   Resultado: <Logs>\ultimo-replay-result.json
   Ops: Action, WaitForm, Fill, AssertMessage, CloseForm *)

interface

uses
  System.SysUtils, System.Classes;

function ReplayScenarioFile: string;
function ReplayModeActive: Boolean;
function ObserveLogsDirectory: string;

procedure ScheduleReplayAfterLogin;
procedure WriteReplayResult(Ok: Boolean; StepsDone, FailedStep: Integer;
  const MessageText: string);

implementation

uses
  Winapi.Windows, Winapi.Messages,
  System.JSON, System.IOUtils, System.StrUtils, System.UITypes,
  Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, Vcl.Buttons, Vcl.DBCtrls,
  Vcl.ExtCtrls, Vcl.ActnList, Vcl.Dialogs, Data.DB,
  ObserveJson;

const
  DEFAULT_STEP_DELAY_MS = 200;
  DEFAULT_WAIT_FORM_MS = 10000;
  DEFAULT_ASSERT_MSG_MS = 10000;

type
  TReplayHost = class(TComponent)
  private
    FScenarioFile: string;
    FDismissTimer: TTimer;
    FStartTimer: TTimer;
    FLastDialogText: string;
    FAutoDismiss: Boolean;
    FExpectContains: string;
    FExpectMatched: Boolean;
    procedure DismissTimerTick(Sender: TObject);
    procedure StartTimerTick(Sender: TObject);
    function RunScenario(const AFile: string): Integer;
    function FindFormByClass(const AClassName: string): TCustomForm;
    function FindActionOnForm(AForm: TCustomForm; const AName: string): TAction;
    function FindControlOnForm(AForm: TCustomForm; const AName: string): TControl;
    function WaitForForm(const AClassName: string; TimeoutMs: Integer): TCustomForm;
    function DoAction(const AFormName, AActionName, AControlName: string): string;
    function DoFill(const AFormName, AControlName, AValue: string): string;
    function DoAssertMessage(const AContains: string; TimeoutMs: Integer): string;
    function DoCloseForm(const AFormName: string): string;
    procedure TryDismissDialogs;
    procedure TryDismissWin32MessageBox;
    function ExtractDialogText(AForm: TCustomForm): string;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Start(const AFile: string);
  end;

var
  GReplayHost: TReplayHost = nil;

function ReplayScenarioFile: string;
var
  I: Integer;
  Arg: string;
begin
  Result := '';
  for I := 1 to ParamCount do
  begin
    Arg := Trim(ParamStr(I));
    if SameText(Arg, '-replay') or SameText(Arg, '/replay') then
    begin
      if I < ParamCount then
        Result := Trim(ParamStr(I + 1));
      Exit;
    end;
    if StartsText('-replay:', Arg) or StartsText('/replay:', Arg) then
    begin
      Result := Trim(Copy(Arg, Pos(':', Arg) + 1, MaxInt));
      Exit;
    end;
  end;
end;

function ReplayModeActive: Boolean;
begin
  Result := ReplayScenarioFile <> '';
end;

function ObserveLogsDirectory: string;
var
  AppDir, LogsDir, TempDir: string;
begin
  AppDir := ExtractFilePath(ParamStr(0));
  if AppDir = '' then
    AppDir := GetCurrentDir;
  LogsDir := TPath.Combine(AppDir, 'Logs');
  if ForceDirectories(LogsDir) and DirectoryExists(LogsDir) then
  begin
    Result := LogsDir;
    Exit;
  end;
  TempDir := TPath.Combine(TPath.GetTempPath, 'Projeto_Avaliacao');
  ForceDirectories(TempDir);
  Result := TempDir;
end;

procedure WriteReplayResult(Ok: Boolean; StepsDone, FailedStep: Integer;
  const MessageText: string);
var
  Path: string;
  SW: TStreamWriter;
  Line: string;
begin
  Path := TPath.Combine(ObserveLogsDirectory, 'ultimo-replay-result.json');
  Line := JsonObject([
    JsonPairBool('ok', Ok),
    JsonPairInt('steps', StepsDone),
    JsonPairInt('failedStep', FailedStep),
    JsonPairStr('message', MessageText),
    JsonPairInt('exitCode', Ord(not Ok))
  ]);
  try
    SW := TStreamWriter.Create(Path, False, TEncoding.UTF8);
    try
      SW.WriteLine(Line);
    finally
      SW.Free;
    end;
  except
    // Ignora falha de I/O
  end;
end;

procedure ScheduleReplayAfterLogin;
var
  Scenario: string;
begin
  Scenario := ReplayScenarioFile;
  if Scenario = '' then
    Exit;
  if not FileExists(Scenario) then
  begin
    WriteReplayResult(False, 0, 0, 'Arquivo de scenario nao encontrado: ' + Scenario);
    Application.Terminate;
    Exit;
  end;
  if GReplayHost = nil then
    GReplayHost := TReplayHost.Create(Application);
  GReplayHost.Start(Scenario);
end;

constructor TReplayHost.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDismissTimer := TTimer.Create(Self);
  FDismissTimer.Interval := 120;
  FDismissTimer.Enabled := False;
  FDismissTimer.OnTimer := DismissTimerTick;
  FStartTimer := TTimer.Create(Self);
  FStartTimer.Interval := 500;
  FStartTimer.Enabled := False;
  FStartTimer.OnTimer := StartTimerTick;
  FAutoDismiss := False;
  FExpectMatched := False;
end;

destructor TReplayHost.Destroy;
begin
  FDismissTimer.Enabled := False;
  FStartTimer.Enabled := False;
  inherited Destroy;
end;

procedure TReplayHost.Start(const AFile: string);
begin
  FScenarioFile := AFile;
  FStartTimer.Enabled := True;
end;

procedure TReplayHost.StartTimerTick(Sender: TObject);
var
  Code: Integer;
begin
  FStartTimer.Enabled := False;
  Application.ProcessMessages;
  Code := RunScenario(FScenarioFile);
  if Code = 0 then
    Halt(0)
  else
    Halt(1);
end;

procedure TReplayHost.DismissTimerTick(Sender: TObject);
begin
  if FAutoDismiss then
    TryDismissDialogs;
end;

function TReplayHost.ExtractDialogText(AForm: TCustomForm): string;
var
  I: Integer;
  C: TComponent;
  Buf: array[0..1023] of Char;
  WC: TWinControl;
begin
  Result := AForm.Caption;
  WC := AForm;
  FillChar(Buf, SizeOf(Buf), 0);
  if WC.HandleAllocated and (GetWindowText(WC.Handle, Buf, Length(Buf) - 1) > 0) then
    Result := Result + ' ' + Buf;
  for I := 0 to AForm.ComponentCount - 1 do
  begin
    C := AForm.Components[I];
    if C is TLabel then
      Result := Result + ' ' + TLabel(C).Caption
    else if C is TStaticText then
      Result := Result + ' ' + TStaticText(C).Caption
    else if C is TWinControl then
    begin
      WC := TWinControl(C);
      if WC.HandleAllocated then
      begin
        FillChar(Buf, SizeOf(Buf), 0);
        if GetWindowText(WC.Handle, Buf, Length(Buf) - 1) > 0 then
          Result := Result + ' ' + Buf;
      end;
    end;
  end;
  Result := Trim(Result);
end;

procedure TReplayHost.TryDismissWin32MessageBox;
var
  H, Btn, NextH: HWND;
  Buf: array[0..1023] of Char;
  Pid: DWORD;
  MyPid: DWORD;
begin
  MyPid := GetCurrentProcessId;
  H := FindWindowEx(0, 0, '#32770', nil);
  while H <> 0 do
  begin
    NextH := FindWindowEx(0, H, '#32770', nil);
    Pid := 0;
    GetWindowThreadProcessId(H, @Pid);
    if Pid = MyPid then
    begin
      FillChar(Buf, SizeOf(Buf), 0);
      GetWindowText(H, Buf, Length(Buf) - 1);
      FLastDialogText := Trim(Buf);
      FillChar(Buf, SizeOf(Buf), 0);
      if GetDlgItemText(H, 65535, Buf, Length(Buf) - 1) > 0 then
        FLastDialogText := Trim(FLastDialogText + ' ' + Buf)
      else if GetDlgItemText(H, 100, Buf, Length(Buf) - 1) > 0 then
        FLastDialogText := Trim(FLastDialogText + ' ' + Buf);
      if (FExpectContains <> '') and ContainsText(FLastDialogText, FExpectContains) then
        FExpectMatched := True;
      Btn := GetDlgItem(H, IDOK);
      if Btn = 0 then
        Btn := GetDlgItem(H, IDYES);
      if Btn <> 0 then
        PostMessage(Btn, BM_CLICK, 0, 0)
      else
        PostMessage(H, WM_CLOSE, 0, 0);
      Exit;
    end;
    H := NextH;
  end;
end;

procedure TReplayHost.TryDismissDialogs;
var
  I: Integer;
  F: TCustomForm;
  J: Integer;
  C: TComponent;
  Btn: TButton;
  Txt: string;
begin
  TryDismissWin32MessageBox;

  for I := 0 to Screen.FormCount - 1 do
  begin
    F := Screen.Forms[I];
    if not F.Visible then
      Continue;
    if F = Application.MainForm then
      Continue;
    // Dialogos CreateMessageDialog / ShowMessage
    if not (SameText(F.ClassName, 'TMessageForm') or (F.BorderStyle = bsDialog)) then
      Continue;
    if F = Application.MainForm then
      Continue;

    Txt := ExtractDialogText(F);
    FLastDialogText := Trim(Txt);
    if (FExpectContains <> '') and ContainsText(FLastDialogText, FExpectContains) then
      FExpectMatched := True;

    for J := 0 to F.ComponentCount - 1 do
    begin
      C := F.Components[J];
      if C is TButton then
      begin
        Btn := TButton(C);
        if (Btn.ModalResult = mrOk) or (Btn.ModalResult = mrYes) or
           SameText(Btn.Caption, 'OK') or SameText(Btn.Caption, '&OK') then
        begin
          Btn.Click;
          Exit;
        end;
      end;
    end;
  end;
end;

function TReplayHost.FindFormByClass(const AClassName: string): TCustomForm;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to Screen.FormCount - 1 do
    if SameText(Screen.Forms[I].ClassName, AClassName) then
    begin
      Result := Screen.Forms[I];
      Exit;
    end;
end;

function TReplayHost.FindActionOnForm(AForm: TCustomForm; const AName: string): TAction;
var
  Comp: TComponent;
  I, J: Integer;
  AL: TActionList;
begin
  Result := nil;
  if AForm = nil then
    Exit;
  Comp := AForm.FindComponent(AName);
  if Comp is TAction then
  begin
    Result := TAction(Comp);
    Exit;
  end;
  for I := 0 to AForm.ComponentCount - 1 do
    if AForm.Components[I] is TActionList then
    begin
      AL := TActionList(AForm.Components[I]);
      for J := 0 to AL.ActionCount - 1 do
        if SameText(AL.Actions[J].Name, AName) and (AL.Actions[J] is TAction) then
        begin
          Result := TAction(AL.Actions[J]);
          Exit;
        end;
    end;
end;

function TReplayHost.FindControlOnForm(AForm: TCustomForm; const AName: string): TControl;
var
  Comp: TComponent;
begin
  Result := nil;
  if AForm = nil then
    Exit;
  Comp := AForm.FindComponent(AName);
  if Comp is TControl then
    Result := TControl(Comp);
end;

function TReplayHost.WaitForForm(const AClassName: string; TimeoutMs: Integer): TCustomForm;
var
  Elapsed: Integer;
begin
  Elapsed := 0;
  Result := FindFormByClass(AClassName);
  while (Result = nil) and (Elapsed < TimeoutMs) do
  begin
    Application.ProcessMessages;
    Sleep(50);
    Inc(Elapsed, 50);
    Result := FindFormByClass(AClassName);
  end;
end;

function TReplayHost.DoAction(const AFormName, AActionName, AControlName: string): string;
var
  Form: TCustomForm;
  Act: TAction;
  Ctrl: TControl;
begin
  Result := '';
  Form := FindFormByClass(AFormName);
  if Form = nil then
  begin
    Result := 'Form nao encontrado: ' + AFormName;
    Exit;
  end;
  if AActionName <> '' then
  begin
    Act := FindActionOnForm(Form, AActionName);
    if Act = nil then
    begin
      Result := 'Action nao encontrada: ' + AActionName;
      Exit;
    end;
    if not Act.Enabled then
    begin
      Result := 'Action desabilitada: ' + AActionName;
      Exit;
    end;
    FAutoDismiss := True;
    FDismissTimer.Enabled := True;
    try
      Act.Execute;
    finally
      Sleep(150);
      FAutoDismiss := False;
      FDismissTimer.Enabled := False;
    end;
    Exit;
  end;
  if AControlName <> '' then
  begin
    Ctrl := FindControlOnForm(Form, AControlName);
    if Ctrl = nil then
    begin
      Result := 'Controle nao encontrado: ' + AControlName;
      Exit;
    end;
    if Ctrl is TButton then
      TButton(Ctrl).Click
    else if Ctrl is TBitBtn then
      TBitBtn(Ctrl).Click
    else
      Result := 'Controle nao clicavel: ' + AControlName;
  end;
end;

function TReplayHost.DoFill(const AFormName, AControlName, AValue: string): string;
var
  Form: TCustomForm;
  Ctrl: TControl;
  Edit: TCustomEdit;
begin
  Result := '';
  Form := FindFormByClass(AFormName);
  if Form = nil then
  begin
    Result := 'Form nao encontrado: ' + AFormName;
    Exit;
  end;
  Ctrl := FindControlOnForm(Form, AControlName);
  if Ctrl = nil then
  begin
    Result := 'Controle nao encontrado: ' + AControlName;
    Exit;
  end;
  if not (Ctrl is TCustomEdit) then
  begin
    Result := 'Controle nao e editavel: ' + AControlName;
    Exit;
  end;
  Edit := TCustomEdit(Ctrl);
  if Edit.CanFocus then
    Edit.SetFocus;
  Application.ProcessMessages;
  if Ctrl is TDBEdit then
  begin
    if Assigned(TDBEdit(Ctrl).Field) and Assigned(TDBEdit(Ctrl).DataSource) and
       Assigned(TDBEdit(Ctrl).DataSource.DataSet) then
    begin
      if not (TDBEdit(Ctrl).DataSource.DataSet.State in [dsInsert, dsEdit]) then
      begin
        Result := 'Dataset nao esta em Insert/Edit para ' + AControlName;
        Exit;
      end;
      TDBEdit(Ctrl).Field.AsString := AValue;
    end
    else
      TDBEdit(Ctrl).Text := AValue;
  end
  else if Ctrl is TDBMemo then
  begin
    if Assigned(TDBMemo(Ctrl).Field) then
      TDBMemo(Ctrl).Field.AsString := AValue
    else
      TDBMemo(Ctrl).Text := AValue;
  end
  else
    Edit.Text := AValue;

  // Dispara validacao OnExit sem acessar o evento protegido.
  if Edit.HandleAllocated then
    Edit.Perform(CM_EXIT, 0, 0);
  Application.ProcessMessages;
end;

function TReplayHost.DoAssertMessage(const AContains: string; TimeoutMs: Integer): string;
var
  Elapsed: Integer;
begin
  Result := '';
  FExpectContains := AContains;
  FExpectMatched := False;
  FAutoDismiss := True;
  FDismissTimer.Enabled := True;
  Elapsed := 0;
  try
    while Elapsed < TimeoutMs do
    begin
      TryDismissDialogs;
      if FExpectMatched or
         ((AContains <> '') and ContainsText(FLastDialogText, AContains)) then
      begin
        FExpectMatched := True;
        Exit;
      end;
      Application.ProcessMessages;
      Sleep(50);
      Inc(Elapsed, 50);
    end;
    if not FExpectMatched then
      Result := 'AssertMessage falhou. Esperado conter: "' + AContains +
        '". Ultimo dialogo: "' + FLastDialogText + '"';
  finally
    FAutoDismiss := False;
    FDismissTimer.Enabled := False;
    FExpectContains := '';
  end;
end;

function TReplayHost.DoCloseForm(const AFormName: string): string;
var
  Form: TCustomForm;
begin
  Result := '';
  Form := FindFormByClass(AFormName);
  if Form = nil then
    Exit;
  Form.Close;
  Application.ProcessMessages;
end;

function TReplayHost.RunScenario(const AFile: string): Integer;
var
  Root, StepsArr, StepObj: TJSONValue;
  Arr: TJSONArray;
  Obj, Step: TJSONObject;
  I: Integer;
  Op, FormName, ActionName, ControlName, Value, ContainsTextVal, Err: string;
  TimeoutMs: Integer;
  V: TJSONValue;
begin
  Result := 1;
  Root := TJSONObject.ParseJSONValue(TFile.ReadAllText(AFile, TEncoding.UTF8));
  if Root = nil then
  begin
    WriteReplayResult(False, 0, 0, 'JSON de scenario invalido');
    Exit;
  end;
  try
    if not (Root is TJSONObject) then
    begin
      WriteReplayResult(False, 0, 0, 'Raiz do scenario deve ser objeto');
      Exit;
    end;
    Obj := TJSONObject(Root);
    StepsArr := Obj.Values['steps'];
    if not (StepsArr is TJSONArray) then
    begin
      WriteReplayResult(False, 0, 0, 'Campo steps ausente');
      Exit;
    end;
    Arr := TJSONArray(StepsArr);

    for I := 0 to Arr.Count - 1 do
    begin
      StepObj := Arr.Items[I];
      if not (StepObj is TJSONObject) then
      begin
        WriteReplayResult(False, I, I, 'Step invalido no indice ' + IntToStr(I));
        Exit;
      end;
      Step := TJSONObject(StepObj);
      Op := '';
      FormName := '';
      ActionName := '';
      ControlName := '';
      Value := '';
      ContainsTextVal := '';
      TimeoutMs := DEFAULT_WAIT_FORM_MS;

      V := Step.Values['op'];
      if V <> nil then
        Op := V.Value;
      V := Step.Values['form'];
      if V <> nil then
        FormName := V.Value;
      V := Step.Values['action'];
      if V <> nil then
        ActionName := V.Value;
      V := Step.Values['control'];
      if V <> nil then
        ControlName := V.Value;
      V := Step.Values['value'];
      if V <> nil then
        Value := V.Value;
      V := Step.Values['contains'];
      if V <> nil then
        ContainsTextVal := V.Value;
      V := Step.Values['timeoutMs'];
      if V <> nil then
        TimeoutMs := StrToIntDef(V.Value, TimeoutMs);

      Err := '';
      if SameText(Op, 'Action') then
        Err := DoAction(FormName, ActionName, ControlName)
      else if SameText(Op, 'WaitForm') then
      begin
        if WaitForForm(FormName, TimeoutMs) = nil then
          Err := 'Timeout aguardando form: ' + FormName;
      end
      else if SameText(Op, 'Fill') then
        Err := DoFill(FormName, ControlName, Value)
      else if SameText(Op, 'AssertMessage') then
      begin
        if TimeoutMs = DEFAULT_WAIT_FORM_MS then
          TimeoutMs := DEFAULT_ASSERT_MSG_MS;
        // Se a mensagem ja foi auto-dismissed no Action anterior, valida buffer.
        if (ContainsTextVal <> '') and ContainsText(FLastDialogText, ContainsTextVal) then
          Err := ''
        else
          Err := DoAssertMessage(ContainsTextVal, TimeoutMs);
      end
      else if SameText(Op, 'CloseForm') then
        Err := DoCloseForm(FormName)
      else
        Err := 'Operacao desconhecida: ' + Op;

      if Err <> '' then
      begin
        WriteReplayResult(False, I, I, Err);
        Exit;
      end;

      Application.ProcessMessages;
      Sleep(DEFAULT_STEP_DELAY_MS);
    end;

    WriteReplayResult(True, Arr.Count, -1, '');
    Result := 0;
  finally
    Root.Free;
  end;
end;

initialization

finalization
  // Host e owned por Application quando criado.

end.
