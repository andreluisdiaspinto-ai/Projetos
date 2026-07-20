object Form_Produto: TForm_Produto
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'Cadastro de Produtos'
  ClientHeight = 600
  ClientWidth = 920
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
  OnActivate = FormActivate
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 15
  object Panel_Titulo: TPanel
    Left = 0
    Top = 0
    Width = 920
    Height = 50
    Align = alTop
    Alignment = taLeftJustify
    BevelOuter = bvNone
    Caption = '   Cadastro de Produtos'
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
    Width = 920
    Height = 28
    Align = alTop
    BevelOuter = bvNone
    Color = 15263976
    ParentBackground = False
    TabOrder = 1
    object LabelEstadoAtual: TLabel
      Left = 0
      Top = 0
      Width = 920
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
      ExplicitLeft = 785
      ExplicitWidth = 123
      ExplicitHeight = 15
    end
  end
  object PanelRodape: TPanel
    Left = 0
    Top = 534
    Width = 920
    Height = 66
    Align = alBottom
    BevelOuter = bvNone
    Color = 15790320
    ParentBackground = False
    TabOrder = 3
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
      Hint = 'Primeiro registro'
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
      Hint = 'Registro anterior'
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
      Hint = 'Pr'#243'ximo registro'
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
      Hint = #218'ltimo registro'
      Margin = 0
      ParentShowHint = False
      ShowHint = True
      Spacing = 0
      TabOrder = 3
      OnClick = BtnUltimoClick
    end
    object BtnInserir: TBitBtn
      Left = 218
      Top = 12
      Width = 108
      Height = 42
      Hint = 'Inserir um novo produto (F5)'
      Caption = '&Inserir'
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
      TabOrder = 4
      OnClick = BtnInserirClick
    end
    object BtnEditar: TBitBtn
      Left = 332
      Top = 12
      Width = 108
      Height = 42
      Hint = 'Editar o registro atual (F6)'
      Caption = '&Editar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 16750899
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      Margin = 10
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      Spacing = 8
      TabOrder = 5
      OnClick = BtnEditarClick
    end
    object BtnGravar: TBitBtn
      Left = 446
      Top = 12
      Width = 108
      Height = 42
      Hint = 'Gravar as altera'#231#245'es (F9)'
      Caption = '&Gravar'
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
      TabOrder = 6
      OnClick = BtnGravarClick
    end
    object BtnCancelar: TBitBtn
      Left = 560
      Top = 12
      Width = 108
      Height = 42
      Hint = 'Cancelar as altera'#231#245'es'
      Caption = '&Cancelar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 3355443
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      Margin = 10
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      Spacing = 8
      TabOrder = 7
      OnClick = BtnCancelarClick
      OnMouseDown = BtnCancelarMouseDown
    end
    object BtnExcluir: TBitBtn
      Left = 674
      Top = 12
      Width = 108
      Height = 42
      Hint = 'Excluir o registro atual'
      Caption = 'E&xcluir'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      Margin = 10
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      Spacing = 8
      TabOrder = 8
      OnClick = BtnExcluirClick
    end
    object BtnSair: TBitBtn
      Left = 796
      Top = 12
      Width = 108
      Height = 42
      Hint = 'Fechar o formul'#225'rio (ESC)'
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
      TabOrder = 9
      OnClick = BtnSairClick
      OnMouseDown = BtnSairMouseDown
    end
  end
  object PanelDados: TPanel
    Left = 0
    Top = 78
    Width = 920
    Height = 456
    Align = alClient
    BevelOuter = bvNone
    Color = 16119285
    Padding.Left = 12
    Padding.Top = 8
    Padding.Right = 12
    Padding.Bottom = 8
    ParentBackground = False
    TabOrder = 2
    object PageControlProduto: TPageControl
      Left = 12
      Top = 8
      Width = 896
      Height = 440
      ActivePage = TabCadastro
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 3355443
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnChange = PageControlProdutoChange
      object TabCadastro: TTabSheet
        Caption = 'Cadastro'
        object PanelIdentificacao: TPanel
          Left = 0
          Top = 0
          Width = 888
          Height = 218
          Align = alClient
          BevelOuter = bvNone
          Color = clWhite
          ParentBackground = False
          TabOrder = 0
          object LabelSecaoIdent: TLabel
            Left = 12
            Top = 8
            Width = 81
            Height = 19
            Caption = 'Identifica'#231#227'o'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -14
            Font.Name = 'Segoe UI Semibold'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object LabelCodigo: TLabel
            Left = 12
            Top = 34
            Width = 39
            Height = 15
            Caption = 'C'#243'digo'
            FocusControl = DBEditCodigo
          end
          object LabelDescricao: TLabel
            Left = 140
            Top = 34
            Width = 51
            Height = 15
            Caption = 'Descri'#231#227'o'
            FocusControl = DBEditDescricao
          end
          object LabelDescricaoAst: TLabel
            Left = 199
            Top = 34
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
          object LabelReferencia: TLabel
            Left = 12
            Top = 92
            Width = 55
            Height = 15
            Caption = 'Refer'#234'ncia'
            FocusControl = DBEditReferencia
          end
          object LabelReferenciaAst: TLabel
            Left = 75
            Top = 92
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
          object LabelCodigoBarras: TLabel
            Left = 460
            Top = 92
            Width = 90
            Height = 15
            Caption = 'C'#243'digo de barras'
            FocusControl = DBEditCodigoBarras
          end
          object LabelCodigoBarrasAst: TLabel
            Left = 558
            Top = 92
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
          object LabelMarca: TLabel
            Left = 12
            Top = 150
            Width = 33
            Height = 15
            Caption = 'Marca'
            FocusControl = DBEditMarca
          end
          object LabelGrupo: TLabel
            Left = 460
            Top = 150
            Width = 33
            Height = 15
            Caption = 'Grupo'
            FocusControl = DBEditGrupo
          end
          object DBEditCodigo: TDBEdit
            Left = 12
            Top = 54
            Width = 116
            Height = 26
            TabStop = False
            BorderStyle = bsNone
            Color = 15790320
            DataField = 'CODIGO'
            DataSource = DM.DsProduto
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 5263440
            Font.Height = -14
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
            ReadOnly = True
            TabOrder = 0
          end
          object DBEditDescricao: TDBEdit
            Left = 140
            Top = 54
            Width = 732
            Height = 27
            Hint = 'Descricao'
            CharCase = ecUpperCase
            DataField = 'DESCRICAO'
            DataSource = DM.DsProduto
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 3355443
            Font.Height = -14
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 1
            OnEnter = EditFocoEnter
            OnExit = DBEditObrigatorioExit
          end
          object DBEditReferencia: TDBEdit
            Left = 12
            Top = 112
            Width = 440
            Height = 27
            Hint = 'Referencia'
            CharCase = ecUpperCase
            DataField = 'REFERENCIA'
            DataSource = DM.DsProduto
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 3355443
            Font.Height = -14
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 2
            OnEnter = EditFocoEnter
            OnExit = DBEditObrigatorioExit
          end
          object DBEditCodigoBarras: TDBEdit
            Left = 460
            Top = 112
            Width = 412
            Height = 27
            Hint = 'Codigo de Barras'
            DataField = 'CODIGO_BARRAS'
            DataSource = DM.DsProduto
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 3355443
            Font.Height = -14
            Font.Name = 'Segoe UI'
            Font.Style = []
            MaxLength = 18
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 3
            OnEnter = EditFocoEnter
            OnExit = DBEditObrigatorioExit
            OnKeyPress = DBEditCodigoBarrasKeyPress
          end
          object DBEditMarca: TDBEdit
            Left = 12
            Top = 170
            Width = 440
            Height = 27
            Hint = 'Marca'
            CharCase = ecUpperCase
            DataField = 'MARCA'
            DataSource = DM.DsProduto
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 3355443
            Font.Height = -14
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 4
            OnEnter = EditFocoEnter
            OnExit = EditFocoExit
          end
          object DBEditGrupo: TDBEdit
            Left = 460
            Top = 170
            Width = 412
            Height = 27
            Hint = 'Grupo'
            CharCase = ecUpperCase
            DataField = 'GRUPO'
            DataSource = DM.DsProduto
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 3355443
            Font.Height = -14
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 5
            OnEnter = EditFocoEnter
            OnExit = EditFocoExit
          end
        end
        object GroupBoxValores: TGroupBox
          AlignWithMargins = True
          Left = 0
          Top = 226
          Width = 888
          Height = 180
          Margins.Left = 0
          Margins.Top = 8
          Margins.Right = 0
          Margins.Bottom = 0
          Align = alBottom
          Caption = ' Valores '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -14
          Font.Name = 'Segoe UI Semibold'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
          object LabelUnd: TLabel
            Left = 16
            Top = 32
            Width = 24
            Height = 15
            Caption = 'UND'
            FocusControl = DBEditUnd
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 3355443
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
          end
          object LabelUndAst: TLabel
            Left = 44
            Top = 32
            Width = 5
            Height = 15
            Caption = '*'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clRed
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
          end
          object LabelPrecoCusto: TLabel
            Left = 148
            Top = 32
            Width = 76
            Height = 15
            Caption = 'Pre'#231'o de custo'
            FocusControl = DBEditPrecoCusto
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 3355443
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
          end
          object LabelPrecoVenda: TLabel
            Left = 348
            Top = 32
            Width = 81
            Height = 15
            Caption = 'Pre'#231'o de venda'
            FocusControl = DBEditPrecoVenda
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 3355443
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
          end
          object LabelEstoqueAtual: TLabel
            Left = 548
            Top = 32
            Width = 71
            Height = 15
            Caption = 'Estoque atual'
            FocusControl = DBEditEstoqueAtual
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 3355443
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
          end
          object LabelMargemLucro: TLabel
            Left = 16
            Top = 88
            Width = 103
            Height = 15
            Caption = 'Margem de lucro (%)'
            FocusControl = DBEditMargemLucro
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 3355443
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
          end
          object DBEditUnd: TDBEdit
            Left = 16
            Top = 52
            Width = 120
            Height = 27
            Hint = 'A unidade de medida'
            CharCase = ecUpperCase
            DataField = 'UND'
            DataSource = DM.DsProduto
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 3355443
            Font.Height = -14
            Font.Name = 'Segoe UI'
            Font.Style = []
            MaxLength = 6
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            OnEnter = EditFocoEnter
            OnExit = DBEditObrigatorioExit
          end
          object DBEditPrecoCusto: TDBEdit
            Left = 148
            Top = 52
            Width = 188
            Height = 27
            Hint = 'O preco de custo'
            DataField = 'PRECO_CUSTO'
            DataSource = DM.DsProduto
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 3355443
            Font.Height = -14
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 1
            OnEnter = EditFocoEnter
            OnExit = DBEditPrecoCustoExit
          end
          object DBEditPrecoVenda: TDBEdit
            Left = 348
            Top = 52
            Width = 188
            Height = 27
            Hint = 'O preco de venda'
            DataField = 'PRECO_VENDA'
            DataSource = DM.DsProduto
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 3355443
            Font.Height = -14
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 2
            OnEnter = EditFocoEnter
            OnExit = DBEditValorPositivoExit
          end
          object DBEditEstoqueAtual: TDBEdit
            Left = 548
            Top = 52
            Width = 188
            Height = 27
            Hint = 'O estoque atual'
            DataField = 'ESTOQUE_ATUAL'
            DataSource = DM.DsProduto
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
            OnExit = DBEditValorPositivoExit
          end
          object DBEditMargemLucro: TDBEdit
            Left = 16
            Top = 108
            Width = 188
            Height = 27
            Hint = 'Calculada automaticamente: ((preco venda - preco custo) / preco custo) * 100'
            Color = clBtnFace
            DataField = 'MARGEM_LUCRO'
            DataSource = DM.DsProduto
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 3355443
            Font.Height = -14
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
            ParentShowHint = False
            ReadOnly = True
            ShowHint = True
            TabOrder = 4
            OnEnter = EditFocoEnter
          end
        end
      end
      object TabMovimentacao: TTabSheet
        Caption = 'Movimenta'#231#227'o'
        ImageIndex = 1
        object DBGridVndaItem: TDBGrid
          Left = 0
          Top = 0
          Width = 888
          Height = 334
          Align = alClient
          DataSource = DsMovProduto
          DrawingStyle = gdsClassic
          Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
          ReadOnly = True
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clNavy
          TitleFont.Height = -12
          TitleFont.Name = 'Segoe UI Semibold'
          TitleFont.Style = [fsBold]
          OnDrawColumnCell = DBGridVndaItemDrawColumnCell
          Columns = <
            item
              Expanded = False
              FieldName = 'CODIGO'
              Title.Caption = 'C'#243'd. Venda'
              Width = 80
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'DATA_HORA_VENDA'
              Title.Caption = 'Data/Hora'
              Width = 130
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'CODIGO_PRODUTO'
              Title.Caption = 'C'#243'd. Produto'
              Width = 90
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'DESCRICAO'
              Title.Caption = 'Descri'#231#227'o'
              Width = 220
              Visible = True
            end
            item
              Alignment = taRightJustify
              Expanded = False
              FieldName = 'QUANTIDADE'
              Title.Alignment = taRightJustify
              Title.Caption = 'Quantidade'
              Width = 90
              Visible = True
            end
            item
              Alignment = taRightJustify
              Expanded = False
              FieldName = 'PRECO_UNITARIO'
              Title.Alignment = taRightJustify
              Title.Caption = 'Pre'#231'o Unit.'
              Width = 100
              Visible = True
            end
            item
              Alignment = taRightJustify
              Expanded = False
              FieldName = 'TOTAL_LIQUIDO'
              Title.Alignment = taRightJustify
              Title.Caption = 'Total L'#237'quido'
              Width = 110
              Visible = True
            end>
        end
        object PanelTotaisMov: TPanel
          Left = 0
          Top = 334
          Width = 888
          Height = 72
          Align = alBottom
          BevelOuter = bvNone
          Color = clWhite
          ParentBackground = False
          TabOrder = 1
          object LabelTotalItens: TLabel
            Left = 16
            Top = 10
            Width = 128
            Height = 15
            Caption = 'Total Itens Vendidos'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 5263440
            Font.Height = -12
            Font.Name = 'Segoe UI Semibold'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object LabelTotalLiquidoMov: TLabel
            Left = 280
            Top = 10
            Width = 78
            Height = 15
            Caption = 'Total L'#237'quido'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -12
            Font.Name = 'Segoe UI Semibold'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object EditTotalItens: TEdit
            Left = 16
            Top = 30
            Width = 240
            Height = 29
            TabStop = False
            Alignment = taRightJustify
            Color = 15790320
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 5263440
            Font.Height = -16
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
            ReadOnly = True
            TabOrder = 0
            Text = '0,000'
          end
          object EditTotalLiquidoMov: TEdit
            Left = 280
            Top = 30
            Width = 240
            Height = 29
            TabStop = False
            Alignment = taRightJustify
            Color = 15790320
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -16
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
            ReadOnly = True
            TabOrder = 1
            Text = '0,00'
          end
        end
      end
    end
  end
  object QueryMovProduto: TIBQuery
    Database = DM.Conexao
    Transaction = DM.IBTransaction1
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    Left = 48
    Top = 500
  end
  object DsMovProduto: TDataSource
    DataSet = QueryMovProduto
    Left = 136
    Top = 500
  end
  object ActionList: TActionList
    Left = 776
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
end
