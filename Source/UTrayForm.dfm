object frmTray: TfrmTray
  Left = 1446
  Top = 885
  BorderStyle = bsNone
  Caption = 'frmTray'
  ClientHeight = 95
  ClientWidth = 406
  Color = 2565927
  Ctl3D = False
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clSilver
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 406
    Height = 95
    Align = alClient
    BevelOuter = bvNone
    BorderStyle = bsSingle
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 0
    ExplicitLeft = 56
    ExplicitTop = 24
    ExplicitWidth = 505
    ExplicitHeight = 241
    DesignSize = (
      404
      93)
    object SpeedButton8: TSpeedButton
      Left = 373
      Top = 2
      Width = 30
      Height = 30
      Cursor = crArrow
      Anchors = [akTop, akRight]
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Glyph.Data = {
        36040000424D3604000000000000360000002800000010000000100000000100
        2000000000000004000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        000000000000F2C5A3FF00000000000000000000000000000000000000000000
        00000000000000000000F2C5A3FF000000000000000000000000000000000000
        00000000000000000000F2C5A3FF000000000000000000000000000000000000
        000000000000F2C5A3FF00000000000000000000000000000000000000000000
        0000000000000000000000000000F2C5A3FF0000000000000000000000000000
        0000F2C5A3FF0000000000000000000000000000000000000000000000000000
        000000000000000000000000000000000000F2C5A3FF0000000000000000F2C5
        A3FF000000000000000000000000000000000000000000000000000000000000
        00000000000000000000000000000000000000000000F2C5A3FFF2C5A3FF0000
        0000000000000000000000000000000000000000000000000000000000000000
        00000000000000000000000000000000000000000000F2C5A3FFF2C5A3FF0000
        0000000000000000000000000000000000000000000000000000000000000000
        000000000000000000000000000000000000F2C5A3FF0000000000000000F2C5
        A3FF000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000F2C5A3FF0000000000000000000000000000
        0000F2C5A3FF0000000000000000000000000000000000000000000000000000
        00000000000000000000F2C5A3FF000000000000000000000000000000000000
        000000000000F2C5A3FF00000000000000000000000000000000000000000000
        000000000000F2C5A3FF00000000000000000000000000000000000000000000
        00000000000000000000F2C5A3FF000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000}
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      OnClick = SpeedButton8Click
      ExplicitLeft = 472
    end
    object Memo1: TMemo
      Left = 7
      Top = 5
      Width = 363
      Height = 82
      Anchors = [akLeft, akTop, akRight, akBottom]
      BorderStyle = bsNone
      Color = 2565927
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      Lines.Strings = (
        'Memo1')
      ParentCtl3D = False
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
      WordWrap = False
      OnClick = Memo1Click
      OnDblClick = Memo1DblClick
      ExplicitWidth = 462
      ExplicitHeight = 228
    end
  end
  object Timer1: TTimer
    Interval = 5000
    OnTimer = Timer1Timer
    Left = 80
    Top = 32
  end
end
