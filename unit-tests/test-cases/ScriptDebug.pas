unit ScriptDebug;

interface

uses
  Classes, SysUtils,
  uPSComponent, uPSCompiler, uPSRuntime;

type
  TScriptDebug = class (TObject)
  private
    FTestValue: String;
  public
    class function Instance: TScriptDebug;
    class procedure Release;
    property TestValue: String read FTestValue write FTestValue;
  end;

  TScriptDebugImporter = class (TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  public
    class procedure CompileImport(Sender: TPSScript);
    class procedure ExecuteImport(Sender: TPSScript);
  end;

implementation

{ TScriptDebug }

var
  _ScriptDebug: TScriptDebug = nil;

class function TScriptDebug.Instance: TScriptDebug;
begin
  if not Assigned(_ScriptDebug) then
    _ScriptDebug := TScriptDebug.Create;
  Result := _ScriptDebug;
end;

class procedure TScriptDebug.Release;
begin
  FreeAndNil(_ScriptDebug);
end;

{ TScriptDebugImporter }

{ Private declarations }

procedure TScriptDebugTestValueR(Self: TScriptDebug; var Value: String);
begin
  Value := Self.TestValue;
end;

procedure TScriptDebugTestValueW(Self: TScriptDebug; Value: String);
begin
  Self.TestValue := Value;
end;

{ Protected declarations }

procedure TScriptDebugImporter.CompileImport1(CompExec: TPSScript);
begin
  with CompExec.Comp.AddClassN(CompExec.Comp.FindClass('TObject'), 'TScriptDebug') do
  begin
    RegisterProperty('TestValue', 'String', iptRW);
  end;
end;

procedure TScriptDebugImporter.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  with Ri.Add(TScriptDebug) do
  begin
    RegisterPropertyHelper(@TScriptDebugTestValueR, @TScriptDebugTestValueW, 'TestValue');
  end;
end;

{ Public declarations }

class procedure TScriptDebugImporter.CompileImport(Sender: TPSScript);
begin
  Sender.AddRegisteredVariable('ScriptDebug', 'TScriptDebug');
end;

class procedure TScriptDebugImporter.ExecuteImport(Sender: TPSScript);
begin
  Sender.SetVarToInstance('ScriptDebug', TScriptDebug.Instance);
end;

end.

