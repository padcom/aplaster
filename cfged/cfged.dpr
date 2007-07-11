// ----------------------------------------------------------------------------
// file: cfged.dpr - a part of AplaSter system
// date: 2005-09-08
// auth: Matthias Hryniszak
// desc: configuration editor project file
// ----------------------------------------------------------------------------

program cfged;

uses
  FastMM4,
  Log4D,
  SysUtils,
  Forms,
  PxGetText,
  Icons in '..\common\Icons.pas',
  DeviceIds in '..\common\DeviceIds.pas',
  ConfigFile in '..\common\ConfigFile.pas',
  Config in '..\common\Config.pas',
  Storage in '..\common\Storage.pas',
  OptionsBase in '..\common\OptionsBase.pas',
  Options in 'Options.pas',
  ConfigFactory in 'ConfigFactory.pas',
  ConfigManipulator in 'ConfigManipulator.pas',
  Editors in 'Editors.pas',
  ViewUtils in '..\common\ViewUtils.pas',
  ViewBuilders in '..\common\ViewBuilders.pas',
  FormMain in 'FormMain.pas' {FrmMain},
  FormFunctionList in 'FormFunctionList.pas' {FrmFunctionList},
  Resources in 'Resources.pas',
  ViewUtilsForCfgEd in 'ViewUtilsForCfgEd.pas',

  // pascal scripting
  PasUtils in 'PasUtils.pas',
  Protocol in '..\common\Protocol.pas',
  ScriptObjects in '..\server\ScriptObjects.pas',
  uPSI_BaseTypes in '..\common\uPSI_BaseTypes.pas',
  uPSI_Config in '..\common\uPSI_Config.pas',
  uPSI_ConfigFile in '..\common\uPSI_ConfigFile.pas';


{$R *.res}

begin
  TLogPropertyConfigurator.Configure(ChangeFileExt(ParamStr(0), '.log4d'));

  LoadDefaultLang;
  Application.Initialize;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.
