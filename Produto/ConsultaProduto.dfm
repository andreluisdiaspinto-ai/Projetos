object Form_ConsultaProduto: TForm_ConsultaProduto
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'Consulta de Produtos'
  ClientHeight = 520
  ClientWidth = 780
  Color = 16119285
  Font.Charset = DEFAULT_CHARSET
  Font.Color = 3355443
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 15
  object Panel_Titulo: TPanel
    Left = 0
    Top = 0
    Width = 780
    Height = 50
    Align = alTop
    Alignment = taLeftJustify
    BevelOuter = bvNone
    Caption = '   Consulta de Produtos'
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
  object PanelPesquisa: TPanel
    Left = 0
    Top = 50
    Width = 780
    Height = 70
    Align = alTop
    BevelOuter = bvNone
    Color = 16119285
    ParentBackground = False
    TabOrder = 1
    object LabelPesquisa: TLabel
      Left = 16
      Top = 8
      Width = 233
      Height = 15
      Caption = 'Pesquisar pela descri'#231#227'o (ordem alfab'#233'tica)'
    end
    object EditPesquisa: TEdit
      Left = 16
      Top = 28
      Width = 748
      Height = 27
      Hint = 'Digite a descricao do produto: a lista filtra a cada caractere'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 3355443
      Font.Height = -14
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnChange = EditPesquisaChange
      OnEnter = EditFocoEnter
      OnExit = EditFocoExit
    end
  end
  object DBGridConsulta: TDBGrid
    Left = 0
    Top = 120
    Width = 780
    Height = 334
    Align = alClient
    DataSource = DsConsulta
    DrawingStyle = gdsClassic
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    ReadOnly = True
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clNavy
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI Semibold'
    TitleFont.Style = [fsBold]
    OnDblClick = DBGridConsultaDblClick
    OnDrawColumnCell = DBGridConsultaDrawColumnCell
    Columns = <
      item
        Expanded = False
        FieldName = 'CODIGO'
        Title.Caption = 'C'#243'digo'
        Width = 70
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'DESCRICAO'
        Title.Caption = 'Descri'#231#227'o'
        Width = 280
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'CODIGO_BARRAS'
        Title.Caption = 'C'#243'd. Barras'
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
    Top = 454
    Width = 780
    Height = 66
    Align = alBottom
    BevelOuter = bvNone
    Color = 15790320
    ParentBackground = False
    TabOrder = 3
    object BtnConfirmar: TBitBtn
      Left = 254
      Top = 12
      Width = 130
      Height = 42
      Hint = 'Confirmar o produto selecionado (ENTER)'
      Caption = '&Confirmar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 2263842
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      Margin = 10
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      Spacing = 8
      TabOrder = 0
      OnClick = BtnConfirmarClick
    end
    object BtnCancelar: TBitBtn
      Left = 396
      Top = 12
      Width = 130
      Height = 42
      Hint = 'Cancelar a consulta (ESC)'
      Caption = 'Ca&ncelar'
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
      TabOrder = 1
      OnClick = BtnCancelarClick
    end
  end
  object QueryConsulta: TIBQuery
    Database = DM.Conexao
    Transaction = DM.IBTransaction1
    BufferChunks = 1000
    CachedUpdates = False
    Left = 24
    Top = 464
  end
  object DsConsulta: TDataSource
    DataSet = QueryConsulta
    Left = 80
    Top = 464
  end
end
