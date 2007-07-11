// ----------------------------------------------------------------------------
// file: ConfigManipulator.pas - a part of AplaSter system
// date: 2006-08-30
// auth: Matthias Hryniszak
// desc: utilities to manage the configuration
// ----------------------------------------------------------------------------

unit ConfigManipulator;

{$IFOPT D+}
  {$DEFINE DEBUG}
{$ENDIF}

interface

uses
  Classes, SysUtils, Log4D,
  Config, Storage;

type
  TConfigManipulator = class (TObject)
  private
    FConfig: TConfig;
  protected
    class function Log: TLogLogger;
  public
    // instance access
    class function Instance(Config: TConfig): TConfigManipulator;
    // item selector functions
    function GetServerByName(Name: string): TServer;
    function GetServerByTag(Tag: Integer): TServer;
    function GetTimerByName(Server: TServer; Name: string): TTimer;
    function GetTimerByTag(Server: TServer; Tag: Integer): TTimer;
    function GetModuleByName(Server: TServer; Name: string): TModule;
    function GetModuleByTag(Server: TServer; Tag: Integer): TModule;
    function GetAnalogInputByName(Module: TModule; Name: string): TAnalogInput;
    function GetAnalogInputByTag(Module: TModule; Tag: Integer): TAnalogInput;
    function GetDigitalInputByName(Module: TModule; Name: string): TDigitalInput;
    function GetDigitalInputByTag(Module: TModule; Tag: Integer): TDigitalInput;
    function GetDigitalOutputByName(Module: TModule; Name: string): TDigitalOutput;
    function GetDigitalOutputByTag(Module: TModule; Tag: Integer): TDigitalOutput;
    function GetRelayByName(Module: TModule; Name: string): TRelay;
    function GetRelayByTag(Module: TModule; Tag: Integer): TRelay;
    function GetWiegandByName(Module: TModule; Name: string): TWiegand;
    function GetWiegandByTag(Module: TModule; Tag: Integer): TWiegand;
    function GetRS232ByName(Module: TModule; Name: string): TRS232;
    function GetRS232ByTag(Module: TModule; Tag: Integer): TRS232;
    function GetRS485ByName(Module: TModule; Name: string): TRS485;
    function GetRS485ByTag(Module: TModule; Tag: Integer): TRS485;
    function GetMotorByName(Module: TModule; Name: string): TMotor;
    function GetMotorByTag(Module: TModule; Tag: Integer): TMotor;
    // utility functions
    procedure AddScript(Code: TStrings);
    procedure DeleteServer(Server: TServer);
    procedure DeleteTimer(Timer: TTimer);
    procedure DeleteModule(Module: TModule);
    procedure DeleteFolder(Folder: TFolder);
    procedure AssignTimerToFolder(Folder: TFolder; Timer: TTimer);
    procedure RemoveTimerFromFolder(Folder: TFolder; Timer: TTimer);
    procedure AssignModuleToFolder(Folder: TFolder; Module: TModule);
    procedure RemoveModuleFromFolder(Folder: TFolder; Module: TModule);
  end;

implementation

uses
  DeviceIds, Options;

{ TConfigManipulator }

{ Protected declarations }

class function TConfigManipulator.Log: TLogLogger;
begin
  Result := TLogLogger.GetLogger(Self);
end;

{ Public declarations }

var
  _ConfigManipulator: TConfigManipulator;

class function TConfigManipulator.Instance(Config: TConfig): TConfigManipulator;
begin
  _ConfigManipulator.FConfig := Config;
  Result := _ConfigManipulator;
end;

// item selection functions

function TConfigManipulator.GetServerByName(Name: string): TServer;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to FConfig.Servers.Count - 1 do
    if AnsiSameText(FConfig.Servers[I].D.Title, Name) then
    begin
      Result := FConfig.Servers[I];
      Break;
    end;
end;

function TConfigManipulator.GetServerByTag(Tag: Integer): TServer;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to FConfig.Servers.Count - 1 do
    if FConfig.Servers[I].D.Tag = Tag then
    begin
      Result := FConfig.Servers[I];
      Break;
    end;
end;

function TConfigManipulator.GetTimerByName(Server: TServer; Name: string): TTimer;
var
  I: Integer;
begin
  Assert(Assigned(Server), 'Error: server cannot be nil');

  Result := nil;
  for I := 0 to Server.Timers.Count - 1 do
    if AnsiSameText(Server.Timers[I].D.Title, Name) then
    begin
      Result := Server.Timers[I];
      Break;
    end;
end;

function TConfigManipulator.GetTimerByTag(Server: TServer; Tag: Integer): TTimer;
var
  I: Integer;
begin
  Assert(Assigned(Server), 'Error: server cannot be nil');

  Result := nil;
  for I := 0 to Server.Timers.Count - 1 do
    if Server.Timers[I].D.Tag = Tag then
    begin
      Result := Server.Timers[I];
      Break;
    end;
end;

function TConfigManipulator.GetModuleByName(Server: TServer; Name: string): TModule;
var
  I: Integer;
begin
  Assert(Assigned(Server), 'Error: server cannot be nil');

  Result := nil;
  for I := 0 to Server.Modules.Count - 1 do
    if AnsiSameText(Server.Modules[I].D.Title, Name) then
    begin
      Result := Server.Modules[I];
      Break;
    end;
end;

function TConfigManipulator.GetModuleByTag(Server: TServer; Tag: Integer): TModule;
var
  I: Integer;
begin
  Assert(Assigned(Server), 'Error: server cannot be nil');

  Result := nil;
  for I := 0 to Server.Modules.Count - 1 do
    if Server.Modules[I].D.Tag = Tag then
    begin
      Result := Server.Modules[I];
      Break;
    end;
end;

function TConfigManipulator.GetAnalogInputByName(Module: TModule; Name: string): TAnalogInput;
var
  I: Integer;
begin
  Assert(Assigned(Module), 'Error: module cannot be nil');

  Result := nil;
  for I := 0 to Module.AnalogInputs.Count - 1 do
    if AnsiSameText(Module.AnalogInputs[I].D.Title, Name) then
    begin
      Result := Module.AnalogInputs[I];
      Break;
    end;
end;

function TConfigManipulator.GetAnalogInputByTag(Module: TModule; Tag: Integer): TAnalogInput;
var
  I: Integer;
begin
  Assert(Assigned(Module), 'Error: module cannot be nil');

  Result := nil;
  for I := 0 to Module.AnalogInputs.Count - 1 do
    if Module.AnalogInputs[I].D.Tag = Tag then
    begin
      Result := Module.AnalogInputs[I];
      Break;
    end;
end;

function TConfigManipulator.GetDigitalInputByName(Module: TModule; Name: string): TDigitalInput;
var
  I: Integer;
begin
  Assert(Assigned(Module), 'Error: module cannot be nil');

  Result := nil;
  for I := 0 to Module.DigitalInputs.Count - 1 do
    if AnsiSameText(Module.DigitalInputs[I].D.Title, Name) then
    begin
      Result := Module.DigitalInputs[I];
      Break;
    end;
end;

function TConfigManipulator.GetDigitalInputByTag(Module: TModule; Tag: Integer): TDigitalInput;
var
  I: Integer;
begin
  Assert(Assigned(Module), 'Error: module cannot be nil');

  Result := nil;
  for I := 0 to Module.DigitalInputs.Count - 1 do
    if Module.DigitalInputs[I].D.Tag = Tag then
    begin
      Result := Module.DigitalInputs[I];
      Break;
    end;
end;

function TConfigManipulator.GetDigitalOutputByName(Module: TModule; Name: string): TDigitalOutput;
var
  I: Integer;
begin
  Assert(Assigned(Module), 'Error: module cannot be nil');

  Result := nil;
  for I := 0 to Module.DigitalOutputs.Count - 1 do
    if AnsiSameText(Module.DigitalOutputs[I].D.Title, Name) then
    begin
      Result := Module.DigitalOutputs[I];
      Break;
    end;
end;

function TConfigManipulator.GetDigitalOutputByTag(Module: TModule; Tag: Integer): TDigitalOutput;
var
  I: Integer;
begin
  Assert(Assigned(Module), 'Error: module cannot be nil');

  Result := nil;
  for I := 0 to Module.DigitalOutputs.Count - 1 do
    if Module.DigitalOutputs[I].D.Tag = Tag then
    begin
      Result := Module.DigitalOutputs[I];
      Break;
    end;
end;

function TConfigManipulator.GetRelayByName(Module: TModule; Name: string): TRelay;
var
  I: Integer;
begin
  Assert(Assigned(Module), 'Error: module cannot be nil');

  Result := nil;
  for I := 0 to Module.Relays.Count - 1 do
    if AnsiSameText(Module.Relays[I].D.Title, Name) then
    begin
      Result := Module.Relays[I];
      Break;
    end;
end;

function TConfigManipulator.GetRelayByTag(Module: TModule; Tag: Integer): TRelay;
var
  I: Integer;
begin
  Assert(Assigned(Module), 'Error: module cannot be nil');

  Result := nil;
  for I := 0 to Module.Relays.Count - 1 do
    if Module.Relays[I].D.Tag = Tag then
    begin
      Result := Module.Relays[I];
      Break;
    end;
end;

function TConfigManipulator.GetWiegandByName(Module: TModule; Name: string): TWiegand;
var
  I: Integer;
begin
  Assert(Assigned(Module), 'Error: module cannot be nil');

  Result := nil;
  for I := 0 to Module.Wiegands.Count - 1 do
    if AnsiSameText(Module.Wiegands[I].D.Title, Name) then
    begin
      Result := Module.Wiegands[I];
      Break;
    end;
end;

function TConfigManipulator.GetWiegandByTag(Module: TModule; Tag: Integer): TWiegand;
var
  I: Integer;
begin
  Assert(Assigned(Module), 'Error: module cannot be nil');

  Result := nil;
  for I := 0 to Module.Wiegands.Count - 1 do
    if Module.Wiegands[I].D.Tag = Tag then
    begin
      Result := Module.Wiegands[I];
      Break;
    end;
end;

function TConfigManipulator.GetRS232ByName(Module: TModule; Name: string): TRS232;
var
  I: Integer;
begin
  Assert(Assigned(Module), 'Error: module cannot be nil');

  Result := nil;
  for I := 0 to Module.RS232s.Count - 1 do
    if AnsiSameText(Module.RS232s[I].D.Title, Name) then
    begin
      Result := Module.RS232s[I];
      Break;
    end;
end;

function TConfigManipulator.GetRS232ByTag(Module: TModule; Tag: Integer): TRS232;
var
  I: Integer;
begin
  Assert(Assigned(Module), 'Error: module cannot be nil');

  Result := nil;
  for I := 0 to Module.RS232s.Count - 1 do
    if Module.RS232s[I].D.Tag = Tag then
    begin
      Result := Module.RS232s[I];
      Break;
    end;
end;

function TConfigManipulator.GetRS485ByName(Module: TModule; Name: string): TRS485;
var
  I: Integer;
begin
  Assert(Assigned(Module), 'Error: module cannot be nil');

  Result := nil;
  for I := 0 to Module.RS485s.Count - 1 do
    if AnsiSameText(Module.RS485s[I].D.Title, Name) then
    begin
      Result := Module.RS485s[I];
      Break;
    end;
end;

function TConfigManipulator.GetRS485ByTag(Module: TModule; Tag: Integer): TRS485;
var
  I: Integer;
begin
  Assert(Assigned(Module), 'Error: module cannot be nil');

  Result := nil;
  for I := 0 to Module.RS485s.Count - 1 do
    if Module.RS485s[I].D.Tag = Tag then
    begin
      Result := Module.RS485s[I];
      Break;
    end;
end;

function TConfigManipulator.GetMotorByName(Module: TModule; Name: string): TMotor;
var
  I: Integer;
begin
  Assert(Assigned(Module), 'Error: module cannot be nil');

  Result := nil;
  for I := 0 to Module.Motors.Count - 1 do
    if AnsiSameText(Module.Motors[I].D.Title, Name) then
    begin
      Result := Module.Motors[I];
      Break;
    end;
end;

function TConfigManipulator.GetMotorByTag(Module: TModule; Tag: Integer): TMotor;
var
  I: Integer;
begin
  Assert(Assigned(Module), 'Error: module cannot be nil');

  Result := nil;
  for I := 0 to Module.Motors.Count - 1 do
    if Module.Motors[I].D.Tag = Tag then
    begin
      Result := Module.Motors[I];
      Break;
    end;
end;

// utility functions

procedure TConfigManipulator.AddScript(Code: TStrings);
begin
  with FConfig.ConfigFile do
  begin
    GlobalData.Code := GlobalData.Code + Code.Text;
    GlobalData.Modified := True;
  end;
end;

procedure TConfigManipulator.DeleteServer(Server: TServer);
var
  I, J: Integer;
begin
  Assert(Assigned(Server), 'Error: Server cannot be nil');

  with Server do
  begin
    for I := 0 to Folders.Count - 1 do
    begin
      Config.ConfigFile.DelRecord(Folders[I].D, True);
      Folders[I].Free;
    end;
    for I := 0 to Timers.Count - 1 do
    begin
      Config.ConfigFile.DelRecord(Timers[I].D, True);
      Timers[I].Free;
    end;
    for I := 0 to Modules.Count - 1 do
    begin
      for J := 0 to Modules[I].AnalogInputs.Count - 1 do
      begin
        Config.ConfigFile.DelRecord(Modules[I].AnalogInputs[J].D, True);
        Modules[I].AnalogInputs[J].Free;
      end;
      for J := 0 to Modules[I].DigitalInputs.Count - 1 do
      begin
        Config.ConfigFile.DelRecord(Modules[I].DigitalInputs[J].D, True);
        Modules[I].DigitalInputs[J].Free;
      end;
      for J := 0 to Modules[I].DigitalOutputs.Count - 1 do
      begin
        Config.ConfigFile.DelRecord(Modules[I].DigitalOutputs[J].D, True);
        Modules[I].DigitalOutputs[J].Free;
      end;
      for J := 0 to Modules[I].Relays.Count - 1 do
      begin
        Config.ConfigFile.DelRecord(Modules[I].Relays[J].D, True);
        Modules[I].Relays[J].Free;
      end;
      for J := 0 to Modules[I].Wiegands.Count - 1 do
      begin
        Config.ConfigFile.DelRecord(Modules[I].Wiegands[J].D, True);
        Modules[I].Wiegands[J].Free;
      end;
      for J := 0 to Modules[I].RS232s.Count - 1 do
      begin
        Config.ConfigFile.DelRecord(Modules[I].RS232s[J].D, True);
        Modules[I].RS232s[J].Free;
      end;
      for J := 0 to Modules[I].RS485s.Count - 1 do
      begin
        Config.ConfigFile.DelRecord(Modules[I].RS485s[J].D, True);
        Modules[I].RS485s[J].Free;
      end;
      for J := 0 to Modules[I].Motors.Count - 1 do
      begin
        Config.ConfigFile.DelRecord(Modules[I].Motors[J].D, True);
        Modules[I].Motors[J].Free;
      end;
      Config.ConfigFile.DelRecord(Modules[I].D, True);
      Modules[I].Free;
    end;
    Config.ConfigFile.DelRecord(D, True);
    Config.Servers.Remove(Server);
    Free;
  end;

  FConfig.UpdateLists;
end;

procedure TConfigManipulator.DeleteTimer(Timer: TTimer);
begin
  Assert(Assigned(Timer), 'Error: Timer cannot be nil');

  with Timer do
  begin
    Config.ConfigFile.DelRecord(D, True);
    Free;
  end;

  FConfig.UpdateLists;
end;

procedure TConfigManipulator.DeleteModule(Module: TModule);
var
  I: Integer;
begin
  Assert(Assigned(Module), 'Error: Module cannot be nil');

  with Module do
  begin
    for I := 0 to AnalogInputs.Count - 1 do
    begin
      Config.ConfigFile.DelRecord(AnalogInputs[I].D, True);
      AnalogInputs[I].Free;
    end;
    for I := 0 to DigitalInputs.Count - 1 do
    begin
      Config.ConfigFile.DelRecord(DigitalInputs[I].D, True);
      DigitalInputs[I].Free;
    end;
    for I := 0 to DigitalOutputs.Count - 1 do
    begin
      Config.ConfigFile.DelRecord(DigitalOutputs[I].D, True);
      DigitalOutputs[I].Free;
    end;
    for I := 0 to Relays.Count - 1 do
    begin
      Config.ConfigFile.DelRecord(Relays[I].D, True);
      Relays[I].Free;
    end;
    for I := 0 to Wiegands.Count - 1 do
    begin
      Config.ConfigFile.DelRecord(Wiegands[I].D, True);
      Wiegands[I].Free;
    end;
    for I := 0 to RS232s.Count - 1 do
    begin
      Config.ConfigFile.DelRecord(RS232s[I].D, True);
      RS232s[I].Free;
    end;
    for I := 0 to RS485s.Count - 1 do
    begin
      Config.ConfigFile.DelRecord(RS485s[I].D, True);
      RS485s[I].Free;
    end;
    for I := 0 to Motors.Count - 1 do
    begin
      Config.ConfigFile.DelRecord(Motors[I].D, True);
      Motors[I].Free;
    end;
    Config.ConfigFile.DelRecord(D, True);
    Free;
  end;

  FConfig.UpdateLists;
end;

procedure TConfigManipulator.DeleteFolder(Folder: TFolder);
var
  I: Integer;
begin
  Assert(Assigned(Folder), 'Error: Folder cannot be nil');

  with Folder do
  begin
    for I := 0 to Timers.Count - 1 do
      Timers[I].D.FolderId := 0;
    for I := 0 to Modules.Count - 1 do
      Modules[I].D.FolderId := 0;

    Config.ConfigFile.DelRecord(Folder.D, True);
    Free;
  end;

  FConfig.UpdateLists;
end;

procedure TConfigManipulator.AssignTimerToFolder(Folder: TFolder; Timer: TTimer);
begin
  Assert(Assigned(Folder), 'Error: Folder cannot be nil');
  Assert(Assigned(Timer), 'Error: Timer cannot be nil');

  Timer.D.FolderId := Folder.Id;
  Timer.D.Modified := True;
  FConfig.UpdateLists;
end;

procedure TConfigManipulator.RemoveTimerFromFolder(Folder: TFolder; Timer: TTimer);
begin
  Assert(Assigned(Folder), 'Error: Folder cannot be nil');
  Assert(Assigned(Timer), 'Error: Timer cannot be nil');

  Timer.D.FolderId := 0;
  Timer.D.Modified := True;
  FConfig.UpdateLists;
end;

procedure TConfigManipulator.AssignModuleToFolder(Folder: TFolder; Module: TModule);
begin
  Assert(Assigned(Folder), 'Error: Folder cannot be nil');
  Assert(Assigned(Module), 'Error: Module cannot be nil');

  Module.D.FolderId := Folder.Id;
  Module.D.Modified := True;
  FConfig.UpdateLists;
end;

procedure TConfigManipulator.RemoveModuleFromFolder(Folder: TFolder; Module: TModule);
begin
  Assert(Assigned(Folder), 'Error: Folder cannot be nil');
  Assert(Assigned(Module), 'Error: Module cannot be nil');

  Module.D.FolderId := 0;
  Module.D.Modified := True;
  FConfig.UpdateLists;
end;

initialization
  _ConfigManipulator := TConfigManipulator.Create;

finalization
  FreeAndNil(_ConfigManipulator);

end.

