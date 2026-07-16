unit Temas;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons,
  UITheme;

const
  ICN_APLICAR = #$E73E; // Accept
  ICN_SAIR    = #$E8BB; // ChromeClose

type
  TForm_Temas = class(TForm)
    Panel_Titulo: TPanel;
    PanelDados: TPanel;
    PanelLista: TPanel;
    LabelLista: TLabel;
    ListBoxTemas: TListBox;
    LabelDescricao: TLabel;
    PanelPreview: TPanel;
    LabelPreview: TLabel;
    PanelAmostraPrimary: TPanel;
    PanelAmostraPage: TPanel;
    PanelAmostraCard: TPanel;
    LabelPrimary: TLabel;
    LabelPage: TLabel;
    LabelCard: TLabel;
    PanelRodape: TPanel;
    BtnAplicar: TBitBtn;
    BtnSair: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ListBoxTemasClick(Sender: TObject);
    procedure BtnAplicarClick(Sender: TObject);
    procedure BtnSairClick(Sender: TObject);
  private
    procedure AplicarLayoutInicial;
    procedure PopularLista;
    procedure AtualizarPreview;
    function TemaSelecionado: TAppThemeId;
  public
    { Public declarations }
  end;

var
  Form_Temas: TForm_Temas;

implementation

uses Mensagens, ObserveHooks;

{$R *.dfm}

procedure TForm_Temas.AplicarLayoutInicial;
begin
  Color := COR_PAGE;
  AplicarHeaderPrimary(Panel_Titulo);
  AplicarFormEstiloWeb(Self);
  PanelDados.ParentBackground := False;
  PanelDados.BevelOuter := bvNone;
  PanelDados.Color := COR_PAGE;
  AplicarPainelCard(PanelLista);
  AplicarPainelCard(PanelPreview);
  PanelRodape.ParentBackground := False;
  PanelRodape.BevelOuter := bvNone;
  PanelRodape.Color := COR_PAGE;
  LabelLista.Font.Color := COR_PRIMARY;
  LabelPreview.Font.Color := COR_PRIMARY;
  LabelDescricao.Font.Color := COR_TEXTO_MUTED;
  LabelPrimary.Font.Color := COR_TEXTO;
  LabelPage.Font.Color := COR_TEXTO;
  LabelCard.Font.Color := COR_TEXTO;
  AplicarBotaoBootstrap(BtnAplicar, bbkPrimary, ICN_APLICAR);
  AplicarBotaoBootstrap(BtnSair, bbkSecondary, ICN_SAIR);
end;

procedure TForm_Temas.PopularLista;
var
  Id: TAppThemeId;
begin
  ListBoxTemas.Items.BeginUpdate;
  try
    ListBoxTemas.Clear;
    for Id := Low(TAppThemeId) to High(TAppThemeId) do
      ListBoxTemas.Items.Add(NomeTema(Id));
  finally
    ListBoxTemas.Items.EndUpdate;
  end;
  ListBoxTemas.ItemIndex := Ord(TemaAtual);
  AtualizarPreview;
end;

function TForm_Temas.TemaSelecionado: TAppThemeId;
begin
  if (ListBoxTemas.ItemIndex < Ord(Low(TAppThemeId))) or
     (ListBoxTemas.ItemIndex > Ord(High(TAppThemeId))) then
    Result := TemaAtual
  else
    Result := TAppThemeId(ListBoxTemas.ItemIndex);
end;

procedure TForm_Temas.AtualizarPreview;
var
  Primary, Page, Card: TColor;
  Id: TAppThemeId;
begin
  Id := TemaSelecionado;
  ObterAmostraTema(Id, Primary, Page, Card);
  LabelDescricao.Caption := DescricaoTema(Id);
  PanelAmostraPrimary.Color := Primary;
  PanelAmostraPage.Color := Page;
  PanelAmostraCard.Color := Card;
  PanelAmostraPrimary.Invalidate;
  PanelAmostraPage.Invalidate;
  PanelAmostraCard.Invalidate;
end;

procedure TForm_Temas.FormCreate(Sender: TObject);
begin
  AplicarLayoutInicial;
  PopularLista;
end;

procedure TForm_Temas.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ObserveLogCloseForm(Self);
  Action := caFree;
  Form_Temas := nil;
end;

procedure TForm_Temas.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    Key := 0;
    Close;
  end
  else if (Key = VK_RETURN) or (Key = VK_TAB) then
  begin
    Key := 0;
    Perform(WM_NEXTDLGCTL, 0, 0);
  end;
end;

procedure TForm_Temas.ListBoxTemasClick(Sender: TObject);
begin
  AtualizarPreview;
end;

procedure TForm_Temas.BtnAplicarClick(Sender: TObject);
begin
  ObserveLogAction(Self, 'ActAplicarTema', 'BtnAplicar');
  DefinirTema(TemaSelecionado, True);
  AplicarLayoutInicial;
  AtualizarPreview;
  ShowMessage('Tema aplicado.');
end;

procedure TForm_Temas.BtnSairClick(Sender: TObject);
begin
  Close;
end;

end.
