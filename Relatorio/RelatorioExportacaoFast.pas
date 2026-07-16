unit RelatorioExportacaoFast;

{ Configura os filtros de exportacao do FastReport (PDF, XML, Word e CSV)
  declarados no dfm de cada relatorio.

  Excel usa TfrxXMLExport (planilha XML) em vez de TfrxXLSXExport:
  o XLSX empacota XML em ZIP via System.ZLib e no Delphi 11+/Athens
  isso gera EZCompressionError 'Invalid ZStream operation!'. }

interface

uses
  frxClass, frxExportPDF, frxExportXML, frxExportRTF, frxExportCSV;

type
  TRelatorioExportacaoFast = class
  public
    class procedure VincularExportacoes(AReport: TfrxReport;
      APDF: TfrxPDFExport; AExcel: TfrxXMLExport; AWord: TfrxRTFExport;
      ACSV: TfrxCSVExport);
  end;

implementation

class procedure TRelatorioExportacaoFast.VincularExportacoes(
  AReport: TfrxReport; APDF: TfrxPDFExport; AExcel: TfrxXMLExport;
  AWord: TfrxRTFExport; ACSV: TfrxCSVExport);
begin
  // Delphi 11+ (inclui Athens): Compressed=True no PDF gera
  // EZCompressionError 'Invalid ZStream operation!' na exportacao.
  if Assigned(APDF) then
    APDF.Compressed := False;
end;

end.