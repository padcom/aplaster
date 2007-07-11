unit DigitalInput;

interface

uses
  Classes, SysUtils, Log4D,
  Device, DeviceIds, Protocol;

type
  TDigitalInput = class (TComponent)
  private
    FDevId: Byte;
    FStatus: Byte;
    FOnSendCommand: TSendCommandEvent;
    procedure SetStatus(Value: Byte);
    procedure SendCommand(Command, DevId, DataSize: Byte; Data: Pointer);
  protected
    class function Log: TLogLogger;
  public
    constructor Create(AOwner: TComponent); override;
    procedure CmdGetStatus;
    property DevId: Byte read FDevId write FDevId;
    property Status: Byte read FStatus write SetStatus;
    property OnSendCommand: TSendCommandEvent read FOnSendCommand write FOnSendCommand;
  end;

implementation

{ TDigitalInput }

{ Private declarations }

procedure TDigitalInput.SetStatus(Value: Byte);
begin
  if FStatus <> Value then
  begin
    FStatus := Value;
    case Status of
      DIGITAL_INPUT_STATUS_ON:
        SendCommand(CMD_DIGITAL_INPUT_OPEN, DevId, 0, nil);
      DIGITAL_INPUT_STATUS_OFF:
        SendCommand(CMD_DIGITAL_INPUT_CLOSE, DevId, 0, nil);
    end;
  end;
end;

procedure TDigitalInput.SendCommand(Command, DevId, DataSize: Byte; Data: Pointer);
begin
  if Assigned(OnSendCommand) then
    OnSendCommand(Command, DevId, DataSize, Data);
end;

{ Protected declarations }

class function TDigitalInput.Log: TLogLogger;
begin
  Result := TLogLogger.GetLogger(Self);
end;

{ Public declarations }

constructor TDigitalInput.Create(AOwner: TComponent); 
begin
  inherited Create(AOwner);
  FDevId := DID_UNKNOWN;
end;

procedure TDigitalInput.CmdGetStatus;
var
  Data: TDigitalInputStatusRec;
begin
  Data.Status := Status;
  SendCommand(CMD_DIGITAL_INPUT_STATUS, DevId, SizeOf(TDigitalInputStatusRec), @Data);
end;

end.
