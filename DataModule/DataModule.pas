unit DataModule;

interface

uses
  System.SysUtils, System.Classes, Data.FMTBcd, Data.DBXFirebird, Data.DB,
  Datasnap.Provider, Datasnap.DBClient, Data.SqlExpr, IBX.IBDatabase,
  IBX.IBCustomDataSet, IBX.IBQuery, IBX.IBUpdateSQL;

type
  TDM = class(TDataModule)
    Conexao: TIBDatabase;
    SqlCliente: TIBQuery;
    IBTransaction1: TIBTransaction;
    CDSCliente: TClientDataSet;
    DsCliente: TDataSource;
    DSPCliente: TDataSetProvider;
    SqlProduto: TIBQuery;
    DsProduto: TDataSource;
    CDSProduto: TClientDataSet;
    DSPProduto: TDataSetProvider;
    SqlClienteCODIGO: TIntegerField;
    SqlClienteNOME: TIBStringField;
    SqlClienteTIPO: TIBStringField;
    SqlClienteCPF: TIBStringField;
    SqlClienteCNPJ: TIBStringField;
    SqlClienteCEP: TIBStringField;
    SqlClienteENDERECO: TIBStringField;
    SqlClienteNUMERO: TIBStringField;
    SqlClienteBAIRRO: TIBStringField;
    SqlClienteCIDADE: TIBStringField;
    SqlClienteTELEFONE: TIBStringField;
    SqlClienteOBSERVACAO: TWideMemoField;
    SqlClienteRENDA_MENSAL: TIBBCDField;
    SqlClienteLIMITE_CREDITO: TIBBCDField;
    SqlClienteTOTAL_COMPRAS: TIBBCDField;
    SqlProdutoCODIGO: TIntegerField;
    SqlProdutoDESCRICAO: TIBStringField;
    SqlProdutoREFERENCIA: TIBStringField;
    SqlProdutoCODIGO_BARRAS: TLargeintField;
    SqlProdutoMARCA: TIBStringField;
    SqlProdutoGRUPO: TIBStringField;
    SqlProdutoPRECO_VENDA: TIBBCDField;
    SqlProdutoESTOQUE_ATUAL: TIBBCDField;
    SqlVenda: TIBQuery;
    CDSVenda: TClientDataSet;
    DSVenda: TDataSource;
    DSPVenda: TDataSetProvider;
    SQLVendaItem: TIBQuery;
    DSVendaItem: TDataSource;
    CDSVendaItem: TClientDataSet;
    SQLVendaItemCODIGO: TIntegerField;
    SQLVendaItemCODIGO_VENDA: TIntegerField;
    SQLVendaItemCODIGO_PRODUTO: TIntegerField;
    SQLVendaItemQUANTIDADE: TIBBCDField;
    SQLVendaItemPRECO_UNITARIO: TIBBCDField;
    SQLVendaItemDESCONTO: TIBBCDField;
    SQLVendaItemACRESCIMO: TIBBCDField;
    SQLVendaItemTOTAL_LIQUIDO: TIBBCDField;
    SqlVendaCODIGO: TIntegerField;
    SqlVendaCODIGO_CLIENTE: TIntegerField;
    SqlVendaSITUACAO: TIBStringField;
    SqlVendaDATA_HORA_VENDA: TDateTimeField;
    SqlVendaTOTAL_BRUTO: TIBBCDField;
    SqlVendaDESCONTO_PERC: TIBBCDField;
    SqlVendaACRESCIMO_PER: TIBBCDField;
    SqlVendaTOTAL_LIQUIDO: TIBBCDField;
    DSPVendaItem: TDataSetProvider;
    SQLVendaItemDescricaoProduto: TStringField;
    QueryId: TIBQuery;
    CDSClienteCODIGO: TIntegerField;
    CDSClienteNOME: TWideStringField;
    CDSClienteTIPO: TWideStringField;
    CDSClienteCPF: TWideStringField;
    CDSClienteCNPJ: TWideStringField;
    CDSClienteCEP: TWideStringField;
    CDSClienteENDERECO: TWideStringField;
    CDSClienteNUMERO: TWideStringField;
    CDSClienteBAIRRO: TWideStringField;
    CDSClienteCIDADE: TWideStringField;
    CDSClienteTELEFONE: TWideStringField;
    CDSClienteOBSERVACAO: TWideMemoField;
    CDSClienteRENDA_MENSAL: TBCDField;
    CDSClienteLIMITE_CREDITO: TBCDField;
    CDSClienteTOTAL_COMPRAS: TBCDField;
    IBUpdateSQLCliente: TIBUpdateSQL;
    IBUpdateSQLProduto: TIBUpdateSQL;
    IBUpdateSQLVenda: TIBUpdateSQL;
    IBUpdateSQLVendaItem: TIBUpdateSQL;
    SQLVendaItemPrecoItem: TFloatField;
    SqlVendaNOMECLIENTTE: TStringField;
    procedure DataModuleCreate(Sender: TObject);
    procedure DsClienteDataChange(Sender: TObject; Field: TField);
    procedure DsProdutoDataChange(Sender: TObject; Field: TField);
    procedure DSVendaDataChange(Sender: TObject; Field: TField);
  private
    function CaminhoConexaoIni: string;
    procedure GravarConexaoIniPadrao(const Arquivo: string);
    procedure AplicarParamsConexao(const Arquivo: string);
    procedure ConfigurarConexaoDoIni;
  public
    { Public declarations }
  end;

var
  DM: TDM;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}
uses
  System.IniFiles, Cliente, Produto, Venda;

{$R *.dfm}

const
  // Defaults iguais aos parametros atuais do Conexao no .dfm
  INI_SEC_FIREBIRD = 'Firebird';
  DEF_DATABASE =
    '127.0.0.1/3050:C:\Avaliacao Delphi_Firebird\Andre_luis\Dados\DBAVALIACAO.IB';
  DEF_USER_NAME = 'SYSDBA';
  DEF_PASSWORD = '1652498327';
  DEF_LC_CTYPE = 'WIN1252';
  DEF_SERVER_TYPE = 'IBServer';

function TDM.CaminhoConexaoIni: string;
begin
  // Sempre ao lado do executavel (ParamStr(0)).
  Result := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) +
    'conexao.ini';
end;

procedure TDM.GravarConexaoIniPadrao(const Arquivo: string);
var
  Ini: TIniFile;
  Pasta: string;
begin
  Pasta := ExtractFilePath(Arquivo);
  if (Pasta <> '') and (not DirectoryExists(Pasta)) then
    ForceDirectories(Pasta);

  Ini := TIniFile.Create(Arquivo);
  try
    Ini.WriteString(INI_SEC_FIREBIRD, 'Database', DEF_DATABASE);
    Ini.WriteString(INI_SEC_FIREBIRD, 'User_Name', DEF_USER_NAME);
    Ini.WriteString(INI_SEC_FIREBIRD, 'Password', DEF_PASSWORD);
    Ini.WriteString(INI_SEC_FIREBIRD, 'LC_CTYPE', DEF_LC_CTYPE);
    Ini.WriteString(INI_SEC_FIREBIRD, 'ServerType', DEF_SERVER_TYPE);
  finally
    Ini.Free;
  end;
end;

procedure TDM.AplicarParamsConexao(const Arquivo: string);
var
  Ini: TIniFile;
  DatabaseName, UserName, Password, LcCtype, ServerType: string;
begin
  Ini := TIniFile.Create(Arquivo);
  try
    DatabaseName := Trim(Ini.ReadString(INI_SEC_FIREBIRD, 'Database', DEF_DATABASE));
    UserName := Trim(Ini.ReadString(INI_SEC_FIREBIRD, 'User_Name', DEF_USER_NAME));
    Password := Ini.ReadString(INI_SEC_FIREBIRD, 'Password', DEF_PASSWORD);
    LcCtype := Trim(Ini.ReadString(INI_SEC_FIREBIRD, 'LC_CTYPE', DEF_LC_CTYPE));
    ServerType := Trim(Ini.ReadString(INI_SEC_FIREBIRD, 'ServerType', DEF_SERVER_TYPE));
  finally
    Ini.Free;
  end;

  if DatabaseName = '' then
    DatabaseName := DEF_DATABASE;
  if UserName = '' then
    UserName := DEF_USER_NAME;
  if LcCtype = '' then
    LcCtype := DEF_LC_CTYPE;
  if ServerType = '' then
    ServerType := DEF_SERVER_TYPE;

  // Garante desconectado antes de aplicar parametros.
  if Conexao.Connected then
    Conexao.Connected := False;

  Conexao.LoginPrompt := False;
  Conexao.Params.Clear;
  Conexao.Params.Values['user_name'] := UserName;
  Conexao.Params.Values['password'] := Password;
  Conexao.Params.Values['lc_ctype'] := LcCtype;
  Conexao.ServerType := ServerType;
  // DatabaseName por ultimo: IBX exige nome antes do Open.
  Conexao.DatabaseName := DatabaseName;
end;

procedure TDM.ConfigurarConexaoDoIni;
var
  Arquivo: string;
begin
  Arquivo := CaminhoConexaoIni;
  if not FileExists(Arquivo) then
    GravarConexaoIniPadrao(Arquivo);
  AplicarParamsConexao(Arquivo);
end;

procedure TDM.DataModuleCreate(Sender: TObject);
begin
  // 1) Sempre inicia desconectado (nao conectar no streaming do dfm).
  Conexao.Connected := False;

  // 2) Le/cria conexao.ini ao lado do .exe e aplica parametros.
  ConfigurarConexaoDoIni;

  // 3) So abre se houver DatabaseName.
  if Trim(Conexao.DatabaseName) = '' then
    Conexao.DatabaseName := DEF_DATABASE;

  try
    Conexao.Open; // Connected = True apenas com sucesso
  except
    on E: Exception do
    begin
      Conexao.Connected := False;
      raise Exception.Create(
        'Falha ao conectar pelo conexao.ini.' + sLineBreak +
        'Arquivo: ' + CaminhoConexaoIni + sLineBreak +
        'Database: ' + Conexao.DatabaseName + sLineBreak + E.Message);
    end;
  end;
end;

procedure TDM.DsClienteDataChange(Sender: TObject; Field: TField);
begin
 with Dm.SqlCliente.DataSource do
 begin
   if Assigned(Form_Cliente) then
   begin
     Form_Cliente.BtnPrimeiro. Enabled :=  (not Dm.SqlCliente.Bof) and (Dm.SqlCliente.State = DsBrowse);
     Form_Cliente.BtnAnterior. Enabled :=  (not Dm.SqlCliente.Bof) and (Dm.SqlCliente.State = DsBrowse);
     Form_Cliente.BtnUltimo. Enabled   :=  (not Dm.SqlCliente.Eof) and (Dm.SqlCliente.State = DsBrowse);
     Form_Cliente.BtnProximo. Enabled  :=  (not Dm.SqlCliente.Eof) and (Dm.SqlCliente.State = DsBrowse);
     Form_Cliente.BtnInserir. Enabled  :=  (dm.SqlCliente.State = DsBrowse);
     Form_Cliente.BtnEditar. Enabled   :=  (dm.SqlCliente.State = DsBrowse) and (not Dm.SqlCliente.IsEmpty);
     Form_Cliente.BtnExcluir. Enabled  :=  (dm.SqlCliente.State = DsBrowse) and (not Dm.SqlCliente.IsEmpty);
     Form_Cliente.BtnCancelar. Enabled :=  (dm.SqlCliente.State <> DsBrowse) and (not Dm.SqlCliente.IsEmpty);
     Form_Cliente.BtnGravar. Enabled   :=  (dm.SqlCliente.State <> DsBrowse);
   end;
 end;
end;

procedure TDM.DsProdutoDataChange(Sender: TObject; Field: TField);
begin
  with Dm.SqlProduto.DataSource do
  begin
    if Assigned(Form_Produto) then
    begin
      Form_Produto.BtnPrimeiro. Enabled :=  (not Dm.SqlProduto.Bof) and (Dm.SqlProduto.State = DsBrowse);
      Form_Produto.BtnAnterior. Enabled :=  (not Dm.SqlProduto.Bof) and (Dm.SqlProduto.State = DsBrowse);
      Form_Produto.BtnUltimo. Enabled   :=  (not Dm.SqlProduto.Eof) and (Dm.SqlProduto.State = DsBrowse);
      Form_Produto.BtnProximo. Enabled  :=  (not Dm.SqlProduto.Eof) and (Dm.SqlProduto.State = DsBrowse);
      Form_Produto.BtnInserir. Enabled  :=  (dm.SqlProduto.State = DsBrowse);
      Form_Produto.BtnEditar. Enabled   :=  (dm.SqlProduto.State = DsBrowse)  and (not Dm.SqlProduto.IsEmpty);
      Form_Produto.BtnExcluir. Enabled  :=  (dm.SqlProduto.State = DsBrowse)  and (not Dm.SqlProduto.IsEmpty);
      Form_Produto.BtnCancelar. Enabled :=  (dm.SqlProduto.State <> DsBrowse) and (not Dm.SqlProduto.IsEmpty);
      Form_Produto.BtnGravar. Enabled   :=  (dm.SqlProduto.State <> DsBrowse);
    end;
  end;
end;

procedure TDM.DSVendaDataChange(Sender: TObject; Field: TField);
begin
  with Dm.SqlVenda.DataSource do
  begin
    {if Assigned(Form_Venda) then
    begin
      Form_Venda.BtnPrimeiro. Enabled :=  (not Dm.SqlVenda.Bof) and (Dm.SqlVenda.State = DsBrowse);
      Form_Venda.BtnAnterior. Enabled :=  (not Dm.SqlVenda.Bof) and (Dm.SqlVenda.State = DsBrowse);
      Form_Venda.BtnUltimo. Enabled   :=  (not Dm.SqlVenda.Eof) and (Dm.SqlVenda.State = DsBrowse);
      Form_Venda.BtnProximo. Enabled  :=  (not Dm.SqlVenda.Eof) and (Dm.SqlVenda.State = DsBrowse);
      Form_Venda.BtnInserir. Enabled  :=  (dm.SqlVenda.State = DsBrowse);
      Form_Venda.BtnEditar. Enabled   :=  (dm.SqlVenda.State = DsBrowse)  and (not Dm.SqlVenda.IsEmpty);
      Form_Venda.BtnExcluir. Enabled  :=  (dm.SqlVenda.State = DsBrowse)  and (not Dm.SqlVenda.IsEmpty);
      Form_Venda.BtnCancelar. Enabled :=  (dm.SqlVenda.State <> DsBrowse) and (not Dm.SqlVenda.IsEmpty);
      Form_Venda.BtnGravar. Enabled   :=  (dm.SqlVenda.State <> DsBrowse);
    end;}
  end;
end;

end.
