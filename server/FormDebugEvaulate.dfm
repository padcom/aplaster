object FrmDebugEvaluate: TFrmDebugEvaluate
  Left = 297
  Top = 201
  BorderStyle = bsToolWindow
  Caption = 'FrmEvaluate'
  ClientHeight = 216
  ClientWidth = 394
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
  OnResize = FormResize
  OnShow = FormShow
  DesignSize = (
    394
    216)
  PixelsPerInch = 96
  TextHeight = 13
  object LblExpression: TLabel
    Left = 8
    Top = 7
    Width = 65
    Height = 13
    Anchors = [akLeft, akRight, akBottom]
    Caption = 'LblExpression'
  end
  object LblResult: TLabel
    Left = 8
    Top = 48
    Width = 44
    Height = 13
    Anchors = [akLeft, akRight, akBottom]
    Caption = 'LblResult'
  end
  object LblNewValue: TLabel
    Left = 8
    Top = 171
    Width = 63
    Height = 13
    Anchors = [akLeft, akRight, akBottom]
    Caption = 'LblNewValue'
    Enabled = False
  end
  object CbbExpression: TComboBox
    Left = 8
    Top = 23
    Width = 379
    Height = 21
    Anchors = [akLeft, akRight, akBottom]
    ItemHeight = 13
    TabOrder = 0
    Text = 'CbbExpression'
    OnKeyDown = CbbExpressionKeyDown
  end
  object MemResult: TMemo
    Left = 8
    Top = 64
    Width = 379
    Height = 104
    Anchors = [akLeft, akRight, akBottom]
    Lines.Strings = (
      'MemResult')
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object CbbNewValue: TComboBox
    Left = 8
    Top = 187
    Width = 379
    Height = 21
    Anchors = [akLeft, akRight, akBottom]
    Enabled = False
    ItemHeight = 13
    TabOrder = 2
    Text = 'CbbNewValue'
    OnKeyDown = CbbNewValueKeyDown
  end
end
