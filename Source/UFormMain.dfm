object frmMain: TfrmMain
  Left = 951
  Top = 96
  Caption = 'flog'
  ClientHeight = 548
  ClientWidth = 855
  Color = clAppWorkSpace
  Ctl3D = False
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIForm
  OldCreateOrder = False
  Scaled = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 855
    Height = 27
    Align = alTop
    BevelOuter = bvNone
    Caption = 'Panel1'
    Color = 4142124
    ParentBackground = False
    ShowCaption = False
    TabOrder = 0
    DesignSize = (
      855
      27)
    object SpeedButton1: TSpeedButton
      Left = 8
      Top = 4
      Width = 41
      Height = 20
      Action = actAdd
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object SpeedButton2: TSpeedButton
      Left = 808
      Top = 4
      Width = 41
      Height = 20
      Action = actGoToTray
      Anchors = [akTop, akRight]
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object ComboBox1: TComboBox
      Left = 68
      Top = 4
      Width = 101
      Height = 21
      Style = csDropDownList
      Color = 8678491
      ItemHeight = 13
      ItemIndex = 1
      TabOrder = 0
      Text = 'refresh: 2 sec'
      OnChange = ComboBox1Change
      Items.Strings = (
        'refresh: no'
        'refresh: 2 sec'
        'refresh: 5 sec'
        'refresh: 10 sec'
        'refresh: 60 sec')
    end
    object ComboBox2: TComboBox
      Left = 175
      Top = 4
      Width = 106
      Height = 21
      Style = csDropDownList
      Color = 8678491
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 1
      Text = 'place: cascade'
      OnChange = ComboBox2Change
      Items.Strings = (
        'place: cascade'
        'place: vert'
        'place: horiz')
    end
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 184
    Top = 80
  end
  object ActionManager1: TActionManager
    Left = 72
    Top = 80
    StyleName = 'Platform Default'
    object actAdd: TAction
      Caption = 'add'
      OnExecute = actAddExecute
    end
    object actReturnFromTray: TAction
      Caption = 'show'
      OnExecute = actReturnFromTrayExecute
    end
    object actGoToTray: TAction
      Caption = 'tray'
      OnExecute = actGoToTrayExecute
    end
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'log'
    Filter = 'log|*.log|all|*.*'
    FilterIndex = 0
    Options = [ofHideReadOnly, ofFileMustExist, ofEnableSizing]
    Left = 272
    Top = 80
  end
  object TrayIcon1: TTrayIcon
    AnimateInterval = 0
    BalloonTimeout = 1000
    BalloonFlags = bfWarning
    Icon.Data = {
      0000010001001010000001002000680400001600000028000000100000002000
      0000010020000000000040040000000000000000000000000000000000001108
      02FF110802FF110802FF110802FF110802FF110802FF110802FF110802FF1108
      02FF110802FF110802FF110802FF110802FF110802FF110802FF110802FF1108
      02FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF110802FF1108
      02FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF110802FF1108
      02FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF110802FFF2C5
      A3FFF2C5A3FFF2C5A3FFF2C5A3FFF2C5A3FFF2C5A3FF000000FF000000FF0000
      00FF000000FFF2C5A3FFF2C5A3FFF2C5A3FFF2C5A3FFF2C5A3FFF2C5A3FF1108
      02FF000000FF000000FF000000FF000000FFF2C5A3FF000000FF000000FF0000
      00FF000000FFF2C5A3FF000000FF000000FF000000FF000000FF110802FF1108
      02FF000000FF000000FF000000FF000000FFF2C5A3FF000000FF000000FF0000
      00FF000000FFF2C5A3FF000000FF000000FF000000FF000000FF110802FF1108
      02FF000000FF000000FF000000FF000000FFF2C5A3FF000000FF000000FF0000
      00FF000000FFF2C5A3FF000000FF000000FF000000FF000000FF110802FF1108
      02FF000000FF000000FFF2C5A3FFF2C5A3FFF2C5A3FFF2C5A3FFF2C5A3FF0000
      00FF000000FFF2C5A3FF000000FF000000FF000000FF000000FF110802FF1108
      02FF000000FF000000FF000000FF000000FFF2C5A3FF000000FF000000FF0000
      00FF000000FFF2C5A3FF000000FF000000FF000000FF000000FF110802FF1108
      02FF000000FF000000FF000000FF000000FFF2C5A3FF000000FF000000FF0000
      00FF000000FFF2C5A3FF000000FF000000FF000000FF000000FF110802FF1108
      02FF000000FF000000FF000000FF000000FFF2C5A3FF000000FF000000FF0000
      00FF000000FFF2C5A3FF000000FF000000FF000000FF000000FF110802FF1108
      02FF000000FF000000FF000000FF000000FFF2C5A3FFF2C5A3FFF2C5A3FFF2C5
      A3FFF2C5A3FFF2C5A3FF000000FF000000FF000000FF000000FF110802FF1108
      02FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF110802FF1108
      02FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF110802FF1108
      02FF110802FF110802FF110802FF110802FF110802FF110802FF110802FF1108
      02FF110802FF110802FF110802FF110802FF110802FF110802FF110802FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000}
    PopupMenu = PopupMenu1
    OnBalloonClick = actReturnFromTrayExecute
    OnClick = actReturnFromTrayExecute
    Left = 448
    Top = 88
  end
  object PopupMenu1: TPopupMenu
    Left = 536
    Top = 88
    object show1: TMenuItem
      Action = actReturnFromTray
    end
  end
end
