program Monitor;

uses
  FastMM4,
  Forms,
  Icons in '..\common\Icons.pas',
  DeviceIds in '..\common\DeviceIds.pas',
  ConfigFile in '..\common\ConfigFile.pas',
  Config in '..\common\Config.pas',
  Storage in '..\common\Storage.pas',
  OptionsBase in '..\common\OptionsBase.pas',
  Resources in 'Resources.pas',
  FormMain in 'FormMain.pas' {FrmMain};

begin
  Application.Initialize;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.
