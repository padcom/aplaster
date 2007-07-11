unit DigitalOutput;

interface

uses
  Classes, SysUtils, ExtCtrls,
  Device, DeviceIds, Protocol;

const
  DIGITAL_OUTPUT_DISABLED           = 0;
  DIGITAL_OUTPUT_WAIT_INITIAL_STATE = 1;
  DIGITAL_OUTPUT_SET_INITIAL_STATE  = 2;
  DIGITAL_OUTPUT_WAIT_FINAL_STATE   = 3;
  DIGITAL_OUTPUT_SET_FINALL_STATE   = 4;

type
  TGetDigitalInputStateEvent = procedure (Sender: TObject; DevId: Byte; var State: Boolean) of object;
  TSetDigitalOutputStateEvent = procedure (Sender: TObject; DevId: Byte; const State: Boolean) of object;

  TDigitalOutput = class (TComponent)
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
    FOnSetDigitalOutputState: TSetDigitalOutputStateEvent;
    function GetEnabled: Boolean;
    procedure SetEnabled(Value: Boolean);
    procedure SetStatus(Value: Byte);
    procedure SendCommand(Command, DevId, DataSize: Byte; Data: Pointer);
    function GetDigitalInputState(DevId: Byte): Boolean;
    procedure SetDigitalOutputState(DevId: Byte; State: Boolean);
  protected
    procedure Run(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    procedure CmdControl(Data: PDigitalOutputControlRec);
    procedure CmdGetStatus;
    property Enabled: Boolean read GetEnabled write SetEnabled;
    property DevId: Byte read FDevId write FDevId;
    property Status: Byte read FStatus write SetStatus;
    property OnSendCommand: TSendCommandEvent read FOnSendCommand write FOnSendCommand;
    property OnGetDigitalInputState: TGetDigitalInputStateEvent read FOnGetDigitalInputState write FOnGetDigitalInputState;
    property OnSetDigitalOutputState: TSetDigitalOutputStateEvent read FOnSetDigitalOutputState write FOnSetDigitalOutputState;
  end;

implementation

{ TDigitalOutput }

{ Private declarations }

function TDigitalOutput.GetEnabled: Boolean;
begin
  Result :=  FTimer.Enabled;
end;

procedure TDigitalOutput.SetEnabled(Value: Boolean);
begin
  FTimer.Enabled := Value;
end;

procedure TDigitalOutput.SetStatus(Value: Byte);
begin
  if Value <> Status then
  begin
    FStatus := Value;
    SetDigitalOutputState(DevId, Status = 1);
    CmdGetStatus;
  end;
end;

procedure TDigitalOutput.SendCommand(Command, DevId, DataSize: Byte; Data: Pointer);
begin
  if Assigned(OnSendCommand) then
    OnSendCommand(Command, DevId, DataSize, Data);
end;

function TDigitalOutput.GetDigitalInputState(DevId: Byte): Boolean;
begin
  Result := False;
  if Assigned(FOnGetDigitalInputState) then
    FOnGetDigitalInputState(Self, DevId, Result);
end;

procedure TDigitalOutput.SetDigitalOutputState(DevId: Byte; State: Boolean);
begin
  if Assigned(FOnSetDigitalOutputState) then
    FOnSetDigitalOutputState(Self, DevId, State);
end;

{ Protected declarations }

procedure TDigitalOutput.Run(Sender: TObject);
begin
  case FState of
    DIGITAL_OUTPUT_DISABLED:
      ;

    DIGITAL_OUTPUT_WAIT_INITIAL_STATE:
    begin
      if FDelay = 0 then
        FState := DIGITAL_OUTPUT_SET_INITIAL_STATE
      else
        Dec(FDelay);
    end;

    DIGITAL_OUTPUT_SET_INITIAL_STATE:
    begin
      Status := Byte(FInitialState);
      if FDuration > 0 then
        FState := DIGITAL_OUTPUT_WAIT_FINAL_STATE
      else
        FState := DIGITAL_OUTPUT_SET_FINALL_STATE;
    end;

    DIGITAL_OUTPUT_WAIT_FINAL_STATE:
    begin
      if FDuration = 0 then
        FState := DIGITAL_OUTPUT_SET_FINALL_STATE
      else
        Dec(FDuration);

      if GetDigitalInputState(FBreakDevId) then
        Status := Byte(not FInitialState)
      else
        Status := Byte(FInitialState);

      if GetDigitalInputState(FTerminateDevId) then
        FState := DIGITAL_OUTPUT_SET_FINALL_STATE;
    end;

    DIGITAL_OUTPUT_SET_FINALL_STATE:
    begin
      Status := Byte(FFinalState);
      FState := DIGITAL_OUTPUT_DISABLED;
    end;
  end;
end;

{ Public declarations }

constructor TDigitalOutput.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FTimer := TTimer.Create(AOwner);
  FTimer.Interval := 5;
  FTimer.OnTimer := Run;
  FDevId := DID_UNKNOWN;
end;

procedure TDigitalOutput.CmdControl(Data: PDigitalOutputControlRec);
begin
  FInitialState := (Data^.States and 1) <> 0;
  FFinalState := (Data^.States and 2) <> 0;
  FDelay := Data^.Delay;
  FDuration := Data^.Duration;
  FBreakDevId := Data^.BreakDevId;
  FTerminateDevId := Data^.TerminateDevId;

  if (Data^.Delay = 0) and (Data^.Duration = 0) then
    FState := DIGITAL_OUTPUT_SET_FINALL_STATE
  else if Data^.Delay = 0 then
    FState := DIGITAL_OUTPUT_SET_INITIAL_STATE
  else
    FState := DIGITAL_OUTPUT_WAIT_INITIAL_STATE;
end;

procedure TDigitalOutput.CmdGetStatus;
var
  Data: TDigitalOutputStatusRec;
begin
  Data.Status := Status;
  SendCommand(CMD_DIGITAL_OUTPUT_STATUS, DevId, SizeOf(TDigitalOutputStatusRec), @Data);
end;

end.

