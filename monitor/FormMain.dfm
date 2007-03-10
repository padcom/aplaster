object FrmMain: TFrmMain
  Left = 211
  Top = 168
  Width = 696
  Height = 480
  Caption = 'FrmMain'
  Color = clAppWorkSpace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIForm
  Menu = MainMenu
  OldCreateOrder = False
  Position = poScreenCenter
  WindowMenu = MnuWindow
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar: TStatusBar
    Left = 0
    Top = 415
    Width = 688
    Height = 19
    Panels = <>
  end
  object MainMenu: TMainMenu
    Left = 80
    Top = 64
    object MnuFile: TMenuItem
      Caption = 'MnuFile'
      object MniFileExit: TMenuItem
        Action = ActFileExit
      end
    end
    object MnuWindow: TMenuItem
      Caption = 'MnuWindow'
      object MniWindowTileHorizontal: TMenuItem
        Action = ActWindowTileHorizontal
      end
      object MniWindowTileVertical: TMenuItem
        Action = ActWindowTileVertical
      end
      object MniWindowCascade: TMenuItem
        Action = ActWindowCascade
      end
      object MniMinimizeAll: TMenuItem
        Action = ActWindowMinimizeAll
      end
      object N1: TMenuItem
        Caption = '-'
      end
    end
  end
  object Actions: TActionList
    Left = 48
    Top = 64
    object ActFileExit: TAction
      Category = 'File'
      Caption = 'ActFileExit'
      ShortCut = 32883
      OnExecute = ActFileExitExecute
    end
    object ActWindowCascade: TWindowCascade
      Category = 'Window'
      Caption = 'ActWindowCascade'
      Enabled = False
      ImageIndex = 17
    end
    object ActWindowTileHorizontal: TWindowTileHorizontal
      Category = 'Window'
      Caption = 'ActWindowTileHorizontal'
      Enabled = False
      ImageIndex = 15
    end
    object ActWindowTileVertical: TWindowTileVertical
      Category = 'Window'
      Caption = 'ActWindowTileVertical'
      Enabled = False
      ImageIndex = 16
    end
    object ActWindowMinimizeAll: TWindowMinimizeAll
      Category = 'Window'
      Caption = 'ActWindowMinimizeAll'
      Enabled = False
    end
  end
end
