// ----------------------------------------------------------------------------
// file: uPSI_BaseTypes.pas - a part of AplaSter system
// date: 2005-09-08
// auth: Matthias Hryniszak
// desc: base types for pascal scripting (import unit)
// ----------------------------------------------------------------------------

unit uPSI_BaseTypes;

interface

uses
  Classes, SysUtils, Dialogs,
  PxDataFile,
  uPSCompiler, uPSRuntime, uPSComponent, uPSUtils;

type
  TPSImport_BaseTypes = class (TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;

implementation

{ TPSImport_BaseTypes }

{ Protected declarations }

procedure TPSImport_BaseTypes.CompileImport1(CompExec: TPSScript);
begin
  // types used by data objects
  CompExec.Comp.AddTypeS('TIdentifier', 'Longword');
  CompExec.Comp.AddClass(CompExec.Comp.FindClass('TObject'), TPxDataRecord);
  CompExec.Comp.AddClass(CompExec.Comp.FindClass('TPxDataRecord'), TPxDataRecordEx);
  CompExec.Comp.AddClass(CompExec.Comp.FindClass('TObject'), TPxDataFile);
  with CompExec.Comp.AddClass(CompExec.Comp.FindClass('TObject'), TList) do
    RegisterProperty('Count', 'Integer', iptR);
  CompExec.Comp.AddDelphiFunction('function InputQuery(const ACaption, APrompt: string; var Value: string): Boolean;');
end;

procedure TListCountR(Self: TList; var Count: Integer);
begin
  Count := Self.Count;
end;

procedure TPSImport_BaseTypes.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  ri.Add(TPxDataRecord);
  ri.Add(TPxDataRecordEx);
  ri.Add(TPxDataFile);
  with ri.Add(TList) do
    RegisterPropertyHelper(@TListCountR, nil, 'Count');
  CompExec.Exec.RegisterDelphiFunction(@InputQuery, 'InputQuery', cdRegister);
end;

end.
