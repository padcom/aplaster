// ----------------------------------------------------------------------------
// file: modsim.dpr - a part of AplaSter system
// date: 2005-09-08
// auth: Matthias Hryniszak
// desc: module simulator project file
// ----------------------------------------------------------------------------

program modsim;

uses
  FastMM4,
  Forms,
  PxGetText,
  DeviceIds in '..\common\DeviceIds.pas',
  Protocol in '..\common\Protocol.pas',
  Resources in 'Resources.pas',
  FormMain in 'FormMain.pas' {FrmMain};

{$R *.res}

begin
  LoadDefaultLang;
  Application.Initialize;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.

