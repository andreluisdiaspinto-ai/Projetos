object Form_Venda: TForm_Venda
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'Vendas'
  ClientHeight = 720
  ClientWidth = 1100
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
  Constraints.MinHeight = 620
  Constraints.MinWidth = 1000
  OnActivate = FormActivate
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 15
  object Panel_Titulo: TPanel
    Left = 0
    Top = 0
    Width = 1100
    Height = 50
    Align = alTop
    Alignment = taLeftJustify
    BevelOuter = bvNone
    Caption = '   Vendas'
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
  object PanelEstado: TPanel
    Left = 0
    Top = 50
    Width = 1100
    Height = 28
    Align = alTop
    BevelOuter = bvNone
    Color = 15263976
    ParentBackground = False
    TabOrder = 1
    object LabelSituacaoVenda: TLabel
      Left = 0
      Top = 0
      Width = 220
      Height = 28
      Align = alLeft
      AutoSize = False
      Caption = '   SEM VENDA'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 5263440
      Font.Height = -12
      Font.Name = 'Segoe UI Semibold'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
    end
    object LabelEstadoAtual: TLabel
      Left = 220
      Top = 0
      Width = 880
      Height = 28
      Margins.Right = 12
      Align = alClient
      Alignment = taRightJustify
      Caption = 'MODO: NAVEGACAO   '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 5263440
      Font.Height = -12
      Font.Name = 'Segoe UI Semibold'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
      ExplicitLeft = 977
      ExplicitWidth = 123
      ExplicitHeight = 15
    end
  end
  object GroupBoxDados: TGroupBox
    Left = 0
    Top = 78
    Width = 1100
    Height = 140
    Align = alTop
    Caption = ' Dados da Venda '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -14
    Font.Name = 'Segoe UI Semibold'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    object LabelCodigo: TLabel
      Left = 16
      Top = 26
      Width = 39
      Height = 15
      Caption = 'C'#243'digo'
      FocusControl = DBEditCodigoVenda
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 3355443
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object LabelDataHora: TLabel
      Left = 150
      Top = 26
      Width = 111
      Height = 15
      Caption = 'Data e hora da venda'
      FocusControl = DBEditDataHora
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 3355443
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object LabelSituacao: TLabel
      Left = 360
      Top = 26
      Width = 45
      Height = 15
      Caption = 'Situa'#231#227'o'
      FocusControl = DBEditSituacao
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 3355443
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object LabelDescSituacao: TLabel
      Left = 404
      Top = 52
      Width = 41
      Height = 19
      Caption = 'Aberta'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -14
      Font.Name = 'Segoe UI Semibold'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object LabelCodigoCliente: TLabel
      Left = 16
      Top = 82
      Width = 37
      Height = 15
      Caption = 'Cliente'
      FocusControl = DBEditCodigoCliente
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 3355443
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object LabelCodigoClienteAst: TLabel
      Left = 62
      Top = 82
      Width = 5
      Height = 15
      Caption = '*'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object DBEditCodigoVenda: TDBEdit
      Left = 16
      Top = 46
      Width = 116
      Height = 27
      TabStop = False
      Color = 15790320
      DataField = 'CODIGO'
      DataSource = DM.DSVenda
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 5263440
      Font.Height = -14
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
    end
    object DBEditDataHora: TDBEdit
      Left = 150
      Top = 46
      Width = 190
      Height = 27
      TabStop = False
      Color = 15790320
      DataField = 'DATA_HORA_VENDA'
      DataSource = DM.DSVenda
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 5263440
      Font.Height = -14
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      TabOrder = 1
    end
    object DBEditSituacao: TDBEdit
      Left = 360
      Top = 46
      Width = 30
      Height = 27
      TabStop = False
      Color = 15790320
      DataField = 'SITUACAO'
      DataSource = DM.DSVenda
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 5263440
      Font.Height = -14
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      TabOrder = 2
    end
    object DBEditCodigoCliente: TDBEdit
      Left = 16
      Top = 102
      Width = 116
      Height = 27
      Hint = 'Codigo do Cliente'
      DataField = 'CODIGO_CLIENTE'
      DataSource = DM.DSVenda
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 3355443
      Font.Height = -14
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      OnEnter = EditFocoEnter
      OnExit = DBEditCodigoClienteExit
      OnKeyPress = DBEditCodigoClienteKeyPress
    end
    object DBEditNome: TDBEdit
      Left = 150
      Top = 102
      Width = 700
      Height = 27
      TabStop = False
      Color = 15790320
      DataField = 'NOMECLIENTTE'
      DataSource = DM.DSVenda
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 5263440
      Font.Height = -14
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      TabOrder = 4
    end
    object BtnPesquisarCliente: TBitBtn
      Left = 858
      Top = 100
      Width = 150
      Height = 30
      Hint = 'Pesquisar cliente pelo nome'
      Caption = 'Pes&quisar Cliente'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      Margin = 8
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      Spacing = 6
      TabOrder = 5
      OnClick = BtnPesquisarClienteClick
      OnMouseDown = BtnPesquisarClienteMouseDown
    end
  end
  object GroupBoxItem: TGroupBox
    Left = 0
    Top = 218
    Width = 1100
    Height = 148
    Align = alTop
    Caption = ' Digita'#231#227'o do Item '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -14
    Font.Name = 'Segoe UI Semibold'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    object LabelItemProduto: TLabel
      Left = 16
      Top = 24
      Width = 43
      Height = 15
      Caption = 'Produto'
      FocusControl = EditCodigoProduto
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 3355443
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object LabelItemProdutoAst: TLabel
      Left = 68
      Top = 24
      Width = 5
      Height = 15
      Caption = '*'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object LabelItemDescricao: TLabel
      Left = 130
      Top = 24
      Width = 51
      Height = 15
      Caption = 'Descri'#231#227'o'
      FocusControl = EditDescricaoProduto
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 3355443
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object LabelItemPreco: TLabel
      Left = 574
      Top = 24
      Width = 75
      Height = 15
      Caption = 'Pre'#231'o Unit'#225'rio'
      FocusControl = EditPrecoUnitario
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 3355443
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object LabelItemQuantidade: TLabel
      Left = 708
      Top = 24
      Width = 62
      Height = 15
      Caption = 'Quantidade'
      FocusControl = EditQuantidade
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 3355443
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object LabelItemQuantidadeAst: TLabel
      Left = 778
      Top = 24
      Width = 5
      Height = 15
      Caption = '*'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object LabelItemDesconto: TLabel
      Left = 16
      Top = 80
      Width = 71
      Height = 15
      Caption = 'Desconto (%)'
      FocusControl = EditDesconto
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object LabelItemAcrescimo: TLabel
      Left = 140
      Top = 80
      Width = 77
      Height = 15
      Caption = 'Acr'#233'scimo (%)'
      FocusControl = EditAcrescimo
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object LabelItemTotal: TLabel
      Left = 264
      Top = 80
      Width = 70
      Height = 15
      Caption = 'Total do Item'
      FocusControl = EditTotalItem
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object EditCodigoProduto: TEdit
      Left = 16
      Top = 44
      Width = 100
      Height = 27
      Hint = 'Codigo do Produto'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 3355443
      Font.Height = -14
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnEnter = EditFocoEnter
      OnExit = EditCodigoProdutoExit
      OnKeyPress = EditCodigoProdutoKeyPress
    end
    object EditDescricaoProduto: TEdit
      Left = 130
      Top = 44
      Width = 430
      Height = 27
      TabStop = False
      Color = 15790320
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 5263440
      Font.Height = -14
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      TabOrder = 1
    end
    object EditPrecoUnitario: TEdit
      Left = 574
      Top = 44
      Width = 120
      Height = 27
      TabStop = False
      Alignment = taRightJustify
      Color = 15790320
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 5263440
      Font.Height = -14
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      TabOrder = 2
    end
    object BtnPesquisarProduto: TBitBtn
      Left = 850
      Top = 42
      Width = 180
      Height = 30
      Hint = 'Pesquisar produto pela descricao'
      Caption = 'Pesquisar Produ&to'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      Margin = 8
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      Spacing = 6
      TabOrder = 9
      OnClick = BtnPesquisarProdutoClick
      OnMouseDown = BtnPesquisarProdutoMouseDown
    end
    object EditQuantidade: TEdit
      Left = 708
      Top = 44
      Width = 110
      Height = 27
      Hint = 'A quantidade'
      Alignment = taRightJustify
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 3355443
      Font.Height = -14
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      Text = '1'
      OnChange = EditItemValorChange
      OnEnter = EditFocoEnter
      OnExit = EditFocoExit
      OnKeyPress = EditNumericoKeyPress
    end
    object EditDesconto: TEdit
      Left = 16
      Top = 100
      Width = 110
      Height = 27
      Hint = 'O desconto do item'
      Alignment = taRightJustify
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -14
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      Text = '0'
      OnChange = EditItemValorChange
      OnEnter = EditFocoEnter
      OnExit = EditFocoExit
      OnKeyPress = EditNumericoKeyPress
    end
    object EditAcrescimo: TEdit
      Left = 140
      Top = 100
      Width = 110
      Height = 27
      Hint = 'O acrescimo do item'
      Alignment = taRightJustify
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -14
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
      Text = '0'
      OnChange = EditItemValorChange
      OnEnter = EditFocoEnter
      OnExit = EditFocoExit
      OnKeyPress = EditNumericoKeyPress
    end
    object EditTotalItem: TEdit
      Left = 264
      Top = 100
      Width = 150
      Height = 27
      TabStop = False
      Alignment = taRightJustify
      Color = 15790320
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -14
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      TabOrder = 6
      Text = '0,00'
    end
    object BtnAdicionarItem: TBitBtn
      Left = 440
      Top = 96
      Width = 160
      Height = 36
      Hint = 'Adiciona o item na venda'
      Caption = '&Adicionar Item'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 2263842
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      Margin = 8
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      Spacing = 6
      TabOrder = 7
      OnClick = BtnAdicionarItemClick
    end
    object BtnRemoverItem: TBitBtn
      Left = 610
      Top = 96
      Width = 160
      Height = 36
      Hint = 'Remove o item selecionado no grid'
      Caption = '&Remover Item'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      Margin = 8
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      Spacing = 6
      TabOrder = 8
      OnClick = BtnRemoverItemClick
    end
  end
  object GroupBoxItens: TGroupBox
    Left = 0
    Top = 366
    Width = 1100
    Height = 178
    Align = alClient
    Caption = ' Itens da Venda '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -14
    Font.Name = 'Segoe UI Semibold'
    Font.Style = [fsBold]
    Padding.Left = 12
    Padding.Top = 8
    Padding.Right = 12
    Padding.Bottom = 12
    ParentFont = False
    TabOrder = 4
    object DBGridVendaItem: TDBGrid
      Left = 14
      Top = 29
      Width = 1072
      Height = 135
      Align = alClient
      DataSource = DM.DSVendaItem
      DrawingStyle = gdsClassic
      ReadOnly = True
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clNavy
      TitleFont.Height = -14
      TitleFont.Name = 'Segoe UI Semibold'
      TitleFont.Style = [fsBold]
      OnDrawColumnCell = DBGridVendaItemDrawColumnCell
      Columns = <
        item
          Expanded = False
          FieldName = 'CODIGO_PRODUTO'
          Title.Caption = 'C'#243'd.Produto'
          Width = 89
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'DescricaoProduto'
          Title.Caption = 'Descri'#231#227'o'
          Width = 435
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'QUANTIDADE'
          Title.Alignment = taRightJustify
          Width = 90
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'PRECO_UNITARIO'
          Title.Alignment = taRightJustify
          Title.Caption = 'Pre'#231'o Unit.'
          Width = 97
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'DESCONTO'
          Title.Alignment = taRightJustify
          Title.Caption = 'Desconto %'
          Width = 85
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ACRESCIMO'
          Title.Alignment = taRightJustify
          Title.Caption = 'Acr'#233'scimo %'
          Width = 85
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'TOTAL_LIQUIDO'
          Title.Alignment = taRightJustify
          Title.Caption = 'Valor Total'
          Width = 111
          Visible = True
        end>
    end
  end
  object GroupBoxFechamento: TGroupBox
    Left = 0
    Top = 544
    Width = 1100
    Height = 110
    Align = alBottom
    Caption = ' Fechamento da Venda '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -14
    Font.Name = 'Segoe UI Semibold'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 5
    object LabelTotalProduto: TLabel
      Left = 16
      Top = 28
      Width = 111
      Height = 21
      Caption = 'Total Produtos'
      FocusControl = DBEditTotalProduto
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 5263440
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object LabelDesconto: TLabel
      Left = 286
      Top = 28
      Width = 107
      Height = 21
      Caption = 'Desconto (R$)'
      FocusControl = DBEditDesconto
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object LabelAcrescimo: TLabel
      Left = 556
      Top = 28
      Width = 114
      Height = 21
      Caption = 'Acr'#233'scimo (R$)'
      FocusControl = DBEditAcrescimo
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object LabelTotalLiquido: TLabel
      Left = 826
      Top = 28
      Width = 100
      Height = 21
      Caption = 'Total L'#237'quido'
      FocusControl = DBEditTotalLiquido
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object DBEditTotalProduto: TDBEdit
      Left = 16
      Top = 54
      Width = 250
      Height = 33
      TabStop = False
      Color = 15790320
      DataField = 'TOTAL_BRUTO'
      DataSource = DM.DSVenda
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 5263440
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
    end
    object DBEditDesconto: TDBEdit
      Left = 286
      Top = 54
      Width = 250
      Height = 33
      TabStop = False
      Color = 15790320
      DataField = 'DESCONTO_PERC'
      DataSource = DM.DSVenda
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      TabOrder = 1
    end
    object DBEditAcrescimo: TDBEdit
      Left = 556
      Top = 54
      Width = 250
      Height = 33
      TabStop = False
      Color = 15790320
      DataField = 'ACRESCIMO_PER'
      DataSource = DM.DSVenda
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      TabOrder = 2
    end
    object DBEditTotalLiquido: TDBEdit
      Left = 826
      Top = 54
      Width = 250
      Height = 33
      TabStop = False
      Color = 15790320
      DataField = 'TOTAL_LIQUIDO'
      DataSource = DM.DSVenda
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      TabOrder = 3
    end
  end
  object PanelRodape: TPanel
    Left = 0
    Top = 654
    Width = 1100
    Height = 66
    Align = alBottom
    BevelOuter = bvNone
    Color = 15790320
    ParentBackground = False
    TabOrder = 6
    object ShapeSep: TBevel
      Left = 204
      Top = 14
      Width = 2
      Height = 38
      Shape = bsLeftLine
    end
    object BtnPrimeiro: TBitBtn
      Left = 14
      Top = 12
      Width = 42
      Height = 42
      Hint = 'Primeira venda'
      Margin = 0
      ParentShowHint = False
      ShowHint = True
      Spacing = 0
      TabOrder = 0
      OnClick = BtnPrimeiroClick
    end
    object BtnAnterior: TBitBtn
      Left = 60
      Top = 12
      Width = 42
      Height = 42
      Hint = 'Venda anterior'
      Margin = 0
      ParentShowHint = False
      ShowHint = True
      Spacing = 0
      TabOrder = 1
      OnClick = BtnAnteriorClick
    end
    object BtnProximo: TBitBtn
      Left = 106
      Top = 12
      Width = 42
      Height = 42
      Hint = 'Pr'#243'xima venda'
      Margin = 0
      ParentShowHint = False
      ShowHint = True
      Spacing = 0
      TabOrder = 2
      OnClick = BtnProximoClick
    end
    object BtnUltimo: TBitBtn
      Left = 152
      Top = 12
      Width = 42
      Height = 42
      Hint = #218'ltima venda'
      Margin = 0
      ParentShowHint = False
      ShowHint = True
      Spacing = 0
      TabOrder = 3
      OnClick = BtnUltimoClick
    end
    object BtnFecharVenda: TBitBtn
      Left = 218
      Top = 12
      Width = 130
      Height = 42
      Hint = 'Fecha ou reabre a venda atual'
      Caption = 'Fechar Venda'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 3355443
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      Margin = 8
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      Spacing = 6
      TabOrder = 4
      OnClick = BtnFecharVendaClick
    end
    object BtnInserir: TBitBtn
      Left = 354
      Top = 12
      Width = 100
      Height = 42
      Hint = 'Iniciar uma nova venda (F5)'
      Caption = '&Inserir'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      Margin = 8
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      Spacing = 6
      TabOrder = 5
      OnClick = BtnInserirClick
    end
    object BtnEditar: TBitBtn
      Left = 460
      Top = 12
      Width = 100
      Height = 42
      Hint = 'Editar o cabe'#231'alho da venda (F6)'
      Caption = '&Editar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 16750899
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      Margin = 8
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      Spacing = 6
      TabOrder = 6
      OnClick = BtnEditarClick
    end
    object BtnGravar: TBitBtn
      Left = 566
      Top = 12
      Width = 100
      Height = 42
      Hint = 'Gravar o cabe'#231'alho da venda (F9)'
      Caption = '&Gravar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 2263842
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      Margin = 8
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      Spacing = 6
      TabOrder = 7
      OnClick = BtnGravarClick
    end
    object BtnCancelar: TBitBtn
      Left = 672
      Top = 12
      Width = 100
      Height = 42
      Hint = 'Cancelar as altera'#231#245'es'
      Caption = '&Cancelar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 3355443
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      Margin = 8
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      Spacing = 6
      TabOrder = 8
      OnClick = BtnCancelarClick
      OnMouseDown = BtnCancelarMouseDown
    end
    object BtnExcluir: TBitBtn
      Left = 778
      Top = 12
      Width = 100
      Height = 42
      Hint = 'Excluir a venda e seus itens (Ctrl+Del)'
      Caption = 'E&xcluir'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      Margin = 8
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      Spacing = 6
      TabOrder = 9
      OnClick = BtnExcluirClick
    end
    object BtnSair: TBitBtn
      Left = 884
      Top = 12
      Width = 100
      Height = 42
      Hint = 'Fechar o formul'#225'rio (ESC)'
      Caption = '&Sair'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 6710015
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      Margin = 8
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      Spacing = 6
      TabOrder = 10
      OnClick = BtnSairClick
      OnMouseDown = BtnSairMouseDown
    end
  end
  object Query: TIBQuery
    Database = DM.Conexao
    Transaction = DM.IBTransaction1
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    PrecommittedReads = False
    Left = 952
    Top = 96
  end
  object QueryAtualizaEstoque: TIBQuery
    Database = DM.Conexao
    Transaction = DM.IBTransaction1
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    PrecommittedReads = False
    Left = 1016
    Top = 96
  end
  object ActionList: TActionList
    Left = 888
    Top = 96
    object ActPrimeiro: TAction
      Caption = 'Primeiro'
      ShortCut = 113
      OnExecute = ActPrimeiroExecute
    end
    object ActAnterior: TAction
      Caption = 'Anterior'
      ShortCut = 114
      OnExecute = ActAnteriorExecute
    end
    object ActProximo: TAction
      Caption = 'Proximo'
      ShortCut = 115
      OnExecute = ActProximoExecute
    end
    object ActUltimo: TAction
      Caption = 'Ultimo'
      ShortCut = 119
      OnExecute = ActUltimoExecute
    end
    object ActInserir: TAction
      Caption = 'Inserir'
      ShortCut = 116
      OnExecute = ActInserirExecute
    end
    object ActEditar: TAction
      Caption = 'Editar'
      ShortCut = 117
      OnExecute = ActEditarExecute
    end
    object ActGravar: TAction
      Caption = 'Gravar'
      ShortCut = 120
      OnExecute = ActGravarExecute
    end
    object ActCancelar: TAction
      Caption = 'Cancelar'
      OnExecute = ActCancelarExecute
    end
    object ActExcluir: TAction
      Caption = 'Excluir'
      ShortCut = 16430
      OnExecute = ActExcluirExecute
    end
  end
  object QueryAtualizar: TIBQuery
    Database = DM.Conexao
    Transaction = DM.IBTransaction1
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    PrecommittedReads = False
    Left = 752
    Top = 96
  end
end
