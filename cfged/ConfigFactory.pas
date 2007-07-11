// ----------------------------------------------------------------------------
// file: ConfigFactory.pas - a part of AplaSter system
// date: 2005-09-08
// auth: Matthias Hryniszak
// desc: factories for complex object agregation
// ----------------------------------------------------------------------------

unit ConfigFactory;

{$IFOPT D+}
  {$DEFINE DEBUG}
{$ENDIF}

interface

uses
  Classes, SysUtils, Log4D,
  Config, Storage;

type
  TConfigFactory = class (TObject)
  private
    class function CreateAnalogInput(Module: TModule; DevId: Integer; DeltaChange: Integer; Connector: WideString): TAnalogInput;
    class function CreateDigitalInput(Module: TModule; DevId: Integer; Connector: WideString): TDigitalInput;
    class function CreateDigitalOutput(Module: TModule; DevId: Integer; Connector: WideString): TDigitalOutput;
    class function CreateRelay(Module: TModule; DevId: Integer; Connector: WideString): TRelay;
    class function CreateWiegand(Module: TModule; DevId: Integer; DataBits: Integer; Connector: WideString): TWiegand;
    class function CreateRS232(Module: TModule; DevId: Integer; Bitrate, DataBits, Parity, StopBits: Integer; Connector: WideString): TRS232;
    class function CreateRS485(Module: TModule; DevId: Integer; Bitrate, DataBits, Parity, StopBits: Integer; Connector: WideString): TRS485;
    class function CreateMotor(Module: TModule; DevId: Integer; Connector: WideString): TMotor;
  protected
    class function Log: TLogLogger;
  public
    // main objects creation function
    class function CreateServer(Config: TConfig): TServer;
    class function CreateModule(Server: TServer): TModule;
    class function CreateTimer(Server: TServer): TTimer;
    class function CreateFolder(Server: TServer): TFolder;
  end;

implementation

uses
  DeviceIds, Options;

{ TConfigFactory }

{ Private declarations }

class function TConfigFactory.CreateAnalogInput(Module: TModule; DevId: Integer; DeltaChange: Integer; Connector: WideString): TAnalogInput;
begin
  Result := TAnalogInput.Create(Module.Config, Module, Module.Config.ConfigFile.AddAnalogInputData);
  Result.D.ParentId := Module.Id;
  Result.D.DevId := DevId;
  Result.D.DeltaChange := DeltaChange;
  Result.D.Connector := Connector;
end;

class function TConfigFactory.CreateDigitalInput(Module: TModule; DevId: Integer; Connector: WideString): TDigitalInput;
begin
  Result := TDigitalInput.Create(Module.Config, Module, Module.Config.ConfigFile.AddDigitalInputData);
  Result.D.ParentId := Module.Id;
  Result.D.DevId := DevId;
  Result.D.Connector := Connector;
end;

class function TConfigFactory.CreateDigitalOutput(Module: TModule; DevId: Integer; Connector: WideString): TDigitalOutput;
begin
  Result := TDigitalOutput.Create(Module.Config, Module, Module.Config.ConfigFile.AddDigitalOutputData);
  Result.D.ParentId := Module.Id;
  Result.D.DevId := DevId;
  Result.D.Connector := Connector;
end;

class function TConfigFactory.CreateRelay(Module: TModule; DevId: Integer; Connector: WideString): TRelay;
begin
  Result := TRelay.Create(Module.Config, Module, Module.Config.ConfigFile.AddRelayData);
  Result.D.ParentId := Module.Id;
  Result.D.DevId := DevId;
  Result.D.Connector := Connector;
end;

class function TConfigFactory.CreateWiegand(Module: TModule; DevId: Integer; DataBits: Integer; Connector: WideString): TWiegand;
begin
  Result := TWiegand.Create(Module.Config, Module, Module.Config.ConfigFile.AddWiegandData);
  Result.D.ParentId := Module.Id;
  Result.D.DevId := DevId;
  Result.D.DataBits := DataBits;
  Result.D.Connector := Connector;
end;

class function TConfigFactory.CreateRS232(Module: TModule; DevId: Integer; Bitrate, DataBits, Parity, StopBits: Integer; Connector: WideString): TRS232;
begin
  Result := TRS232.Create(Module.Config, Module, Module.Config.ConfigFile.AddRS232Data);
  Result.D.ParentId := Module.Id;
  Result.D.DevId := DevId;
  Result.D.DataBits := DataBits;
  Result.D.Connector := Connector;
end;

class function TConfigFactory.CreateRS485(Module: TModule; DevId: Integer; Bitrate, DataBits, Parity, StopBits: Integer; Connector: WideString): TRS485;
begin
  Result := TRS485.Create(Module.Config, Module, Module.Config.ConfigFile.AddRS485Data);
  Result.D.ParentId := Module.Id;
  Result.D.DevId := DevId;
  Result.D.DataBits := DataBits;
  Result.D.Connector := Connector;
end;

class function TConfigFactory.CreateMotor(Module: TModule; DevId: Integer; Connector: WideString): TMotor;
begin
  Result := TMotor.Create(Module.Config, Module, Module.Config.ConfigFile.AddMotorData);
  Result.D.ParentId := Module.Id;
  Result.D.DevId := DevId;
  Result.D.Connector := Connector;
end;

{ Protected declarations }

class function TConfigFactory.Log: TLogLogger;
begin
  Result := TLogLogger.GetLogger(Self);
end;

{ Public declarations }

class function TConfigFactory.CreateServer(Config: TConfig): TServer;
begin
  Result := TServer.Create(Config, nil, Config.ConfigFile.AddServerData);
  Config.Servers.Add(Result);
  Config.UpdateLists;
end;

class function TConfigFactory.CreateModule(Server: TServer): TModule;
begin
  Result := TModule.Create(Server.Config, Server, Server.Config.ConfigFile.AddModuleData);
  Result.D.ParentId := Server.Id;
  CreateAnalogInput(Result, DID_ANALOGINPUT0, 1, 'X-2/1');
  CreateAnalogInput(Result, DID_ANALOGINPUT1, 1, 'X-2/2');
  CreateDigitalInput(Result, DID_DIGITALINPUT0, 'X-3/1');
  CreateDigitalInput(Result, DID_DIGITALINPUT1, 'X-3/2');
  CreateDigitalInput(Result, DID_DIGITALINPUT2, 'X-3/3');
  CreateDigitalInput(Result, DID_DIGITALINPUT3, 'X-3/4');
  CreateDigitalInput(Result, DID_DIGITALINPUT4, 'X-3/5');
  CreateDigitalInput(Result, DID_DIGITALINPUT5, 'X-3/6');
  CreateDigitalInput(Result, DID_DIGITALINPUT6, 'X-3/7');
  CreateDigitalInput(Result, DID_DIGITALINPUT7, 'X-3/8');
  CreateDigitalOutput(Result, DID_DIGITALOUTPUT0, 'X-4/1');
  CreateDigitalOutput(Result, DID_DIGITALOUTPUT1, 'X-4/2');
  CreateDigitalOutput(Result, DID_DIGITALOUTPUT2, 'X-4/3');
  CreateDigitalOutput(Result, DID_DIGITALOUTPUT3, 'X-4/4');
  CreateDigitalOutput(Result, DID_DIGITALOUTPUT4, 'X-4/5');
  CreateDigitalOutput(Result, DID_DIGITALOUTPUT5, 'X-4/6');
  CreateRelay(Result, DID_RELAY0, 'X-5/1..2');
  CreateRelay(Result, DID_RELAY1, 'X-5/3..4');
  CreateRelay(Result, DID_RELAY2, 'X-5/5..6');
  CreateWiegand(Result, DID_WIEGAND0, 32, 'X-6/1..2');
  CreateWiegand(Result, DID_WIEGAND1, 32, 'X-7/1..2');
  CreateRS232(Result, DID_RS2320, BITRATE_9600, DATABITS_8, PARITY_NONE, STOPBITS_ONE, 'X-8/1..3');
  CreateRS485(Result, DID_RS4850, BITRATE_9600, DATABITS_8, PARITY_NONE, STOPBITS_ONE, 'X-9/1..5');
  CreateRS485(Result, DID_RS4851, BITRATE_9600, DATABITS_8, PARITY_NONE, STOPBITS_ONE, 'X-9/1..5');
  CreateMotor(Result, DID_MOTOR0, 'X-10/1..2');
  Server.Config.UpdateLists;
end;

class function TConfigFactory.CreateTimer(Server: TServer): TTimer;
begin
  Result := TTimer.Create(Server.Config, Server, Server.Config.ConfigFile.AddTimerData);
  Result.D.ParentId := Server.Id;
  Result.D.Interval := 10000;
  Server.Config.UpdateLists;
end;

class function TConfigFactory.CreateFolder(Server: TServer): TFolder;
begin
  Result := TFolder.Create(Server.Config, Server, Server.Config.ConfigFile.AddFolderData);
  Result.D.ServerId := Server.Id;
  Server.Config.UpdateLists;
end;

end.

