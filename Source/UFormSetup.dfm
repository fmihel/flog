object frmSetup: TfrmSetup
  Left = 894
  Top = 420
  BorderStyle = bsDialog
  Caption = 'Setup'
  ClientHeight = 365
  ClientWidth = 293
  Color = clWindow
  Ctl3D = False
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 11
    Width = 35
    Height = 13
    Caption = 'refresh'
  end
  object cbInterval: TComboBox
    Left = 88
    Top = 8
    Width = 70
    Height = 21
    Style = csDropDownList
    Color = 8678491
    ItemHeight = 13
    ItemIndex = 2
    TabOrder = 0
    Text = '2 sec'
    OnChange = CommonChange
    Items.Strings = (
      'no'
      '1 sec'
      '2 sec'
      '5 sec'
      '10 sec'
      '60 sec')
  end
  object Panel1: TPanel
    Left = 0
    Top = 324
    Width = 293
    Height = 41
    Align = alBottom
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 1
    object Button1: TButton
      Left = 210
      Top = 8
      Width = 75
      Height = 25
      Caption = 'close'
      TabOrder = 0
      OnClick = Button1Click
    end
  end
  object cbTrayOnMinimize: TCheckBox
    Left = 16
    Top = 43
    Width = 142
    Height = 17
    Alignment = taLeftJustify
    Caption = 'tray on minimize'
    TabOrder = 2
    OnClick = CommonChange
  end
  object cbAlwaysOnTop: TCheckBox
    Left = 16
    Top = 66
    Width = 142
    Height = 17
    Alignment = taLeftJustify
    Caption = 'always on top'
    TabOrder = 3
    OnClick = CommonChange
  end
  object cbHideScrollBarOnInActive: TCheckBox
    Left = 16
    Top = 89
    Width = 142
    Height = 17
    Alignment = taLeftJustify
    Caption = 'hide scrollbar on inactive'
    TabOrder = 4
    OnClick = CommonChange
  end
end
