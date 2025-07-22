object frmSetup: TfrmSetup
  Left = 1046
  Top = 277
  BorderStyle = bsDialog
  Caption = 'Setup'
  ClientHeight = 303
  ClientWidth = 256
  Color = clGray
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
  DesignSize = (
    256
    303)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 11
    Width = 35
    Height = 13
    Caption = 'refresh'
  end
  object Label2: TLabel
    Left = 16
    Top = 115
    Width = 69
    Height = 13
    Caption = 'clear after idle'
  end
  object cbInterval: TComboBox
    Left = 88
    Top = 8
    Width = 70
    Height = 21
    Style = csDropDownList
    Color = clGray
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
    Top = 262
    Width = 256
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    BorderStyle = bsSingle
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 1
    ExplicitTop = 338
    object Button1: TButton
      Left = 170
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
    Top = 35
    Width = 142
    Height = 17
    Alignment = taLeftJustify
    Caption = 'tray on minimize'
    TabOrder = 2
    OnClick = CommonChange
  end
  object cbAlwaysOnTop: TCheckBox
    Left = 16
    Top = 58
    Width = 142
    Height = 17
    Alignment = taLeftJustify
    Caption = 'always on top'
    TabOrder = 3
    OnClick = CommonChange
  end
  object cbHideScrollBarOnInActive: TCheckBox
    Left = 16
    Top = 81
    Width = 142
    Height = 17
    Alignment = taLeftJustify
    Caption = 'hide scrollbar on inactive'
    TabOrder = 4
    OnClick = CommonChange
  end
  object cbClearOnIdle: TComboBox
    Left = 91
    Top = 112
    Width = 70
    Height = 21
    Style = csDropDownList
    Color = clGray
    ItemHeight = 13
    TabOrder = 5
    OnChange = CommonChange
    Items.Strings = (
      'none'
      '1 sec'
      '2 sec'
      '5 sec'
      '10 sec'
      '15 sec'
      '20 sec'
      '30 sec'
      '1 min'
      '2 min'
      '5 min'
      '10 min')
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 162
    Width = 240
    Height = 102
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Tray out crop'
    TabOrder = 6
    Visible = False
    object Label4: TLabel
      Left = 13
      Top = 23
      Width = 33
      Height = 13
      Caption = 'out len'
    end
    object Label3: TLabel
      Left = 13
      Top = 57
      Width = 54
      Height = 13
      Caption = 'filter match'
    end
    object seTrayOutLen: TSpinEdit
      Left = 83
      Top = 21
      Width = 70
      Height = 22
      MaxValue = 255
      MinValue = 0
      TabOrder = 0
      Value = 0
      OnChange = CommonChange
    end
    object edTrayOutFilter: TEdit
      Left = 83
      Top = 54
      Width = 126
      Height = 19
      TabOrder = 1
      Text = 'edTrayOutFilter'
      OnChange = CommonChange
    end
  end
  object cbTraySystem: TCheckBox
    Left = 19
    Top = 139
    Width = 142
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Use system tray'
    TabOrder = 7
    OnClick = CommonChange
  end
end
