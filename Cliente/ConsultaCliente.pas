unit ConsultaCliente;

{ Consulta de clientes para selecao (lookup).

  Pesquisa incremental: a cada caractere digitado no campo de pesquisa a
  query e reaberta filtrando os nomes que comecam pelo texto informado,
  sempre em ordem alfabetica.

  Uso tipico (ex.: tela de Venda):

    if TForm_ConsultaCliente.Selecionar(Codigo, Nome) then
      ... usa o cliente selecionado ...
}

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.Grids, Vcl.DBGrids,
  Data.DB, IBX.IBQuery;

const
  // Cores dos campos de entrada (TColor = 0x00BBGGRR)
  COR_EDIT_NORMAL = clWhite;
  COR_EDIT_FOCO   = $00FFF5EA;

  // Cores alternadas das linhas do grid (zebra)
  COR_GRID_LINHA_PAR   = clWhite;
  COR_GRID_LINHA_IMPAR = $00F3E9DC;
  COR_GRID_TEXTO       = $00333333;

  // Icones Segoe MDL2 Assets (Windows 10/11)
  ICN_CONFIRMAR = #$E73E; // CheckMark
  ICN_CANCELAR  = #$E711; // Cancel
  ICN_PESQUISA  = #$E721; // Search

type
  TForm_ConsultaCliente = class(TForm)
    Panel_Titulo: TPanel;

    PanelPesquisa: TPanel;
    LabelPesquisa: TLabel;
    EditPesquisa: TEdit;

    DBGridConsulta: TDBGrid;

    PanelRodape: TPanel;
    BtnConfirmar: TBitBtn;
    BtnCancelar: TBitBtn;

    QueryConsulta: TIBQuery;
    DsConsulta: TDataSource;

    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditPesquisaChange(Sender: TObject);
    procedure EditFocoEnter(Sender: TObject);
    procedure EditFocoExit(Sender: TObject);
    procedure DBGridConsultaDblClick(Sender: TObject);
    procedure DBGridConsultaDrawColumnCell(Sender: TObject;
      const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);
    procedure BtnConfirmarClick(Sender: TObject);
    procedure BtnCancelarClick(Sender: TObject);
  private
    FCodigoSelecionado: Integer;
    FNomeSelecionado: string;

    procedure Pesquisar;
    procedure AjustarFormatoCampos;
    procedure ConfirmarSelecao;
  public
    // Abre a consulta modal; True quando um cliente foi confirmado.
    class function Selecionar(out ACodigo: Integer;
      out ANome: string): Boolean;
  end;

var
  Form_ConsultaCliente: TForm_ConsultaCliente;

implementation

uses DataModule, Mensagens, ObserveHooks, ObserveJson, UITheme;

{$R *.dfm}

{ Chamada externa }

class function TForm_ConsultaCliente.Selecionar(out ACodigo: Integer;
  out ANome: string): Boolean;
var
  Form: TForm_ConsultaCliente;
begin
  ACodigo := 0;
  ANome   := '';
  Form := TForm_ConsultaCliente.Create(nil);
  try
    ObserveLogModalOpen(Form);
    Result := Form.ShowModal = mrOk;
    if Result then
    begin
      ACodigo := Form.FCodigoSelecionado;
      ANome   := Form.FNomeSelecionado;
      ObserveLogModalResult(Form, mrOk, [
        JsonPairInt('codigo', ACodigo),
        JsonPairStr('nome', ANome)
      ]);
    end
    else
      ObserveLogModalResult(Form, Form.ModalResult, []);
  finally
    Form.Free;
  end;
end;

{ Ciclo de vida }

procedure TForm_ConsultaCliente.FormCreate(Sender: TObject);
begin
  FCodigoSelecionado := 0;
  FNomeSelecionado   := '';

  Color := COR_PAGE;
  AplicarHeaderPrimary(Panel_Titulo);
  AplicarFormEstiloWeb(Self);
  AplicarPainelCard(PanelPesquisa);
  AplicarBotaoBootstrap(BtnConfirmar, bbkPrimary, ICN_CONFIRMAR);
  AplicarBotaoBootstrap(BtnCancelar, bbkSecondary, ICN_CANCELAR);

  QueryConsulta.SQL.Text :=
    'select CODIGO, NOME, TELEFONE, LIMITE_CREDITO, TOTAL_COMPRAS ' +
    'from CLIENTE ' +
    'where UPPER(NOME) like UPPER(:PNOME) ' +
    'order by NOME';

  // Abre listando todos os clientes em ordem alfabetica.
  Pesquisar;
  ActiveControl := EditPesquisa;
end;

{ Pesquisa incremental }

procedure TForm_ConsultaCliente.Pesquisar;
begin
  QueryConsulta.DisableControls;
  try
    QueryConsulta.Close;
    // Prefixo: traz os nomes que COMECAM pelo texto digitado.
    QueryConsulta.ParamByName('PNOME').AsString :=
      Trim(EditPesquisa.Text) + '%';
    QueryConsulta.Open;
    AjustarFormatoCampos;
  finally
    QueryConsulta.EnableControls;
  end;
end;

procedure TForm_ConsultaCliente.AjustarFormatoCampos;

  procedure Formatar(const NomeCampo: string);
  var
    Fld: TField;
  begin
    Fld := QueryConsulta.FindField(NomeCampo);
    if Fld is TBCDField then
      TBCDField(Fld).DisplayFormat := '#,##0.00'
    else if Fld is TFloatField then
      TFloatField(Fld).DisplayFormat := '#,##0.00';
  end;

begin
  Formatar('LIMITE_CREDITO');
  Formatar('TOTAL_COMPRAS');
end;

procedure TForm_ConsultaCliente.EditPesquisaChange(Sender: TObject);
begin
  // Caracter a caracter: refiltra a cada tecla digitada.
  Pesquisar;
end;

{ Cores de foco }

procedure TForm_ConsultaCliente.EditFocoEnter(Sender: TObject);
begin
  if Sender is TEdit then
    TEdit(Sender).Color := COR_EDIT_FOCO;
end;

procedure TForm_ConsultaCliente.EditFocoExit(Sender: TObject);
begin
  if Sender is TEdit then
    TEdit(Sender).Color := COR_EDIT_NORMAL;
end;

{ Grid - linhas com cores alternadas (zebra) }

procedure TForm_ConsultaCliente.DBGridConsultaDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
var
  Grid: TDBGrid;
begin
  Grid := TDBGrid(Sender);

  // Linha selecionada mantem o destaque padrao; as demais alternam a
  // cor de fundo conforme a posicao do registro (par/impar).
  if not (gdSelected in State) then
  begin
    if Odd(Grid.DataSource.DataSet.RecNo) then
      Grid.Canvas.Brush.Color := COR_GRID_LINHA_IMPAR
    else
      Grid.Canvas.Brush.Color := COR_GRID_LINHA_PAR;
    Grid.Canvas.Font.Color := COR_GRID_TEXTO;
  end;

  Grid.DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;

{ Selecao }

procedure TForm_ConsultaCliente.ConfirmarSelecao;
begin
  if QueryConsulta.IsEmpty then
  begin
    MensagemDlg('Nenhum cliente encontrado para selecionar.',
      mtInformation, [mbOK], 0);
    Exit;
  end;

  FCodigoSelecionado := QueryConsulta.FieldByName('CODIGO').AsInteger;
  FNomeSelecionado   := QueryConsulta.FieldByName('NOME').AsString;
  ModalResult := mrOk;
end;

procedure TForm_ConsultaCliente.DBGridConsultaDblClick(Sender: TObject);
begin
  ConfirmarSelecao;
end;

procedure TForm_ConsultaCliente.BtnConfirmarClick(Sender: TObject);
begin
  ConfirmarSelecao;
end;

procedure TForm_ConsultaCliente.BtnCancelarClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

{ Teclado }

procedure TForm_ConsultaCliente.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    Key := 0;
    ModalResult := mrCancel;
  end
  else if (Key = VK_RETURN) and not (ActiveControl is TCustomButton) then
  begin
    // ENTER confirma o cliente posicionado (na pesquisa ou na grade).
    Key := 0;
    ConfirmarSelecao;
  end
  else if (Key = VK_DOWN) and (ActiveControl = EditPesquisa) then
  begin
    // Seta para baixo salta da pesquisa para a grade.
    Key := 0;
    if DBGridConsulta.CanFocus then
      DBGridConsulta.SetFocus;
  end;
end;

end.
