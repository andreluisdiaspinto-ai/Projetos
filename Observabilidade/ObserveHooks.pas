unit ObserveHooks;

{ Hooks globais e helpers de instrumentacao do Interaction Recorder.
  Instala Screen.OnActiveFormChange e Application.OnException.
  Helpers: LogAction, LogClick, LogFill, LogMessage, EmitSnapshot, etc. }

interface

uses
  System.SysUtils, System.Classes, System.UITypes,
  Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, Vcl.Buttons, Vcl.DBCtrls, Data.DB;

procedure ObserveInstall;
procedure ObserveUninstall;

function ObserveFormName(AForm: TCustomForm): string;
function ObserveControlId(AControl: TComponent): string;
function ObserveDsStateName(AState: TDataSetState): string;

procedure ObserveLogAction(AForm: TCustomForm; const ActionName, ControlName: string);
procedure ObserveLogClick(AForm: TCustomForm; const ControlName: string);
procedure ObserveLogFill(AForm: TCustomForm; const ControlName, OldValue, NewValue: string);
procedure ObserveLogMessage(const Msg, Kind: string; ModalResult: Integer = 0);
procedure ObserveLogShowMessage(const Msg: string);
procedure ObserveLogOpenForm(AForm: TCustomForm);
procedure ObserveLogCloseForm(AForm: TCustomForm);
procedure ObserveLogPost(AForm: TCustomForm; const Entity: string);
procedure ObserveLogApplyUpdates(AForm: TCustomForm; const Entity: string);
procedure ObserveLogCommit(AForm: TCustomForm; const Entity: string);
procedure ObserveLogRollback(AForm: TCustomForm; const Entity, ErrMsg: string);
procedure ObserveLogDelete(AForm: TCustomForm; const Entity: string);
procedure ObserveLogException(const Msg, Op, FormName: string);
procedure ObserveLogModalOpen(AForm: TCustomForm);
procedure ObserveLogModalResult(AForm: TCustomForm; ModalResult: Integer;
  const ExtraPairs: array of string);
procedure ObserveEmitSnapshot(AForm: TCustomForm; ADataSet: TDataSet);

implementation

uses
  Winapi.Windows, Vcl.Dialogs, InteractionLogger, ObserveJson;

type
  TObserveHookTarget = class
  private
    FOldActiveFormChange: TNotifyEvent;
    FOldException: TExceptionEvent;
    FLastActiveForm: TCustomForm;
  public
    procedure HandleActiveFormChange(Sender: TObject);
    procedure HandleException(Sender: TObject; E: Exception);
  end;

var
  GInstalled: Boolean = False;
  GHookTarget: TObserveHookTarget = nil;

function ObserveFormName(AForm: TCustomForm): string;
begin
  if AForm = nil then
    Result := ''
  else
    Result := AForm.ClassName;
end;

function ObserveControlId(AControl: TComponent): string;
var
  OwnerForm: TComponent;
begin
  if AControl = nil then
  begin
    Result := '';
    Exit;
  end;
  OwnerForm := AControl.Owner;
  while (OwnerForm <> nil) and not (OwnerForm is TCustomForm) do
    OwnerForm := OwnerForm.Owner;
  if OwnerForm is TCustomForm then
    Result := TCustomForm(OwnerForm).ClassName + '.' + AControl.Name
  else
    Result := AControl.Name;
end;

function ObserveDsStateName(AState: TDataSetState): string;
begin
  case AState of
    dsInactive: Result := 'dsInactive';
    dsBrowse:   Result := 'dsBrowse';
    dsEdit:     Result := 'dsEdit';
    dsInsert:   Result := 'dsInsert';
    dsSetKey:   Result := 'dsSetKey';
  else
    Result := 'dsOther';
  end;
end;

procedure ObserveLogAction(AForm: TCustomForm; const ActionName, ControlName: string);
begin
  if not InteractionLog.IsActive then
    Exit;
  InteractionLog.Emit('UI.Action', [
    JsonPairStr('form', ObserveFormName(AForm)),
    JsonPairStr('action', ActionName),
    JsonPairStr('control', ControlName)
  ]);
end;

procedure ObserveLogClick(AForm: TCustomForm; const ControlName: string);
begin
  if not InteractionLog.IsActive then
    Exit;
  InteractionLog.Emit('UI.Click', [
    JsonPairStr('form', ObserveFormName(AForm)),
    JsonPairStr('control', ControlName)
  ]);
end;

procedure ObserveLogFill(AForm: TCustomForm; const ControlName, OldValue, NewValue: string);
begin
  if not InteractionLog.IsActive then
    Exit;
  if OldValue = NewValue then
    Exit;
  InteractionLog.Emit('UI.Fill', [
    JsonPairStr('form', ObserveFormName(AForm)),
    JsonPairStr('control', ControlName),
    JsonPairStr('old', OldValue),
    JsonPairStr('new', NewValue)
  ]);
end;

procedure ObserveLogMessage(const Msg, Kind: string; ModalResult: Integer);
begin
  if not InteractionLog.IsActive then
    Exit;
  InteractionLog.Emit('UI.Message', [
    JsonPairStr('text', Msg),
    JsonPairStr('kind', Kind),
    JsonPairInt('modalResult', ModalResult)
  ]);
end;

procedure ObserveLogShowMessage(const Msg: string);
begin
  ObserveLogMessage(Msg, 'info', 0);
end;

procedure ObserveLogOpenForm(AForm: TCustomForm);
begin
  if not InteractionLog.IsActive then
    Exit;
  InteractionLog.Emit('UI.OpenForm', [
    JsonPairStr('form', ObserveFormName(AForm))
  ]);
end;

procedure ObserveLogCloseForm(AForm: TCustomForm);
begin
  if not InteractionLog.IsActive then
    Exit;
  InteractionLog.Emit('UI.CloseForm', [
    JsonPairStr('form', ObserveFormName(AForm))
  ]);
end;

procedure ObserveLogPost(AForm: TCustomForm; const Entity: string);
begin
  if not InteractionLog.IsActive then
    Exit;
  InteractionLog.Emit('UI.Post', [
    JsonPairStr('form', ObserveFormName(AForm)),
    JsonPairStr('entity', Entity)
  ]);
end;

procedure ObserveLogApplyUpdates(AForm: TCustomForm; const Entity: string);
begin
  if not InteractionLog.IsActive then
    Exit;
  InteractionLog.Emit('UI.ApplyUpdates', [
    JsonPairStr('form', ObserveFormName(AForm)),
    JsonPairStr('entity', Entity)
  ]);
end;

procedure ObserveLogCommit(AForm: TCustomForm; const Entity: string);
begin
  if not InteractionLog.IsActive then
    Exit;
  InteractionLog.Emit('UI.Commit', [
    JsonPairStr('form', ObserveFormName(AForm)),
    JsonPairStr('entity', Entity)
  ]);
end;

procedure ObserveLogRollback(AForm: TCustomForm; const Entity, ErrMsg: string);
begin
  if not InteractionLog.IsActive then
    Exit;
  InteractionLog.Emit('UI.Rollback', [
    JsonPairStr('form', ObserveFormName(AForm)),
    JsonPairStr('entity', Entity),
    JsonPairStr('message', ErrMsg)
  ]);
end;

procedure ObserveLogDelete(AForm: TCustomForm; const Entity: string);
begin
  if not InteractionLog.IsActive then
    Exit;
  InteractionLog.Emit('UI.Delete', [
    JsonPairStr('form', ObserveFormName(AForm)),
    JsonPairStr('entity', Entity)
  ]);
end;

procedure ObserveLogException(const Msg, Op, FormName: string);
begin
  if not InteractionLog.IsActive then
    Exit;
  InteractionLog.Emit('UI.Exception', [
    JsonPairStr('message', Msg),
    JsonPairStr('op', Op),
    JsonPairStr('form', FormName)
  ]);
end;

procedure ObserveLogModalOpen(AForm: TCustomForm);
begin
  if not InteractionLog.IsActive then
    Exit;
  InteractionLog.Emit('UI.ModalOpen', [
    JsonPairStr('form', ObserveFormName(AForm))
  ]);
end;

procedure ObserveLogModalResult(AForm: TCustomForm; ModalResult: Integer;
  const ExtraPairs: array of string);
var
  Base: TArray<string>;
  All: TArray<string>;
  I, N: Integer;
begin
  if not InteractionLog.IsActive then
    Exit;
  SetLength(Base, 2);
  Base[0] := JsonPairStr('form', ObserveFormName(AForm));
  Base[1] := JsonPairInt('modalResult', ModalResult);
  SetLength(All, Length(Base) + Length(ExtraPairs));
  for I := 0 to High(Base) do
    All[I] := Base[I];
  N := Length(Base);
  for I := 0 to High(ExtraPairs) do
  begin
    if ExtraPairs[I] <> '' then
    begin
      All[N] := ExtraPairs[I];
      Inc(N);
    end;
  end;
  SetLength(All, N);
  InteractionLog.Emit('UI.ModalResult', All);
end;

function ControlValueText(AControl: TControl): string;
begin
  Result := '';
  if AControl is TDBEdit then
    Result := TDBEdit(AControl).Text
  else if AControl is TDBMemo then
    Result := TDBMemo(AControl).Text
  else if AControl is TCustomEdit then
    Result := TCustomEdit(AControl).Text;
end;

function IsDataControl(AComp: TComponent): Boolean;
begin
  Result := (AComp is TDBEdit) or (AComp is TDBMemo) or
    (AComp is TBitBtn) or (AComp is TButton);
end;

procedure ObserveEmitSnapshot(AForm: TCustomForm; ADataSet: TDataSet);
var
  I: Integer;
  Comp: TComponent;
  Ctrl: TControl;
  Items: TStringList;
  ItemJson, ControlsJson, DsState: string;
  Val: string;
begin
  if not InteractionLog.IsActive then
    Exit;
  if AForm = nil then
    Exit;

  Items := TStringList.Create;
  try
    for I := 0 to AForm.ComponentCount - 1 do
    begin
      Comp := AForm.Components[I];
      if not (Comp is TControl) then
        Continue;
      if Comp.Name = '' then
        Continue;
      if not IsDataControl(Comp) then
        Continue;

      Ctrl := TControl(Comp);
      Val := ControlValueText(Ctrl);
      // Nunca expor senha
      if SameText(Comp.Name, 'EditSenha') then
        Val := '***';

      ItemJson := JsonObject([
        JsonPairStr('id', Comp.Name),
        JsonPairStr('value', Val),
        JsonPairBool('enabled', Ctrl.Enabled)
      ]);
      Items.Add(ItemJson);
    end;

    ControlsJson := '[';
    for I := 0 to Items.Count - 1 do
    begin
      if I > 0 then
        ControlsJson := ControlsJson + ',';
      ControlsJson := ControlsJson + Items[I];
    end;
    ControlsJson := ControlsJson + ']';

    if ADataSet <> nil then
      DsState := ObserveDsStateName(ADataSet.State)
    else
      DsState := '';

    InteractionLog.Emit('UI.Snapshot', [
      JsonPairStr('form', ObserveFormName(AForm)),
      JsonPairStr('dsState', DsState),
      JsonPairRaw('controls', ControlsJson)
    ]);
  finally
    Items.Free;
  end;
end;

procedure TObserveHookTarget.HandleActiveFormChange(Sender: TObject);
var
  F: TCustomForm;
begin
  if Assigned(FOldActiveFormChange) then
    FOldActiveFormChange(Sender);

  if not InteractionLog.IsActive then
    Exit;

  F := Screen.ActiveCustomForm;
  if F = FLastActiveForm then
    Exit;
  FLastActiveForm := F;
  if F = nil then
    Exit;

  InteractionLog.Emit('UI.ActivateForm', [
    JsonPairStr('form', ObserveFormName(F))
  ]);
end;

procedure TObserveHookTarget.HandleException(Sender: TObject; E: Exception);
var
  FormName: string;
begin
  if InteractionLog.IsActive then
  begin
    if Screen.ActiveCustomForm <> nil then
      FormName := Screen.ActiveCustomForm.ClassName
    else
      FormName := '';
    ObserveLogException(E.Message, 'Application.OnException', FormName);
  end;

  if Assigned(FOldException) then
    FOldException(Sender, E)
  else
    Application.ShowException(E);
end;

procedure ObserveInstall;
begin
  if GInstalled then
    Exit;
  if GHookTarget = nil then
    GHookTarget := TObserveHookTarget.Create;
  GHookTarget.FOldActiveFormChange := Screen.OnActiveFormChange;
  Screen.OnActiveFormChange := GHookTarget.HandleActiveFormChange;
  GHookTarget.FOldException := Application.OnException;
  Application.OnException := GHookTarget.HandleException;
  GInstalled := True;
end;

procedure ObserveUninstall;
begin
  if not GInstalled then
    Exit;
  if GHookTarget <> nil then
  begin
    Screen.OnActiveFormChange := GHookTarget.FOldActiveFormChange;
    Application.OnException := GHookTarget.FOldException;
    GHookTarget.FOldActiveFormChange := nil;
    GHookTarget.FOldException := nil;
    GHookTarget.FLastActiveForm := nil;
  end;
  GInstalled := False;
end;

initialization

finalization
  ObserveUninstall;
  FreeAndNil(GHookTarget);

end.
