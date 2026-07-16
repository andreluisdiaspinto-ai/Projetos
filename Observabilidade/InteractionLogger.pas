unit InteractionLogger;

(* Interaction Recorder MVP
   -----------------------
   Ativacao:
     1) Parametro: Projeto_Avaliacao.exe -observe
     2) Ou variavel de ambiente: PROJETO_OBSERVE=1

   Saida (pasta Logs ao lado do .exe; fallback em %TEMP%):
     <pasta_do_exe>\Logs\observe-yyyyMMdd-HHmmss-session8.jsonl
     <pasta_do_exe>\Logs\ultimo-observe.txt  (caminho do ultimo log)

   Tipos de evento (campo "type"):
     UI.SessionStart, UI.SessionEnd,
     UI.OpenForm, UI.CloseForm, UI.ActivateForm,
     UI.Action, UI.Click, UI.Fill,
     UI.Message, UI.Post, UI.ApplyUpdates, UI.Commit, UI.Rollback,
     UI.Delete, UI.Exception, UI.Snapshot,
     UI.ModalOpen, UI.ModalResult

   AutomationID: FormClassName.ControlName
   Sem -observe o logger e no-op (IsActive = False). *)

interface

uses
  System.SysUtils, System.Classes;

type
  TInteractionLogger = class
  private
    FActive: Boolean;
    FSessionId: string;
    FFileName: string;
    FUserName: string;
    FUserLogin: string;
    FStream: TStreamWriter;
    procedure WriteLine(const Line: string);
    function BuildCommonPairs(const EventType: string): TArray<string>;
    function ResolveLogDirectory: string;
    procedure WritePointerFile;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Start;
    procedure Stop;
    function IsActive: Boolean;

    procedure SetUser(const ANome, ALogin: string);
    function SessionId: string;
    function LogFileName: string;

    procedure Emit(const EventType: string; const ExtraPairs: array of string);
    procedure EmitRaw(const EventType, ExtraJsonObjectBody: string);
  end;

function InteractionLog: TInteractionLogger;
function ObserveRequested: Boolean;

implementation

uses
  Winapi.Windows, System.IOUtils, ObserveJson;

var
  GLogger: TInteractionLogger = nil;

function InteractionLog: TInteractionLogger;
begin
  if GLogger = nil then
    GLogger := TInteractionLogger.Create;
  Result := GLogger;
end;

function ObserveRequested: Boolean;
var
  I: Integer;
  Env: string;
  Arg: string;
begin
  Result := FindCmdLineSwitch('observe');
  if Result then
    Exit;

  Env := GetEnvironmentVariable('PROJETO_OBSERVE');
  if SameText(Env, '1') or SameText(Env, 'true') or SameText(Env, 'yes') or
     SameText(Env, 'sim') then
  begin
    Result := True;
    Exit;
  end;

  for I := 1 to ParamCount do
  begin
    Arg := Trim(ParamStr(I));
    if (Arg <> '') and CharInSet(Arg[1], ['-', '/']) then
      Arg := Copy(Arg, 2, MaxInt);
    if SameText(Arg, 'observe') then
    begin
      Result := True;
      Exit;
    end;
  end;
end;

function NewSessionId: string;
var
  G: TGUID;
begin
  CreateGUID(G);
  Result := GUIDToString(G);
  // Remove chaves { }
  if (Length(Result) >= 2) and (Result[1] = '{') then
    Result := Copy(Result, 2, Length(Result) - 2);
end;

function IsoNow: string;
begin
  Result := FormatDateTime('yyyy-mm-dd"T"hh:nn:ss.zzz', Now);
end;

constructor TInteractionLogger.Create;
begin
  inherited Create;
  FActive := False;
  FSessionId := '';
  FFileName := '';
  FUserName := '';
  FUserLogin := '';
  FStream := nil;
end;

destructor TInteractionLogger.Destroy;
begin
  Stop;
  inherited Destroy;
end;

procedure TInteractionLogger.WriteLine(const Line: string);
begin
  if (not FActive) or (FStream = nil) then
    Exit;
  FStream.WriteLine(Line);
  FStream.Flush;
end;

function TInteractionLogger.BuildCommonPairs(const EventType: string): TArray<string>;
var
  N: Integer;
begin
  N := 3;
  if FUserName <> '' then
    Inc(N);
  if FUserLogin <> '' then
    Inc(N);
  SetLength(Result, N);
  Result[0] := JsonPairStr('ts', IsoNow);
  Result[1] := JsonPairStr('type', EventType);
  Result[2] := JsonPairStr('session', FSessionId);
  N := 3;
  if FUserName <> '' then
  begin
    Result[N] := JsonPairStr('user', FUserName);
    Inc(N);
  end;
  if FUserLogin <> '' then
  begin
    Result[N] := JsonPairStr('userLogin', FUserLogin);
  end;
end;

function TInteractionLogger.ResolveLogDirectory: string;
var
  AppDir, LogsDir, TempDir: string;
begin
  // Preferencia: pasta Logs ao lado do executavel (facil de achar).
  AppDir := ExtractFilePath(ParamStr(0));
  if AppDir = '' then
    AppDir := GetCurrentDir;
  LogsDir := TPath.Combine(AppDir, 'Logs');
  if ForceDirectories(LogsDir) and DirectoryExists(LogsDir) then
  begin
    Result := LogsDir;
    Exit;
  end;
  // Fallback para TEMP se a pasta do exe nao for gravavel.
  TempDir := TPath.Combine(TPath.GetTempPath, 'Projeto_Avaliacao');
  ForceDirectories(TempDir);
  Result := TempDir;
end;

procedure TInteractionLogger.WritePointerFile;
var
  PointerPath: string;
  SW: TStreamWriter;
begin
  if FFileName = '' then
    Exit;
  PointerPath := TPath.Combine(ExtractFilePath(FFileName), 'ultimo-observe.txt');
  try
    SW := TStreamWriter.Create(PointerPath, False, TEncoding.UTF8);
    try
      SW.WriteLine(FFileName);
    finally
      SW.Free;
    end;
  except
    // Ignora falha ao gravar ponteiro
  end;
end;

procedure TInteractionLogger.Start;
var
  Dir, ShortId, Stamp: string;
  CompName: array[0..MAX_COMPUTERNAME_LENGTH] of Char;
  CompSize: DWORD;
  Computer: string;
begin
  if FActive then
    Exit;

  FSessionId := NewSessionId;
  ShortId := Copy(StringReplace(FSessionId, '-', '', [rfReplaceAll]), 1, 8);
  Stamp := FormatDateTime('yyyymmdd-hhnnss', Now);

  Dir := ResolveLogDirectory;
  FFileName := TPath.Combine(Dir, Format('observe-%s-%s.jsonl', [Stamp, ShortId]));

  FStream := TStreamWriter.Create(FFileName, False, TEncoding.UTF8);
  FActive := True;
  WritePointerFile;

  CompSize := MAX_COMPUTERNAME_LENGTH + 1;
  if GetComputerName(CompName, CompSize) then
    Computer := CompName
  else
    Computer := '';

  Emit('UI.SessionStart', [
    JsonPairStr('logFile', FFileName),
    JsonPairStr('computer', Computer),
    JsonPairStr('platform',
      {$IFDEF WIN64}'Win64'{$ELSE}'Win32'{$ENDIF}),
    JsonPairInt('screenWidth', GetSystemMetrics(SM_CXSCREEN)),
    JsonPairInt('screenHeight', GetSystemMetrics(SM_CYSCREEN))
  ]);
end;

procedure TInteractionLogger.Stop;
begin
  if not FActive then
    Exit;
  try
    Emit('UI.SessionEnd', []);
  except
    // Ignora falha ao encerrar
  end;
  FActive := False;
  if FStream <> nil then
  begin
    FStream.Free;
    FStream := nil;
  end;
end;

function TInteractionLogger.IsActive: Boolean;
begin
  Result := FActive;
end;

procedure TInteractionLogger.SetUser(const ANome, ALogin: string);
begin
  FUserName := ANome;
  FUserLogin := ALogin;
end;

function TInteractionLogger.SessionId: string;
begin
  Result := FSessionId;
end;

function TInteractionLogger.LogFileName: string;
begin
  Result := FFileName;
end;

procedure TInteractionLogger.Emit(const EventType: string;
  const ExtraPairs: array of string);
var
  Common: TArray<string>;
  All: TArray<string>;
  I, N: Integer;
begin
  if not FActive then
    Exit;

  Common := BuildCommonPairs(EventType);
  SetLength(All, Length(Common) + Length(ExtraPairs));
  for I := 0 to High(Common) do
    All[I] := Common[I];
  N := Length(Common);
  for I := 0 to High(ExtraPairs) do
  begin
    if ExtraPairs[I] <> '' then
    begin
      All[N] := ExtraPairs[I];
      Inc(N);
    end;
  end;
  SetLength(All, N);
  WriteLine(JsonObject(All));
end;

procedure TInteractionLogger.EmitRaw(const EventType, ExtraJsonObjectBody: string);
var
  Common: TArray<string>;
  Line: string;
  I: Integer;
  SB: TStringBuilder;
begin
  if not FActive then
    Exit;

  Common := BuildCommonPairs(EventType);
  SB := TStringBuilder.Create;
  try
    SB.Append('{');
    for I := 0 to High(Common) do
    begin
      if I > 0 then
        SB.Append(',');
      SB.Append(Common[I]);
    end;
    if ExtraJsonObjectBody <> '' then
    begin
      SB.Append(',');
      SB.Append(ExtraJsonObjectBody);
    end;
    SB.Append('}');
    Line := SB.ToString;
  finally
    SB.Free;
  end;
  WriteLine(Line);
end;

initialization

finalization
  FreeAndNil(GLogger);

end.
