// ----------------------------------------------------------------------------
// Unit : PropertyEditor.pas
// Autor: Maciej "Padcom" Hryniszak
// Data : 2002-xx-xx - first version
//        2004-xx-xx - changed to events instead of registering data types
//        2005-02-27 - after setting data the property editor doesn't receive 
//                     focus anymore
// Opis : Property editor (now it's event-driven)
// ToDo :
// ----------------------------------------------------------------------------
 
unit PropertyEditor;

interface

{$IFDEF FINALVERSION}
  {$UNDEF DEBUG}
{$ENDIF}
{$IFDEF FPC}
  {$H+}
  {$MODE DELPHI}
{$ENDIF}

uses
{$IFDEF FPC}
  LCLType,
  LCLIntf,
  MaskEdit,
{$ELSE}
  Mask,
{$ENDIF}
  Windows, Messages, Classes, SysUtils, Graphics, Controls, Dialogs, Buttons, Forms, ExtCtrls,
  StdCtrls;

const
  ItemSize = 16;

type

  { Property editor specific types }

  TButtonKind = (
    bkPlain,       // plain
    bkArrow,       // drop-down arrow
    bkThreeDot,    // elippse button (like "more")
    bkCustom       // custom drawn button - use OnDrawButtonCaption event to draw the button caption
  );

  TPropertyButton = record
    Id: LongWord;
    Kind: TButtonKind;
    IsCustom: Boolean;
  end;

  TButtons = array of TPropertyButton;

  TProperty = packed record
    Id: LongWord;
{$IFDEF FPC}
    Caption: String;
{$ELSE}
    Caption: WideString;
{$ENDIF}
    Buttons: TButtons;
    ReadOnly: Boolean;
  end;

  TProperties = array of TProperty;

  { Events }

  TGetPropertiesEvent = procedure (Sender: TObject; Data: TObject; Group: Word; var Properties: TProperties) of object;
  TGetPropertyValue = procedure (Sender: TObject; Data: TObject; Group: Word; Prop: TProperty; var Value: WideString) of object;
  TSetPropertyValue = procedure (Sender: TObject; Data: TObject; Group: Word; Prop: TProperty; Value: WideString) of object;
  TDrawButtonCaptionEvent = procedure (Sender: TObject; Data: TObject; Group: Word; Button: LongWord; Canvas: TCanvas; Down: Boolean) of object;
  TPropertySelectedEvent = procedure (Sender: TObject; Data: TObject; Group: Word; Prop: TProperty) of object;
  TButtonDrawCaptionEvent = procedure (Sender: TObject; Canvas: TCanvas; Down: Boolean) of object;
  TUpdateListBoxContentEvent = procedure (Sender: TObject; Data: TObject; Group: Word; Prop: TProperty; Items: TStrings; var ItemIndex: Integer) of object;
  TPropertyButtonClickEvent = procedure (Sender: TObject; Data: TObject; Group: Word; Prop: TProperty; ButtonId: LongWord) of object;
  TEditorDblClickEvent = procedure (Sender: TObject; Data: TObject; Group: Word; Prop: TProperty) of object;

  { Custom elements of the property editor }

  { Editor }

  TPropertyEditorEdit = class (TMaskEdit)
    constructor Create(AOwner: TComponent); override;
  end;

  TPropertyEditorButton = class (TSpeedButton)
  private
    FOnDrawCaption: TButtonDrawCaptionEvent;
    FButtonKind: TButtonKind;
    FIsCustom: Boolean;
    procedure SetButtonKind(Value: TButtonKind);
  protected
    procedure Paint; override;
  public
    property ButtonKind: TButtonKind read FButtonKind write SetButtonKind;
    property IsCustom: Boolean read FIsCustom write FIsCustom;
    property OnDrawCaption: TButtonDrawCaptionEvent read FOndrawCaption write FOndrawCaption;
  end;

  TPropertyEditorButtonList = class (TList)
  private
    function GetItem(Index: Integer): TPropertyEditorButton;
  public
    property Items[Index: Integer]: TPropertyEditorButton read GetItem; default;
  end;

  TCustomPropertyEditor = class (TCustomControl)
  private
    FPaintBuffer: TBitmap;
    FResizingHeader: Integer;
    FEdit: TPropertyEditorEdit;
    FButtons: TPropertyEditorButtonList;
    FOldButtons: TPropertyEditorButtonList;
    FData: TObject;
    FGroup: Word;
    FProperties: TProperties;
    FCurrentPropertyIndex: Integer;
    FHeaderWidth: Integer;
    FShowCaptions: Boolean;
    FScrollBarPos: Integer;
    FOnGetProperties: TGetPropertiesEvent;
    FOnGetPropertyValue: TGetPropertyValue;
    FOnSetPropertyValue: TSetPropertyValue;
    FOnDrawButtonCaption: TDrawButtonCaptionEvent;
    FOnPropertySelected: TPropertySelectedEvent;
    FOnUpdateListBoxContent: TUpdateListBoxContentEvent;
    FOnPropertyButtonClick: TPropertyButtonClickEvent;
    FOnEditorDblClick: TEditorDblClickEvent;
    FListBox: TListBox;
    procedure SetData(Value: TObject);
    procedure SetGroup(Value: Word);
    procedure SetCurrentPropertyIndex(Value: Integer);
    procedure SetHeaderWidth(Value: Integer);
    procedure SetShowCaptions(Value: Boolean);

    procedure OnButtonClick(Sender: TObject);
    procedure OnButtonPaintCaption(Sender: TObject; Canvas: TCanvas; Down: Boolean);

    procedure WMGetDlgCode(var Msg: TWMGetDlgCode);
    procedure WMVScroll(var Msg: TWMScroll);
    procedure WMMouseWheel(var Msg: TWMMouseWheel);
    procedure WMKillFocus(var Message: TWMKillFocus);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure WndProc(var Msg: TMessage); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure EditorKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState); virtual;
    procedure EditorKeyPress(Sender: TObject; var Key: Char); virtual;
    procedure EditorDblClick(Sender: TObject); virtual;

    procedure ListBoxKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState); virtual;
    procedure ListBoxClick(Sender: TObject); virtual;
    procedure ListBoxDblClick(Sender: TObject); virtual;
    procedure ListBoxExit(Sender: TObject); virtual;

    procedure Resize; override;
    procedure Paint; override;

    procedure InvalidateScrollbar; virtual;
    procedure InvalidateEditor; virtual;
    procedure InvalidateButtons; virtual;

    // properties
    property CurrentPropertyIndex: Integer read FCurrentPropertyIndex write SetCurrentPropertyIndex;
    property HeaderWidth: Integer read FHeaderWidth write SetHeaderWidth;
    property ShowCaptions: Boolean read FShowCaptions write SetShowCaptions;

    // events
    property OnGetProperties: TGetPropertiesEvent read FOnGetProperties write FOnGetProperties;
    property OnGetPropertyValue: TGetPropertyValue read FOnGetPropertyValue write FOnGetPropertyValue;
    property OnSetPropertyValue: TSetPropertyValue read FOnSetPropertyValue write FOnSetPropertyValue;
    property OnDrawButtonCaption: TDrawButtonCaptionEvent read FOnDrawButtonCaption write FOnDrawButtonCaption;
    property OnPropertySelected: TPropertySelectedEvent read FOnPropertySelected write FOnPropertySelected;
    property OnUpdateListBoxContent: TUpdateListBoxContentEvent read FOnUpdateListBoxContent write FOnUpdateListBoxContent;
    property OnPropertyButtonClick: TPropertyButtonClickEvent read FOnPropertyButtonClick write FOnPropertyButtonClick;
    property OnEditorDblClick: TEditorDblClickEvent read FOnEditorDblClick write FOnEditorDblClick;
  public
    class function MakeButton(Id: LongWord; Kind: TButtonKind = bkArrow): TPropertyButton;
    class function MakeProperty(Id: LongWord; Caption: WideString; Buttons: Integer = 0; ReadOnly: Boolean = False): TProperty;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetFocus; override;
    procedure Undo;
    procedure UpdateContent;
    procedure UpdateData;
    procedure HideAdditionals; virtual;
    procedure SetProperty(PropertyId: LongWord);
    property Data: TObject read FData write SetData;
    property Group: Word read FGroup write SetGroup;
  end;

  TPropertyEditor = class (TCustomPropertyEditor)
  published
    property Align;
    property CurrentPropertyIndex;
    property HeaderWidth;
    property ShowCaptions;
    property TabStop;
    property OnGetProperties;
    property OnGetPropertyValue;
    property OnSetPropertyValue;
    property OnDrawButtonCaption;
    property OnPropertySelected;
    property OnUpdateListBoxContent;
    property OnPropertyButtonClick;
    property OnEditorDblClick;
  end;

procedure Register;

implementation

{ TPropertyEditorEdit }

constructor TPropertyEditorEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF VER140}
  ControlStyle := ControlStyle + [csOpaque];
{$ELSE}  
  ControlStyle := ControlStyle + [csOpaque, csParentBackground];
{$ENDIF}
end;

{ TPropertyEditorButton }

{ Private declarations }

procedure TPropertyEditorButton.SetButtonKind(Value: TButtonKind);
begin
  if FButtonKind <> Value then
  begin
    FButtonKind := Value;
    Invalidate;
  end;
end;

{ Protected declarations }

procedure TPropertyEditorButton.Paint;
var
  R: TRect;
begin
  R := ClientRect;
  Canvas.Brush.Color := clBtnFace;
  Canvas.FillRect(R);
  if bsDown = FState then
  begin
    Canvas.Pen.Color := clBtnShadow;
    Canvas.Polyline([Point(0, 0), Point(14, 0), Point(14, 13), Point(0, 13), Point(0, 0)]);
    case ButtonKind of
      bkPlain: ;
      bkArrow:
      begin
        Canvas.Pen.Color := clWindowText;
        Canvas.Polyline([Point(5, 6), Point(12, 6)]);
        Canvas.Polyline([Point(6, 7), Point(11, 7)]);
        Canvas.Polyline([Point(7, 8), Point(10, 8)]);
        Canvas.Pixels[8, 9] := clWindowText;
      end;
      bkThreeDot:
      begin
        Canvas.Brush.Style := bsClear;
        Canvas.TextOut(4, -2, '...');
      end;
      bkCustom:
        if Assigned(OnDrawCaption) then
          OnDrawCaption(Self, Canvas, True);
    end;
  end
  else
  begin
    // top
    Canvas.Pen.Color := clBtnFace;
    Canvas.Polyline([Point(0, 12), Point(0, 0), Point(14, 0)]);
    Canvas.Pen.Color := clWindow;
    Canvas.Polyline([Point(1, 11), Point(1, 1), Point(13, 1)]);
    // bottom
    Canvas.Pen.Color := clBtnShadow;
    Canvas.Polyline([Point(1, 12), Point(13, 12), Point(13, 0)]);
    Canvas.Pen.Color := clBlack;
    Canvas.Polyline([Point(0, 13), Point(14, 13), Point(14, -1)]);

    case ButtonKind of
      bkPlain: ;
      bkArrow:
      begin
        Canvas.Pen.Color := clWindowText;
        Canvas.Polyline([Point(4, 5), Point(11, 5)]);
        Canvas.Polyline([Point(5, 6), Point(10, 6)]);
        Canvas.Polyline([Point(6, 7), Point(9, 7)]);
        Canvas.Pixels[7, 8] := clWindowText;
      end;
      bkThreeDot:
      begin
        Canvas.Brush.Style := bsClear;
        Canvas.TextOut(3, -3, '...');
      end;
      bkCustom:
        if Assigned(OnDrawCaption) then
          OnDrawCaption(Self, Canvas, True);
    end;
  end;
end;

{ TPropertyEditorButtonList }

{ Private declaration }

function TPropertyEditorButtonList.GetItem(Index: Integer): TPropertyEditorButton;
begin
  Result := TObject(Get(Index)) as TPropertyEditorButton;
end;

{ Public declarations }

{ TCustomPropertyEditor }

{ Private declarations }

procedure TCustomPropertyEditor.SetData(Value: TObject);
begin
  if FData <> Value then
  begin
    FData := Value;
    UpdateContent;
  end;
end;

procedure TCustomPropertyEditor.SetGroup(Value: Word);
var
  I: Integer;
  OldPropId: LongWord;
  EmptyProp: TProperty;
begin
  if FGroup <> Value then
  begin
    FGroup := Value;

    if (CurrentPropertyIndex <> -1) and (Length(FProperties) > CurrentPropertyIndex) then
      OldPropId := FProperties[CurrentPropertyIndex].Id
    else
      OldPropId := 0;

    FProperties := nil;
    if Assigned(FOnGetProperties) then
      FOnGetProperties(Self, Data, Group, FProperties);

    if Length(FProperties) > 0 then
    begin
      CurrentPropertyIndex := 0;
      for I := 0 to Length(FProperties) - 1 do
        if FProperties[I].Id = OldPropId then
        begin
          CurrentPropertyIndex := I;
          Break;
        end;
    end
    else
      CurrentPropertyIndex := -1;

    HideAdditionals;  
    InvalidateScrollbar;
    InvalidateButtons;
    InvalidateEditor;
    Invalidate;

    if Assigned(OnPropertySelected) then
      if Length(FProperties) > 0 then
        OnPropertySelected(Self, Data, Group, FProperties[CurrentPropertyIndex])
      else
      begin
        EmptyProp := MakeProperty(0, '');
        OnPropertySelected(Self, Data, Group, EmptyProp);
      end;
  end;
end;

procedure TCustomPropertyEditor.SetCurrentPropertyIndex(Value: Integer);
begin
  if FCurrentPropertyIndex <> Value then
  begin
    if Value >= Length(FProperties) then
      Value := Length(FProperties) - 1
    else if (Value < 0) and (Length(FProperties) > 0) then
      Value := 0 // there must be always something selected
    else if Length(FProperties) = 0 then
      Value := -1; // no properties defined - nothing selected
    FCurrentPropertyIndex := Value;

    InvalidateScrollbar;
    InvalidateButtons;
    InvalidateEditor;
    Invalidate;
  end;
end;

procedure TCustomPropertyEditor.SetHeaderWidth(Value: Integer);
begin
  if FHeaderWidth <> Value then
  begin
    FHeaderWidth := Value;
    InvalidateEditor;
    Invalidate;
  end;
end;

procedure TCustomPropertyEditor.SetShowCaptions(Value: Boolean);
begin
  if FShowCaptions <> Value then
  begin
    FShowCaptions := Value;
    InvalidateEditor;
    Invalidate;
  end;
end;

procedure TCustomPropertyEditor.OnButtonClick(Sender: TObject);
const
  MaxDropDownCount = 6;
var
  DoShow: Boolean;
  Index: Integer;
begin
  if FListBox.Visible then
  begin
    FEdit.SetFocus;
    FEdit.SelectAll;
  end
//  else if TPropertyEditorButton(Sender).ButtonKind = bkArrow then
  else if not TPropertyEditorButton(Sender).IsCustom then
  begin
    FListBox.Items.BeginUpdate;
    try
      Index := -1;
      FListBox.Clear;
      if Assigned(OnUpdateListBoxContent) then
        OnUpdateListBoxContent(Self, Data, Group, FProperties[CurrentPropertyIndex], FListBox.Items, Index);
      DoShow := FListBox.Items.Count > 0;
    finally
      FListBox.Items.EndUpdate;
    end;
    if DoShow then
    begin
{$IFNDEF FPC}
      FListBox.Ctl3D := False;
{$ENDIF}
      FListBox.Left := HeaderWidth;
      FListBox.Width := ClientWidth - HeaderWidth - 1;
      FListBox.Top := (CurrentPropertyIndex - FScrollBarPos + 1) * ItemSize + 1;
      FListBox.ItemIndex := Index;
      // DropDown count
      if FListBox.Items.Count < MaxDropDownCount then
        FListBox.ClientHeight := FListBox.Items.Count * FListBox.ItemHeight
      else
        FListBox.ClientHeight := MaxDropDownCount * FListBox.ItemHeight;

      FListBox.Visible := True;
      FListBox.SetFocus;
    end;
  end
  else
  begin
    HideAdditionals;
    if Assigned(OnPropertyButtonClick) then
      OnPropertyButtonClick(Self, Data, Group, FProperties[CurrentPropertyIndex], TPropertyEditorButton(Sender).Tag);
  end;
end;

procedure TCustomPropertyEditor.OnButtonPaintCaption(Sender: TObject; Canvas: TCanvas; Down: Boolean);
begin
  if Assigned(FOnDrawButtonCaption) then
    FOnDrawButtonCaption(Self, Data, Group, TComponent(Sender).Tag, Canvas, Down);
end;

procedure TCustomPropertyEditor.WMGetDlgCode(var Msg: TWMGetDlgCode);
begin
  Msg.Result := DLGC_WANTARROWS;
end;

procedure TCustomPropertyEditor.WMVScroll(var Msg: TWMScroll);
var
  ScrollCode: Integer;
begin
  ScrollCode := MaxInt;
  case Msg.ScrollCode of
    SB_LINEDOWN:
    begin
      if FScrollBarPos < Length(FProperties) -1 then
      begin
        ScrollCode := SB_THUMBTRACK;
        Msg.Pos := FScrollBarPos + 1;
      end;
    end;
    SB_LINEUP:
    begin
      if FScrollBarPos > 0 then
      begin
        ScrollCode := SB_THUMBTRACK;
        Msg.Pos := FScrollBarPos - 1;
      end;
    end;
    SB_PAGEDOWN:
    begin
      if FScrollBarPos < Length(FProperties) - (ClientHeight div ItemSize) then
      begin
        ScrollCode := SB_THUMBTRACK;
        Msg.Pos := FScrollBarPos + (ClientHeight div ItemSize);
      end
      else if FScrollBarPos < Length(FProperties) - 1 then
      begin
        ScrollCode := SB_THUMBTRACK;
        Msg.Pos := Length(FProperties) - 1 ;
      end;
    end;
    SB_PAGEUP:
    begin
      if FScrollBarPos > (ClientHeight div ItemSize) then
      begin
        ScrollCode := SB_THUMBTRACK;
        Msg.Pos := FScrollBarPos - (ClientHeight div ItemSize);
      end
      else if FScrollBarPos > 0 then
      begin
        ScrollCode := SB_THUMBTRACK;
        Msg.Pos := 0;
      end
    end;
    SB_THUMBTRACK:
      ScrollCode := SB_THUMBTRACK;
  end;
  case ScrollCode of
    SB_THUMBTRACK,
    SB_LINEDOWN,
    SB_LINEUP,
    SB_PAGEDOWN,
    SB_PAGEUP:
    begin
      FScrollBarPos := Msg.Pos;
      InvalidateScrollbar;
      InvalidateButtons;
      InvalidateEditor;
      Invalidate;
      if Assigned(OnPropertySelected) then
        OnPropertySelected(Self, Data, Group, FProperties[CurrentPropertyIndex]);
    end;
  end;
end;

procedure TCustomPropertyEditor.WMMouseWheel(var Msg: TWMMouseWheel);
var
  M: TWMVScroll;
begin
  M.Msg := WM_VSCROLL;
  M.Pos := 0;
  M.ScrollCode := 0;
  if Msg.WheelDelta > 0 then
    M.ScrollCode := SB_LINEUP
  else if Msg.WheelDelta < 0 then
    M.ScrollCode := SB_LINEDOWN
  else
    M.ScrollCode := MAXSHORT;

  if M.ScrollCode <> MAXSHORT then
    SendMessage(Handle, M.Msg, TMessage(M).WParam, TMessage(M).LParam);
end;

procedure TCustomPropertyEditor.WMKillFocus(var Message: TWMkillFocus);
begin
  Invalidate;
end;

{ Protected declarations }

procedure TCustomPropertyEditor.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style or WS_TABSTOP and (not CS_HREDRAW) and (not CS_VREDRAW);
  Params.ExStyle := Params.ExStyle or WS_EX_WINDOWEDGE or WS_EX_RIGHTSCROLLBAR;
  Params.WindowClass.style := CS_DBLCLKS;
end;

procedure TCustomPropertyEditor.WndProc(var Msg: TMessage); 
begin
  inherited WndProc(Msg);
  case Msg.Msg of
    WM_GETDLGCODE: WMGetDlgCode(TWMGetDlgCode(Msg));
    WM_VSCROLL: WMVScroll(TWMScroll(Msg));
    WM_MOUSEWHEEL: WMMouseWheel(TWMMouseWheel(Msg));
    WM_KILLFOCUS: WMKillFocus(TWMKillFocus(Msg));
  end;
end;

procedure TCustomPropertyEditor.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  if FResizingHeader > 0 then
  begin
    FResizingHeader := X;
    if FResizingHeader < 30 then FResizingHeader := 30;
    if FResizingHeader > ClientWidth - 30 then FResizingHeader := ClientWidth - 30;
    Invalidate;
  end
  else if ShowCaptions and (Abs(X - FHeaderWidth) < 2) then Cursor := crHSplit
  else Cursor := crDefault;
  inherited MouseMove(Shift, X, Y);
end;

procedure TCustomPropertyEditor.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Index: Integer;
begin
  inherited MouseDown(Button, Shift, X, Y);
  if Abs(X - HeaderWidth) < 2 then
  begin
    FResizingHeader := X;
    if FResizingHeader < 30 then FResizingHeader := 30;
    if FResizingHeader > ClientWidth - 30 then FResizingHeader := ClientWidth - 30;
    Invalidate;
  end
  else
  begin
    Index := Y div ItemSize + FScrollBarPos;
    if (Index < Length(FProperties)) and (Index <> CurrentPropertyIndex) then
    begin
      UpdateData;
      CurrentPropertyIndex := Index;
      InvalidateButtons;
      InvalidateEditor;
      HideAdditionals;
      Invalidate;
      if Assigned(OnPropertySelected) then
        OnPropertySelected(Self, Data, Group, FProperties[CurrentPropertyIndex]);
    end;
  end;
  if not Focused then
    SetFocus;
end;

procedure TCustomPropertyEditor.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  if FResizingHeader > 0 then
  begin
    FHeaderWidth := FResizingHeader;
    FResizingHeader := -1;
    InvalidateButtons;
    InvalidateEditor;
    HideAdditionals;
    Invalidate;
  end;
end;

procedure TCustomPropertyEditor.KeyDown(var Key: Word; Shift: TShiftState);
var
  I: Integer;
  Changed: Boolean;
  Msg: TWMVScroll;
begin
  Changed := False;
  case Key of
    VK_UP:
    begin
      if (Length(FProperties) > 0) and (CurrentPropertyIndex > 0) then
      begin
        CurrentPropertyIndex := CurrentPropertyIndex - 1;
        Changed := True;
      end;
      Key := 0;
    end;
    VK_DOWN:
    begin
      if (Length(FProperties) > 0) and (CurrentPropertyIndex < Length(FProperties) - 1) then
      begin
        CurrentPropertyIndex := CurrentPropertyIndex + 1;
        Changed := True;
      end;
      Key := 0;
    end;
    VK_RETURN:
    begin
      if ssCtrl in Shift then
        for I := FButtons.Count - 1 downto 0 do
          if FButtons[I].Visible then
          begin
            FButtons[I].Click;
            Key := 0;
            Break;
          end;
    end;
  end;
  inherited KeyDown(Key, Shift);
  if Changed then
  begin
    if CurrentPropertyIndex < FScrollBarPos then
    begin
      Msg.Msg := WM_VSCROLL;
      Msg.ScrollCode := SB_THUMBTRACK;
      Msg.Pos := CurrentPropertyIndex;
      SendMessage(Handle, WM_VSCROLL, TMessage(Msg).WParam, TMessage(Msg).LParam);
      HideAdditionals;
    end
    else if CurrentPropertyIndex > FScrollBarPos + ClientHeight div ItemSize - 1 then
    begin
      Msg.Msg := WM_VSCROLL;
      Msg.ScrollCode := SB_THUMBTRACK;
      Msg.Pos := CurrentPropertyIndex - ClientHeight div ItemSize + 1;
      SendMessage(Handle, WM_VSCROLL, TMessage(Msg).WParam, TMessage(Msg).LParam);
      HideAdditionals;
    end
    else
    begin
      InvalidateEditor;
      InvalidateButtons;
      HideAdditionals;
      if FEdit.Visible then
        FEdit.SetFocus;
      Invalidate;
      if Assigned(OnPropertySelected) then
        OnPropertySelected(Self, Data, Group, FProperties[CurrentPropertyIndex]);
    end;
  end;
end;

procedure TCustomPropertyEditor.EditorKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_RETURN:
      if not (ssCtrl in Shift) then
      begin
        UpdateData;
        if FEdit.Visible then
          FEdit.SetFocus;
        Invalidate;
      end;
    VK_UP,
    VK_DOWN:
    begin
      if not (ssCtrl in Shift) then
      begin
        UpdateData;
        if FEdit.Visible then
          FEdit.SetFocus;
        Invalidate;
      end;
      if Assigned(OnPropertySelected) then
        OnPropertySelected(Self, Data, Group, FProperties[CurrentPropertyIndex]);
    end;
    VK_ESCAPE:
      Undo;
  end;

  KeyDown(Key, Shift);
end;

procedure TCustomPropertyEditor.EditorKeyPress(Sender: TObject; var Key: Char);
begin
  if Key in [#13, #27] then
    Key := #0;
end;

procedure TCustomPropertyEditor.EditorDblClick(Sender: TObject);
begin
  if Assigned(FOnEditorDblClick) then
    FOnEditorDblClick(Self, Data, Group, FProperties[CurrentPropertyIndex]);
end;

procedure TCustomPropertyEditor.ListBoxKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_RETURN, VK_ESCAPE:
    begin
      HideAdditionals;
      FEdit.SetFocus;
    end;
  end;
end;

procedure TCustomPropertyEditor.ListBoxClick(Sender: TObject);
begin
  FEdit.Text := FListBox.Items[FListBox.ItemIndex];
  UpdateData;
  {if not RequireDblClick then
  begin}
    HideAdditionals;
    if FEdit.Visible then
      FEdit.SetFocus;
  {end;}
end;

procedure TCustomPropertyEditor.ListBoxDblClick(Sender: TObject);
begin
  HideAdditionals;
  if FEdit.Visible then
    FEdit.SetFocus;
end;

procedure TCustomPropertyEditor.ListBoxExit(Sender: TObject);
begin
  HideAdditionals;
end;

procedure TCustomPropertyEditor.Resize;
begin
  inherited Resize;
  FPaintBuffer.Width := ClientWidth;
  FPaintBuffer.Height := ClientHeight;
  HideAdditionals;
  InvalidateScrollbar;
  InvalidateButtons;
  InvalidateEditor;
  Invalidate;
end;

procedure TCustomPropertyEditor.Paint;
var
  I: Integer;
  R: TRect;
  Canvas: TCanvas;
  procedure DrawHDivider;
  var
    J: Integer;
  begin
    if I = CurrentPropertyIndex then Exit;
    for J := 0 to ClientWidth - 1 do
      if J mod 2 = 0 then
        Canvas.Pixels[J, ((I - FScrollBarPos) + 1) * ItemSize] := clDkGray;
  end;
  procedure Line(X1, Y1, X2, Y2: Integer; Color: TColor);
  begin
    Canvas.Pen.Color := Color;
    Canvas.MoveTo(X1, Y1);
    Canvas.LineTo(X2, Y2);
  end;
  procedure DrawVDivider;
  begin
    if I = CurrentPropertyIndex then
    begin
      Line(HeaderWidth - 1, (I - FScrollBarPos) * ItemSize + 2, HeaderWidth - 1, ((I - FScrollBarPos) + 1) * ItemSize + 0, clBtnShadow);
      Line(HeaderWidth, (I - FScrollBarPos) * ItemSize + 2, HeaderWidth, ((I - FScrollBarPos) + 1) * ItemSize + 0, clBtnHighlight);
    end
    else
    begin
      Line(HeaderWidth - 1, (I - FScrollBarPos) * ItemSize + 1, HeaderWidth - 1, ((I - FScrollBarPos) + 1) * ItemSize - 0, clBtnShadow);
      Line(HeaderWidth, (I - FScrollBarPos) * ItemSize + 1, HeaderWidth, ((I - FScrollBarPos) + 1) * ItemSize - 0, clBtnHighlight);
    end;
  end;
  procedure DrawHeaderResizer;
  var
    PS: TPenStyle;
    PM: TPenMode;
  begin
    PS := Canvas.Pen.Style;
    PM := Canvas.Pen.Mode;
    Canvas.Pen.Color := clBlack;
    Canvas.Pen.Style := psDot;
    Canvas.Pen.Mode := pmXor;
    Line(FResizingHeader, 0, FResizingHeader, ClientHeight, clBlack);
    Canvas.Pen.Style := PS;
    Canvas.Pen.Mode := PM;
  end;
var
  S: WideString;
begin
  Canvas := FPaintBuffer.Canvas;
  Canvas.Brush.Color := clBtnFace;
  Canvas.FillRect(ClientRect);

  for I := FScrollBarPos to Length(FProperties) - 1 do
  begin
    if I = CurrentPropertyIndex then
    begin
      R := Rect(0, (I - FScrollBarPos) * ItemSize, ClientWidth + 1, ((I - FScrollBarPos) + 1) * ItemSize + 1);
      DrawFrameControl(Canvas.Handle, R, DFC_BUTTON, DFCS_BUTTONPUSH or DFCS_PUSHED);
    end;
    if ShowCaptions then
    begin
      R := Rect(2, (I - FScrollBarPos) * ItemSize + 2, HeaderWidth, ((I - FScrollBarPos) + 1) * ItemSize);
      Canvas.Brush.Color := clBtnFace;
      Canvas.Font.Color := clWindowText;
      Canvas.TextRect(R, R.Left + 2, R.Top, FProperties[I].Caption);
    end;

    R := Rect(HeaderWidth + 1, (I - FScrollBarPos) * ItemSize + 2, ClientWidth - 2, ((I - FScrollBarPos) + 1) * ItemSize - 1);
    if I = CurrentPropertyIndex then
    begin
      if FProperties[I].ReadOnly then
      begin
        Canvas.Brush.Color := clHighlight;
        Canvas.Font.Color := clHighlightText;
        if Focused then
          R.Top := R.Top - 0;
        R.Bottom := R.Bottom + 1;
  //      R.Left := R.Left - 1;
        R.Right := R.Right + 1;
        R.Right := R.Right - Length(FProperties[I].Buttons) * ItemSize;
        if Length(FProperties[I].Buttons) > 0 then
          R.Right := R.Right + 1;
      end
      else
      begin
        Canvas.Brush.Color := clWindow;
        Canvas.Font.Color := clWindow;
      end;
    end
    else
      Canvas.Brush.Color := clBtnFace;
    Canvas.FillRect(R);

    S := '';
    if Assigned(OnGetPropertyValue) then
      OnGetPropertyValue(Self, Data, Group, FProperties[I], S);
    if (I = CurrentPropertyIndex) and (FProperties[I].ReadOnly) then
    begin
      if Focused then
        Canvas.TextRect(R, R.Left + 2, R.Top + 0, S)
      else
        Canvas.TextRect(R, R.Left + 2, R.Top + 0, S)
    end
    else
      Canvas.TextRect(R, R.Left + 2, R.Top + 0, S);

    if (I = CurrentPropertyIndex) and (FProperties[I].ReadOnly) and Focused then
    begin
      // draw a rectangle like in the Gredi editor
      DrawFocusRect(Canvas.Handle, R);
    end;

    DrawHDivider;
    if ShowCaptions then
      DrawVDivider;
  end;

  if FResizingHeader > 0 then
    DrawHeaderResizer;

  R := ClientRect;
{$IFDEF FPC}
  Canvas.Frame3D(R, 1, bvLowered);
{$ELSE}
  Frame3D(Canvas, R, clBtnShadow, clBtnHighlight, 1);
{$ENDIF}

  PaintControls(Canvas.Handle, FEdit);

  Self.Canvas.Draw(0, 0, FPaintBuffer);
end;

procedure TCustomPropertyEditor.InvalidateScrollbar;
var
  Info: TScrollInfo;
begin
  FillChar(Info, SizeOf(Info), 0);
  if Length(FProperties) > ClientHeight div ItemSize then
  begin
    Info.cbSize := SizeOf(TScrollInfo);
    Info.fMask := SIF_RANGE or SIF_POS;
    Info.nMin := 0;
    Info.nMax := Length(FProperties) - (ClientHeight div ItemSize);
    if Info.nMax < FScrollBarPos then FScrollBarPos := Info.nMax;
    Info.nPos := FScrollBarPos;
    SetScrollInfo(Handle, SB_CTL or SB_VERT or SIF_RANGE, Info, True);
  end
  else
  begin
    Info.cbSize := SizeOf(TScrollInfo);
    Info.fMask := SIF_RANGE or SIF_POS;
    Info.nMin := 0;
    Info.nMax := 0;
    Info.nPos := 0;
    FScrollBarPos := 0;
    SetScrollInfo(Handle, SB_CTL or SB_VERT or SIF_RANGE, Info, True);
  end;
end;

procedure TCustomPropertyEditor.InvalidateEditor;
var
  S: WideString;
  DoSetFocus: Boolean;
begin
  if (Length(FProperties) <> 0) and Assigned(Data) then
  begin
    DoSetFocus := FEdit.Focused or Focused;
    if FProperties[CurrentPropertyIndex].ReadOnly then
      FEdit.Hide
    else
      FEdit.Show;
    Application.ProcessMessages;
    S := '';
    if Assigned(FOnGetPropertyValue) then
      FOnGetPropertyValue(Self, Data, Group, FProperties[CurrentPropertyIndex], S);
    FEdit.Text := S;
    FEdit.SelectAll;
    FEdit.ReadOnly := FProperties[CurrentPropertyIndex].ReadOnly;
    if DoSetFocus then
      if FEdit.CanFocus then
        FEdit.SetFocus
      else
        SetFocus;
    if ShowCaptions then
      FEdit.SetBounds(
        FHeaderWidth + 3,
        (CurrentPropertyIndex - FScrollBarPos) * ItemSize + 2,
        ClientWidth - FHeaderWidth - Length(FProperties[CurrentPropertyIndex].Buttons) * ItemSize - 4,
        13)
    else
      FEdit.SetBounds(
        FHeaderWidth + 4,
        (CurrentPropertyIndex - FScrollBarPos) * ItemSize + 2,
        ClientWidth - FHeaderWidth - Length(FProperties[CurrentPropertyIndex].Buttons) * ItemSize - 2,
        ItemSize);
  end
  else
    FEdit.Hide;
end;

procedure TCustomPropertyEditor.InvalidateButtons;
var
  I, Count: Integer;
  Button: TPropertyEditorButton;
begin
  // workaround for an AV exception in Buttons:1063 (if Enabled...)
  // probably because a message is send to a item that doesn't exists anymore and that's why we have a
  // second list to keep semi-disposed elements alive till they are absolutely ready to be disposed.
  Application.ProcessMessages;
  I := 0;
  while I < FOldButtons.Count do
  begin
    FOldButtons[I].Tag := FOldButtons[I].Tag - 1;
    if FOldButtons[I].Tag = 0 then
    begin
      RemoveControl(FOldButtons[I]);
      FOldButtons[I].Free;
      FOldButtons.Delete(I);
    end
    else Inc(I);
  end;

  for I := 0 to FButtons.Count - 1 do
  begin
    FOldButtons.Add(FButtons[I]);
    FButtons[I].Tag := 10;
    FButtons[I].Visible := False;
  end;
  FButtons.Clear;

  if (Length(FProperties) <> 0) and Assigned(Data) then
  begin
    Count := Length(FProperties[CurrentPropertyIndex].Buttons);
    for I := 0 to Count - 1 do
    begin
      Button := TPropertyEditorButton.Create(Self);
      Button.Tag := FProperties[CurrentPropertyIndex].Buttons[Count - I - 1].Id;
      Button.ButtonKind := FProperties[CurrentPropertyIndex].Buttons[Count - I - 1].Kind;
      Button.IsCustom := FProperties[CurrentPropertyIndex].Buttons[Count - I - 1].IsCustom;
      Button.Flat := True;
      Button.OnClick := OnButtonClick;
      Button.OnDrawCaption := OnButtonPaintCaption;
      Button.SetBounds(
        ClientWidth - ((I + 1) * (ItemSize - 1)) - 1,
        (CurrentPropertyIndex - FScrollBarPos) * ItemSize + 2,
        ItemSize - 1,
        ItemSize - 2);
      InsertControl(Button);
      FButtons.Add(Button);
    end;
  end;
end;

{ Public declarations }

class function TCustomPropertyEditor.MakeButton(Id: LongWord; Kind: TButtonKind = bkArrow): TPropertyButton;
begin
  Result.Id := Id;
  Result.Kind := Kind;
end;

class function TCustomPropertyEditor.MakeProperty(Id: LongWord; Caption: WideString; Buttons: Integer = 0; ReadOnly: Boolean = False): TProperty;
var
  I: Integer;
begin
  Result.Id := Id;
  Result.Caption := Caption;
  Result.ReadOnly := ReadOnly;

  SetLength(Result.Buttons, Buttons);
  for I := 0 to Buttons - 1 do
  begin
    Result.Buttons[I].Id := I + 1;
    Result.Buttons[I].Kind := bkArrow;
    Result.Buttons[I].IsCustom := False;
  end;
end;

constructor TCustomPropertyEditor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csAcceptsControls, csOpaque];

  FPaintBuffer := TBitmap.Create;
  FShowCaptions := True;
  FHeaderWidth := 75;

  FEdit := TPropertyEditorEdit.Create(Self);
  FEdit.AutoSize := False;
  FEdit.BorderStyle := bsNone;
  FEdit.Height := 5;
  FEdit.OnKeyDown := EditorKeyDown;
  FEdit.OnKeyPress := EditorKeyPress;
  FEdit.OnDblClick := EditorDblClick;
  InsertControl(FEdit);
  FEdit.Visible := False;
  FEdit.Top := -FEdit.Height;

  FButtons := TPropertyEditorButtonList.Create;
  FOldButtons := TPropertyEditorButtonList.Create;

  FListBox := TListBox.Create(Self);
  FListBox.OnClick := ListBoxClick;
  FListBox.OnDblClick := ListBoxDblClick;
  FListBox.OnKeyDown := ListBoxKeyDown;
  FListBox.OnExit := ListBoxExit;
  InsertControl(FListBox);
  FListBox.Top := -FListBox.Height;
  FListBox.Hide;

  HideAdditionals;
end;

destructor TCustomPropertyEditor.Destroy;
begin
  FreeAndNil(FPaintBuffer);
  FreeAndNil(FButtons);
  FreeAndNil(FOldButtons);
  inherited Destroy;
end;

procedure TCustomPropertyEditor.SetFocus;
begin
  inherited SetFocus;
  if FEdit.Visible then
    FEdit.SetFocus
  else
    Invalidate;
end;

procedure TCustomPropertyEditor.Undo;
var
  Data: WideString;
begin
  Data := '';
  if Assigned(OnGetPropertyValue) then
    OnGetPropertyValue(Self, Self.Data, Group, FProperties[CurrentPropertyIndex], Data);
  if FEdit.Text <> Data then
    FEdit.Text := Data;
  FEdit.SelectAll;
end;

procedure TCustomPropertyEditor.UpdateContent;
var
  I: Integer;
  OldPropId: LongWord;
  EmptyProp: TProperty;
begin
  if (CurrentPropertyIndex <> -1) and (Length(FProperties) > CurrentPropertyIndex) then
    OldPropId := FProperties[CurrentPropertyIndex].Id
  else
    OldPropId := 0;

  FProperties := nil;
  if Assigned(FOnGetProperties) then
    FOnGetProperties(Self, Data, Group, FProperties);

  if Length(FProperties) > 0 then
  begin
    CurrentPropertyIndex := 0;
    for I := 0 to Length(FProperties) - 1 do
      if FProperties[I].Id = OldPropId then
      begin
        CurrentPropertyIndex := I;
        Break;
      end;
  end
  else
    CurrentPropertyIndex := -1;

  InvalidateScrollbar;
  InvalidateButtons;
  InvalidateEditor;
  Invalidate;

  if Assigned(OnPropertySelected) then
    if Length(FProperties) > 0 then
      OnPropertySelected(Self, Data, Group, FProperties[CurrentPropertyIndex])
    else
    begin
      EmptyProp := MakeProperty(0, '');
      OnPropertySelected(Self, Data, Group, EmptyProp);
    end;
end;

procedure TCustomPropertyEditor.UpdateData;
var
  OldValue: WideString;
begin
  if Assigned(OnGetPropertyValue) then
    OnGetPropertyValue(Self, Data, Group, FProperties[CurrentPropertyIndex], OldValue)
  else
    OldValue := '';
  if Assigned(OnSetPropertyValue) and (not WideSameText(FEdit.Text, OldValue)) then
    OnSetPropertyValue(Self, Data, Group, FProperties[CurrentPropertyIndex], FEdit.Text);
  if Assigned(OnPropertySelected) and (Length(FProperties) > 0) then
    OnPropertySelected(Self, Data, Group, FProperties[CurrentPropertyIndex]);
  InvalidateEditor;
end;

procedure TCustomPropertyEditor.HideAdditionals;
var
  I: Integer;
begin
  for I := 0 to ControlCount - 1 do
    if (Controls[I] <> FEdit) and (FButtons.IndexOf(Controls[I]) = -1) then
      Controls[I].Visible := False;
  for I := 0 to FButtons.Count - 1 do
    FButtons[I].Down := False;
end;

procedure TCustomPropertyEditor.SetProperty(PropertyId: LongWord);
var
  I: Integer;
begin
  for I := 0 to Length(FProperties) - 1 do
    if FProperties[I].Id = PropertyId then
    begin
      FCurrentPropertyIndex := I;
      UpdateContent;
      Break;
    end;
end;

{ TPropertyEditor }

{ *** }

{$R PropertyEditor.dcr}

procedure Register;
begin
  RegisterComponents('PxVCL', [TPropertyEditor]);
end;

end.
