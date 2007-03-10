// ----------------------------------------------------------------------------
// file: Options.pas - a part of AplaSter system
// date: 2005-09-08
// auth: Matthias Hryniszak
// desc: runtime options for aplaster server
// ----------------------------------------------------------------------------

unit Options;

{$IFOPT D+}
  {$DEFINE DEBUG}
  {$DEFINE ENABLE_SCRIPT_DEBUGGER}
{$ELSE}
  {$I config.inc}
{$ENDIF}

interface

uses
  Classes, SysUtils,
  PxCommandLine, PxSettings,
  OptionsBase;
  
type
  TOptions = class (TOptionsBase)
  private
{$IFDEF ENABLE_SCRIPT_DEBUGGER}
    function GetDebug: Boolean;
{$ENDIF}
  protected
    procedure CreateOptions; override;
    procedure AfterParseOptions; override;
  public
    class function Instance: TOptions;
{$IFDEF ENABLE_SCRIPT_DEBUGGER}
    property Debug: Boolean read GetDebug;
{$ENDIF}    
  end;

implementation

uses IniFiles;

{ TOptions }

{ Private declarations }

{$IFDEF ENABLE_SCRIPT_DEBUGGER}
function TOptions.GetDebug: Boolean;
begin
  Result := ByName['debug'].Value;
end;
{$ENDIF}    

{ Protected declarations }

procedure TOptions.CreateOptions; 
begin
  inherited CreateOptions;
{$IFDEF ENABLE_SCRIPT_DEBUGGER}
  with AddOption(TPxBoolOption.Create('d', 'debug')) do
    Explanation := 'Enable debugging extensions';
{$ENDIF}    
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
  FreeAndNil(_Options);

end.
