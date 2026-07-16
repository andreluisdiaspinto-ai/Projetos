object Form_Cliente: TForm_Cliente
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'Cadastro de Clientes'
  ClientHeight = 798
  ClientWidth = 920
  Color = 16448248
  Constraints.MinHeight = 683
  Constraints.MinWidth = 920
  Font.Charset = DEFAULT_CHARSET
  Font.Color = 2697513
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  FormStyle = fsMDIChild
  KeyPreview = True
  Position = poMainFormCenter
  Visible = True
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
    Width = 920
    Height = 50
    Align = alTop
    Alignment = taLeftJustify
    BevelOuter = bvNone
    Caption = '   Cadastro de Clientes'
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
    Color = 14869221
    ParentBackground = False
    TabOrder = 1
    object LabelEstadoAtual: TLabel
      Left = 797
      Top = 0
      Width = 123
      Height = 15
      Margins.Right = 12
      Align = alClient
      Alignment = taRightJustify
      Caption = 'MODO: NAVEGACAO   '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 4278851
      Font.Height = -12
      Font.Name = 'Segoe UI Semibold'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
      ExplicitLeft = 797
      ExplicitWidth = 123
      ExplicitHeight = 15
    end
  end
  object PanelRodape: TPanel
    Left = 0
    Top = 732
    Width = 920
    Height = 66
    Align = alBottom
    BevelOuter = bvNone
    Color = 16448248
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
      Hint = 'Inserir um novo cliente (F5)'
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
    AlignWithMargins = True
    Left = 24
    Top = 94
    Width = 872
    Height = 630
    Margins.Left = 24
    Margins.Top = 16
    Margins.Right = 24
    Margins.Bottom = 8
    Align = alClient
    BevelOuter = bvNone
    Color = clWhite
    Padding.Left = 12
    Padding.Top = 8
    Padding.Right = 12
    Padding.Bottom = 8
    ParentBackground = False
    TabOrder = 2
    object PanelIdentificacao: TPanel
      Left = 12
      Top = 8
      Width = 848
      Height = 360
      Align = alTop
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
        Font.Color = 16608781
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
      object LabelNome: TLabel
        Left = 140
        Top = 34
        Width = 33
        Height = 15
        Caption = 'Nome'
        FocusControl = DBEditNome
      end
      object LabelNomeAst: TLabel
        Left = 174
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
      object LabelCpf: TLabel
        Left = 320
        Top = 88
        Width = 21
        Height = 15
        Caption = 'CPF'
        FocusControl = DBEditCPF
      end
      object LabelCnpj: TLabel
        Left = 320
        Top = 88
        Width = 28
        Height = 15
        Caption = 'CNPJ'
        FocusControl = DBEditCNPJ
        Visible = False
      end
      object LabelCep: TLabel
        Left = 12
        Top = 148
        Width = 21
        Height = 15
        Caption = 'CEP'
        FocusControl = DBEditCep
      end
      object LabelEndereco: TLabel
        Left = 12
        Top = 204
        Width = 49
        Height = 15
        Caption = 'Endere'#231'o'
        FocusControl = DBEditEndereco
      end
      object LabelEnderecoAst: TLabel
        Left = 63
        Top = 204
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
      object LabelNumero: TLabel
        Left = 760
        Top = 204
        Width = 42
        Height = 15
        Caption = 'N'#250'mero'
        FocusControl = DBEditNumero
      end
      object LabelBairro: TLabel
        Left = 12
        Top = 260
        Width = 31
        Height = 15
        Caption = 'Bairro'
        FocusControl = DBEditBairro
      end
      object LabelBairroAst: TLabel
        Left = 45
        Top = 260
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
      object LabelCidade: TLabel
        Left = 460
        Top = 260
        Width = 37
        Height = 15
        Caption = 'Cidade'
        FocusControl = DBEditCidade
      end
      object LabelCidadeAst: TLabel
        Left = 499
        Top = 260
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
      object LabelTelefone: TLabel
        Left = 12
        Top = 316
        Width = 45
        Height = 15
        Caption = 'Telefone'
        FocusControl = DBEditTelefone
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
        DataSource = DM.DsCliente
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 5263440
        Font.Height = -14
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        ReadOnly = True
        TabOrder = 0
      end
      object DBEditNome: TDBEdit
        Left = 140
        Top = 54
        Width = 696
        Height = 27
        Hint = 'Nome do Cliente'
        CharCase = ecUpperCase
        DataField = 'NOME'
        DataSource = DM.DsCliente
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 2697513
        Font.Height = -14
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = False
        TabOrder = 1
        OnEnter = EditFocoEnter
        OnExit = DBEditObrigatorioExit
      end
      object DBRadioTipo: TDBRadioGroup
        Left = 12
        Top = 88
        Width = 292
        Height = 50
        Caption = ' Tipo '
        Columns = 2
        DataField = 'TIPO'
        DataSource = DM.DsCliente
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 2697513
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        Items.Strings = (
          'Pessoa F'#237'sica'
          'Pessoa Jur'#237'dica')
        ParentFont = False
        TabOrder = 2
        Values.Strings = (
          'F'
          'J')
        OnChange = DBRadioTipoChange
      end
      object DBEditCPF: TDBEdit
        Left = 320
        Top = 106
        Width = 200
        Height = 27
        Hint = 'CPF'
        DataField = 'CPF'
        DataSource = DM.DsCliente
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 2697513
        Font.Height = -14
        Font.Name = 'Segoe UI'
        Font.Style = []
        MaxLength = 14
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
        OnEnter = DBEditCPFEnter
        OnExit = DBEditCPFExit
        OnKeyPress = DBEditCPFKeyPress
      end
      object DBEditCNPJ: TDBEdit
        Left = 320
        Top = 106
        Width = 220
        Height = 27
        Hint = 'CNPJ'
        CharCase = ecUpperCase
        DataField = 'CNPJ'
        DataSource = DM.DsCliente
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 2697513
        Font.Height = -14
        Font.Name = 'Segoe UI'
        Font.Style = []
        MaxLength = 18
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 4
        Visible = False
        OnEnter = DBEditCNPJEnter
        OnExit = DBEditCNPJExit
        OnKeyPress = DBEditCNPJKeyPress
      end
      object DBEditCep: TDBEdit
        Left = 12
        Top = 166
        Width = 120
        Height = 27
        Hint = 'CEP'
        DataField = 'CEP'
        DataSource = DM.DsCliente
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 2697513
        Font.Height = -14
        Font.Name = 'Segoe UI'
        Font.Style = []
        MaxLength = 9
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 5
        OnEnter = DBEditCepEnter
        OnExit = DBEditCepExit
        OnKeyPress = DBEditCepKeyPress
      end
      object DBEditEndereco: TDBEdit
        Left = 12
        Top = 224
        Width = 732
        Height = 27
        Hint = 'Endereco'
        CharCase = ecUpperCase
        DataField = 'ENDERECO'
        DataSource = DM.DsCliente
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 2697513
        Font.Height = -14
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 6
        OnEnter = EditFocoEnter
        OnExit = DBEditObrigatorioExit
      end
      object DBEditNumero: TDBEdit
        Left = 760
        Top = 224
        Width = 76
        Height = 27
        Hint = 'Numero'
        CharCase = ecUpperCase
        DataField = 'NUMERO'
        DataSource = DM.DsCliente
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 2697513
        Font.Height = -14
        Font.Name = 'Segoe UI'
        Font.Style = []
        MaxLength = 10
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 7
        OnEnter = EditFocoEnter
        OnExit = EditFocoExit
      end
      object DBEditBairro: TDBEdit
        Left = 12
        Top = 280
        Width = 440
        Height = 27
        Hint = 'Bairro'
        CharCase = ecUpperCase
        DataField = 'BAIRRO'
        DataSource = DM.DsCliente
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 2697513
        Font.Height = -14
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 8
        OnEnter = EditFocoEnter
        OnExit = DBEditObrigatorioExit
      end
      object DBEditCidade: TDBEdit
        Left = 460
        Top = 280
        Width = 376
        Height = 27
        Hint = 'Cidade'
        CharCase = ecUpperCase
        DataField = 'CIDADE'
        DataSource = DM.DsCliente
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 2697513
        Font.Height = -14
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 9
        OnEnter = EditFocoEnter
        OnExit = DBEditObrigatorioExit
      end
      object DBEditTelefone: TDBEdit
        Left = 12
        Top = 336
        Width = 220
        Height = 27
        Hint = 'Fixo: 10 d'#237'gitos com DDD  |  Celular: 11 d'#237'gitos com DDD'
        DataField = 'TELEFONE'
        DataSource = DM.DsCliente
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 3355443
        Font.Height = -14
        Font.Name = 'Segoe UI'
        Font.Style = []
        MaxLength = 15
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 10
        OnEnter = DBEditTelefoneEnter
        OnExit = DBEditTelefoneExit
        OnKeyPress = DBEditTelefoneKeyPress
      end
    end
    object PanelObservacao: TPanel
      AlignWithMargins = True
      Left = 12
      Top = 376
      Width = 848
      Height = 108
      Margins.Left = 0
      Margins.Top = 8
      Margins.Right = 0
      Margins.Bottom = 8
      Align = alClient
      BevelOuter = bvNone
      Color = clWhite
      ParentBackground = False
      TabOrder = 1
      object LabelObservacao: TLabel
        Left = 12
        Top = 8
        Width = 80
        Height = 19
        Caption = 'Observa'#231#245'es'
        FocusControl = DBMemoObs
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 16608781
        Font.Height = -14
        Font.Name = 'Segoe UI Semibold'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object DBMemoObs: TDBMemo
        Left = 12
        Top = 30
        Width = 824
        Height = 56
        DataField = 'OBSERVACAO'
        DataSource = DM.DsCliente
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 2697513
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 0
        OnEnter = EditFocoEnter
        OnExit = EditFocoExit
      end
    end
    object GroupBoxValores: TGroupBox
      AlignWithMargins = True
      Left = 12
      Top = 492
      Width = 848
      Height = 130
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
      TabOrder = 2
      object LabelRendaMensal: TLabel
        Left = 16
        Top = 32
        Width = 74
        Height = 15
        Caption = 'Renda mensal'
        FocusControl = DBEditRendaMensal
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 3355443
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object LabelLimiteCredito: TLabel
        Left = 220
        Top = 32
        Width = 89
        Height = 15
        Caption = 'Limite de cr'#233'dito'
        FocusControl = DBEditLimiteCredito
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 3355443
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object LabelTotalCompras: TLabel
        Left = 424
        Top = 32
        Width = 91
        Height = 15
        Caption = 'Total de compras'
        FocusControl = DBEditCompras
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 3355443
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object DBEditRendaMensal: TDBEdit
        Left = 16
        Top = 52
        Width = 188
        Height = 27
        DataField = 'RENDA_MENSAL'
        DataSource = DM.DsCliente
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 3355443
        Font.Height = -14
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnEnter = EditFocoEnter
        OnExit = DBEditRendaMensalExit
      end
      object DBEditLimiteCredito: TDBEdit
        Left = 220
        Top = 52
        Width = 188
        Height = 27
        TabStop = False
        Color = 15790320
        DataField = 'LIMITE_CREDITO'
        DataSource = DM.DsCliente
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 5263440
        Font.Height = -14
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        ReadOnly = True
        TabOrder = 1
      end
      object DBEditCompras: TDBEdit
        Left = 424
        Top = 52
        Width = 188
        Height = 27
        TabStop = False
        Color = 15790320
        DataField = 'TOTAL_COMPRAS'
        DataSource = DM.DsCliente
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 5263440
        Font.Height = -14
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        ReadOnly = True
        TabOrder = 2
      end
      object BtnAtualizar: TBitBtn
        Left = 668
        Top = 84
        Width = 212
        Height = 34
        Hint = 'Recalcula o total de compras do cliente (F7)'
        Caption = 'Atualizar total de compras'
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
        TabOrder = 3
        OnClick = BtnAtualizarClick
      end
    end
  end
  object QueryAtualizar: TIBQuery
    Database = DM.Conexao
    Transaction = DM.IBTransaction1
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    PrecommittedReads = False
    Left = 848
    Top = 96
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
    object ActAtualizar: TAction
      Caption = 'Atualizar'
      ShortCut = 118
      OnExecute = ActAtualizarExecute
    end
  end
end
