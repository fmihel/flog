object frmSetup: TfrmSetup
  Left = 1182
  Top = 306
  Caption = 'Setup'
  ClientHeight = 562
  ClientWidth = 429
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 31
    Width = 35
    Height = 13
    Caption = 'refresh'
  end
  object ComboBox1: TComboBox
    Left = 65
    Top = 28
    Width = 101
    Height = 21
    Style = csDropDownList
    Color = 8678491
    ItemHeight = 13
    ItemIndex = 1
    TabOrder = 0
    Text = 'refresh: 2 sec'
    Items.Strings = (
      'refresh: no'
      'refresh: 2 sec'
      'refresh: 5 sec'
      'refresh: 10 sec'
      'refresh: 60 sec')
  end
  object ComboBox2: TComboBox
    Left = 65
    Top = 68
    Width = 106
    Height = 21
    Style = csDropDownList
    Color = 8678491
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 1
    Text = 'place: cascade'
    Items.Strings = (
      'place: cascade'
      'place: vert'
      'place: horiz')
  end
end
