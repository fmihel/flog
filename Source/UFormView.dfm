object frmView: TfrmView
  Left = 816
  Top = 524
  Caption = 'frmView'
  ClientHeight = 269
  ClientWidth = 952
  Color = clBtnFace
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
  PixelsPerInch = 96
  TextHeight = 13
  object Memo: TMemo
    Left = 0
    Top = 0
    Width = 952
    Height = 269
    Align = alClient
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    PopupMenu = PopupMenu1
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 0
    WordWrap = False
    ExplicitLeft = 8
    ExplicitTop = 48
    ExplicitWidth = 905
    ExplicitHeight = 193
  end
  object ActionManager1: TActionManager
    Left = 696
    Top = 24
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
    Left = 576
    Top = 24
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
