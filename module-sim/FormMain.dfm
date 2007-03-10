object FrmMain: TFrmMain
  Left = 159
  Top = 155
  BorderStyle = bsDialog
  Caption = 'FrmMain'
  ClientHeight = 482
  ClientWidth = 559
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object GbxAnalogInput: TGroupBox
    Left = 8
    Top = 8
    Width = 89
    Height = 465
    Caption = 'GbxAnalogInput'
    TabOrder = 0
    object LblAN0: TLabel
      Left = 16
      Top = 16
      Width = 21
      Height = 13
      Caption = 'AN0'
    end
    object LblAN1: TLabel
      Left = 48
      Top = 16
      Width = 21
      Height = 13
      Caption = 'AN1'
    end
    object AN0: TTrackBar
      Left = 16
      Top = 32
      Width = 25
      Height = 425
      Max = 1023
      Orientation = trVertical
      Position = 512
      TabOrder = 0
      TickMarks = tmBoth
      TickStyle = tsNone
      OnChange = AN0Change
    end
    object AN1: TTrackBar
      Left = 48
      Top = 32
      Width = 25
      Height = 425
      Max = 1023
      Orientation = trVertical
      Position = 512
      TabOrder = 1
      TickMarks = tmBoth
      TickStyle = tsNone
      OnChange = AN1Change
    end
  end
  object GbxDigitalInput: TGroupBox
    Left = 104
    Top = 8
    Width = 329
    Height = 57
    Caption = 'GbxDigitalInput'
    TabOrder = 1
    object DI0: TSpeedButton
      Left = 8
      Top = 24
      Width = 33
      Height = 22
      AllowAllUp = True
      GroupIndex = 1
      Caption = 'DI0'
      OnClick = DI0Click
    end
    object DI1: TSpeedButton
      Left = 48
      Top = 24
      Width = 33
      Height = 22
      AllowAllUp = True
      GroupIndex = 2
      Caption = 'DI1'
      OnClick = DI1Click
    end
    object DI2: TSpeedButton
      Left = 88
      Top = 24
      Width = 33
      Height = 22
      AllowAllUp = True
      GroupIndex = 3
      Caption = 'DI2'
      OnClick = DI2Click
    end
    object DI3: TSpeedButton
      Left = 128
      Top = 24
      Width = 33
      Height = 22
      AllowAllUp = True
      GroupIndex = 4
      Caption = 'DI3'
      OnClick = DI3Click
    end
    object DI4: TSpeedButton
      Left = 168
      Top = 24
      Width = 33
      Height = 22
      AllowAllUp = True
      GroupIndex = 5
      Caption = 'DI4'
      OnClick = DI4Click
    end
    object DI5: TSpeedButton
      Left = 208
      Top = 24
      Width = 33
      Height = 22
      AllowAllUp = True
      GroupIndex = 6
      Caption = 'DI5'
      OnClick = DI5Click
    end
    object DI6: TSpeedButton
      Left = 248
      Top = 24
      Width = 33
      Height = 22
      AllowAllUp = True
      GroupIndex = 7
      Caption = 'DI6'
      OnClick = DI6Click
    end
    object DI7: TSpeedButton
      Left = 288
      Top = 24
      Width = 33
      Height = 22
      AllowAllUp = True
      GroupIndex = 8
      Caption = 'DI7'
      OnClick = DI7Click
    end
  end
  object GbxDigitalOutput: TGroupBox
    Left = 104
    Top = 72
    Width = 329
    Height = 57
    Caption = 'GbxDigitalOutput'
    TabOrder = 2
    object DO0: TSpeedButton
      Left = 8
      Top = 24
      Width = 33
      Height = 22
      AllowAllUp = True
      GroupIndex = 9
      Caption = 'DO0'
    end
    object DO1: TSpeedButton
      Left = 48
      Top = 24
      Width = 33
      Height = 22
      AllowAllUp = True
      GroupIndex = 10
      Caption = 'DO1'
    end
    object DO2: TSpeedButton
      Left = 88
      Top = 24
      Width = 33
      Height = 22
      AllowAllUp = True
      GroupIndex = 11
      Caption = 'DO2'
    end
    object DO3: TSpeedButton
      Left = 128
      Top = 24
      Width = 33
      Height = 22
      AllowAllUp = True
      GroupIndex = 12
      Caption = 'DO3'
    end
    object DO4: TSpeedButton
      Left = 168
      Top = 24
      Width = 33
      Height = 22
      AllowAllUp = True
      GroupIndex = 13
      Caption = 'DO4'
    end
    object DO5: TSpeedButton
      Left = 208
      Top = 24
      Width = 33
      Height = 22
      AllowAllUp = True
      GroupIndex = 14
      Caption = 'DO5'
    end
  end
  object GbxRelay: TGroupBox
    Left = 104
    Top = 136
    Width = 329
    Height = 57
    Caption = 'GbxRelay'
    TabOrder = 3
    object RE0: TSpeedButton
      Left = 8
      Top = 24
      Width = 33
      Height = 22
      AllowAllUp = True
      GroupIndex = 15
      Caption = 'RE0'
    end
    object RE1: TSpeedButton
      Left = 48
      Top = 24
      Width = 33
      Height = 22
      AllowAllUp = True
      GroupIndex = 16
      Caption = 'RE1'
    end
    object RE2: TSpeedButton
      Left = 88
      Top = 24
      Width = 33
      Height = 22
      AllowAllUp = True
      GroupIndex = 17
      Caption = 'RE2'
    end
  end
  object GbxWiegand: TGroupBox
    Left = 104
    Top = 200
    Width = 329
    Height = 121
    Caption = 'GbxWiegand'
    TabOrder = 4
    object Wiegand0Send: TSpeedButton
      Left = 280
      Top = 40
      Width = 41
      Height = 21
      OnClick = Wiegand0SendClick
    end
    object Wiegand1Send: TSpeedButton
      Left = 280
      Top = 88
      Width = 41
      Height = 21
      OnClick = Wiegand1SendClick
    end
    object LblWiegand0: TLabel
      Left = 8
      Top = 24
      Width = 58
      Height = 13
      Caption = 'WIEGAND0'
    end
    object LblWiegand1: TLabel
      Left = 8
      Top = 72
      Width = 58
      Height = 13
      Caption = 'WIEGAND1'
    end
    object WIEGAND0: TEdit
      Left = 8
      Top = 40
      Width = 265
      Height = 21
      TabOrder = 0
      Text = 'WIEGAND0'
    end
    object WIEGAND1: TEdit
      Left = 8
      Top = 88
      Width = 265
      Height = 21
      TabOrder = 1
      Text = 'WIEGAND1'
    end
  end
  object GbxRS232: TGroupBox
    Left = 104
    Top = 328
    Width = 329
    Height = 73
    Caption = 'GbxRS232'
    TabOrder = 5
    object RS2320Send: TSpeedButton
      Left = 280
      Top = 40
      Width = 41
      Height = 21
      OnClick = RS2320SendClick
    end
    object LblRS2320: TLabel
      Left = 8
      Top = 24
      Width = 39
      Height = 13
      Caption = 'RS2320'
    end
    object RS2320: TEdit
      Left = 8
      Top = 40
      Width = 265
      Height = 21
      TabOrder = 0
      Text = 'RS2320'
    end
  end
  object GbxMotor: TRadioGroup
    Left = 104
    Top = 408
    Width = 329
    Height = 65
    Caption = 'GbxMotor'
    ItemIndex = 1
    Items.Strings = (
      'Left'
      'Stop'
      'Right')
    TabOrder = 6
  end
  object BtnDebug1: TButton
    Left = 456
    Top = 16
    Width = 75
    Height = 25
    Caption = 'BtnDebug1'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 7
    OnClick = BtnDebug1Click
  end
  object BtnDebug2: TButton
    Left = 456
    Top = 48
    Width = 75
    Height = 25
    Caption = 'BtnDebug2'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 8
    OnClick = BtnDebug2Click
  end
  object BtnDebug3: TButton
    Left = 456
    Top = 96
    Width = 75
    Height = 25
    Caption = 'BtnDebug3'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 9
    OnClick = BtnDebug3Click
  end
  object BtnDebug4: TButton
    Left = 456
    Top = 128
    Width = 75
    Height = 25
    Caption = 'BtnDebug4'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 10
    OnClick = BtnDebug4Click
  end
  object BtnDebug5: TButton
    Left = 456
    Top = 176
    Width = 75
    Height = 25
    Caption = 'BtnDebug5'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 11
    OnClick = BtnDebug5Click
  end
  object BtnDebug6: TButton
    Left = 456
    Top = 208
    Width = 75
    Height = 25
    Caption = 'BtnDebug6'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 12
    OnClick = BtnDebug6Click
  end
end
