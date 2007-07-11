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
  Dialogs, ExtCtrls, StdCtrls, Buttons, ComCtrls, Log4D,
  Winsock, Protocol, Network,
  AnalogInput, DigitalInput, DigitalOutput, Relay, Motor;

type
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
    procedure AnalogInputChange(Sender: TObject);
    procedure DigitalInputClick(Sender: TObject);
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
    FNetwork: TNetwork;
    FAnalogInput: array of TAnalogInput;
    FDigitalInput: array of TDigitalInput;
    FDigitalOutput: array of TDigitalOutput;
    FRelay: array of TRelay;
    FMotor: array of TMotor;

    procedure AssignLanguage;

    procedure DispatchCommand(Buffer: array of Byte; BufferSize: Integer);
    procedure GetButtonState(Sender: TObject; DevId: Byte; var State: Boolean);
    procedure SetButtonState(Sender: TObject; DevId: Byte; const State: Boolean);
    procedure SetMotorState(Sender: TObject; DevId: Byte; const State: Integer);

    // commands send from server to module
    procedure ResetSimulator;
    procedure ReceiveNetworkConfig(Config: PModuleNetworkConfigRec);
    procedure RS232Data(DevId: Byte; Data: PRS232DataRec; DataSize: Byte);
    procedure RS232SetConfig(DevId: Byte; Data: PRS232ConfigRec);
    procedure WiegandSetConfig(DevId: Byte; Data: PWiegandConfigRec);

    // device handlers
    procedure CreateDevices;
  protected
    class function Log: TLogLogger;
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

// ----------------------------------------------------------------------------
// Dispatching of received commands
// ----------------------------------------------------------------------------

procedure TFrmMain.DispatchCommand(Buffer: array of Byte; BufferSize: Integer);
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
      FNetwork.SendCommand(CMD_MODULE_PONG, 0, 0, nil);
    CMD_MODULE_RESET:
      ResetSimulator;
    CMD_MODULE_NETWORK_CONFIG:
      ReceiveNetworkConfig(Data);
    CMD_ANALOG_INPUT_CONFIG:
      FAnalogInput[Header^.DevId - DID_ANALOGINPUT0].CmdConfig(Data);
    CMD_ANALOG_INPUT_GET_STATUS:
      FAnalogInput[Header^.DevId - DID_ANALOGINPUT0].CmdGetStatus;
    CMD_DIGITAL_INPUT_GET_STATUS:
      FDigitalInput[Header^.DevId - DID_DIGITALINPUT0].CmdGetStatus;
    CMD_DIGITAL_OUTPUT_CONTROL:
      FDigitalOutput[Header^.DevId - DID_DIGITALOUTPUT0].CmdControl(Data);
    CMD_DIGITAL_OUTPUT_GET_STATUS:
      FDigitalOutput[Header^.DevId - DID_DIGITALOUTPUT0].CmdGetStatus;
    CMD_RELAY_CONTROL:
      FRelay[Header^.DevId - DID_RELAY0].CmdControl(Data);
    CMD_RELAY_GET_STATUS:
      FRelay[Header^.DevId - DID_RELAY0].CmdGetStatus;
    CMD_WIEGAND_CONFIG:
      WiegandSetConfig(Header^.DevId, Data);
    CMD_RS232_DATA:
      RS232Data(Header^.DevId, Data, Header^.DataSize);
    CMD_RS232_CONFIG:
      RS232SetConfig(Header^.DevId, Data);
    CMD_MOTOR_START:
      FMotor[Header^.DevId - DID_MOTOR0].CmdStart(Data);
    CMD_MOTOR_STOP:
      FMotor[Header^.DevId - DID_MOTOR0].CmdStop(Data);
  end;
end;

// ----------------------------------------------------------------------------
// Event handlers
// ----------------------------------------------------------------------------

procedure TFrmMain.GetButtonState(Sender: TObject; DevId: Byte; var State: Boolean);
var
  I: Integer;
  DigitalInput: TSpeedButton;
begin
  DigitalInput := nil;
  for I := 0 to ComponentCount - 1 do
    if Components[I].Tag = DevId then
    begin
      DigitalInput := Components[I] as TSpeedButton;
      Break;
    end;
  if Assigned(DigitalInput) then
    State := DigitalInput.Down;
end;

procedure TFrmMain.SetButtonState(Sender: TObject; DevId: Byte; const State: Boolean);
var
  I: Integer;
  DigitalOutput: TSpeedButton;
begin
  DigitalOutput := nil;
  for I := 0 to ComponentCount - 1 do
    if Components[I].Tag = DevId then
    begin
      DigitalOutput := Components[I] as TSpeedButton;
      Break;
    end;
  if Assigned(DigitalOutput) then
    DigitalOutput.Down := State;
end;

procedure TFrmMain.SetMotorState(Sender: TObject; DevId: Byte; const State: Integer);
begin
  GbxMotor.ItemIndex := State;
end;

// ----------------------------------------------------------------------------
// Additional commands the emulator is reacting on
// ----------------------------------------------------------------------------

procedure TFrmMain.ResetSimulator;
begin
  Close;
end;

procedure TFrmMain.ReceiveNetworkConfig(Config: PModuleNetworkConfigRec);
begin
  ShowMessage('Network configuration received');
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
  ShowMessageFmt('Received RS232(DID %d) configuration ', [DevId]);
end;

procedure TFrmMain.WiegandSetConfig(DevId: Byte; Data: PWiegandConfigRec);
begin
  ShowMessageFmt('Received Wiegand(DID %d) configuration ', [DevId]);
end;

// ----------------------------------------------------------------------------
// Internal state machines to control devices
// ----------------------------------------------------------------------------

procedure TFrmMain.CreateDevices;
var
  I: Integer;
begin
  SetLength(FAnalogInput, 2);
  for I := 0 to Length(FAnalogInput) - 1 do
  begin
    FAnalogInput[I] := TAnalogInput.Create(Self);
    FAnalogInput[I].DevId := DID_ANALOGINPUT0 + I;
    FAnalogInput[I].OnSendCommand := FNetwork.SendCommand;
  end;
  AN0.Tag := DID_ANALOGINPUT0;
  AN1.Tag := DID_ANALOGINPUT1;

  SetLength(FDigitalInput, 8);
  for I := 0 to Length(FDigitalInput) - 1 do
  begin
    FDigitalInput[I] := TDigitalInput.Create(Self);
    FDigitalInput[I].DevId := DID_DIGITALINPUT0 + I;
    FDigitalInput[I].OnSendCommand := FNetwork.SendCommand;
  end;
  DI0.Tag := DID_DIGITALINPUT0;
  DI1.Tag := DID_DIGITALINPUT1;
  DI2.Tag := DID_DIGITALINPUT2;
  DI3.Tag := DID_DIGITALINPUT3;
  DI4.Tag := DID_DIGITALINPUT4;
  DI5.Tag := DID_DIGITALINPUT5;
  DI6.Tag := DID_DIGITALINPUT6;
  DI7.Tag := DID_DIGITALINPUT7;

  SetLength(FDigitalOutput, 8);
  for I := 0 to Length(FDigitalOutput) - 1 do
  begin
    FDigitalOutput[I] := TDigitalOutput.Create(Self);
    FDigitalOutput[I].DevId := DID_DIGITALOUTPUT0 + I;
    FDigitalOutput[I].OnSendCommand := FNetwork.SendCommand;
    FDigitalOutput[I].OnGetDigitalInputState := GetButtonState;
    FDigitalOutput[I].OnSetDigitalOutputState := SetButtonState;
  end;
  DO0.Tag := DID_DIGITALOUTPUT0;
  DO1.Tag := DID_DIGITALOUTPUT1;
  DO2.Tag := DID_DIGITALOUTPUT2;
  DO3.Tag := DID_DIGITALOUTPUT3;
  DO4.Tag := DID_DIGITALOUTPUT4;
  DO5.Tag := DID_DIGITALOUTPUT5;

  SetLength(FRelay, 3);
  for I := 0 to Length(FRelay) - 1 do
  begin
    FRelay[I] := TRelay.Create(Self);
    FRelay[I].DevId := DID_RELAY0 + I;
    FRelay[I].OnSendCommand := FNetwork.SendCommand;
    FRelay[I].OnGetDigitalInputState := GetButtonState;
    FRelay[I].OnSetRelayState := SetButtonState;
  end;
  RE0.Tag := DID_RELAY0;
  RE1.Tag := DID_RELAY1;
  RE2.Tag := DID_RELAY2;

  SetLength(FMotor, 1);
  for I := 0 to Length(FMotor) - 1 do
  begin
    FMotor[I] := TMotor.Create(Self);
    FMotor[I].DevId := DID_MOTOR0 + I;
    FMotor[I].OnSendCommand := FNetwork.SendCommand;
    FMotor[I].OnGetDigitalInputState := GetButtonState;
    FMotor[I].OnSetMotorState := SetMotorState;
  end;
  GbxMotor.Tag := DID_MOTOR0;

  // enable all devices
  for I := 0 to Length(FDigitalOutput) - 1 do
    FDigitalOutput[I].Enabled := True;
  for I := 0 to Length(FRelay) - 1 do
    FRelay[I].Enabled := True;
  for I := 0 to Length(FMotor) - 1 do
    FMotor[I].Enabled := True;
end;

{ Protected declarations }

class function TFrmMain.Log: TLogLogger;
begin
  Result := TLogLogger.GetLogger(Self);
end;

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
            DispatchCommand(Buffer, Length(Buffer));
          end;
        end;
      end;
  end;
end;

{ Public declarations }

procedure TFrmMain.FormCreate(Sender: TObject);
begin
  AssignLanguage;
  FNetwork := TNetwork.Create(Self, Handle);
  CreateDevices;
end;

procedure TFrmMain.FormDestroy(Sender: TObject);
begin
  FNetwork := nil; 
end;

procedure TFrmMain.FormShow(Sender: TObject);
begin
//
end;

procedure TFrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
//
end;

procedure TFrmMain.FormResize(Sender: TObject);
begin
//
end;

procedure TFrmMain.AnalogInputChange(Sender: TObject);
begin
  with Sender as TTrackBar do
    FAnalogInput[Tag - DID_ANALOGINPUT0].Value := Position;
end;

procedure TFrmMain.DigitalInputClick(Sender: TObject);
begin
  with Sender as TSpeedButton do
    if Down then
      FDigitalInput[Tag - DID_DIGITALINPUT0].Status := 0
    else
      FDigitalInput[Tag - DID_DIGITALINPUT0].Status := 1;
end;

procedure TFrmMain.Wiegand0SendClick(Sender: TObject);
var
  Data: TWiegandDataRec;
begin
  Data.Data := StrToInt(WIEGAND0.Text);
  FNetwork.SendCommand(CMD_WIEGAND_DATA, DID_WIEGAND0, SizeOf(Data), @Data);
end;

procedure TFrmMain.Wiegand1SendClick(Sender: TObject);
var
  Data: TWiegandDataRec;
begin
  Data.Data := StrToInt(WIEGAND1.Text);
  FNetwork.SendCommand(CMD_WIEGAND_DATA, DID_WIEGAND1, SizeOf(Data), @Data);
end;

procedure TFrmMain.RS2320SendClick(Sender: TObject);
var
  Data: TRS232DataRec;
begin
  Move(RS2320.Text[1], Data.Data, Length(RS2320.Text));
  FNetwork.SendCommand(CMD_RS232_DATA, DID_RS2320, Length(RS2320.Text), @Data);
end;

// ----------------------------------------------------------------------------
// DEBUG!
// ----------------------------------------------------------------------------

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
  Data := @Bytes[SizeOf(TPacketHeader)];
  Data^.States := 1; // 01b
  Data^.Delay := 50;
  Data^.Duration := 30;
  Data^.BreakDevId := DID_DIGITALINPUT0;
  Data^.TerminateDevId := DID_DIGITALINPUT1;
  DispatchCommand(Bytes, Length(Bytes));
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
  Data := @Bytes[SizeOf(TPacketHeader)];
  Data^.States := 0; // 00b
  Data^.Delay := 0;
  Data^.Duration := 0;
  Data^.BreakDevId := 0;
  Data^.TerminateDevId := 0;
  DispatchCommand(Bytes, Length(Bytes));
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
  Data := @Bytes[SizeOf(TPacketHeader)];
  Data^.States := 2; // 10b
  Data^.Delay := 0;
  Data^.Duration := 0;
  Data^.BreakDevId := DID_DIGITALINPUT0;
  Data^.TerminateDevId := DID_DIGITALINPUT1;
  DispatchCommand(Bytes, Length(Bytes));
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
  Data := @Bytes[SizeOf(TPacketHeader)];
  Data^.States := 0; // 00b
  Data^.Delay := 0;
  Data^.Duration := 0;
  Data^.BreakDevId := 0;
  Data^.TerminateDevId := 0;
  DispatchCommand(Bytes, Length(Bytes));
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
  Data := @Bytes[SizeOf(TPacketHeader)];
  Data^.Polarity := 1;
  Data^.Delay := 100;
  Data^.Duration := 200;
  Data^.BreakDevId := DID_DIGITALINPUT3;
  Data^.TerminateDevId := DID_DIGITALINPUT4;
  DispatchCommand(Bytes, Length(Bytes));
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
  Data := @Bytes[SizeOf(TPacketHeader)];
  Data^.StopKind := 0;
  DispatchCommand(Bytes, Length(Bytes));
end;

end.


