unit AnalogInput;

interface

uses
  Classes, SysUtils,
  Device, DeviceIds, Protocol;

type
  TAnalogInput = class (TComponent)
  private
    FDevId: Byte;
    FValue: Word;
    FHisteresis: Word;
    FOnSendCommand: TSendCommandEvent;
    procedure SetValue(const Value: Word);
    procedure SendCommand(Command, DevId, DataSize: Byte; Data: Pointer);
  public
    constructor Create(AOwner: TComponent); override;
    procedure CmdGetStatus;
    procedure CmdConfig(Config: PAnalogInputConfigRec);
    property DevId: Byte read FDevId write FDevId;
    property Value: Word read FValue write SetValue;
    property Histeresis: Word read FHisteresis write FHisteresis;
    property OnSendCommand: TSendCommandEvent read FOnSendCommand write FOnSendCommand;
  end;

implementation

{ TAnalogInput }

{ Private declarations }

procedure TAnalogInput.SetValue(const Value: Word);
var
  Data: TAnalogInputDataRec;
begin
  if Histeresis < Abs(Self.Value - Value) then
  begin
    FValue := Value;
    Data.Value := Value;
    SendCommand(CMD_ANALOG_INPUT_DATA, DevId, SizeOf(Data), @Data);
  end;
end;

procedure TAnalogInput.SendCommand(Command, DevId, DataSize: Byte; Data: Pointer);
begin
  if Assigned(OnSendCommand) then
    OnSendCommand(Command, DevId, DataSize, Data);
end;

{ Public declarations }

constructor TAnalogInput.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDevId := DID_UNKNOWN;
end;

procedure TAnalogInput.CmdGetStatus;
var
  Data: TAnalogInputStatusRec;
begin
  Data.Value := Value;
  SendCommand(CMD_ANALOG_INPUT_STATUS, DevId, SizeOf(TAnalogInputStatusRec), @Data);
end;

procedure TAnalogInput.CmdConfig(Config: PAnalogInputConfigRec);
begin
  Histeresis := Config^.Histeresis;
end;

end.

