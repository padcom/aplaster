// ----------------------------------------------------------------------------
// file: ViewUtilsForServer.pas - a part of AplaSter system
// date: 2005-09-08
// auth: Matthias Hryniszak
// desc: various view utilities for aplaster server
// ----------------------------------------------------------------------------

unit ViewUtilsForServer;

interface

uses
  Classes, SysUtils,
  Config, ScriptObjects, ViewUtils;

type
  TConfigTreeDisplayerForServer = class (TConfigTreeDisplayer)
  private
    FServer: TPSServer;
  protected
    function GetServerTitle(Server: TServer): string; override;
    function GetFolderTitle(Folder: TFolder): string; override;
    function GetTimerTitle(Timer: TTimer): string; override;
    function GetModuleTitle(Module: TModule): string; override;
    function GetAnalogInputTitle(AnalogInput: TAnalogInput): string; override;
    function GetDigitalInputTitle(DigitalInput: TDigitalInput): string; override;
    function GetDigitalOutputTitle(DigitalOutput: TDigitalOutput): string; override;
    function GetRelayTitle(Relay: TRelay): string; override;
    function GetWiegandTitle(Wiegand: TWiegand): string; override;
    function GetRS232Title(RS232: TRS232): string; override;
    function GetRS485Title(RS485: TRS485): string; override;
    function GetMotorTitle(Motor: TMotor): string; override;
  public
    constructor Create(AServer: TPSServer);
  end;

implementation

uses
  Resources;

{ TConfigTreeDisplayerForServer }

{ Protected declarations }

function TConfigTreeDisplayerForServer.GetServerTitle(Server: TServer): string;
begin
  Result := inherited GetServerTitle(Server);
end;

function TConfigTreeDisplayerForServer.GetFolderTitle(Folder: TFolder): string;
begin
  Result := inherited GetFolderTitle(Folder);
end;

function TConfigTreeDisplayerForServer.GetTimerTitle(Timer: TTimer): string;
var
  I: Integer;
  ScriptObject: TPSTimer;
begin
  Result := inherited GetTimerTitle(Timer);

  // find script object
  ScriptObject := nil;
  for I := 0 to FServer.Timers.Count - 1 do
    if FServer.Timers[I].D.Id = Timer.Id then
      begin
        ScriptObject := FServer.Timers[I];
        Break;
      end;

  if Assigned(ScriptObject) then
  begin
    // add status text
    if ScriptObject.Running then
      Result := Result + ' (' + SRunning + ')'
    else
      Result := Result + ' (' + SNotRunning + ')'
  end;
end;

function TConfigTreeDisplayerForServer.GetModuleTitle(Module: TModule): string;
begin
  Result := inherited GetModuleTitle(Module);
end;

function TConfigTreeDisplayerForServer.GetAnalogInputTitle(AnalogInput: TAnalogInput): string;
var
  I, J: Integer;
  ScriptObject: TPSAnalogInput;
begin
  Result := inherited GetAnalogInputTitle(AnalogInput);

  // find script object
  ScriptObject := nil;
  for I := 0 to FServer.Modules.Count - 1 do
    for J := 0 to FServer.Modules[I].AnalogInputs.Count - 1 do
      if FServer.Modules[I].AnalogInputs[J].D.Id = AnalogInput.Id then
      begin
        ScriptObject := FServer.Modules[I].AnalogInputs[J];
        Break;
      end;

  if Assigned(ScriptObject) then
  begin
    // add status text
    Result := Result + ' (' + Format(SAnalogInputStatus, [ScriptObject.Value]) + ')';
  end;
end;

function TConfigTreeDisplayerForServer.GetDigitalInputTitle(DigitalInput: TDigitalInput): string;
var
  I, J: Integer;
  ScriptObject: TPSDigitalInput;
begin
  Result := inherited GetDigitalInputTitle(DigitalInput);

  // find script object
  ScriptObject := nil;
  for I := 0 to FServer.Modules.Count - 1 do
    for J := 0 to FServer.Modules[I].DigitalInputs.Count - 1 do
      if FServer.Modules[I].DigitalInputs[J].D.Id = DigitalInput.Id then
      begin
        ScriptObject := FServer.Modules[I].DigitalInputs[J];
        Break;
      end;

  if Assigned(ScriptObject) then
  begin
    // add status text
    if ScriptObject.Status then
      Result := Result + ' (' + SClose + ')'
    else
      Result := Result + ' (' + SOpen + ')'
  end;
end;

function TConfigTreeDisplayerForServer.GetDigitalOutputTitle(DigitalOutput: TDigitalOutput): string;
var
  I, J: Integer;
  ScriptObject: TPSDigitalOutput;
begin
  Result := inherited GetDigitalOutputTitle(DigitalOutput);

  // find script object
  ScriptObject := nil;
  for I := 0 to FServer.Modules.Count - 1 do
    for J := 0 to FServer.Modules[I].DigitalOutputs.Count - 1 do
      if FServer.Modules[I].DigitalOutputs[J].D.Id = DigitalOutput.Id then
      begin
        ScriptObject := FServer.Modules[I].DigitalOutputs[J];
        Break;
      end;

  if Assigned(ScriptObject) then
  begin
    // add status text
    if ScriptObject.Status then
      Result := Result + ' (' + SClose + ')'
    else
      Result := Result + ' (' + SOpen + ')'
  end;
end;

function TConfigTreeDisplayerForServer.GetRelayTitle(Relay: TRelay): string;
var
  I, J: Integer;
  ScriptObject: TPSRelay;
begin
  Result := inherited GetRelayTitle(Relay);

  // find script object
  ScriptObject := nil;
  for I := 0 to FServer.Modules.Count - 1 do
    for J := 0 to FServer.Modules[I].Relays.Count - 1 do
      if FServer.Modules[I].Relays[J].D.Id = Relay.Id then
      begin
        ScriptObject := FServer.Modules[I].Relays[J];
        Break;
      end;

  if Assigned(ScriptObject) then
  begin
    // add status text
    if ScriptObject.Status then
      Result := Result + ' (' + SClose + ')'
    else
      Result := Result + ' (' + SOpen + ')'
  end;
end;

function TConfigTreeDisplayerForServer.GetWiegandTitle(Wiegand: TWiegand): string;
begin
  Result := inherited GetWiegandTitle(Wiegand);
end;

function TConfigTreeDisplayerForServer.GetRS232Title(RS232: TRS232): string;
begin
  Result := inherited GetRS232Title(RS232);
end;

function TConfigTreeDisplayerForServer.GetRS485Title(RS485: TRS485): string;
begin
  Result := inherited GetRS485Title(RS485);
end;

function TConfigTreeDisplayerForServer.GetMotorTitle(Motor: TMotor): string;
begin
  Result := inherited GetMotorTitle(Motor);
end;

{ Public declarations }

constructor TConfigTreeDisplayerForServer.Create(AServer: TPSServer);
begin
  inherited Create;

  Assert(Assigned(AServer), Format('Error: cannot build %s instance without a valid server object', [ClassName]));
  FServer := AServer;
end;

end.

