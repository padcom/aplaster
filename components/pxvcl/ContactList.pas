unit ContactList;

interface

uses
  Windows, Messages, Classes, SysUtils, Graphics,
  Controls;

const
  TIMER_BLINK = 1;
  BLINK_INTERVAL = 300;

type
  TContactState = (csAvailable, csAway, csInvisible, csDisconnected);

  TContactBLinkStatus = (bsNone, bsBlink1, bsBlink2);

  TContact = class (TObject)
  private
    FUIN: Cardinal;
    FNick: string;
    FState: TContactState;
    FBlinkCount: Integer;
    FBlink: TContactBLinkStatus;
  public
    constructor Create(AUIN: Cardinal; ANick: string; AState: TContactState);
    property UIN: Cardinal read FUIN;
    property Nick: string read FNick;
    property State: TContactState read FState write FState;
  end;

  TContactList = class (TList)
  private
    function GetItem(Index: Integer): TContact;
  public
    procedure Clear; override;
    property Items[Index: Integer]: TContact read GetItem; default;
  end;

  TCustomContactListView = class (TCustomControl)
  private
    FContacts: TContactList;
    FIcons: TImageList;
    FImageIndexAvailable: Integer;
    FImageIndexAway: Integer;
    FImageIndexInvisible: Integer;
    FImageIndexDisconnected: Integer;
    FTopContactIndex: Integer;
    FContactIndex: Integer;
    FBlinkTimer: THandle;
    procedure SetContactIndex(Index: Integer);
    procedure DrawContact(Canvas: TCanvas; R: TRect; Contact: TContact);
    procedure BlinkContacts;
  protected
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure WndProc(var Message: TMessage); override;

    property Icons: TImageList read FIcons write FIcons;
    property ImageIndexAvailable: Integer read FImageIndexAvailable write FImageIndexAvailable;
    property ImageIndexAway: Integer read FImageIndexAway write FImageIndexAway;
    property ImageIndexInvisible: Integer read FImageIndexInvisible write FImageIndexInvisible;
    property ImageIndexDisconnected: Integer read FImageIndexDisconnected write FImageIndexDisconnected;
    property ContactIndex: Integer read FContactIndex write SetContactIndex;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetContactAt(X, Y: Integer): TContact;
    procedure BlinkContact(Contact: TContact);
    property Contacts: TContactList read FContacts;
  end;

  TContactListView = class (TCustomContactListView)
  published
    property Icons;
    property ImageIndexAvailable;
    property ImageIndexAway;
    property ImageIndexInvisible;
    property ImageIndexDisconnected;
    property OnDblClick;
  end;

procedure Register;

implementation

uses
  RtlConsts;

{ TContact }

{ Private declarations }

{ Public declarations }

constructor TContact.Create(AUIN: Cardinal; ANick: string; AState: TContactState);
begin
  inherited Create;
  FUIN := AUIN;
  FNick := ANick;
  FState := AState;
end;

{ TContactList }

{ Private declarations }

function TContactList.GetItem(Index: Integer): TContact;
begin
  Result := TObject(Get(Index)) as TContact;
end;

{ Public declarations }

procedure TContactList.Clear;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    Items[I].Free;
  inherited Clear;
end;

{ TCustomContactListView }

{ Private declarations }

procedure TCustomContactListView.SetContactIndex(Index: Integer);
begin
  if Index <> FContactIndex then
  begin
    if (Index < 0) or (Index >= Contacts.Count) then
      raise EListError.CreateFmt(SListIndexError, [Index])
    else
    begin
      FContactIndex := Index;
      Invalidate;
    end;
  end;
end;

procedure TCustomContactListView.DrawContact(Canvas: TCanvas; R: TRect; Contact: TContact);
var
  ImageIndex: Integer;
begin
  if ContactIndex = Contacts.IndexOf(Contact) then
  begin
    Canvas.Brush.Color := clHighlight;
    Canvas.Font.Color := clHighlightText;
  end
  else
  begin
    Canvas.Brush.Color := clWindow;
    Canvas.Font.Color := clWindowText;
  end;
  Canvas.Brush.Style := bsSolid;
  Canvas.FillRect(R);

  Canvas.Brush.Style := bsClear;
  if Assigned(Icons) then
  begin
    case Contact.State of
      csAvailable:
        ImageIndex := ImageIndexAvailable;
      csAway:
        ImageIndex := ImageIndexAway;
      csInvisible:
        ImageIndex := ImageIndexInvisible;
      csDisconnected:
        ImageIndex := ImageIndexDisconnected;
      else
        ImageIndex := -1;
    end;

    if ImageIndex <> -1 then
      Icons.Draw(Canvas, R.Left + 2, R.Top + 1, ImageIndex);

    R.Left := R.Left + Icons.Width + 2;
  end;

  R.Left := R.Left + 5;
  R.Top  := R.Top + 3;
  case Contact.FBlink of
    bsNone: Canvas.Font.Style := [];
    bsBlink1: Canvas.Font.Style := [fsBold];
    bsBlink2: Canvas.Font.Style := [];
  end;
  DrawText(Canvas.Handle, PChar(Contact.Nick), Length(Contact.Nick), R, DT_LEFT);
end;

procedure TCustomContactListView.BlinkContacts;
var
  I: Integer;
  Changed: Boolean;
  Contact: TContact;
begin
  Changed := False;
  for I := 0 to Contacts.Count - 1 do
  begin
    Contact := Contacts[I];
    if Contact.FBlinkCount > 0 then
    begin
      Dec(Contact.FBlinkCount);
      case Contact.FBlink of
        bsBlink1:
        begin
          Contact.FBlink := bsBlink2;
          Changed := True;
        end;
        bsBlink2:
        begin
          Contact.FBlink := bsBlink1;
          Changed := True;
        end;
      end;
    end
    else if Contact.FBlink <> bsNone then
    begin
      Contact.FBlink := bsNone;
      Changed := True;
    end;
  end;

  if Changed then
    Invalidate;
end;

{ Protected declartions }

procedure TCustomContactListView.Paint;
var
  B: TBitmap;
  R: TRect;
  I: Integer;
begin
  R := ClientRect;

  B := TBitmap.Create;
  try
    B.Width := ClientWidth;
    B.Height := ClientHeight;
    B.Canvas.Brush.Color := clWindow;
    B.Canvas.Font.Color := clWindowText;
    B.Canvas.FillRect(R);

    for I := 0 to Contacts.Count - 1 do
    begin
      R.Left := 0;
      R.Right := ClientWidth;
      R.Top := I * 20;
      R.Bottom := (I + 1) * 20;
      DrawContact(B.Canvas, R, Contacts[I]);
    end;

    Canvas.Draw(0, 0, B);
  finally
    B.Free;
  end;
end;

procedure TCustomContactListView.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Contact: TContact;
begin
  inherited MouseDown(Button, Shift, X, Y);
  Contact := GetContactAt(X, Y);
  if Assigned(Contact) then
    ContactIndex := Contacts.IndexOf(Contact);
end;

procedure TCustomContactListView.WndProc(var Message: TMessage);
begin
  if Message.Msg <> WM_ERASEBKGND then
    inherited WndProc(Message);

  case Message.Msg of
    WM_CREATE:
      FBlinkTimer := SetTimer(Handle, TIMER_BLINK, BLINK_INTERVAL, nil);
    WM_DESTROY:
      KillTimer(Handle, TIMER_BLINK);
    WM_TIMER:
      case Message.wParam of
        TIMER_BLINK:
          BlinkContacts;
      end;
  end;
end;

{ Public declarations }

constructor TCustomContactListView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csOpaque];
  FContacts := TContactList.Create;
  FImageIndexAvailable := -1;
  FImageIndexAway := -1;
  FImageIndexInvisible := -1;
  FImageIndexDisconnected := -1;
end;

destructor TCustomContactListView.Destroy;
begin
  FreeAndNil(FContacts);
  inherited Destroy;
end;

function TCustomContactListView.GetContactAt(X, Y: Integer): TContact;
var
  Index: Integer;
begin
  Index := FTopContactIndex + (Y div 20);
  if Index < Contacts.Count then
    Result := Contacts[Index]
  else
    Result := nil;
end;

procedure TCustomContactListView.BlinkContact(Contact: TContact);
begin
  Contact.FBlinkCount := 10;
  Contact.FBlink := bsBlink2;
end;

{ *** }

procedure Register;
begin
  RegisterComponents('PxVCL', [TContactListView]);
end;

end.

