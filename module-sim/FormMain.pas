// ----------------------------------------------------------------------------
// file: FormMain.pas - a part of AplaSter system
// date: 2005-09-08
// auth: Matthias Hryniszak
// desc: main form for module simulator
// ----------------------------------------------------------------------------

unit FormMain;

{$IFOPT D+}
  {$DEFINE DEBUG}
{$ENDIF}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, ComCtrls,
  Winsock, Protocol;

const
  RX_PORT     = 8001;
  TX_PORT     = 8000;

  WM_RXSOCKET = WM_USER + 1;
  WM_TXSOCKET = WM_USER + 2;

const
  DIGITAL_OUTPUT_DISABLED           = 0;
  DIGITAL_OUTPUT_WAIT_INITIAL_STATE = 1;
  DIGITAL_OUTPUT_SET_INITIAL_STATE  = 2;
  DIGITAL_OUTPUT_WAIT_FINAL_STATE   = 3;
  DIGITAL_OUTPUT_SET_FINALL_STATE   = 4;

  RELAY_DISABLED           = 0;
  RELAY_WAIT_INITIAL_STATE = 1;
  RELAY_SET_INITIAL_STATE  = 2;
  RELAY_WAIT_FINAL_STATE   = 3;
  RELAY_SET_FINALL_STATE   = 4;

  MOTOR_DISABLED           = 0;
  MOTOR_WAIT_INITIAL_STATE = 1;
  MOTOR_SET_INITIAL_STATE  = 2;
  MOTOR_WAIT_FINAL_STATE   = 3;
  MOTOR_SET_FINALL_STATE   = 4;

type
  PAnalogInputSM = ^TAnalogInputSM;
  TAnalogInputSM = record
    Histeresis: Word;
    PrevValue : Word;
  end;

  PDigitalOutputSM = ^TDigitalOutputSM;
  TDigitalOutputSM = record
    State         : Byte;
    InitialState  : Boolean;
    FinalState    : Boolean;
    Delay         : Word;
    Duration      : Word;
    BreakDevId    : Byte;
    TerminateDevId: Byte;
  end;

  PRelaySM = ^TRelaySM;
  TRelaySM = record
    State         : Byte;
    InitialState  : Boolean;
    FinalState    : Boolean;
    Delay         : Word;
    Duration      : Word;
    BreakDevId    : Byte;
    TerminateDevId: Byte;
  end;

  PMotorSM = ^TMotorSM;
  TMotorSM = record
    State         : Byte;
    Polarity      : Byte;
    Delay         : Word;
    Duration      : Word;
    BreakDevId    : Byte;
    TerminateDevId: Byte;
  end;

  TFrmMain = class(TForm)
    GbxAnalogInput: TGroupBox;
    AN0: TTrackBar;
    LblAN0: TLabel;
    AN1: TTrackBar;
    LblAN1: TLabel;
    GbxDigitalInput: TGroupBox;
    DI0: TSpeedButton;
    DI1: TSpeedButton;
    DI2: TSpeedButton;
    DI3: TSpeedButton;
    DI4: TSpeedButton;
    DI5: TSpeedButton;
    DI6: TSpeedButton;
    DI7: TSpeedButton;
    GbxDigitalOutput: TGroupBox;
    DO0: TSpeedButton;
    DO1: TSpeedButton;
    DO2: TSpeedButton;
    DO3: TSpeedButton;
    DO4: TSpeedButton;
    DO5: TSpeedButton;
    GbxRelay: TGroupBox;
    RE0: TSpeedButton;
    RE1: TSpeedButton;
    RE2: TSpeedButton;
    GbxWiegand: TGroupBox;
    WIEGAND0: TEdit;
    Wiegand0Send: TSpeedButton;
    LblWiegand0: TLabel;
    WIEGAND1: TEdit;
    Wiegand1Send: TSpeedButton;
    LblWiegand1: TLabel;
    GbxRS232: TGroupBox;
    RS2320: TEdit;
    RS2320Send: TSpeedButton;
    LblRS2320: TLabel;
    GbxMotor: TRadioGroup;
    BtnDebug1: TButton;
    BtnDebug2: TButton;
    BtnDebug3: TButton;
    BtnDebug4: TButton;
    BtnDebug5: TButton;
    BtnDebug6: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormResize(Sender: TObject);
    procedure AN0Change(Sender: TObject);
    procedure AN1Change(Sender: TObject);
    procedure DI0Click(Sender: TObject);
    procedure DI1Click(Sender: TObject);
    procedure DI2Click(Sender: TObject);
    procedure DI3Click(Sender: TObject);
    procedure DI4Click(Sender: TObject);
    procedure DI5Click(Sender: TObject);
    procedure DI6Click(Sender: TObject);
    procedure DI7Click(Sender: TObject);
    procedure Wiegand0SendClick(Sender: TObject);
    procedure Wiegand1SendClick(Sender: TObject);
    procedure RS2320SendClick(Sender: TObject);
    procedure BtnDebug1Click(Sender: TObject);
    procedure BtnDebug2Click(Sender: TObject);
    procedure BtnDebug3Click(Sender: TObject);
    procedure BtnDebug4Click(Sender: TObject);
    procedure BtnDebug5Click(Sender: TObject);
    procedure BtnDebug6Click(Sender: TObject);
  private
    { Private declarations }
    FRxSocket: TSocket;
    FTxSocket: TSocket;
    FDevices: array of record
      DevId: Byte;
      Timer: TTimer;
    end;
    FAnalogInput: array of TAnalogInputSM;
    FDigitalOutput: array of TDigitalOutputSM;
    FRelay: array of TRelaySM;
    FMotor: array of TMotorSM;

    procedure AssignLanguage;
    procedure CreateSockets;
    procedure ProcessCommand(Buffer: array of Byte; BufferSize: Integer);
    procedure SendCommand(Command, DevId, DataSize: Byte; Data: Pointer);

    // commands send from server to module
    procedure ResetSimulator;
    procedure ReceiveNetworkConfig(Config: PModuleNetworkConfigRec);
    procedure AnalogInputConfig(DevId: Byte; Config: PAnalogInputConfigRec);
    procedure AnalogInputGetStatus(DevId: Byte);
    procedure DigitalInputGetStatus(DevId: Byte);
    procedure DigitalOutputControl(DevId: Byte; Data: PDigitalOutputControlRec);
    procedure DigitalOutputGetStatus(DevId: Byte);
    procedure RelayControl(DevId: Byte; Data: PRelayControlRec);
    procedure RelayGetStatus(DevId: Byte);
    procedure WiegandSetConfig(DevId: Byte; Data: PWiegandConfigRec);
    procedure RS232Data(DevId: Byte; Data: PRS232DataRec; DataSize: Byte);
    procedure RS232SetConfig(DevId: Byte; Data: PRS232ConfigRec);
    procedure MotorStart(DevId: Byte; Data: PMotorStartRec);
    procedure MotorStop(DevId: Byte; Data: PMotorStopRec);

    // device handlers
    procedure CreateDevices;
    function GetDigitalInput(DevId: Integer): TSpeedButton;
    procedure DigitalOutput(Sender: TObject);
    procedure Relay(Sender: TObject);
    procedure Motor(Sender: TObject);
  protected
    procedure WndProc(var Msg: TMessage); override;
  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;

implementation

uses
  Resources, DeviceIds, Math;

{$R *.dfm}

{ Private declarations }

procedure TFrmMain.AssignLanguage;
begin
  Caption := SModuleSimulator;
  Application.Title := SModuleSimulator;
  GbxAnalogInput.Caption := SAnalogInput;
  GbxDigitalInput.Caption := SDigitalInput;
  GbxDigitalOutput.Caption := SDigitalOutput;
  GbxRelay.Caption := SRelay;
  GbxWiegand.Caption := SWiegand;
  Wiegand0Send.Caption := SSend;
  Wiegand1Send.Caption := SSend;
  GbxRS232.Caption := SRS232;
  RS2320Send.Caption := SSend;
  GbxMotor.Caption := SMotor;
  BtnDebug1.Hint := SDebug1Hint;
  BtnDebug2.Hint := SDebug2Hint;
  BtnDebug3.Hint := SDebug3Hint;
  BtnDebug4.Hint := SDebug4Hint;
  BtnDebug5.Hint := SDebug5Hint;
  BtnDebug6.Hint := SDebug6Hint;
end;

procedure TFrmMain.CreateSockets;
var
  Addr: TSockAddrIn;
begin
  // socket to receive packets
  FRxSocket := socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
  if FRxSocket = INVALID_SOCKET then
    raise Exception.CreateFmt('Error: cannot create socket (%d)', [WSAGetLastError]);
  Addr.sin_family := AF_INET;
  Addr.sin_port := htons(RX_PORT);
  Addr.sin_addr.S_addr := INADDR_ANY;
  if bind(FRxSocket, Addr, SizeOf(Addr)) <> 0 then
    raise Exception.CreateFmt('Error: cannot bind socket (%d)', [WSAGetLastError]);
  WSAAsyncSelect(FRxSocket, Handle, WM_RXSOCKET, FD_READ);

  // socket to transmit packets
  FTxSocket := socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
  if FTxSocket = INVALID_SOCKET then
    raise Exception.CreateFmt('Error: cannot create socket (%d)', [WSAGetLastError]);
end;

// ----------------------------------------------------------------------------
// Sending and receiving commands
// ----------------------------------------------------------------------------

procedure TFrmMain.ProcessCommand(Buffer: array of Byte; BufferSize: Integer);
var
  Header: PPacketHeader;
  Data: Pointer;
begin
  // check data retrieval
  if BufferSize < SizeOf(TPacketHeader) then
    Exit;

  // map pointers to buffer
  Header := @Buffer[0];
  if Header^.DataSize > 0 then
    Data := @Buffer[SizeOf(TPacketHeader)]
  else
    Data := nil;

  // check data retrieval begin
  if Length(Buffer) < SizeOf(TPacketHeader) + Header^.DataSize then
    Exit;

  // process commands
  case Header^.Command of
    CMD_MODULE_PING:
      SendCommand(CMD_MODULE_PONG, 0, 0, nil);
    CMD_MODULE_RESET:
      ResetSimulator;
    CMD_MODULE_NETWORK_CONFIG:
      ReceiveNetworkConfig(Data);
    CMD_ANALOG_INPUT_CONFIG:
      AnalogInputConfig(Header^.DevId, Data);
    CMD_ANALOG_INPUT_GET_STATUS:
      AnalogInputGetStatus(Header^.DevId);
    CMD_DIGITAL_INPTUT_GET_STATUS:
      DigitalInputGetStatus(Header^.DevId);
    CMD_DIGITAL_OUTPUT_CONTROL:
      DigitalOutputControl(Header^.DevId, Data);
    CMD_DIGITAL_OUTPUT_GET_STATUS:
      DigitalOutputGetStatus(Header^.DevId);
    CMD_RELAY_CONTROL:
      RelayControl(Header^.DevId, Data);
    CMD_RELAY_GET_STATUS:
      RelayGetStatus(Header^.DevId);
    CMD_WIEGAND_CONFIG:
      WiegandSetConfig(Header^.DevId, Data);
    CMD_RS232_DATA:
      RS232Data(Header^.DevId, Data, Header^.DataSize);
    CMD_RS232_CONFIG:
      RS232SetConfig(Header^.DevId, Data);
    CMD_MOTOR_START:
      MotorStart(Header^.DevId, Data);
    CMD_MOTOR_STOP:
      MotorStop(Header^.DevId, Data);
  end;
end;

procedure TFrmMain.SendCommand(Command, DevId, DataSize: Byte; Data: Pointer);
var
  Buffer: array of Byte;
  Header: PPacketHeader;
  Addr: TSockAddrIn;
begin
  SetLength(Buffer, SizeOf(TPacketHeader) + DataSize);
  Header := @Buffer[0];
  Header^.Command := Command;
  Header^.DevId := DevId;
  Header^.DataSize := DataSize;
  if DataSize > 0 then
    Move(Data^, Buffer[SizeOf(TPacketHeader)], DataSize);

  // commands are send only to localhost (test setup!)
  Addr.sin_family := AF_INET;
  Addr.sin_port := htons(TX_PORT);
  Addr.sin_addr.S_addr := inet_addr('127.0.0.1');
  sendto(FTxSocket, Buffer[0], Length(Buffer), 0, Addr, SizeOf(Addr));
end;

// ----------------------------------------------------------------------------
// Commands the emulator is reacting on
// ----------------------------------------------------------------------------

procedure TFrmMain.ResetSimulator;
begin
  Close;
end;

procedure TFrmMain.ReceiveNetworkConfig(Config: PModuleNetworkConfigRec);
begin
// todo: process network configuration packet
end;

procedure TFrmMain.AnalogInputConfig(DevId: Byte; Config: PAnalogInputConfigRec);
begin
  case DevId of
    DID_ANALOGINPUT0:
      FAnalogInput[0].Histeresis := Config^.Histeresis;
    DID_ANALOGINPUT1:
      FAnalogInput[1].Histeresis := Config^.Histeresis;
  end;
end;

procedure TFrmMain.AnalogInputGetStatus(DevId: Byte);
var
  Data: TAnalogInputStatusRec;
begin
  case DevId of
    DID_ANALOGINPUT0:
    begin
      Data.Value := AN0.Position;
      SendCommand(CMD_ANALOG_INPUT_STATUS, DevId, SizeOf(TAnalogInputStatusRec), @Data);
    end;
    DID_ANALOGINPUT1:
    begin
      Data.Value := AN1.Position;
      SendCommand(CMD_ANALOG_INPUT_STATUS, DevId, SizeOf(TAnalogInputStatusRec), @Data);
    end;
  end;
end;

procedure TFrmMain.DigitalInputGetStatus(DevId: Byte);
var
  Data: TDigitalInputStatusRec;
begin
  case DevId of
    DID_DIGITALINPUT0:
    begin
      Data.Status := Byte(DI0.Down);
      SendCommand(CMD_DIGITAL_INPTUT_STATUS, DevId, SizeOf(TDigitalInputStatusRec), @Data);
    end;
    DID_DIGITALINPUT1:
    begin
      Data.Status := Byte(DI1.Down);
      SendCommand(CMD_DIGITAL_INPTUT_STATUS, DevId, SizeOf(TDigitalInputStatusRec), @Data);
    end;
    DID_DIGITALINPUT2:
    begin
      Data.Status := Byte(DI2.Down);
      SendCommand(CMD_DIGITAL_INPTUT_STATUS, DevId, SizeOf(TDigitalInputStatusRec), @Data);
    end;
    DID_DIGITALINPUT3:
    begin
      Data.Status := Byte(DI3.Down);
      SendCommand(CMD_DIGITAL_INPTUT_STATUS, DevId, SizeOf(TDigitalInputStatusRec), @Data);
    end;
    DID_DIGITALINPUT4:
    begin
      Data.Status := Byte(DI4.Down);
      SendCommand(CMD_DIGITAL_INPTUT_STATUS, DevId, SizeOf(TDigitalInputStatusRec), @Data);
    end;
    DID_DIGITALINPUT5:
    begin
      Data.Status := Byte(DI5.Down);
      SendCommand(CMD_DIGITAL_INPTUT_STATUS, DevId, SizeOf(TDigitalInputStatusRec), @Data);
    end;
    DID_DIGITALINPUT6:
    begin
      Data.Status := Byte(DI6.Down);
      SendCommand(CMD_DIGITAL_INPTUT_STATUS, DevId, SizeOf(TDigitalInputStatusRec), @Data);
    end;
    DID_DIGITALINPUT7:
    begin
      Data.Status := Byte(DI7.Down);
      SendCommand(CMD_DIGITAL_INPTUT_STATUS, DevId, SizeOf(TDigitalInputStatusRec), @Data);
    end;
  end;
end;

procedure TFrmMain.DigitalOutputControl(DevId: Byte; Data: PDigitalOutputControlRec);
var
  DigitalOutput: PDigitalOutputSM;
begin
  DigitalOutput := nil;
  case DevId of
    DID_DIGITALOUTPUT0:
      DigitalOutput := @FDigitalOutput[0];
    DID_DIGITALOUTPUT1:
      DigitalOutput := @FDigitalOutput[1];
    DID_DIGITALOUTPUT2:
      DigitalOutput := @FDigitalOutput[2];
    DID_DIGITALOUTPUT3:
      DigitalOutput := @FDigitalOutput[3];
    DID_DIGITALOUTPUT4:
      DigitalOutput := @FDigitalOutput[4];
    DID_DIGITALOUTPUT5:
      DigitalOutput := @FDigitalOutput[5];
  end;

  if Assigned(DigitalOutput) then
  begin
    DigitalOutput^.InitialState := (Data^.States and 1) <> 0;
    DigitalOutput^.FinalState := (Data^.States and 2) <> 0;
    DigitalOutput^.Delay := Data^.Delay;
    DigitalOutput^.Duration := Data^.Duration;
    DigitalOutput^.BreakDevId := Data^.BreakDevId;
    DigitalOutput^.TerminateDevId := Data^.TerminateDevId;

    if (Data^.Delay = 0) and (Data^.Duration = 0) then
      DigitalOutput^.State := DIGITAL_OUTPUT_SET_FINALL_STATE
    else if Data^.Delay = 0 then
      DigitalOutput^.State := DIGITAL_OUTPUT_SET_INITIAL_STATE
    else
      DigitalOutput^.State := DIGITAL_OUTPUT_WAIT_INITIAL_STATE;
  end;
end;

procedure TFrmMain.DigitalOutputGetStatus(DevId: Byte);
var
  Data: TDigitalOutputStatusRec;
begin
  case DevId of
    DID_DIGITALOUTPUT0:
    begin
      Data.Status := Byte(DI0.Down);
      SendCommand(CMD_DIGITAL_OUTPUT_STATUS, DevId, SizeOf(TDigitalOutputStatusRec), @Data);
    end;
    DID_DIGITALOUTPUT1:
    begin
      Data.Status := Byte(DO1.Down);
      SendCommand(CMD_DIGITAL_OUTPUT_STATUS, DevId, SizeOf(TDigitalOutputStatusRec), @Data);
    end;
    DID_DIGITALOUTPUT2:
    begin
      Data.Status := Byte(DO2.Down);
      SendCommand(CMD_DIGITAL_OUTPUT_STATUS, DevId, SizeOf(TDigitalOutputStatusRec), @Data);
    end;
    DID_DIGITALOUTPUT3:
    begin
      Data.Status := Byte(DO3.Down);
      SendCommand(CMD_DIGITAL_OUTPUT_STATUS, DevId, SizeOf(TDigitalOutputStatusRec), @Data);
    end;
    DID_DIGITALOUTPUT4:
    begin
      Data.Status := Byte(DO4.Down);
      SendCommand(CMD_DIGITAL_OUTPUT_STATUS, DevId, SizeOf(TDigitalOutputStatusRec), @Data);
    end;
    DID_DIGITALOUTPUT5:
    begin
      Data.Status := Byte(DO5.Down);
      SendCommand(CMD_DIGITAL_OUTPUT_STATUS, DevId, SizeOf(TDigitalOutputStatusRec), @Data);
    end;
  end;
end;

procedure TFrmMain.RelayControl(DevId: Byte; Data: PRelayControlRec);
var
  Relay: PRelaySM;
begin
  Relay := nil;
  case DevId of
    DID_RELAY0:
      Relay := @FRelay[0];
    DID_RELAY1:
      Relay := @FRelay[1];
    DID_RELAY2:
      Relay := @FRelay[2];
  end;

  if Assigned(Relay) then
  begin
    Relay^.InitialState := (Data^.States and 1) <> 0;
    Relay^.FinalState := (Data^.States and 2) <> 0;
    Relay^.Delay := Data^.Delay;
    Relay^.Duration := Data^.Duration;
    Relay^.BreakDevId := Data^.BreakDevId;
    Relay^.TerminateDevId := Data^.TerminateDevId;

    if (Data^.Delay = 0) and (Data^.Duration = 0) then
      Relay^.State := RELAY_SET_FINALL_STATE
    else if Data^.Delay = 0 then
      Relay^.State := RELAY_SET_INITIAL_STATE
    else
      Relay^.State := RELAY_WAIT_INITIAL_STATE;
  end;
end;

procedure TFrmMain.RelayGetStatus(DevId: Byte);
var
  Data: TRelayStatusRec;
begin
  case DevId of
    DID_RELAY0:
    begin
      Data.Status := Byte(RE0.Down);
      SendCommand(CMD_RELAY_STATUS, DevId, SizeOf(TRelayStatusRec), @Data);
    end;
    DID_RELAY1:
    begin
      Data.Status := Byte(RE1.Down);
      SendCommand(CMD_RELAY_STATUS, DevId, SizeOf(TRelayStatusRec), @Data);
    end;
    DID_RELAY2:
    begin
      Data.Status := Byte(RE2.Down);
      SendCommand(CMD_RELAY_STATUS, DevId, SizeOf(TRelayStatusRec), @Data);
    end;
  end;
end;

procedure TFrmMain.WiegandSetConfig(DevId: Byte; Data: PWiegandConfigRec);
begin
// todo: set wiegand's data length in bits (Data^.Bits)
end;

procedure TFrmMain.RS232Data(DevId: Byte; Data: PRS232DataRec; DataSize: Byte);
var
  S: string;
begin
  case DevId of
    DID_RS2320:
    begin
      SetLength(S, DataSize);
      Move(Data^.Data, S[1], DataSize);
      RS2320.Text := S;
    end;
  end;
end;

procedure TFrmMain.RS232SetConfig(DevId: Byte; Data: PRS232ConfigRec);
begin
// todo: set RS232's parameters
end;

procedure TFrmMain.MotorStart(DevId: Byte; Data: PMotorStartRec);
var
  Motor: PMotorSM;
begin
  Motor := nil;
  case DevId of
    DID_MOTOR0:
      Motor := @FMotor[0];
  end;

  if Assigned(Motor) then
  begin
    Motor^.Polarity := Data^.Polarity;
    Motor^.Delay := Data^.Delay;
    Motor^.Duration := Data^.Duration;
    Motor^.BreakDevId := Data^.BreakDevId;
    Motor^.TerminateDevId := Data^.TerminateDevId;

    if (Data^.Delay = 0) and (Data^.Duration = 0) then
      Motor^.State := MOTOR_WAIT_FINAL_STATE
    else if Data^.Delay = 0 then
      Motor^.State := MOTOR_SET_INITIAL_STATE
    else
      Motor^.State := MOTOR_WAIT_INITIAL_STATE;
  end;
end;

procedure TFrmMain.MotorStop(DevId: Byte; Data: PMotorStopRec);
begin
  case DevId of
    DID_MOTOR0:
    begin
      FMotor[0].State := 0;
      GbxMotor.ItemIndex := 1;
    end;
  end;
end;

// ----------------------------------------------------------------------------
// Internal state machines to control devices 
// ----------------------------------------------------------------------------

procedure TFrmMain.CreateDevices;
var
  I, Index: Integer;
begin
  SetLength(FAnalogInput, 2);
  for I := 0 to Length(FAnalogInput) - 1 do
  begin
    FAnalogInput[I].Histeresis := 0;
    FAnalogInput[I].PrevValue := 0;
  end;

  SetLength(FDigitalOutput, 8);
  for I := 0 to Length(FDigitalOutput) - 1 do
    FDigitalOutput[I].State := 0;

  SetLength(FRelay, 3);
  for I := 0 to Length(FRelay) - 1 do
    FRelay[I].State := 0;

  SetLength(FMotor, 1);
  for I := 0 to Length(FMotor) - 1 do
    FMotor[I].State := 0;

  SetLength(FDevices, 8 + 3 + 1);
  Index := 0;
  for I := 0 to 7 do
  begin
    FDevices[Index].DevId := DID_DIGITALOUTPUT0 + I;
    FDevices[Index].Timer := TTimer.Create(Self);
    FDevices[Index].Timer.OnTimer := DigitalOutput;
    Inc(Index);
  end;
  for I := 0 to 2 do
  begin
    FDevices[Index].DevId := DID_RELAY0 + I;
    FDevices[Index].Timer := TTimer.Create(Self);
    FDevices[Index].Timer.OnTimer := Relay;
    Inc(Index);
  end;
  for I := 0 to 0 do
  begin
    FDevices[Index].DevId := DID_MOTOR0 + I;
    FDevices[Index].Timer := TTimer.Create(Self);
    FDevices[Index].Timer.OnTimer := Motor;
    Inc(Index);
  end;

  for I := 0 to Length(FDevices) - 1 do
  begin
    FDevices[I].Timer.Interval := 5;
    FDevices[I].Timer.Enabled := True;
  end;
end;

function TFrmMain.GetDigitalInput(DevId: Integer): TSpeedButton;
begin
  case DevId of
    DID_DIGITALINPUT0:
      Result := DI0;
    DID_DIGITALINPUT1:
      Result := DI1;
    DID_DIGITALINPUT2:
      Result := DI2;
    DID_DIGITALINPUT3:
      Result := DI3;
    DID_DIGITALINPUT4:
      Result := DI4;
    DID_DIGITALINPUT5:
      Result := DI5;
    DID_DIGITALINPUT6:
      Result := DI6;
    DID_DIGITALINPUT7:
      Result := DI7;
    else
      Result := nil;
  end;
end;

procedure TFrmMain.DigitalOutput(Sender: TObject);
var
  I: Integer;
  DevId: Byte;
  DigitalOutput: PDigitalOutputSM;
  DigitalOutputDev: TSpeedButton;
  BreakDev, TerminateDev: TSpeedButton;
  StatusRec: TDigitalOutputStatusRec;
begin
  DevId := 255;
  for I := 0 to Length(FDevices) - 1 do
    if FDevices[I].Timer = Sender then
    begin
      DevId := FDevices[I].DevId;
      Break;
    end;

  DigitalOutput := nil;
  case DevId of
    DID_DIGITALOUTPUT0:
      DigitalOutput := @FDigitalOutput[0];
    DID_DIGITALOUTPUT1:
      DigitalOutput := @FDigitalOutput[1];
    DID_DIGITALOUTPUT2:
      DigitalOutput := @FDigitalOutput[2];
    DID_DIGITALOUTPUT3:
      DigitalOutput := @FDigitalOutput[3];
    DID_DIGITALOUTPUT4:
      DigitalOutput := @FDigitalOutput[4];
    DID_DIGITALOUTPUT5:
      DigitalOutput := @FDigitalOutput[5];
  end;

  if Assigned(DigitalOutput) then
  begin
    DigitalOutputDev := nil;
    case DevId of
      DID_DIGITALOUTPUT0:
        DigitalOutputDev := DO0;
      DID_DIGITALOUTPUT1:
        DigitalOutputDev := DO1;
      DID_DIGITALOUTPUT2:
        DigitalOutputDev := DO2;
      DID_DIGITALOUTPUT3:
        DigitalOutputDev := DO3;
      DID_DIGITALOUTPUT4:
        DigitalOutputDev := DO4;
      DID_DIGITALOUTPUT5:
        DigitalOutputDev := DO5;
    end;
    BreakDev := GetDigitalInput(DigitalOutput^.BreakDevId);
    TerminateDev := GetDigitalInput(DigitalOutput^.TerminateDevId);

    case DigitalOutput^.State of
      DIGITAL_OUTPUT_DISABLED:
        ;

      DIGITAL_OUTPUT_WAIT_INITIAL_STATE:
      begin
        if DigitalOutput^.Delay = 0 then
          DigitalOutput^.State := DIGITAL_OUTPUT_SET_INITIAL_STATE;
        Dec(DigitalOutput^.Delay);
      end;

      DIGITAL_OUTPUT_SET_INITIAL_STATE:
      begin
        DigitalOutputDev.Down := DigitalOutput^.InitialState;

        if DigitalOutput^.Duration > 0 then
          DigitalOutput^.State := DIGITAL_OUTPUT_WAIT_FINAL_STATE
        else
          DigitalOutput^.State := DIGITAL_OUTPUT_SET_FINALL_STATE;

        StatusRec.Status := Byte(DigitalOutput^.InitialState);
        SendCommand(CMD_DIGITAL_OUTPUT_STATUS, DevId, SizeOf(StatusRec), @StatusRec);
      end;

      DIGITAL_OUTPUT_WAIT_FINAL_STATE:
      begin
        if DigitalOutput^.Duration = 0 then
          DigitalOutput^.State := DIGITAL_OUTPUT_SET_FINALL_STATE;
        Dec(DigitalOutput^.Duration);

        if Assigned(BreakDev) and BreakDev.Down then
          DigitalOutputDev.Down := not DigitalOutput^.InitialState
        else if Assigned(BreakDev) then
          DigitalOutputDev.Down := DigitalOutput^.InitialState;

        if Assigned(TerminateDev) and TerminateDev.Down then
          DigitalOutput.State := DIGITAL_OUTPUT_SET_FINALL_STATE;
      end;

      DIGITAL_OUTPUT_SET_FINALL_STATE:
      begin
        DigitalOutputDev.Down := DigitalOutput^.FinalState;
        DigitalOutput^.State := DIGITAL_OUTPUT_DISABLED;

        StatusRec.Status := Byte(DigitalOutput^.FinalState);
        SendCommand(CMD_DIGITAL_OUTPUT_STATUS, DevId, SizeOf(StatusRec), @StatusRec);
      end;
    end;
  end;
end;

procedure TFrmMain.Relay(Sender: TObject);
var
  I: Integer;
  DevId: Byte;
  Relay: PRelaySM;
  RelayDev: TSpeedButton;
  BreakDev, TerminateDev: TSpeedButton;
  StatusRec: TRelayStatusRec;
begin
  DevId := 255;
  for I := 0 to Length(FDevices) - 1 do
    if FDevices[I].Timer = Sender then
    begin
      DevId := FDevices[I].DevId;
      Break;
    end;

  Relay := nil;
  case DevId of
    DID_RELAY0:
      Relay := @FRelay[0];
    DID_RELAY1:
      Relay := @FRelay[1];
    DID_RELAY2:
      Relay := @FRelay[2];
  end;

  if Assigned(Relay) then
  begin
    RelayDev := nil;
    case DevId of
      DID_RELAY0:
        RelayDev := RE0;
      DID_RELAY1:
        RelayDev := RE1;
      DID_RELAY2:
        RelayDev := RE2;
    end;
    BreakDev := GetDigitalInput(Relay^.BreakDevId);
    TerminateDev := GetDigitalInput(Relay^.TerminateDevId);

    case Relay^.State of
      RELAY_DISABLED:
        ;

      RELAY_WAIT_INITIAL_STATE:
      begin
        if Relay^.Delay = 0 then
          Relay^.State := RELAY_SET_INITIAL_STATE;
        Dec(Relay^.Delay);
      end;

      RELAY_SET_INITIAL_STATE:
      begin
        RelayDev.Down := Relay^.InitialState;

        if Relay^.Duration > 0 then
          Relay^.State := RELAY_WAIT_FINAL_STATE
        else
          Relay^.State := RELAY_SET_FINALL_STATE;

        StatusRec.Status := Byte(Relay^.InitialState);
        SendCommand(CMD_RELAY_STATUS, DevId, SizeOf(StatusRec), @StatusRec);
      end;

      RELAY_WAIT_FINAL_STATE:
      begin
        if Relay^.Duration = 0 then
          Relay^.State := RELAY_SET_FINALL_STATE;
        Dec(Relay^.Duration);

        if Assigned(BreakDev) and BreakDev.Down then
          RelayDev.Down := not Relay^.InitialState
        else if Assigned(BreakDev) then
          RelayDev.Down := Relay^.InitialState;

        if Assigned(TerminateDev) and TerminateDev.Down then
          Relay.State := RELAY_SET_FINALL_STATE;
      end;

      RELAY_SET_FINALL_STATE:
      begin
        RelayDev.Down := Relay^.FinalState;
        Relay^.State := RELAY_DISABLED;

        StatusRec.Status := Byte(Relay^.FinalState);
        SendCommand(CMD_RELAY_STATUS, DevId, SizeOf(StatusRec), @StatusRec);
      end;
    end;
  end;
end;

procedure TFrmMain.Motor(Sender: TObject);
var
  I: Integer;
  DevId: Byte;
  Motor: PMotorSM;
  MotorDev: TRadioGroup;
  BreakDev: TSpeedButton;
  TerminateDev: TSpeedButton;
begin
  DevId := 255;
  for I := 0 to Length(FDevices) - 1 do
    if FDevices[I].Timer = Sender then
    begin
      DevId := FDevices[I].DevId;
      Break;
    end;

  case DevId of
    DID_MOTOR0:
      Motor := @FMotor[0];
    else
      Motor := nil;
  end;

  if Assigned(Motor) then
  begin
    MotorDev := nil;
    case DevId of
      DID_MOTOR0:
        MotorDev := GbxMotor;
    end;
    BreakDev := GetDigitalInput(Motor^.BreakDevId);
    TerminateDev := GetDigitalInput(Motor^.TerminateDevId);

    case Motor^.State of
      MOTOR_DISABLED:
        ;

      MOTOR_WAIT_INITIAL_STATE:
      begin
        if Motor^.Delay = 0 then
          Motor^.State := MOTOR_SET_INITIAL_STATE;
        Dec(Motor^.Delay);
      end;

      MOTOR_SET_INITIAL_STATE:
      begin
        case Motor^.Polarity of
          0: MotorDev.ItemIndex := 0;
          1: MotorDev.ItemIndex := 2;
          else MotorDev.ItemIndex := 1;
        end;

        if Motor^.Duration > 0 then
          Motor^.State := MOTOR_WAIT_FINAL_STATE
        else
          Motor^.State := MOTOR_SET_FINALL_STATE;
      end;

      MOTOR_WAIT_FINAL_STATE:
      begin
        if Motor^.Duration = 0 then
          Motor^.State := MOTOR_SET_FINALL_STATE;
        Dec(Motor^.Duration);

        if Assigned(BreakDev) and BreakDev.Down then
          MotorDev.ItemIndex := 1
        else if Assigned(BreakDev) then
          case Motor^.Polarity of
            0: MotorDev.ItemIndex := 0;
            1: MotorDev.ItemIndex := 2;
          end;

        if Assigned(TerminateDev) and TerminateDev.Down then
          Motor.State := MOTOR_SET_FINALL_STATE;
      end;

      MOTOR_SET_FINALL_STATE:
      begin
        MotorDev.ItemIndex := 1;
        Motor^.State := MOTOR_DISABLED;
      end;
    end;
  end;
end;

{ Protected declarations }

procedure TFrmMain.WndProc(var Msg: TMessage);
var
  Addr: TSockAddrIn;
  AddrLen: Integer;
  Buffer: array of Byte;
  Count: Integer;
begin
  inherited WndProc(Msg);
  case Msg.Msg of
    WM_RXSOCKET:
      case Msg.lParam of
        FD_READ:
        begin
          SetLength(Buffer, 1024);
          ZeroMemory(@Addr, SizeOf(Addr));
          AddrLen := SizeOf(Addr);
          Count := recvfrom(Msg.wParam, Buffer[0], Length(Buffer), 0, Addr, AddrLen);
          if Count > 0 then
          begin
            SetLength(Buffer, Count);
            ProcessCommand(Buffer, Length(Buffer));
          end;
        end;
      end;
  end;
end;

{ Public declarations }

procedure TFrmMain.FormCreate(Sender: TObject);
var
  WSAData: TWSAData;
begin
  AssignLanguage;
  WSAStartup($101, WSAData);
  CreateSockets;
end;

procedure TFrmMain.FormDestroy(Sender: TObject);
begin
  closesocket(FRxSocket);
  closesocket(FTxSocket);
  WSACleanup;
end;

procedure TFrmMain.FormShow(Sender: TObject);
begin
  CreateDevices;
end;

procedure TFrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
//
end;

procedure TFrmMain.FormResize(Sender: TObject);
begin
//
end;

procedure TFrmMain.AN0Change(Sender: TObject);
var
  Data: TAnalogInputDataRec;
begin
  if FAnalogInput[0].Histeresis < Abs(FAnalogInput[0].PrevValue - AN0.Position) then
  begin
    FAnalogInput[0].PrevValue := AN0.Position;
    Data.Value := AN0.Position;
    SendCommand(CMD_ANALOG_INPUT_DATA, DID_ANALOGINPUT0, SizeOf(Data), @Data);
  end;
end;

procedure TFrmMain.AN1Change(Sender: TObject);
var
  Data: TAnalogInputDataRec;
begin
  if FAnalogInput[1].Histeresis < Abs(FAnalogInput[1].PrevValue - AN1.Position) then
  begin
    FAnalogInput[1].PrevValue := AN1.Position;
    Data.Value := AN1.Position;
    SendCommand(CMD_ANALOG_INPUT_DATA, DID_ANALOGINPUT1, SizeOf(Data), @Data);
  end;
end;

procedure TFrmMain.DI0Click(Sender: TObject);
begin
  if DI0.Down then
    SendCommand(CMD_DIGITAL_INPTUT_CLOSE, DID_DIGITALINPUT0, 0, nil)
  else
    SendCommand(CMD_DIGITAL_INPTUT_OPEN, DID_DIGITALINPUT0, 0, nil)
end;

procedure TFrmMain.DI1Click(Sender: TObject);
begin
  if DI1.Down then
    SendCommand(CMD_DIGITAL_INPTUT_CLOSE, DID_DIGITALINPUT1, 0, nil)
  else
    SendCommand(CMD_DIGITAL_INPTUT_OPEN, DID_DIGITALINPUT1, 0, nil)
end;

procedure TFrmMain.DI2Click(Sender: TObject);
begin
  if DI2.Down then
    SendCommand(CMD_DIGITAL_INPTUT_CLOSE, DID_DIGITALINPUT2, 0, nil)
  else
    SendCommand(CMD_DIGITAL_INPTUT_OPEN, DID_DIGITALINPUT2, 0, nil)
end;

procedure TFrmMain.DI3Click(Sender: TObject);
begin
  if DI3.Down then
    SendCommand(CMD_DIGITAL_INPTUT_CLOSE, DID_DIGITALINPUT3, 0, nil)
  else
    SendCommand(CMD_DIGITAL_INPTUT_OPEN, DID_DIGITALINPUT3, 0, nil)
end;

procedure TFrmMain.DI4Click(Sender: TObject);
begin
  if DI4.Down then
    SendCommand(CMD_DIGITAL_INPTUT_CLOSE, DID_DIGITALINPUT4, 0, nil)
  else
    SendCommand(CMD_DIGITAL_INPTUT_OPEN, DID_DIGITALINPUT4, 0, nil)
end;

procedure TFrmMain.DI5Click(Sender: TObject);
begin
  if DI5.Down then
    SendCommand(CMD_DIGITAL_INPTUT_CLOSE, DID_DIGITALINPUT5, 0, nil)
  else
    SendCommand(CMD_DIGITAL_INPTUT_OPEN, DID_DIGITALINPUT5, 0, nil)
end;

procedure TFrmMain.DI6Click(Sender: TObject);
begin
  if DI6.Down then
    SendCommand(CMD_DIGITAL_INPTUT_CLOSE, DID_DIGITALINPUT6, 0, nil)
  else
    SendCommand(CMD_DIGITAL_INPTUT_OPEN, DID_DIGITALINPUT6, 0, nil)
end;

procedure TFrmMain.DI7Click(Sender: TObject);
begin
  if DI7.Down then
    SendCommand(CMD_DIGITAL_INPTUT_CLOSE, DID_DIGITALINPUT7, 0, nil)
  else
    SendCommand(CMD_DIGITAL_INPTUT_OPEN, DID_DIGITALINPUT7, 0, nil)
end;

procedure TFrmMain.Wiegand0SendClick(Sender: TObject);
var
  Data: TWiegandDataRec;
begin
  Data.Data := StrToInt(WIEGAND0.Text);
  SendCommand(CMD_WIEGAND_DATA, DID_WIEGAND0, SizeOf(Data), @Data);
end;

procedure TFrmMain.Wiegand1SendClick(Sender: TObject);
var
  Data: TWiegandDataRec;
begin
  Data.Data := StrToInt(WIEGAND1.Text);
  SendCommand(CMD_WIEGAND_DATA, DID_WIEGAND1, SizeOf(Data), @Data);
end;

procedure TFrmMain.RS2320SendClick(Sender: TObject);
var
  Data: TRS232DataRec;
begin
  Move(RS2320.Text[1], Data.Data, Length(RS2320.Text));
  SendCommand(CMD_RS232_DATA, DID_RS2320, Length(RS2320.Text), @Data);
end;

//
// DEBUG!
//

procedure TFrmMain.BtnDebug1Click(Sender: TObject);
var
  Bytes: array of Byte;
  Header: PPacketHeader;
  Data: PRelayControlRec;
begin
  SetLength(Bytes, SizeOf(TPacketHeader) + SizeOf(TRelayControlRec));
  Header := @Bytes[0];
  Header^.Command  := CMD_RELAY_CONTROL;
  Header^.DevId    := DID_RELAY1;
  Header^.DataSize := SizeOf(TRelayControlRec);
  Data   := @Bytes[SizeOf(TPacketHeader)];
  Data^.States := 1; // 01b
  Data^.Delay := 50;
  Data^.Duration := 30;
  Data^.BreakDevId := DID_DIGITALINPUT0;
  Data^.TerminateDevId := DID_DIGITALINPUT1;
  ProcessCommand(Bytes, Length(Bytes));
end;

procedure TFrmMain.BtnDebug2Click(Sender: TObject);
var
  Bytes: array of Byte;
  Header: PPacketHeader;
  Data: PRelayControlRec;
begin
  SetLength(Bytes, SizeOf(TPacketHeader) + SizeOf(TRelayControlRec));
  Header := @Bytes[0];
  Header^.Command  := CMD_RELAY_CONTROL;
  Header^.DevId    := DID_RELAY1;
  Header^.DataSize := SizeOf(TRelayControlRec);
  Data   := @Bytes[SizeOf(TPacketHeader)];
  Data^.States := 0; // 00b
  Data^.Delay := 0;
  Data^.Duration := 0;
  Data^.BreakDevId := 0;
  Data^.TerminateDevId := 0;
  ProcessCommand(Bytes, Length(Bytes));
end;

procedure TFrmMain.BtnDebug3Click(Sender: TObject);
var
  Bytes: array of Byte;
  Header: PPacketHeader;
  Data: PDigitalOutputControlRec;
begin
  SetLength(Bytes, SizeOf(TPacketHeader) + SizeOf(TDigitalOutputControlRec));
  Header := @Bytes[0];
  Header^.Command  := CMD_DIGITAL_OUTPUT_CONTROL;
  Header^.DevId    := DID_DIGITALOUTPUT1;
  Header^.DataSize := SizeOf(TDigitalOutputControlRec);
  Data   := @Bytes[SizeOf(TPacketHeader)];
  Data^.States := 2; // 10b
  Data^.Delay := 0;
  Data^.Duration := 0;
  Data^.BreakDevId := DID_DIGITALINPUT0;
  Data^.TerminateDevId := DID_DIGITALINPUT1;
  ProcessCommand(Bytes, Length(Bytes));
end;

procedure TFrmMain.BtnDebug4Click(Sender: TObject);
var
  Bytes: array of Byte;
  Header: PPacketHeader;
  Data: PDigitalOutputControlRec;
begin
  SetLength(Bytes, SizeOf(TPacketHeader) + SizeOf(TDigitalOutputControlRec));
  Header := @Bytes[0];
  Header^.Command  := CMD_DIGITAL_OUTPUT_CONTROL;
  Header^.DevId    := DID_DIGITALOUTPUT1;
  Header^.DataSize := SizeOf(TDigitalOutputControlRec);
  Data   := @Bytes[SizeOf(TPacketHeader)];
  Data^.States := 0; // 00b
  Data^.Delay := 0;
  Data^.Duration := 0;
  Data^.BreakDevId := 0;
  Data^.TerminateDevId := 0;
  ProcessCommand(Bytes, Length(Bytes));
end;

procedure TFrmMain.BtnDebug5Click(Sender: TObject);
var
  Bytes: array of Byte;
  Header: PPacketHeader;
  Data: PMotorStartRec;
begin
  SetLength(Bytes, SizeOf(TPacketHeader) + SizeOf(TMotorStartRec));
  Header := @Bytes[0];
  Header^.Command  := CMD_MOTOR_START;
  Header^.DevId    := DID_MOTOR0;
  Header^.DataSize := SizeOf(TMotorStartRec);
  Data   := @Bytes[SizeOf(TPacketHeader)];
  Data^.Polarity := 1;
  Data^.Delay := 100;
  Data^.Duration := 200;
  Data^.BreakDevId := DID_DIGITALINPUT3;
  Data^.TerminateDevId := DID_DIGITALINPUT4;
  ProcessCommand(Bytes, Length(Bytes));
end;

procedure TFrmMain.BtnDebug6Click(Sender: TObject);
var
  Bytes: array of Byte;
  Header: PPacketHeader;
  Data: PMotorStopRec;
begin
  SetLength(Bytes, SizeOf(TPacketHeader) + SizeOf(TMotorStopRec));
  Header := @Bytes[0];
  Header^.Command  := CMD_MOTOR_STOP;
  Header^.DevId    := DID_MOTOR0;
  Header^.DataSize := SizeOf(TMotorStopRec);
  Data   := @Bytes[SizeOf(TPacketHeader)];
  Data^.StopKind := 0;
  ProcessCommand(Bytes, Length(Bytes));
end;

end.

