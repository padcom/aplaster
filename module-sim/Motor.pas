unit Motor;

interface

uses
  Classes, SysUtils, ExtCtrls,
  Device, DeviceIds, Protocol;

const
  MOTOR_DISABLED           = 0;
  MOTOR_WAIT_INITIAL_STATE = 1;
  MOTOR_SET_INITIAL_STATE  = 2;
  MOTOR_WAIT_FINAL_STATE   = 3;
  MOTOR_SET_FINALL_STATE   = 4;

type
  TGetDigitalInputStateEvent = procedure (Sender: TObject; DevId: Byte; var State: Boolean) of object;
  TSetMotorStateEvent = procedure (Sender: TObject; DevId: Byte; const State: Integer) of object;

  TMotor = class (TComponent)
  private
    FTimer: TTimer;
    FDevId: Byte;
    FState: Byte;
    FPolarity: Byte;
    FDelay: Word;
    FDuration: Word;
    FBreakDevId: Byte;
    FTerminateDevId: Byte;
    FOnSendCommand: TSendCommandEvent;
    FOnGetDigitalInputState: TGetDigitalInputStateEvent;
    FOnSetMotorState: TSetMotorStateEvent;
    function GetEnabled: Boolean;
    procedure SetEnabled(Value: Boolean);
    procedure SetPolarity(Value: Byte);
    procedure SendCommand(Command, DevId, DataSize: Byte; Data: Pointer);
    function GetDigitalInputState(DevId: Byte): Boolean;
    procedure SetMotorState(DevId: Byte; State: Integer);
  protected
    procedure Run(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    procedure CmdGetStatus;
    procedure CmdStart(Data: PMotorStartRec);
    procedure CmdStop(Data: PMotorStopRec);
    property Enabled: Boolean read GetEnabled write SetEnabled;
    property DevId: Byte read FDevId write FDevId;
    property Polarity: Byte read FPolarity write SetPolarity;
    property OnSendCommand: TSendCommandEvent read FOnSendCommand write FOnSendCommand;
    property OnGetDigitalInputState: TGetDigitalInputStateEvent read FOnGetDigitalInputState write FOnGetDigitalInputState;
    property OnSetMotorState: TSetMotorStateEvent read FOnSetMotorState write FOnSetMotorState;
  end;

implementation

{ TMotor }

{ Private declarations }

function TMotor.GetEnabled: Boolean;
begin
  Result := FTimer.Enabled;
end;

procedure TMotor.SetEnabled(Value: Boolean);
begin
  FTimer.Enabled := Value;
end;

procedure TMotor.SetPolarity(Value: Byte);
begin
  if FPolarity <> Value then
  begin
    FPolarity := Value;
    SetMotorState(DevId, Polarity);
    CmdGetStatus;
  end;
end;

procedure TMotor.SendCommand(Command, DevId, DataSize: Byte; Data: Pointer);
begin
  if Assigned(OnSendCommand) then
    OnSendCommand(Command, DevId, DataSize, Data);
end;

function TMotor.GetDigitalInputState(DevId: Byte): Boolean;
begin
  Result := False;
  if Assigned(FOnGetDigitalInputState) then
    FOnGetDigitalInputState(Self, DevId, Result);
end;

procedure TMotor.SetMotorState(DevId: Byte; State: Integer);
begin
  if Assigned(FOnSetMotorState) then
    FOnSetMotorState(Self, DevId, State);
end;

{ Protected declarations }

procedure TMotor.Run(Sender: TObject);
begin
  case FState of
    MOTOR_DISABLED:
      ;

    MOTOR_WAIT_INITIAL_STATE:
    begin
      if FDelay = 0 then
        FState := MOTOR_SET_INITIAL_STATE
      else
        Dec(FDelay);
    end;

    MOTOR_SET_INITIAL_STATE:
    begin
      SetMotorState(FDevId, FPolarity);
      case FPolarity of
        0: Polarity := 0;
        1: Polarity := 2;
        else Polarity := 1;
      end;

      if FDuration > 0 then
        FState := MOTOR_WAIT_FINAL_STATE
      else
        FState := MOTOR_SET_FINALL_STATE;
    end;

    MOTOR_WAIT_FINAL_STATE:
    begin
      if FDuration = 0 then
        FState := MOTOR_SET_FINALL_STATE
      else
        Dec(FDuration);

      if GetDigitalInputState(FBreakDevId) then
        Polarity := 1
      else
        case FPolarity of
          0: Polarity := 0;
          1: Polarity := 2;
        end;

      if GetDigitalInputState(FTerminateDevId) then
        FState := MOTOR_SET_FINALL_STATE;
    end;

    MOTOR_SET_FINALL_STATE:
    begin
      SetMotorState(DevId, 1);
      FState := MOTOR_DISABLED;
    end;
  end;
end;

{ Public declarations }

constructor TMotor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FTimer := TTimer.Create(AOwner);
  FTimer.Interval := 5;
  FTimer.OnTimer := Run;
  FDevId := DID_UNKNOWN;
end;

procedure TMotor.CmdGetStatus;
var
  Data: TMotorStatusRec;
begin
  Data.Direction := FPolarity;
  SendCommand(CMD_MOTOR_STATUS, FDevId, SizeOf(TMotorStatusRec), @Data);
end;

procedure TMotor.CmdStart(Data: PMotorStartRec);
begin
  FPolarity := Data^.Polarity;
  FDelay := Data^.Delay;
  FDuration := Data^.Duration;
  FBreakDevId := Data^.BreakDevId;
  FTerminateDevId := Data^.TerminateDevId;

  if (Data^.Delay = 0) and (Data^.Duration = 0) then
    FState := MOTOR_WAIT_FINAL_STATE
  else if Data^.Delay = 0 then
    FState := MOTOR_SET_INITIAL_STATE
  else
    FState := MOTOR_WAIT_INITIAL_STATE;
end;

procedure TMotor.CmdStop(Data: PMotorStopRec);
begin
  FState := 0;
  SetMotorState(DevId, 1);
end;

end.

