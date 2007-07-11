// ----------------------------------------------------------------------------
// file: Options.pas - a part of AplaSter system
// date: 2005-09-08
// auth: Matthias Hryniszak
// desc: runtime options for configuration editor
// ----------------------------------------------------------------------------

unit Options;

{$IFOPT D+}
  {$DEFINE DEBUG}
{$ENDIF}

interface

uses
  Classes, SysUtils, Log4D,
  PxCommandLine, PxSettings,
  OptionsBase;

type
  TOptions = class (TOptionsBase)
  private
    function GetConfigFileName: string;
  protected
    class function Log: TLogLogger;
    procedure CreateOptions; override;
    procedure AfterParseOptions; override;
  public
    class function Instance: TOptions;
    property ConfigFileName: string read GetConfigFileName;
  end;

implementation

{ TOptions }

{ Private declarations }

function TOptions.GetConfigFileName: string;
begin
  Result := ByName['config-file'].Value;
  if (Result = '') and (FLeftList.Count > 0) then
    Result := FLeftList[0];
end;

{ Protected declarations }

class function TOptions.Log: TLogLogger;
begin
  Result := TLogLogger.GetLogger(Self);
end;

procedure TOptions.CreateOptions;
begin
  inherited CreateOptions;
  with AddOption(TPxStringOption.Create('f', 'config-file')) do
  begin
    Explanation := 'Input file name to load after program start';
    Value := IniFile.ReadString('settings', 'configfile', '');
  end;
end;

procedure TOptions.AfterParseOptions;
begin
end;

{ Public declarations }

var
  _Options: TOptions;

class function TOptions.Instance: TOptions;
begin
  Assert(Assigned(_Options), 'Error: TOptions instance has not been initialized or has already been disposed');
  Result := _Options;
end;

{ *** }

initialization
  _Options := TOptions.Create;
  _Options.Parse;

finalization
  FreeAndnil(_Options);

end.

