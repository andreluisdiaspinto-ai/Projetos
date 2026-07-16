object Form_CupomVenda: TForm_CupomVenda
  Left = 0
  Top = 0
  Caption = 'Cupom de Venda'
  ClientHeight = 120
  ClientWidth = 320
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  Visible = False
  OnCreate = FormCreate
  TextHeight = 15
  object QueryCabecalho: TIBQuery
    Database = DM.Conexao
    Transaction = DM.IBTransaction1
    SQL.Strings = (
      'select'
      '  V.CODIGO,'
      '  V.CODIGO_CLIENTE,'
      '  C.NOME as NOME_CLIENTE,'
      '  V.SITUACAO,'
      '  V.DATA_HORA_VENDA,'
      '  V.TOTAL_BRUTO,'
      '  V.DESCONTO_PERC,'
      '  V.ACRESCIMO_PER,'
      '  V.TOTAL_LIQUIDO'
      'from VENDA V'
      'left join CLIENTE C on C.CODIGO = V.CODIGO_CLIENTE'
      'where V.CODIGO = :CODIGO')
    Left = 24
    Top = 16
    ParamData = <
      item
        DataType = ftInteger
        Name = 'CODIGO'
        ParamType = ptInput
      end>
  end
  object QueryItens: TIBQuery
    Database = DM.Conexao
    Transaction = DM.IBTransaction1
    SQL.Strings = (
      'select'
      '  I.CODIGO,'
      '  I.CODIGO_PRODUTO,'
      '  P.DESCRICAO as DESCRICAO_PRODUTO,'
      '  I.QUANTIDADE,'
      '  I.PRECO_UNITARIO,'
      '  I.DESCONTO,'
      '  I.ACRESCIMO,'
      '  I.TOTAL_LIQUIDO'
      'from VENDA_ITEM I'
      'left join PRODUTO P on P.CODIGO = I.CODIGO_PRODUTO'
      'where I.CODIGO_VENDA = :CODIGO'
      'order by I.CODIGO')
    Left = 112
    Top = 16
    ParamData = <
      item
        DataType = ftInteger
        Name = 'CODIGO'
        ParamType = ptInput
      end>
  end
  object frxDBDatasetCupom: TfrxDBDataset
    UserName = 'frxDBDatasetCupom'
    CloseDataSource = False
    DataSet = QueryCabecalho
    BCDToCurrency = False
    DataSetOptions = []
    Left = 24
    Top = 64
  end
  object frxDBDatasetCupomItens: TfrxDBDataset
    UserName = 'frxDBDatasetCupomItens'
    CloseDataSource = False
    DataSet = QueryItens
    BCDToCurrency = False
    DataSetOptions = []
    Left = 152
    Top = 64
  end
  object frxReportCupom: TfrxReport
    Version = '2023.1.3'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick, pbCopy, pbSelection]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = 'Default'
    PrintOptions.PrintOnSheet = 0
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      'begin'
      'end.')
    Left = 256
    Top = 16
    Datasets = <
      item
        DataSet = frxDBDatasetCupom
        DataSetName = 'frxDBDatasetCupom'
      end
      item
        DataSet = frxDBDatasetCupomItens
        DataSetName = 'frxDBDatasetCupomItens'
      end>
    Variables = <>
    Style = <>
    object Data: TfrxDataPage
      Height = 1000.000000000000000000
      Left = 0
      Top = 0
      Width = 1000.000000000000000000
    end
    object Page1: TfrxReportPage
      PaperWidth = 80.000000000000000000
      PaperHeight = 300.000000000000000000
      PaperSize = 256
      LeftMargin = 3.000000000000000000
      RightMargin = 3.000000000000000000
      TopMargin = 3.000000000000000000
      BottomMargin = 3.000000000000000000
      EndlessHeight = True
      Frame.Typ = []
      MirrorMode = []
      object ReportTitle1: TfrxReportTitle
        FillType = ftBrush
        FillGap.Top = 0
        FillGap.Left = 0
        FillGap.Bottom = 0
        FillGap.Right = 0
        Frame.Typ = []
        Height = 157.000000000000000000
        Top = 0
        Width = 279.000000000000000000
        object MemoEmpresa: TfrxMemoView
          AllowVectorExport = True
          Left = 0
          Top = 0
          Width = 279.000000000000000000
          Height = 16.000000000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Courier New'
          Font.Style = [fsBold]
          Frame.Typ = []
          HAlign = haCenter
          Memo.UTF8W = (
            'GANSO SISTEMAS')
          ParentFont = False
        end
        object MemoRazao: TfrxMemoView
          AllowVectorExport = True
          Left = 0
          Top = 14.000000000000000000
          Width = 279.000000000000000000
          Height = 13.000000000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -8
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = []
          HAlign = haCenter
          Memo.UTF8W = (
            'Ganso Demonstracao Ltda.')
          ParentFont = False
        end
        object MemoCnpj: TfrxMemoView
          AllowVectorExport = True
          Left = 0
          Top = 26.000000000000000000
          Width = 279.000000000000000000
          Height = 13.000000000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -8
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = []
          HAlign = haCenter
          Memo.UTF8W = (
            'CNPJ: 04.391.715/0004-16')
          ParentFont = False
        end
        object MemoEndereco: TfrxMemoView
          AllowVectorExport = True
          Left = 0
          Top = 38.000000000000000000
          Width = 279.000000000000000000
          Height = 22.000000000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -8
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = []
          HAlign = haCenter
          Memo.UTF8W = (
            'Avenida Afonso Pena, 2386'
            'Campo Grande - MS')
          ParentFont = False
        end
        object MemoSep1: TfrxMemoView
          AllowVectorExport = True
          Left = 0
          Top = 61.000000000000000000
          Width = 279.000000000000000000
          Height = 11.000000000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -8
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = []
          HAlign = haCenter
          Memo.UTF8W = (
            '----------------------------------------')
          ParentFont = False
        end
        object MemoTitulo: TfrxMemoView
          AllowVectorExport = True
          Left = 0
          Top = 71.000000000000000000
          Width = 279.000000000000000000
          Height = 14.000000000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Courier New'
          Font.Style = [fsBold]
          Frame.Typ = []
          HAlign = haCenter
          Memo.UTF8W = (
            'DANFE NFC-e')
          ParentFont = False
        end
        object MemoSubtitulo: TfrxMemoView
          AllowVectorExport = True
          Left = 0
          Top = 85.000000000000000000
          Width = 279.000000000000000000
          Height = 22.000000000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -7
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = []
          HAlign = haCenter
          Memo.UTF8W = (
            'Documento Auxiliar da Nota Fiscal'
            'de Consumidor Eletronica')
          ParentFont = False
        end
        object MemoSep2: TfrxMemoView
          AllowVectorExport = True
          Left = 0
          Top = 107.000000000000000000
          Width = 279.000000000000000000
          Height = 11.000000000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -8
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = []
          HAlign = haCenter
          Memo.UTF8W = (
            '----------------------------------------')
          ParentFont = False
        end
        object MemoVenda: TfrxMemoView
          AllowVectorExport = True
          Left = 0
          Top = 117.000000000000000000
          Width = 279.000000000000000000
          Height = 12.000000000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -7
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = []
          WordWrap = False
          Memo.UTF8W = (
            
              'Venda: [FormatFloat('#39'000000'#39',<frxDBDatasetCupom."CODIGO">)]  ' +
              '[FormatDateTime('#39'dd/mm/yyyy hh:nn'#39',<frxDBDatasetCupom."DATA_HO' +
              'RA_VENDA">)]  Sit: [frxDBDatasetCupom."SITUACAO"]')
          ParentFont = False
        end
        object MemoCliente: TfrxMemoView
          AllowVectorExport = True
          Left = 0
          Top = 129.000000000000000000
          Width = 279.000000000000000000
          Height = 12.000000000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -7
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = []
          WordWrap = False
          Memo.UTF8W = (
            
              'Cliente: [FormatFloat('#39'00000'#39',<frxDBDatasetCupom."CODIGO_CLIEN' +
              'TE">)] [Copy(<frxDBDatasetCupom."NOME_CLIENTE">,1,24)]')
          ParentFont = False
        end
        object MemoHdrCod: TfrxMemoView
          AllowVectorExport = True
          Left = 0
          Top = 143.000000000000000000
          Width = 22.000000000000000000
          Height = 12.000000000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -6
          Font.Name = 'Courier New'
          Font.Style = [fsBold]
          Frame.Typ = []
          WordWrap = False
          Memo.UTF8W = (
            'COD')
          ParentFont = False
        end
        object MemoHdrDesc: TfrxMemoView
          AllowVectorExport = True
          Left = 22.000000000000000000
          Top = 143.000000000000000000
          Width = 108.000000000000000000
          Height = 12.000000000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -6
          Font.Name = 'Courier New'
          Font.Style = [fsBold]
          Frame.Typ = []
          WordWrap = False
          Memo.UTF8W = (
            'DESCRICAO')
          ParentFont = False
        end
        object MemoHdrQtd: TfrxMemoView
          AllowVectorExport = True
          Left = 130.000000000000000000
          Top = 143.000000000000000000
          Width = 38.000000000000000000
          Height = 12.000000000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -6
          Font.Name = 'Courier New'
          Font.Style = [fsBold]
          Frame.Typ = []
          HAlign = haRight
          WordWrap = False
          Memo.UTF8W = (
            'QTD')
          ParentFont = False
        end
        object MemoHdrVlUn: TfrxMemoView
          AllowVectorExport = True
          Left = 168.000000000000000000
          Top = 143.000000000000000000
          Width = 48.000000000000000000
          Height = 12.000000000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -6
          Font.Name = 'Courier New'
          Font.Style = [fsBold]
          Frame.Typ = []
          HAlign = haRight
          WordWrap = False
          Memo.UTF8W = (
            'VL.UN')
          ParentFont = False
        end
        object MemoHdrTotal: TfrxMemoView
          AllowVectorExport = True
          Left = 216.000000000000000000
          Top = 143.000000000000000000
          Width = 63.000000000000000000
          Height = 12.000000000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -6
          Font.Name = 'Courier New'
          Font.Style = [fsBold]
          Frame.Typ = []
          HAlign = haRight
          WordWrap = False
          Memo.UTF8W = (
            'TOTAL')
          ParentFont = False
        end
      end
      object MasterData1: TfrxMasterData
        FillType = ftBrush
        FillGap.Top = 0
        FillGap.Left = 0
        FillGap.Bottom = 0
        FillGap.Right = 0
        Frame.Typ = []
        Height = 12.000000000000000000
        Top = 179.000000000000000000
        Width = 279.000000000000000000
        DataSet = frxDBDatasetCupomItens
        DataSetName = 'frxDBDatasetCupomItens'
        RowCount = 0
        object MemoItemCod: TfrxMemoView
          AllowVectorExport = True
          Left = 0
          Top = 0
          Width = 22.000000000000000000
          Height = 11.000000000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -6
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = []
          WordWrap = False
          Memo.UTF8W = (
            '[FormatFloat('#39'000'#39',<frxDBDatasetCupomItens."CODIGO_PRODUTO">)]')
          ParentFont = False
        end
        object MemoItemDesc: TfrxMemoView
          AllowVectorExport = True
          Left = 22.000000000000000000
          Top = 0
          Width = 108.000000000000000000
          Height = 11.000000000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -6
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = []
          WordWrap = False
          Memo.UTF8W = (
            '[Copy(<frxDBDatasetCupomItens."DESCRICAO_PRODUTO">,1,18)]')
          ParentFont = False
        end
        object MemoItemQtd: TfrxMemoView
          AllowVectorExport = True
          Left = 130.000000000000000000
          Top = 0
          Width = 38.000000000000000000
          Height = 11.000000000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -6
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = []
          HAlign = haRight
          WordWrap = False
          Memo.UTF8W = (
            '[FormatFloat('#39'0.000'#39',<frxDBDatasetCupomItens."QUANTIDADE">)]')
          ParentFont = False
        end
        object MemoItemVlUn: TfrxMemoView
          AllowVectorExport = True
          Left = 168.000000000000000000
          Top = 0
          Width = 48.000000000000000000
          Height = 11.000000000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -6
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = []
          HAlign = haRight
          WordWrap = False
          Memo.UTF8W = (
            '[FormatFloat('#39'#,##0.00'#39',<frxDBDatasetCupomItens."PRECO_UNITARIO">)]')
          ParentFont = False
        end
        object MemoItemTotal: TfrxMemoView
          AllowVectorExport = True
          Left = 216.000000000000000000
          Top = 0
          Width = 63.000000000000000000
          Height = 11.000000000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -6
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = []
          HAlign = haRight
          WordWrap = False
          Memo.UTF8W = (
            '[FormatFloat('#39'#,##0.00'#39',<frxDBDatasetCupomItens."TOTAL_LIQUIDO">)]')
          ParentFont = False
        end
      end
      object ReportSummary1: TfrxReportSummary
        FillType = ftBrush
        FillGap.Top = 0
        FillGap.Left = 0
        FillGap.Bottom = 0
        FillGap.Right = 0
        Frame.Typ = []
        Height = 120.000000000000000000
        Top = 213.000000000000000000
        Width = 279.000000000000000000
        object MemoSep3: TfrxMemoView
          AllowVectorExport = True
          Left = 0
          Top = 0
          Width = 279.000000000000000000
          Height = 11.000000000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -8
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = []
          HAlign = haCenter
          Memo.UTF8W = (
            '----------------------------------------')
          ParentFont = False
        end
        object MemoLblBruto: TfrxMemoView
          AllowVectorExport = True
          Left = 0
          Top = 12.000000000000000000
          Width = 120.000000000000000000
          Height = 12.000000000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -8
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = []
          Memo.UTF8W = (
            'TOTAL BRUTO')
          ParentFont = False
        end
        object MemoValBruto: TfrxMemoView
          AllowVectorExport = True
          Left = 120.000000000000000000
          Top = 12.000000000000000000
          Width = 159.000000000000000000
          Height = 12.000000000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -8
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = []
          HAlign = haRight
          WordWrap = False
          Memo.UTF8W = (
            'R$ [FormatFloat('#39'#,##0.00'#39',<frxDBDatasetCupom."TOTAL_BRUTO">)]')
          ParentFont = False
        end
        object MemoLblDesconto: TfrxMemoView
          AllowVectorExport = True
          Left = 0
          Top = 24.000000000000000000
          Width = 120.000000000000000000
          Height = 12.000000000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -8
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = []
          Memo.UTF8W = (
            'DESCONTO')
          ParentFont = False
        end
        object MemoValDesconto: TfrxMemoView
          AllowVectorExport = True
          Left = 120.000000000000000000
          Top = 24.000000000000000000
          Width = 159.000000000000000000
          Height = 12.000000000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -8
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = []
          HAlign = haRight
          WordWrap = False
          Memo.UTF8W = (
            '[FormatFloat('#39'#,##0.00'#39',<frxDBDatasetCupom."DESCONTO_PERC">)]')
          ParentFont = False
        end
        object MemoLblAcrescimo: TfrxMemoView
          AllowVectorExport = True
          Left = 0
          Top = 36.000000000000000000
          Width = 120.000000000000000000
          Height = 12.000000000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -8
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = []
          Memo.UTF8W = (
            'ACRESCIMO')
          ParentFont = False
        end
        object MemoValAcrescimo: TfrxMemoView
          AllowVectorExport = True
          Left = 120.000000000000000000
          Top = 36.000000000000000000
          Width = 159.000000000000000000
          Height = 12.000000000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -8
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = []
          HAlign = haRight
          WordWrap = False
          Memo.UTF8W = (
            '[FormatFloat('#39'#,##0.00'#39',<frxDBDatasetCupom."ACRESCIMO_PER">)]')
          ParentFont = False
        end
        object MemoLblLiquido: TfrxMemoView
          AllowVectorExport = True
          Left = 0
          Top = 50.000000000000000000
          Width = 120.000000000000000000
          Height = 14.000000000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -10
          Font.Name = 'Courier New'
          Font.Style = [fsBold]
          Frame.Typ = []
          Memo.UTF8W = (
            'TOTAL LIQUIDO')
          ParentFont = False
        end
        object MemoValLiquido: TfrxMemoView
          AllowVectorExport = True
          Left = 120.000000000000000000
          Top = 50.000000000000000000
          Width = 159.000000000000000000
          Height = 14.000000000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -10
          Font.Name = 'Courier New'
          Font.Style = [fsBold]
          Frame.Typ = []
          HAlign = haRight
          WordWrap = False
          Memo.UTF8W = (
            'R$ [FormatFloat('#39'#,##0.00'#39',<frxDBDatasetCupom."TOTAL_LIQUIDO">)]')
          ParentFont = False
        end
        object MemoSep4: TfrxMemoView
          AllowVectorExport = True
          Left = 0
          Top = 66.000000000000000000
          Width = 279.000000000000000000
          Height = 11.000000000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -8
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = []
          HAlign = haCenter
          Memo.UTF8W = (
            '----------------------------------------')
          ParentFont = False
        end
        object MemoChave: TfrxMemoView
          AllowVectorExport = True
          Left = 0
          Top = 76.000000000000000000
          Width = 279.000000000000000000
          Height = 20.000000000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -7
          Font.Name = 'Courier New'
          Font.Style = []
          Frame.Typ = []
          HAlign = haCenter
          Memo.UTF8W = (
            'Consulte pela Chave de Acesso'
            '0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000')
          ParentFont = False
        end
        object MemoAviso: TfrxMemoView
          AllowVectorExport = True
          Left = 0
          Top = 98.000000000000000000
          Width = 279.000000000000000000
          Height = 18.000000000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -7
          Font.Name = 'Courier New'
          Font.Style = [fsBold]
          Frame.Typ = []
          HAlign = haCenter
          Memo.UTF8W = (
            'DOCUMENTO AUXILIAR'
            'SEM VALOR FISCAL')
          ParentFont = False
        end
      end
    end
  end
  object frxExportPDF: TfrxPDFExport
    Compressed = False
    Left = 256
    Top = 64
  end
  object frxExportExcel: TfrxXMLExport
    Left = 40
    Top = 96
  end
  object frxExportWord: TfrxRTFExport
    Left = 128
    Top = 96
  end
  object frxExportCSV: TfrxCSVExport
    Left = 216
    Top = 96
  end
end
