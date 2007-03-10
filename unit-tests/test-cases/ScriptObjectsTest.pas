unit ScriptObjectsTest;

interface

uses
  Classes, SysUtils, TestFramework,
  Config, ConfigFactory, ScriptObjects, Protocol, Script, ScriptObjectsTestEnvironment;

type
  TPSTestBase = class (TTestCase)
  private
    FEnvironment: TScriptObjectsTestEnvironment;
  protected
    procedure Setup; override;
    procedure Teardown; override;
    property Environment: TScriptObjectsTestEnvironment read FEnvironment;
  end;

  TPSAnalogInputTest = class (TPSTestBase)
  private
    FAnalogInput: TPSAnalogInput;
  protected
    procedure Setup; override;
    property AnalogInput: TPSAnalogInput read FAnalogInput;
  published
    procedure TestGetStatus;
    procedure TestProcess;
    procedure TestOnRequestConfig;
    procedure TestOnData;
    procedure TestOnStatus;
  end;

  TPSDigitalInputTest = class (TPSTestBase)
  private
    FDigitalInput: TPSDigitalInput;
  protected
    procedure Setup; override;
    property DigitalInput: TPSDigitalInput read FDigitalInput;
  published
    procedure TestGetStatus;
    procedure TestProcess;
    procedure TestOnOpen;
    procedure TestOnClose;
    procedure TestOnStatus;
  end;

implementation

uses
  ScriptDebug;

{ TPSTestBase }

procedure TPSTestBase.Setup;
begin
  FEnvironment := TScriptObjectsTestEnvironment.Create;
end;

procedure TPSTestBase.Teardown;
begin
  FreeAndNil(FEnvironment);
end;

{ TPSAnalogInputTest }

{ Protected declarations }

procedure TPSAnalogInputTest.Setup;
begin
  inherited Setup;
  FAnalogInput := Environment.Server.Modules[0].AnalogInputs[0];
end;

{ Published declarations }

procedure TPSAnalogInputTest.TestGetStatus;
begin
  AnalogInput.GetStatus;
  Environment.CheckSendArgs(Environment.SendArgs, AnalogInput.Module.D.IP, CMD_ANALOG_INPUT_GET_STATUS, AnalogInput.D.DevId, 0);
end;

procedure TPSAnalogInputTest.TestProcess;
var
  Data: Word;
begin
  AnalogInput.Process(CMD_ANALOG_INPUT_REQUEST_CONFIG, AnalogInput.D.DevId, nil, 0);
  CheckEquals('OnAnalogInputRequestConfig', Environment.Events.LastEvent);
  Data := 123;
  AnalogInput.Process(CMD_ANALOG_INPUT_DATA, AnalogInput.D.DevId, @Data, 2);
  CheckEquals('OnAnalogInputData', Environment.Events.LastEvent);
  Data := 123;
  AnalogInput.Process(CMD_ANALOG_INPUT_STATUS, AnalogInput.D.DevId, @Data, 2);
  CheckEquals('OnAnalogInputStatus', Environment.Events.LastEvent);
end;

procedure TPSAnalogInputTest.TestOnRequestConfig;
var
  ConfigRec: ^TAnalogInputConfigRec;
begin
  AnalogInput.Process(CMD_ANALOG_INPUT_REQUEST_CONFIG, AnalogInput.D.DevId, nil, 0);
  Environment.CheckSendArgs(Environment.SendArgs, AnalogInput.Module.D.IP, CMD_ANALOG_INPUT_CONFIG, AnalogInput.D.DevId, SizeOf(TAnalogInputConfigRec));
  ConfigRec := Environment.SendArgs.Data;
  CheckEquals(AnalogInput.D.DeltaChange, ConfigRec^.Histeresis);
  CheckEquals('OnAnalogInputRequestConfig', Environment.Events.LastEvent);
end;

procedure TPSAnalogInputTest.TestOnData;
begin
  Environment.Script.SetScript('procedure test_handler(Sender: TPSAnalogInput; Data: Integer); begin ScriptDebug.TestValue := ''Test event handler executed''; end;');
  AnalogInput.D.OnData := 'test_handler';
  AnalogInput.OnData(123);
  Environment.Script.CheckPostExecutionState;
  CheckEquals('OnAnalogInputData', Environment.Events.LastEvent);
  CheckEquals('Test event handler executed', TScriptDebug.Instance.TestValue);
end;

procedure TPSAnalogInputTest.TestOnStatus;
begin
  AnalogInput.OnStatus(123);
  CheckEquals('OnAnalogInputStatus', Environment.Events.LastEvent);
end;

{ TPSDigitalInputTest }

{ Protected declarations }

procedure TPSDigitalInputTest.Setup;
begin
  inherited Setup;
  FDigitalInput := Environment.Server.Modules[0].DigitalInputs[0];
end;

{ Published declarations }

procedure TPSDigitalInputTest.TestGetStatus;
begin
  DigitalInput.GetStatus;
  Environment.CheckSendArgs(Environment.SendArgs, DigitalInput.Module.D.IP, CMD_DIGITAL_INPTUT_GET_STATUS, DigitalInput.D.DevId, 0);
end;

procedure TPSDigitalInputTest.TestProcess;
var
  Data: TDigitalInputStatusRec;
begin
  DigitalInput.Process(CMD_DIGITAL_INPTUT_OPEN, DigitalInput.D.DevId, nil, 0);
  CheckEquals('OnDigitalInputOpen', Environment.Events.LastEvent);
  DigitalInput.Process(CMD_DIGITAL_INPTUT_CLOSE, DigitalInput.D.DevId, nil, 0);
  CheckEquals('OnDigitalInputClose', Environment.Events.LastEvent);
  DigitalInput.Process(CMD_DIGITAL_INPTUT_STATUS, DigitalInput.D.DevId, @Data, SizeOf(Data));
  CheckEquals('OnDigitalInputStatus', Environment.Events.LastEvent);
end;

procedure TPSDigitalInputTest.TestOnOpen;
begin
  Environment.Script.SetScript('procedure test_handler(Sender: TPSDigitalInput); begin ScriptDebug.TestValue := ''Test event handler executed''; end;');
  DigitalInput.D.OnOpen := 'test_handler';
  DigitalInput.OnOpen;
  Environment.Script.CheckPostExecutionState;
  CheckEquals('OnDigitalInputOpen', Environment.Events.LastEvent);
  CheckEquals('Test event handler executed', TScriptDebug.Instance.TestValue);
end;

procedure TPSDigitalInputTest.TestOnClose;
begin
  Environment.Script.SetScript('procedure test_handler(Sender: TPSDigitalInput); begin ScriptDebug.TestValue := ''Test event handler executed''; end;');
  DigitalInput.D.OnClose := 'test_handler';
  DigitalInput.OnClose;
  Environment.Script.CheckPostExecutionState;
  CheckEquals('OnDigitalInputClose', Environment.Events.LastEvent);
  CheckEquals('Test event handler executed', TScriptDebug.Instance.TestValue);
end;

procedure TPSDigitalInputTest.TestOnStatus;
begin
  DigitalInput.OnStatus(123);
  CheckEquals('OnDigitalInputStatus', Environment.Events.LastEvent);
end;

initialization
  RegisterTest('', TPSAnalogInputTest.Suite);
  RegisterTest('', TPSDigitalInputTest.Suite);

end.

