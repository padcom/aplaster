// ----------------------------------------------------------------------------
// file: ViewUtils.pas - a part of AplaSter system
// date: 2005-09-08
// auth: Matthias Hryniszak
// desc: various view utilities
// ----------------------------------------------------------------------------

unit ViewUtils;

interface

uses
  Classes, SysUtils,
  Config;

type
  TConfigTreeDisplayer = class (TObject)
  protected
    function GetServerTitle(Server: TServer): string; virtual;
    function GetFolderTitle(Folder: TFolder): string; virtual;
    function GetTimerTitle(Timer: TTimer): string; virtual;
    function GetModuleTitle(Module: TModule): string; virtual;
    function GetAnalogInputTitle(AnalogInput: TAnalogInput): string; virtual;
    function GetDigitalInputTitle(DigitalInput: TDigitalInput): string; virtual;
    function GetDigitalOutputTitle(DigitalOutput: TDigitalOutput): string; virtual;
    function GetRelayTitle(Relay: TRelay): string; virtual;
    function GetWiegandTitle(Wiegand: TWiegand): string; virtual;
    function GetRS232Title(RS232: TRS232): string; virtual;
    function GetRS485Title(RS485: TRS485): string; virtual;
    function GetMotorTitle(Motor: TMotor): string; virtual;
  public
    class function IsBetween(S: String; Low, High: Integer): Boolean;
    class function IsValidIPAddress(S: String): Boolean;
    class function IsValidMACAddress(S: String): Boolean;
    function GetTitle(Item: TConfigItem): string;
  end;

implementation

uses
  Resources, RegExpr;

{ TConfigTreeDisplayer }

{ Protected declarations }

function TConfigTreeDisplayer.GetServerTitle(Server: TServer): string;
begin
  with Server do
  begin
    Result := SServer;
    if D.Title <> '' then
      Result := Result + ' - ' + D.Title;
    if D.IP <> '' then
    begin
      Result := Result + ' (' + D.IP;
      if not IsValidIPAddress(D.IP) then
        Result := Result + ' - ' + SInvalidIPAddress;
      Result := Result + ')';
    end
    else
      Result := Result + ' (' + SNotConfigured + ')';
  end
end;

function TConfigTreeDisplayer.GetFolderTitle(Folder: TFolder): string;
begin
  if Folder.D.Title = '' then
    Result := SFolder
  else
    Result := Folder.D.Title;
end;

function TConfigTreeDisplayer.GetTimerTitle(Timer: TTimer): string;
begin
  with Timer do
  begin
    if D.Title <> '' then
      Result := D.Title
    else
      Result := STimer;
    if (D.Interval <= 0) or (D.Interval > 655350) then
      Result := Result + ' (' + SInvalidInterval + ')';
  end;
end;

function TConfigTreeDisplayer.GetModuleTitle(Module: TModule): string;
var
  S: string;
begin
  with Module do
  begin
    Result := SModule;
    if D.Title <> '' then
      Result := Result + ' - ' + D.Title;
    if D.IP <> '' then
    begin
      Result := Result + ' (' + D.IP;
      S := '';
      if not IsValidIPAddress(D.IP) then
        S := SInvalidIPAddress;
      if not IsValidIPAddress(D.Netmask) then
      begin
        if S <> '' then
          S := S + ', ';
        S := S + SInvalidNetmaskAddress;
      end;
      if (D.MAC = '') or (not IsValidMACAddress(D.MAC)) then
      begin
        if S <> '' then
          S := S + ', ';
        if D.MAC = '' then
          S := S + SMissingMACAddress
        else
          S := S + SInvalidMACAddress;
      end;
      if S <> '' then
        Result := Result + ' - ' + S;
      Result := Result + ')';
    end
    else
      Result := Result + ' (' + SNotConfigured + ')';
  end;
end;

function TConfigTreeDisplayer.GetAnalogInputTitle(AnalogInput: TAnalogInput): string;
begin
  with AnalogInput do
  begin
    Result := '[' + D.Connector + '] ';
    if D.Title <> '' then
      Result := Result + D.Title
    else
      Result := Result + SAnalogInput;
    if (D.DeltaChange > 1023) or (D.DeltaChange < 1) then
      Result := Result + ' (' + SInvalidDeltaChangeValue + ')';
  end;
end;

function TConfigTreeDisplayer.GetDigitalInputTitle(DigitalInput: TDigitalInput): string;
begin
  with DigitalInput do
  begin
    Result := '[' + D.Connector + '] ';
    if D.Title <> '' then
      Result := Result + D.Title
    else
      Result := Result + SDigitalInput;
  end;
end;

function TConfigTreeDisplayer.GetDigitalOutputTitle(DigitalOutput: TDigitalOutput): string;
begin
  with DigitalOutput do
  begin
    Result := '[' + D.Connector + '] ';
    if D.Title <> '' then
      Result := Result + D.Title
    else
      Result := Result + SDigitalOutput;
  end;
end;

function TConfigTreeDisplayer.GetRelayTitle(Relay: TRelay): string;
begin
  with Relay do
  begin
    Result := '[' + D.Connector + '] ';
    if D.Title <> '' then
      Result := Result + D.Title
    else
      Result := Result + SRelay;
  end;
end;

function TConfigTreeDisplayer.GetWiegandTitle(Wiegand: TWiegand): string;
begin
  with Wiegand do
  begin
    Result := '[' + D.Connector + '] ';
    if D.Title <> '' then
      Result := Result + D.Title
    else
      Result := Result + SWiegand;
    if (D.DataBits < 16) or (D.DataBits > 128) then
      Result := Result + ' (' + Format(SInvalidDataBisValue, [D.DataBits]) + ')';
  end;
end;

function TConfigTreeDisplayer.GetRS232Title(RS232: TRS232): string;
begin
  with RS232 do
  begin
    Result := '[' + D.Connector + '] ';
    if D.Title <> '' then
      Result := Result + D.Title
    else
      Result := Result + SRS232;
  end;
end;

function TConfigTreeDisplayer.GetRS485Title(RS485: TRS485): string;
begin
  with RS485 do
  begin
    Result := '[' + D.Connector + '] ';
    if D.Title <> '' then
      Result := Result + D.Title
    else
      Result := Result + SRS485;
  end;
end;

function TConfigTreeDisplayer.GetMotorTitle(Motor: TMotor): string;
begin
  with Motor do
  begin
    Result := '[' + D.Connector + '] ';
    if D.Title <> '' then
      Result := Result + D.Title
    else
      Result := Result + SMotor;
  end;
end;

{ Public declarations }

class function TConfigTreeDisplayer.IsBetween(S: String; Low, High: Integer): Boolean;
var
  V: Integer;
begin
  Result := TryStrToInt(S, V) and (V >= Low) and (V <= High);
end;

class function TConfigTreeDisplayer.IsValidIPAddress(S: String): Boolean;
var
  R: TRegExpr;
begin
  R := TRegExpr.Create;
  try
    R.Expression := '(\d+)\.(\d+)\.(\d+)\.(\d+)';
    if R.Exec(S) then
    begin
      Result :=
        IsBetween(R.Match[1], 0, 255) and
        IsBetween(R.Match[2], 0, 255) and
        IsBetween(R.Match[3], 0, 255) and
        IsBetween(R.Match[4], 0, 255);
    end
    else
      Result := False;
  finally
    R.Free;
  end;
end;

class function TConfigTreeDisplayer.IsValidMACAddress(S: String): Boolean;
var
  R: TRegExpr;
begin
  R := TRegExpr.Create;
  try
    R.Expression := '([0-9ABCDEF]{1,2}):([0-9ABCDEF]{1,2}):([0-9ABCDEF]{1,2}):([0-9ABCDEF]{1,2}):([0-9ABCDEF]{1,2}):([0-9ABCDEF]{1,2})';
    if R.Exec(UpperCase(S)) then
    begin
      Result :=
        IsBetween('$' + R.Match[1], 0, 255) and
        IsBetween('$' + R.Match[2], 0, 255) and
        IsBetween('$' + R.Match[3], 0, 255) and
        IsBetween('$' + R.Match[4], 0, 255) and
        IsBetween('$' + R.Match[5], 0, 255) and
        IsBetween('$' + R.Match[6], 0, 255);
    end
    else
      Result := False;
  finally
    R.Free;
  end;
end;

function TConfigTreeDisplayer.GetTitle(Item: TConfigItem): string;
begin
  if Item is TServer then
    Result := GetServerTitle(Item as TServer)
  else if Item is TFolder then
    Result := GetFolderTitle(Item as TFolder)
  else if Item is TTimer then
    Result := GetTimerTitle(Item as TTimer)
  else if Item is TModule then
    Result := GetModuleTitle(Item as TModule)
  else if Item is TAnalogInput then
    Result := GetAnalogInputTitle(Item as TAnalogInput)
  else if Item is TDigitalInput then
    Result := GetDigitalInputTitle(Item as TDigitalInput)
  else if Item is TDigitalOutput then
    Result := GetDigitalOutputTitle(Item as TDigitalOutput)
  else if Item is TRelay then
    Result := GetRelayTitle(Item as TRelay)
  else if Item is TWiegand then
    Result := GetWiegandTitle(Item as TWiegand)
  else if Item is TRS232 then
    Result := GetRS232Title(Item as TRS232)
  else if Item is TRS485 then
    Result := GetRS485Title(Item as TRS485)
  else if Item is TMotor then
    Result := GetMotorTitle(Item as TMotor)
  else
    Result := Format(SUnknownElement, [Item.ClassName]);
end;

end.
