unit ConfigFactoryTest;

interface

uses
  Classes, SysUtils, TestFramework,
  Config, ConfigFactory;
  
type
  TConfigFactoryTest = class (TTestCase)
  private
    FConfig: TConfig;
  protected
    procedure Setup; override;
    procedure Teardown; override;
    property Config: TConfig read FConfig;
  published
    procedure TestCreateServer;
    procedure TestCreateModule;
    procedure TestCreateTimer;
    procedure TestCreateFolder;
  end;

implementation

{ TConfigFactoryTest }

{ Private declarations }

{ Protected declarations }

procedure TConfigFactoryTest.Setup;
begin
  FConfig := TConfig.Create;
end;

procedure TConfigFactoryTest.Teardown;
begin
  FreeAndNil(FConfig);
end;

{ Published declarations }

procedure TConfigFactoryTest.TestCreateServer;
var
  Server: TServer;
begin
  Server := TConfigFactory.CreateServer(Config);
  CheckNotNull(Server);
  CheckEquals(1, Config.Servers.Count);
end;

procedure TConfigFactoryTest.TestCreateModule;
var
  Server: TServer;
  Module: TModule;
begin
  Server := TConfigFactory.CreateServer(Config);
  CheckNotNull(Server);
  Module := TConfigFactory.CreateModule(Server);
  CheckNotNull(Module);
  CheckEquals(1, Config.Servers[0].Modules.Count);
  CheckEquals(2, Config.Servers[0].Modules[0].AnalogInputs.Count);
  CheckEquals(8, Config.Servers[0].Modules[0].DigitalInputs.Count);
  CheckEquals(6, Config.Servers[0].Modules[0].DigitalOutputs.Count);
  CheckEquals(3, Config.Servers[0].Modules[0].Relays.Count);
  CheckEquals(2, Config.Servers[0].Modules[0].Wiegands.Count);
  CheckEquals(1, Config.Servers[0].Modules[0].RS232s.Count);
  CheckEquals(2, Config.Servers[0].Modules[0].RS485s.Count);
  CheckEquals(1, Config.Servers[0].Modules[0].Motors.Count);
end;

procedure TConfigFactoryTest.TestCreateTimer;
var
  Server: TServer;
  Timer: TTimer;
begin
  Server := TConfigFactory.CreateServer(Config);
  CheckNotNull(Server);
  Timer := TConfigFactory.CreateTimer(Server);
  CheckNotNull(Timer);
  CheckEquals(1, Config.Servers[0].Timers.Count);
end;

procedure TConfigFactoryTest.TestCreateFolder;
var
  Server: TServer;
  Folder: TFolder;
begin
  Server := TConfigFactory.CreateServer(Config);
  CheckNotNull(Server);
  Folder := TConfigFactory.CreateFolder(Server);
  CheckNotNull(Folder);
  CheckEquals(1, Config.Servers[0].Folders.Count);
end;

initialization
  RegisterTest('', TConfigFactoryTest.Suite);

end.

