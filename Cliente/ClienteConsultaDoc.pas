unit ClienteConsultaDoc;

{ Validacao de CPF/CNPJ e consultas HTTP (CEP ViaCEP, CNPJ BrasilAPI).
  CPF: apenas validacao local (sem API publica gratuita / LGPD). }

interface

uses
  System.SysUtils, System.Classes, System.JSON, System.Net.HttpClient,
  System.Net.URLClient;

type
  TDadosCep = record
    Logradouro: string;
    Bairro: string;
    Cidade: string;
    Uf: string;
    Encontrado: Boolean;
  end;

  TDadosCnpj = record
    RazaoSocial: string;
    NomeFantasia: string;
    Logradouro: string;
    Numero: string;
    Bairro: string;
    Municipio: string;
    Uf: string;
    Cep: string;
    Telefone: string;
    Encontrado: Boolean;
  end;

function SomenteDigitosDoc(const S: string): string;
function SomenteAlfaNumDoc(const S: string): string;
function ValidarCpf(const Cpf: string): Boolean;
function ValidarCnpj(const Cnpj: string): Boolean;
function FormatarCpfExibicao(const Digitos: string): string;
function FormatarCnpjExibicao(const Base: string): string;
function FormatarCepExibicao(const Digitos: string): string;
function ConsultarCepViaCep(const Cep: string; out Dados: TDadosCep;
  out Erro: string): Boolean;
function ConsultarCnpjBrasilApi(const Cnpj: string; out Dados: TDadosCnpj;
  out Erro: string): Boolean;

implementation

const
  HTTP_TIMEOUT_MS = 8000;

function SomenteDigitosDoc(const S: string): string;
var
  Ch: Char;
begin
  Result := '';
  for Ch in S do
    if CharInSet(Ch, ['0'..'9']) then
      Result := Result + Ch;
end;

function SomenteAlfaNumDoc(const S: string): string;
var
  Ch: Char;
  U: Char;
begin
  Result := '';
  for Ch in S do
  begin
    U := UpCase(Ch);
    if CharInSet(U, ['0'..'9', 'A'..'Z']) then
      Result := Result + U;
  end;
end;

function TodosCaracteresIguais(const S: string): Boolean;
var
  i: Integer;
begin
  Result := Length(S) > 0;
  for i := 2 to Length(S) do
    if S[i] <> S[1] then
      Exit(False);
end;

function ValorCharCnpj(const C: Char): Integer;
begin
  { Regra RFB: valor = Ord(UpCase(c)) - 48 (digitos e letras A-Z). }
  Result := Ord(UpCase(C)) - 48;
end;

function DigitoModulo11(const Base: string; const Pesos: array of Integer): Char;
var
  Soma, i, Resto, Dv: Integer;
begin
  Soma := 0;
  for i := 0 to High(Pesos) do
    Soma := Soma + ValorCharCnpj(Base[i + 1]) * Pesos[i];
  Resto := Soma mod 11;
  if Resto < 2 then
    Dv := 0
  else
    Dv := 11 - Resto;
  Result := Char(Ord('0') + Dv);
end;

function ValidarCpf(const Cpf: string): Boolean;
var
  Digitos: string;
  i, Soma, Resto, Dv: Integer;
begin
  Digitos := SomenteDigitosDoc(Cpf);
  Result := False;
  if Length(Digitos) <> 11 then
    Exit;
  if TodosCaracteresIguais(Digitos) then
    Exit;

  Soma := 0;
  for i := 1 to 9 do
    Soma := Soma + (Ord(Digitos[i]) - Ord('0')) * (11 - i);
  Resto := Soma mod 11;
  if Resto < 2 then
    Dv := 0
  else
    Dv := 11 - Resto;
  if Dv <> (Ord(Digitos[10]) - Ord('0')) then
    Exit;

  Soma := 0;
  for i := 1 to 10 do
    Soma := Soma + (Ord(Digitos[i]) - Ord('0')) * (12 - i);
  Resto := Soma mod 11;
  if Resto < 2 then
    Dv := 0
  else
    Dv := 11 - Resto;
  Result := Dv = (Ord(Digitos[11]) - Ord('0'));
end;

function ValidarCnpj(const Cnpj: string): Boolean;
const
  Pesos1: array[0..11] of Integer = (5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2);
  Pesos2: array[0..12] of Integer = (6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2);
var
  Base: string;
  i: Integer;
  Dv1, Dv2: Char;
begin
  Base := SomenteAlfaNumDoc(Cnpj);
  Result := False;
  if Length(Base) <> 14 then
    Exit;

  for i := 1 to 12 do
    if not CharInSet(Base[i], ['0'..'9', 'A'..'Z']) then
      Exit;
  if not CharInSet(Base[13], ['0'..'9']) then
    Exit;
  if not CharInSet(Base[14], ['0'..'9']) then
    Exit;
  if TodosCaracteresIguais(Base) then
    Exit;

  Dv1 := DigitoModulo11(Copy(Base, 1, 12), Pesos1);
  if Base[13] <> Dv1 then
    Exit;
  Dv2 := DigitoModulo11(Copy(Base, 1, 13), Pesos2);
  Result := Base[14] = Dv2;
end;

function FormatarCpfExibicao(const Digitos: string): string;
var
  D: string;
begin
  D := SomenteDigitosDoc(Digitos);
  if Length(D) <> 11 then
    Result := D
  else
    Result := Copy(D, 1, 3) + '.' + Copy(D, 4, 3) + '.' +
      Copy(D, 7, 3) + '-' + Copy(D, 10, 2);
end;

function FormatarCnpjExibicao(const Base: string): string;
var
  S: string;
begin
  S := SomenteAlfaNumDoc(Base);
  if Length(S) <> 14 then
    Result := S
  else
    Result := Copy(S, 1, 2) + '.' + Copy(S, 3, 3) + '.' +
      Copy(S, 6, 3) + '/' + Copy(S, 9, 4) + '-' + Copy(S, 13, 2);
end;

function FormatarCepExibicao(const Digitos: string): string;
var
  D: string;
begin
  D := SomenteDigitosDoc(Digitos);
  if Length(D) <> 8 then
    Result := D
  else
    Result := Copy(D, 1, 5) + '-' + Copy(D, 6, 3);
end;

function HttpGetJson(const Url: string; out JsonText: string;
  out Erro: string): Boolean;
var
  Http: THTTPClient;
  Resp: IHTTPResponse;
begin
  Result := False;
  JsonText := '';
  Erro := '';
  Http := THTTPClient.Create;
  try
    Http.ConnectionTimeout := HTTP_TIMEOUT_MS;
    Http.ResponseTimeout := HTTP_TIMEOUT_MS;
    Http.UserAgent := 'ProjetoAvaliacao/1.0';
    try
      Resp := Http.Get(Url);
      if (Resp.StatusCode < 200) or (Resp.StatusCode >= 300) then
      begin
        Erro := Format('Falha HTTP %d ao consultar o servico.', [Resp.StatusCode]);
        Exit;
      end;
      JsonText := Resp.ContentAsString;
      Result := Trim(JsonText) <> '';
      if not Result then
        Erro := 'Resposta vazia do servico.';
    except
      on E: Exception do
      begin
        Erro := 'Erro de conexao: ' + E.Message;
        Result := False;
      end;
    end;
  finally
    Http.Free;
  end;
end;

function JsonStr(Obj: TJSONObject; const Nome: string): string;
var
  V: TJSONValue;
begin
  Result := '';
  if not Assigned(Obj) then
    Exit;
  V := Obj.Values[Nome];
  if Assigned(V) and not (V is TJSONNull) then
    Result := Trim(V.Value);
end;

function ConsultarCepViaCep(const Cep: string; out Dados: TDadosCep;
  out Erro: string): Boolean;
var
  Digitos, Url, JsonText: string;
  Root: TJSONValue;
  Obj: TJSONObject;
  FlagErro: TJSONValue;
begin
  Dados.Logradouro := '';
  Dados.Bairro := '';
  Dados.Cidade := '';
  Dados.Uf := '';
  Dados.Encontrado := False;
  Erro := '';
  Result := False;
  Digitos := SomenteDigitosDoc(Cep);
  if Length(Digitos) <> 8 then
  begin
    Erro := 'CEP deve conter 8 digitos.';
    Exit;
  end;

  Url := 'https://viacep.com.br/ws/' + Digitos + '/json/';
  if not HttpGetJson(Url, JsonText, Erro) then
    Exit;

  Root := TJSONObject.ParseJSONValue(JsonText);
  if not Assigned(Root) then
  begin
    Erro := 'Resposta de CEP invalida.';
    Exit;
  end;
  try
    if not (Root is TJSONObject) then
    begin
      Erro := 'Resposta de CEP invalida.';
      Exit;
    end;
    Obj := TJSONObject(Root);
    FlagErro := Obj.Values['erro'];
    if Assigned(FlagErro) and (SameText(FlagErro.Value, 'true') or
       (FlagErro is TJSONTrue)) then
    begin
      Erro := 'CEP nao encontrado.';
      Exit;
    end;
    Dados.Logradouro := AnsiUpperCase(JsonStr(Obj, 'logradouro'));
    Dados.Bairro := AnsiUpperCase(JsonStr(Obj, 'bairro'));
    Dados.Cidade := AnsiUpperCase(JsonStr(Obj, 'localidade'));
    Dados.Uf := AnsiUpperCase(JsonStr(Obj, 'uf'));
    Dados.Encontrado := True;
    Result := True;
  finally
    Root.Free;
  end;
end;

function ConsultarCnpjBrasilApi(const Cnpj: string; out Dados: TDadosCnpj;
  out Erro: string): Boolean;
var
  Base, Url, JsonText, Ddd: string;
  Root: TJSONValue;
  Obj: TJSONObject;
begin
  Dados.RazaoSocial := '';
  Dados.NomeFantasia := '';
  Dados.Logradouro := '';
  Dados.Numero := '';
  Dados.Bairro := '';
  Dados.Municipio := '';
  Dados.Uf := '';
  Dados.Cep := '';
  Dados.Telefone := '';
  Dados.Encontrado := False;
  Erro := '';
  Result := False;
  Base := SomenteAlfaNumDoc(Cnpj);
  if not ValidarCnpj(Base) then
  begin
    Erro := 'CNPJ invalido.';
    Exit;
  end;

  Url := 'https://brasilapi.com.br/api/cnpj/v1/' + Base;
  if not HttpGetJson(Url, JsonText, Erro) then
    Exit;

  Root := TJSONObject.ParseJSONValue(JsonText);
  if not Assigned(Root) then
  begin
    Erro := 'Resposta de CNPJ invalida.';
    Exit;
  end;
  try
    if not (Root is TJSONObject) then
    begin
      Erro := 'Resposta de CNPJ invalida.';
      Exit;
    end;
    Obj := TJSONObject(Root);
    Dados.RazaoSocial := AnsiUpperCase(JsonStr(Obj, 'razao_social'));
    Dados.NomeFantasia := AnsiUpperCase(JsonStr(Obj, 'nome_fantasia'));
    Dados.Logradouro := AnsiUpperCase(JsonStr(Obj, 'logradouro'));
    Dados.Numero := AnsiUpperCase(JsonStr(Obj, 'numero'));
    Dados.Bairro := AnsiUpperCase(JsonStr(Obj, 'bairro'));
    Dados.Municipio := AnsiUpperCase(JsonStr(Obj, 'municipio'));
    Dados.Uf := AnsiUpperCase(JsonStr(Obj, 'uf'));
    Dados.Cep := SomenteDigitosDoc(JsonStr(Obj, 'cep'));
    Ddd := SomenteDigitosDoc(JsonStr(Obj, 'ddd_telefone_1'));
    if Ddd <> '' then
      Dados.Telefone := Ddd
    else
      Dados.Telefone := SomenteDigitosDoc(JsonStr(Obj, 'telefone'));
    Dados.Encontrado := (Dados.RazaoSocial <> '') or (Dados.NomeFantasia <> '');
    if not Dados.Encontrado then
    begin
      Erro := 'CNPJ nao encontrado na BrasilAPI.';
      Exit;
    end;
    Result := True;
  finally
    Root.Free;
  end;
end;

end.
