object Form_RelatorioCliente: TForm_RelatorioCliente
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'Relat'#243'rio de Clientes'
  ClientHeight = 620
  ClientWidth = 990
  Color = 16119285
  Font.Charset = DEFAULT_CHARSET
  Font.Color = 3355443
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  FormStyle = fsMDIChild
  WindowState = wsNormal
  KeyPreview = True
  Position = poMainFormCenter
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 15
  object Panel_Titulo: TPanel
    Left = 0
    Top = 0
    Width = 990
    Height = 50
    Align = alTop
    Alignment = taLeftJustify
    BevelOuter = bvNone
    Caption = '   Relat'#243'rio de Clientes'
    Color = 16608781
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -20
    Font.Name = 'Segoe UI Semibold'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 0
  end
  object PanelFiltros: TPanel
    Left = 0
    Top = 50
    Width = 990
    Height = 118
    Align = alTop
    BevelOuter = bvNone
    Color = 16119285
    ParentBackground = False
    TabOrder = 1
    object LabelCodigoDe: TLabel
      Left = 248
      Top = 10
      Width = 73
      Height = 15
      Caption = 'C'#243'digo inicial'
    end
    object LabelCodigoAte: TLabel
      Left = 372
      Top = 8
      Width = 65
      Height = 15
      Caption = 'C'#243'digo final'
    end
    object LabelBairro: TLabel
      Left = 248
      Top = 62
      Width = 31
      Height = 15
      Caption = 'Bairro'
    end
    object LabelCidade: TLabel
      Left = 500
      Top = 62
      Width = 37
      Height = 15
      Caption = 'Cidade'
    end
    object LabelProgresso: TLabel
      Left = 750
      Top = 62
      Width = 224
      Height = 15
      AutoSize = False
      Caption = 'Aguardando pesquisa'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object RadioGrupoOrdem: TRadioGroup
      Left = 16
      Top = 8
      Width = 212
      Height = 98
      Caption = 'Ordem do relat'#243'rio '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 3355443
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ItemIndex = 0
      Items.Strings = (
        'Ordem Alfab'#233'tica'
        'Ordem por C'#243'digo')
      ParentFont = False
      TabOrder = 0
    end
    object EditCodigoDe: TEdit
      Left = 248
      Top = 29
      Width = 110
      Height = 25
      Hint = 'C'#243'digo inicial da faixa (vazio = sem limite)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 3355443
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      MaxLength = 9
      NumbersOnly = True
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnEnter = EditFocoEnter
      OnExit = EditFocoExit
      OnKeyPress = EditNumericoKeyPress
    end
    object EditCodigoAte: TEdit
      Left = 372
      Top = 29
      Width = 110
      Height = 25
      Hint = 'C'#243'digo final da faixa (vazio = sem limite)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 3355443
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      MaxLength = 9
      NumbersOnly = True
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnEnter = EditFocoEnter
      OnExit = EditFocoExit
      OnKeyPress = EditNumericoKeyPress
    end
    object EditBairro: TEdit
      Left = 248
      Top = 81
      Width = 234
      Height = 25
      Hint = 'Filtra os bairros que come'#231'am pelo texto informado'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 3355443
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      MaxLength = 30
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      OnEnter = EditFocoEnter
      OnExit = EditFocoExit
    end
    object EditCidade: TEdit
      Left = 500
      Top = 81
      Width = 234
      Height = 25
      Hint = 'Filtra as cidades que come'#231'am pelo texto informado'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 3355443
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      MaxLength = 30
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      OnEnter = EditFocoEnter
      OnExit = EditFocoExit
    end
    object ProgressBarPesquisa: TProgressBar
      Left = 750
      Top = 81
      Width = 224
      Height = 25
      Hint = 'Percentual da pesquisa em execu'#231#227'o'
      ParentShowHint = False
      Smooth = True
      ShowHint = True
      TabOrder = 5
    end
  end
  object DBGridCliente: TDBGrid
    Left = 0
    Top = 168
    Width = 990
    Height = 386
    Align = alClient
    DataSource = DsCliente
    DrawingStyle = gdsClassic
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    ReadOnly = True
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = 3355443
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    OnDrawColumnCell = DBGridClienteDrawColumnCell
    Columns = <
      item
        Expanded = False
        FieldName = 'CODIGO'
        Title.Caption = 'C'#243'digo'
        Width = 60
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'NOME'
        Title.Caption = 'Nome'
        Width = 236
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'ENDERECO'
        Title.Caption = 'Endere'#231'o'
        Width = 219
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'BAIRRO'
        Title.Caption = 'Bairro'
        Width = 144
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'CIDADE'
        Title.Caption = 'Cidade'
        Width = 166
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'TELEFONE'
        Title.Caption = 'Telefone'
        Width = 110
        Visible = True
      end>
  end
  object PanelRodape: TPanel
    Left = 0
    Top = 554
    Width = 990
    Height = 66
    Align = alBottom
    BevelOuter = bvNone
    Color = 15790320
    ParentBackground = False
    TabOrder = 3
    object BtnPesquisar: TBitBtn
      Left = 211
      Top = 12
      Width = 130
      Height = 42
      Hint = 'Pesquisar clientes com os filtros informados'
      Caption = '&Pesquisar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      Margin = 10
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      Spacing = 8
      TabOrder = 0
      OnClick = BtnPesquisarClick
    end
    object BtnLimpar: TBitBtn
      Left = 357
      Top = 12
      Width = 130
      Height = 42
      Hint = 'Limpar os filtros e refazer a pesquisa'
      Caption = '&Limpar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 4210752
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      Margin = 10
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      Spacing = 8
      TabOrder = 1
      OnClick = BtnLimparClick
    end
    object BtnImprimir: TBitBtn
      Left = 503
      Top = 12
      Width = 130
      Height = 42
      Hint = 'Imprimir o resultado da pesquisa'
      Caption = '&Imprimir'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      Margin = 10
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      Spacing = 8
      TabOrder = 2
      OnClick = BtnImprimirClick
    end
    object BtnSair: TBitBtn
      Left = 649
      Top = 12
      Width = 130
      Height = 42
      Hint = 'Fechar o relat'#243'rio (ESC)'
      Caption = '&Sair'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 6710015
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      Margin = 10
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      Spacing = 8
      TabOrder = 3
      OnClick = BtnSairClick
    end
  end
  object QueryCliente: TIBQuery
    Database = DM.Conexao
    Transaction = DM.IBTransaction1
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    SQL.Strings = (
      
        'select CODIGO, NOME, ENDERECO, BAIRRO, CIDADE, TELEFONE from Cli' +
        'ente order by NOME')
    PrecommittedReads = False
    Left = 24
    Top = 495
  end
  object DsCliente: TDataSource
    DataSet = QueryCliente
    Left = 93
    Top = 496
  end
  object frxDBDatasetCliente: TfrxDBDataset
    UserName = 'frxDBDatasetCliente'
    CloseDataSource = False
    DataSet = QueryCliente
    BCDToCurrency = False
    DataSetOptions = []
    Left = 288
    Top = 496
  end
  object frxReportCliente: TfrxReport
    Version = '2023.1.3'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick, pbCopy, pbSelection]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = 'Default'
    PrintOptions.PrintOnSheet = 0
    ReportOptions.CreateDate = 46211.560532106500000000
    ReportOptions.LastChange = 46211.614572060190000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      ''
      'procedure MasterData1OnBeforePrint(Sender: TfrxComponent);'
      'begin'
      '  if(<cor> = 1)then begin'
      '    Shape1.Visible:= true;'
      
        '    Report.Variables['#39'cor'#39']:= 0;                                ' +
        '                '
      '  end else if (<cor> = 0) then begin'
      '    Shape1.Visible:= false;'
      '    Report.Variables['#39'cor'#39']:= 1;  '
      '  end;  '
      'end;'
      ''
      'begin'
      ''
      'end.')
    Left = 168
    Top = 496
    Datasets = <
      item
        DataSet = frxDBDatasetCliente
        DataSetName = 'frxDBDatasetCliente'
      end>
    Variables = <
      item
        Name = ' Especifica'
        Value = Null
      end
      item
        Name = 'Cor'
        Value = '0'
      end>
    Style = <>
    object Data: TfrxDataPage
      Height = 1000.000000000000000000
      Width = 1000.000000000000000000
    end
    object Page1: TfrxReportPage
      PaperWidth = 210.000000000000000000
      PaperHeight = 297.000000000000000000
      PaperSize = 9
      LeftMargin = 10.000000000000000000
      RightMargin = 10.000000000000000000
      TopMargin = 10.000000000000000000
      BottomMargin = 10.000000000000000000
      Frame.Typ = []
      MirrorMode = []
      object ReportTitle1: TfrxReportTitle
        FillType = ftBrush
        FillGap.Top = 0
        FillGap.Left = 0
        FillGap.Bottom = 0
        FillGap.Right = 0
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        Height = 94.488250000000000000
        Width = 718.110700000000000000
        object MemoSoftHouse: TfrxMemoView
          AllowVectorExport = True
          Left = 3.779530000000000000
          Top = 3.779530000000000000
          Width = 166.299320000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -19
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          Memo.UTF8W = (
            'Ganso Sistemas')
          ParentFont = False
        end
        object MemoEmpresa: TfrxMemoView
          AllowVectorExport = True
          Left = 7.559060000000000000
          Top = 37.795300000000000000
          Width = 272.126160000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          Memo.UTF8W = (
            'Empresa: Ganso Demonstra'#231#227'o Ltda')
          ParentFont = False
        end
        object MemoTituloRelatorio: TfrxMemoView
          AllowVectorExport = True
          Left = 245.669450000000000000
          Top = 3.779530000000000000
          Width = 275.905690000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = [fsBold, fsItalic]
          Frame.Typ = []
          Memo.UTF8W = (
            'Relat'#243'rio de Cadastro de Clientes')
          ParentFont = False
        end
        object MemoData: TfrxMemoView
          AllowVectorExport = True
          Left = 570.709030000000000000
          Top = 3.779530000000000000
          Width = 52.913420000000000000
          Height = 18.897650000000000000
          DisplayFormat.FormatStr = 'dd mmm yyyy'
          DisplayFormat.Kind = fkDateTime
          Frame.Typ = []
          Memo.UTF8W = (
            'Data....: ')
        end
        object MemoHora: TfrxMemoView
          AllowVectorExport = True
          Left = 570.709030000000000000
          Top = 37.795300000000000000
          Width = 52.913420000000000000
          Height = 18.897650000000000000
          DisplayFormat.FormatStr = 'hh:mm:ss'
          DisplayFormat.Kind = fkDateTime
          Frame.Typ = []
          Memo.UTF8W = (
            'Hora....: ')
        end
        object MemoFiltro: TfrxMemoView
          AllowVectorExport = True
          Left = 3.779530000000000000
          Top = 64.252010000000000000
          Width = 517.795610000000000000
          Height = 18.897650000000000000
          Frame.Typ = []
          Memo.UTF8W = (
            'Filtro:')
        end
        object MemoDataEmis: TfrxMemoView
          AllowVectorExport = True
          Left = 569.929500000000000000
          Top = 64.252010000000000000
          Width = 52.913420000000000000
          Height = 18.897650000000000000
          Frame.Typ = []
          Memo.UTF8W = (
            'P'#225'gina.: ')
        end
        object Date: TfrxMemoView
          IndexTag = 1
          Align = baRight
          AllowVectorExport = True
          Left = 638.740570000000000000
          Top = 3.779530000000000000
          Width = 79.370130000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          HAlign = haRight
          Memo.UTF8W = (
            '[Date]')
          ParentFont = False
        end
        object Time: TfrxMemoView
          IndexTag = 1
          Align = baRight
          AllowVectorExport = True
          Left = 653.858690000000000000
          Top = 37.795300000000000000
          Width = 64.252010000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          HAlign = haRight
          Memo.UTF8W = (
            '[Time]')
          ParentFont = False
        end
        object TotalPages: TfrxMemoView
          IndexTag = 1
          AllowVectorExport = True
          Left = 654.417750000000000000
          Top = 64.472480000000000000
          Width = 60.472480000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          HAlign = haRight
          Memo.UTF8W = (
            '[TotalPages#]')
          ParentFont = False
        end
        object Page: TfrxMemoView
          IndexTag = 1
          AllowVectorExport = True
          Left = 623.622450000000000000
          Top = 64.252010000000000000
          Width = 37.795300000000000000
          Height = 18.897650000000000000
          Frame.Typ = []
          Memo.UTF8W = (
            '[Page#]')
        end
      end
      object MasterData1: TfrxMasterData
        FillType = ftBrush
        FillGap.Top = 0
        FillGap.Left = 0
        FillGap.Bottom = 0
        FillGap.Right = 0
        Frame.Typ = [ftLeft, ftRight, ftBottom]
        Height = 28.456710000000000000
        Top = 132.283550000000000000
        Width = 718.110700000000000000
        OnBeforePrint = 'MasterData1OnBeforePrint'
        DataSet = frxDBDatasetCliente
        DataSetName = 'frxDBDatasetCliente'
        RowCount = 0
        object Shape1: TfrxShapeView
          AllowVectorExport = True
          Left = 2.000000000000000000
          Top = 2.000000000000000000
          Width = 714.331170000000000000
          Height = 26.456710000000000000
          Fill.BackColor = 15790320
          Frame.Color = clNone
          Frame.Typ = []
        end
        object frxDBDatasetClienteCODIGO: TfrxMemoView
          IndexTag = 1
          AllowVectorExport = True
          Top = 3.779530000000000000
          Width = 60.472480000000000000
          Height = 18.897650000000000000
          DataField = 'CODIGO'
          DataSet = frxDBDatasetCliente
          DataSetName = 'frxDBDatasetCliente'
          DisplayFormat.FormatStr = '00000'
          DisplayFormat.Kind = fkNumeric
          Frame.Typ = []
          Memo.UTF8W = (
            '[frxDBDatasetCliente."CODIGO"]')
        end
        object frxDBDatasetClienteNOME: TfrxMemoView
          IndexTag = 1
          AllowVectorExport = True
          Left = 42.472480000000000000
          Top = 3.779530000000000000
          Width = 188.976500000000000000
          Height = 18.897650000000000000
          DataField = 'NOME'
          DataSet = frxDBDatasetCliente
          DataSetName = 'frxDBDatasetCliente'
          Frame.Typ = []
          Memo.UTF8W = (
            '[frxDBDatasetCliente."NOME"]')
        end
        object frxDBDatasetClienteENDERECO: TfrxMemoView
          IndexTag = 1
          AllowVectorExport = True
          Left = 224.448980000000000000
          Top = 3.779530000000000000
          Width = 192.756030000000000000
          Height = 18.897650000000000000
          DataField = 'ENDERECO'
          DataSet = frxDBDatasetCliente
          DataSetName = 'frxDBDatasetCliente'
          Frame.Typ = []
          Memo.UTF8W = (
            '[frxDBDatasetCliente."ENDERECO"]')
        end
        object frxDBDatasetClienteTELEFONE: TfrxMemoView
          IndexTag = 1
          AllowVectorExport = True
          Left = 616.063390000000000000
          Top = 3.779530000000000000
          Width = 98.267780000000000000
          Height = 18.897650000000000000
          DataField = 'TELEFONE'
          DataSet = frxDBDatasetCliente
          DataSetName = 'frxDBDatasetCliente'
          Frame.Typ = []
          Memo.UTF8W = (
            '[frxDBDatasetCliente."TELEFONE"]')
        end
        object frxDBDatasetClienteBAIRRO: TfrxMemoView
          IndexTag = 1
          AllowVectorExport = True
          Left = 504.134200000000000000
          Top = 3.779530000000000000
          Width = 120.944960000000000000
          Height = 18.897650000000000000
          DataField = 'CIDADE'
          DataSet = frxDBDatasetCliente
          DataSetName = 'frxDBDatasetCliente'
          Frame.Typ = []
          Memo.UTF8W = (
            '[frxDBDatasetCliente."CIDADE"]')
        end
        object frxDBDatasetClienteBAIRRO1: TfrxMemoView
          IndexTag = 1
          AllowVectorExport = True
          Left = 420.086890000000000000
          Top = 3.779530000000000000
          Width = 94.488250000000000000
          Height = 18.897650000000000000
          DataField = 'BAIRRO'
          DataSet = frxDBDatasetCliente
          DataSetName = 'frxDBDatasetCliente'
          Frame.Typ = []
          Memo.UTF8W = (
            '[frxDBDatasetCliente."BAIRRO"]')
        end
      end
      object PageFooter1: TfrxPageFooter
        FillType = ftBrush
        FillGap.Top = 0
        FillGap.Left = 0
        FillGap.Bottom = 0
        FillGap.Right = 0
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        Height = 31.015770000000000000
        Top = 200.315090000000000000
        Width = 718.110700000000000000
        object Shape2: TfrxShapeView
          AllowVectorExport = True
          Left = 1.000000000000000000
          Top = 1.779530000000000000
          Width = 714.331170000000000000
          Height = 26.456710000000000000
          Fill.BackColor = 15790320
          Frame.Color = clNone
          Frame.Typ = []
        end
        object Memo1: TfrxMemoView
          AllowVectorExport = True
          Left = 7.559060000000000000
          Top = 8.118120000000000000
          Width = 442.205010000000000000
          Height = 18.897650000000000000
          Frame.Typ = []
          Memo.UTF8W = (
            
              'Relat'#243'rio Desenvolvido e Impresso Por: Ganso Sistemas CopyRight(' +
              'c) Reservados.')
        end
      end
    end
  end
  object frxExportPDF: TfrxPDFExport
    Compressed = False
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    DataOnly = False
    EmbedFontsIfProtected = False
    InteractiveFormsFontSubset = 'A-Z,a-z,0-9,#43-#47 '
    OpenAfterExport = False
    PrintOptimized = False
    Outline = False
    Background = False
    HTMLTags = True
    Quality = 95
    Author = 'FastReport'
    Subject = 'FastReport PDF export'
    Creator = 'FastReport'
    ProtectionFlags = [ePrint, eModify, eCopy, eAnnot]
    HideToolbar = False
    HideMenubar = False
    HideWindowUI = False
    FitWindow = False
    CenterWindow = False
    PrintScaling = False
    PdfA = False
    PDFStandard = psNone
    PDFVersion = pv17
    Left = 360
    Top = 496
  end
  object frxExportExcel: TfrxXMLExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    Background = False
    Creator = 'FastReport'
    EmptyLines = True
    ExportPageBreaks = True
    ExportStyles = True
    OpenExcelAfterExport = False
    SuppressPageHeadersFooters = False
    Wysiwyg = True
    Left = 432
    Top = 496
  end
  object frxExportWord: TfrxRTFExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    DataOnly = False
    PictureType = gpPNG
    OpenAfterExport = False
    Wysiwyg = True
    Creator = 'FastReport'
    SuppressPageHeadersFooters = False
    HeaderFooterMode = hfText
    AutoSize = False
    Left = 504
    Top = 496
  end
  object frxExportCSV: TfrxCSVExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    DataOnly = False
    Separator = ';'
    OEMCodepage = False
    UTF8 = False
    OpenAfterExport = False
    NoSysSymbols = True
    ForcedQuotes = False
    Left = 576
    Top = 496
  end
end
