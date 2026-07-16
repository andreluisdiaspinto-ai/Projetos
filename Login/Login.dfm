object Form_Login: TForm_Login
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'Acesso ao Sistema'
  ClientHeight = 430
  ClientWidth = 429
  Color = 16448248
  Constraints.MinHeight = 430
  Constraints.MinWidth = 420
  Font.Charset = DEFAULT_CHARSET
  Font.Color = 2697513
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 15
  object Panel_Titulo: TPanel
    Left = 0
    Top = 0
    Width = 429
    Height = 50
    Align = alTop
    BevelOuter = bvNone
    Caption = '   Acesso ao Sistema'
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
  object PanelDados: TPanel
    AlignWithMargins = True
    Left = 24
    Top = 66
    Width = 381
    Height = 290
    Margins.Left = 24
    Margins.Top = 16
    Margins.Right = 24
    Margins.Bottom = 8
    Align = alClient
    AutoSize = True
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 1
    DesignSize = (
      381
      290)
    object LabelIconeUsuario: TLabel
      Left = 0
      Top = 6
      Width = 405
      Height = 56
      Alignment = taCenter
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 16608781
      Font.Height = -40
      Font.Name = 'Segoe MDL2 Assets'
      Font.Style = []
      ParentFont = False
      Transparent = True
      ExplicitWidth = 381
    end
    object LabelInstrucao: TLabel
      Left = 0
      Top = 109
      Width = 405
      Height = 16
      Alignment = taCenter
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = 'Informe suas credenciais para acessar o sistema'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 8221548
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      Transparent = True
      ExplicitWidth = 381
    end
    object LabelLogin: TLabel
      Left = 48
      Top = 134
      Width = 30
      Height = 15
      Caption = 'Login'
      Transparent = True
    end
    object LabelLoginAst: TLabel
      Left = 80
      Top = 134
      Width = 5
      Height = 15
      Caption = '*'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
    object LabelSenha: TLabel
      Left = 48
      Top = 192
      Width = 32
      Height = 15
      Caption = 'Senha'
      Transparent = True
    end
    object LabelSenhaAst: TLabel
      Left = 84
      Top = 192
      Width = 5
      Height = 15
      Caption = '*'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
    object LabelTentativas: TLabel
      Left = 0
      Top = 262
      Width = 405
      Height = 18
      Alignment = taCenter
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
      ExplicitWidth = 381
    end
    object Label1: TLabel
      Left = 0
      Top = 50
      Width = 405
      Height = 46
      Alignment = taCenter
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = 'GANSO SISTEMAS'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 16608781
      Font.Height = -40
      Font.Name = 'Segoe MDL2 Assets'
      Font.Style = [fsBold, fsItalic]
      ParentFont = False
      Transparent = True
      ExplicitWidth = 381
    end
    object EditLogin: TEdit
      Left = 48
      Top = 152
      Width = 285
      Height = 25
      Hint = 'Login do usuario (maximo 20 caracteres)'
      CharCase = ecLowerCase
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 3355443
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      MaxLength = 20
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnChange = EditLoginChange
      OnEnter = EditFocoEnter
      OnExit = EditFocoExit
    end
    object EditSenha: TEdit
      Left = 48
      Top = 210
      Width = 285
      Height = 25
      Hint = 'Senha do usuario (maximo 15 caracteres)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 3355443
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      MaxLength = 15
      ParentFont = False
      ParentShowHint = False
      PasswordChar = '*'
      ShowHint = True
      TabOrder = 1
      OnChange = EditLoginChange
      OnEnter = EditFocoEnter
      OnExit = EditFocoExit
    end
  end
  object PanelRodape: TPanel
    Left = 0
    Top = 364
    Width = 429
    Height = 66
    Align = alBottom
    BevelOuter = bvNone
    Color = 16448248
    ParentBackground = False
    TabOrder = 2
    object BtnEntrar: TBitBtn
      Left = 106
      Top = 12
      Width = 112
      Height = 42
      Hint = 'Entrar no sistema (ENTER)'
      Caption = '&Entrar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      Margin = 10
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      Spacing = 8
      TabOrder = 0
      OnClick = BtnEntrarClick
    end
    object BtnSair: TBitBtn
      Left = 258
      Top = 12
      Width = 112
      Height = 42
      Hint = 'Sair do sistema (ESC)'
      Caption = '&Sair'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      Margin = 10
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      Spacing = 8
      TabOrder = 1
      OnClick = BtnSairClick
    end
  end
  object QueryLogin: TIBQuery
    Database = DM.Conexao
    Transaction = DM.IBTransaction1
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    PrecommittedReads = False
    Left = 24
    Top = 376
  end
end
