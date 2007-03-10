program tests;

uses
  FastMM4, Classes, SysUtils, Forms, Log4D, TestFramework, GUITestRunner,
  ViewBuildersTest in 'test-cases\ViewBuildersTest.pas',
  ConfigTest in 'test-cases\ConfigTest.pas',
  ConfigFactoryTest in 'test-cases\ConfigFactoryTest.pas',
  ConfigManipulatorTest in 'test-cases\ConfigManipulatorTest.pas',
  ViewUtilsTest in 'test-cases\ViewUtilsTest.pas',
  Script in 'test-cases\Script.pas',
  ScriptDebug in 'test-cases\ScriptDebug.pas',
  ScriptObjectsTest in 'test-cases\ScriptObjectsTest.pas',
  ScriptObjectsTestEnvironment in 'test-cases\ScriptObjectsTestEnvironment.pas',
  EditorsTest in 'test-cases\EditorsTest.pas';

var
  AGUITestRunner: TGUITestRunner;

begin
  TLogPropertyConfigurator.Configure(ChangeFileExt(ParamStr(0), '.log4d'));
  Application.Initialize;
  Application.CreateForm(TGUITestRunner, AGUITestRunner);
  AGUITestRunner.Suite := RegisteredTests;
  Application.Run;
end.
