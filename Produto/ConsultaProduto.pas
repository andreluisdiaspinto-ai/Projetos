unit ConsultaProduto;

{ Consulta de produtos para selecao (lookup).

  Pesquisa incremental: a cada caractere digitado no campo de pesquisa a
  query e reaberta filtrando as descricoes que comecam pelo texto
  informado, sempre em ordem alfabetica. As linhas do grid alternam de
  cor (zebra) para melhor visualizacao.

  Uso tipico (ex.: tela de Venda):

    if TForm_ConsultaProduto.Selecionar(Codigo, Descricao) then
      ... usa o produto selecionado ...
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

type
  TForm_ConsultaProduto = class(TForm)
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
    FDescricaoSelecionada: string;

    procedure Pesquisar;
    procedure AjustarFormatoCampos;
    procedure ConfirmarSelecao;
  public
    // Abre a consulta modal; True quando um produto foi confirmado.
    class function Selecionar(out ACodigo: Integer;
      out ADescricao: string): Boolean;
  end;

var
  Form_ConsultaProduto: TForm_ConsultaProduto;

implementation

uses DataModule, Mensagens, ObserveHooks, ObserveJson, UITheme;

{$R *.dfm}

{ Chamada externa }

class function TForm_ConsultaProduto.Selecionar(out ACodigo: Integer;
  out ADescricao: string): Boolean;
var
  Form: TForm_ConsultaProduto;
begin
  ACodigo    := 0;
  ADescricao := '';
  Form := TForm_ConsultaProduto.Create(nil);
  try
    ObserveLogModalOpen(Form);
    Result := Form.ShowModal = mrOk;
    if Result then
    begin
      ACodigo    := Form.FCodigoSelecionado;
      ADescricao := Form.FDescricaoSelecionada;
      ObserveLogModalResult(Form, mrOk, [
        JsonPairInt('codigo', ACodigo),
        JsonPairStr('descricao', ADescricao)
      ]);
    end
    else
      ObserveLogModalResult(Form, Form.ModalResult, []);
  finally
    Form.Free;
  end;
end;

{ Ciclo de vida }

procedure TForm_ConsultaProduto.FormCreate(Sender: TObject);
begin
  FCodigoSelecionado    := 0;
  FDescricaoSelecionada := '';

  Color := COR_PAGE;
  AplicarHeaderPrimary(Panel_Titulo);
  AplicarFormEstiloWeb(Self);
  AplicarPainelCard(PanelPesquisa);
  AplicarBotaoBootstrap(BtnConfirmar, bbkPrimary, ICN_CONFIRMAR);
  AplicarBotaoBootstrap(BtnCancelar, bbkSecondary, ICN_CANCELAR);

  QueryConsulta.SQL.Text :=
    'select CODIGO, DESCRICAO, CODIGO_BARRAS, PRECO_VENDA, ESTOQUE_ATUAL ' +
    'from PRODUTO ' +
    'where UPPER(DESCRICAO) like UPPER(:PDESCRICAO) ' +
    'order by DESCRICAO';

  // Abre listando todos os produtos em ordem alfabetica.
  Pesquisar;
  ActiveControl := EditPesquisa;
end;

{ Pesquisa incremental }

procedure TForm_ConsultaProduto.Pesquisar;
begin
  QueryConsulta.DisableControls;
  try
    QueryConsulta.Close;
    // Prefixo: traz as descricoes que COMECAM pelo texto digitado.
    QueryConsulta.ParamByName('PDESCRICAO').AsString :=
      Trim(EditPesquisa.Text) + '%';
    QueryConsulta.Open;
    AjustarFormatoCampos;
  finally
    QueryConsulta.EnableControls;
  end;
end;

procedure TForm_ConsultaProduto.AjustarFormatoCampos;

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
  Formatar('PRECO_VENDA');
  Formatar('ESTOQUE_ATUAL');
end;

procedure TForm_ConsultaProduto.EditPesquisaChange(Sender: TObject);
begin
  // Caracter a caracter: refiltra a cada tecla digitada.
  Pesquisar;
end;

{ Cores de foco }

procedure TForm_ConsultaProduto.EditFocoEnter(Sender: TObject);
begin
  if Sender is TEdit then
    TEdit(Sender).Color := COR_EDIT_FOCO;
end;

procedure TForm_ConsultaProduto.EditFocoExit(Sender: TObject);
begin
  if Sender is TEdit then
    TEdit(Sender).Color := COR_EDIT_NORMAL;
end;

{ Grid - linhas com cores alternadas (zebra) }

procedure TForm_ConsultaProduto.DBGridConsultaDrawColumnCell(Sender: TObject;
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

procedure TForm_ConsultaProduto.ConfirmarSelecao;
begin
  if QueryConsulta.IsEmpty then
  begin
    MensagemDlg('Nenhum produto encontrado para selecionar.',
      mtInformation, [mbOK], 0);
    Exit;
  end;

  FCodigoSelecionado    := QueryConsulta.FieldByName('CODIGO').AsInteger;
  FDescricaoSelecionada := QueryConsulta.FieldByName('DESCRICAO').AsString;
  ModalResult := mrOk;
end;

procedure TForm_ConsultaProduto.DBGridConsultaDblClick(Sender: TObject);
begin
  ConfirmarSelecao;
end;

procedure TForm_ConsultaProduto.BtnConfirmarClick(Sender: TObject);
begin
  ConfirmarSelecao;
end;

procedure TForm_ConsultaProduto.BtnCancelarClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

{ Teclado }

procedure TForm_ConsultaProduto.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    Key := 0;
    ModalResult := mrCancel;
  end
  else if (Key = VK_RETURN) and not (ActiveControl is TCustomButton) then
  begin
    // ENTER confirma o produto posicionado (na pesquisa ou na grade).
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
