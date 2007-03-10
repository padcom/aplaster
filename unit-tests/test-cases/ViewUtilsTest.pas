unit ViewUtilsTest;

interface

uses
  Classes, SysUtils, TestFramework,
  Config, ConfigFactory, ViewUtils;

type
  TViewUtilsTest = class (TTestCase)
  private
    FConfig: TConfig;
    FServer: TServer;
    FConfigTreeDisplayer: TConfigTreeDisplayer;
  protected
    procedure Setup; override;
    procedure Teardown; override;
    property Config: TConfig read FConfig;
    property Server: TServer read FServer;
    property ConfigTreeDisplayer: TConfigTreeDisplayer read FConfigTreeDisplayer;
  published
    procedure TestIsValidIPAddress;
    procedure TestIsValidMACAddress;
    procedure TestGetTitle_Server;
    procedure TestGetTitle_Folder;
    procedure TestGetTitle_Timer;
    procedure TestGetTitle_Module;
    procedure TestGetTitle_AnalogInput;
    procedure TestGetTitle_DigitalInput;
    procedure TestGetTitle_DigitalOutput;
    procedure TestGetTitle_Relay;
    procedure TestGetTitle_RS232;
    procedure TestGetTitle_RS485;
    procedure TestGetTitle_Motor;
  end;

implementation

{ TViewUtilsTest }

{ Private declarations }

{ Protected declarations }

procedure TViewUtilsTest.Setup;
begin
  FConfig := TConfig.Create;
  FServer := TConfigFactory.CreateServer(Config);
  FConfigTreeDisplayer := TConfigTreeDisplayer.Create;
end;

procedure TViewUtilsTest.Teardown;
begin
  FreeAndNil(FConfigTreeDisplayer);
  FreeAndNil(FConfig);
end;

{ Published declarations }

procedure TViewUtilsTest.TestIsValidIPAddress;
begin
  CheckTrue(TConfigTreeDisplayer.IsValidIPAddress('0.0.0.0'));
  CheckFalse(TConfigTreeDisplayer.IsValidIPAddress('256.0.0.0'));
  CheckFalse(TConfigTreeDisplayer.IsValidIPAddress('0.256.0.0'));
  CheckFalse(TConfigTreeDisplayer.IsValidIPAddress('0.0.256.0'));
  CheckFalse(TConfigTreeDisplayer.IsValidIPAddress('0.0.0.256'));
  CheckFalse(TConfigTreeDisplayer.IsValidIPAddress('a.0.0.0'));
end;

procedure TViewUtilsTest.TestIsValidMACAddress;
begin
  CheckTrue(TConfigTreeDisplayer.IsValidMACAddress('00:00:00:00:00:00'));
  CheckTrue(TConfigTreeDisplayer.IsValidMACAddress('FF:FF:FF:FF:FF:ff'));
  CheckTrue(TConfigTreeDisplayer.IsValidMACAddress('F:1:2:3:4:5'));
  CheckTrue(TConfigTreeDisplayer.IsValidMACAddress('11:22:33:44:55:66'));
  CheckTrue(TConfigTreeDisplayer.IsValidMACAddress('12:34:56:78:9A:BC'));
  CheckFalse(TConfigTreeDisplayer.IsValidMACAddress(''));
  CheckFalse(TConfigTreeDisplayer.IsValidMACAddress('zz:34:56:78:9A:BC'));
  CheckFalse(TConfigTreeDisplayer.IsValidMACAddress('34:56:78:9A:BC'));
end;

procedure TViewUtilsTest.TestGetTitle_Server;
begin
  CheckEquals('Server (not configured)', ConfigTreeDisplayer.GetTitle(Server));
  Server.D.Title := 'TEST_SEREVER';
  CheckEquals('Server - TEST_SEREVER (not configured)', ConfigTreeDisplayer.GetTitle(Server));
  Server.D.IP := '1.1.1.1';
  CheckEquals('Server - TEST_SEREVER (1.1.1.1)', ConfigTreeDisplayer.GetTitle(Server));
end;

procedure TViewUtilsTest.TestGetTitle_Folder;
var
  Folder: TFolder;
begin
  Folder := TConfigFactory.CreateFolder(Server);
  CheckEquals('Folder', ConfigTreeDisplayer.GetTitle(Folder));
  Folder.D.Title := 'TEST_FOLDER';
  CheckEquals('TEST_FOLDER', ConfigTreeDisplayer.GetTitle(Folder));
end;

procedure TViewUtilsTest.TestGetTitle_Timer;
var
  Timer: TTimer;
begin
  Timer := TConfigFactory.CreateTimer(Server);
  CheckEquals('Timer', ConfigTreeDisplayer.GetTitle(Timer));
  Timer.D.Title := 'TEST_TIMER';
  CheckEquals('TEST_TIMER', ConfigTreeDisplayer.GetTitle(Timer));
end;

procedure TViewUtilsTest.TestGetTitle_Module;
var
  Module: TModule;
begin
  Module := TConfigFactory.CreateModule(Server);
  CheckEquals('Module (not configured)', ConfigTreeDisplayer.GetTitle(Module));
  Module.D.Title := 'TEST_MODULE';
  CheckEquals('Module - TEST_MODULE (not configured)', ConfigTreeDisplayer.GetTitle(Module));
  Module.D.IP := '1.1.1.1';
  CheckEquals('Module - TEST_MODULE (1.1.1.1 - Invalid network mask, missing MAC address)', ConfigTreeDisplayer.GetTitle(Module));
  Module.D.Netmask := '255.255.255.0';
  CheckEquals('Module - TEST_MODULE (1.1.1.1 - missing MAC address)', ConfigTreeDisplayer.GetTitle(Module));
  Module.D.MAC := 'FF:FF:FF:FF:FF:FF';
  CheckEquals('Module - TEST_MODULE (1.1.1.1)', ConfigTreeDisplayer.GetTitle(Module));
end;

procedure TViewUtilsTest.TestGetTitle_AnalogInput;
var
  Module: TModule;
  AnalogInput: TAnalogInput;
begin
  Module := TConfigFactory.CreateModule(Server);
  AnalogInput := Module.AnalogInputs[0];
  CheckEquals('[X-2/1] Analog input', ConfigTreeDisplayer.GetTitle(AnalogInput));
  AnalogInput.D.Title := 'TEST_ANALOG_INPUT';
  CheckEquals('[X-2/1] TEST_ANALOG_INPUT', ConfigTreeDisplayer.GetTitle(AnalogInput));
end;

procedure TViewUtilsTest.TestGetTitle_DigitalInput;
var
  Module: TModule;
  DigitalInput: TDigitalInput;
begin
  Module := TConfigFactory.CreateModule(Server);
  DigitalInput := Module.DigitalInputs[0];
  CheckEquals('[X-3/1] Digital input', ConfigTreeDisplayer.GetTitle(DigitalInput));
  DigitalInput.D.Title := 'TEST_DIGITAL_INPUT';
  CheckEquals('[X-3/1] TEST_DIGITAL_INPUT', ConfigTreeDisplayer.GetTitle(DigitalInput));
end;

procedure TViewUtilsTest.TestGetTitle_DigitalOutput;
var
  Module: TModule;
  DigitalOutput: TDigitalOutput;
begin
  Module := TConfigFactory.CreateModule(Server);
  DigitalOutput := Module.DigitalOutputs[0];
  CheckEquals('[X-4/1] Digital output', ConfigTreeDisplayer.GetTitle(DigitalOutput));
  DigitalOutput.D.Title := 'TEST_DIGITAL_OUTPUT';
  CheckEquals('[X-4/1] TEST_DIGITAL_OUTPUT', ConfigTreeDisplayer.GetTitle(DigitalOutput));
end;

procedure TViewUtilsTest.TestGetTitle_Relay;
var
  Module: TModule;
  Relay: TRelay;
begin
  Module := TConfigFactory.CreateModule(Server);
  Relay := Module.Relays[0];
  CheckEquals('[X-5/1..2] Relay', ConfigTreeDisplayer.GetTitle(Relay));
  Relay.D.Title := 'TEST_RELAY';
  CheckEquals('[X-5/1..2] TEST_RELAY', ConfigTreeDisplayer.GetTitle(Relay));
end;

procedure TViewUtilsTest.TestGetTitle_RS232;
var
  Module: TModule;
  RS232: TRS232;
begin
  Module := TConfigFactory.CreateModule(Server);
  RS232 := Module.RS232s[0];
  CheckEquals('[X-8/1..3] RS232', ConfigTreeDisplayer.GetTitle(RS232));
  RS232.D.Title := 'TEST_RS232';
  CheckEquals('[X-8/1..3] TEST_RS232', ConfigTreeDisplayer.GetTitle(RS232));
end;

procedure TViewUtilsTest.TestGetTitle_RS485;
var
  Module: TModule;
  RS485: TRS485;
begin
  Module := TConfigFactory.CreateModule(Server);
  RS485 := Module.RS485s[0];
  CheckEquals('[X-9/1..5] RS485', ConfigTreeDisplayer.GetTitle(RS485));
  RS485.D.Title := 'TEST_RS485';
  CheckEquals('[X-9/1..5] TEST_RS485', ConfigTreeDisplayer.GetTitle(RS485));
end;

procedure TViewUtilsTest.TestGetTitle_Motor;
var
  Module: TModule;
  Motor: TMotor;
begin
  Module := TConfigFactory.CreateModule(Server);
  Motor := Module.Motors[0];
  CheckEquals('[X-10/1..2] Motor', ConfigTreeDisplayer.GetTitle(Motor));
  Motor.D.Title := 'TEST_MOTOR';
  CheckEquals('[X-10/1..2] TEST_MOTOR', ConfigTreeDisplayer.GetTitle(Motor));
end;

initialization
  RegisterTest('', TViewUtilsTest.Suite);

end.

