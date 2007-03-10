program tests_auto;

{$APPTYPE CONSOLE}

uses
  Classes, SysUtils, Forms, Log4D, TestFramework, TextTestRunner,
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

begin
  TLogPropertyConfigurator.Configure(ChangeFileExt(ParamStr(0), '.log4d'));
  RunRegisteredTests;
end.
