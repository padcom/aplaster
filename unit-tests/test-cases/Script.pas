unit Script;

interface

uses
  Classes, SysUtils,
  uPSComponent;

type
  TScript = class (TObject)
  private
    FScriptEngine: TPSScript;
    FScriptEngineOwner: TComponent;
  public
    constructor Create;
    destructor Destroy; override;
    procedure SetScript(Script: String);
    procedure CheckPostExecutionState;
    property ScriptEngine: TPSScript read FScriptEngine;
  end;

implementation

uses
  uPSCompiler, uPSI_BaseTypes, uPSComponent_Default, ScriptObjects, ScriptDebug;

{ TScript }

{ Private declarations }

constructor TScript.Create;
begin
  FScriptEngineOwner := TComponent.Create(nil);
  FScriptEngine := TPSScript.Create(FScriptEngineOwner);
  ScriptEngine.CompilerOptions := [icAllowNoBegin, icAllowNoEnd, icBooleanShortCircuit];
  ScriptEngine.OnCompile := TScriptDebugImporter.CompileImport;
  ScriptEngine.OnExecute := TScriptDebugImporter.ExecuteImport;
  TPSPluginItem(ScriptEngine.Plugins.Add).Plugin := TPSDllPlugin.Create(FScriptEngineOwner);
  TPSPluginItem(ScriptEngine.Plugins.Add).Plugin := TPSImport_Classes.Create(FScriptEngineOwner);
  TPSPluginItem(ScriptEngine.Plugins.Add).Plugin := TPSImport_DateUtils.Create(FScriptEngineOwner);
  TPSPluginItem(ScriptEngine.Plugins.Add).Plugin := TPSImport_BaseTypes.Create(FScriptEngineOwner);
  TPSPluginItem(ScriptEngine.Plugins.Add).Plugin := TPSScriptObjects.Create(FScriptEngineOwner);
  TPSPluginItem(ScriptEngine.Plugins.Add).Plugin := TScriptDebugImporter.Create(FScriptEngineOwner);
end;

destructor TScript.Destroy;
begin
  FreeAndNil(FScriptEngineOwner);
end;

procedure TScript.SetScript(Script: String);
begin
  ScriptEngine.Script.Text := Script;
  ScriptEngine.SuppressLoadData := True;
  if not ScriptEngine.Compile then
    raise Exception.Create('Error while compiling script' + ScriptEngine.CompilerErrorToStr(0));
  if not ScriptEngine.LoadExec then
    raise Exception.Create('Error while loading executable byte-code: ' + ScriptEngine.ExecErrorToString);
  if Assigned(ScriptEngine.OnExecute) then
    ScriptEngine.OnExecute(ScriptEngine);
end;

procedure TScript.CheckPostExecutionState;
begin
  if ScriptEngine.ExecErrorToString <> 'No Error' then
    raise Exception.Create(ScriptEngine.ExecErrorToString);
end;

end.

