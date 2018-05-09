object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'Demo form'
  ClientHeight = 51
  ClientWidth = 447
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lbResult: TLabel
    Left = 8
    Top = 30
    Width = 8
    Height = 13
    Caption = '..'
  end
  object edTemplate: TEdit
    Left = 8
    Top = 8
    Width = 321
    Height = 21
    TabOrder = 0
  end
  object btnApply: TButton
    Left = 364
    Top = 8
    Width = 75
    Height = 25
    Align = alCustom
    Anchors = [akTop, akRight]
    Caption = 'Apply'
    TabOrder = 1
    OnClick = btnApplyClick
  end
end
