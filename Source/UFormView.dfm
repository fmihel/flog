object frmView: TfrmView
  Left = 339
  Top = 174
  Caption = 'frmView'
  ClientHeight = 681
  ClientWidth = 744
  Color = clWindow
  Ctl3D = False
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Memo: TMemo
    Left = 0
    Top = 0
    Width = 744
    Height = 681
    Align = alClient
    Color = 1973790
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = 14341071
    Font.Height = -13
    Font.Name = 'Consolas'
    Font.Style = []
    Lines.Strings = (
      
        '[13-Dec-2019 11:50:32 UTC] fmihel\ConvertPdfToImage\ConvertPdfTo' +
        'Image::load Exception: PDFDelegateFailed `'#1053#1077' '#1091#1076#1072#1077#1090#1089#1103' '#1085#1072#1081#1090#1080' '#1091#1082#1072#1079#1072 +
        #1085#1085#1099#1081' '#1092#1072#1081#1083'.'
      #39' @ error/pdf.c/ReadPDFImage/794'
      
        '[13-Dec-2019 11:50:32 UTC] fmihel\ConvertPdfToImage\ConvertPdfTo' +
        'Image::save Exception: PDFDelegateFailed `'#1053#1077' '#1091#1076#1072#1077#1090#1089#1103' '#1085#1072#1081#1090#1080' '#1091#1082#1072#1079#1072 +
        #1085#1085#1099#1081' '#1092#1072#1081#1083'.'
      #39' @ error/pdf.c/ReadPDFImage/794'
      ''
      '12345678'
      'WWwwAA 8')
    ParentFont = False
    PopupMenu = PopupMenu1
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 0
    WordWrap = False
    ExplicitLeft = -8
  end
  object PanelName: TPanel
    Left = 560
    Top = 56
    Width = 137
    Height = 25
    BevelOuter = bvNone
    BorderStyle = bsSingle
    Caption = 'PanelName'
    Color = 1973790
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 16171150
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    ShowCaption = False
    TabOrder = 1
    Visible = False
    object PanelNameText: TLabel
      Left = 6
      Top = 5
      Width = 53
      Height = 13
      Caption = 'PanelName'
    end
  end
  object ActionManager1: TActionManager
    Left = 56
    Top = 192
    StyleName = 'Platform Default'
    object actClose: TAction
      Caption = 'close'
      OnExecute = actCloseExecute
    end
    object actClear: TAction
      Caption = 'clear'
      OnExecute = actClearExecute
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 64
    Top = 88
    object clear1: TMenuItem
      Action = actClear
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object close1: TMenuItem
      Action = actClose
    end
  end
end
