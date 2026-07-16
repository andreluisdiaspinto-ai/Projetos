unit ObserveJson;

{ Helpers minimos para montar JSON sem dependencias externas.
  Usado pelo Interaction Recorder (saida JSON Lines UTF-8). }

interface

uses
  System.SysUtils, System.Classes;

function JsonEscape(const S: string): string;
function JsonStr(const S: string): string;
function JsonPairStr(const Key, Value: string): string;
function JsonPairInt(const Key: string; Value: Int64): string;
function JsonPairBool(const Key: string; Value: Boolean): string;
function JsonPairRaw(const Key, RawJsonValue: string): string;
function JsonObject(const Pairs: array of string): string;
function JsonArray(const Items: array of string): string;

implementation

function JsonEscape(const S: string): string;
var
  I: Integer;
  C: Char;
  SB: TStringBuilder;
begin
  SB := TStringBuilder.Create(Length(S) + 16);
  try
    for I := 1 to Length(S) do
    begin
      C := S[I];
      case C of
        '"':  SB.Append('\"');
        '\':  SB.Append('\\');
        #8:   SB.Append('\b');
        #9:   SB.Append('\t');
        #10:  SB.Append('\n');
        #12:  SB.Append('\f');
        #13:  SB.Append('\r');
      else
        if Ord(C) < 32 then
          SB.AppendFormat('\u%0.4x', [Ord(C)])
        else
          SB.Append(C);
      end;
    end;
    Result := SB.ToString;
  finally
    SB.Free;
  end;
end;

function JsonStr(const S: string): string;
begin
  Result := '"' + JsonEscape(S) + '"';
end;

function JsonPairStr(const Key, Value: string): string;
begin
  Result := JsonStr(Key) + ':' + JsonStr(Value);
end;

function JsonPairInt(const Key: string; Value: Int64): string;
begin
  Result := JsonStr(Key) + ':' + IntToStr(Value);
end;

function JsonPairBool(const Key: string; Value: Boolean): string;
begin
  if Value then
    Result := JsonStr(Key) + ':true'
  else
    Result := JsonStr(Key) + ':false';
end;

function JsonPairRaw(const Key, RawJsonValue: string): string;
begin
  Result := JsonStr(Key) + ':' + RawJsonValue;
end;

function JsonObject(const Pairs: array of string): string;
var
  I: Integer;
  SB: TStringBuilder;
begin
  SB := TStringBuilder.Create;
  try
    SB.Append('{');
    for I := 0 to High(Pairs) do
    begin
      if Pairs[I] = '' then
        Continue;
      if SB.Length > 1 then
        SB.Append(',');
      SB.Append(Pairs[I]);
    end;
    SB.Append('}');
    Result := SB.ToString;
  finally
    SB.Free;
  end;
end;

function JsonArray(const Items: array of string): string;
var
  I: Integer;
  SB: TStringBuilder;
begin
  SB := TStringBuilder.Create;
  try
    SB.Append('[');
    for I := 0 to High(Items) do
    begin
      if Items[I] = '' then
        Continue;
      if SB.Length > 1 then
        SB.Append(',');
      SB.Append(Items[I]);
    end;
    SB.Append(']');
    Result := SB.ToString;
  finally
    SB.Free;
  end;
end;

end.
