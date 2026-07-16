object Form_Temas: TForm_Temas
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'Temas do Sistema'
  ClientHeight = 420
  ClientWidth = 640
  Color = 16119285
  Constraints.MinHeight = 380
  Constraints.MinWidth = 560
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
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 15
  object Panel_Titulo: TPanel
    Left = 0
    Top = 0
    Width = 640
    Height = 50
    Align = alTop
    Alignment = taLeftJustify
    BevelOuter = bvNone
    Caption = '   Temas do Sistema'
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
  object PanelRodape: TPanel
    Left = 0
    Top = 354
    Width = 640
    Height = 66
    Align = alBottom
    BevelOuter = bvNone
    Color = 15790320
    ParentBackground = False
    TabOrder = 2
    object BtnAplicar: TBitBtn
      Left = 16
      Top = 12
      Width = 120
      Height = 42
      Caption = 'Aplicar'
      TabOrder = 0
      OnClick = BtnAplicarClick
    end
    object BtnSair: TBitBtn
      Left = 148
      Top = 12
      Width = 100
      Height = 42
      Caption = 'Sair'
      TabOrder = 1
      OnClick = BtnSairClick
    end
  end
  object PanelDados: TPanel
    Left = 0
    Top = 50
    Width = 640
    Height = 304
    Align = alClient
    BevelOuter = bvNone
    Color = 16119285
    ParentBackground = False
    TabOrder = 1
    object PanelLista: TPanel
      Left = 16
      Top = 16
      Width = 280
      Height = 272
      BevelOuter = bvNone
      Color = clWhite
      ParentBackground = False
      TabOrder = 0
      object LabelLista: TLabel
        Left = 12
        Top = 12
        Width = 80
        Height = 17
        Caption = 'Temas'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 16608781
        Font.Height = -13
        Font.Name = 'Segoe UI Semibold'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object ListBoxTemas: TListBox
        Left = 12
        Top = 36
        Width = 256
        Height = 180
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ItemHeight = 17
        ParentFont = False
        TabOrder = 0
        OnClick = ListBoxTemasClick
      end
      object LabelDescricao: TLabel
        Left = 12
        Top = 228
        Width = 256
        Height = 32
        AutoSize = False
        Caption = ''
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 7107956
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
    end
    object PanelPreview: TPanel
      Left = 312
      Top = 16
      Width = 312
      Height = 272
      BevelOuter = bvNone
      Color = clWhite
      ParentBackground = False
      TabOrder = 1
      object LabelPreview: TLabel
        Left = 12
        Top = 12
        Width = 80
        Height = 17
        Caption = 'Amostra'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 16608781
        Font.Height = -13
        Font.Name = 'Segoe UI Semibold'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object PanelAmostraPrimary: TPanel
        Left = 12
        Top = 48
        Width = 288
        Height = 48
        BevelOuter = bvNone
        Color = 16608781
        ParentBackground = False
        TabOrder = 0
      end
      object LabelPrimary: TLabel
        Left = 12
        Top = 100
        Width = 80
        Height = 15
        Caption = 'Primary'
      end
      object PanelAmostraPage: TPanel
        Left = 12
        Top = 124
        Width = 288
        Height = 48
        BevelOuter = bvNone
        Color = 16119285
        ParentBackground = False
        TabOrder = 1
      end
      object LabelPage: TLabel
        Left = 12
        Top = 176
        Width = 80
        Height = 15
        Caption = 'Page'
      end
      object PanelAmostraCard: TPanel
        Left = 12
        Top = 200
        Width = 288
        Height = 48
        BevelOuter = bvNone
        Color = clWhite
        ParentBackground = False
        TabOrder = 2
      end
      object LabelCard: TLabel
        Left = 12
        Top = 252
        Width = 80
        Height = 15
        Caption = 'Card'
      end
    end
  end
end.
