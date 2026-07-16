unit CupomVenda;

{ Emissao do cupom da venda (visual estilo DANFE NFC-e auxiliar).

  Layout FastReport guardado na tabela RELATORIO (campo BLOB ARQUIVO),
  com seed a partir de Fr3\CupomVenda.fr3 na primeira execucao - mesmo
  fluxo das etiquetas e dos demais relatorios. }

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Data.DB, IBX.IBQuery, IBX.IBCustomDataSet,
  frxClass, frxDBSet,
  frxExportPDF, frxExportXML, frxExportRTF, frxExportCSV;

const
  NOME_RELATORIO     = 'Cupom_Venda';
  ARQUIVO_FR3        = 'CupomVenda.fr3';
  PASTA_FR3          = 'C:\Avaliacao Delphi_Firebird\Andre_luis\Projeto\Fr3';
  PASTA_FR3_RELATIVA = 'Fr3';

type
  TForm_CupomVenda = class(TForm)
    QueryCabecalho: TIBQuery;
    QueryItens: TIBQuery;
    frxDBDatasetCupom: TfrxDBDataset;
    frxDBDatasetCupomItens: TfrxDBDataset;
    frxReportCupom: TfrxReport;
    frxExportPDF: TfrxPDFExport;
    frxExportExcel: TfrxXMLExport;
    frxExportWord: TfrxRTFExport;
    frxExportCSV: TfrxCSVExport;
    procedure FormCreate(Sender: TObject);
  private
    function AbrirDados(const ACodigoVenda: Integer): Boolean;
    function LocalizarArquivoFr3: string;
    procedure GravarRelatorioNoBanco(const ANome, ACaminhoArquivo: string);
    function CarregarRelatorioDoBanco(const ANome: string;
      AStream: TStream): Boolean;
    procedure GravarRelatorioEmbutidoNoBanco(const ANome: string);
    procedure ExibirRelatorio;
  public
    class procedure Emitir(AOwner: TComponent; ACodigoVenda: Integer);
  end;

var
  Form_CupomVenda: TForm_CupomVenda;

implementation

uses
  DataModule, Mensagens, RelatorioExportacaoFast;

{$R *.dfm}

procedure TForm_CupomVenda.FormCreate(Sender: TObject);
begin
  TRelatorioExportacaoFast.VincularExportacoes(frxReportCupom, frxExportPDF,
    frxExportExcel, frxExportWord, frxExportCSV);
end;

function TForm_CupomVenda.AbrirDados(const ACodigoVenda: Integer): Boolean;
begin
  Result := False;

  QueryCabecalho.Close;
  QueryCabecalho.ParamByName('CODIGO').AsInteger := ACodigoVenda;
  QueryCabecalho.Open;
  if QueryCabecalho.IsEmpty then
  begin
    MensagemDlg('Venda nao encontrada para impressao do cupom.',
      mtInformation, [mbOK], 0);
    Exit;
  end;

  QueryItens.Close;
  QueryItens.ParamByName('CODIGO').AsInteger := ACodigoVenda;
  QueryItens.Open;
  if QueryItens.IsEmpty then
  begin
    MensagemDlg('A venda nao possui itens para impressao do cupom.',
      mtInformation, [mbOK], 0);
    Exit;
  end;

  Result := True;
end;

function TForm_CupomVenda.LocalizarArquivoFr3: string;
var
  lPastaExe: string;
  lBases: array of string;
  lI: Integer;
  lTentativa: string;
begin
  Result := '';
  lPastaExe := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName));

  lBases := [
    lPastaExe + '..' + PathDelim + '..' + PathDelim + PASTA_FR3_RELATIVA + PathDelim,
    lPastaExe + '..' + PathDelim + PASTA_FR3_RELATIVA + PathDelim,
    lPastaExe + PASTA_FR3_RELATIVA + PathDelim,
    lPastaExe,
    IncludeTrailingPathDelimiter(PASTA_FR3)
  ];

  for lI := Low(lBases) to High(lBases) do
  begin
    lTentativa := lBases[lI] + ARQUIVO_FR3;
    if FileExists(lTentativa) then
      Exit(lTentativa);
  end;
end;

procedure TForm_CupomVenda.GravarRelatorioNoBanco(const ANome,
  ACaminhoArquivo: string);
var
  lQuery: TIBQuery;
  lStream: TFileStream;
begin
  lStream := TFileStream.Create(ACaminhoArquivo, fmOpenRead or fmShareDenyWrite);
  try
    lQuery := TIBQuery.Create(nil);
    try
      lQuery.Database    := QueryCabecalho.Database;
      lQuery.Transaction := QueryCabecalho.Transaction;
      lQuery.SQL.Text :=
        'update or insert into RELATORIO ' +
        '  (NOME, DESCRICAO, ARQUIVO, DATA_ALTERACAO) ' +
        'values ' +
        '  (:PNOME, :PDESCRICAO, :PARQUIVO, CURRENT_TIMESTAMP) ' +
        'matching (NOME)';
      lQuery.ParamByName('PNOME').AsString      := ANome;
      lQuery.ParamByName('PDESCRICAO').AsString := 'Cupom de Venda';
      lQuery.ParamByName('PARQUIVO').LoadFromStream(lStream, ftBlob);
      lQuery.ExecSQL;
      Dm.IBTransaction1.CommitRetaining;
    finally
      lQuery.Free;
    end;
  finally
    lStream.Free;
  end;
end;

function TForm_CupomVenda.CarregarRelatorioDoBanco(const ANome: string;
  AStream: TStream): Boolean;
var
  lQuery: TIBQuery;
begin
  lQuery := TIBQuery.Create(nil);
  try
    lQuery.Database    := QueryCabecalho.Database;
    lQuery.Transaction := QueryCabecalho.Transaction;
    lQuery.SQL.Text :=
      'select ARQUIVO from RELATORIO where NOME = :PNOME';
    lQuery.ParamByName('PNOME').AsString := ANome;
    lQuery.Open;

    Result := not (lQuery.IsEmpty or lQuery.FieldByName('ARQUIVO').IsNull);
    if Result then
    begin
      TBlobField(lQuery.FieldByName('ARQUIVO')).SaveToStream(AStream);
      AStream.Position := 0;
    end;
    lQuery.Close;
  finally
    lQuery.Free;
  end;
end;

procedure TForm_CupomVenda.GravarRelatorioEmbutidoNoBanco(const ANome: string);
var
  lQuery: TIBQuery;
  lStream: TMemoryStream;
begin
  lStream := TMemoryStream.Create;
  try
    frxReportCupom.SaveToStream(lStream);
    lStream.Position := 0;

    lQuery := TIBQuery.Create(nil);
    try
      lQuery.Database    := QueryCabecalho.Database;
      lQuery.Transaction := QueryCabecalho.Transaction;
      lQuery.SQL.Text :=
        'update or insert into RELATORIO ' +
        '  (NOME, DESCRICAO, ARQUIVO, DATA_ALTERACAO) ' +
        'values ' +
        '  (:PNOME, :PDESCRICAO, :PARQUIVO, CURRENT_TIMESTAMP) ' +
        'matching (NOME)';
      lQuery.ParamByName('PNOME').AsString      := ANome;
      lQuery.ParamByName('PDESCRICAO').AsString := 'Cupom de Venda';
      lQuery.ParamByName('PARQUIVO').LoadFromStream(lStream, ftBlob);
      lQuery.ExecSQL;
      Dm.IBTransaction1.CommitRetaining;
    finally
      lQuery.Free;
    end;
  finally
    lStream.Free;
  end;
end;

procedure TForm_CupomVenda.ExibirRelatorio;
var
  lStream: TMemoryStream;
  lCaminhoFr3: string;
begin
  lStream := TMemoryStream.Create;
  try
    // Layout embutido no dfm prevalece (garante cupom atualizado apos rebuild).
    GravarRelatorioEmbutidoNoBanco(NOME_RELATORIO);

    if not CarregarRelatorioDoBanco(NOME_RELATORIO, lStream) then
    begin
      lCaminhoFr3 := LocalizarArquivoFr3;
      if lCaminhoFr3 <> '' then
      begin
        GravarRelatorioNoBanco(NOME_RELATORIO, lCaminhoFr3);
        if not CarregarRelatorioDoBanco(NOME_RELATORIO, lStream) then
        begin
          MensagemDlg('Nao foi possivel carregar o layout gravado na ' +
            'tabela RELATORIO.', mtError, [mbOK], 0);
          Exit;
        end;
      end
      else
      begin
        MensagemDlg('Layout "' + NOME_RELATORIO + '" nao encontrado na ' +
          'tabela RELATORIO e o arquivo ' + ARQUIVO_FR3 +
          ' nao foi localizado em disco.', mtWarning, [mbOK], 0);
        Exit;
      end;
    end;

    frxReportCupom.LoadFromStream(lStream);
    TRelatorioExportacaoFast.VincularExportacoes(frxReportCupom, frxExportPDF,
      frxExportExcel, frxExportWord, frxExportCSV);
    frxReportCupom.ShowReport;
  finally
    lStream.Free;
  end;
end;

class procedure TForm_CupomVenda.Emitir(AOwner: TComponent;
  ACodigoVenda: Integer);
var
  lForm: TForm_CupomVenda;
begin
  if ACodigoVenda <= 0 then
  begin
    MensagemDlg('Venda invalida para impressao do cupom.', mtInformation,
      [mbOK], 0);
    Exit;
  end;

  lForm := TForm_CupomVenda.Create(AOwner);
  try
    if not lForm.AbrirDados(ACodigoVenda) then
      Exit;
    try
      lForm.ExibirRelatorio;
    except
      on E: Exception do
        MensagemDlg('Erro ao abrir o cupom.' + sLineBreak + E.Message,
          mtError, [mbOK], 0);
    end;
  finally
    lForm.Free;
  end;
end;

end.
