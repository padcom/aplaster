unit ConfigManipulatorTest;

interface

uses
  Classes, SysUtils, TestFramework,
  Config, ConfigFactory, ConfigManipulator;
  
type
  TConfigManipulatorTest = class (TTestCase)
  private
    FConfig: TConfig;
    FServer: TServer;
  protected
    procedure Setup; override;
    procedure Teardown; override;
    property Config: TConfig read FConfig;
    property Server: TServer read FServer;
  published
    procedure TestGetServerByName;
    procedure TestGetServerByTag;
    procedure TestGetTimerByName;
    procedure TestGetTimerByTag;
    procedure TestGetModuleByName;
    procedure TestGetModuleByTag;
    procedure TestGetAnalogInputByName;
    procedure TestGetAnalogInputByTag;
    procedure TestGetDigitalInputByName;
    procedure TestGetDigitalInputByTag;
    procedure TestGetDigitalOutputByName;
    procedure TestGetDigitalOutputByTag;
    procedure TestGetRelayByName;
    procedure TestGetRelayByTag;
    procedure TestGetWiegandByName;
    procedure TestGetWiegandByTag;
    procedure TestGetRS232ByName;
    procedure TestGetRS232ByTag;
    procedure TestGetRS485ByName;
    procedure TestGetRS485ByTag;
    procedure TestGetMotorByName;
    procedure TestGetMotorByTag;
    procedure TestAddScript;
    procedure TestDeleteServer;
    procedure TestDeleteTimer;
    procedure TestDeleteModule;
    procedure TestDeleteFolder;
    procedure TestAssignTimerToFolder;
    procedure TestRemoveTimerFromFolder;
    procedure TestAssignModuleToFolder;
    procedure TestRemoveModuleFromFolder;
  end;

implementation

{ TConfigManipulatorTest }

{ Private declarations }

{ Protected declarations }

procedure TConfigManipulatorTest.Setup;
begin
  FConfig := TConfig.Create;
  FServer := TConfigFactory.CreateServer(Config);
end;

procedure TConfigManipulatorTest.Teardown;
begin
  FreeAndNil(FConfig);
end;

{ Published declarations }

procedure TConfigManipulatorTest.TestGetServerByName;
begin
  Server.D.Title := 'TEST_SERVER';
  CheckSame(Server, TConfigManipulator.Instance(Config).GetServerByName('TEST_SERVER'));
end;

procedure TConfigManipulatorTest.TestGetServerByTag;
begin
  Server.D.Tag := 123;
  CheckSame(Server, TConfigManipulator.Instance(Config).GetServerByTag(123));
end;

procedure TConfigManipulatorTest.TestGetTimerByName;
var
  Timer: TTimer;
begin
  Timer := TConfigFactory.CreateTimer(Server);
  Timer.D.Title := 'TEST_TIMER';
  CheckSame(Timer, TConfigManipulator.Instance(Config).GetTimerByName(Server, 'TEST_TIMER'));
end;

procedure TConfigManipulatorTest.TestGetTimerByTag;
var
  Timer: TTimer;
begin
  Timer := TConfigFactory.CreateTimer(Server);
  Timer.D.Tag := 123;
  CheckSame(Timer, TConfigManipulator.Instance(Config).GetTimerByTag(Server, 123));
end;

procedure TConfigManipulatorTest.TestGetModuleByName;
var
  Module: TModule;
begin
  Module := TConfigFactory.CreateModule(Server);
  Module.D.Title := 'TEST_MODULE';
  CheckSame(Module, TConfigManipulator.Instance(Config).GetModuleByName(Server, 'TEST_MODULE'));
end;

procedure TConfigManipulatorTest.TestGetModuleByTag;
var
  Module: TModule;
begin
  Module := TConfigFactory.CreateModule(Server);
  Module.D.Tag := 123;
  CheckSame(Module, TConfigManipulator.Instance(Config).GetModuleByTag(Server, 123));
end;

procedure TConfigManipulatorTest.TestGetAnalogInputByName;
var
  Module: TModule;
begin
  Module := TConfigFactory.CreateModule(Server);
  Module.AnalogInputs[0].D.Title := 'TEST_ANALOG_INPUT';
  CheckSame(Module.AnalogInputs[0], TConfigManipulator.Instance(Config).GetAnalogInputByName(Module, 'TEST_ANALOG_INPUT'));
end;

procedure TConfigManipulatorTest.TestGetAnalogInputByTag;
var
  Module: TModule;
begin
  Module := TConfigFactory.CreateModule(Server);
  Module.AnalogInputs[0].D.Tag := 123;
  CheckSame(Module.AnalogInputs[0], TConfigManipulator.Instance(Config).GetAnalogInputByTag(Module, 123));
end;

procedure TConfigManipulatorTest.TestGetDigitalInputByName;
var
  Module: TModule;
begin
  Module := TConfigFactory.CreateModule(Server);
  Module.DigitalInputs[0].D.Title := 'TEST_DIGITAL_INPUT';
  CheckSame(Module.DigitalInputs[0], TConfigManipulator.Instance(Config).GetDigitalInputByName(Module, 'TEST_DIGITAL_INPUT'));
end;

procedure TConfigManipulatorTest.TestGetDigitalInputByTag;
var
  Module: TModule;
begin
  Module := TConfigFactory.CreateModule(Server);
  Module.DigitalInputs[0].D.Tag := 123;
  CheckSame(Module.DigitalInputs[0], TConfigManipulator.Instance(Config).GetDigitalInputByTag(Module, 123));
end;

procedure TConfigManipulatorTest.TestGetDigitalOutputByName;
var
  Module: TModule;
begin
  Module := TConfigFactory.CreateModule(Server);
  Module.DigitalOutputs[0].D.Title := 'TEST_DIGITAL_OUTPUT';
  CheckSame(Module.DigitalOutputs[0], TConfigManipulator.Instance(Config).GetDigitalOutputByName(Module, 'TEST_DIGITAL_OUTPUT'));
end;

procedure TConfigManipulatorTest.TestGetDigitalOutputByTag;
var
  Module: TModule;
begin
  Module := TConfigFactory.CreateModule(Server);
  Module.DigitalOutputs[0].D.Tag := 123;
  CheckSame(Module.DigitalOutputs[0], TConfigManipulator.Instance(Config).GetDigitalOutputByTag(Module, 123));
end;

procedure TConfigManipulatorTest.TestGetRelayByName;
var
  Module: TModule;
begin
  Module := TConfigFactory.CreateModule(Server);
  Module.Relays[0].D.Title := 'TEST_RELAY';
  CheckSame(Module.Relays[0], TConfigManipulator.Instance(Config).GetRelayByName(Module, 'TEST_RELAY'));
end;

procedure TConfigManipulatorTest.TestGetRelayByTag;
var
  Module: TModule;
begin
  Module := TConfigFactory.CreateModule(Server);
  Module.Relays[0].D.Tag := 123;
  CheckSame(Module.Relays[0], TConfigManipulator.Instance(Config).GetRelayByTag(Module, 123));
end;

procedure TConfigManipulatorTest.TestGetWiegandByName;
var
  Module: TModule;
begin
  Module := TConfigFactory.CreateModule(Server);
  Module.Wiegands[0].D.Title := 'TEST_WIEGAND';
  CheckSame(Module.Wiegands[0], TConfigManipulator.Instance(Config).GetWiegandByName(Module, 'TEST_WIEGAND'));
end;

procedure TConfigManipulatorTest.TestGetWiegandByTag;
var
  Module: TModule;
begin
  Module := TConfigFactory.CreateModule(Server);
  Module.Wiegands[0].D.Tag := 123;
  CheckSame(Module.Wiegands[0], TConfigManipulator.Instance(Config).GetWiegandByTag(Module, 123));
end;

procedure TConfigManipulatorTest.TestGetRS232ByName;
var
  Module: TModule;
begin
  Module := TConfigFactory.CreateModule(Server);
  Module.RS232s[0].D.Title := 'TEST_RS232';
  CheckSame(Module.RS232s[0], TConfigManipulator.Instance(Config).GetRS232ByName(Module, 'TEST_RS232'));
end;

procedure TConfigManipulatorTest.TestGetRS232ByTag;
var
  Module: TModule;
begin
  Module := TConfigFactory.CreateModule(Server);
  Module.RS232s[0].D.Tag := 123;
  CheckSame(Module.RS232s[0], TConfigManipulator.Instance(Config).GetRS232ByTag(Module, 123));
end;

procedure TConfigManipulatorTest.TestGetRS485ByName;
var
  Module: TModule;
begin
  Module := TConfigFactory.CreateModule(Server);
  Module.RS485s[0].D.Title := 'TEST_RS485';
  CheckSame(Module.RS485s[0], TConfigManipulator.Instance(Config).GetRS485ByName(Module, 'TEST_RS485'));
end;

procedure TConfigManipulatorTest.TestGetRS485ByTag;
var
  Module: TModule;
begin
  Module := TConfigFactory.CreateModule(Server);
  Module.RS485s[0].D.Tag := 123;
  CheckSame(Module.RS485s[0], TConfigManipulator.Instance(Config).GetRS485ByTag(Module, 123));
end;

procedure TConfigManipulatorTest.TestGetMotorByName;
var
  Module: TModule;
begin
  Module := TConfigFactory.CreateModule(Server);
  Module.Motors[0].D.Title := 'TEST_MOTOR';
  CheckSame(Module.Motors[0], TConfigManipulator.Instance(Config).GetMotorByName(Module, 'TEST_MOTOR'));
end;

procedure TConfigManipulatorTest.TestGetMotorByTag;
var
  Module: TModule;
begin
  Module := TConfigFactory.CreateModule(Server);
  Module.Motors[0].D.Tag := 123;
  CheckSame(Module.Motors[0], TConfigManipulator.Instance(Config).GetMotorByTag(Module, 123));
end;

procedure TConfigManipulatorTest.TestAddScript;
const
  TEST_CODE = 'program test; begin end.';
var
  Script: TStrings;
begin
  Script := TStringList.Create;
  try
    Script.Text := TEST_CODE;
    TConfigManipulator.Instance(Config).AddScript(Script);
    CheckEquals(TEST_CODE + #13#10, Config.ConfigFile.GlobalData.Code);
  finally
    Script.Free;
  end;
end;

procedure TConfigManipulatorTest.TestDeleteServer;
begin
  TConfigManipulator.Instance(Config).DeleteServer(Server);
  CheckEquals(0, Config.Servers.Count);
end;

procedure TConfigManipulatorTest.TestDeleteTimer;
var
  Timer: TTimer;
begin
  Timer := TConfigFactory.CreateTimer(Server);
  CheckEquals(1, Server.Timers.Count);
  TConfigManipulator.Instance(Config).DeleteTimer(Timer);
  CheckEquals(0, Server.Timers.Count);
end;

procedure TConfigManipulatorTest.TestDeleteModule;
var
  Module: TModule;
begin
  Module := TConfigFactory.CreateModule(Server);
  CheckEquals(1, Server.Modules.Count);
  TConfigManipulator.Instance(Config).DeleteModule(Module);
  CheckEquals(0, Server.Modules.Count);
end;

procedure TConfigManipulatorTest.TestDeleteFolder;
var
  Timer: TTimer;
begin
  Timer := TConfigFactory.CreateTimer(Server);
  CheckEquals(1, Server.Timers.Count);
  TConfigManipulator.Instance(Config).DeleteTimer(Timer);
  CheckEquals(0, Server.Timers.Count);
end;

procedure TConfigManipulatorTest.TestAssignTimerToFolder;
var
  Folder: TFolder;
  Timer: TTimer;
begin
  Folder := TConfigFactory.CreateFolder(Server);
  CheckEquals(1, Server.Folders.Count);
  Timer := TConfigFactory.CreateTimer(Server);
  CheckEquals(1, Server.Timers.Count);
  CheckEquals(0, Server.Folders[0].Timers.Count);
  TConfigManipulator.Instance(Config).AssignTimerToFolder(Folder, Timer);
  CheckEquals(1, Server.Folders[0].Timers.Count);
  CheckEquals(1, Folder.Timers.Count);
end;

procedure TConfigManipulatorTest.TestRemoveTimerFromFolder;
var
  Folder: TFolder;
  Timer: TTimer;
begin
  Folder := TConfigFactory.CreateFolder(Server);
  CheckEquals(1, Server.Folders.Count);
  Timer := TConfigFactory.CreateTimer(Server);
  CheckEquals(1, Server.Timers.Count);
  CheckEquals(0, Server.Folders[0].Timers.Count);
  TConfigManipulator.Instance(Config).AssignTimerToFolder(Folder, Timer);
  CheckEquals(1, Server.Folders[0].Timers.Count);
  CheckEquals(1, Folder.Timers.Count);
  TConfigManipulator.Instance(Config).RemoveTimerFromFolder(Folder, Timer);
  CheckEquals(0, Server.Folders[0].Timers.Count);
  CheckEquals(0, Folder.Timers.Count);
end;

procedure TConfigManipulatorTest.TestAssignModuleToFolder;
var
  Folder: TFolder;
  Module: TModule;
begin
  Folder := TConfigFactory.CreateFolder(Server);
  CheckEquals(1, Server.Folders.Count);
  Module := TConfigFactory.CreateModule(Server);
  CheckEquals(1, Server.Modules.Count);
  CheckEquals(0, Server.Folders[0].Modules.Count);
  TConfigManipulator.Instance(Config).AssignModuleToFolder(Folder, Module);
  CheckEquals(1, Server.Folders[0].Modules.Count);
  CheckEquals(1, Folder.Modules.Count);
end;

procedure TConfigManipulatorTest.TestRemoveModuleFromFolder;
var
  Folder: TFolder;
  Module: TModule;
begin
  Folder := TConfigFactory.CreateFolder(Server);
  CheckEquals(1, Server.Folders.Count);
  Module := TConfigFactory.CreateModule(Server);
  CheckEquals(1, Server.Modules.Count);
  CheckEquals(0, Server.Folders[0].Modules.Count);
  TConfigManipulator.Instance(Config).AssignModuleToFolder(Folder, Module);
  CheckEquals(1, Server.Folders[0].Modules.Count);
  CheckEquals(1, Folder.Modules.Count);
  TConfigManipulator.Instance(Config).RemoveModuleFromFolder(Folder, Module);
  CheckEquals(0, Server.Folders[0].Modules.Count);
  CheckEquals(0, Folder.Modules.Count);
end;

initialization
  RegisterTest('', TConfigManipulatorTest.Suite);

end.

