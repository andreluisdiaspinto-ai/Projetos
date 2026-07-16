object Form_Usuario: TForm_Usuario
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'Cadastro de Usuarios'
  ClientHeight = 420
  ClientWidth = 720
  Color = 16119285
  Constraints.MinHeight = 380
  Constraints.MinWidth = 640
  Font.Charset = DEFAULT_CHARSET
  Font.Color = 3355443
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  FormStyle = fsMDIChild
  KeyPreview = True
  Position = poMainFormCenter
  Visible = True
  WindowState = wsNormal
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
    Width = 720
    Height = 50
    Align = alTop
    Alignment = taLeftJustify
    BevelOuter = bvNone
    Caption = '   Cadastro de Usuarios'
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
    Width = 720
    Height = 28
    Align = alTop
    BevelOuter = bvNone
    Color = 15263976
    ParentBackground = False
    TabOrder = 1
    object LabelEstadoAtual: TLabel
      Left = 0
      Top = 0
      Width = 720
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
      ExplicitLeft = 585
      ExplicitWidth = 123
      ExplicitHeight = 15
    end
  end
  object PanelRodape: TPanel
    Left = 0
    Top = 354
    Width = 720
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
      Left = 214
      Top = 12
      Width = 72
      Height = 42
      Hint = 'Inserir um novo usuario (F5)'
      Caption = '&Inserir'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      Margin = 4
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      Spacing = 4
      TabOrder = 4
      OnClick = BtnInserirClick
    end
    object BtnEditar: TBitBtn
      Left = 290
      Top = 12
      Width = 72
      Height = 42
      Hint = 'Editar o registro atual (F6)'
      Caption = '&Editar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 16750899
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      Margin = 4
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      Spacing = 4
      TabOrder = 5
      OnClick = BtnEditarClick
    end
    object BtnGravar: TBitBtn
      Left = 366
      Top = 12
      Width = 72
      Height = 42
      Hint = 'Gravar as altera'#231#245'es (F9)'
      Caption = '&Gravar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 2263842
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      Margin = 4
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      Spacing = 4
      TabOrder = 6
      OnClick = BtnGravarClick
    end
    object BtnCancelar: TBitBtn
      Left = 442
      Top = 12
      Width = 78
      Height = 42
      Hint = 'Cancelar as altera'#231#245'es'
      Caption = '&Cancelar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 3355443
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      Margin = 4
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      Spacing = 4
      TabOrder = 7
      OnClick = BtnCancelarClick
      OnMouseDown = BtnCancelarMouseDown
    end
    object BtnExcluir: TBitBtn
      Left = 524
      Top = 12
      Width = 72
      Height = 42
      Hint = 'Excluir o registro atual'
      Caption = 'E&xcluir'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      Margin = 4
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      Spacing = 4
      TabOrder = 8
      OnClick = BtnExcluirClick
    end
    object BtnSair: TBitBtn
      Left = 600
      Top = 12
      Width = 72
      Height = 42
      Hint = 'Fechar o formul'#225'rio (ESC)'
      Caption = '&Sair'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 6710015
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      Margin = 4
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      Spacing = 4
      TabOrder = 9
      OnClick = BtnSairClick
      OnMouseDown = BtnSairMouseDown
    end
  end
  object PanelDados: TPanel
    Left = 0
    Top = 78
    Width = 720
    Height = 276
    Align = alClient
    BevelOuter = bvNone
    Color = 16119285
    Padding.Left = 12
    Padding.Top = 8
    Padding.Right = 12
    Padding.Bottom = 8
    ParentBackground = False
    TabOrder = 2
    object PanelIdentificacao: TPanel
      Left = 12
      Top = 8
      Width = 696
      Height = 260
      Align = alClient
      BevelOuter = bvNone
      Color = clWhite
      ParentBackground = False
      TabOrder = 0
      object LabelSecaoIdent: TLabel
        Left = 16
        Top = 12
        Width = 48
        Height = 19
        Caption = 'Dados'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -14
        Font.Name = 'Segoe UI Semibold'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object LabelCodigo: TLabel
        Left = 16
        Top = 44
        Width = 39
        Height = 15
        Caption = 'C'#243'digo'
        FocusControl = DBEditCodigo
      end
      object LabelLogin: TLabel
        Left = 148
        Top = 44
        Width = 28
        Height = 15
        Caption = 'Login'
        FocusControl = DBEditLogin
      end
      object LabelLoginAst: TLabel
        Left = 180
        Top = 44
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
      object LabelSenha: TLabel
        Left = 16
        Top = 108
        Width = 32
        Height = 15
        Caption = 'Senha'
        FocusControl = DBEditSenha
      end
      object LabelSenhaAst: TLabel
        Left = 52
        Top = 108
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
      object LabelConfirmaSenha: TLabel
        Left = 280
        Top = 108
        Width = 95
        Height = 15
        Caption = 'Confirmar senha'
        FocusControl = EditConfirmaSenha
      end
      object LabelConfirmaSenhaAst: TLabel
        Left = 380
        Top = 108
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
      object LabelNome: TLabel
        Left = 16
        Top = 172
        Width = 88
        Height = 15
        Caption = 'Nome do usuario'
        FocusControl = DBEditNome
      end
      object LabelNomeAst: TLabel
        Left = 110
        Top = 172
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
      object DBEditCodigo: TDBEdit
        Left = 16
        Top = 64
        Width = 116
        Height = 26
        TabStop = False
        BorderStyle = bsNone
        Color = 15790320
        DataField = 'CODIGO'
        DataSource = DsUsuario
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 5263440
        Font.Height = -14
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        ReadOnly = True
        TabOrder = 0
      end
      object DBEditLogin: TDBEdit
        Left = 148
        Top = 64
        Width = 240
        Height = 27
        Hint = 'Login'
        CharCase = ecUpperCase
        DataField = 'LOGIN'
        DataSource = DsUsuario
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 3355443
        Font.Height = -14
        Font.Name = 'Segoe UI'
        Font.Style = []
        MaxLength = 20
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnEnter = EditFocoEnter
        OnExit = DBEditObrigatorioExit
      end
      object DBEditSenha: TDBEdit
        Left = 16
        Top = 128
        Width = 240
        Height = 27
        Hint = 'Senha'
        DataField = 'SENHA'
        DataSource = DsUsuario
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 3355443
        Font.Height = -14
        Font.Name = 'Segoe UI'
        Font.Style = []
        MaxLength = 15
        ParentFont = False
        ParentShowHint = False
        PasswordChar = '*'
        ShowHint = True
        TabOrder = 2
        OnEnter = EditFocoEnter
        OnExit = DBEditObrigatorioExit
      end
      object EditConfirmaSenha: TEdit
        Left = 280
        Top = 128
        Width = 240
        Height = 27
        Hint = 'Confirmacao de senha'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 3355443
        Font.Height = -14
        Font.Name = 'Segoe UI'
        Font.Style = []
        MaxLength = 15
        ParentFont = False
        ParentShowHint = False
        PasswordChar = '*'
        ShowHint = True
        TabOrder = 3
        OnEnter = EditFocoEnter
        OnExit = EditConfirmaSenhaExit
      end
      object DBEditNome: TDBEdit
        Left = 16
        Top = 192
        Width = 504
        Height = 27
        Hint = 'Nome'
        CharCase = ecUpperCase
        DataField = 'NOME_USUARIO'
        DataSource = DsUsuario
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 3355443
        Font.Height = -14
        Font.Name = 'Segoe UI'
        Font.Style = []
        MaxLength = 35
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 4
        OnEnter = EditFocoEnter
        OnExit = DBEditObrigatorioExit
      end
    end
  end
  object SqlUsuario: TIBQuery
    Database = DM.Conexao
    Transaction = DM.IBTransaction1
    BufferChunks = 1000
    CachedUpdates = True
    ParamCheck = True
    SQL.Strings = (
      'select CODIGO, LOGIN, SENHA, NOME_USUARIO from USUARIO'
      'order by LOGIN')
    UpdateObject = UpdUsuario
    PrecommittedReads = False
    Left = 560
    Top = 200
    object SqlUsuarioCODIGO: TIntegerField
      FieldName = 'CODIGO'
      Origin = 'USUARIO.CODIGO'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object SqlUsuarioLOGIN: TIBStringField
      FieldName = 'LOGIN'
      Origin = 'USUARIO.LOGIN'
      Required = True
      Size = 20
    end
    object SqlUsuarioSENHA: TIBStringField
      FieldName = 'SENHA'
      Origin = 'USUARIO.SENHA'
      Required = True
      Size = 15
    end
    object SqlUsuarioNOME_USUARIO: TIBStringField
      FieldName = 'NOME_USUARIO'
      Origin = 'USUARIO.NOME_USUARIO'
      Required = True
      Size = 35
    end
  end
  object UpdUsuario: TIBUpdateSQL
    RefreshSQL.Strings = (
      'Select '
      '  CODIGO,'
      '  LOGIN,'
      '  SENHA,'
      '  NOME_USUARIO'
      'from USUARIO '
      'where'
      '  CODIGO = :CODIGO')
    ModifySQL.Strings = (
      'update USUARIO'
      'set'
      '  LOGIN = :LOGIN,'
      '  SENHA = :SENHA,'
      '  NOME_USUARIO = :NOME_USUARIO'
      'where'
      '  CODIGO = :OLD_CODIGO')
    InsertSQL.Strings = (
      'insert into USUARIO'
      '  (CODIGO, LOGIN, SENHA, NOME_USUARIO)'
      'values'
      '  (:CODIGO, :LOGIN, :SENHA, :NOME_USUARIO)')
    DeleteSQL.Strings = (
      'delete from USUARIO'
      'where'
      '  CODIGO = :OLD_CODIGO')
    Left = 624
    Top = 200
  end
  object DsUsuario: TDataSource
    DataSet = SqlUsuario
    OnDataChange = DsUsuarioDataChange
    OnStateChange = DsUsuarioStateChange
    Left = 560
    Top = 256
  end
  object ActionList: TActionList
    Left = 624
    Top = 256
    object ActPrimeiro: TAction
      Caption = 'Primeiro'
      OnExecute = ActPrimeiroExecute
    end
    object ActAnterior: TAction
      Caption = 'Anterior'
      OnExecute = ActAnteriorExecute
    end
    object ActProximo: TAction
      Caption = 'Proximo'
      OnExecute = ActProximoExecute
    end
    object ActUltimo: TAction
      Caption = 'Ultimo'
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
      OnExecute = ActExcluirExecute
    end
  end
end
