unit Mensagens;

{ Dialogos de mensagem com botoes e titulos traduzidos para pt-BR.
  Substitui MessageDlg, cuja UI padrao exibe botoes em ingles
  (Yes/No/OK/Cancel) e titulos em ingles (Confirm/Warning/Error). }

interface

uses
  System.UITypes, Vcl.Dialogs;

function MensagemDlg(const Msg: string; TipoDlg: TMsgDlgType;
  Botoes: TMsgDlgButtons; AjudaCtx: Longint): Integer; overload;

function MensagemDlg(const Msg: string; TipoDlg: TMsgDlgType;
  Botoes: TMsgDlgButtons; AjudaCtx: Longint;
  BotaoPadrao: TMsgDlgBtn): Integer; overload;

implementation

uses
  Vcl.Forms, Vcl.StdCtrls, Vcl.Controls, ObserveHooks;

function KindFromTipo(TipoDlg: TMsgDlgType): string;
begin
  case TipoDlg of
    mtWarning:      Result := 'warning';
    mtError:        Result := 'error';
    mtInformation:  Result := 'info';
    mtConfirmation: Result := 'confirm';
  else
    Result := 'info';
  end;
end;

procedure TraduzirDialogo(Dlg: TForm; TipoDlg: TMsgDlgType);
var
  I: Integer;
  Btn: TButton;
begin
  case TipoDlg of
    mtConfirmation: Dlg.Caption := 'Confirma'#231#227'o';
    mtWarning:      Dlg.Caption := 'Aviso';
    mtError:        Dlg.Caption := 'Erro';
    mtInformation:  Dlg.Caption := 'Informa'#231#227'o';
  end;

  for I := 0 to Dlg.ComponentCount - 1 do
    if Dlg.Components[I] is TButton then
    begin
      Btn := TButton(Dlg.Components[I]);
      case Btn.ModalResult of
        mrYes:      Btn.Caption := '&Sim';
        mrNo:       Btn.Caption := '&N'#227'o';
        mrOk:       Btn.Caption := 'OK';
        mrCancel:   Btn.Caption := '&Cancelar';
        mrAbort:    Btn.Caption := '&Abortar';
        mrRetry:    Btn.Caption := '&Repetir';
        mrIgnore:   Btn.Caption := '&Ignorar';
        mrAll:      Btn.Caption := '&Todos';
        mrNoToAll:  Btn.Caption := 'N'#227'o para to&dos';
        mrYesToAll: Btn.Caption := 'Sim para t&odos';
        mrClose:    Btn.Caption := '&Fechar';
        mrHelp:     Btn.Caption := 'Aj&uda';
      end;
    end;
end;

function MensagemDlg(const Msg: string; TipoDlg: TMsgDlgType;
  Botoes: TMsgDlgButtons; AjudaCtx: Longint): Integer;
var
  Dlg: TForm;
begin
  Dlg := CreateMessageDialog(Msg, TipoDlg, Botoes);
  try
    Dlg.HelpContext := AjudaCtx;
    TraduzirDialogo(Dlg, TipoDlg);
    Result := Dlg.ShowModal;
    ObserveLogMessage(Msg, KindFromTipo(TipoDlg), Result);
  finally
    Dlg.Free;
  end;
end;

function MensagemDlg(const Msg: string; TipoDlg: TMsgDlgType;
  Botoes: TMsgDlgButtons; AjudaCtx: Longint;
  BotaoPadrao: TMsgDlgBtn): Integer;
var
  Dlg: TForm;
begin
  Dlg := CreateMessageDialog(Msg, TipoDlg, Botoes, BotaoPadrao);
  try
    Dlg.HelpContext := AjudaCtx;
    TraduzirDialogo(Dlg, TipoDlg);
    Result := Dlg.ShowModal;
    ObserveLogMessage(Msg, KindFromTipo(TipoDlg), Result);
  finally
    Dlg.Free;
  end;
end;

end.
