object Form_RelatorioVendaSinteticaCliente: TForm_RelatorioVendaSinteticaCliente
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'Relat'#243'rio de Venda Sint'#233'tica por Cliente'
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
    Caption = '   Relat'#243'rio de Venda Sint'#233'tica por Cliente'
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
      TabOrder = 12
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
        FieldName = 'CODIGO'
        Title.Caption = 'Venda'
        Width = 60
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'DATA_HORA_VENDA'
        Title.Caption = 'Data'
        Width = 90
        Visible = True
      end
      item
        Alignment = taCenter
        Expanded = False
        FieldName = 'SITUACAO'
        Title.Alignment = taCenter
        Title.Caption = 'Sit.'
        Width = 40
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'CODIGO_CLIENTE'
        Title.Caption = 'C'#243'd. Cli.'
        Width = 60
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'NOME_CLIENTE'
        Title.Caption = 'Cliente'
        Width = 240
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'TELEFONE_CLIENTE'
        Title.Caption = 'Telefone'
        Width = 120
        Visible = True
      end
      item
        Alignment = taRightJustify
        Expanded = False
        FieldName = 'TOTAL_BRUTO'
        Title.Alignment = taRightJustify
        Title.Caption = 'Total Bruto'
        Width = 100
        Visible = True
      end
      item
        Alignment = taRightJustify
        Expanded = False
        FieldName = 'TOTAL_LIQUIDO'
        Title.Alignment = taRightJustify
        Title.Caption = 'Total L'#237'quido'
        Width = 100
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
      '  vc.CODIGO,'
      '  vc.DATA_HORA_VENDA,'
      '  vc.SITUACAO,'
      '  vc.CODIGO_CLIENTE,'
      '  cli.NOME as NOME_CLIENTE,'
      '  cli.TELEFONE as TELEFONE_CLIENTE,'
      '  vc.TOTAL_BRUTO,'
      '  vc.TOTAL_LIQUIDO'
      'from VENDA vc'
      '  inner join CLIENTE cli    on cli.CODIGO = vc.CODIGO_CLIENTE'
      'order by cli.NOME, vc.DATA_HORA_VENDA, vc.CODIGO')
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
      'var'
      
        '  TotalMestreBruto, TotalMestreLiquido, TotalDetalheLiquido: Ext' +
        'ended;'
      '  QtdVendas: Integer;'
      ''
      'procedure MasterData1OnBeforePrint(Sender: TfrxComponent);'
      'begin'
      
        '  TotalDetalheLiquido := TotalDetalheLiquido + <frxDBDatasetVend' +
        'aCliente."TOTAL_LIQUIDO">;'
      'end;'
      ''
      'procedure GroupFooterVendaOnBeforePrint(Sender: TfrxComponent);'
      'begin'
      
        '  TotalMestreBruto   := TotalMestreBruto + <frxDBDatasetVendaCli' +
        'ente."TOTAL_BRUTO_VENDA">;'
      
        '  TotalMestreLiquido := TotalMestreLiquido + <frxDBDatasetVendaC' +
        'liente."TOTAL_VENDA">;'
      '  QtdVendas := QtdVendas + 1;'
      'end;'
      ''
      'procedure ReportSummary1OnBeforePrint(Sender: TfrxComponent);'
      'begin'
      
        '  MemoTotalGeralBruto.Text      := FormatFloat('#39'0.00'#39', TotalMest' +
        'reBruto);'
      
        '  MemoTotalDetalheLiquido.Text  := FormatFloat('#39'0.00'#39', TotalDeta' +
        'lheLiquido);'
      
        '  MemoTotalGeralLiquido.Text    := FormatFloat('#39'0.00'#39', TotalMest' +
        'reLiquido);'
      '  MemoQtdVendas.Text            := IntToStr(QtdVendas);'
      'end;'
      ''
      'begin'
      '  TotalMestreBruto    := 0;'
      '  TotalMestreLiquido  := 0;'
      '  TotalDetalheLiquido := 0;'
      '  QtdVendas           := 0;'
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
        FillType = ftBrush
        FillGap.Top = 0
        FillGap.Left = 0
        FillGap.Bottom = 0
        FillGap.Right = 0
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        Height = 94.031540000000000000
        Width = 718.110700000000000000
        object MemoSoftHouse: TfrxMemoView
          AllowVectorExport = True
          Left = 3.779530000000000000
          Top = 3.779530000000000000
          Width = 200.000000000000000000
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
          Left = 3.779530000000000000
          Top = 30.000000000000000000
          Width = 350.000000000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -14
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          Memo.UTF8W = (
            'Empresa: Ganso Demonstra'#231#227'o Ltda')
          ParentFont = False
        end
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
            'Relat'#243'rio de Venda por Cliente')
          ParentFont = False
        end
        object MemoDataLabel: TfrxMemoView
          AllowVectorExport = True
          Left = 560.000000000000000000
          Top = 3.779530000000000000
          Width = 55.000000000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          Memo.UTF8W = (
            'Data....:')
          ParentFont = False
          WordWrap = False
        end
        object MemoDataValor: TfrxMemoView
          AllowVectorExport = True
          Left = 618.000000000000000000
          Top = 3.779530000000000000
          Width = 95.000000000000000000
          DisplayFormat.FormatStr = 'dd/mm/yyyy'
          DisplayFormat.Kind = fkDateTime
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          HAlign = haRight
          Memo.UTF8W = (
            '[Date]')
          ParentFont = False
          WordWrap = False
        end
        object MemoHoraLabel: TfrxMemoView
          AllowVectorExport = True
          Left = 560.000000000000000000
          Top = 22.677180000000000000
          Width = 55.000000000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          Memo.UTF8W = (
            'Hora....:')
          ParentFont = False
          WordWrap = False
        end
        object MemoHoraValor: TfrxMemoView
          AllowVectorExport = True
          Left = 618.000000000000000000
          Top = 22.677180000000000000
          Width = 95.000000000000000000
          DisplayFormat.FormatStr = 'hh:mm:ss'
          DisplayFormat.Kind = fkDateTime
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          HAlign = haRight
          Memo.UTF8W = (
            '[Time]')
          ParentFont = False
          WordWrap = False
        end
        object MemoPaginaLabel: TfrxMemoView
          AllowVectorExport = True
          Left = 560.000000000000000000
          Top = 41.574830000000000000
          Width = 55.000000000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          Memo.UTF8W = (
            'P'#225'gina.:')
          ParentFont = False
          WordWrap = False
        end
        object MemoPaginaValor: TfrxMemoView
          IndexTag = 1
          AllowVectorExport = True
          Left = 618.000000000000000000
          Top = 41.574830000000000000
          Width = 95.000000000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          HAlign = haRight
          Memo.UTF8W = (
            '[Page#]/[TotalPages#]')
          ParentFont = False
          WordWrap = False
        end
        object MemoFiltroLabel: TfrxMemoView
          AllowVectorExport = True
          Left = 3.779530000000000000
          Top = 52.000000000000000000
          Width = 45.000000000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          Memo.UTF8W = (
            'Filtro:')
          ParentFont = False
          WordWrap = False
        end
        object MemoFiltroValor: TfrxMemoView
          AllowVectorExport = True
          Left = 50.000000000000000000
          Top = 52.000000000000000000
          Width = 500.000000000000000000
          Height = 34.000000000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          ParentFont = False
        end
      end
      object PageHeader1: TfrxPageHeader
        FillType = ftBrush
        FillGap.Top = 0
        FillGap.Left = 0
        FillGap.Bottom = 0
        FillGap.Right = 0
        Frame.Typ = [ftTop, ftBottom]
        Height = 22.677180000000000000
        Top = 94.488250000000000000
        Width = 718.110700000000000000
        object MemoColCodProduto: TfrxMemoView
          AllowVectorExport = True
          Left = 3.779530000000000000
          Top = 1.889760000000000000
          Width = 40.000000000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          Memo.UTF8W = (
            'C'#243'd.')
          ParentFont = False
          WordWrap = False
        end
        object MemoColProduto: TfrxMemoView
          AllowVectorExport = True
          Left = 45.354330000000000000
          Top = 1.889760000000000000
          Width = 290.551570000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          Memo.UTF8W = (
            'Produto')
          ParentFont = False
          WordWrap = False
        end
        object MemoColQuantidade: TfrxMemoView
          AllowVectorExport = True
          Left = 338.000000000000000000
          Top = 1.889760000000000000
          Width = 50.000000000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          HAlign = haRight
          Memo.UTF8W = (
            'Qtd.')
          ParentFont = False
          WordWrap = False
        end
        object MemoColPreco: TfrxMemoView
          AllowVectorExport = True
          Left = 390.000000000000000000
          Top = 1.889760000000000000
          Width = 60.000000000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          HAlign = haRight
          Memo.UTF8W = (
            'Pr.Unit.')
          ParentFont = False
          WordWrap = False
        end
        object MemoColBruto: TfrxMemoView
          AllowVectorExport = True
          Left = 452.000000000000000000
          Top = 1.889760000000000000
          Width = 68.000000000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          HAlign = haRight
          Memo.UTF8W = (
            'V.Bruto')
          ParentFont = False
          WordWrap = False
        end
        object MemoColDesconto: TfrxMemoView
          AllowVectorExport = True
          Left = 522.000000000000000000
          Top = 1.889760000000000000
          Width = 60.000000000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          HAlign = haRight
          Memo.UTF8W = (
            'Desc.')
          ParentFont = False
          WordWrap = False
        end
        object MemoColAcrescimo: TfrxMemoView
          AllowVectorExport = True
          Left = 584.000000000000000000
          Top = 1.889760000000000000
          Width = 60.000000000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          HAlign = haRight
          Memo.UTF8W = (
            'Acr'#233'sc.')
          ParentFont = False
          WordWrap = False
        end
        object MemoColTotalLiquido: TfrxMemoView
          AllowVectorExport = True
          Left = 646.000000000000000000
          Top = 1.889760000000000000
          Width = 72.000000000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          HAlign = haRight
          Memo.UTF8W = (
            'T.L'#237'quido')
          ParentFont = False
          WordWrap = False
        end
      end
      object GroupHeaderCliente: TfrxGroupHeader
        FillType = ftBrush
        FillGap.Top = 0
        FillGap.Left = 0
        FillGap.Bottom = 0
        FillGap.Right = 0
        Frame.Typ = []
        Height = 22.677180000000000000
        Top = 132.283550000000000000
        Width = 718.110700000000000000
        Condition = 'frxDBDatasetVendaCliente."NOME_CLIENTE"'
        object ShapeCliente: TfrxShapeView
          AllowVectorExport = True
          Left = 3.779530000000000000
          Top = 1.000000000000000000
          Width = 714.307470000000000000
          Height = 20.677180000000000000
          Fill.BackColor = clTeal
          Frame.Color = clNone
          Frame.Typ = []
        end
        object MemoClienteGrupoLabel: TfrxMemoView
          AllowVectorExport = True
          Left = 6.000000000000000000
          Top = 2.000000000000000000
          Width = 70.000000000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          Memo.UTF8W = (
            'Cliente:')
          ParentFont = False
        end
        object MemoClienteGrupoCodigo: TfrxMemoView
          AllowVectorExport = True
          Left = 80.000000000000000000
          Top = 2.000000000000000000
          Width = 55.000000000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          Memo.UTF8W = (
            
              '[FormatFloat('#39'00000'#39',<frxDBDatasetVendaCliente."CODIGO_CLIENTE"' +
              '>)]')
          ParentFont = False
        end
        object MemoClienteGrupoNome: TfrxMemoView
          AllowVectorExport = True
          Left = 140.000000000000000000
          Top = 2.000000000000000000
          Width = 450.000000000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          Memo.UTF8W = (
            '[frxDBDatasetVendaCliente."NOME_CLIENTE"]')
          ParentFont = False
        end
      end
      object GroupHeaderDia: TfrxGroupHeader
        FillType = ftBrush
        FillGap.Top = 0
        FillGap.Left = 0
        FillGap.Bottom = 0
        FillGap.Right = 0
        Frame.Typ = []
        Height = 22.677180000000000000
        Top = 154.960730000000000000
        Width = 718.110700000000000000
        Condition = 'frxDBDatasetVendaCliente."DATA_VENDA"'
        object ShapeDia: TfrxShapeView
          AllowVectorExport = True
          Left = 3.779530000000000000
          Top = 1.000000000000000000
          Width = 714.307470000000000000
          Height = 20.677180000000000000
          Fill.BackColor = 14079702
          Frame.Color = clNone
          Frame.Typ = []
        end
        object MemoDiaLabel: TfrxMemoView
          AllowVectorExport = True
          Left = 6.000000000000000000
          Top = 2.000000000000000000
          Width = 80.000000000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          Memo.UTF8W = (
            'Dia:')
          ParentFont = False
        end
        object MemoDiaValor: TfrxMemoView
          AllowVectorExport = True
          Left = 90.000000000000000000
          Top = 2.000000000000000000
          Width = 200.000000000000000000
          Height = 18.897650000000000000
          DataField = 'DATA_VENDA'
          DataSet = frxDBDatasetVendaCliente
          DataSetName = 'frxDBDatasetVendaCliente'
          DisplayFormat.FormatStr = 'dd/mm/yyyy'
          DisplayFormat.Kind = fkDateTime
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          Memo.UTF8W = (
            '[frxDBDatasetVendaCliente."DATA_VENDA"]')
          ParentFont = False
        end
      end
      object GroupHeaderVenda: TfrxGroupHeader
        FillType = ftBrush
        FillGap.Top = 0
        FillGap.Left = 0
        FillGap.Bottom = 0
        FillGap.Right = 0
        Frame.Typ = [ftLeft, ftRight, ftBottom]
        Height = 24.000000000000000000
        Top = 177.637910000000000000
        Width = 718.110700000000000000
        Condition = 'frxDBDatasetVendaCliente."CODIGO"'
        object MemoVendaLabel: TfrxMemoView
          AllowVectorExport = True
          Left = 3.779530000000000000
          Top = 2.000000000000000000
          Width = 45.000000000000000000
          Height = 15.118120000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          Memo.UTF8W = (
            'Venda:')
          ParentFont = False
          WordWrap = False
        end
        object MemoVendaCodigo: TfrxMemoView
          AllowVectorExport = True
          Left = 48.000000000000000000
          Top = 2.000000000000000000
          Width = 55.000000000000000000
          Height = 15.118120000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          Memo.UTF8W = (
            '[FormatFloat('#39'000000'#39',<frxDBDatasetVendaCliente."CODIGO">)]')
          ParentFont = False
          WordWrap = False
        end
        object MemoVendaDataLabel: TfrxMemoView
          AllowVectorExport = True
          Left = 110.000000000000000000
          Top = 2.000000000000000000
          Width = 35.000000000000000000
          Height = 15.118120000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          Memo.UTF8W = (
            'Data:')
          ParentFont = False
          WordWrap = False
        end
        object MemoVendaData: TfrxMemoView
          AllowVectorExport = True
          Left = 145.000000000000000000
          Top = 2.000000000000000000
          Width = 70.000000000000000000
          Height = 15.118120000000000000
          DataField = 'DATA_HORA_VENDA'
          DataSet = frxDBDatasetVendaCliente
          DataSetName = 'frxDBDatasetVendaCliente'
          DisplayFormat.FormatStr = 'dd/mm/yyyy'
          DisplayFormat.Kind = fkDateTime
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          Memo.UTF8W = (
            '[frxDBDatasetVendaCliente."DATA_HORA_VENDA"]')
          ParentFont = False
          WordWrap = False
        end
        object MemoVendaClienteLabel: TfrxMemoView
          AllowVectorExport = True
          Left = 222.000000000000000000
          Top = 2.000000000000000000
          Width = 50.000000000000000000
          Height = 15.118120000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          Memo.UTF8W = (
            'Cliente:')
          ParentFont = False
          WordWrap = False
        end
        object MemoClienteCodigo: TfrxMemoView
          AllowVectorExport = True
          Left = 272.000000000000000000
          Top = 2.000000000000000000
          Width = 45.000000000000000000
          Height = 15.118120000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          Memo.UTF8W = (
            
              '[FormatFloat('#39'00000'#39',<frxDBDatasetVendaCliente."CODIGO_CLIENTE' +
              '">)]')
          ParentFont = False
          WordWrap = False
        end
        object MemoClienteNome: TfrxMemoView
          AllowVectorExport = True
          Left = 318.000000000000000000
          Top = 2.000000000000000000
          Width = 300.000000000000000000
          Height = 15.118120000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          Memo.UTF8W = (
            '[Copy(<frxDBDatasetVendaCliente."NOME_CLIENTE">,1,28)]')
          ParentFont = False
          WordWrap = False
        end
        object MemoSituacaoLabel: TfrxMemoView
          AllowVectorExport = True
          Left = 622.000000000000000000
          Top = 2.000000000000000000
          Width = 25.000000000000000000
          Height = 15.118120000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          Memo.UTF8W = (
            'Sit:')
          ParentFont = False
          WordWrap = False
        end
        object MemoSituacao: TfrxMemoView
          AllowVectorExport = True
          Left = 647.000000000000000000
          Top = 2.000000000000000000
          Width = 28.000000000000000000
          Height = 15.118120000000000000
          DataField = 'SITUACAO'
          DataSet = frxDBDatasetVendaCliente
          DataSetName = 'frxDBDatasetVendaCliente'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          Memo.UTF8W = (
            '[frxDBDatasetVendaCliente."SITUACAO"]')
          ParentFont = False
          WordWrap = False
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
        Top = 200.315090000000000000
        Width = 718.110700000000000000
        OnBeforePrint = 'MasterData1OnBeforePrint'
        DataSet = frxDBDatasetVendaCliente
        DataSetName = 'frxDBDatasetVendaCliente'
        RowCount = 0
        object MemoItemProduto: TfrxMemoView
          AllowVectorExport = True
          Left = 3.779530000000000000
          Top = 0.500000000000000000
          Width = 40.000000000000000000
          Height = 11.000000000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -7
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          Memo.UTF8W = (
            
              '[FormatFloat('#39'000000'#39',<frxDBDatasetVendaCliente."CODIGO_PRODUT' +
              'O">)]')
          ParentFont = False
          WordWrap = False
        end
        object MemoItemDescricao: TfrxMemoView
          AllowVectorExport = True
          Left = 45.354330000000000000
          Top = 0.500000000000000000
          Width = 290.551570000000000000
          Height = 11.000000000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -7
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          Memo.UTF8W = (
            '[Copy(<frxDBDatasetVendaCliente."DESCRICAO_PRODUTO">,1,40)]')
          ParentFont = False
          WordWrap = False
        end
        object MemoItemQuantidade: TfrxMemoView
          AllowVectorExport = True
          Left = 338.000000000000000000
          Top = 0.500000000000000000
          Width = 50.000000000000000000
          Height = 11.000000000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -7
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          HAlign = haRight
          Memo.UTF8W = (
            '[FormatFloat('#39'0.000'#39',<frxDBDatasetVendaCliente."QUANTIDADE">)]')
          ParentFont = False
          WordWrap = False
        end
        object MemoItemPreco: TfrxMemoView
          AllowVectorExport = True
          Left = 390.000000000000000000
          Top = 0.500000000000000000
          Width = 60.000000000000000000
          Height = 11.000000000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -7
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          HAlign = haRight
          Memo.UTF8W = (
            
              '[FormatFloat('#39'0.00'#39',<frxDBDatasetVendaCliente."PRECO_UNITARIO"' +
              '>)]')
          ParentFont = False
          WordWrap = False
        end
        object MemoItemBruto: TfrxMemoView
          AllowVectorExport = True
          Left = 452.000000000000000000
          Top = 0.500000000000000000
          Width = 68.000000000000000000
          Height = 11.000000000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -7
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          HAlign = haRight
          Memo.UTF8W = (
            '[FormatFloat('#39'0.00'#39',<frxDBDatasetVendaCliente."VALOR_BRUTO">)]')
          ParentFont = False
          WordWrap = False
        end
        object MemoItemDesconto: TfrxMemoView
          AllowVectorExport = True
          Left = 522.000000000000000000
          Top = 0.500000000000000000
          Width = 60.000000000000000000
          Height = 11.000000000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -7
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          HAlign = haRight
          Memo.UTF8W = (
            '[FormatFloat('#39'0.00'#39',<frxDBDatasetVendaCliente."DESCONTO">)]')
          ParentFont = False
          WordWrap = False
        end
        object MemoItemAcrescimo: TfrxMemoView
          AllowVectorExport = True
          Left = 584.000000000000000000
          Top = 0.500000000000000000
          Width = 60.000000000000000000
          Height = 11.000000000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -7
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          HAlign = haRight
          Memo.UTF8W = (
            '[FormatFloat('#39'0.00'#39',<frxDBDatasetVendaCliente."ACRESCIMO">)]')
          ParentFont = False
          WordWrap = False
        end
        object MemoItemTotalLiquido: TfrxMemoView
          AllowVectorExport = True
          Left = 646.000000000000000000
          Top = 0.500000000000000000
          Width = 72.000000000000000000
          Height = 11.000000000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -7
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          HAlign = haRight
          Memo.UTF8W = (
            
              '[FormatFloat('#39'0.00'#39',<frxDBDatasetVendaCliente."TOTAL_LIQUIDO">' +
              ')]')
          ParentFont = False
          WordWrap = False
        end
      end
      object GroupFooterVenda: TfrxGroupFooter
        FillType = ftBrush
        FillGap.Top = 0
        FillGap.Left = 0
        FillGap.Bottom = 0
        FillGap.Right = 0
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        Height = 18.897650000000000000
        Top = 211.653680000000000000
        Width = 718.110700000000000000
        OnBeforePrint = 'GroupFooterVendaOnBeforePrint'
        object MemoVendaTotLabel: TfrxMemoView
          AllowVectorExport = True
          Left = 3.779530000000000000
          Top = 2.000000000000000000
          Width = 448.000000000000000000
          Height = 15.118120000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          Memo.UTF8W = (
            'Totais da venda:')
          ParentFont = False
          WordWrap = False
        end
        object MemoVendaTotBruto: TfrxMemoView
          AllowVectorExport = True
          Left = 452.000000000000000000
          Top = 2.000000000000000000
          Width = 68.000000000000000000
          Height = 15.118120000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -7
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          HAlign = haRight
          Memo.UTF8W = (
            
              '[FormatFloat('#39'0.00'#39',SUM(<frxDBDatasetVendaCliente."VALOR_BRUTO' +
              '">,MasterData1))]')
          ParentFont = False
          WordWrap = False
        end
        object MemoVendaTotDesconto: TfrxMemoView
          AllowVectorExport = True
          Left = 522.000000000000000000
          Top = 2.000000000000000000
          Width = 60.000000000000000000
          Height = 15.118120000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -7
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          HAlign = haRight
          Memo.UTF8W = (
            
              '[FormatFloat('#39'0.00'#39',SUM(<frxDBDatasetVendaCliente."DESCONTO">,' +
              'MasterData1))]')
          ParentFont = False
          WordWrap = False
        end
        object MemoVendaTotAcrescimo: TfrxMemoView
          AllowVectorExport = True
          Left = 584.000000000000000000
          Top = 2.000000000000000000
          Width = 60.000000000000000000
          Height = 15.118120000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -7
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          HAlign = haRight
          Memo.UTF8W = (
            
              '[FormatFloat('#39'0.00'#39',SUM(<frxDBDatasetVendaCliente."ACRESCIMO">' +
              ',MasterData1))]')
          ParentFont = False
          WordWrap = False
        end
        object MemoVendaTotLiquido: TfrxMemoView
          AllowVectorExport = True
          Left = 646.000000000000000000
          Top = 2.000000000000000000
          Width = 72.000000000000000000
          Height = 15.118120000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -7
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          HAlign = haRight
          Memo.UTF8W = (
            
              '[FormatFloat('#39'0.00'#39',SUM(<frxDBDatasetVendaCliente."TOTAL_LIQUI' +
              'DO">,MasterData1))]')
          ParentFont = False
          WordWrap = False
        end
      end
      object GroupFooterDia: TfrxGroupFooter
        FillType = ftBrush
        FillGap.Top = 0
        FillGap.Left = 0
        FillGap.Bottom = 0
        FillGap.Right = 0
        Frame.Typ = []
        Height = 18.897650000000000000
        Top = 230.551330000000000000
        Width = 718.110700000000000000
        object ShapeDiaFooter: TfrxShapeView
          AllowVectorExport = True
          Left = 3.779530000000000000
          Top = 1.000000000000000000
          Width = 714.307470000000000000
          Height = 20.677180000000000000
          Fill.BackColor = 15790320
          Frame.Color = clNone
          Frame.Typ = []
        end
        object MemoDiaTotLabel: TfrxMemoView
          AllowVectorExport = True
          Left = 6.000000000000000000
          Top = 2.000000000000000000
          Width = 446.000000000000000000
          Height = 15.118120000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          Memo.UTF8W = (
            'Subtotal do dia:')
          ParentFont = False
          WordWrap = False
        end
        object MemoDiaTotBruto: TfrxMemoView
          AllowVectorExport = True
          Left = 452.000000000000000000
          Top = 2.000000000000000000
          Width = 68.000000000000000000
          Height = 15.118120000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -7
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          HAlign = haRight
          Memo.UTF8W = (
            
              '[FormatFloat('#39'0.00'#39',SUM(<frxDBDatasetVendaCliente."VALOR_BRUTO' +
              '">,MasterData1))]')
          ParentFont = False
          WordWrap = False
        end
        object MemoDiaTotDesconto: TfrxMemoView
          AllowVectorExport = True
          Left = 522.000000000000000000
          Top = 2.000000000000000000
          Width = 60.000000000000000000
          Height = 15.118120000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -7
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          HAlign = haRight
          Memo.UTF8W = (
            
              '[FormatFloat('#39'0.00'#39',SUM(<frxDBDatasetVendaCliente."DESCONTO">,' +
              'MasterData1))]')
          ParentFont = False
          WordWrap = False
        end
        object MemoDiaTotAcrescimo: TfrxMemoView
          AllowVectorExport = True
          Left = 584.000000000000000000
          Top = 2.000000000000000000
          Width = 60.000000000000000000
          Height = 15.118120000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -7
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          HAlign = haRight
          Memo.UTF8W = (
            
              '[FormatFloat('#39'0.00'#39',SUM(<frxDBDatasetVendaCliente."ACRESCIMO">' +
              ',MasterData1))]')
          ParentFont = False
          WordWrap = False
        end
        object MemoDiaTotLiquido: TfrxMemoView
          AllowVectorExport = True
          Left = 646.000000000000000000
          Top = 2.000000000000000000
          Width = 72.000000000000000000
          Height = 15.118120000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -7
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          HAlign = haRight
          Memo.UTF8W = (
            
              '[FormatFloat('#39'0.00'#39',SUM(<frxDBDatasetVendaCliente."TOTAL_LIQUI' +
              'DO">,MasterData1))]')
          ParentFont = False
          WordWrap = False
        end
      end
      object GroupFooterCliente: TfrxGroupFooter
        FillType = ftBrush
        FillGap.Top = 0
        FillGap.Left = 0
        FillGap.Bottom = 0
        FillGap.Right = 0
        Frame.Typ = []
        Height = 18.897650000000000000
        Top = 249.448980000000000000
        Width = 718.110700000000000000
        object ShapeClienteFooter: TfrxShapeView
          AllowVectorExport = True
          Left = 3.779530000000000000
          Top = 1.000000000000000000
          Width = 714.307470000000000000
          Height = 16.897650000000000000
          Fill.BackColor = clSilver
          Frame.Color = clNone
          Frame.Typ = []
        end
        object MemoClienteTotLabel: TfrxMemoView
          AllowVectorExport = True
          Left = 6.000000000000000000
          Top = 2.000000000000000000
          Width = 446.000000000000000000
          Height = 15.118120000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          Memo.UTF8W = (
            'Subtotal do cliente:')
          ParentFont = False
          WordWrap = False
        end
        object MemoClienteTotBruto: TfrxMemoView
          AllowVectorExport = True
          Left = 452.000000000000000000
          Top = 2.000000000000000000
          Width = 68.000000000000000000
          Height = 15.118120000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -7
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          HAlign = haRight
          Memo.UTF8W = (
            
              '[FormatFloat('#39'0.00'#39',SUM(<frxDBDatasetVendaCliente."VALOR_BRUTO"' +
              '>,MasterData1))]')
          ParentFont = False
          WordWrap = False
        end
        object MemoClienteTotDesconto: TfrxMemoView
          AllowVectorExport = True
          Left = 522.000000000000000000
          Top = 2.000000000000000000
          Width = 60.000000000000000000
          Height = 15.118120000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -7
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          HAlign = haRight
          Memo.UTF8W = (
            
              '[FormatFloat('#39'0.00'#39',SUM(<frxDBDatasetVendaCliente."DESCONTO">,' +
              'MasterData1))]')
          ParentFont = False
          WordWrap = False
        end
        object MemoClienteTotAcrescimo: TfrxMemoView
          AllowVectorExport = True
          Left = 584.000000000000000000
          Top = 2.000000000000000000
          Width = 60.000000000000000000
          Height = 15.118120000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -7
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          HAlign = haRight
          Memo.UTF8W = (
            
              '[FormatFloat('#39'0.00'#39',SUM(<frxDBDatasetVendaCliente."ACRESCIMO">' +
              ',MasterData1))]')
          ParentFont = False
          WordWrap = False
        end
        object MemoClienteTotLiquido: TfrxMemoView
          AllowVectorExport = True
          Left = 646.000000000000000000
          Top = 2.000000000000000000
          Width = 72.000000000000000000
          Height = 15.118120000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -7
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          HAlign = haRight
          Memo.UTF8W = (
            
              '[FormatFloat('#39'0.00'#39',SUM(<frxDBDatasetVendaCliente."TOTAL_LIQUI' +
              'DO">,MasterData1))]')
          ParentFont = False
          WordWrap = False
        end
      end
      object ReportSummary1: TfrxReportSummary
        FillType = ftBrush
        FillGap.Top = 0
        FillGap.Left = 0
        FillGap.Bottom = 0
        FillGap.Right = 0
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        Height = 300.000000000000000000
        Top = 287.244280000000000000
        Width = 718.110700000000000000
        OnBeforePrint = 'ReportSummary1OnBeforePrint'
        object ShapeSummary: TfrxShapeView
          AllowVectorExport = True
          Left = 3.779530000000000000
          Top = 1.000000000000000000
          Width = 714.307470000000000000
          Height = 65.000000000000000000
          Fill.BackColor = clTeal
          Frame.Color = clNone
          Frame.Typ = []
        end
        object MemoTotalGeralLabel: TfrxMemoView
          AllowVectorExport = True
          Left = 6.000000000000000000
          Top = 3.000000000000000000
          Width = 250.000000000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          Memo.UTF8W = (
            'Totais gerais do relat'#243'rio:')
          ParentFont = False
          WordWrap = False
        end
        object MemoQtdVendasLabel: TfrxMemoView
          AllowVectorExport = True
          Left = 6.000000000000000000
          Top = 26.000000000000000000
          Width = 120.000000000000000000
          Height = 15.118120000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          Memo.UTF8W = (
            'Vendas impressas:')
          ParentFont = False
          WordWrap = False
        end
        object MemoQtdVendas: TfrxMemoView
          AllowVectorExport = True
          Left = 128.000000000000000000
          Top = 26.000000000000000000
          Width = 50.000000000000000000
          Height = 15.118120000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -7
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          HAlign = haRight
          Memo.UTF8W = (
            '0')
          ParentFont = False
          WordWrap = False
        end
        object MemoTotalBrutoLabel: TfrxMemoView
          AllowVectorExport = True
          Left = 347.000000000000000000
          Top = 26.000000000000000000
          Width = 105.000000000000000000
          Height = 15.118120000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          HAlign = haRight
          Memo.UTF8W = (
            'Total Bruto:')
          ParentFont = False
          WordWrap = False
        end
        object MemoTotalGeralBruto: TfrxMemoView
          AllowVectorExport = True
          Left = 452.000000000000000000
          Top = 26.000000000000000000
          Width = 68.000000000000000000
          Height = 15.118120000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -7
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          HAlign = haRight
          Memo.UTF8W = (
            '0,00')
          ParentFont = False
          WordWrap = False
        end
        object MemoTotalDetalheLiquidoLabel: TfrxMemoView
          AllowVectorExport = True
          Left = 574.000000000000000000
          Top = 44.000000000000000000
          Width = 72.000000000000000000
          Height = 15.118120000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          HAlign = haRight
          Memo.UTF8W = (
            'T.L'#237'q. Itens:')
          ParentFont = False
          WordWrap = False
        end
        object MemoTotalDetalheLiquido: TfrxMemoView
          AllowVectorExport = True
          Left = 646.000000000000000000
          Top = 44.000000000000000000
          Width = 72.000000000000000000
          Height = 15.118120000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -7
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          HAlign = haRight
          Memo.UTF8W = (
            '0,00')
          ParentFont = False
          WordWrap = False
        end
        object MemoTotalLiquidoLabel: TfrxMemoView
          AllowVectorExport = True
          Left = 574.000000000000000000
          Top = 26.000000000000000000
          Width = 72.000000000000000000
          Height = 15.118120000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          HAlign = haRight
          Memo.UTF8W = (
            'Total Venda:')
          ParentFont = False
          WordWrap = False
        end
        object MemoTotalGeralLiquido: TfrxMemoView
          AllowVectorExport = True
          Left = 646.000000000000000000
          Top = 26.000000000000000000
          Width = 72.000000000000000000
          Height = 15.118120000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -7
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          HAlign = haRight
          Memo.UTF8W = (
            '0,00')
          ParentFont = False
          WordWrap = False
        end
        object MemoTituloGrafico: TfrxMemoView
          AllowVectorExport = True
          Left = 6.000000000000000000
          Top = 72.000000000000000000
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
          WordWrap = False
        end
      end
      object PageFooter1: TfrxPageFooter
        FillType = ftBrush
        FillGap.Top = 0
        FillGap.Left = 0
        FillGap.Bottom = 0
        FillGap.Right = 0
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        Height = 24.000000000000000000
        Top = 587.244280000000000000
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
