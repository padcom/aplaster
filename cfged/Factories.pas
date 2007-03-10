// ----------------------------------------------------------------------------
// file: Factories.pas - a part of AplaSter system
// date: 2005-09-08
// auth: Matthias Hryniszak
// desc: factories for complex object agregation
// ----------------------------------------------------------------------------

unit Factories;

{$IFOPT D+}
  {$DEFINE DEBUG}
{$ENDIF}

interface

uses
  Classes, SysUtils,
  Config, Storage;

type
  TConfigFactory = class (TObject)
  private
    FConfig: TConfig;
  public
    function CreateServer: TServer;
    function CreateModule(Server: TServer): TModule;
    function CreateTimer(Server: TServer): TTimer;
    function CreateFolder(Server: TServer): TFolder;
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

  TFileStorageFactory = class (TObject)
    function CreateFileStorage: TFileStorage;
  end;

function ConfigFactory(Config: TConfig): TConfigFactory;
function FileStorageFactory: TFileStorageFactory;

implementation

uses
  DeviceIds, RtOpts;

{ TConfigFactory }

function TConfigFactory.CreateServer: TServer;
begin
  Result := TServer.Create(FConfig, nil, FConfig.ConfigFile.AddServerData);
  FConfig.Servers.Add(Result);
  FConfig.UpdateLists;
end;

function TConfigFactory.CreateModule(Server: TServer): TModule;
var
  AnalogIn: TAnalogInput;
  DigiIn  : TDigitalInput;
  DigiOut : TDigitalOutput;
  Relay   : TRelay;
  Wiegand : TWiegand;
  RS232   : TRS232;
//  RS485   : TRS485;
  Motor   : TMotor;
begin
  Result := TModule.Create(FConfig, Server, FConfig.ConfigFile.AddModuleData);
  Result.D.ParentId := Server.Id;
  AnalogIn := TAnalogInput.Create(FConfig, Result, FConfig.ConfigFile.AddAnalogInputData);
  AnalogIn.D.ParentId := Result.Id;
  AnalogIn.D.DevId := DID_ANALOGINPUT0;
  AnalogIn.D.DeltaChange := 1;
  AnalogIn.D.Connector := 'X-2/1';
  AnalogIn := TAnalogInput.Create(FConfig, Result, FConfig.ConfigFile.AddAnalogInputData);
  AnalogIn.D.ParentId := Result.Id;
  AnalogIn.D.DevId := DID_ANALOGINPUT1;
  AnalogIn.D.DeltaChange := 1;
  AnalogIn.D.Connector := 'X-2/2';
  DigiIn := TDigitalInput.Create(FConfig, Result, FConfig.ConfigFile.AddDigitalInputData);
  DigiIn.D.ParentId := Result.Id;
  DigiIn.D.DevId := DID_DIGITALINPUT0;
  DigiIn.D.Connector := 'X-3/1';
  DigiIn := TDigitalInput.Create(FConfig, Result, FConfig.ConfigFile.AddDigitalInputData);
  DigiIn.D.ParentId := Result.Id;
  DigiIn.D.DevId := DID_DIGITALINPUT1;
  DigiIn.D.Connector := 'X-3/2';
  DigiIn := TDigitalInput.Create(FConfig, Result, FConfig.ConfigFile.AddDigitalInputData);
  DigiIn.D.ParentId := Result.Id;
  DigiIn.D.DevId := DID_DIGITALINPUT2;
  DigiIn.D.Connector := 'X-3/3';
  DigiIn := TDigitalInput.Create(FConfig, Result, FConfig.ConfigFile.AddDigitalInputData);
  DigiIn.D.ParentId := Result.Id;
  DigiIn.D.DevId := DID_DIGITALINPUT3;
  DigiIn.D.Connector := 'X-3/4';
  DigiIn := TDigitalInput.Create(FConfig, Result, FConfig.ConfigFile.AddDigitalInputData);
  DigiIn.D.ParentId := Result.Id;
  DigiIn.D.DevId := DID_DIGITALINPUT4;
  DigiIn.D.Connector := 'X-3/5';
  DigiIn := TDigitalInput.Create(FConfig, Result, FConfig.ConfigFile.AddDigitalInputData);
  DigiIn.D.ParentId := Result.Id;
  DigiIn.D.DevId := DID_DIGITALINPUT5;
  DigiIn.D.Connector := 'X-3/6';
  DigiIn := TDigitalInput.Create(FConfig, Result, FConfig.ConfigFile.AddDigitalInputData);
  DigiIn.D.ParentId := Result.Id;
  DigiIn.D.DevId := DID_DIGITALINPUT6;
  DigiIn.D.Connector := 'X-3/7';
  DigiIn := TDigitalInput.Create(FConfig, Result, FConfig.ConfigFile.AddDigitalInputData);
  DigiIn.D.ParentId := Result.Id;
  DigiIn.D.DevId := DID_DIGITALINPUT7;
  DigiIn.D.Connector := 'X-3/8';
  DigiOut := TDigitalOutput.Create(FConfig, Result, FConfig.ConfigFile.AddDigitalOutputData);
  DigiOut.D.ParentId := Result.Id;
  DigiOut.D.DevId := DID_DIGITALOUTPUT0;
  DigiOut.D.Connector := 'X-4/1';
  DigiOut := TDigitalOutput.Create(FConfig, Result, FConfig.ConfigFile.AddDigitalOutputData);
  DigiOut.D.ParentId := Result.Id;
  DigiOut.D.DevId := DID_DIGITALOUTPUT1;
  DigiOut.D.Connector := 'X-4/2';
  DigiOut := TDigitalOutput.Create(FConfig, Result, FConfig.ConfigFile.AddDigitalOutputData);
  DigiOut.D.ParentId := Result.Id;
  DigiOut.D.DevId := DID_DIGITALOUTPUT2;
  DigiOut.D.Connector := 'X-4/3';
  DigiOut := TDigitalOutput.Create(FConfig, Result, FConfig.ConfigFile.AddDigitalOutputData);
  DigiOut.D.ParentId := Result.Id;
  DigiOut.D.DevId := DID_DIGITALOUTPUT3;
  DigiOut.D.Connector := 'X-4/4';
  DigiOut := TDigitalOutput.Create(FConfig, Result, FConfig.ConfigFile.AddDigitalOutputData);
  DigiOut.D.ParentId := Result.Id;
  DigiOut.D.DevId := DID_DIGITALOUTPUT4;
  DigiOut.D.Connector := 'X-4/5';
  DigiOut := TDigitalOutput.Create(FConfig, Result, FConfig.ConfigFile.AddDigitalOutputData);
  DigiOut.D.ParentId := Result.Id;
  DigiOut.D.DevId := DID_DIGITALOUTPUT5;
  DigiOut.D.Connector := 'X-4/6';
  Relay := TRelay.Create(FConfig, Result, FConfig.ConfigFile.AddRelayData);
  Relay.D.ParentId := Result.Id;
  Relay.D.DevId := DID_RELAY0;
  Relay.D.Connector := 'X-5/1..2';
  Relay := TRelay.Create(FConfig, Result, FConfig.ConfigFile.AddRelayData);
  Relay.D.ParentId := Result.Id;
  Relay.D.DevId := DID_RELAY1;
  Relay.D.Connector := 'X-5/3..4';
  Relay := TRelay.Create(FConfig, Result, FConfig.ConfigFile.AddRelayData);
  Relay.D.ParentId := Result.Id;
  Relay.D.DevId := DID_RELAY2;
  Relay.D.Connector := 'X-5/5..6';
  Wiegand := TWiegand.Create(FConfig, Result, FConfig.ConfigFile.AddWiegandData);
  Wiegand.D.ParentId := Result.Id;
  Wiegand.D.DevId := DID_WIEGAND0;
  Wiegand.D.DataBits := 32;
  Wiegand.D.Connector := 'X-6/1..2';
  Wiegand := TWiegand.Create(FConfig, Result, FConfig.ConfigFile.AddWiegandData);
  Wiegand.D.ParentId := Result.Id;
  Wiegand.D.DevId := DID_WIEGAND1;
  Wiegand.D.DataBits := 32;
  Wiegand.D.Connector := 'X-7/1..2';
  RS232 := TRS232.Create(FConfig, Result, FConfig.ConfigFile.AddRS232Data);
  RS232.D.ParentId := Result.Id;
  RS232.D.DevId := DID_RS2320;
  RS232.D.Bitrate := BITRATE_9600;
  RS232.D.DataBits := DATABITS_8;
  RS232.D.Parity := PARITY_NONE;
  RS232.D.StopBits := STOPBITS_ONE;
  RS232.D.Connector := 'X-8/1..3';
//  RS485 := TRS485.Create(FConfig, Result, FConfig.ConfigFile.AddRS485Data);
//  RS485.D.ParentId := Result.Id;
//  RS485.D.DevId := DID_RS4850;
//  RS485.D.Bitrate := BITRATE_9600;
//  RS485.D.DataBits := DATABITS_8;
//  RS485.D.Parity := PARITY_NONE;
//  RS485.D.StopBits := STOPBITS_ONE;
//  RS485.D.Connector := 'X-?/1..5';
//  RS485 := TRS485.Create(FConfig, Result, FConfig.ConfigFile.AddRS485Data);
//  RS485.D.ParentId := Result.Id;
//  RS485.D.DevId := DID_RS4851;
//  RS485.D.Bitrate := BITRATE_9600;
//  RS485.D.DataBits := DATABITS_8;
//  RS485.D.Parity := PARITY_NONE;
//  RS485.D.StopBits := STOPBITS_ONE;
//  RS485.D.Connector := 'X-?/1..5';
  Motor := TMotor.Create(FConfig, Result, FConfig.ConfigFile.AddMotorData);
  Motor.D.ParentId := Result.Id;
  Motor.D.DevId := DID_MOTOR0;
  Motor.D.Connector := 'X-9/1..2';
  FConfig.UpdateLists;
end;

function TConfigFactory.CreateTimer(Server: TServer): TTimer;
begin
  Result := TTimer.Create(FConfig, Server, FConfig.ConfigFile.AddTimerData);
  Result.D.ParentId := Server.Id;
  Result.D.Interval := 10000;
  FConfig.UpdateLists;
end;

function TConfigFactory.CreateFolder(Server: TServer): TFolder;
begin
  Result := TFolder.Create(FConfig, Server, FConfig.ConfigFile.AddFolderData);
  Result.D.ServerId := Server.Id;
  FConfig.UpdateLists;
end;

// item selection functions

function TConfigFactory.GetServerByName(Name: string): TServer;
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

function TConfigFactory.GetServerByTag(Tag: Integer): TServer;
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

function TConfigFactory.GetTimerByName(Server: TServer; Name: string): TTimer;
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

function TConfigFactory.GetTimerByTag(Server: TServer; Tag: Integer): TTimer;
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

function TConfigFactory.GetModuleByName(Server: TServer; Name: string): TModule;
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

function TConfigFactory.GetModuleByTag(Server: TServer; Tag: Integer): TModule;
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

function TConfigFactory.GetAnalogInputByName(Module: TModule; Name: string): TAnalogInput;
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

function TConfigFactory.GetAnalogInputByTag(Module: TModule; Tag: Integer): TAnalogInput;
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

function TConfigFactory.GetDigitalInputByName(Module: TModule; Name: string): TDigitalInput;
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

function TConfigFactory.GetDigitalInputByTag(Module: TModule; Tag: Integer): TDigitalInput;
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

function TConfigFactory.GetDigitalOutputByName(Module: TModule; Name: string): TDigitalOutput;
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

function TConfigFactory.GetDigitalOutputByTag(Module: TModule; Tag: Integer): TDigitalOutput;
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

function TConfigFactory.GetRelayByName(Module: TModule; Name: string): TRelay;
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

function TConfigFactory.GetRelayByTag(Module: TModule; Tag: Integer): TRelay;
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

function TConfigFactory.GetWiegandByName(Module: TModule; Name: string): TWiegand;
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

function TConfigFactory.GetWiegandByTag(Module: TModule; Tag: Integer): TWiegand;
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

function TConfigFactory.GetRS232ByName(Module: TModule; Name: string): TRS232;
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

function TConfigFactory.GetRS232ByTag(Module: TModule; Tag: Integer): TRS232;
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

function TConfigFactory.GetRS485ByName(Module: TModule; Name: string): TRS485;
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

function TConfigFactory.GetRS485ByTag(Module: TModule; Tag: Integer): TRS485;
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

function TConfigFactory.GetMotorByName(Module: TModule; Name: string): TMotor;
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

function TConfigFactory.GetMotorByTag(Module: TModule; Tag: Integer): TMotor;
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

procedure TConfigFactory.AddScript(Code: TStrings);
begin
  with FConfig.ConfigFile do
  begin
    GlobalData.Code := GlobalData.Code + Code.Text;
    GlobalData.Modified := True;
  end;
end;

procedure TConfigFactory.DeleteServer(Server: TServer);
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

procedure TConfigFactory.DeleteTimer(Timer: TTimer);
begin
  Assert(Assigned(Timer), 'Error: Timer cannot be nil');

  with Timer do
  begin
    Config.ConfigFile.DelRecord(D, True);
    Free;
  end;

  FConfig.UpdateLists;
end;

procedure TConfigFactory.DeleteModule(Module: TModule);
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

procedure TConfigFactory.DeleteFolder(Folder: TFolder);
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

procedure TConfigFactory.AssignTimerToFolder(Folder: TFolder; Timer: TTimer);
begin
  Assert(Assigned(Folder), 'Error: Folder cannot be nil');
  Assert(Assigned(Timer), 'Error: Timer cannot be nil');

  Timer.D.FolderId := Folder.Id;
  Timer.D.Modified := True;
  FConfig.UpdateLists;
end;

procedure TConfigFactory.RemoveTimerFromFolder(Folder: TFolder; Timer: TTimer);
begin
  Assert(Assigned(Folder), 'Error: Folder cannot be nil');
  Assert(Assigned(Timer), 'Error: Timer cannot be nil');

  Timer.D.FolderId := 0;
  Timer.D.Modified := True;
  FConfig.UpdateLists;
end;

procedure TConfigFactory.AssignModuleToFolder(Folder: TFolder; Module: TModule);
begin
  Assert(Assigned(Folder), 'Error: Folder cannot be nil');
  Assert(Assigned(Module), 'Error: Module cannot be nil');

  Module.D.FolderId := Folder.Id;
  Module.D.Modified := True;
  FConfig.UpdateLists;
end;

procedure TConfigFactory.RemoveModuleFromFolder(Folder: TFolder; Module: TModule);
begin
  Assert(Assigned(Folder), 'Error: Folder cannot be nil');
  Assert(Assigned(Module), 'Error: Module cannot be nil');

  Module.D.FolderId := 0;
  Module.D.Modified := True;
  FConfig.UpdateLists;
end;

{ TFileStorageFactory }

function TFileStorageFactory.CreateFileStorage: TFileStorage;
begin
  // for now only DBFileStorage is implemented
  Result := TDBFileStorage.Create(Options.DBServer + ':' + Options.DBDatabase);
end;

{ *** }

var
  _ConfigFactory: TConfigFactory;

function ConfigFactory(Config: TConfig): TConfigFactory;
begin
  _ConfigFactory.FConfig := Config;
  Result := _ConfigFactory;
end;

var
  _FileStorageFactory: TFileStorageFactory = nil;

function FileStorageFactory: TFileStorageFactory;
begin
  Result := _FileStorageFactory;
end;

initialization
  _ConfigFactory := TConfigFactory.Create;
  _FileStorageFactory := TFileStorageFactory.Create;

finalization
  FreeAndNil(_ConfigFactory);
  FreeAndNil(_FileStorageFactory);

end.

