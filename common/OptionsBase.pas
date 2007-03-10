// ----------------------------------------------------------------------------
// file: OptionsBase.pas - a part of AplaSter system
// date: 2005-09-08
// auth: Matthias Hryniszak
// desc: base runtime options for all aplaster applications that access 
//       information stored in database 
// ----------------------------------------------------------------------------

unit OptionsBase;

{$IFOPT D+}
  {$DEFINE DEBUG}
{$ENDIF}

interface

uses
  Classes, SysUtils, Log4d,
  PxCommandLine, PxSettings;
  
type
  TConfigSource = (csLocalFile, csDatabase);

  TOptionsBase = class (TPxCommandLineParser)
  private
    FLog: TLogLogger;
    function GetConfigSource: TConfigSource;
    function GetConfigFileName: String;
    function GetDBServer: string;
    function GetDBDatabase: string;
  protected
    procedure CreateOptions; override;
    procedure AfterParseOptions; override;
    property Log: TLogLogger read FLog;
  public
    constructor Create;
    property ConfigSource: TConfigSource read GetConfigSource;
    property ConfigFileName: String read GetConfigFileName;
    property DBServer: string read GetDBServer;
    property DBDatabase: string read GetDBDatabase;
  end;

implementation

{ TOptionsBase }

{ Private declarations }

function TOptionsBase.GetConfigSource: TConfigSource;
var
  Source: String;
begin
  Source := IniFile.ReadString('settings', 'configsource', 'file');
  Log.Debug('GetConfigSource: Source = ""', [Source]);
  if AnsiCompareText(Source, 'file') = 0 then
    Result := csLocalFile
  else if AnsiCompareText(Source, 'database') = 0 then
    Result := csDatabase
  else
    raise Exception.CreateFmt('Unknown configuration source "%s"', [Source]);
end;

function TOptionsBase.GetConfigFileName: String;
begin
  Result := IniFile.ReadString('settings', 'configfile', 'netconfig.cfg');
  Log.Debug('GetConfigFileName: %s', [Result]);
end;

function TOptionsBase.GetDBServer: string;
begin
  Result := ByName['dbserver'].Value;
  Log.Debug('GetDBServer: %s', [Result]);
end;

function TOptionsBase.GetDBDatabase: string;
begin
  Result := ByName['dbdatabase'].Value;
  Log.Debug('GetDBDatabase: %s', [Result]);
end;

{ Protected declarations }

procedure TOptionsBase.CreateOptions;
begin
  with AddOption(TPxStringOption.Create('s', 'dbserver')) do
  begin
    Explanation := 'Database server';
    Value := IniFile.ReadString('settings', 'dbserver', '127.0.0.1');
  end;
  with AddOption(TPxStringOption.Create('b', 'dbdatabase')) do
  begin
    Explanation := 'Database on the database server';
    Value := IniFile.ReadString('settings', 'dbdatabase', 'aplaster');
  end;
end;

procedure TOptionsBase.AfterParseOptions; 
begin
end;

{ Public declarations }

constructor TOptionsBase.Create;
begin
  inherited Create;
  FLog := TLogLogger.GetLogger(ClassType);
end;

end.
