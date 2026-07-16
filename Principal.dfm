object Form_Principal: TForm_Principal
  Left = 0
  Top = 0
  Caption = 'Ganso Sistemas - Sistema de Gerenciamento de Retaguarda'
  ClientHeight = 668
  ClientWidth = 1024
  Color = 16448248
  Constraints.MinHeight = 560
  Constraints.MinWidth = 900
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  FormStyle = fsMDIForm
  Position = poDesktopCenter
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 15
  object Panel_Titulo: TPanel
    Left = 0
    Top = 0
    Width = 1024
    Height = 60
    Align = alTop
    BevelOuter = bvNone
    Caption = 'GANSO SISTEMAS  -  Sistema de Gerenciamento de Retaguarda'
    Color = 10579725
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -21
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 0
  end
  object PanelSidebar: TPanel
    Left = 0
    Top = 60
    Width = 240
    Height = 584
    Align = alLeft
    BevelOuter = bvNone
    Color = 3683871
    ParentBackground = False
    TabOrder = 1
    object PanelSidebarHeader: TPanel
      Left = 0
      Top = 0
      Width = 240
      Height = 60
      Align = alTop
      BevelOuter = bvNone
      Color = 2500129
      ParentBackground = False
      TabOrder = 0
      OnClick = ActToggleSidebarExecute
      object LabelIconeToggle: TLabel
        Left = 16
        Top = 18
        Width = 24
        Height = 24
        Cursor = crHandPoint
        Alignment = taCenter
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -20
        Font.Name = 'Segoe MDL2 Assets'
        Font.Style = []
        ParentFont = False
        Transparent = True
        Layout = tlCenter
        OnClick = ActToggleSidebarExecute
      end
      object LabelTituloSidebar: TLabel
        Left = 56
        Top = 18
        Width = 168
        Height = 24
        Cursor = crHandPoint
        AutoSize = False
        Caption = 'Ganso Sistemas'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -15
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
        Layout = tlCenter
        OnClick = ActToggleSidebarExecute
      end
    end
    object PanelItemSair: TPanel
      Left = 0
      Top = 536
      Width = 240
      Height = 48
      Align = alBottom
      BevelOuter = bvNone
      Color = 3683871
      ParentBackground = False
      TabOrder = 1
      OnClick = ActSairExecute
      OnMouseEnter = ItemMouseEnter
      OnMouseLeave = ItemMouseLeave
      object LabelIconeSair: TLabel
        Left = 16
        Top = 12
        Width = 24
        Height = 24
        Cursor = crHandPoint
        Alignment = taCenter
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -20
        Font.Name = 'Segoe MDL2 Assets'
        Font.Style = []
        ParentFont = False
        Transparent = True
        Layout = tlCenter
        OnClick = ActSairExecute
        OnMouseEnter = ItemMouseEnter
        OnMouseLeave = ItemMouseLeave
      end
      object LabelTextoSair: TLabel
        Left = 56
        Top = 12
        Width = 168
        Height = 24
        Cursor = crHandPoint
        AutoSize = False
        Caption = 'Sair'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
        Layout = tlCenter
        OnClick = ActSairExecute
        OnMouseEnter = ItemMouseEnter
        OnMouseLeave = ItemMouseLeave
      end
    end
    object PanelItemSobre: TPanel
      Left = 0
      Top = 488
      Width = 240
      Height = 48
      Align = alBottom
      BevelOuter = bvNone
      Color = 3683871
      ParentBackground = False
      TabOrder = 2
      OnClick = ActSobreExecute
      OnMouseEnter = ItemMouseEnter
      OnMouseLeave = ItemMouseLeave
      object LabelIconeSobre: TLabel
        Left = 16
        Top = 12
        Width = 24
        Height = 24
        Cursor = crHandPoint
        Alignment = taCenter
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -20
        Font.Name = 'Segoe MDL2 Assets'
        Font.Style = []
        ParentFont = False
        Transparent = True
        Layout = tlCenter
        OnClick = ActSobreExecute
        OnMouseEnter = ItemMouseEnter
        OnMouseLeave = ItemMouseLeave
      end
      object LabelTextoSobre: TLabel
        Left = 56
        Top = 12
        Width = 168
        Height = 24
        Cursor = crHandPoint
        AutoSize = False
        Caption = 'Sobre'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
        Layout = tlCenter
        OnClick = ActSobreExecute
        OnMouseEnter = ItemMouseEnter
        OnMouseLeave = ItemMouseLeave
      end
    end
    object PanelItemClientes: TPanel
      Left = 0
      Top = 76
      Width = 240
      Height = 48
      BevelOuter = bvNone
      Color = 3683871
      ParentBackground = False
      TabOrder = 3
      OnClick = ActClientesExecute
      OnMouseEnter = ItemMouseEnter
      OnMouseLeave = ItemMouseLeave
      object LabelIconeClientes: TLabel
        Left = 16
        Top = 12
        Width = 24
        Height = 24
        Cursor = crHandPoint
        Alignment = taCenter
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -20
        Font.Name = 'Segoe MDL2 Assets'
        Font.Style = []
        ParentFont = False
        Transparent = True
        Layout = tlCenter
        OnClick = ActClientesExecute
        OnMouseEnter = ItemMouseEnter
        OnMouseLeave = ItemMouseLeave
      end
      object LabelTextoClientes: TLabel
        Left = 56
        Top = 12
        Width = 168
        Height = 24
        Cursor = crHandPoint
        AutoSize = False
        Caption = 'Clientes'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
        Layout = tlCenter
        OnClick = ActClientesExecute
        OnMouseEnter = ItemMouseEnter
        OnMouseLeave = ItemMouseLeave
      end
    end
    object PanelItemProdutos: TPanel
      Left = 0
      Top = 124
      Width = 240
      Height = 48
      BevelOuter = bvNone
      Color = 3683871
      ParentBackground = False
      TabOrder = 4
      OnClick = ActProdutosExecute
      OnMouseEnter = ItemMouseEnter
      OnMouseLeave = ItemMouseLeave
      object LabelIconeProdutos: TLabel
        Left = 16
        Top = 12
        Width = 24
        Height = 24
        Cursor = crHandPoint
        Alignment = taCenter
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -20
        Font.Name = 'Segoe MDL2 Assets'
        Font.Style = []
        ParentFont = False
        Transparent = True
        Layout = tlCenter
        OnClick = ActProdutosExecute
        OnMouseEnter = ItemMouseEnter
        OnMouseLeave = ItemMouseLeave
      end
      object LabelTextoProdutos: TLabel
        Left = 56
        Top = 12
        Width = 168
        Height = 24
        Cursor = crHandPoint
        AutoSize = False
        Caption = 'Produtos'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
        Layout = tlCenter
        OnClick = ActProdutosExecute
        OnMouseEnter = ItemMouseEnter
        OnMouseLeave = ItemMouseLeave
      end
    end
    object PanelItemVendas: TPanel
      Left = 0
      Top = 172
      Width = 240
      Height = 48
      BevelOuter = bvNone
      Color = 3683871
      ParentBackground = False
      TabOrder = 5
      OnClick = ActVendasExecute
      OnMouseEnter = ItemMouseEnter
      OnMouseLeave = ItemMouseLeave
      object LabelIconeVendas: TLabel
        Left = 16
        Top = 12
        Width = 24
        Height = 24
        Cursor = crHandPoint
        Alignment = taCenter
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -20
        Font.Name = 'Segoe MDL2 Assets'
        Font.Style = []
        ParentFont = False
        Transparent = True
        Layout = tlCenter
        OnClick = ActVendasExecute
        OnMouseEnter = ItemMouseEnter
        OnMouseLeave = ItemMouseLeave
      end
      object LabelTextoVendas: TLabel
        Left = 56
        Top = 12
        Width = 168
        Height = 24
        Cursor = crHandPoint
        AutoSize = False
        Caption = 'Vendas'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
        Layout = tlCenter
        OnClick = ActVendasExecute
        OnMouseEnter = ItemMouseEnter
        OnMouseLeave = ItemMouseLeave
      end
    end
    object PanelItemRelatorios: TPanel
      Left = 0
      Top = 220
      Width = 240
      Height = 48
      BevelOuter = bvNone
      Color = 3683871
      ParentBackground = False
      TabOrder = 6
      OnClick = ActRelatoriosExecute
      OnMouseEnter = ItemMouseEnter
      OnMouseLeave = ItemMouseLeave
      object LabelIconeRelatorios: TLabel
        Left = 16
        Top = 12
        Width = 24
        Height = 24
        Cursor = crHandPoint
        Alignment = taCenter
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -20
        Font.Name = 'Segoe MDL2 Assets'
        Font.Style = []
        ParentFont = False
        Transparent = True
        Layout = tlCenter
        OnClick = ActRelatoriosExecute
        OnMouseEnter = ItemMouseEnter
        OnMouseLeave = ItemMouseLeave
      end
      object LabelTextoRelatorios: TLabel
        Left = 56
        Top = 12
        Width = 168
        Height = 24
        Cursor = crHandPoint
        AutoSize = False
        Caption = 'Relat'#243'rios'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
        Layout = tlCenter
        OnClick = ActRelatoriosExecute
        OnMouseEnter = ItemMouseEnter
        OnMouseLeave = ItemMouseLeave
      end
    end
    object PanelItemUtilitarios: TPanel
      Left = 0
      Top = 268
      Width = 240
      Height = 48
      BevelOuter = bvNone
      Color = 3683871
      ParentBackground = False
      TabOrder = 8
      OnClick = ActUtilitariosExecute
      OnMouseEnter = ItemMouseEnter
      OnMouseLeave = ItemMouseLeave
      object LabelIconeUtilitarios: TLabel
        Left = 16
        Top = 12
        Width = 24
        Height = 24
        Cursor = crHandPoint
        Alignment = taCenter
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -20
        Font.Name = 'Segoe MDL2 Assets'
        Font.Style = []
        ParentFont = False
        Transparent = True
        Layout = tlCenter
        OnClick = ActUtilitariosExecute
        OnMouseEnter = ItemMouseEnter
        OnMouseLeave = ItemMouseLeave
      end
      object LabelTextoUtilitarios: TLabel
        Left = 56
        Top = 12
        Width = 168
        Height = 24
        Cursor = crHandPoint
        AutoSize = False
        Caption = 'Utilit'#225'rios'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
        Layout = tlCenter
        OnClick = ActUtilitariosExecute
        OnMouseEnter = ItemMouseEnter
        OnMouseLeave = ItemMouseLeave
      end
    end
    object PanelSeparador: TPanel
      Left = 0
      Top = 60
      Width = 240
      Height = 16
      Align = alTop
      BevelOuter = bvNone
      Color = 3683871
      ParentBackground = False
      TabOrder = 7
    end
  end
  object StatusBarPrincipal: TStatusBar
    Left = 0
    Top = 644
    Width = 1024
    Height = 24
    Panels = <
      item
        Text = 'Ganso Sistemas'
        Width = 180
      end
      item
        Alignment = taCenter
        Text = 'Sistema de Gerenciamento de Retaguarda'
        Width = 340
      end
      item
        Alignment = taCenter
        Text = 'Versao 2.0.0.1'
        Width = 140
      end
      item
        Text = 'Usuario:'
        Width = 260
      end
      item
        Alignment = taRightJustify
        Width = 50
      end>
  end
  object TimerRelogio: TTimer
    OnTimer = TimerRelogioTimer
    Left = 640
    Top = 240
  end
  object TimerSidebar: TTimer
    Enabled = False
    Interval = 12
    OnTimer = TimerSidebarTimer
    Left = 720
    Top = 240
  end
  object ActionListPrincipal: TActionList
    Left = 560
    Top = 240
    object ActClientes: TAction
      Caption = 'Clientes'
      ShortCut = 16460
      OnExecute = ActClientesExecute
    end
    object ActProdutos: TAction
      Caption = 'Produtos'
      ShortCut = 16464
      OnExecute = ActProdutosExecute
    end
    object ActVendas: TAction
      Caption = 'Vendas'
      ShortCut = 16470
      OnExecute = ActVendasExecute
    end
    object ActRelatorios: TAction
      Caption = 'Relat'#243'rios'
      ShortCut = 16466
      OnExecute = ActRelatoriosExecute
    end
    object ActUtilitarios: TAction
      Caption = 'Utilit'#225'rios'
      OnExecute = ActUtilitariosExecute
    end
    object ActSobre: TAction
      Caption = 'Sobre'
      ShortCut = 112
      OnExecute = ActSobreExecute
    end
    object ActSair: TAction
      Caption = 'Sair'
      ShortCut = 16465
      OnExecute = ActSairExecute
    end
    object ActToggleSidebar: TAction
      Caption = 'Alternar Menu Lateral'
      ShortCut = 16450
      OnExecute = ActToggleSidebarExecute
    end
  end
  object PopupMenuRelatorios: TPopupMenu
    Left = 560
    Top = 300
    object MenuItemRelClientes: TMenuItem
      Caption = 'Relat'#243'rio de Clientes'
      OnClick = MenuItemRelClientesClick
    end
    object MenuItemRelProdutos: TMenuItem
      Caption = 'Relat'#243'rio de Produtos'
      OnClick = MenuItemRelProdutosClick
    end
    object MenuItemRelTabelaPrecos: TMenuItem
      Caption = 'Relat'#243'rio de Tabela de Pre'#231'os'
      OnClick = MenuItemRelTabelaPrecosClick
    end
    object MenuItemRelLucratividade: TMenuItem
      Caption = 'Relat'#243'rio de Lucratividade'
      OnClick = MenuItemRelLucratividadeClick
    end
    object MenuItemRelVendas: TMenuItem
      Caption = 'Relat'#243'rio de Vendas Sint'#233'tico'
      OnClick = MenuItemRelVendasClick
    end
    object MenuItemRelVendasAnalitico: TMenuItem
      Caption = 'Relat'#243'rio de Vendas Anal'#237'tico'
      OnClick = MenuItemRelVendasAnaliticoClick
    end
    object MenuItemRelVendasCliente: TMenuItem
      Caption = 'Relat'#243'rio de Vendas por Cliente'
      OnClick = MenuItemRelVendasClienteClick
    end
    object MenuItemRelVendasProduto: TMenuItem
      Caption = 'Relat'#243'rio de Vendas por Produto'
      OnClick = MenuItemRelVendasProdutoClick
    end
    object MenuItemRelVendasSinteticaCliente: TMenuItem
      Caption = 'Relat'#243'rio de Venda Sint'#233'tica por Cliente'
      OnClick = MenuItemRelVendasSinteticaClienteClick
    end
    object MenuItemRelVendasClienteGrade: TMenuItem
      Caption = 'Relat'#243'rio de Venda Cliente (Grade)'
      OnClick = MenuItemRelVendasClienteGradeClick
    end
    object MenuItemEtiquetaProduto: TMenuItem
      Caption = 'Etiquetas de Produto (G'#244'ndola)'
      OnClick = MenuItemEtiquetaProdutoClick
    end
    object MenuItemEtiquetaCliente: TMenuItem
      Caption = 'Etiquetas de Cliente (3 Colunas)'
      OnClick = MenuItemEtiquetaClienteClick
    end
  end
  object PopupMenuUtilitarios: TPopupMenu
    Left = 640
    Top = 300
    object MenuItemUsuarios: TMenuItem
      Caption = 'Usu'#225'rios'
      OnClick = MenuItemUsuariosClick
    end
    object MenuItemTemas: TMenuItem
      Caption = 'Temas'
      OnClick = MenuItemTemasClick
    end
  end
end
