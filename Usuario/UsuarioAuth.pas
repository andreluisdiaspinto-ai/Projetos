unit UsuarioAuth;

{ Controle de usuarios inspirado no UserControl (ecossistema Delphi).
  Usa a tabela USUARIO existente (IBX/Firebird) e senha Master padrao. }

interface

uses
  System.SysUtils, IBX.IBDatabase, IBX.IBQuery;

const
  // Credenciais Master padrao (acesso administrativo completo)
  USUARIO_MASTER_LOGIN = 'MASTER';
  USUARIO_MASTER_SENHA = 'MASTER';
  USUARIO_MASTER_NOME  = 'Usuario Master';

  // Limites da tabela USUARIO
  USUARIO_LOGIN_MAX = 20;
  USUARIO_SENHA_MAX = 15;
  USUARIO_NOME_MAX  = 35;

function UsuarioEhMaster(const Login: string): Boolean;
function UsuarioPodeGerenciarUsuarios(const Login: string): Boolean;
procedure GarantirUsuarioMaster(Database: TIBDatabase; Transaction: TIBTransaction);

implementation

function UsuarioEhMaster(const Login: string): Boolean;
begin
  Result := SameText(Trim(Login), USUARIO_MASTER_LOGIN);
end;

function UsuarioPodeGerenciarUsuarios(const Login: string): Boolean;
begin
  // Master e admin historico do projeto
  Result := UsuarioEhMaster(Login) or SameText(Trim(Login), 'admin');
end;

procedure GarantirUsuarioMaster(Database: TIBDatabase; Transaction: TIBTransaction);
var
  Q: TIBQuery;
  ProxCodigo: Integer;
begin
  if (Database = nil) or (Transaction = nil) then
    Exit;
  if not Database.Connected then
    Database.Open;

  Q := TIBQuery.Create(nil);
  try
    Q.Database := Database;
    Q.Transaction := Transaction;
    Q.SQL.Text :=
      'select CODIGO from USUARIO where UPPER(LOGIN) = UPPER(:PLOGIN)';
    Q.ParamByName('PLOGIN').AsString := USUARIO_MASTER_LOGIN;
    Q.Open;
    if not Q.IsEmpty then
    begin
      Q.Close;
      Exit;
    end;
    Q.Close;

    Q.SQL.Text := 'select coalesce(Max(Codigo),0)+1 as Codigo from USUARIO';
    Q.Open;
    ProxCodigo := Q.FieldByName('Codigo').AsInteger;
    Q.Close;

    Q.SQL.Text :=
      'insert into USUARIO (CODIGO, LOGIN, SENHA, NOME_USUARIO) ' +
      'values (:CODIGO, :LOGIN, :SENHA, :NOME)';
    Q.ParamByName('CODIGO').AsInteger := ProxCodigo;
    Q.ParamByName('LOGIN').AsString := USUARIO_MASTER_LOGIN;
    Q.ParamByName('SENHA').AsString := USUARIO_MASTER_SENHA;
    Q.ParamByName('NOME').AsString := USUARIO_MASTER_NOME;
    Q.ExecSQL;
    if Transaction.InTransaction then
      Transaction.CommitRetaining
    else
    begin
      Transaction.StartTransaction;
      Transaction.CommitRetaining;
    end;
  finally
    Q.Free;
  end;
end;

end.
