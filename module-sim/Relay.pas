unit Relay;

interface

uses
  Classes, SysUtils, ExtCtrls, 
  Device, DeviceIds, Protocol;

const
  RELAY_DISABLED           = 0;
  RELAY_WAIT_INITIAL_STATE = 1;
  RELAY_SET_INITIAL_STATE  = 2;
  RELAY_WAIT_FINAL_STATE   = 3;
  RELAY_SET_FINALL_STATE   = 4;

type
  TGetDigitalInputStateEvent = procedure (Sender: TObject; DevId: Byte; var State: Boolean) of object;
  TSetRelayStateEvent = procedure (Sender: TObject; DevId: Byte; const State: Boolean) of object;

  TRelay = class (TComponent)
  private
    FTimer: TTimer;
    FDevId: Byte;
    FStatus: Byte;
    FState: Byte;
    FInitialState: Boolean;
    FFinalState: Boolean;
    FDelay: Word;
    FDuration: Word;
    FBreakDevId: Byte;
    FTerminateDevId: Byte;
    FOnSendCommand: TSendCommandEvent;
    FOnGetDigitalInputState: TGetDigitalInputStateEvent;
    FOnSetRelayState: TSetRelayStateEvent;
    function GetEnabled: Boolean;
    procedure SetEnabled(Value: Boolean);
    procedure SetStatus(Value: Byte);
    procedure SendCommand(Command, DevId, DataSize: Byte; Data: Pointer);
    function GetDigitalInputState(DevId: Byte): Boolean;
    procedure SetRelayState(DevId: Byte; State: Boolean);
  protected
    procedure Run(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    procedure CmdControl(Data: PRelayControlRec);
    procedure CmdGetStatus;
    property Enabled: Boolean read GetEnabled write SetEnabled;
    property DevId: Byte read FDevId write FDevId;
    property Status: Byte read FStatus write SetStatus;
    property OnSendCommand: TSendCommandEvent read FOnSendCommand write FOnSendCommand;
    property OnGetDigitalInputState: TGetDigitalInputStateEvent read FOnGetDigitalInputState write FOnGetDigitalInputState;
    property OnSetRelayState: TSetRelayStateEvent read FOnSetRelayState write FOnSetRelayState;
  end;

implementation

{ TRelay }

{ Private declarations }

function TRelay.GetEnabled: Boolean;
begin
  Result := FTimer.Enabled;
end;

procedure TRelay.SetEnabled(Value: Boolean);
begin
  FTimer.Enabled := Value;
end;

procedure TRelay.SetStatus(Value: Byte);
begin
  if Value <> Status then
  begin
    FStatus := Value;
    SetRelayState(DevId, Status = 1);
    CmdGetStatus;
  end;
end;

procedure TRelay.SendCommand(Command, DevId, DataSize: Byte; Data: Pointer);
begin
  if Assigned(OnSendCommand) then
    OnSendCommand(Command, DevId, DataSize, Data);
end;

function TRelay.GetDigitalInputState(DevId: Byte): Boolean;
begin
  Result := False;
  if Assigned(FOnGetDigitalInputState) then
    FOnGetDigitalInputState(Self, DevId, Result);
end;

procedure TRelay.SetRelayState(DevId: Byte; State: Boolean);
begin
  if Assigned(FOnSetRelayState) then
    FOnSetRelayState(Self, DevId, State);
end;

{ Protected declarations }

procedure TRelay.Run(Sender: TObject);
begin
  case FState of
    RELAY_DISABLED:
      ;

    RELAY_WAIT_INITIAL_STATE:
    begin
      if FDelay = 0 then
        FState := RELAY_SET_INITIAL_STATE
      else
        Dec(FDelay);
    end;

    RELAY_SET_INITIAL_STATE:
    begin
      Status := Byte(FInitialState);
      if FDuration > 0 then
        FState := RELAY_WAIT_FINAL_STATE
      else
        FState := RELAY_SET_FINALL_STATE;
    end;

    RELAY_WAIT_FINAL_STATE:
    begin
      if FDuration = 0 then
        FState := RELAY_SET_FINALL_STATE
      else
        Dec(FDuration);

      if GetDigitalInputState(FBreakDevId) then
        SetRelayState(DevId, not FInitialState)
      else
        SetRelayState(DevId, FInitialState);

      if GetDigitalInputState(FTerminateDevId) then
        FState := RELAY_SET_FINALL_STATE;
    end;

    RELAY_SET_FINALL_STATE:
    begin
      Status := Byte(FFinalState);
      FState := RELAY_DISABLED;
    end;
  end;
end;

{ Public declarations }

constructor TRelay.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FTimer := TTimer.Create(AOwner);
  FTimer.Interval := 5;
  FTimer.OnTimer := Run;
  FDevId := DID_UNKNOWN;
end;

procedure TRelay.CmdControl(Data: PRelayControlRec);
begin
  FInitialState := (Data^.States and 1) <> 0;
  FFinalState := (Data^.States and 2) <> 0;
  FDelay := Data^.Delay;
  FDuration := Data^.Duration;
  FBreakDevId := Data^.BreakDevId;
  FTerminateDevId := Data^.TerminateDevId;

  if (Data^.Delay = 0) and (Data^.Duration = 0) then
    FState := RELAY_SET_FINALL_STATE
  else if Data^.Delay = 0 then
    FState := RELAY_SET_INITIAL_STATE
  else
    FState := RELAY_WAIT_INITIAL_STATE;
end;

procedure TRelay.CmdGetStatus;
var
  Data: TRelayStatusRec;
begin
  Data.Status := Status;
  SendCommand(CMD_RELAY_STATUS, DevId, SizeOf(TRelayStatusRec), @Data);
end;

end.

