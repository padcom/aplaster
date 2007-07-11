// ----------------------------------------------------------------------------
// file: modsim.dpr - a part of AplaSter system
// date: 2005-09-08
// auth: Matthias Hryniszak
// desc: module simulator project file
// ----------------------------------------------------------------------------

program modsim;

uses
  FastMM4,
  Log4D,
  SysUtils,
  Forms,
  PxGetText,
  DeviceIds in '..\common\DeviceIds.pas',
  Protocol in '..\common\Protocol.pas',
  Resources in 'Resources.pas',
  Network in 'Network.pas',
  AnalogInput in 'AnalogInput.pas',
  DigitalInput in 'DigitalInput.pas',
  DigitalOutput in 'DigitalOutput.pas',
  Relay in 'Relay.pas',
  Motor in 'Motor.pas',
  FormMain in 'FormMain.pas' {FrmMain};

{$R *.res}

begin
  TLogPropertyConfigurator.Configure(ChangeFileExt(ParamStr(0), '.log4d'));

  LoadDefaultLang;
  Application.Initialize;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.

