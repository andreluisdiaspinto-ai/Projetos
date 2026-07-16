unit Cliente;

interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.CommCtrl,
  System.SysUtils, System.Classes, System.Actions,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Mask, Vcl.DBCtrls,
  Vcl.Buttons, Vcl.ActnList, Vcl.WinXCtrls,
  Data.DB, IBX.IBQuery, IBX.IBCustomDataSet, ClienteConsultaDoc;

const
  // Mensagem custom usada para reagendar o foco no proprio campo,
  // saindo do fluxo do OnExit corrente (evita loop e efeitos colaterais).
  WM_REFOCAR = WM_USER + $100;
  // Aplica F/J apos o Click do TDBRadioGroup gravar TIPO no dataset
  // (OnChange sincrono + Clear de CPF/CNPJ revertiam o radio para F).
  WM_APLICAR_TIPO = WM_USER + $101;

  // Cores dos campos de entrada (TColor = 0x00BBGGRR)
  COR_EDIT_NORMAL   = clWhite;    // branco padrao (edicao)
  COR_EDIT_FOCO     = $00FFE2CF;  // azul Bootstrap claro (foco ativo)
  COR_EDIT_ERRO     = $00D6D6FF;  // vermelho claro (erro de validacao)
  COR_EDIT_READONLY = $00F0F0F0;  // cinza claro (readonly / browse)

  // Icones Segoe MDL2 Assets (Windows 10/11)
  ICN_PRIMEIRO  = #$E892; // Previous (First)
  ICN_ANTERIOR  = #$E76B; // ChevronLeft
  ICN_PROXIMO   = #$E76C; // ChevronRight
  ICN_ULTIMO    = #$E893; // Next (Last)
  ICN_INSERIR   = #$E710; // Add
  ICN_EDITAR    = #$E70F; // Edit
  ICN_GRAVAR    = #$E74E; // Save
  ICN_CANCELAR  = #$E711; // Cancel
  ICN_EXCLUIR   = #$E74D; // Delete
  ICN_ATUALIZAR = #$E72C; // Refresh
  ICN_SAIR      = #$E8BB; // ChromeClose

type
  TForm_Cliente = class(TForm)
    // Topo / estado
    Panel_Titulo: TPanel;
    PanelEstado: TPanel;
    LabelEstadoAtual: TLabel;

    // Corpo
    PanelDados: TPanel;

    PanelIdentificacao: TPanel;
    LabelSecaoIdent: TLabel;
    LabelCodigo: TLabel;
    DBEditCodigo: TDBEdit;
    LabelNome: TLabel;
    LabelNomeAst: TLabel;
    DBEditNome: TDBEdit;
    DBRadioTipo: TDBRadioGroup;
    LabelCpf: TLabel;
    DBEditCPF: TDBEdit;
    LabelCnpj: TLabel;
    DBEditCNPJ: TDBEdit;
    LabelCep: TLabel;
    DBEditCep: TDBEdit;
    LabelEndereco: TLabel;
    LabelEnderecoAst: TLabel;
    DBEditEndereco: TDBEdit;
    LabelNumero: TLabel;
    DBEditNumero: TDBEdit;
    LabelBairro: TLabel;
    LabelBairroAst: TLabel;
    DBEditBairro: TDBEdit;
    LabelCidade: TLabel;
    LabelCidadeAst: TLabel;
    DBEditCidade: TDBEdit;
    LabelTelefone: TLabel;
    DBEditTelefone: TDBEdit;

    PanelObservacao: TPanel;
    LabelObservacao: TLabel;
    DBMemoObs: TDBMemo;

    GroupBoxValores: TGroupBox;
    LabelRendaMensal: TLabel;
    DBEditRendaMensal: TDBEdit;
    LabelLimiteCredito: TLabel;
    DBEditLimiteCredito: TDBEdit;
    LabelTotalCompras: TLabel;
    DBEditCompras: TDBEdit;
    BtnAtualizar: TBitBtn;

    // Rodape
    PanelRodape: TPanel;
    BtnPrimeiro: TBitBtn;
    BtnAnterior: TBitBtn;
    BtnProximo: TBitBtn;
    BtnUltimo: TBitBtn;
    ShapeSep: TBevel;
    BtnInserir: TBitBtn;
    BtnEditar: TBitBtn;
    BtnGravar: TBitBtn;
    BtnCancelar: TBitBtn;
    BtnExcluir: TBitBtn;
    BtnSair: TBitBtn;

    // Nao-visuais
    QueryAtualizar: TIBQuery;
    ActionList: TActionList;
    ActPrimeiro: TAction;
    ActAnterior: TAction;
    ActProximo: TAction;
    ActUltimo: TAction;
    ActInserir: TAction;
    ActEditar: TAction;
    ActGravar: TAction;
    ActCancelar: TAction;
    ActExcluir: TAction;
    ActAtualizar: TAction;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormActivate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormResize(Sender: TObject);

    procedure BtnPrimeiroClick(Sender: TObject);
    procedure BtnAnteriorClick(Sender: TObject);
    procedure BtnProximoClick(Sender: TObject);
    procedure BtnUltimoClick(Sender: TObject);
    procedure BtnInserirClick(Sender: TObject);
    procedure BtnEditarClick(Sender: TObject);
    procedure BtnGravarClick(Sender: TObject);
    procedure BtnCancelarClick(Sender: TObject);
    procedure BtnCancelarMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BtnExcluirClick(Sender: TObject);
    procedure BtnAtualizarClick(Sender: TObject);
    procedure BtnSairClick(Sender: TObject);
    procedure BtnSairMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);

    procedure ActPrimeiroExecute(Sender: TObject);
    procedure ActAnteriorExecute(Sender: TObject);
    procedure ActProximoExecute(Sender: TObject);
    procedure ActUltimoExecute(Sender: TObject);
    procedure ActInserirExecute(Sender: TObject);
    procedure ActEditarExecute(Sender: TObject);
    procedure ActGravarExecute(Sender: TObject);
    procedure ActCancelarExecute(Sender: TObject);
    procedure ActExcluirExecute(Sender: TObject);
    procedure ActAtualizarExecute(Sender: TObject);

    procedure DBEditObrigatorioExit(Sender: TObject);
    procedure DBEditRendaMensalExit(Sender: TObject);
    procedure DBEditTelefoneEnter(Sender: TObject);
    procedure DBEditTelefoneKeyPress(Sender: TObject; var Key: Char);
    procedure DBEditTelefoneExit(Sender: TObject);
    procedure DBRadioTipoChange(Sender: TObject);
    procedure DBEditCPFEnter(Sender: TObject);
    procedure DBEditCPFExit(Sender: TObject);
    procedure DBEditCPFKeyPress(Sender: TObject; var Key: Char);
    procedure DBEditCNPJEnter(Sender: TObject);
    procedure DBEditCNPJExit(Sender: TObject);
    procedure DBEditCNPJKeyPress(Sender: TObject; var Key: Char);
    procedure DBEditCepEnter(Sender: TObject);
    procedure DBEditCepExit(Sender: TObject);
    procedure DBEditCepKeyPress(Sender: TObject; var Key: Char);
    procedure EditFocoEnter(Sender: TObject);
    procedure EditFocoExit(Sender: TObject);
  private
    FValidando: Boolean;
    FIgnorarValidacao: Boolean;
    FConsultandoDoc: Boolean;
    FAtualizandoUI: Boolean;
    FAplicandoMascara: Boolean;
    FAjustandoLayout: Boolean;
    FAlterandoTipo: Boolean;
    FAplicandoVisibilidade: Boolean;
    FOldDataChange: TDataChangeEvent;
    FOldStateChange: TNotifyEvent;
    FBalloonHint: TBalloonHint;
    FCampoComErro: TWinControl;
    FObserveEnterControl: string;
    FObserveEnterValue: string;

    procedure ConfigurarGlyphsBotoes;
    procedure ConfigurarCampoTelefone;
    procedure ConfigurarCamposDocumento;
    procedure AplicarMascarasExibicao;
    procedure AplicarLayoutInicial;
    procedure AjustarLayoutResponsivo;
    procedure AtualizarEstadoUI;
    procedure AplicarVisibilidadeDocumento(LimparOculto: Boolean);
    procedure ProcessarAlteracaoTipo;
    function TipoPessoaAtual: string;
    function TipoSelecionadoNoRadio: string;
    function FocoEhCancelarOuSair: Boolean;
    procedure AplicarDadosCnpj(const Dados: TDadosCnpj);
    procedure AplicarDadosCep(const Dados: TDadosCep);

    function SoDigitos(const S: string): string;
    function FormatarTelefone(const Digitos: string; out Formatado: string): Boolean;
    procedure DefinirCorFundo(Ctrl: TWinControl; Cor: TColor);
    function ControleEmSomenteLeitura(Ctrl: TWinControl): Boolean;

    procedure DsClienteDataChangeChained(Sender: TObject; Field: TField);
    procedure DsClienteStateChangeChained(Sender: TObject);

    function ValidarCamposObrigatorios: Boolean;
    procedure MostrarBaloonErro(Edit: TCustomEdit; const Titulo, Texto: string);
    procedure ReagendarFocoNoCampo(Edit: TWinControl);
    procedure FocarControleSeguro(Ctrl: TWinControl);
    procedure WMRefocar(var Msg: TMessage); message WM_REFOCAR;
    procedure WMAplicarTipo(var Msg: TMessage); message WM_APLICAR_TIPO;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
  end;

var
  Form_Cliente: TForm_Cliente;

implementation

uses DataModule, Mensagens, ObserveHooks, UITheme;

{$R *.dfm}

{ Utilitarios locais }

procedure TForm_Cliente.ConfigurarGlyphsBotoes;
begin
  AplicarBotaoBootstrap(BtnPrimeiro, bbkOutline, ICN_PRIMEIRO);
  AplicarBotaoBootstrap(BtnAnterior, bbkOutline, ICN_ANTERIOR);
  AplicarBotaoBootstrap(BtnProximo, bbkOutline, ICN_PROXIMO);
  AplicarBotaoBootstrap(BtnUltimo, bbkOutline, ICN_ULTIMO);
  AplicarBotaoBootstrap(BtnInserir, bbkSuccess, ICN_INSERIR);
  AplicarBotaoBootstrap(BtnEditar, bbkWarning, ICN_EDITAR);
  AplicarBotaoBootstrap(BtnGravar, bbkPrimary, ICN_GRAVAR);
  AplicarBotaoBootstrap(BtnCancelar, bbkSecondary, ICN_CANCELAR);
  AplicarBotaoBootstrap(BtnExcluir, bbkDanger, ICN_EXCLUIR);
  AplicarBotaoBootstrap(BtnAtualizar, bbkOutline, ICN_ATUALIZAR);
  AplicarBotaoBootstrap(BtnSair, bbkSecondary, ICN_SAIR);
end;

procedure TForm_Cliente.ConfigurarCampoTelefone;
begin
  // A mascara nao e aplicada no TField para evitar EDBEditError quando
  // o usuario tenta sair do campo com valor incompleto/vazio.
  // O formato so e aplicado apos a digitacao (ver DBEditTelefoneExit).
  if Assigned(Dm.SqlClienteTELEFONE) then
    Dm.SqlClienteTELEFONE.EditMask := '';
end;

procedure TForm_Cliente.ConfigurarCamposDocumento;
begin
  // Mascaras sao so visuais (;0; = sem literais na persistencia).
  // Aplicadas em AplicarMascarasExibicao / OnExit; limpas no OnEnter.
  if Assigned(Dm.SqlClienteCPF) then
    Dm.SqlClienteCPF.EditMask := '';
  if Assigned(Dm.SqlClienteCNPJ) then
    Dm.SqlClienteCNPJ.EditMask := '';
  if Assigned(Dm.SqlClienteCEP) then
    Dm.SqlClienteCEP.EditMask := '';
end;

procedure TForm_Cliente.AplicarMascarasExibicao;
var
  Digitos, Base, NovaMascara: string;
  Fld: TField;

  procedure DefinirMascaraSeDiferente(AField: TField; const AMascara: string);
  begin
    // So atribui quando muda: EditMask dispara DataChange e reentraria em
    // AtualizarEstadoUI / AplicarMascarasExibicao (stack overflow).
    if Assigned(AField) and (AField.EditMask <> AMascara) then
      AField.EditMask := AMascara;
  end;

begin
  // Formata CPF/CNPJ/CEP ao exibir/navegar. Nao mexe no campo com foco
  // (usuario pode estar digitando sem mascara).
  if FAplicandoMascara then
    Exit;
  if not Assigned(Dm) or not Assigned(Dm.SqlCliente) then
    Exit;
  if (not Dm.SqlCliente.Active) then
    Exit;

  FAplicandoMascara := True;
  try
    if Assigned(DBEditCPF.Field) and DBEditCPF.Visible and
       (ActiveControl <> DBEditCPF) then
    begin
      Fld := DBEditCPF.Field;
      Digitos := SomenteDigitosDoc(Fld.AsString);
      if Length(Digitos) = 11 then
        NovaMascara := '000.000.000-00;0;'
      else
        NovaMascara := '';
      DefinirMascaraSeDiferente(Fld, NovaMascara);
    end;

    if Assigned(DBEditCNPJ.Field) and DBEditCNPJ.Visible and
       (ActiveControl <> DBEditCNPJ) then
    begin
      Fld := DBEditCNPJ.Field;
      Base := SomenteAlfaNumDoc(Fld.AsString);
      if Length(Base) = 14 then
      begin
        if SomenteDigitosDoc(Base) = Base then
          NovaMascara := '00.000.000/0000-00;0;'
        else
          NovaMascara := 'AA.AAA.AAA/AAAA-00;0;';
      end
      else
        NovaMascara := '';
      DefinirMascaraSeDiferente(Fld, NovaMascara);
    end;

    if Assigned(DBEditCep.Field) and (ActiveControl <> DBEditCep) then
    begin
      Fld := DBEditCep.Field;
      Digitos := SomenteDigitosDoc(Fld.AsString);
      if Length(Digitos) = 8 then
        NovaMascara := '00000-000;0;'
      else
        NovaMascara := '';
      DefinirMascaraSeDiferente(Fld, NovaMascara);
    end;
  finally
    FAplicandoMascara := False;
  end;
end;

function TForm_Cliente.SoDigitos(const S: string): string;
var
  Ch: Char;
begin
  Result := '';
  for Ch in S do
    if CharInSet(Ch, ['0'..'9']) then
      Result := Result + Ch;
end;

function TForm_Cliente.FormatarTelefone(const Digitos: string;
  out Formatado: string): Boolean;
begin
  Result := True;
  case Length(Digitos) of
    10:
      // Fixo com DDD: (XX) XXXX-XXXX
      Formatado := Format('(%s) %s-%s',
        [Copy(Digitos, 1, 2), Copy(Digitos, 3, 4), Copy(Digitos, 7, 4)]);
    11:
      // Celular com DDD: (XX) XXXXX-XXXX
      Formatado := Format('(%s) %s-%s',
        [Copy(Digitos, 1, 2), Copy(Digitos, 3, 5), Copy(Digitos, 8, 4)]);
  else
    Formatado := Digitos;
    Result := False;
  end;
end;

procedure TForm_Cliente.AplicarLayoutInicial;
begin
  // Mesmo shell do Form_Login: bsNone, fundo COR_PAGE, header Primary,
  // card branco com margens e rodape limpo.
  BorderStyle := bsNone;
  BorderIcons := [];
  Constraints.MinWidth := 920;
  Constraints.MinHeight := 683;
  Color := COR_PAGE;
  AplicarHeaderPrimary(Panel_Titulo);
  AplicarFormEstiloWeb(Self);

  PanelEstado.ParentBackground := False;
  PanelEstado.BevelOuter := bvNone;
  PanelEstado.Color := COR_ESTADO_BROWSE_BG;
  LabelEstadoAtual.Font.Color := COR_ESTADO_BROWSE_FG;

  AplicarPainelCard(PanelDados);
  PanelDados.AlignWithMargins := True;
  PanelDados.Margins.SetBounds(24, 16, 24, 8);
  PanelDados.Color := COR_CARD;

  // Secoes internas no mesmo fundo do card (evita "card sobre card").
  PanelIdentificacao.ParentBackground := False;
  PanelIdentificacao.BevelOuter := bvNone;
  PanelIdentificacao.Color := COR_CARD;
  PanelObservacao.ParentBackground := False;
  PanelObservacao.BevelOuter := bvNone;
  PanelObservacao.Color := COR_CARD;
  AplicarGrupoCard(GroupBoxValores);

  PanelRodape.ParentBackground := False;
  PanelRodape.BevelOuter := bvNone;
  PanelRodape.Color := COR_PAGE;
  LabelSecaoIdent.Font.Color := COR_PRIMARY;
  GroupBoxValores.Font.Color := COR_PRIMARY;

  // Marcadores visuais dos campos obrigatorios (asterisco vermelho).
  LabelNomeAst.Font.Color     := clRed;
  LabelEnderecoAst.Font.Color := clRed;
  LabelBairroAst.Font.Color   := clRed;
  LabelCidadeAst.Font.Color   := clRed;

  AjustarLayoutResponsivo;
end;

procedure TForm_Cliente.AjustarLayoutResponsivo;
const
  MARGEM = 14;
  GAP = 6;
  GAP_GRUPO = 14;
  PAD = 12;
var
  X: Integer;
  LarguraUtil: Integer;
  Meio: Integer;
  GapMid: Integer;
  ColW: Integer;
begin
  if FAjustandoLayout then
    Exit;
  if not Assigned(PanelRodape) then
    Exit;

  FAjustandoLayout := True;
  try
  // Rodape: navegacao + acoes a esquerda; Sair colado a direita.
  X := MARGEM;
  BtnPrimeiro.Left := X;
  Inc(X, BtnPrimeiro.Width + GAP);
  BtnAnterior.Left := X;
  Inc(X, BtnAnterior.Width + GAP);
  BtnProximo.Left := X;
  Inc(X, BtnProximo.Width + GAP);
  BtnUltimo.Left := X;
  Inc(X, BtnUltimo.Width + GAP_GRUPO);
  ShapeSep.Left := X;
  Inc(X, ShapeSep.Width + GAP_GRUPO);
  BtnInserir.Left := X;
  Inc(X, BtnInserir.Width + GAP);
  BtnEditar.Left := X;
  Inc(X, BtnEditar.Width + GAP);
  BtnGravar.Left := X;
  Inc(X, BtnGravar.Width + GAP);
  BtnCancelar.Left := X;
  Inc(X, BtnCancelar.Width + GAP);
  BtnExcluir.Left := X;
  Inc(X, BtnExcluir.Width + GAP);
  BtnSair.Left := PanelRodape.ClientWidth - BtnSair.Width - MARGEM;
  if BtnSair.Left < X then
    BtnSair.Left := X;

  // Identificacao: Nome estica; Endereco + Numero; Bairro|Cidade 50/50.
  if Assigned(PanelIdentificacao) and (PanelIdentificacao.ClientWidth > 40) then
  begin
    DBEditNome.Width := PanelIdentificacao.ClientWidth - DBEditNome.Left - PAD;

    GapMid := 12;
    ColW := 90;
    DBEditEndereco.Width :=
      PanelIdentificacao.ClientWidth - DBEditEndereco.Left - PAD - ColW - GapMid;
    if DBEditEndereco.Width < 120 then
      DBEditEndereco.Width := 120;
    DBEditNumero.Left := DBEditEndereco.Left + DBEditEndereco.Width + GapMid;
    DBEditNumero.Width := ColW;
    LabelNumero.Left := DBEditNumero.Left;

    LarguraUtil := PanelIdentificacao.ClientWidth - (PAD * 2) - GapMid;
    if LarguraUtil < 100 then
      LarguraUtil := 100;
    Meio := LarguraUtil div 2;
    DBEditBairro.Left := PAD;
    DBEditBairro.Width := Meio;
    DBEditCidade.Left := DBEditBairro.Left + Meio + GapMid;
    DBEditCidade.Width := PanelIdentificacao.ClientWidth - DBEditCidade.Left - PAD;
    LabelCidade.Left := DBEditCidade.Left;
    LabelCidadeAst.Left := LabelCidade.Left + LabelCidade.Width + 4;
  end;

  // Observacao: memo preenche o card.
  if Assigned(PanelObservacao) and (PanelObservacao.ClientWidth > 40) then
  begin
    DBMemoObs.Width := PanelObservacao.ClientWidth - DBMemoObs.Left - PAD;
    DBMemoObs.Height := PanelObservacao.ClientHeight - DBMemoObs.Top - PAD;
  end;

  // Valores: tres colunas proporcionais + botao a direita.
  if Assigned(GroupBoxValores) and (GroupBoxValores.ClientWidth > 40) then
  begin
    GapMid := 16;
    LarguraUtil := GroupBoxValores.ClientWidth - (16 * 2) - (GapMid * 2);
    ColW := LarguraUtil div 3;
    if ColW < 120 then
      ColW := 120;
    DBEditRendaMensal.Left := 16;
    DBEditRendaMensal.Width := ColW;
    LabelRendaMensal.Left := DBEditRendaMensal.Left;
    DBEditLimiteCredito.Left := DBEditRendaMensal.Left + ColW + GapMid;
    DBEditLimiteCredito.Width := ColW;
    LabelLimiteCredito.Left := DBEditLimiteCredito.Left;
    DBEditCompras.Left := DBEditLimiteCredito.Left + ColW + GapMid;
    DBEditCompras.Width := ColW;
    LabelTotalCompras.Left := DBEditCompras.Left;
    BtnAtualizar.Left := GroupBoxValores.ClientWidth - BtnAtualizar.Width - 16;
    if BtnAtualizar.Left < 16 then
      BtnAtualizar.Left := 16;
  end;
  finally
    FAjustandoLayout := False;
  end;
end;

procedure TForm_Cliente.FormResize(Sender: TObject);
begin
  AjustarLayoutResponsivo;
end;

function TForm_Cliente.ControleEmSomenteLeitura(Ctrl: TWinControl): Boolean;
begin
  Result := False;
  if Ctrl is TDBEdit then
    Result := TDBEdit(Ctrl).ReadOnly
  else if Ctrl is TDBMemo then
    Result := TDBMemo(Ctrl).ReadOnly;
end;

procedure TForm_Cliente.DefinirCorFundo(Ctrl: TWinControl; Cor: TColor);
begin
  if Ctrl is TDBEdit then
    TDBEdit(Ctrl).Color := Cor
  else if Ctrl is TDBMemo then
    TDBMemo(Ctrl).Color := Cor;
end;

procedure TForm_Cliente.EditFocoEnter(Sender: TObject);
begin
  // Nao altera cor de campos em somente-leitura (mantem o cinza).
  if not (Sender is TWinControl) then
    Exit;
  if Sender is TControl then
  begin
    FObserveEnterControl := TControl(Sender).Name;
    if Sender is TCustomEdit then
      FObserveEnterValue := TCustomEdit(Sender).Text
    else
      FObserveEnterValue := '';
  end;
  if ControleEmSomenteLeitura(TWinControl(Sender)) then
    Exit;
  // Campo re-focado por erro de validacao permanece em vermelho claro
  // (sem isso, o realce de foco apagaria a cor de erro aplicada no OnExit).
  if Sender = FCampoComErro then
    DefinirCorFundo(TWinControl(Sender), COR_EDIT_ERRO)
  else
    DefinirCorFundo(TWinControl(Sender), COR_EDIT_FOCO);
end;

procedure TForm_Cliente.EditFocoExit(Sender: TObject);
var
  Novo: string;
begin
  if not (Sender is TWinControl) then
    Exit;
  if (Sender is TCustomEdit) and (TControl(Sender).Name = FObserveEnterControl) then
  begin
    Novo := TCustomEdit(Sender).Text;
    ObserveLogFill(Self, TControl(Sender).Name, FObserveEnterValue, Novo);
  end;
  if ControleEmSomenteLeitura(TWinControl(Sender)) then
    Exit;
  DefinirCorFundo(TWinControl(Sender), COR_EDIT_NORMAL);
end;

procedure TForm_Cliente.AtualizarEstadoUI;
var
  Estado: TDataSetState;
  ModoTexto: string;
  CorFundo, CorTexto: TColor;
  EmEdicao: Boolean;
begin
  // Reentrada: AplicarMascaras / Visible / ReadOnly podem disparar DataChange.
  if FAtualizandoUI then
    Exit;
  if not Assigned(Dm) or not Assigned(Dm.SqlCliente) then
    Exit;

  FAtualizandoUI := True;
  try
    Estado    := Dm.SqlCliente.State;
    EmEdicao  := Estado in [dsInsert, dsEdit];

    case Estado of
      dsInsert:
        begin
          ModoTexto := 'MODO: INSERINDO';
          CorFundo  := COR_ESTADO_INSERT_BG;
          CorTexto  := COR_ESTADO_INSERT_FG;
        end;
      dsEdit:
        begin
          ModoTexto := 'MODO: EDITANDO';
          CorFundo  := COR_ESTADO_EDIT_BG;
          CorTexto  := COR_ESTADO_EDIT_FG;
        end;
      dsBrowse:
        begin
          ModoTexto := 'MODO: NAVEGACAO';
          CorFundo  := COR_ESTADO_BROWSE_BG;
          CorTexto  := COR_ESTADO_BROWSE_FG;
        end;
    else
      ModoTexto := 'MODO: ' + IntToStr(Ord(Estado));
      CorFundo  := COR_ESTADO_BROWSE_BG;
      CorTexto  := COR_ESTADO_BROWSE_FG;
    end;

    PanelEstado.Color            := CorFundo;
    LabelEstadoAtual.Caption     := ModoTexto;
    LabelEstadoAtual.Font.Color  := CorTexto;

    // Bloqueia edicao dos DBEdits fora de Insert/Edit (evita alterar campo
    // sem estar no modo apropriado).
    DBEditNome.ReadOnly        := not EmEdicao;
    DBEditCPF.ReadOnly         := not EmEdicao;
    DBEditCNPJ.ReadOnly        := not EmEdicao;
    DBEditCep.ReadOnly         := not EmEdicao;
    DBEditEndereco.ReadOnly    := not EmEdicao;
    DBEditNumero.ReadOnly      := not EmEdicao;
    DBEditBairro.ReadOnly      := not EmEdicao;
    DBEditCidade.ReadOnly      := not EmEdicao;
    DBEditTelefone.ReadOnly    := not EmEdicao;
    DBMemoObs.ReadOnly         := not EmEdicao;
    DBEditRendaMensal.ReadOnly := not EmEdicao;
    DBRadioTipo.ReadOnly       := not EmEdicao;

    // Cor de fundo dos campos editaveis segue o modo do dataset.
    // Em Insert/Edit ficam brancos (prontos para digitacao); em Browse
    // ficam cinza claro, indicando que estao bloqueados.
    if EmEdicao then
    begin
      DBEditNome.Color        := COR_EDIT_NORMAL;
      DBEditCPF.Color         := COR_EDIT_NORMAL;
      DBEditCNPJ.Color        := COR_EDIT_NORMAL;
      DBEditCep.Color         := COR_EDIT_NORMAL;
      DBEditEndereco.Color    := COR_EDIT_NORMAL;
      DBEditNumero.Color      := COR_EDIT_NORMAL;
      DBEditBairro.Color      := COR_EDIT_NORMAL;
      DBEditCidade.Color      := COR_EDIT_NORMAL;
      DBEditTelefone.Color    := COR_EDIT_NORMAL;
      DBMemoObs.Color         := COR_EDIT_NORMAL;
      DBEditRendaMensal.Color := COR_EDIT_NORMAL;
    end
    else
    begin
      DBEditNome.Color        := COR_EDIT_READONLY;
      DBEditCPF.Color         := COR_EDIT_READONLY;
      DBEditCNPJ.Color        := COR_EDIT_READONLY;
      DBEditCep.Color         := COR_EDIT_READONLY;
      DBEditEndereco.Color    := COR_EDIT_READONLY;
      DBEditNumero.Color      := COR_EDIT_READONLY;
      DBEditBairro.Color      := COR_EDIT_READONLY;
      DBEditCidade.Color      := COR_EDIT_READONLY;
      DBEditTelefone.Color    := COR_EDIT_READONLY;
      DBMemoObs.Color         := COR_EDIT_READONLY;
      DBEditRendaMensal.Color := COR_EDIT_READONLY;
    end;

    AplicarVisibilidadeDocumento(False);

    // BtnAtualizar so faz sentido em navegacao com registro corrente.
    BtnAtualizar.Enabled :=
      (Estado = dsBrowse) and Assigned(DBEditCodigo.Field) and
      (not DBEditCodigo.Field.IsNull);

    AplicarMascarasExibicao;
  finally
    FAtualizandoUI := False;
  end;
end;

{ Chained events do DataSource (preservam o comportamento definido no DataModule) }

procedure TForm_Cliente.DsClienteDataChangeChained(Sender: TObject;
  Field: TField);
begin
  if Assigned(FOldDataChange) then
    FOldDataChange(Sender, Field);
  // Evita reentrada quando EditMask / AsString / TIPO dispararam DataChange.
  if FAtualizandoUI or FAplicandoMascara or FAlterandoTipo or
     FAplicandoVisibilidade then
    Exit;
  AtualizarEstadoUI;
  if (Field = nil) or SameText(Field.FieldName, 'TIPO') then
    AplicarVisibilidadeDocumento(False);
end;

procedure TForm_Cliente.DsClienteStateChangeChained(Sender: TObject);
begin
  if Assigned(FOldStateChange) then
    FOldStateChange(Sender);
  if FAtualizandoUI or FAlterandoTipo then
    Exit;
  AtualizarEstadoUI;
end;

{ Validacoes }

function TForm_Cliente.TipoSelecionadoNoRadio: string;
begin
  // ItemIndex e mais confiavel que Value durante o OnChange do radio.
  case DBRadioTipo.ItemIndex of
    0: Result := 'F';
    1: Result := 'J';
  else
    begin
      Result := UpperCase(Trim(DBRadioTipo.Value));
      if (Result <> 'F') and (Result <> 'J') then
        Result := '';
    end;
  end;
end;

function TForm_Cliente.TipoPessoaAtual: string;
begin
  // Somente le o dataset - nunca grava F aqui (evita sobrescrever J).
  Result := 'F';
  if Assigned(Dm) and Assigned(Dm.SqlCliente) and
     Assigned(Dm.SqlCliente.FindField('TIPO')) and
     (not Dm.SqlCliente.FieldByName('TIPO').IsNull) then
  begin
    Result := UpperCase(Trim(Dm.SqlCliente.FieldByName('TIPO').AsString));
    if (Result <> 'F') and (Result <> 'J') then
      Result := 'F';
  end;
end;

function TForm_Cliente.FocoEhCancelarOuSair: Boolean;
var
  FocoDestino: HWND;
begin
  Result := False;
  FocoDestino := GetFocus;
  if FocoDestino = 0 then
    Exit;
  Result :=
    (BtnCancelar.HandleAllocated and (FocoDestino = BtnCancelar.Handle)) or
    (BtnSair.HandleAllocated and (FocoDestino = BtnSair.Handle));
end;

procedure TForm_Cliente.AplicarVisibilidadeDocumento(LimparOculto: Boolean);
var
  EhPF: Boolean;
  Fld: TField;
begin
  if FAplicandoVisibilidade then
    Exit;

  FAplicandoVisibilidade := True;
  try
    EhPF := TipoPessoaAtual <> 'J';

    // So altera Visible quando muda (evita Resize/DataChange desnecessario).
    if LabelCpf.Visible <> EhPF then
      LabelCpf.Visible := EhPF;
    if DBEditCPF.Visible <> EhPF then
      DBEditCPF.Visible := EhPF;
    DBEditCPF.TabStop := EhPF;

    if LabelCnpj.Visible <> (not EhPF) then
      LabelCnpj.Visible := not EhPF;
    if DBEditCNPJ.Visible <> (not EhPF) then
      DBEditCNPJ.Visible := not EhPF;
    DBEditCNPJ.TabStop := not EhPF;

    if LimparOculto and Assigned(Dm) and Assigned(Dm.SqlCliente) and
       (Dm.SqlCliente.State in [dsInsert, dsEdit]) then
    begin
      if EhPF then
      begin
        Fld := Dm.SqlCliente.FindField('CNPJ');
        if Assigned(Fld) and (not Fld.IsNull) then
        begin
          Fld.EditMask := '';
          Fld.Clear;
        end;
      end
      else
      begin
        Fld := Dm.SqlCliente.FindField('CPF');
        if Assigned(Fld) and (not Fld.IsNull) then
        begin
          Fld.EditMask := '';
          Fld.Clear;
        end;
      end;
    end;
  finally
    FAplicandoVisibilidade := False;
  end;
end;

procedure TForm_Cliente.ProcessarAlteracaoTipo;
var
  NovoTipo, TipoAtual: string;
  FldTipo: TField;
begin
  if FAlterandoTipo or FAtualizandoUI then
    Exit;
  if not Assigned(Dm) or not Assigned(Dm.SqlCliente) then
    Exit;

  // Em navegacao o radio e ReadOnly: so sincroniza UI a partir do dataset.
  if not (Dm.SqlCliente.State in [dsInsert, dsEdit]) then
  begin
    AplicarVisibilidadeDocumento(False);
    Exit;
  end;

  NovoTipo := TipoSelecionadoNoRadio;
  if (NovoTipo <> 'F') and (NovoTipo <> 'J') then
    Exit;

  FAlterandoTipo := True;
  try
    FldTipo := Dm.SqlCliente.FindField('TIPO');
    if not Assigned(FldTipo) then
      Exit;

    TipoAtual := UpperCase(Trim(FldTipo.AsString));
    // Garante persistencia de J/F mesmo se o DataLink ainda nao gravou.
    if TipoAtual <> NovoTipo then
      FldTipo.AsString := NovoTipo;

    AplicarVisibilidadeDocumento(True);
  finally
    FAlterandoTipo := False;
  end;

  // Atualiza cores/readonly/mascaras fora do lock de TIPO.
  AtualizarEstadoUI;
end;

procedure TForm_Cliente.AplicarDadosCep(const Dados: TDadosCep);
begin
  if not Assigned(Dm) or not Assigned(Dm.SqlCliente) then
    Exit;
  if not (Dm.SqlCliente.State in [dsInsert, dsEdit]) then
    Exit;
  if Dados.Logradouro <> '' then
    Dm.SqlCliente.FieldByName('ENDERECO').AsString := Dados.Logradouro;
  if Dados.Bairro <> '' then
    Dm.SqlCliente.FieldByName('BAIRRO').AsString := Dados.Bairro;
  if Dados.Cidade <> '' then
    Dm.SqlCliente.FieldByName('CIDADE').AsString := Dados.Cidade;
end;

procedure TForm_Cliente.AplicarDadosCnpj(const Dados: TDadosCnpj);
var
  Nome: string;
  TelFmt: string;
begin
  if not Assigned(Dm) or not Assigned(Dm.SqlCliente) then
    Exit;
  if not (Dm.SqlCliente.State in [dsInsert, dsEdit]) then
    Exit;

  if Dados.NomeFantasia <> '' then
    Nome := Dados.NomeFantasia
  else
    Nome := Dados.RazaoSocial;
  if Nome <> '' then
    Dm.SqlCliente.FieldByName('NOME').AsString := Nome;
  if Dados.Logradouro <> '' then
    Dm.SqlCliente.FieldByName('ENDERECO').AsString := Dados.Logradouro;
  if Dados.Numero <> '' then
    Dm.SqlCliente.FieldByName('NUMERO').AsString := Copy(Dados.Numero, 1, 10);
  if Dados.Bairro <> '' then
    Dm.SqlCliente.FieldByName('BAIRRO').AsString := Dados.Bairro;
  if Dados.Municipio <> '' then
    Dm.SqlCliente.FieldByName('CIDADE').AsString := Dados.Municipio;
  if Dados.Cep <> '' then
    Dm.SqlCliente.FieldByName('CEP').AsString := Copy(SomenteDigitosDoc(Dados.Cep), 1, 8);
  if Dados.Telefone <> '' then
  begin
    if FormatarTelefone(SomenteDigitosDoc(Dados.Telefone), TelFmt) then
      Dm.SqlCliente.FieldByName('TELEFONE').AsString := TelFmt
    else
      Dm.SqlCliente.FieldByName('TELEFONE').AsString :=
        Copy(SomenteDigitosDoc(Dados.Telefone), 1, 16);
  end;
end;

procedure TForm_Cliente.DBRadioTipoChange(Sender: TObject);
begin
  if FAtualizandoUI or FAlterandoTipo or FAplicandoVisibilidade then
    Exit;
  // Adia: no Click do TDBRadioGroup o OnChange pode rodar antes de
  // Field.Text := Value. Clear de CPF/CNPJ no mesmo stack dispara
  // DataChange e o radio volta a ler TIPO antigo (F).
  if HandleAllocated then
    PostMessage(Handle, WM_APLICAR_TIPO, 0, 0)
  else
    ProcessarAlteracaoTipo;
end;

procedure TForm_Cliente.DBEditCPFEnter(Sender: TObject);
begin
  EditFocoEnter(Sender);
  // Remove mascara visual para editar so os digitos (banco Size=11).
  if not Assigned(DBEditCPF.Field) then
    Exit;
  if not Assigned(Dm) or not Assigned(Dm.SqlCliente) then
    Exit;
  if not (Dm.SqlCliente.State in [dsInsert, dsEdit]) then
    Exit;
  DBEditCPF.Field.EditMask := '';
  if Trim(DBEditCPF.Field.AsString) <> '' then
    DBEditCPF.Field.AsString := SomenteDigitosDoc(DBEditCPF.Field.AsString);
end;

procedure TForm_Cliente.DBEditCNPJEnter(Sender: TObject);
begin
  EditFocoEnter(Sender);
  // Remove mascara visual para editar base alfanumerica (Size=14).
  if not Assigned(DBEditCNPJ.Field) then
    Exit;
  if not Assigned(Dm) or not Assigned(Dm.SqlCliente) then
    Exit;
  if not (Dm.SqlCliente.State in [dsInsert, dsEdit]) then
    Exit;
  DBEditCNPJ.Field.EditMask := '';
  if Trim(DBEditCNPJ.Field.AsString) <> '' then
    DBEditCNPJ.Field.AsString := SomenteAlfaNumDoc(DBEditCNPJ.Field.AsString);
end;

procedure TForm_Cliente.DBEditCepEnter(Sender: TObject);
begin
  EditFocoEnter(Sender);
  // Remove mascara visual para editar so os digitos (Size=8).
  if not Assigned(DBEditCep.Field) then
    Exit;
  if not Assigned(Dm) or not Assigned(Dm.SqlCliente) then
    Exit;
  if not (Dm.SqlCliente.State in [dsInsert, dsEdit]) then
    Exit;
  DBEditCep.Field.EditMask := '';
  if Trim(DBEditCep.Field.AsString) <> '' then
    DBEditCep.Field.AsString := SomenteDigitosDoc(DBEditCep.Field.AsString);
end;

procedure TForm_Cliente.DBEditCPFKeyPress(Sender: TObject; var Key: Char);
var
  Qtd: Integer;
  Ch: Char;
begin
  if CharInSet(Key, [#8, #9, #13, #27]) then
    Exit;
  if not CharInSet(Key, ['0'..'9', '.', '-']) then
  begin
    Key := #0;
    Exit;
  end;
  if CharInSet(Key, ['0'..'9']) and (DBEditCPF.SelLength = 0) then
  begin
    Qtd := 0;
    for Ch in DBEditCPF.Text do
      if CharInSet(Ch, ['0'..'9']) then
        Inc(Qtd);
    if Qtd >= 11 then
      Key := #0;
  end;
end;

procedure TForm_Cliente.DBEditCNPJKeyPress(Sender: TObject; var Key: Char);
var
  Qtd: Integer;
  Ch, U: Char;
begin
  if CharInSet(Key, [#8, #9, #13, #27]) then
    Exit;
  U := UpCase(Key);
  if not CharInSet(U, ['0'..'9', 'A'..'Z', '.', '/', '-']) then
  begin
    Key := #0;
    Exit;
  end;
  if CharInSet(U, ['0'..'9', 'A'..'Z']) and (DBEditCNPJ.SelLength = 0) then
  begin
    Qtd := 0;
    for Ch in DBEditCNPJ.Text do
      if CharInSet(UpCase(Ch), ['0'..'9', 'A'..'Z']) then
        Inc(Qtd);
    if Qtd >= 14 then
      Key := #0;
  end;
end;

procedure TForm_Cliente.DBEditCepKeyPress(Sender: TObject; var Key: Char);
var
  Qtd: Integer;
  Ch: Char;
begin
  if CharInSet(Key, [#8, #9, #13, #27]) then
    Exit;
  if not CharInSet(Key, ['0'..'9', '-']) then
  begin
    Key := #0;
    Exit;
  end;
  if CharInSet(Key, ['0'..'9']) and (DBEditCep.SelLength = 0) then
  begin
    Qtd := 0;
    for Ch in DBEditCep.Text do
      if CharInSet(Ch, ['0'..'9']) then
        Inc(Qtd);
    if Qtd >= 8 then
      Key := #0;
  end;
end;

procedure TForm_Cliente.DBEditCPFExit(Sender: TObject);
var
  Digitos: string;
begin
  if FValidando or FConsultandoDoc then
    Exit;

  EditFocoExit(Sender);
  if FCampoComErro = DBEditCPF then
    FCampoComErro := nil;

  if FIgnorarValidacao then
    Exit;
  if csDestroying in ComponentState then
    Exit;
  if not Assigned(Dm) or not Assigned(Dm.SqlCliente) then
    Exit;
  if not (Dm.SqlCliente.State in [dsInsert, dsEdit]) then
    Exit;
  if not DBEditCPF.Visible then
    Exit;
  if not Assigned(DBEditCPF.Field) then
    Exit;
  if FocoEhCancelarOuSair then
    Exit;

  Digitos := SomenteDigitosDoc(DBEditCPF.Text);
  if Digitos = '' then
  begin
    DBEditCPF.Field.EditMask := '';
    DBEditCPF.Field.AsString := '';
    Exit;
  end;

  if not ValidarCpf(Digitos) then
  begin
    DBEditCPF.Field.EditMask := '';
    DBEditCPF.Color := COR_EDIT_ERRO;
    FCampoComErro := DBEditCPF;
    MostrarBaloonErro(DBEditCPF, 'CPF invalido',
      'Informe um CPF valido (digitos verificadores).');
    ReagendarFocoNoCampo(DBEditCPF);
    Exit;
  end;

  // Persiste so digitos (Size=11); mascara visual apos validar (;0; = sem literais).
  DBEditCPF.Field.EditMask := '';
  DBEditCPF.Field.AsString := Digitos;
  DBEditCPF.Field.EditMask := '000.000.000-00;0;';
  // Sem API publica gratuita de CPF (LGPD): apenas validacao local.
end;

procedure TForm_Cliente.DBEditCNPJExit(Sender: TObject);
var
  Base, Erro: string;
  Dados: TDadosCnpj;
begin
  if FValidando or FConsultandoDoc then
    Exit;

  EditFocoExit(Sender);
  if FCampoComErro = DBEditCNPJ then
    FCampoComErro := nil;

  if FIgnorarValidacao then
    Exit;
  if csDestroying in ComponentState then
    Exit;
  if not Assigned(Dm) or not Assigned(Dm.SqlCliente) then
    Exit;
  if not (Dm.SqlCliente.State in [dsInsert, dsEdit]) then
    Exit;
  if not DBEditCNPJ.Visible then
    Exit;
  if not Assigned(DBEditCNPJ.Field) then
    Exit;
  if FocoEhCancelarOuSair then
    Exit;

  Base := SomenteAlfaNumDoc(DBEditCNPJ.Text);
  if Base = '' then
  begin
    DBEditCNPJ.Field.EditMask := '';
    DBEditCNPJ.Field.AsString := '';
    Exit;
  end;

  if not ValidarCnpj(Base) then
  begin
    DBEditCNPJ.Field.EditMask := '';
    DBEditCNPJ.Color := COR_EDIT_ERRO;
    FCampoComErro := DBEditCNPJ;
    MostrarBaloonErro(DBEditCNPJ, 'CNPJ invalido',
      'Informe um CNPJ valido (regra alfanumerica / modulo 11).');
    ReagendarFocoNoCampo(DBEditCNPJ);
    Exit;
  end;

  // Persiste base limpa (Size=14); mascara visual apos validar.
  DBEditCNPJ.Field.EditMask := '';
  DBEditCNPJ.Field.AsString := Base;
  if SomenteDigitosDoc(Base) = Base then
    DBEditCNPJ.Field.EditMask := '00.000.000/0000-00;0;'
  else
    DBEditCNPJ.Field.EditMask := 'AA.AAA.AAA/AAAA-00;0;';

  FConsultandoDoc := True;
  try
    if ConsultarCnpjBrasilApi(Base, Dados, Erro) then
      AplicarDadosCnpj(Dados)
    else if Erro <> '' then
      ShowMessage(Erro);
  finally
    FConsultandoDoc := False;
  end;
end;

procedure TForm_Cliente.DBEditCepExit(Sender: TObject);
var
  Digitos, Erro: string;
  Dados: TDadosCep;
begin
  if FValidando or FConsultandoDoc then
    Exit;

  EditFocoExit(Sender);
  if FCampoComErro = DBEditCep then
    FCampoComErro := nil;

  if FIgnorarValidacao then
    Exit;
  if csDestroying in ComponentState then
    Exit;
  if not Assigned(Dm) or not Assigned(Dm.SqlCliente) then
    Exit;
  if not (Dm.SqlCliente.State in [dsInsert, dsEdit]) then
    Exit;
  if not Assigned(DBEditCep.Field) then
    Exit;
  if FocoEhCancelarOuSair then
    Exit;

  Digitos := SomenteDigitosDoc(DBEditCep.Text);
  if Digitos = '' then
  begin
    DBEditCep.Field.EditMask := '';
    DBEditCep.Field.AsString := '';
    Exit;
  end;

  if Length(Digitos) <> 8 then
  begin
    DBEditCep.Field.EditMask := '';
    DBEditCep.Color := COR_EDIT_ERRO;
    FCampoComErro := DBEditCep;
    MostrarBaloonErro(DBEditCep, 'CEP incompleto',
      'Informe um CEP com 8 digitos.');
    ReagendarFocoNoCampo(DBEditCep);
    Exit;
  end;

  // Persiste so digitos (Size=8); mascara visual apos validar.
  DBEditCep.Field.EditMask := '';
  DBEditCep.Field.AsString := Digitos;
  DBEditCep.Field.EditMask := '00000-000;0;';

  FConsultandoDoc := True;
  try
    if ConsultarCepViaCep(Digitos, Dados, Erro) then
      AplicarDadosCep(Dados)
    else if Erro <> '' then
      ShowMessage(Erro);
  finally
    FConsultandoDoc := False;
  end;
end;

procedure TForm_Cliente.MostrarBaloonErro(Edit: TCustomEdit;
  const Titulo, Texto: string);
begin
  // TBalloonHint (Vcl.WinXCtrls) exibe uma popup independente do estado
  // de foco do edit, funcionando de dentro do OnExit sem exigir que o
  // controle esteja focado no momento do ShowHint.
  if not Assigned(Edit) or not Assigned(FBalloonHint) then
    Exit;

  FBalloonHint.HideHint;
  FBalloonHint.Title       := Titulo;
  FBalloonHint.Description := Texto;
  FBalloonHint.ShowHint(Edit);
end;

procedure TForm_Cliente.ReagendarFocoNoCampo(Edit: TWinControl);
begin
  // PostMessage garante que o OnExit atual termine antes de reajustar o foco.
  if Assigned(Edit) then
    PostMessage(Self.Handle, WM_REFOCAR, WPARAM(Pointer(Edit)), 0);
end;

procedure TForm_Cliente.FocarControleSeguro(Ctrl: TWinControl);
begin
  if (Ctrl = nil) or (not Ctrl.Showing) or (not Ctrl.CanFocus) then
    Exit;
  try
    Ctrl.SetFocus;
  except
    on EInvalidOperation do
      ;
  end;
end;

procedure TForm_Cliente.WMRefocar(var Msg: TMessage);
var
  Ctrl: TWinControl;
begin
  Ctrl := TWinControl(Pointer(Msg.WParam));
  if not Assigned(Ctrl) then
    Exit;
  FValidando := True;
  try
    FocarControleSeguro(Ctrl);
  finally
    FValidando := False;
  end;
end;

procedure TForm_Cliente.WMAplicarTipo(var Msg: TMessage);
begin
  ProcessarAlteracaoTipo;
end;

procedure TForm_Cliente.DBEditObrigatorioExit(Sender: TObject);
var
  Edit: TDBEdit;
  Rotulo: string;
  FocoDestino: HWND;
begin
  if FValidando then
    Exit;
  Edit := Sender as TDBEdit;

  // Ao sair, tira o realce de foco e limpa o estado de erro. Se algo
  // abaixo detectar erro, ambos sao reaplicados.
  Edit.Color := COR_EDIT_NORMAL;
  if FCampoComErro = Edit then
    FCampoComErro := nil;

  if FIgnorarValidacao then
    Exit;
  if csDestroying in ComponentState then
    Exit;
  if not Assigned(Dm) or not Assigned(Dm.SqlCliente) then
    Exit;
  if not (Dm.SqlCliente.State in [dsInsert, dsEdit]) then
    Exit;

  // Permite sair do campo sem validacao quando o proximo foco for
  // Cancelar ou Sair (MouseDown do botao pode ocorrer apos o OnExit).
  FocoDestino := GetFocus;
  if (FocoDestino <> 0) and
     ((BtnCancelar.HandleAllocated and (FocoDestino = BtnCancelar.Handle)) or
      (BtnSair.HandleAllocated and (FocoDestino = BtnSair.Handle))) then
    Exit;

  if Edit.Hint <> '' then
    Rotulo := Edit.Hint
  else
    Rotulo := Edit.Name;

  if Trim(Edit.Text) = '' then
  begin
    Edit.Color    := COR_EDIT_ERRO;
    FCampoComErro := Edit;
    MostrarBaloonErro(Edit, 'Campo obrigatorio',
      'O campo ' + Rotulo + ' deve ser preenchido.');
    ReagendarFocoNoCampo(Edit);
  end
  else if Edit.Name = FObserveEnterControl then
    ObserveLogFill(Self, Edit.Name, FObserveEnterValue, Edit.Text);
end;

procedure TForm_Cliente.DBEditRendaMensalExit(Sender: TObject);
var
  Valor: Double;
  FocoDestino: HWND;
begin
  if FValidando then
    Exit;

  DBEditRendaMensal.Color := COR_EDIT_NORMAL;
  if FCampoComErro = DBEditRendaMensal then
    FCampoComErro := nil;

  if FIgnorarValidacao then
    Exit;
  if not Assigned(Dm) or not Assigned(Dm.SqlCliente) then
    Exit;
  if not (Dm.SqlCliente.State in [dsInsert, dsEdit]) then
    Exit;
  if not Assigned(DBEditRendaMensal.Field) then
    Exit;

  FocoDestino := GetFocus;
  if (FocoDestino <> 0) and
     ((BtnCancelar.HandleAllocated and (FocoDestino = BtnCancelar.Handle)) or
      (BtnSair.HandleAllocated and (FocoDestino = BtnSair.Handle))) then
    Exit;

  Valor := DBEditRendaMensal.Field.AsFloat;
  if Valor < 0 then
  begin
    DBEditRendaMensal.Color := COR_EDIT_ERRO;
    FCampoComErro           := DBEditRendaMensal;
    MostrarBaloonErro(DBEditRendaMensal, 'Valor invalido',
      'A renda mensal nao pode ser negativa.');
    ReagendarFocoNoCampo(DBEditRendaMensal);
    Exit;
  end;

  DBEditLimiteCredito.Field.AsFloat := Valor * 0.30;
  if DBEditRendaMensal.Name = FObserveEnterControl then
    ObserveLogFill(Self, DBEditRendaMensal.Name, FObserveEnterValue,
      DBEditRendaMensal.Text);
end;

procedure TForm_Cliente.DBEditTelefoneEnter(Sender: TObject);
var
  ValorAtual: string;
begin
  // Realce de foco.
  EditFocoEnter(Sender);

  // Ao entrar no campo, removemos a formatacao para o usuario editar
  // apenas os digitos. A mascara so reaparece ao sair.
  if not Assigned(DBEditTelefone.Field) then
    Exit;
  if not (Dm.SqlCliente.State in [dsInsert, dsEdit]) then
    Exit;

  ValorAtual := DBEditTelefone.Field.AsString;
  if ValorAtual = '' then
    Exit;

  DBEditTelefone.Field.AsString := SoDigitos(ValorAtual);
end;

procedure TForm_Cliente.DBEditTelefoneKeyPress(Sender: TObject; var Key: Char);
var
  QtdDigitos: Integer;
  Ch: Char;
begin
  // Permite teclas de controle (backspace, tab, enter).
  if CharInSet(Key, [#8, #9, #13, #27]) then
    Exit;

  // Bloqueia qualquer coisa que nao seja digito.
  if not CharInSet(Key, ['0'..'9']) then
  begin
    Key := #0;
    Exit;
  end;

  // Se ha selecao ativa, o novo digito substitui a selecao.
  if DBEditTelefone.SelLength > 0 then
    Exit;

  // Limita a 11 digitos (celular). Impede digitacao adicional.
  QtdDigitos := 0;
  for Ch in DBEditTelefone.Text do
    if CharInSet(Ch, ['0'..'9']) then
      Inc(QtdDigitos);
  if QtdDigitos >= 11 then
    Key := #0;
end;

procedure TForm_Cliente.DBEditTelefoneExit(Sender: TObject);
var
  FocoDestino: HWND;
  Digitos, Formatado: string;
begin
  if FValidando then
    Exit;

  DBEditTelefone.Color := COR_EDIT_NORMAL;
  if FCampoComErro = DBEditTelefone then
    FCampoComErro := nil;

  if FIgnorarValidacao then
    Exit;
  if csDestroying in ComponentState then
    Exit;
  if not Assigned(Dm) or not Assigned(Dm.SqlCliente) then
    Exit;
  if not (Dm.SqlCliente.State in [dsInsert, dsEdit]) then
    Exit;
  if not Assigned(DBEditTelefone.Field) then
    Exit;

  FocoDestino := GetFocus;
  if (FocoDestino <> 0) and
     ((BtnCancelar.HandleAllocated and (FocoDestino = BtnCancelar.Handle)) or
      (BtnSair.HandleAllocated and (FocoDestino = BtnSair.Handle))) then
    Exit;

  Digitos := SoDigitos(DBEditTelefone.Text);

  // Campo vazio e permitido (telefone e opcional).
  if Digitos = '' then
  begin
    DBEditTelefone.Field.AsString := '';
    Exit;
  end;

  if FormatarTelefone(Digitos, Formatado) then
  begin
    DBEditTelefone.Field.AsString := Formatado;
    if DBEditTelefone.Name = FObserveEnterControl then
      ObserveLogFill(Self, DBEditTelefone.Name, FObserveEnterValue, Formatado);
  end
  else
  begin
    DBEditTelefone.Color := COR_EDIT_ERRO;
    FCampoComErro        := DBEditTelefone;
    MostrarBaloonErro(DBEditTelefone, 'Telefone incompleto',
      'Informe 10 digitos (fixo com DDD) ou 11 digitos (celular com DDD).');
    ReagendarFocoNoCampo(DBEditTelefone);
  end;
end;

function TForm_Cliente.ValidarCamposObrigatorios: Boolean;

  function CampoVazio(Edit: TDBEdit): Boolean;
  begin
    Result := (Edit.Field = nil) or (Trim(Edit.Field.AsString) = '');
  end;

  function FalharEm(Edit: TDBEdit; const Rotulo: string): Boolean;
  begin
    Edit.Color    := COR_EDIT_ERRO;
    FCampoComErro := Edit;
    MostrarBaloonErro(Edit, 'Campo obrigatorio',
      'O campo ' + Rotulo + ' deve ser preenchido.');
    ReagendarFocoNoCampo(Edit);
    Result := False;
  end;

begin
  Result := True;
  if CampoVazio(DBEditNome)     then Exit(FalharEm(DBEditNome,     'Nome'));
  if CampoVazio(DBEditEndereco) then Exit(FalharEm(DBEditEndereco, 'Endereco'));
  if CampoVazio(DBEditBairro)   then Exit(FalharEm(DBEditBairro,   'Bairro'));
  if CampoVazio(DBEditCidade)   then Exit(FalharEm(DBEditCidade,   'Cidade'));

  if TipoPessoaAtual = 'J' then
  begin
    if Assigned(DBEditCNPJ.Field) and (Trim(DBEditCNPJ.Field.AsString) <> '') and
       (not ValidarCnpj(DBEditCNPJ.Field.AsString)) then
    begin
      DBEditCNPJ.Color := COR_EDIT_ERRO;
      FCampoComErro := DBEditCNPJ;
      MostrarBaloonErro(DBEditCNPJ, 'CNPJ invalido',
        'Informe um CNPJ valido antes de gravar.');
      ReagendarFocoNoCampo(DBEditCNPJ);
      Exit(False);
    end;
  end
  else if Assigned(DBEditCPF.Field) and (Trim(DBEditCPF.Field.AsString) <> '') and
          (not ValidarCpf(DBEditCPF.Field.AsString)) then
  begin
    DBEditCPF.Color := COR_EDIT_ERRO;
    FCampoComErro := DBEditCPF;
    MostrarBaloonErro(DBEditCPF, 'CPF invalido',
      'Informe um CPF valido antes de gravar.');
    ReagendarFocoNoCampo(DBEditCPF);
    Exit(False);
  end;

  if Assigned(DBEditCep.Field) and (Trim(DBEditCep.Field.AsString) <> '') and
     (Length(SomenteDigitosDoc(DBEditCep.Field.AsString)) <> 8) then
  begin
    DBEditCep.Color := COR_EDIT_ERRO;
    FCampoComErro := DBEditCep;
    MostrarBaloonErro(DBEditCep, 'CEP invalido',
      'Informe um CEP com 8 digitos antes de gravar.');
    ReagendarFocoNoCampo(DBEditCep);
    Exit(False);
  end;

  if Assigned(DBEditRendaMensal.Field) and (DBEditRendaMensal.Field.AsFloat < 0) then
  begin
    DBEditRendaMensal.Color := COR_EDIT_ERRO;
    FCampoComErro           := DBEditRendaMensal;
    MostrarBaloonErro(DBEditRendaMensal, 'Valor invalido',
      'A renda mensal nao pode ser negativa.');
    ReagendarFocoNoCampo(DBEditRendaMensal);
    Result := False;
  end;
end;

{ Ciclo de vida }

procedure TForm_Cliente.FormCreate(Sender: TObject);
begin
  FValidando             := False;
  FIgnorarValidacao      := False;
  FConsultandoDoc        := False;
  FAtualizandoUI         := False;
  FAplicandoMascara      := False;
  FAjustandoLayout       := False;
  FAlterandoTipo         := False;
  FAplicandoVisibilidade := False;

  // Balloon hint reutilizavel (mesmo padrao do Form_Login).
  FBalloonHint           := TBalloonHint.Create(Self);
  FBalloonHint.HideAfter := 4000;
  FBalloonHint.Delay     := 0;

  if not Dm.SqlCliente.Active then
    Dm.SqlCliente.Open;

  ConfigurarGlyphsBotoes;
  ConfigurarCampoTelefone;
  ConfigurarCamposDocumento;
  AplicarLayoutInicial;
  AplicarVisibilidadeDocumento(False);

  // Instala handlers encadeados no DsCliente, preservando os do DataModule.
  FOldDataChange  := Dm.DsCliente.OnDataChange;
  FOldStateChange := Dm.DsCliente.OnStateChange;
  Dm.DsCliente.OnDataChange  := DsClienteDataChangeChained;
  Dm.DsCliente.OnStateChange := DsClienteStateChangeChained;

  AtualizarEstadoUI;
  ObserveLogOpenForm(Self);
  ObserveEmitSnapshot(Self, Dm.SqlCliente);
end;

procedure TForm_Cliente.FormDestroy(Sender: TObject);
begin
  // Restaura os handlers originais do DataModule.
  if Assigned(Dm) and Assigned(Dm.DsCliente) then
  begin
    if TMethod(Dm.DsCliente.OnDataChange).Data = Self then
      Dm.DsCliente.OnDataChange := FOldDataChange;
    if TMethod(Dm.DsCliente.OnStateChange).Data = Self then
      Dm.DsCliente.OnStateChange := FOldStateChange;
  end;
  if Assigned(Dm) and Assigned(Dm.SqlClienteCPF) then
    Dm.SqlClienteCPF.EditMask := '';
  if Assigned(Dm) and Assigned(Dm.SqlClienteCNPJ) then
    Dm.SqlClienteCNPJ.EditMask := '';
  if Assigned(Dm) and Assigned(Dm.SqlClienteCEP) then
    Dm.SqlClienteCEP.EditMask := '';
end;

procedure TForm_Cliente.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ObserveLogCloseForm(Self);
  Action       := caFree;
  Form_Cliente := nil;
end;

procedure TForm_Cliente.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := True;
  if Assigned(Dm) and Assigned(Dm.SqlCliente) and
     (Dm.SqlCliente.State in [dsInsert, dsEdit]) then
  begin
    case MensagemDlg(
      'Existem alteracoes nao gravadas. Deseja descarta-las e fechar?',
      mtConfirmation, [mbYes, mbNo], 0) of
      mrYes:
        begin
          Dm.SqlCliente.Cancel;
          CanClose := True;
        end;
    else
      CanClose := False;
    end;
  end;
end;

procedure TForm_Cliente.CreateParams(var Params: TCreateParams);
begin
  // Garante shell sem chrome desde a criacao do HWND (MDI child).
  inherited CreateParams(Params);
  Params.Style := Params.Style and not (WS_CAPTION or WS_THICKFRAME or
    WS_MINIMIZEBOX or WS_MAXIMIZEBOX or WS_SYSMENU or WS_BORDER or WS_DLGFRAME);
  Params.ExStyle := Params.ExStyle and not (WS_EX_CLIENTEDGE or
    WS_EX_WINDOWEDGE or WS_EX_DLGMODALFRAME or WS_EX_STATICEDGE);
end;

procedure TForm_Cliente.FormActivate(Sender: TObject);
begin
  // Reaplica apos o MDI ativar (Windows pode restaurar borda/caption).
  RemoverChromeJanela(Self);
  BringToFront;
  // Adia o foco: SetFocus sincrono no Activate falha com form ainda invisivel.
  ReagendarFocoNoCampo(BtnInserir);
end;

procedure TForm_Cliente.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  // ENTER navega para o proximo campo (imitando TAB), exceto quando o
  // foco esta em um memo (que precisa do Enter para quebrar linha) ou
  // em um botao (que deve receber o clique via Enter).
  if (Key = VK_RETURN) and (Shift = []) then
  begin
    if (ActiveControl <> nil) and
       not (ActiveControl is TCustomMemo) and
       not (ActiveControl is TCustomButton) then
    begin
      Key := 0;
      SelectNext(ActiveControl, True, True);
      Exit;
    end;
  end;

  // Seta para CIMA volta ao campo anterior, mesmo que o campo atual
  // esteja invalido (rota de escape da validacao imediata).
  if (Key = VK_UP) and (Shift = []) then
  begin
    if (ActiveControl <> nil) and
       not (ActiveControl is TCustomMemo) and
       not (ActiveControl is TCustomButton) then
    begin
      Key := 0;
      FIgnorarValidacao := True;
      try
        SelectNext(ActiveControl, False, True);
      finally
        FIgnorarValidacao := False;
      end;
      Exit;
    end;
  end;

  // ESC so fecha o form quando nao ha edicao pendente; caso contrario
  // deixamos o fluxo padrao para nao descartar dados silenciosamente.
  if Key = VK_ESCAPE then
  begin
    if Assigned(Dm) and Assigned(Dm.SqlCliente) and
       (Dm.SqlCliente.State in [dsInsert, dsEdit]) then
      Exit;
    Close;
  end;
end;

{ Navegacao }

procedure TForm_Cliente.BtnPrimeiroClick(Sender: TObject);
begin
  Dm.SqlCliente.First;
end;

procedure TForm_Cliente.BtnAnteriorClick(Sender: TObject);
begin
  Dm.SqlCliente.Prior;
end;

procedure TForm_Cliente.BtnProximoClick(Sender: TObject);
begin
  Dm.SqlCliente.Next;
end;

procedure TForm_Cliente.BtnUltimoClick(Sender: TObject);
begin
  Dm.SqlCliente.Last;
end;

{ CRUD }

procedure TForm_Cliente.BtnInserirClick(Sender: TObject);
begin
  Dm.SqlCliente.Insert;
  DBEditRendaMensal.Field.AsFloat    := 0.00;
  DBEditLimiteCredito.Field.AsFloat  := 0.00;
  DbEditCompras.Field.AsFloat        := 0.00;
  if Assigned(Dm.SqlCliente.FindField('TIPO')) then
    Dm.SqlCliente.FieldByName('TIPO').AsString := 'F';
  if Dm.QueryId.Active then
    Dm.QueryId.Close;
  Dm.QueryId.SQL.Text :=
    'SELECT COALESCE(MAX(CODIGO),0) + 1 AS CODIGO FROM CLIENTE';
  Dm.QueryId.Open;
  try
    if Dm.SqlCliente.State = dsInsert then
      DBEditCodigo.Field.AsString :=
        Dm.QueryId.FieldByName('CODIGO').AsString;
  finally
    Dm.QueryId.Close;
  end;

  AplicarVisibilidadeDocumento(True);
  ReagendarFocoNoCampo(DBEditNome);
end;

procedure TForm_Cliente.BtnEditarClick(Sender: TObject);
begin
  Dm.SqlCliente.Edit;
  ReagendarFocoNoCampo(DBEditNome);
end;

procedure TForm_Cliente.BtnGravarClick(Sender: TObject);
begin
  if not (Dm.SqlCliente.State in [dsInsert, dsEdit]) then
    Exit;

  if not ValidarCamposObrigatorios then
    Exit;

  // Garante documento do tipo oculto limpo e valores sem mascara no banco.
  if TipoPessoaAtual = 'J' then
  begin
    if Assigned(Dm.SqlCliente.FindField('CPF')) then
    begin
      Dm.SqlCliente.FieldByName('CPF').EditMask := '';
      Dm.SqlCliente.FieldByName('CPF').Clear;
    end;
    if Assigned(DBEditCNPJ.Field) then
    begin
      DBEditCNPJ.Field.EditMask := '';
      if Trim(DBEditCNPJ.Field.AsString) <> '' then
        DBEditCNPJ.Field.AsString := SomenteAlfaNumDoc(DBEditCNPJ.Field.AsString);
    end;
  end
  else
  begin
    if Assigned(Dm.SqlCliente.FindField('CNPJ')) then
    begin
      Dm.SqlCliente.FieldByName('CNPJ').EditMask := '';
      Dm.SqlCliente.FieldByName('CNPJ').Clear;
    end;
    if Assigned(DBEditCPF.Field) then
    begin
      DBEditCPF.Field.EditMask := '';
      if Trim(DBEditCPF.Field.AsString) <> '' then
        DBEditCPF.Field.AsString := SomenteDigitosDoc(DBEditCPF.Field.AsString);
    end;
  end;
  if Assigned(DBEditCep.Field) then
  begin
    DBEditCep.Field.EditMask := '';
    if Trim(DBEditCep.Field.AsString) <> '' then
      DBEditCep.Field.AsString := SomenteDigitosDoc(DBEditCep.Field.AsString);
  end;

  ObserveEmitSnapshot(Self, Dm.SqlCliente);
  try
    Dm.SqlCliente.Post;
    ObserveLogPost(Self, 'Cliente');
    Dm.SqlCliente.ApplyUpdates;
    ObserveLogApplyUpdates(Self, 'Cliente');
    Dm.IBTransaction1.CommitRetaining;
    ObserveLogCommit(Self, 'Cliente');
    ObserveLogShowMessage('Registro gravado com sucesso.');
    ShowMessage('Registro gravado com sucesso.');
    ObserveEmitSnapshot(Self, Dm.SqlCliente);
  except
    on E: Exception do
    begin
      if Dm.IBTransaction1.InTransaction then
        Dm.IBTransaction1.Rollback;
      ObserveLogRollback(Self, 'Cliente', E.Message);
      ObserveLogException(E.Message, 'BtnGravar', ClassName);
      MensagemDlg('Erro na gravacao: ' + E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

procedure TForm_Cliente.BtnCancelarMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  // Garante que o usuario possa cancelar mesmo estando em um campo
  // obrigatorio ainda invalido - suprime a validacao OnExit ate que o
  // BtnCancelarClick termine.
  FIgnorarValidacao := True;
end;

procedure TForm_Cliente.BtnCancelarClick(Sender: TObject);
begin
  try
    if Dm.SqlCliente.State in [dsInsert, dsEdit] then
    begin
      if MensagemDlg('Descartar as alteracoes deste registro?',
           mtConfirmation, [mbYes, mbNo], 0) = mrYes then
        Dm.SqlCliente.Cancel;
    end;
  finally
    FIgnorarValidacao := False;
  end;
end;

procedure TForm_Cliente.BtnSairMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  // Como no BtnCancelar: o usuario pode sair mesmo com um campo
  // invalido focado - suprime a validacao OnExit durante o clique.
  FIgnorarValidacao := True;
end;

procedure TForm_Cliente.BtnSairClick(Sender: TObject);
begin
  try
    // Sair abandona qualquer edicao pendente e fecha imediatamente,
    // sem confirmacao. Com o dataset de volta em dsBrowse, o
    // FormCloseQuery nao pergunta nada.
    if Assigned(Dm) and Assigned(Dm.SqlCliente) and
       (Dm.SqlCliente.State in [dsInsert, dsEdit]) then
      Dm.SqlCliente.Cancel;
    Close;
  finally
    FIgnorarValidacao := False;
  end;
end;

procedure TForm_Cliente.BtnExcluirClick(Sender: TObject);
var
  Nome, Codigo: string;
  Resposta: Integer;
begin
  if not Assigned(Dm) or not Assigned(Dm.SqlCliente) or
     Dm.SqlCliente.IsEmpty then
  begin
    ObserveLogShowMessage('Nao ha cliente selecionado para excluir.');
    ShowMessage('Nao ha cliente selecionado para excluir.');
    Exit;
  end;

  Nome   := Dm.SqlCliente.FieldByName('NOME').AsString;
  Codigo := Dm.SqlCliente.FieldByName('CODIGO').AsString;

  Resposta := MensagemDlg(
    Format(
      'Deseja realmente excluir o cliente abaixo?' + sLineBreak + sLineBreak +
      '   Codigo: %s' + sLineBreak +
      '   Nome  : %s' + sLineBreak + sLineBreak +
      'Essa operacao nao podera ser desfeita.',
      [Codigo, Nome]),
    mtWarning, [mbYes, mbNo], 0, mbNo);

  if Resposta <> mrYes then
    Exit;

  try
    Dm.SqlCliente.Delete;
    ObserveLogDelete(Self, 'Cliente');
    Dm.SqlCliente.ApplyUpdates;
    ObserveLogApplyUpdates(Self, 'Cliente');
    Dm.IBTransaction1.CommitRetaining;
    ObserveLogCommit(Self, 'Cliente');
    ObserveLogShowMessage('Cliente excluido com sucesso.');
    ShowMessage('Cliente excluido com sucesso.');
  except
    on E: Exception do
    begin
      if Dm.IBTransaction1.InTransaction then
        Dm.IBTransaction1.Rollback;
      ObserveLogRollback(Self, 'Cliente', E.Message);
      ObserveLogException(E.Message, 'BtnExcluir', ClassName);
      MensagemDlg('Erro ao excluir: ' + E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

procedure TForm_Cliente.BtnAtualizarClick(Sender: TObject);
var
  Codigo: Integer;
begin
  if not Assigned(DBEditCodigo.Field) or DBEditCodigo.Field.IsNull then
  begin
    ShowMessage('Selecione um cliente antes de atualizar o total de compras.');
    Exit;
  end;

  if not TryStrToInt(Trim(DBEditCodigo.Text), Codigo) then
  begin
    ShowMessage('Codigo do cliente invalido.');
    Exit;
  end;

  try
    QueryAtualizar.SQL.Text :=
      'EXECUTE PROCEDURE SP_ATUALIZAR_TT_COMPRAS (:CODIGO_CLIENTE)';
    QueryAtualizar.ParamByName('CODIGO_CLIENTE').AsInteger := Codigo;
    QueryAtualizar.ExecSQL;
    Dm.IBTransaction1.CommitRetaining;
    Dm.SqlCliente.Refresh;
    ShowMessage('Total de compras atualizado.');
  except
    on E: Exception do
    begin
      if Dm.IBTransaction1.InTransaction then
        Dm.IBTransaction1.Rollback;
      MensagemDlg('Erro ao atualizar: ' + E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

{ Actions - encaminham para os handlers dos botoes preservando o gate
  de habilitacao (que continua sendo controlado pelo DataModule). }

procedure TForm_Cliente.ActPrimeiroExecute(Sender: TObject);
begin
  ObserveLogAction(Self, 'ActPrimeiro', 'BtnPrimeiro');
  if BtnPrimeiro.Enabled then
    BtnPrimeiroClick(BtnPrimeiro);
end;

procedure TForm_Cliente.ActAnteriorExecute(Sender: TObject);
begin
  ObserveLogAction(Self, 'ActAnterior', 'BtnAnterior');
  if BtnAnterior.Enabled then
    BtnAnteriorClick(BtnAnterior);
end;

procedure TForm_Cliente.ActProximoExecute(Sender: TObject);
begin
  ObserveLogAction(Self, 'ActProximo', 'BtnProximo');
  if BtnProximo.Enabled then
    BtnProximoClick(BtnProximo);
end;

procedure TForm_Cliente.ActUltimoExecute(Sender: TObject);
begin
  ObserveLogAction(Self, 'ActUltimo', 'BtnUltimo');
  if BtnUltimo.Enabled then
    BtnUltimoClick(BtnUltimo);
end;

procedure TForm_Cliente.ActInserirExecute(Sender: TObject);
begin
  ObserveLogAction(Self, 'ActInserir', 'BtnInserir');
  if BtnInserir.Enabled then
    BtnInserirClick(BtnInserir);
end;

procedure TForm_Cliente.ActEditarExecute(Sender: TObject);
begin
  ObserveLogAction(Self, 'ActEditar', 'BtnEditar');
  if BtnEditar.Enabled then
    BtnEditarClick(BtnEditar);
end;

procedure TForm_Cliente.ActGravarExecute(Sender: TObject);
begin
  ObserveLogAction(Self, 'ActGravar', 'BtnGravar');
  if BtnGravar.Enabled then
    BtnGravarClick(BtnGravar);
end;

procedure TForm_Cliente.ActCancelarExecute(Sender: TObject);
begin
  ObserveLogAction(Self, 'ActCancelar', 'BtnCancelar');
  if BtnCancelar.Enabled then
  begin
    FIgnorarValidacao := True;
    try
      BtnCancelarClick(BtnCancelar);
    finally
      FIgnorarValidacao := False;
    end;
  end;
end;

procedure TForm_Cliente.ActExcluirExecute(Sender: TObject);
begin
  ObserveLogAction(Self, 'ActExcluir', 'BtnExcluir');
  if BtnExcluir.Enabled then
    BtnExcluirClick(BtnExcluir);
end;

procedure TForm_Cliente.ActAtualizarExecute(Sender: TObject);
begin
  ObserveLogAction(Self, 'ActAtualizar', 'BtnAtualizar');
  if BtnAtualizar.Enabled then
    BtnAtualizarClick(BtnAtualizar);
end;

end.

