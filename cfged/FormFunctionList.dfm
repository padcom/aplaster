object FrmFunctionList: TFrmFunctionList
  Left = 234
  Top = 165
  ActiveControl = LivItems
  BorderStyle = bsDialog
  Caption = 'FrmFunctionList'
  ClientHeight = 292
  ClientWidth = 586
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
  DesignSize = (
    586
    292)
  PixelsPerInch = 96
  TextHeight = 13
  object LblList: TLabel
    Left = 8
    Top = 8
    Width = 30
    Height = 13
    Caption = 'LblList'
  end
  object BtnOk: TButton
    Left = 488
    Top = 24
    Width = 89
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'BtnOk'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object BtnCancel: TButton
    Left = 488
    Top = 56
    Width = 89
    Height = 25
    Anchors = [akTop, akRight]
    Cancel = True
    Caption = 'BtnCancel'
    ModalResult = 2
    TabOrder = 1
  end
  object LivItems: TListView
    Left = 8
    Top = 24
    Width = 465
    Height = 260
    Anchors = [akLeft, akTop, akRight, akBottom]
    Columns = <>
    GridLines = True
    HideSelection = False
    HotTrack = True
    HotTrackStyles = [htHandPoint, htUnderlineHot]
    IconOptions.AutoArrange = True
    ReadOnly = True
    RowSelect = True
    SortType = stText
    TabOrder = 2
    ViewStyle = vsReport
    OnDblClick = LivItemsDblClick
  end
end
