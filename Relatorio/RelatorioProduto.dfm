object Form_RelatorioProduto: TForm_RelatorioProduto
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'Relat'#243'rio de Produtos'
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
    Caption = '   Relat'#243'rio de Produtos'
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
      Top = 10
      Width = 65
      Height = 15
      Caption = 'C'#243'digo final'
    end
    object LabelReferencia: TLabel
      Left = 500
      Top = 10
      Width = 57
      Height = 15
      Caption = 'Refer'#234'ncia'
    end
    object LabelMarca: TLabel
      Left = 248
      Top = 62
      Width = 35
      Height = 15
      Caption = 'Marca'
    end
    object LabelGrupo: TLabel
      Left = 500
      Top = 62
      Width = 36
      Height = 15
      Caption = 'Grupo'
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
      Caption = ' Ordem do relat'#243'rio '
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
    object EditReferencia: TEdit
      Left = 500
      Top = 29
      Width = 234
      Height = 25
      Hint = 'Filtra as refer'#234'ncias que come'#231'am pelo texto informado'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 3355443
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      MaxLength = 10
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      OnEnter = EditFocoEnter
      OnExit = EditFocoExit
    end
    object EditMarca: TEdit
      Left = 248
      Top = 81
      Width = 234
      Height = 25
      Hint = 'Filtra as marcas que come'#231'am pelo texto informado'
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
    object EditGrupo: TEdit
      Left = 500
      Top = 81
      Width = 234
      Height = 25
      Hint = 'Filtra os grupos que come'#231'am pelo texto informado'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 3355443
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      MaxLength = 30
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
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
      ShowHint = True
      Smooth = True
      TabOrder = 6
    end
  end
  object DBGridProduto: TDBGrid
    Left = 0
    Top = 168
    Width = 990
    Height = 386
    Align = alClient
    DataSource = DsProduto
    DrawingStyle = gdsClassic
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    ReadOnly = True
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clNavy
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI Semibold'
    TitleFont.Style = [fsBold]
    OnDrawColumnCell = DBGridProdutoDrawColumnCell
    Columns = <
      item
        Expanded = False
        FieldName = 'CODIGO'
        Title.Caption = 'C'#243'digo'
        Width = 65
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'DESCRICAO'
        Title.Caption = 'Descri'#231#227'o'
        Width = 250
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'REFERENCIA'
        Title.Caption = 'Refer'#234'ncia'
        Width = 100
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'MARCA'
        Title.Caption = 'Marca'
        Width = 130
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'GRUPO'
        Title.Caption = 'Grupo'
        Width = 130
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'PRECO_VENDA'
        Title.Caption = 'Pre'#231'o Venda'
        Width = 100
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'ESTOQUE_ATUAL'
        Title.Caption = 'Estoque Atual'
        Width = 100
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
      Hint = 'Pesquisar produtos com os filtros informados'
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
  object QueryProduto: TIBQuery
    Database = DM.Conexao
    Transaction = DM.IBTransaction1
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    SQL.Strings = (
      
        'Select CODIGO, DESCRICAO, REFERENCIA, MARCA, GRUPO, PRECO_VENDA,' +
        ' ESTOQUE_ATUAL from Produto order by DESCRICAO')
    Left = 24
    Top = 495
  end
  object DsProduto: TDataSource
    DataSet = QueryProduto
    Left = 93
    Top = 496
  end
  object frxDBDatasetProduto: TfrxDBDataset
    UserName = 'frxDBDatasetProduto'
    CloseDataSource = False
    DataSet = QueryProduto
    BCDToCurrency = False
    DataSetOptions = []
    Left = 288
    Top = 496
  end
  object frxReportProduto: TfrxReport
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
    Left = 216
    Top = 496
    Datasets = <
      item
        DataSet = frxDBDatasetProduto
        DataSetName = 'frxDBDatasetProduto'
      end>
    Variables = <>
    Style = <>
  end
  object frxExportPDF: TfrxPDFExport
    Compressed = False
    Left = 360
    Top = 496
  end
  object frxExportExcel: TfrxXMLExport
    Left = 432
    Top = 496
  end
  object frxExportWord: TfrxRTFExport
    Left = 504
    Top = 496
  end
  object frxExportCSV: TfrxCSVExport
    Left = 576
    Top = 496
  end
end
