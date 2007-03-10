unit ScriptObjectsTestEnvironment;

interface

uses
  Classes, SysUtils, TestFramework,
  uPSComponent,
  Config, ConfigFactory, ScriptObjects, Protocol, Script;

type
  TPSSendArgs = record
    IP: String;
    Command: Byte;
    DevId: Byte;
    Data: Pointer;
    DataSize: Byte;
  end;

  TScriptEventsMock = class (TPSEvents)
  private
    FLastEvent: String;
  protected
    procedure OnServerStarted(Server: TPSServer); override;
    procedure OnServerStopped(Server: TPSServer); override;
    procedure OnTimer(Timer: TPSTimer); override;
    procedure OnModuleRequestNetworkConfig(Module: TPSModule); override;
    procedure OnModuleInitialized(Module: TPSModule); override;
    procedure OnModuleConnected(Module: TPSModule); override;
    procedure OnModuleDisconnected(Module: TPSModule); override;
    procedure OnAnalogInputRequestConfig(AnalogInput: TPSAnalogInput); override;
    procedure OnAnalogInputData(AnalogInput: TPSAnalogInput; Data: Word); override;
    procedure OnAnalogInputStatus(AnalogInput: TPSAnalogInput; Data: Word); override;
    procedure OnDigitalInputOpen(DigitalInput: TPSDigitalInput); override;
    procedure OnDigitalInputClose(DigitalInput: TPSDigitalInput); override;
    procedure OnDigitalInputStatus(DigitalInput: TPSDigitalInput; Status: Byte); override;
    procedure OnDigitalOutputStatus(DigitalOutput: TPSDigitalOutput; Status: Byte); override;
    procedure OnRelayStatus(Relay: TPSRelay; Status: Byte); override;
    procedure OnWiegandRequestConfig(Wiegand: TPSWiegand); override;
    procedure OnWiegandData(Wiegand: TPSWiegand; Data: Integer); override;
    procedure OnRS232RequestConfig(RS232: TPSRS232); override;
    procedure OnRS232Data(RS232: TPSRS232; Data: Char); override;
    procedure OnRS485RequestConfig(RS485: TPSRS485); override;
    procedure OnRS485Data(RS485: TPSRS485; Data: Char); override;
  public
    property LastEvent: String read FLastEvent;
  end;

  TScriptEventsMockTest = class (TTestCase)
  private
    FMock: TScriptEventsMock;
  protected
    procedure Setup; override;
    procedure Teardown; override;
    property Mock: TScriptEventsMock read FMock;
  published
    procedure TestEvents;
  end;

  TScriptObjectsTestEnvironment = class (TObject)
  private
    FScript: TScript;
    FConfig: TConfig;
    FServer: TPSServer;
    FEvents: TScriptEventsMock;
    FSendArgs: TPSSendArgs;
    procedure CreateTestConfig;
    procedure CreateScript;
    procedure CreateScriptObjects;
    procedure SendPacketMock(IP: String; Command: Byte; DevId: Byte; Data: Pointer; DataSize: Byte);
  public
    constructor Create;
    destructor Destroy; override;
    procedure CheckSendArgs(Args: TPSSendArgs; IP: String; Command: Byte; DevId: Byte; DataSize: Byte);
    property Config: TConfig read FConfig;
    property Server: TPSServer read FServer;
    property Events: TScriptEventsMock read FEvents;
    property SendArgs: TPSSendArgs read FSendArgs;
    property Script: TScript read FScript;
  end;

implementation

uses
  ScriptDebug, uPSCompiler, uPSI_BaseTypes, uPSComponent_Default;

{ TScriptEventsMock }

{ Protected declarations }

procedure TScriptEventsMock.OnServerStarted(Server: TPSServer);
begin
  FLastEvent := 'OnServerStarted';
end;

procedure TScriptEventsMock.OnServerStopped(Server: TPSServer);
begin
  FLastEvent := 'OnServerStopped';
end;

procedure TScriptEventsMock.OnTimer(Timer: TPSTimer);
begin
  FLastEvent := 'OnTimer';
end;

procedure TScriptEventsMock.OnModuleRequestNetworkConfig(Module: TPSModule);
begin
  FLastEvent := 'OnModuleRequestNetworkConfig';
end;

procedure TScriptEventsMock.OnModuleInitialized(Module: TPSModule);
begin
  FLastEvent := 'OnModuleInitialized';
end;

procedure TScriptEventsMock.OnModuleConnected(Module: TPSModule);
begin
  FLastEvent := 'OnModuleConnected';
end;

procedure TScriptEventsMock.OnModuleDisconnected(Module: TPSModule);
begin
  FLastEvent := 'OnModuleDisconnected';
end;

procedure TScriptEventsMock.OnAnalogInputRequestConfig(AnalogInput: TPSAnalogInput);
begin
  FLastEvent := 'OnAnalogInputRequestConfig';
end;

procedure TScriptEventsMock.OnAnalogInputData(AnalogInput: TPSAnalogInput; Data: Word);
begin
  FLastEvent := 'OnAnalogInputData';
end;

procedure TScriptEventsMock.OnAnalogInputStatus(AnalogInput: TPSAnalogInput; Data: Word);
begin
  FLastEvent := 'OnAnalogInputStatus';
end;

procedure TScriptEventsMock.OnDigitalInputOpen(DigitalInput: TPSDigitalInput);
begin
  FLastEvent := 'OnDigitalInputOpen';
end;

procedure TScriptEventsMock.OnDigitalInputClose(DigitalInput: TPSDigitalInput);
begin
  FLastEvent := 'OnDigitalInputClose';
end;

procedure TScriptEventsMock.OnDigitalInputStatus(DigitalInput: TPSDigitalInput; Status: Byte);
begin
  FLastEvent := 'OnDigitalInputStatus';
end;

procedure TScriptEventsMock.OnDigitalOutputStatus(DigitalOutput: TPSDigitalOutput; Status: Byte);
begin
  FLastEvent := 'OnDigitalOutputStatus';
end;

procedure TScriptEventsMock.OnRelayStatus(Relay: TPSRelay; Status: Byte);
begin
  FLastEvent := 'OnRelayStatus';
end;

procedure TScriptEventsMock.OnWiegandRequestConfig(Wiegand: TPSWiegand);
begin
  FLastEvent := 'OnWiegandRequestConfig';
end;

procedure TScriptEventsMock.OnWiegandData(Wiegand: TPSWiegand; Data: Integer);
begin
  FLastEvent := 'OnWiegandData';
end;

procedure TScriptEventsMock.OnRS232RequestConfig(RS232: TPSRS232);
begin
  FLastEvent := 'OnRS232RequestConfig';
end;

procedure TScriptEventsMock.OnRS232Data(RS232: TPSRS232; Data: Char);
begin
  FLastEvent := 'OnRS232Data';
end;

procedure TScriptEventsMock.OnRS485RequestConfig(RS485: TPSRS485);
begin
  FLastEvent := 'OnRS485RequestConfig';
end;

procedure TScriptEventsMock.OnRS485Data(RS485: TPSRS485; Data: Char);
begin
  FLastEvent := 'OnRS485Data';
end;

{ TScriptEventsMockTest }

{ Private declarations }

{ Protected declarations }

procedure TScriptEventsMockTest.Setup;
begin
  FMock := TScriptEventsMock.Create;
end;

procedure TScriptEventsMockTest.Teardown;
begin
  FreeAndNil(FMock);
end;

{ Published declarations }

procedure TScriptEventsMockTest.TestEvents;
begin
  Mock.OnServerStarted(nil);
  Check('OnServerStarted' = Mock.LastEvent);
  Mock.OnServerStopped(nil);
  Check('OnServerStopped' = Mock.LastEvent);
  Mock.OnTimer(nil);
  Check('OnTimer' = Mock.LastEvent);
  Mock.OnModuleRequestNetworkConfig(nil);
  Check('OnModuleRequestNetworkConfig' = Mock.LastEvent);
  Mock.OnModuleInitialized(nil);
  Check('OnModuleInitialized' = Mock.LastEvent);
  Mock.OnModuleConnected(nil);
  Check('OnModuleConnected' = Mock.LastEvent);
  Mock.OnModuleDisconnected(nil);
  Check('OnModuleDisconnected' = Mock.LastEvent);
  Mock.OnAnalogInputRequestConfig(nil);
  Check('OnAnalogInputRequestConfig' = Mock.LastEvent);
  Mock.OnAnalogInputData(nil, 0);
  Check('OnAnalogInputData' = Mock.LastEvent);
  Mock.OnAnalogInputStatus(nil, 0);
  Check('OnAnalogInputStatus' = Mock.LastEvent);
  Mock.OnDigitalInputOpen(nil);
  Check('OnDigitalInputOpen' = Mock.LastEvent);
  Mock.OnDigitalInputClose(nil);
  Check('OnDigitalInputClose' = Mock.LastEvent);
  Mock.OnDigitalInputStatus(nil, 0);
  Check('OnDigitalInputStatus' = Mock.LastEvent);
  Mock.OnDigitalOutputStatus(nil, 0);
  Check('OnDigitalOutputStatus' = Mock.LastEvent);
  Mock.OnRelayStatus(nil, 0);
  Check('OnRelayStatus' = Mock.LastEvent);
  Mock.OnWiegandRequestConfig(nil);
  Check('OnWiegandRequestConfig' = Mock.LastEvent);
  Mock.OnWiegandData(nil, 0);
  Check('OnWiegandData' = Mock.LastEvent);
  Mock.OnRS232RequestConfig(nil);
  Check('OnRS232RequestConfig' = Mock.LastEvent);
  Mock.OnRS232Data(nil, #0);
  Check('OnRS232Data' = Mock.LastEvent);
  Mock.OnRS485RequestConfig(nil);
  Check('OnRS485RequestConfig' = Mock.LastEvent);
  Mock.OnRS485Data(nil, #0);
  Check('OnRS485Data' = Mock.LastEvent);
end;

{ TScriptObjectsTestBase }

{ Private declarations }

procedure TScriptObjectsTestEnvironment.CreateTestConfig;
var
  Server: TServer;
  Module: TModule;
  Timer: TTimer;
begin
  FConfig := TConfig.Create;
  Server := TConfigFactory.CreateServer(Config);
  Server.D.IP := '1.1.1.1';
  Server.D.Title := 'TEST_SERVER';
  Module := TConfigFactory.CreateModule(Server);
  Module.D.Title := 'TEST_MODULE';
  Module.D.IP := '1.1.1.2';
  Module.D.Netmask := '255.255.255.0';
  Module.D.MAC := '11:11:11:11:11';
  Timer := TConfigFactory.CreateTimer(Server);
  Timer.D.Title := 'TEST_TIMER';
end;

procedure TScriptObjectsTestEnvironment.CreateScript;
begin
  FScript := TScript.Create;
end;

procedure TScriptObjectsTestEnvironment.CreateScriptObjects;
begin
  FServer := RecreateScriptObjects(Config, '1.1.1.1', SendPacketMock, Script.ScriptEngine);
  FEvents := TScriptEventsMock.Create;
  Server.Events.Add(Events);
end;

procedure TScriptObjectsTestEnvironment.SendPacketMock(IP: String; Command: Byte; DevId: Byte; Data: Pointer; DataSize: Byte);
begin
  FSendArgs.IP := IP;
  FSendArgs.Command := Command;
  FSendArgs.DevId := DevId;
  if DataSize > 0 then
  begin
    GetMem(FSendArgs.Data, DataSize);
    Move(Data^, FSendArgs.Data^, DataSize);
  end
  else
    FSendArgs.Data := nil;
  FSendArgs.DataSize := DataSize;
end;

{ Public declarations }

constructor TScriptObjectsTestEnvironment.Create;
begin
  inherited Create;
  CreateTestConfig;
  CreateScript;
  CreateScriptObjects;
end;

destructor TScriptObjectsTestEnvironment.Destroy;
begin
  if SendArgs.Data <> nil then
  begin
    FreeMem(FSendArgs.Data);
    FSendArgs.Data := nil;
  end;
  FreeAndNil(FServer);
  FreeAndNil(FScript);
  TScriptDebug.Release;
  FreeAndNil(FConfig);
  inherited Destroy;
end;

procedure TScriptObjectsTestEnvironment.CheckSendArgs(Args: TPSSendArgs; IP: String; Command: Byte; DevId: Byte; DataSize: Byte);
begin
  if IP <> Args.IP then
    raise ETestFailure.Create('IP mismatch');
  if Command <> Args.Command then
    raise ETestFailure.Create('Command mismatch');
  if DevId <> Args.DevId then
    raise ETestFailure.Create('DevId mismatch');
  if DataSize <> Args.DataSize then
    raise ETestFailure.Create('DataSize mismatch');
  if (DataSize = 0) and (Args.Data <> nil) then
    raise ETestFailure.Create('Expected nil pointer to Data')
  else if (DataSize <> 0) and (Args.Data = nil) then
    raise ETestFailure.Create('Expected valid pointer to Data');
end;

initialization
  RegisterTest(TScriptEventsMockTest.Suite);

end.

