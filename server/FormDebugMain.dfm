object FrmDebugMain: TFrmDebugMain
  Left = 139
  Top = 151
  Width = 848
  Height = 547
  Caption = 'FrmMain'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter: TSplitter
    Left = 0
    Top = 304
    Width = 840
    Height = 4
    Cursor = crVSplit
    Align = alBottom
  end
  object EdtCode: TSynEdit
    Left = 0
    Top = 0
    Width = 840
    Height = 304
    Align = alClient
    Color = clNavy
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Fixedsys'
    Font.Style = []
    TabOrder = 0
    Gutter.Font.Charset = DEFAULT_CHARSET
    Gutter.Font.Color = clWindowText
    Gutter.Font.Height = -11
    Gutter.Font.Name = 'Courier New'
    Gutter.Font.Style = []
    Highlighter = HltPascal
    ReadOnly = True
    RightEdgeColor = clNavy
    SelectedColor.Background = clSilver
    SelectedColor.Foreground = clNavy
    OnSpecialLineColors = EdtCodeSpecialLineColors
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 501
    Width = 840
    Height = 19
    Panels = <>
  end
  object PgcDebugTools: TPageControl
    Left = 0
    Top = 308
    Width = 840
    Height = 193
    ActivePage = TbsDebugTree
    Align = alBottom
    TabOrder = 2
    object TbsDebugTree: TTabSheet
      Caption = 'TbsDebugTree'
      object TrvNetworkStatus: TTreeView
        Left = 0
        Top = 0
        Width = 832
        Height = 165
        Align = alClient
        Images = FrmMain.ImlIcons
        Indent = 19
        TabOrder = 0
        OnCustomDrawItem = TrvNetworkStatusCustomDrawItem
      end
    end
  end
  object Actions: TActionList
    Left = 48
    Top = 56
    object ActRunContinue: TAction
      Category = 'Run'
      Caption = 'ActRunContinue'
      ShortCut = 120
      OnExecute = ActRunContinueExecute
      OnUpdate = ActRunContinueUpdate
    end
    object ActRunToggleBreakpoint: TAction
      Category = 'Run'
      Caption = 'ActRunToggleBreakpoint'
      ShortCut = 16503
      OnExecute = ActRunToggleBreakpointExecute
    end
    object ActRunStepInto: TAction
      Category = 'Run'
      Caption = 'ActRunStepInto'
      ShortCut = 118
      OnExecute = ActRunStepIntoExecute
      OnUpdate = ActRunStepIntoUpdate
    end
    object ActRunStepOver: TAction
      Category = 'Run'
      Caption = 'ActRunStepOver'
      ShortCut = 119
      OnExecute = ActRunStepOverExecute
      OnUpdate = ActRunStepOverUpdate
    end
    object ActRunEvaluate: TAction
      Category = 'Run'
      Caption = 'ActRunEvaluate'
      ShortCut = 16499
      OnExecute = ActRunEvaluateExecute
      OnUpdate = ActRunEvaluateUpdate
    end
  end
  object HltPascal: TSynPasSyn
    AsmAttri.Foreground = clAqua
    CommentAttri.Foreground = clSilver
    CommentAttri.Style = []
    DirectiveAttri.Foreground = clFuchsia
    DirectiveAttri.Style = []
    IdentifierAttri.Foreground = clYellow
    KeyAttri.Foreground = clWhite
    KeyAttri.Style = []
    NumberAttri.Foreground = clYellow
    FloatAttri.Foreground = clYellow
    HexAttri.Foreground = clMoneyGreen
    StringAttri.Foreground = clYellow
    CharAttri.Foreground = clYellow
    SymbolAttri.Foreground = clYellow
    Left = 80
    Top = 56
  end
  object Debugger: TPSScriptDebugger
    CompilerOptions = []
    Plugins = <
      item
        Plugin = FrmMain.PluginDll
      end
      item
        Plugin = FrmMain.PluginClasses
      end
      item
        Plugin = FrmMain.PluginDll
      end>
    UsePreProcessor = True
    OnIdle = DebuggerIdle
    OnLineInfo = DebuggerLineInfo
    OnBreakpoint = DebuggerBreakpoint
    Left = 48
    Top = 88
  end
end
