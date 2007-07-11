// ----------------------------------------------------------------------------
// file: aplasvr.dpr - a part of AplaSter system
// date: 2005-09-08
// auth: Matthias Hryniszak
// desc: aplaster server project file
// ----------------------------------------------------------------------------

program aplasvr;

{$IFOPT D+}
  {$DEFINE DEBUG}
  {$DEFINE ENABLE_SCRIPT_DEBUGGER}
{$ELSE}
  {$I config.inc}
{$ENDIF}

uses
  FastMM4,
  Log4D,
  Windows,
  Forms,
  SysUtils,
  OptionsBase in '..\common\OptionsBase.pas',
  Options in 'Options.pas',
  Icons in '..\common\Icons.pas',
  Config in '..\common\Config.pas',
  ConfigFile in '..\common\ConfigFile.pas',
  Storage in '..\common\Storage.pas',
  Resources in 'Resources.pas',
  Network in 'Network.pas',
  FormMain in 'FormMain.pas' {FrmMain},
  FormDebugEvaulate in 'FormDebugEvaulate.pas' {FormDebugEvaulate},
  FormDebugMain in 'FormDebugMain.pas' {FormDebugMain},
  ViewBuilders in '..\common\ViewBuilders.pas',
  uPSI_BaseTypes in '..\common\uPSI_BaseTypes.pas',
  ScriptObjects in 'ScriptObjects.pas',
  Protocol in '..\common\Protocol.pas',
  DeviceIds in '..\common\DeviceIds.pas',
  ViewUtils in '..\common\ViewUtils.pas',
  ViewUtilsForServer in 'ViewUtilsForServer.pas';

{$R *.res}

var
  Mutex: THandle;

begin
  TLogPropertyConfigurator.Configure(ChangeFileExt(ParamStr(0), '.log4d'));

  // allow only one instance of the server
  Mutex := CreateMutex(nil, True, 'APLASVR');
  if GetLastError = ERROR_ALREADY_EXISTS then
  begin
    ReleaseMutex(Mutex);
    Exit;
  end;

  Application.Initialize;
  Application.ShowMainForm := not FindCmdLineSwitch('hide', True);
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;

  ReleaseMutex(Mutex);
end.
