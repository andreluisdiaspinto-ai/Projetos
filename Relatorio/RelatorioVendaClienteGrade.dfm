object Form_RelatorioVendaClienteGrade: TForm_RelatorioVendaClienteGrade
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'Relat'#243'rio de Venda Cliente (Grade)'
  ClientHeight = 720
  ClientWidth = 1120
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
    Width = 1120
    Height = 50
    Align = alTop
    Alignment = taLeftJustify
    BevelOuter = bvNone
    Caption = '   Relat'#243'rio de Venda Cliente (Grade)'
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
    Width = 1120
    Height = 220
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
      Top = 10
      Width = 65
      Height = 15
      Caption = 'C'#243'digo final'
    end
    object LabelDataDe: TLabel
      Left = 496
      Top = 10
      Width = 58
      Height = 15
      Caption = 'Data inicial'
    end
    object LabelDataAte: TLabel
      Left = 620
      Top = 10
      Width = 50
      Height = 15
      Caption = 'Data final'
    end
    object LabelCodigoCliente: TLabel
      Left = 248
      Top = 62
      Width = 79
      Height = 15
      Caption = 'C'#243'digo Cliente'
    end
    object LabelProgresso: TLabel
      Left = 248
      Top = 178
      Width = 480
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
        'Ordem por Data'
        'Ordem por C'#243'digo'
        'Ordem Alfab'#233'tica (Cliente)')
      ParentFont = False
      TabOrder = 0
    end
    object RadioGrupoSituacao: TRadioGroup
      Left = 16
      Top = 112
      Width = 212
      Height = 98
      Caption = 'Situa'#231#227'o da venda '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 3355443
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ItemIndex = 0
      Items.Strings = (
        'Todas'
        'A - Abertas'
        'F - Fechadas')
      ParentFont = False
      TabOrder = 1
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
      TabOrder = 2
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
      TabOrder = 3
      OnEnter = EditFocoEnter
      OnExit = EditFocoExit
      OnKeyPress = EditNumericoKeyPress
    end
    object EditDataDe: TEdit
      Left = 496
      Top = 29
      Width = 110
      Height = 25
      Hint = 'Data inicial da venda no formato dd/mm/yyyy (vazio = sem limite)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 3355443
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      MaxLength = 10
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      TextHint = 'dd/mm/yyyy'
      OnEnter = EditFocoEnter
      OnExit = EditFocoExit
      OnKeyPress = EditDataKeyPress
    end
    object EditDataAte: TEdit
      Left = 620
      Top = 29
      Width = 110
      Height = 25
      Hint = 'Data final da venda no formato dd/mm/yyyy (vazio = sem limite)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 3355443
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      MaxLength = 10
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
      TextHint = 'dd/mm/yyyy'
      OnEnter = EditFocoEnter
      OnExit = EditFocoExit
      OnKeyPress = EditDataKeyPress
    end
    object EditCodigoCliente: TEdit
      Left = 248
      Top = 81
      Width = 90
      Height = 25
      Hint = 'Filtra pelo c'#243'digo do cliente (vazio = sem filtro)'
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
      TabOrder = 6
      OnEnter = EditFocoEnter
      OnExit = EditFocoExit
      OnKeyPress = EditNumericoKeyPress
    end
    object EditNomeCliente: TEdit
      Left = 344
      Top = 81
      Width = 700
      Height = 25
      Hint = 'Filtra pelos nomes que come'#231'am pelo texto informado'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 3355443
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      MaxLength = 60
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 7
      OnEnter = EditFocoEnter
      OnExit = EditFocoExit
    end
    object BtnLupaCliente: TBitBtn
      Left = 1050
      Top = 79
      Width = 32
      Height = 29
      Hint = 'Consultar cliente'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 8
      OnClick = BtnLupaClienteClick
    end
    object ProgressBarPesquisa: TProgressBar
      Left = 744
      Top = 176
      Width = 338
      Height = 20
      Hint = 'Percentual da pesquisa em execu'#231#227'o'
      ParentShowHint = False
      Smooth = True
      ShowHint = True
      TabOrder = 9
    end
  end
  object DBGridVendaCliente: TDBGrid
    Left = 0
    Top = 270
    Width = 1120
    Height = 384
    Align = alClient
    DataSource = DsVendaCliente
    DrawingStyle = gdsClassic
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    ReadOnly = True
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = 3355443
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    OnDrawColumnCell = DBGridVendaClienteDrawColumnCell
    Columns = <
      item
        Expanded = False
        FieldName = 'CODIGO_CLIENTE'
        Title.Caption = 'C'#243'd. Cli.'
        Width = 60
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'NOME'
        Title.Caption = 'Cliente'
        Width = 300
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'DATA'
        Title.Caption = 'Data'
        Width = 100
        Visible = True
      end
      item
        Alignment = taRightJustify
        Expanded = False
        FieldName = 'TOTAL_BRUTO'
        Title.Alignment = taRightJustify
        Title.Caption = 'Total Bruto'
        Width = 120
        Visible = True
      end
      item
        Alignment = taRightJustify
        Expanded = False
        FieldName = 'TOTAL_VENDA'
        Title.Alignment = taRightJustify
        Title.Caption = 'Total L'#237'quido'
        Width = 120
        Visible = True
      end>
  end
  object PanelRodape: TPanel
    Left = 0
    Top = 654
    Width = 1120
    Height = 66
    Align = alBottom
    BevelOuter = bvNone
    Color = 15790320
    ParentBackground = False
    TabOrder = 3
    object BtnPesquisar: TBitBtn
      Left = 280
      Top = 12
      Width = 130
      Height = 42
      Hint = 'Pesquisar vendas com os filtros informados'
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
      Left = 426
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
      Left = 572
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
      Left = 718
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
  object QueryVendaCliente: TIBQuery
    Database = DM.Conexao
    Transaction = DM.IBTransaction1
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    SQL.Strings = (
      'select'
      '  vc.CODIGO_CLIENTE,'
      '  cli.NOME as NOME,'
      '  cast(vc.DATA_HORA_VENDA as date) as DATA,'
      '  coalesce(sum(vc.TOTAL_BRUTO),0) as TOTAL_BRUTO,'
      '  coalesce(sum(vc.TOTAL_LIQUIDO),0) as TOTAL_VENDA'
      'from VENDA vc'
      '  inner join CLIENTE cli    on cli.CODIGO = vc.CODIGO_CLIENTE'
      'group by vc.CODIGO_CLIENTE, cli.NOME, cast(vc.DATA_HORA_VENDA as date)'
      'order by cast(vc.DATA_HORA_VENDA as date), cli.NOME')
    PrecommittedReads = False
    Left = 24
    Top = 495
  end
  object DsVendaCliente: TDataSource
    DataSet = QueryVendaCliente
    Left = 96
    Top = 496
  end
  object frxDBDatasetVendaCliente: TfrxDBDataset
    UserName = 'frxDBDatasetVendaCliente'
    CloseDataSource = False
    DataSet = QueryVendaCliente
    BCDToCurrency = False
    DataSetOptions = []
    Left = 288
    Top = 496
  end
  object QueryGraficoPorCliente: TIBQuery
    Database = DM.Conexao
    Transaction = DM.IBTransaction1
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    SQL.Strings = (
      'with G as ('
      '  select'
      '    cli.CODIGO as CODIGO_CLIENTE,'
      '    cli.NOME as NOME_CLIENTE,'
      '    sum(vc.TOTAL_LIQUIDO) as TOTAL_CLIENTE'
      '  from VENDA vc'
      '    inner join CLIENTE cli    on cli.CODIGO = vc.CODIGO_CLIENTE'
      '  group by cli.CODIGO, cli.NOME)'
      'select'
      '  g.CODIGO_CLIENTE,'
      '  g.NOME_CLIENTE,'
      '  g.TOTAL_CLIENTE,'
      '  g.NOME_CLIENTE || '#39' ('#39' ||'
      '    replace(cast(cast('
      '      case'
      '        when (select coalesce(sum(t.TOTAL_CLIENTE), 0) from G t) = 0'
      '          then 0'
      '        else g.TOTAL_CLIENTE * 100.00 /'
      '             (select sum(t.TOTAL_CLIENTE) from G t)'
      '      end as numeric(15,1)) as varchar(20)), '#39'.'#39', '#39','#39') ||'
      '    '#39'%)'#39' as LEGENDA_CLIENTE'
      ' from G g'
      ' order by g.NOME_CLIENTE')
    PrecommittedReads = False
    Left = 24
    Top = 560
  end
  object frxDBDatasetGraficoPorCliente: TfrxDBDataset
    UserName = 'frxDBDatasetGraficoPorCliente'
    CloseDataSource = False
    DataSet = QueryGraficoPorCliente
    BCDToCurrency = False
    DataSetOptions = []
    Left = 288
    Top = 560
  end
  object frxReportVendaCliente: TfrxReport
    Version = '2023.1.3'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick, pbCopy, pbSelection]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = 'Default'
    PrintOptions.PrintOnSheet = 0
    ReportOptions.CreateDate = 46212.495831759300000000
    ReportOptions.LastChange = 46212.498667187500000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      'begin'
      'end.')
    Left = 216
    Top = 496
    Datasets = <
      item
        DataSet = frxDBDatasetVendaCliente
        DataSetName = 'frxDBDatasetVendaCliente'
      end
      item
        DataSet = frxDBDatasetGraficoPorCliente
        DataSetName = 'frxDBDatasetGraficoPorCliente'
      end>
    Variables = <
      item
        Name = 'Filtros'
        Value = Null
      end
      item
        Name = 'DataEmissao'
        Value = Null
      end
      item
        Name = 'HoraEmissao'
        Value = Null
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
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        Height = 94.031540000000000000
        Width = 718.110700000000000000
        object MemoTituloRelatorio: TfrxMemoView
          AllowVectorExport = True
          Left = 160.000000000000000000
          Top = 3.779530000000000000
          Width = 390.000000000000000000
          Height = 22.000000000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -18
          Font.Name = 'Arial'
          Font.Style = [fsBold, fsItalic]
          Frame.Typ = []
          HAlign = haCenter
          Memo.UTF8W = (
            'Relat'#243'rio de Venda Cliente (Grade)')
          ParentFont = False
        end
      end
      object ReportSummary1: TfrxReportSummary
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        Height = 120.000000000000000000
        Top = 120.000000000000000000
        Width = 718.110700000000000000
        object MemoTituloGrafico: TfrxMemoView
          AllowVectorExport = True
          Left = 6.000000000000000000
          Top = 6.000000000000000000
          Width = 400.000000000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          Memo.UTF8W = (
            'Gr'#225'fico de pizza - total l'#237'quido por cliente')
          ParentFont = False
        end
      end
      object PageFooter1: TfrxPageFooter
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        Height = 24.000000000000000000
        Top = 260.000000000000000000
        Width = 718.110700000000000000
        object MemoRodape: TfrxMemoView
          AllowVectorExport = True
          Left = 6.000000000000000000
          Top = 4.000000000000000000
          Width = 600.000000000000000000
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
