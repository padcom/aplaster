// ----------------------------------------------------------------------------
// file: ScriptObjects.pas - a part of AplaSter system
// date: 2005-09-08
// auth: Matthias Hryniszak
// desc: definition of scripting objects
// ----------------------------------------------------------------------------

unit ScriptObjects;

{$IFOPT D+}
  {$DEFINE DEBUG}
{$ELSE}
  {$I config.inc}
{$ENDIF}

interface

uses
  Windows, Winsock, Classes, SysUtils, Forms, Log4D,
  uPSComponent, uPSCompiler, uPSRuntime, uPSUtils,
  Config, ConfigFile;

// ----------------------------------------------------------------------------
// Objects representing network items capable of sending commands
// ----------------------------------------------------------------------------

type
  TPSServer = class;
  TPSItemList = class;
  TPSTimer = class;
  TPSTimerList = class;
  TPSModule = class;
  TPSModuleList = class;
  TPSAnalogInput = class;
  TPSAnalogInputList = class;
  TPSDigitalInput = class;
  TPSDigitalInputList = class;
  TPSDigitalOutput = class;
  TPSDigitalOutputList = class;
  TPSRelay = class;
  TPSRelayList = class;
  TPSWiegand = class;
  TPSWiegandList = class;
  TPSRS232 = class;
  TPSRS232List = class;
  TPSRS485 = class;
  TPSRS485List = class;
  TPSMotorList = class;

  // --------------------------------------------------------------------------
  // A method pointer for sending packets.
  //
  // It's importand to understand why we don't pass a pointer to the Network
  // object instead of a method pointer. The reason for it is that there
  // are additional methods not needed while processing commands and in
  // addition the Network unit is using this one to process packages
  // (the structure root (TPSServer) is needed to process incomming commands).
  // Besides it gives some kind of freedom for the method of sending packets
  // (ie. it could be a main form method that counts outgoing packets or
  // performs some other data processing).
  // --------------------------------------------------------------------------
  TSendPacketMethod = procedure (IP: String; Command: Byte; DevId: Byte; Data: Pointer; DataSize: Byte) of object;

  // base type for all scripting-enabled objects
  TPSItem = class (TObject)
  private
    FLog: TLogLogger;
    FConfigObject: TConfigItem;
    FParent: TPSItem;
    FItems: TPSItemList;
    FSend: TSendPacketMethod;
    function GetServer: TPSServer;
  protected
    // get local ip address
    function GetLocalIp: string;
    // create a scripting parameter containing an object
    function GetClassParam(Data: TObject): PIFVariant;
    // create a scripting parameter containing a boolean value
    function GetBooleanParam(Data: Boolean): PIFVariant;
    // create a scripting parameter containing a byte
    function GetByteParam(Data: Byte): PIFVariant;
    // create a scripting parameter containing a word (2 bytes)
    function GetWordParam(Data: Word): PIFVariant;
    // create a scripting parameter containing an integer (4 bytes)
    function GetIntegerParam(Data: Integer): PIFVariant;
    // create a scripting parameter containing a string (ansistring)
    function GetStringParam(Data: string): PIFVariant;
    // a combo procedure to execute events in form
    //   procedure _event_name(Sender: _class_);
    // it's the most used event type so one procedure makes it easier to use
    procedure ExecuteNotifyEvent(Event: string);
    // Logger instance
    property Log: TLogLogger read FLog;
  public
    constructor Create(AParent: TPSItem; AConfigItem: TConfigItem; ASendPacketMethod: TSendPacketMethod); virtual;
    destructor Destroy; override;
    // send a packet via ASendPacketMethod
    procedure Send(IP: String; Command: Byte; DevId: Byte; Data: Pointer; DataSize: Byte);
    // process and dispatch incomming packet
    procedure Process(Command, DevId: Byte; Data: Pointer; DataSize: Byte); virtual;

    property ConfigObject: TConfigItem read FConfigObject;
    // parent item
    property Parent: TPSItem read FParent;
    // sub items
    property Items: TPSItemList read FItems;
    // server
    property Server: TPSServer read GetServer;
  end;

  TPSItemList = class (TList)
  private
    function GetItem(Index: Integer): TPSItem;
  public
    property Items[Index: Integer]: TPSItem read GetItem; default;
  end;

  // events - a chain of subscribers
  TPSEvents = class (TObject)
  protected
    // server events
    procedure OnServerStarted(Server: TPSServer); virtual;
    procedure OnServerStopped(Server: TPSServer); virtual;
    // timer events
    procedure OnTimer(Timer: TPSTimer); virtual;
    // module events
    procedure OnModuleRequestNetworkConfig(Module: TPSModule); virtual;
    procedure OnModuleInitialized(Module: TPSModule); virtual;
    procedure OnModuleConnected(Module: TPSModule); virtual;
    procedure OnModuleDisconnected(Module: TPSModule); virtual;
    // analog input events
    procedure OnAnalogInputRequestConfig(AnalogInput: TPSAnalogInput); virtual;
    procedure OnAnalogInputData(AnalogInput: TPSAnalogInput; Data: Word); virtual;
    procedure OnAnalogInputStatus(AnalogInput: TPSAnalogInput; Data: Word); virtual;
    // digital input events
    procedure OnDigitalInputOpen(DigitalInput: TPSDigitalInput); virtual;
    procedure OnDigitalInputClose(DigitalInput: TPSDigitalInput); virtual;
    procedure OnDigitalInputStatus(DigitalInput: TPSDigitalInput; Status: Byte); virtual;
    // digital output events
    procedure OnDigitalOutputStatus(DigitalOutput: TPSDigitalOutput; Status: Byte); virtual;
    // relay events
    procedure OnRelayStatus(Relay: TPSRelay; Status: Byte); virtual;
    // wiegand events
    procedure OnWiegandRequestConfig(Wiegand: TPSWiegand); virtual;
    procedure OnWiegandData(Wiegand: TPSWiegand; Data: Integer); virtual;
    // RS232 events
    procedure OnRS232RequestConfig(RS232: TPSRS232); virtual;
    procedure OnRS232Data(RS232: TPSRS232; Data: Char); virtual;
    // RS485 events
    procedure OnRS485RequestConfig(RS485: TPSRS485); virtual;
    procedure OnRS485Data(RS485: TPSRS485; Data: Char); virtual;
    // motor events
  end;

  TPSEventsList = class (TList)
  private
    function GetItem(Index: Integer): TPSEvents;
  public
    destructor Destroy; override;
    procedure RunServerStartedEvent(Server: TPSServer); virtual;
    procedure RunServerStoppedEvent(Server: TPSServer); virtual;
    // timer events
    procedure RunTimerEvent(Timer: TPSTimer); virtual;
    // module events
    procedure RunModuleRequestNetworkConfigEvent(Module: TPSModule); virtual;
    procedure RunModuleInitializedEvent(Module: TPSModule); virtual;
    procedure RunModuleConnectedEvent(Module: TPSModule); virtual;
    procedure RunModuleDisconnectedEvent(Module: TPSModule); virtual;
    // analog input events
    procedure RunAnalogInputRequestConfigEvent(AnalogInput: TPSAnalogInput); virtual;
    procedure RunAnalogInputDataEvent(AnalogInput: TPSAnalogInput; Data: Word); virtual;
    procedure RunAnalogInputStatusEvent(AnalogInput: TPSAnalogInput; Data: Word); virtual;
    // digital input events
    procedure RunDigitalInputOpenEvent(DigitalInput: TPSDigitalInput); virtual;
    procedure RunDigitalInputCloseEvent(DigitalInput: TPSDigitalInput); virtual;
    procedure RunDigitalInputStatusEvent(DigitalInput: TPSDigitalInput; Status: Byte); virtual;
    // digital output events
    procedure RunDigitalOutputStatusEvent(DigitalOutput: TPSDigitalOutput; Status: Byte); virtual;
    // relay events
    procedure RunRelayStatusEvent(Relay: TPSRelay; Status: Byte); virtual;
    // wiegand events
    procedure RunWiegandRequestConfigEvent(Wiegand: TPSWiegand); virtual;
    procedure RunWiegandDataEvent(Wiegand: TPSWiegand; Data: Integer); virtual;
    // RS232 events
    procedure RunRS232RequestConfigEvent(RS232: TPSRS232); virtual;
    procedure RunRS232DataEvent(RS232: TPSRS232; Data: Char); virtual;
    // RS485 events
    procedure RunRS485RequestConfigEvent(RS485: TPSRS485); virtual;
    procedure RunRS485DataEvent(RS485: TPSRS485; Data: Char); virtual;
    // properties
    property Items[Index: Integer]: TPSEvents read GetItem; default;
  end;

  TPSServer = class (TPSItem)
  private
    FEvents: TPSEventsList;
    FScriptEngine: TPSScript;
    FTimers: TPSTimerList;
    FModules: TPSModuleList;
    function GetData: TServerData;
  protected
    procedure SetScriptingEngine(Value: TPSScript);
  public
    constructor Create(AParent: TPSItem; AConfigItem: TConfigItem; ASendPacketMethod: TSendPacketMethod); override;
    destructor Destroy; override;
    // functionality
    procedure ResetModules;
    // events
    procedure Process(Command, DevId: Byte; Data: Pointer; DataSize: Byte); override;
    procedure OnStart;
    procedure OnStop;
    // data
    property D: TServerData read GetData;
    property Timers: TPSTimerList read FTimers;
    property Modules: TPSModuleList read FModules;
    property ScriptEngine: TPSScript read FScriptEngine write SetScriptingEngine;

    // notifications
    property Events: TPSEventsList read FEvents;
  end;

  TPSTimer = class(TPSItem)
  private
    FTimer: THandle;
    function GetData: TTimerData;
    function GetRunning: Boolean;
  public
    destructor Destroy; override;
    // functionality
    procedure Start;
    procedure Stop;
    // events
    procedure OnTimer;
    // data
    property D: TTimerData read GetData;
    property Running: Boolean read GetRunning;
  end;

  TPSTimerList = class (TList)
  private
    function GetItem(Index: Integer): TPSTimer;
  public
    property Items[Index: Integer]: TPSTimer read GetItem; default;
  end;

  TModuleAliveStatus = (asUninitialized, asUnknown, asInactive, asActive);

  TPSModule = class (TPSItem)
  private
    FAliveStatus: TModuleAliveStatus;
    FPreviousAliveStatus: TModuleAliveStatus;
    FAnalogInputs: TPSAnalogInputList;
    FDigitalInputs: TPSDigitalInputList;
    FDigitalOutputs: TPSDigitalOutputList;
    FRelays: TPSRelayList;
    FWiegands: TPSWiegandList;
    FRS232s: TPSRS232List;
    FRS485s: TPSRS485List;
    FMotors: TPSMotorList;
    function GetData: TModuleData;
  public
    constructor Create(AParent: TPSItem; AConfigItem: TConfigItem; ASendPacketMethod: TSendPacketMethod); override;
    destructor Destroy; override;
    // functionality
    procedure Reset;
    procedure Ping;
    procedure SendConfig;
    // events
    procedure Process(Command, DevId: Byte; Data: Pointer; DataSize: Byte); override;
    procedure OnRequestNetworkConfig;
    procedure OnInitialized;
    procedure OnConnected;
    procedure OnDisconnected;
    // data
    property D: TModuleData read GetData;
    property AliveStatus: TModuleAliveStatus read FAliveStatus;
    property AnalogInputs: TPSAnalogInputList read FAnalogInputs;
    property DigitalInputs: TPSDigitalInputList read FDigitalInputs;
    property DigitalOutputs: TPSDigitalOutputList read FDigitalOutputs;
    property Relays: TPSRelayList read FRelays;
    property Wiegands: TPSWiegandList read FWiegands;
    property RS232s: TPSRS232List read FRS232s;
    property RS485s: TPSRS485List read FRS485s;
    property Motors: TPSMotorList read FMotors;
  end;

  TPSModuleList = class (TList)
  private
    function GetItem(Index: Integer): TPSModule;
  public
    property Items[Index: Integer]: TPSModule read GetItem; default;
  end;

  // a base class for all device-like classes. a device-like class is a class
  // whose instances are subitems of TPSModule
  TPSDevice = class (TPSItem)
  private
    function GetModule: TPSModule;
    function GetServer: TPSServer;
  protected
    function GetDevId: Byte; virtual; abstract;
  public
    property DevId: Byte read GetDevId;
    property Module: TPSModule read GetModule;
    property Server: TPSServer read GetServer;
  end;

  TPSAnalogInput = class(TPSDevice)
  private
    FValue: Word;
    function GetData: TAnalogInputData;
  protected
    function GetDevId: Byte; override;
  public
    // functionality
    procedure GetStatus;
    // events
    procedure Process(Command, DevId: Byte; Data: Pointer; DataSize: Byte); override;
    procedure OnRequestConfig;
    procedure OnData(Value: Word);
    procedure OnStatus(Value: Word);
    // data
    property D: TAnalogInputData read GetData;
    property Value: Word read FValue;
  end;

  TPSAnalogInputList = class (TList)
  private
    function GetItem(Index: Integer): TPSAnalogInput;
  public
    property Items[Index: Integer]: TPSAnalogInput read GetItem; default;
  end;

  TPSDigitalInput = class(TPSDevice)
  private
    FStatus: Boolean;
    function GetData: TDigitalInputData;
  protected
    function GetDevId: Byte; override;
  public
    // functionality
    procedure GetStatus;
    // events
    procedure Process(Command, DevId: Byte; Data: Pointer; DataSize: Byte); override;
    procedure OnOpen;
    procedure OnClose;
    procedure OnStatus(Value: Byte);
    // data
    property D: TDigitalInputData read GetData;
    property Status: Boolean read FStatus;
  end;

  TPSDigitalInputList = class (TList)
  private
    function GetItem(Index: Integer): TPSDigitalInput;
  public
    property Items[Index: Integer]: TPSDigitalInput read GetItem; default;
  end;

  TPSDigitalOutput = class(TPSDevice)
  private
    FStatus: Boolean;
    function GetData: TDigitalOutputData;
  protected
    function GetDevId: Byte; override;
  public
    // functionality
    procedure Control(InitialStatus, FinalStatus: Boolean; Delay, Duration: Word; Break, Terminate: TPSDigitalInput);
    procedure Open;
    procedure Close;
    procedure GetStatus;
    // events
    procedure Process(Command, DevId: Byte; Data: Pointer; DataSize: Byte); override;
    procedure OnStatus(Value: Byte);
    // data
    property D: TDigitalOutputData read GetData;
    property Status: Boolean read FStatus;
  end;

  TPSDigitalOutputList = class (TList)
  private
    function GetItem(Index: Integer): TPSDigitalOutput;
  public
    property Items[Index: Integer]: TPSDigitalOutput read GetItem; default;
  end;

  TPSRelay = class(TPSDevice)
  private
    FStatus: Boolean;
    function GetData: TRelayData;
  protected
    function GetDevId: Byte; override;
  public
    // functionality
    procedure Control(InitialStatus, FinalStatus: Boolean; Delay, Duration: Word; Break, Terminate: TPSDigitalInput);
    procedure Open;
    procedure Close;
    procedure GetStatus;
    // events
    procedure Process(Command, DevId: Byte; Data: Pointer; DataSize: Byte); override;
    procedure OnStatus(Value: Byte);
    // data
    property D: TRelayData read GetData;
    property Status: Boolean read FStatus;
  end;

  TPSRelayList = class (TList)
  private
    function GetItem(Index: Integer): TPSRelay;
  public
    property Items[Index: Integer]: TPSRelay read GetItem; default;
  end;

  TPSWiegand = class(TPSDevice)
  private
    FData: Longword;
    function GetData: TWiegandData;
  protected
    function GetDevId: Byte; override;
  public
    // functionality
    // events
    procedure Process(Command, DevId: Byte; Data: Pointer; DataSize: Byte); override;
    procedure OnRequestConfig;
    procedure OnData(Data: LongWord);
    // data
    property D: TWiegandData read GetData;
  end;

  TPSWiegandList = class (TList)
  private
    function GetItem(Index: Integer): TPSWiegand;
  public
    property Items[Index: Integer]: TPSWiegand read GetItem; default;
  end;

  TPSRS232 = class(TPSDevice)
  private
    FData: string;
    function GetData: TRS232Data;
  protected
    function GetDevId: Byte; override;
  public
    // functionality
    procedure Clear;
    // events
    procedure Process(Command, DevId: Byte; Data: Pointer; DataSize: Byte); override;
    procedure OnRequestConfig;
    procedure OnData(Data: Byte);
    // data
    property D: TRS232Data read GetData;
  end;

  TPSRS232List = class (TList)
  private
    function GetItem(Index: Integer): TPSRS232;
  public
    property Items[Index: Integer]: TPSRS232 read GetItem; default;
  end;

  TPSRS485 = class(TPSDevice)
  private
    FData: string;
    function GetData: TRS485Data;
  protected
    function GetDevId: Byte; override;
  public
    // functionality
    procedure Clear;
    // events
    procedure Process(Command, DevId: Byte; Data: Pointer; DataSize: Byte); override;
    procedure OnRequestConfig;
    procedure OnData(Data: Byte);
    // data
    property D: TRS485Data read GetData;
  end;

  TPSRS485List = class (TList)
  private
    function GetItem(Index: Integer): TPSRS485;
  public
    property Items[Index: Integer]: TPSRS485 read GetItem; default;
  end;

  TPSMotor = class(TPSDevice)
  private
    function GetData: TMotorData;
  protected
    function GetDevId: Byte; override;
  public
    // functionality
    procedure Start(Polarity: Byte; Delay, Duration: Word; Break, Terminate: TPSDigitalInput; StopKind: Byte);
    procedure Stop(StopKind: Byte);
    // events
    // data
    property D: TMotorData read GetData;
  end;

  TPSMotorList = class (TList)
  private
    function GetItem(Index: Integer): TPSMotor;
  public
    property Items[Index: Integer]: TPSMotor read GetItem; default;
  end;

// a global procedure to create a structure based on network configuration
// containing script-enabled objects.
function RecreateScriptObjects(Config: TConfig; LocalIP: String; SendPacketProc: TSendPacketMethod; ScriptEngine: TPSScript): TPSServer;

// a global procedure to scompile server's script
procedure RecompileScript(Server: TPSServer; Config: TConfig);

// ----------------------------------------------------------------------------
// PascalScript import plugin
// ----------------------------------------------------------------------------

type
  TPSScriptObjects = class (TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;

procedure Suspend;

implementation

uses
  Protocol, DeviceIds, Resources;

{ Functions and procedures accessible from script engine }

var
  _Log: TLogLogger = nil;

procedure Log(S: String);
begin
  Assert(Assigned(_Log), 'Error: log system not initialized');
  _Log.Info(S);
end;

{ TPSItem }

{ Private declarations }

function TPSItem.GetServer: TPSServer;
var
  Item: TPSItem;
begin
  Item := Self;
  while Assigned(Item) and (not (Item is TPSServer)) do
    Item := Item.Parent;
  Result := Item as TPSServer;
end;

{ Protected declarations }

function TPSItem.GetLocalIP: String;
var
  ac: String;
  phe: PHostEnt;
begin
  SetLength(ac, 1024);
  if gethostname(PChar(ac), Length(ac)) = SOCKET_ERROR then
    raise Exception.CreateFmt(SErrorWhileGettingLocalIPAddress, [WSAGetLastError])
  else
    SetLength(ac, StrLen(PChar(ac)));

  phe := gethostbyname(PChar(ac));
  if (phe = nil) or (phe^.h_length <> 4) then
    raise Exception.CreateFmt(SErrorNo, [WSAGetLastError]);

  Result := inet_ntoa(in_addr(Pointer(phe^.h_addr_list^)^));
end;

function TPSItem.GetClassParam(Data: TObject): PIFVariant;
begin
  Result := CreateHeapVariant(Server.ScriptEngine.Exec.GetTypeNo(Server.ScriptEngine.Exec.GetType(UpperCase(Data.ClassName))));
  if not Assigned(Result) then
    raise Exception.CreateFmt('Error: type %s not registered for scripting', [Data.ClassName]);
  PPSVariantClass(Result)^.Data := Self;
end;

function TPSItem.GetBooleanParam(Data: Boolean): PIFVariant;
begin
  Result := CreateHeapVariant(Server.ScriptEngine.FindBaseType(btU8));
  PPSVariantU8(Result)^.Data := Byte(Data);
end;

function TPSItem.GetByteParam(Data: Byte): PIFVariant;
begin
  Result := CreateHeapVariant(Server.ScriptEngine.FindBaseType(btU8));
  PPSVariantU8(Result)^.Data := Data;
end;

function TPSItem.GetWordParam(Data: Word): PIFVariant;
begin
  Result := CreateHeapVariant(Server.ScriptEngine.FindBaseType(btU16));
  PPSVariantU16(Result)^.Data := Data;
end;

function TPSItem.GetIntegerParam(Data: Integer): PIFVariant;
begin
  Result := CreateHeapVariant(Server.ScriptEngine.FindBaseType(btS32));
  PPSVariantS32(Result)^.Data := Data;
end;

function TPSItem.GetStringParam(Data: string): PIFVariant;
begin
  Result := CreateHeapVariant(Server.ScriptEngine.FindBaseType(btString));
  PPSVariantAString(Result)^.Data := Data;
end;

procedure TPSItem.ExecuteNotifyEvent(Event: string);
var
  ProcIndex: Cardinal;
  ParamList: TPSList;
begin
  ProcIndex := Server.ScriptEngine.Exec.GetProc(Event);
  if ProcIndex <> InvalidVal then
  begin
    ParamList := TPSList.Create;
    ParamList.Add(GetClassParam(Self));
    Server.ScriptEngine.Exec.RunProc(ParamList, ProcIndex);
    FreePIFVariantList(ParamList);
  end;
end;

{ Public declarations }

constructor TPSItem.Create(AParent: TPSItem; AConfigItem: TConfigItem; ASendPacketMethod: TSendPacketMethod);
begin
  inherited Create;
  FLog := TLogLogger.GetLogger(ClassType);
  FParent := AParent;
  FConfigObject := AConfigItem;
  FItems  := TPSItemList.Create;
  FSend := ASendPacketMethod;

  if Assigned(Parent) then
    Parent.Items.Add(Self);
end;

destructor TPSItem.Destroy;
begin
  if Assigned(Parent) then
    Parent.Items.Remove(Self);

  while Items.Count > 0 do
    Items[Items.Count - 1].Free;
  FreeAndNil(FItems);
  inherited Destroy;
end;

procedure TPSItem.Send(IP: String; Command: Byte; DevId: Byte; Data: Pointer; DataSize: Byte);
begin
  if Assigned(FSend) then
    FSend(IP, Command, DevId, Data, DataSize);
end;

procedure TPSItem.Process(Command, DevId: Byte; Data: Pointer; DataSize: Byte);
begin
end;

{ TPSItemList }

{ Private declarations }

function TPSItemList.GetItem(Index: Integer): TPSItem;
begin
  Result := TObject(Get(Index)) as TPSItem;
end;

{ TPSEvents }

{ Protected declarations }

procedure TPSEvents.OnServerStarted(Server: TPSServer);
begin
end;

procedure TPSEvents.OnServerStopped(Server: TPSServer);
begin
end;

procedure TPSEvents.OnTimer(Timer: TPSTimer);
begin
end;

procedure TPSEvents.OnModuleRequestNetworkConfig(Module: TPSModule);
begin
end;

procedure TPSEvents.OnModuleInitialized(Module: TPSModule);
begin
end;

procedure TPSEvents.OnModuleConnected(Module: TPSModule);
begin
end;

procedure TPSEvents.OnModuleDisconnected(Module: TPSModule);
begin
end;

procedure TPSEvents.OnAnalogInputRequestConfig(AnalogInput: TPSAnalogInput);
begin
end;

procedure TPSEvents.OnAnalogInputData(AnalogInput: TPSAnalogInput; Data: Word);
begin
end;

procedure TPSEvents.OnAnalogInputStatus(AnalogInput: TPSAnalogInput; Data: Word);
begin
end;

procedure TPSEvents.OnDigitalInputOpen(DigitalInput: TPSDigitalInput);
begin
end;

procedure TPSEvents.OnDigitalInputClose(DigitalInput: TPSDigitalInput);
begin
end;

procedure TPSEvents.OnDigitalInputStatus(DigitalInput: TPSDigitalInput; Status: Byte);
begin
end;

procedure TPSEvents.OnDigitalOutputStatus(DigitalOutput: TPSDigitalOutput; Status: Byte);
begin
end;

procedure TPSEvents.OnRelayStatus(Relay: TPSRelay; Status: Byte);
begin
end;

procedure TPSEvents.OnWiegandRequestConfig(Wiegand: TPSWiegand);
begin
end;

procedure TPSEvents.OnWiegandData(Wiegand: TPSWiegand; Data: Integer);
begin
end;

procedure TPSEvents.OnRS232RequestConfig(RS232: TPSRS232);
begin
end;

procedure TPSEvents.OnRS232Data(RS232: TPSRS232; Data: Char);
begin
end;

procedure TPSEvents.OnRS485RequestConfig(RS485: TPSRS485);
begin
end;

procedure TPSEvents.OnRS485Data(RS485: TPSRS485; Data: Char);
begin
end;

{ TPSEventsList }

{ Private declarations }

function TPSEventsList.GetItem(Index: Integer): TPSEvents;
begin
  Result := TObject(Get(Index)) as TPSEvents;
end;

{ Public declarations }

destructor TPSEventsList.Destroy;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    Items[I].Free;
  inherited Destroy;
end;

procedure TPSEventsList.RunServerStartedEvent(Server: TPSServer);
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    Items[I].OnServerStarted(Server);
end;

procedure TPSEventsList.RunServerStoppedEvent(Server: TPSServer);
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    Items[I].OnServerStopped(Server);
end;

procedure TPSEventsList.RunTimerEvent(Timer: TPSTimer);
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    Items[I].OnTimer(Timer);
end;

procedure TPSEventsList.RunModuleRequestNetworkConfigEvent(Module: TPSModule);
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    Items[I].OnModuleRequestNetworkConfig(Module);
end;

procedure TPSEventsList.RunModuleInitializedEvent(Module: TPSModule);
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    Items[I].OnModuleInitialized(Module);
end;

procedure TPSEventsList.RunModuleConnectedEvent(Module: TPSModule);
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    Items[I].OnModuleConnected(Module);
end;

procedure TPSEventsList.RunModuleDisconnectedEvent(Module: TPSModule);
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    Items[I].OnModuleDisconnected(Module);
end;

procedure TPSEventsList.RunAnalogInputRequestConfigEvent(AnalogInput: TPSAnalogInput);
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    Items[I].OnAnalogInputRequestConfig(AnalogInput);
end;

procedure TPSEventsList.RunAnalogInputDataEvent(AnalogInput: TPSAnalogInput; Data: Word);
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    Items[I].OnAnalogInputData(AnalogInput, Data);
end;

procedure TPSEventsList.RunAnalogInputStatusEvent(AnalogInput: TPSAnalogInput; Data: Word);
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    Items[I].OnAnalogInputStatus(AnalogInput, Data);
end;

procedure TPSEventsList.RunDigitalInputOpenEvent(DigitalInput: TPSDigitalInput);
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    Items[I].OnDigitalInputOpen(DigitalInput);
end;

procedure TPSEventsList.RunDigitalInputCloseEvent(DigitalInput: TPSDigitalInput);
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    Items[I].OnDigitalInputClose(DigitalInput);
end;

procedure TPSEventsList.RunDigitalInputStatusEvent(DigitalInput: TPSDigitalInput; Status: Byte);
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    Items[I].OnDigitalInputStatus(DigitalInput, Status);
end;

procedure TPSEventsList.RunDigitalOutputStatusEvent(DigitalOutput: TPSDigitalOutput; Status: Byte);
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    Items[I].OnDigitalOutputStatus(DigitalOutput, Status);
end;

procedure TPSEventsList.RunRelayStatusEvent(Relay: TPSRelay; Status: Byte);
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    Items[I].OnRelayStatus(Relay, Status);
end;

procedure TPSEventsList.RunWiegandRequestConfigEvent(Wiegand: TPSWiegand);
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    Items[I].OnWiegandRequestConfig(Wiegand);
end;

procedure TPSEventsList.RunWiegandDataEvent(Wiegand: TPSWiegand; Data: Integer);
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    Items[I].OnWiegandData(Wiegand, Data);
end;

procedure TPSEventsList.RunRS232RequestConfigEvent(RS232: TPSRS232);
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    Items[I].OnRS232RequestConfig(RS232);
end;

procedure TPSEventsList.RunRS232DataEvent(RS232: TPSRS232; Data: Char);
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    Items[I].OnRS232Data(RS232, Data);
end;

procedure TPSEventsList.RunRS485RequestConfigEvent(RS485: TPSRS485);
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    Items[I].OnRS485RequestConfig(RS485);
end;

procedure TPSEventsList.RunRS485DataEvent(RS485: TPSRS485; Data: Char);
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    Items[I].OnRS485Data(RS485, Data);
end;

{ TPSServer }

{ Private declarations }

function TPSServer.GetData: TServerData;
begin
  Result := TServer(ConfigObject).D;
end;

{ Protected declarations }

procedure TPSServer.SetScriptingEngine(Value: TPSScript);
begin
  Assert(Assigned(Value), 'Error: no scripting engine found!');

  FScriptEngine := Value;
  FScriptEngine.CompilerOptions := [icAllowNoBegin, icAllowNoEnd];
  FScriptEngine.UsePreProcessor := True;
end;

{ Public declarations }

constructor TPSServer.Create(AParent: TPSItem; AConfigItem: TConfigItem; ASendPacketMethod: TSendPacketMethod);
begin
  inherited Create(AParent, AConfigItem, ASendPacketMethod);

  FEvents := TPSEventsList.Create;
  FTimers := TPSTimerList.Create;
  FModules := TPSModuleList.Create;
end;

destructor TPSServer.Destroy;
begin
  FreeAndNil(FEvents);
  FreeAndNil(FTimers);
  FreeAndNil(FModules);
  inherited Destroy;
end;

procedure TPSServer.ResetModules;
var
  I: Integer;
begin
  for I := 0 to Modules.Count - 1 do
    Modules[I].Reset;
end;

procedure TPSServer.Process(Command, DevId: Byte; Data: Pointer; DataSize: Byte);
var
  I: Integer;
  S: String;
begin
  case Command of
    CMD_SERVER_START:
      OnStart;
    CMD_SERVER_STOP:
      OnStop;

    // because the module hasn't an IP address the server must
    // pass the request mannualy to the desired module
    CMD_MODULE_REQUEST_NETWORK_CONFIG:
    begin
      // get MAC address in a comparable form
      with PModuleRequestNetworkConfigRec(Data)^ do
        S := Format('%02x:%02x:%02x:%02x:%02x:%02x', [MAC[0], MAC[1], MAC[2], MAC[3], MAC[4], MAC[5]]);

      // find a module to pass this request to
      for I := 0 to Modules.Count - 1 do
        if AnsiCompareText(Modules[I].D.MAC, S) = 0 then
        begin
          Modules[I].Process(Command, DevId, Data, DataSize);
          Break;
        end;
    end;
  end;
end;

procedure TPSServer.OnStart;
begin
  Events.RunServerStartedEvent(Self);
  ExecuteNotifyEvent(D.OnStart);
end;

procedure TPSServer.OnStop;
begin
  // make sure the scripting engine is stopped
  if ScriptEngine.Exec.Status in [isPaused, isRunning] then
    ScriptEngine.Stop;
  Events.RunServerStoppedEvent(Self);
  ExecuteNotifyEvent(D.OnStop);
end;

{ TPSTimer }

{ Private declarations }

function TPSTimer.GetData: TTimerData;
begin
  Result := TTimer(ConfigObject).D;
end;

function TPSTimer.GetRunning: Boolean;
begin
  Result := FTimer <> 0;
end;

{ Public declarations }

destructor TPSTimer.Destroy;
begin
  Stop;
  inherited Destroy;
end;

var
  //
  // This is no good. A global variable just to access an item in server's timers collection.
  // But AFAIK there's no other method of passing a variable to the timer's callback procedure
  //
  __Server_for_timers: TPSServer;

procedure TimerCallback(hWnd: THandle; uMsg: UINT; idEvent: UINT; dwTime: DWORD); stdcall;
var
  I: Integer;
begin
  // search for a timer object
  if Assigned(__Server_for_timers) then
    for I := 0 to __Server_for_timers.Timers.Count - 1 do
      if __Server_for_timers.Timers[I].FTimer = idEvent then
      begin
        // execute timer event
        __Server_for_timers.Timers[I].OnTimer;
        Break;
      end;
end;

procedure TPSTimer.Start;
begin
  __Server_for_timers := Server;
  if FTimer = 0 then
    FTimer := SetTimer(0, 0, D.Interval, @TimerCallback);
end;

procedure TPSTimer.Stop;
begin
  if FTimer <> 0 then
  begin
    KillTimer(0, FTimer);
    FTimer := 0;
  end;
end;

procedure TPSTimer.OnTimer;
begin
  Server.Events.RunTimerEvent(Self);
  ExecuteNotifyEvent(D.OnTimer);
end;

{ TPSTimerList }

{ Private declarations }

function TPSTimerList.GetItem(Index: Integer): TPSTimer;
begin
  Result := TObject(Get(Index)) as TPSTimer;
end;

{ TPSModule }

{ Private declarations }

function TPSModule.GetData: TModuleData;
begin
  Result := TModule(ConfigObject).D;
end;

{ Public declarations }

constructor TPSModule.Create(AParent: TPSItem; AConfigItem: TConfigItem; ASendPacketMethod: TSendPacketMethod);
begin
  inherited Create(AParent, AConfigItem, ASendPacketMethod);
  FAnalogInputs := TPSAnalogInputList.Create;
  FDigitalInputs := TPSDigitalInputList.Create;
  FDigitalOutputs := TPSDigitalOutputList.Create;
  FRelays := TPSRelayList.Create;
  FWiegands := TPSWiegandList.Create;
  FRS232s := TPSRS232List.Create;
  FRS485s := TPSRS485List.Create;
  FMotors := TPSMotorList.Create;
end;

destructor TPSModule.Destroy;
begin
  FreeAndNil(FMotors);
  FreeAndNil(FRS485s);
  FreeAndNil(FRS232s);
  FreeAndNil(FWiegands);
  FreeAndNil(FRelays);
  FreeAndNil(FDigitalOutputs);
  FreeAndNil(FDigitalInputs);
  FreeAndNil(FAnalogInputs);
  inherited Destroy;
end;

procedure TPSModule.Reset;
begin
  Send(D.IP, CMD_MODULE_RESET, DID_MODULE, nil, 0);
end;

procedure TPSModule.Ping;
begin
  Send(D.IP, CMD_MODULE_PING, DID_MODULE, nil, 0);
  FAliveStatus := asUnknown;
end;

procedure TPSModule.SendConfig;
var
  I: Integer;
  Data: TModuleNetworkConfigRec;
begin
  // store module's MAC address
  for I := 0 to 5 do
    if Length(D.MAC) > I then
      Data.MAC[I] := StrToInt('$' + string(D.MAC)[(I * 2) + 1] + string(D.MAC)[(I * 2) + 2]);
  Data.IP := inet_addr(PChar(string(D.IP)));
  Data.Netmask := inet_addr(PChar(string(D.Netmask)));
  Data.Gateway := 0;
  Data.Server := inet_addr(PChar(GetLocalIp));
  Send('255.255.255.255', CMD_MODULE_NETWORK_CONFIG, DID_MODULE, @Data, SizeOf(Data));
end;

procedure TPSModule.Process(Command, DevId: Byte; Data: Pointer; DataSize: Byte);
begin
  case Command of
    CMD_MODULE_PONG:
      OnConnected;
    CMD_MODULE_REQUEST_NETWORK_CONFIG:
      OnRequestNetworkConfig;
    CMD_MODULE_INITIALIZED:
      OnInitialized;
    CMD_MODULE_CONNECTED:
      OnConnected;
    CMD_MODULE_DISCONNECTED:
      OnDisconnected;
  end;
end;

procedure TPSModule.OnRequestNetworkConfig;
begin
  Server.Events.RunModuleRequestNetworkConfigEvent(Self);
  SendConfig;
end;

procedure TPSModule.OnInitialized;
begin
  Server.Events.RunModuleInitializedEvent(Self);
  ExecuteNotifyEvent(D.OnInitialized);
end;

procedure TPSModule.OnConnected;
begin
  FAliveStatus := asActive;
  if FPreviousAliveStatus <> FAliveStatus then
  begin
    Server.Events.RunModuleConnectedEvent(Self);
    ExecuteNotifyEvent(D.OnConnected);
    FPreviousAliveStatus := FAliveStatus;
  end;
end;

procedure TPSModule.OnDisconnected;
begin
  FAliveStatus := asInactive;
  if FPreviousAliveStatus <> FAliveStatus then
  begin
    Server.Events.RunModuleDisconnectedEvent(Self);
    ExecuteNotifyEvent(D.OnDisconnected);
    FPreviousAliveStatus := FAliveStatus;
  end;
end;

{ TPSModuleList }

{ Private declarations }

function TPSModuleList.GetItem(Index: Integer): TPSModule;
begin
  Result := TObject(Get(Index)) as TPSModule;
end;

{ TPSDevice }

{ Private declarations }

function TPSDevice.GetModule: TPSModule;
begin
  Result := Parent as TPSModule;
end;

function TPSDevice.GetServer: TPSServer;
begin
  Result := Parent.Parent as TPSServer;
end;

{ TPSAnalogInput }

{ Private declarations }

function TPSAnalogInput.GetData: TAnalogInputData;
begin
  Result := TAnalogInput(ConfigObject).D;
end;

{ Protected declarations }

function TPSAnalogInput.GetDevId: Byte;
begin
  Result := D.DevId;
end;

{ Public declarations }

procedure TPSAnalogInput.GetStatus;
begin
  Send(Module.D.IP, CMD_ANALOG_INPUT_GET_STATUS, D.DevId, nil, 0);
end;

procedure TPSAnalogInput.Process(Command, DevId: Byte; Data: Pointer; DataSize: Byte);
begin
  case Command of
    CMD_ANALOG_INPUT_DATA:
      OnData(PWord(Data)^);
    CMD_ANALOG_INPUT_STATUS:
      OnStatus(PWord(Data)^);
    CMD_ANALOG_INPUT_REQUEST_CONFIG:
      OnRequestConfig;
  end;
end;

procedure TPSAnalogInput.OnRequestConfig;
var
  Data: TAnalogInputConfigRec;
begin
  Data.Histeresis := D.DeltaChange;
  Server.Events.RunAnalogInputRequestConfigEvent(Self);
  Send(Module.D.IP, CMD_ANALOG_INPUT_CONFIG, D.DevId, @Data, SizeOf(Data));
end;

procedure TPSAnalogInput.OnData(Value: Word);
var
  ProcIndex: Cardinal;
  ParamList: TPSList;
begin
  FValue := Value;
  Server.Events.RunAnalogInputDataEvent(Self, Value);

  ProcIndex := Server.ScriptEngine.Exec.GetProc(D.OnData);
  if ProcIndex <> InvalidVal then
  begin
    ParamList := TPSList.Create;
    ParamList.Add(GetIntegerParam(Value));
    ParamList.Add(GetClassParam(Self));
    Server.ScriptEngine.Exec.RunProc(ParamList, ProcIndex);
    FreePIFVariantList(ParamList);
  end;
end;

procedure TPSAnalogInput.OnStatus(Value: Word);
begin
  FValue := Value;
  Server.Events.RunAnalogInputStatusEvent(Self, Value);
end;

{ TPSAnalogInputList }

{ Private declarations }

function TPSAnalogInputList.GetItem(Index: Integer): TPSAnalogInput;
begin
  Result := TObject(Get(Index)) as TPSAnalogInput;
end;

{ TPSDigitalInput }

{ Private declarations }

function TPSDigitalInput.GetData: TDigitalInputData;
begin
  Result := TDigitalInput(ConfigObject).D;
end;

{ Protected declarations }

function TPSDigitalInput.GetDevId: Byte;
begin
  Result := D.DevId;
end;

{ Public declarations }

procedure TPSDigitalInput.GetStatus;
begin
  Send(Module.D.IP, CMD_DIGITAL_INPTUT_GET_STATUS, D.DevId, nil, 0);
end;

procedure TPSDigitalInput.Process(Command, DevId: Byte; Data: Pointer; DataSize: Byte);
begin
  case Command of
    CMD_DIGITAL_INPTUT_OPEN:
      OnOpen;
    CMD_DIGITAL_INPTUT_CLOSE:
      OnClose;
    CMD_DIGITAL_INPTUT_STATUS:
      OnStatus(PByte(Data)^);
  end;
end;

procedure TPSDigitalInput.OnOpen;
begin
  FStatus := False;
  Server.Events.RunDigitalInputOpenEvent(Self);
  ExecuteNotifyEvent(D.OnOpen);
end;

procedure TPSDigitalInput.OnClose;
begin
  FStatus := True;
  Server.Events.RunDigitalInputCloseEvent(Self);
  ExecuteNotifyEvent(D.OnClose);
end;

procedure TPSDigitalInput.OnStatus(Value: Byte);
begin
  FStatus := Value = 1;
  Server.Events.RunDigitalInputStatusEvent(Self, Value);
end;

{ TPSDigitalInputList }

{ Private declarations }

function TPSDigitalInputList.GetItem(Index: Integer): TPSDigitalInput;
begin
  Result := TObject(Get(Index)) as TPSDigitalInput;
end;

{ TPSDigitalOutput }

{ Private declarations }

function TPSDigitalOutput.GetData: TDigitalOutputData;
begin
  Result := TDigitalOutput(ConfigObject).D;
end;

{ Protected declarations }

function TPSDigitalOutput.GetDevId: Byte;
begin
  Result := D.DevId;
end;

{ Public declarations }

procedure TPSDigitalOutput.Control(InitialStatus, FinalStatus: Boolean; Delay, Duration: Word; Break, Terminate: TPSDigitalInput);
var
  Data: TDigitalOutputControlRec;
begin
  Data.States := 0;
  if InitialStatus then
    Data.States := Data.States or 1;
  if FinalStatus then
    Data.States := Data.States or 2;
  Data.Delay := Delay;
  Data.Duration := Duration;
  if Assigned(Break) then
    Data.BreakDevId := Break.D.DevId
  else
    Data.BreakDevId := 255;
  if Assigned(Terminate) then
    Data.TerminateDevId := Terminate.D.DevId
  else
    Data.TerminateDevId := 255;
  Send(Module.D.IP, CMD_DIGITAL_OUTPUT_CONTROL, D.DevId, @Data, SizeOf(Data));
end;

procedure TPSDigitalOutput.Open;
begin
  Control(False, False, 0, 0, nil, nil);
end;

procedure TPSDigitalOutput.Close;
begin
  Control(True, True, 0, 0, nil, nil);
end;

procedure TPSDigitalOutput.GetStatus;
begin
  Send(Module.D.IP, CMD_DIGITAL_OUTPUT_GET_STATUS, D.DevId, nil, 0);
end;

procedure TPSDigitalOutput.Process(Command, DevId: Byte; Data: Pointer; DataSize: Byte);
begin
  case Command of
    CMD_DIGITAL_OUTPUT_STATUS:
      OnStatus(PByte(Data)^);
  end;
end;

procedure TPSDigitalOutput.OnStatus(Value: Byte);
begin
  FStatus := Value = 0;
  Server.Events.RunDigitalOutputStatusEvent(Self, Value);
end;

{ TPSDigitalOutputList }

{ Private declarations }

function TPSDigitalOutputList.GetItem(Index: Integer): TPSDigitalOutput;
begin
  Result := TObject(Get(Index)) as TPSDigitalOutput;
end;

{ TPSRelay }

{ Private declarations }

function TPSRelay.GetData: TRelayData;
begin
  Result := TRelay(ConfigObject).D;
end;

{ Protected declarations }

function TPSRelay.GetDevId: Byte;
begin
  Result := D.DevId;
end;

{ Public declarations }

procedure TPSRelay.Control(InitialStatus, FinalStatus: Boolean; Delay, Duration: Word; Break, Terminate: TPSDigitalInput);
var
  Data: TRelayControlRec;
begin
  Data.States := 0;
  if InitialStatus then
    Data.States := Data.States or 1;
  if FinalStatus then
    Data.States := Data.States or 2;
  Data.Delay := Delay;
  Data.Duration := Duration;
  if Assigned(Break) then
    Data.BreakDevId := Break.D.DevId
  else
    Data.BreakDevId := 255;
  if Assigned(Terminate) then
    Data.TerminateDevId := Terminate.D.DevId
  else
    Data.TerminateDevId := 255;
  Send(Module.D.IP, CMD_RELAY_CONTROL, D.DevId, @Data, SizeOf(Data));
end;

procedure TPSRelay.Open;
begin
  Control(False, False, 0, 0, nil, nil);
end;

procedure TPSRelay.Close;
begin
  Control(True, True, 0, 0, nil, nil);
end;

procedure TPSRelay.GetStatus;
begin
  Send(Module.D.IP, CMD_RELAY_GET_STATUS, D.DevId, nil, 0);
end;

procedure TPSRelay.Process(Command, DevId: Byte; Data: Pointer; DataSize: Byte);
begin
  case Command of
    CMD_RELAY_STATUS:
      OnStatus(PByte(Data)^);
  end;
end;

procedure TPSRelay.OnStatus(Value: Byte);
begin
  FStatus := Value = 0;
  Server.Events.RunRelayStatusEvent(Self, Value);
end;

{ TPSRelayList }

{ Private declarations }

function TPSRelayList.GetItem(Index: Integer): TPSRelay;
begin
  Result := TObject(Get(Index)) as TPSRelay;
end;

{ TPSWiegand }

{ Private declarations }

function TPSWiegand.GetData: TWiegandData;
begin
  Result := TWiegand(ConfigObject).D;
end;

{ Protected declarations }

function TPSWiegand.GetDevId: Byte;
begin
  Result := D.DevId;
end;

{ Public declarations }

procedure TPSWiegand.Process(Command, DevId: Byte; Data: Pointer; DataSize: Byte);
begin
  case Command of
    CMD_WIEGAND_REQUEST_CONFIG:
      OnRequestConfig;
    CMD_WIEGAND_DATA:
      OnData(PLongWord(Data)^);
  end;
end;

procedure TPSWiegand.OnRequestConfig;
var
  Data: TWiegandConfigRec;
begin
  Data.Bits := D.DataBits;
  Server.Events.RunWiegandRequestConfigEvent(Self);
  Send(Module.D.IP, CMD_WIEGAND_CONFIG, D.DevId, @Data, SizeOf(Data));
end;

procedure TPSWiegand.OnData(Data: LongWord);
var
  ProcIndex: Cardinal;
  ParamList: TPSList;
begin
  FData := Data;
  Server.Events.RunWiegandDataEvent(Self, Data);

  ProcIndex := Server.ScriptEngine.Exec.GetProc(D.OnData);
  if ProcIndex <> InvalidVal then
  begin
    ParamList := TPSList.Create;
    ParamList.Add(GetIntegerParam(Data));
    ParamList.Add(GetClassParam(Self));
    Server.ScriptEngine.Exec.RunProc(ParamList, ProcIndex);
    FreePIFVariantList(ParamList);
  end;
end;

{ TPSWiegandList }

{ Private declarations }

function TPSWiegandList.GetItem(Index: Integer): TPSWiegand;
begin
  Result := TObject(Get(Index)) as TPSWiegand;
end;

{ TPSRS232 }

{ Private declarations }

function TPSRS232.GetData: TRS232Data;
begin
  Result := TRS232(ConfigObject).D;
end;

{ Protected declarations }

function TPSRS232.GetDevId: Byte;
begin
  Result := D.DevId;
end;

{ Public declarations }

procedure TPSRS232.Clear;
begin
  FData := '';
end;

procedure TPSRS232.Process(Command, DevId: Byte; Data: Pointer; DataSize: Byte);
begin
  case Command of
    CMD_RS232_REQUEST_CONFIG:
      OnRequestConfig;
    CMD_RS232_DATA:
      OnData(PByte(Data)^);
  end;
end;

procedure TPSRS232.OnRequestConfig;
var
  Data: TRS232ConfigRec;
begin
  Server.Events.RunRS232RequestConfigEvent(Self);

  Data.Baudrate := D.Bitrate;
  Data.DataBits := D.DataBits;
  Data.Parity   := D.Parity;
  Data.StopBits := D.StopBits;
  Send(Module.D.IP, CMD_RS232_CONFIG, D.DevId, @Data, SizeOf(Data));
end;

procedure TPSRS232.OnData(Data: Byte);
var
  ProcIndex: Cardinal;
  ParamList: TPSList;
begin
  FData := FData + Char(Data);
  Server.Events.RunRS232DataEvent(Self, Char(Data));

  ProcIndex := Server.ScriptEngine.Exec.GetProc(D.OnData);
  if ProcIndex <> InvalidVal then
  begin
    ParamList := TPSList.Create;
    ParamList.Add(GetByteParam(Data));
    ParamList.Add(GetClassParam(Self));
    Server.ScriptEngine.Exec.RunProc(ParamList, ProcIndex);
    FreePIFVariantList(ParamList);
  end;
end;

{ TPSRS232List }

{ Private declarations }

function TPSRS232List.GetItem(Index: Integer): TPSRS232;
begin
  Result := TObject(Get(Index)) as TPSRS232;
end;

{ TPSRS485 }

{ Private declarations }

function TPSRS485.GetData: TRS485Data;
begin
  Result := TRS485(ConfigObject).D;
end;

{ Protected declarations }

function TPSRS485.GetDevId: Byte;
begin
  Result := D.DevId;
end;

{ Public declarations }

procedure TPSRS485.Clear;
begin
  FData := '';
end;

procedure TPSRS485.Process(Command, DevId: Byte; Data: Pointer; DataSize: Byte);
begin
  case Command of
    CMD_RS485_REQUEST_CONFIG:
      OnRequestConfig;
    CMD_RS485_DATA:
      OnData(PByte(Data)^);
  end;
end;

procedure TPSRS485.OnRequestConfig;
var
  Data: TRS232ConfigRec;
begin
  Server.Events.RunRS485RequestConfigEvent(Self);

  Data.Baudrate := D.Bitrate;
  Data.DataBits := D.DataBits;
  Data.Parity   := D.Parity;
  Data.StopBits := D.StopBits;
  Send(Module.D.IP, CMD_RS485_CONFIG, D.DevId, @Data, SizeOf(Data));
end;

procedure TPSRS485.OnData(Data: Byte);
var
  ProcIndex: Cardinal;
  ParamList: TPSList;
begin
  FData := FData + Char(Data);
  Server.Events.RunRS485DataEvent(Self, Char(Data));

  ProcIndex := Server.ScriptEngine.Exec.GetProc(D.OnData);
  if ProcIndex <> InvalidVal then
  begin
    ParamList := TPSList.Create;
    ParamList.Add(GetByteParam(Data));
    ParamList.Add(GetClassParam(Self));
    Server.ScriptEngine.Exec.RunProc(ParamList, ProcIndex);
    FreePIFVariantList(ParamList);
  end;
end;

{ TPSRS485List }

{ Private declarations }

function TPSRS485List.GetItem(Index: Integer): TPSRS485;
begin
  Result := TObject(Get(Index)) as TPSRS485;
end;

{ TPSMotor }

{ Private declarations }

function TPSMotor.GetData: TMotorData;
begin
  Result := TMotor(ConfigObject).D;
end;

{ Protected declarations }

function TPSMotor.GetDevId: Byte;
begin
  Result := D.DevId;
end;

{ Public declarations }

procedure TPSMotor.Start(Polarity: Byte; Delay, Duration: Word; Break, Terminate: TPSDigitalInput; StopKind: Byte);
var
  Data: TMotorStartRec;
begin
  Data.Polarity := Byte(Polarity);
  Data.Delay := Delay;
  Data.Duration := Duration;
  if Assigned(Break) then
    Data.BreakDevId := Break.DevId
  else
    Data.BreakDevId := 255;
  if Assigned(Terminate) then
    Data.TerminateDevId := Terminate.DevId
  else
    Data.TerminateDevId := 255;
  Data.StopKind := StopKind;
  Send(Module.D.IP, CMD_MOTOR_START, D.DevId, @Data, SizeOf(Data));
end;

procedure TPSMotor.Stop(StopKind: Byte);
var
  Data: TMotorStopRec;
begin
  Data.StopKind := StopKind;
  Send(Module.D.IP, CMD_MOTOR_STOP, D.DevId, @Data, SizeOf(Data));
end;

{ TPSMotorList }

{ Private declarations }

function TPSMotorList.GetItem(Index: Integer): TPSMotor;
begin
  Result := TObject(Get(Index)) as TPSMotor;
end;

{ *** }

function RecreateScriptObjects(Config: TConfig; LocalIP: String; SendPacketProc: TSendPacketMethod; ScriptEngine: TPSScript): TPSServer;
var
  I, J, K: Integer;
  Module: TPSModule;
begin
  Result := nil;
  for I := 0 to Config.Servers.Count - 1 do
    if Config.Servers[I].D.IP = LocalIP then
    begin
      Result := TPSServer.Create(nil, Config.Servers[I], SendPacketProc);
      Result.ScriptEngine := ScriptEngine;
      for J := 0 to Config.Servers[I].Timers.Count - 1 do
        Result.Timers.Add(TPSTimer.Create(Result, Config.Servers[I].Timers[J], SendPacketProc));
      for J := 0 to Config.Servers[I].Modules.Count - 1 do
      begin
        Module := TPSModule.Create(Result, Config.Servers[I].Modules[J], SendPacketProc);
        Result.Modules.Add(Module);
        for K := 0 to Config.Servers[I].Modules[J].AnalogInputs.Count - 1 do
          Module.AnalogInputs.Add(TPSAnalogInput.Create(Module, Config.Servers[I].Modules[J].AnalogInputs[K], SendPacketProc));
        for K := 0 to Config.Servers[I].Modules[J].DigitalInputs.Count - 1 do
          Module.DigitalInputs.Add(TPSDigitalInput.Create(Module, Config.Servers[I].Modules[J].DigitalInputs[K], SendPacketProc));
        for K := 0 to Config.Servers[I].Modules[J].DigitalOutputs.Count - 1 do
          Module.DigitalOutputs.Add(TPSDigitalOutput.Create(Module, Config.Servers[I].Modules[J].DigitalOutputs[K], SendPacketProc));
        for K := 0 to Config.Servers[I].Modules[J].Relays.Count - 1 do
          Module.Relays.Add(TPSRelay.Create(Module, Config.Servers[I].Modules[J].Relays[K], SendPacketProc));
        for K := 0 to Config.Servers[I].Modules[J].Wiegands.Count - 1 do
          Module.Wiegands.Add(TPSWiegand.Create(Module, Config.Servers[I].Modules[J].Wiegands[K], SendPacketProc));
        for K := 0 to Config.Servers[I].Modules[J].RS232s.Count - 1 do
          Module.RS232s.Add(TPSRS232.Create(Module, Config.Servers[I].Modules[J].RS232s[K], SendPacketProc));
        for K := 0 to Config.Servers[I].Modules[J].RS485s.Count - 1 do
          Module.RS485s.Add(TPSRS485.Create(Module, Config.Servers[I].Modules[J].RS485s[K], SendPacketProc));
        for K := 0 to Config.Servers[I].Modules[J].Motors.Count - 1 do
          Module.Motors.Add(TPSMotor.Create(Module, Config.Servers[I].Modules[J].Motors[K], SendPacketProc));
      end;
    end;
end;

procedure RecompileScript(Server: TPSServer; Config: TConfig);
var
  S: String;
  I: Integer;
begin
  if Assigned(Server) then
  begin
    Server.ScriptEngine.Script.Text := Config.ConfigFile.GlobalData.Code;
    Server.ScriptEngine.SuppressLoadData := True;

    if not Server.ScriptEngine.Compile then
    begin
      S := '';
      for I := 0 to Server.ScriptEngine.CompilerMessageCount - 1 do
      begin
        if S <> '' then S := S + #13#10;
        S := S + Server.ScriptEngine.CompilerMessages[I].MessageToString;
      end;
      if S <> '' then
        Server.Log.Error('Error while compiling script' + #13#10 + S)
      else
        Server.Log.Error('Error while compiling script');
    end
    else if not Server.ScriptEngine.LoadExec then
    begin
      Server.Log.Error('Error while preparing execution environment' + #13#10 + Server.ScriptEngine.ExecErrorToString);
    end;
  end;
end;

{ TPSScriptObjects }

{ Additional functions }

procedure Suspend;
begin
  Application.ProcessMessages;
end;

{ Property helpers }

procedure ItemReadServer(Self: TPSItem; var Server: TPSServer);
begin
  Server := Self.Server;
end;

procedure DeviceReadModule(Self: TPSDevice; var Module: TPSModule);
begin
  Module := Self.Module;
end;

procedure ServerTitleRead(Self: TPSServer; var Title: string);
begin
  Title := Self.D.Title;
end;

procedure ServerModuleCountRead(Self: TPSServer; var Count: Integer);
begin
  Count := Self.Modules.Count;
end;

procedure ServerModulesRead(Self: TPSServer; var Module: TPSModule; const Index: Integer);
begin
  Module := Self.Modules[Index];
end;

procedure ServerTimerCountRead(Self: TPSServer; var Count: Integer);
begin
  Count := Self.Timers.Count;
end;

procedure ServerTimersRead(Self: TPSServer; var Timer: TPSTimer; const Index: Integer);
begin
  Timer := Self.Timers[Index];
end;

procedure TimerTitleRead(Self: TPSTimer; var Title: string);
begin
  Title := Self.D.Title;
end;

procedure TimerIntervalRead(Self: TPSTimer; var Interval: Integer);
begin
  Interval := Self.D.Interval;
end;

procedure TimerIntervalWrite(Self: TPSTimer; const Interval: Integer);
begin
  Self.D.Interval := Interval;

  // update runtime timer
  if Self.FTimer <> 0 then
  begin
    Self.Stop;
    Self.Start;
  end;
end;

procedure TimerRunningRead(Self: TPSTimer; var Running: Boolean);
begin
  Running := Self.FTimer <> 0;
end;

procedure TimerRunningWrite(Self: TPSTimer; const Running: Boolean);
begin
  if Running then
    Self.Start
  else
    Self.Stop;
end;

procedure ModuleTitleRead(Self: TPSModule; var Title: string);
begin
  Title := Self.D.Title;
end;

procedure ModuleAnalogInputCountRead(Self: TPSModule; var Count: Integer);
begin
  Count := Self.AnalogInputs.Count;
end;

procedure ModuleAnalogInputsRead(Self: TPSModule; var AnalogInput: TPSAnalogInput; const Index: Integer);
begin
  AnalogInput := Self.AnalogInputs[Index];
end;

procedure ModuleDigitalInputCountRead(Self: TPSModule; var Count: Integer);
begin
  Count := Self.DigitalInputs.Count;
end;

procedure ModuleDigitalInputsRead(Self: TPSModule; var DigitalInput: TPSDigitalInput; const Index: Integer);
begin
  DigitalInput := Self.DigitalInputs[Index];
end;

procedure ModuleDigitalOutputCountRead(Self: TPSModule; var Count: Integer);
begin
  Count := Self.DigitalOutputs.Count;
end;

procedure ModuleDigitalOutputsRead(Self: TPSModule; var DigitalOutput: TPSDigitalOutput; const Index: Integer);
begin
  DigitalOutput := Self.DigitalOutputs[Index];
end;

procedure ModuleRelayCountRead(Self: TPSModule; var Count: Integer);
begin
  Count := Self.Relays.Count;
end;

procedure ModuleRelaysRead(Self: TPSModule; var Relay: TPSRelay; const Index: Integer);
begin
  Relay := Self.Relays[Index];
end;

procedure ModuleWiegandCountRead(Self: TPSModule; var Count: Integer);
begin
  Count := Self.Wiegands.Count;
end;

procedure ModuleWiegandsRead(Self: TPSModule; var Wiegand: TPSWiegand; const Index: Integer);
begin
  Wiegand := Self.Wiegands[Index];
end;

procedure ModuleRS232CountRead(Self: TPSModule; var Count: Integer);
begin
  Count := Self.RS232s.Count;
end;

procedure ModuleRS232sRead(Self: TPSModule; var RS232: TPSRS232; const Index: Integer);
begin
  RS232 := Self.RS232s[Index];
end;

procedure ModuleRS485CountRead(Self: TPSModule; var Count: Integer);
begin
  Count := Self.RS485s.Count;
end;

procedure ModuleRS485sRead(Self: TPSModule; var RS485: TPSRS485; const Index: Integer);
begin
  RS485 := Self.RS485s[Index];
end;

procedure ModuleMotorCountRead(Self: TPSModule; var Count: Integer);
begin
  Count := Self.Motors.Count;
end;

procedure ModuleMotorsRead(Self: TPSModule; var Motor: TPSMotor; const Index: Integer);
begin
  Motor := Self.Motors[Index];
end;

procedure AnalogInputTitleRead(Self: TPSAnalogInput; var Title: string);
begin
  Title := Self.D.Title;
end;

procedure AnalogInputValueRead(Self: TPSAnalogInput; var Value: Word);
begin
  Value := Self.FValue;
end;

procedure DigitalInputTitleRead(Self: TPSDigitalInput; var Title: string);
begin
  Title := Self.D.Title;
end;

procedure DigitalInputStateRead(Self: TPSDigitalInput; var State: Boolean);
begin
  State := Self.FStatus;
end;

procedure DigitalOutputTitleRead(Self: TPSDigitalOutput; var Title: string);
begin
  Title := Self.D.Title;
end;

procedure DigitalOutputStateRead(Self: TPSDigitalOutput; var State: Boolean);
begin
  State := Self.FStatus;
end;

procedure RelayTitleRead(Self: TPSRelay; var Title: string);
begin
  Title := Self.D.Title;
end;

procedure RelayStateRead(Self: TPSRelay; var State: Boolean);
begin
  State := Self.FStatus;
end;

procedure WiegandTitleRead(Self: TPSWiegand; var Title: string);
begin
  Title := Self.D.Title;
end;

procedure WiegandDataRead(Self: TPSWiegand; var Data: LongWord);
begin
  Data := Self.FData;
end;

procedure RS232TitleRead(Self: TPSRS232; var Title: string);
begin
  Title := Self.D.Title;
end;

procedure RS232DataRead(Self: TPSRS232; var Data: String);
begin
  Data := Self.FData;
end;

procedure RS485TitleRead(Self: TPSRS485; var Title: string);
begin
  Title := Self.D.Title;
end;

procedure RS485DataRead(Self: TPSRS485; var Data: String);
begin
  Data := Self.FData;
end;

procedure MotorTitleRead(Self: TPSMotor; var Title: string);
begin
  Title := Self.D.Title;
end;

procedure MotorStateRead(Self: TPSMotor; var State: Integer);
begin
//  State := Self.State;
  State := 0;
end;

{ Protected declarations }

procedure TPSScriptObjects.CompileImport1(CompExec: TPSScript);
var
  AnalogInput: TPSCompileTimeClass;
  DigitalInput: TPSCompileTimeClass;
  DigitalOutput: TPSCompileTimeClass;
  Relay: TPSCompileTimeClass;
  Wiegand: TPSCompileTimeClass;
  RS232: TPSCompileTimeClass;
  RS485: TPSCompileTimeClass;
  Motor: TPSCompileTimeClass;
  Module: TPSCompileTimeClass;
  Timer: TPSCompileTimeClass;
begin
  // common functions
  CompExec.Comp.AddDelphiFunction('PROCEDURE LOG(S: STRING);');
  CompExec.Comp.AddDelphiFunction('PROCEDURE SUSPEND;');

  // standard classes
  with CompExec.Comp.AddClassN(nil, 'TOBJECT') do
  begin
    RegisterMethod('constructor Create');
    RegisterMethod('procedure Free');
  end;

  // forward declarations of class types (needed to register TPSModule and TPSServer) 
  Timer := CompExec.Comp.AddClassN(CompExec.Comp.FindClass('TOBJECT'), 'TPSTIMER');
  Module := CompExec.Comp.AddClassN(CompExec.Comp.FindClass('TOBJECT'), 'TPSMODULE');
  AnalogInput := CompExec.Comp.AddClassN(CompExec.Comp.FindClass('TOBJECT'), 'TPSANALOGINPUT');
  DigitalInput := CompExec.Comp.AddClassN(CompExec.Comp.FindClass('TOBJECT'), 'TPSDIGITALINPUT');
  DigitalOutput := CompExec.Comp.AddClassN(CompExec.Comp.FindClass('TOBJECT'), 'TPSDIGITALOUTPUT');
  Relay := CompExec.Comp.AddClassN(CompExec.Comp.FindClass('TOBJECT'), 'TPSRELAY');
  Wiegand := CompExec.Comp.AddClassN(CompExec.Comp.FindClass('TOBJECT'), 'TPSWIEGAND');
  RS232 := CompExec.Comp.AddClassN(CompExec.Comp.FindClass('TOBJECT'), 'TPSRS232');
  RS485 := CompExec.Comp.AddClassN(CompExec.Comp.FindClass('TOBJECT'), 'TPSRS485');
  Motor := CompExec.Comp.AddClassN(CompExec.Comp.FindClass('TOBJECT'), 'TPSMotor');

  // server class
  with CompExec.Comp.AddClassN(CompExec.Comp.FindClass('TOBJECT'), 'TPSSERVER') do
  begin
    RegisterMethod('PROCEDURE RESETMODULES;');
    RegisterProperty('TITLE', 'STRING', iptR);
    RegisterProperty('TIMERCOUNT', 'INTEGER', iptR);
    RegisterProperty('TIMERS', 'TPSTIMER INTEGER', iptR);
    RegisterProperty('MODULECOUNT', 'INTEGER', iptR);
    RegisterProperty('MODULES', 'TPSMODULE INTEGER', iptR);
  end;

  // timer class
  with Timer do
  begin
    RegisterMethod('PROCEDURE START;');
    RegisterMethod('PROCEDURE STOP;');
    RegisterProperty('SERVER', 'TPSSERVER', iptR);
    RegisterProperty('TITLE', 'STRING', iptR);
    RegisterProperty('INTERVAL', 'INTEGER', iptRW);
    RegisterProperty('RUNNING', 'BOOLEAN', iptRW);
  end;

  // module class
  with Module do
  begin
    RegisterMethod('PROCEDURE RESET;');
    RegisterProperty('SERVER', 'TPSSERVER', iptR);
    RegisterProperty('TITLE', 'STRING', iptR);
    RegisterProperty('ANALOGINPUTCOUNT', 'INTEGER', iptR);
    RegisterProperty('ANALOGINPUTS', 'TPSANALOGINPUT INTEGER', iptR);
    RegisterProperty('DIGITALINPUTCOUNT', 'INTEGER', iptR);
    RegisterProperty('DIGITALINPUTS', 'TPSDIGITALINPUT INTEGER', iptR);
    RegisterProperty('DIGITALOUTPUTCOUNT', 'INTEGER', iptR);
    RegisterProperty('DIGITALOUTPUTS', 'TPSDIGITALOUTPUT INTEGER', iptR);
    RegisterProperty('RELAYCOUNT', 'INTEGER', iptR);
    RegisterProperty('RELAYS', 'TPSRELAY INTEGER', iptR);
    RegisterProperty('WIEGANDCOUNT', 'INTEGER', iptR);
    RegisterProperty('WIEGANDS', 'TPSWIEGAND INTEGER', iptR);
    RegisterProperty('RS232COUNT', 'INTEGER', iptR);
    RegisterProperty('RS232S', 'TPSRS232 INTEGER', iptR);
    RegisterProperty('RS485COUNT', 'INTEGER', iptR);
    RegisterProperty('RS485S', 'TPSRS485 INTEGER', iptR);
    RegisterProperty('MOTORCOUNT', 'INTEGER', iptR);
    RegisterProperty('MOTORS', 'TPSMOTOR INTEGER', iptR);
  end;

  // analog input class
  with AnalogInput do
  begin
    RegisterProperty('SERVER', 'TPSSERVER', iptR);
    RegisterProperty('MODULE', 'TPSMODULE', iptR);
    RegisterProperty('TITLE', 'STRING', iptR);
    RegisterProperty('VALUE', 'WORD', iptR);
  end;

  // digital input
  with DigitalInput do
  begin
    RegisterProperty('SERVER', 'TPSSERVER', iptR);
    RegisterProperty('MODULE', 'TPSMODULE', iptR);
    RegisterProperty('TITLE', 'STRING', iptR);
    RegisterProperty('STATE', 'BOOLEAN', iptR);
  end;

  // digital output
  with DigitalOutput do
  begin
    RegisterMethod('procedure Control(InitialStatus, FinalStatus: Boolean; Delay, Duration: Word; Break, Terminate: TPSDigitalInput);');
    RegisterMethod('procedure Open;');
    RegisterMethod('procedure Close;');
    RegisterProperty('SERVER', 'TPSSERVER', iptR);
    RegisterProperty('MODULE', 'TPSMODULE', iptR);
    RegisterProperty('TITLE', 'STRING', iptR);
    RegisterProperty('STATE', 'BOOLEAN', iptR);
  end;

  // relay
  with Relay do
  begin
    RegisterMethod('procedure Control(InitialStatus, FinalStatus: Boolean; Delay, Duration: Word; Break, Terminate: TPSDigitalInput);');
    RegisterMethod('procedure Open;');
    RegisterMethod('procedure Close;');
    RegisterProperty('SERVER', 'TPSSERVER', iptR);
    RegisterProperty('MODULE', 'TPSMODULE', iptR);
    RegisterProperty('TITLE', 'STRING', iptR);
    RegisterProperty('STATE', 'BOOLEAN', iptR);
  end;

  // wiegand
  with Wiegand do
  begin
    RegisterProperty('SERVER', 'TPSSERVER', iptR);
    RegisterProperty('MODULE', 'TPSMODULE', iptR);
    RegisterProperty('TITLE', 'STRING', iptR);
    RegisterProperty('DATA', 'LONGWORD', iptR);
  end;

  // RS232
  with RS232 do
  begin
    RegisterMethod('PROCEDURE CLEAR;');
    RegisterProperty('SERVER', 'TPSSERVER', iptR);
    RegisterProperty('MODULE', 'TPSMODULE', iptR);
    RegisterProperty('TITLE', 'STRING', iptR);
    RegisterProperty('DATA', 'STRING', iptR);
  end;

  // RS485
  with RS485 do
  begin
    RegisterMethod('PROCEDURE CLEAR;');
    RegisterProperty('SERVER', 'TPSSERVER', iptR);
    RegisterProperty('MODULE', 'TPSMODULE', iptR);
    RegisterProperty('TITLE', 'STRING', iptR);
    RegisterProperty('DATA', 'STRING', iptR);
  end;

  // motor
  with Motor do
  begin
    RegisterMethod('procedure Start(Polarity: Byte; Delay, Duration: Word; Break, Terminate: TPSDigitalInput; StopKind: Byte);');
    RegisterMethod('procedure Stop(StopKind: Byte);');
    RegisterProperty('SERVER', 'TPSSERVER', iptR);
    RegisterProperty('MODULE', 'TPSMODULE', iptR);
    RegisterProperty('TITLE', 'STRING', iptR);
    RegisterProperty('STATE', 'INTEGER', iptR);
  end;
end;

procedure TPSScriptObjects.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  // standard classes
  with ri.Add(TObject) do
  begin
    RegisterConstructor(@TObject.Create, 'CREATE');
    RegisterMethod(@TObject.Free, 'FREE');
  end;

  // common functions
  CompExec.Exec.RegisterDelphiFunction(@Log, 'LOG', cdRegister);
  CompExec.Exec.RegisterDelphiFunction(@Suspend, 'SUSPEND', cdRegister);

  // server
  with ri.Add(TPSServer) do
  begin
    RegisterMethod(@TPSServer.ResetModules, 'RESETMODULES');
    RegisterPropertyHelper(@ServerTitleRead, nil, 'TITLE');
    RegisterPropertyHelper(@ServerTimerCountRead, nil, 'TIMERCOUNT');
    RegisterPropertyHelper(@ServerTimersRead, nil, 'TIMERS');
    RegisterPropertyHelper(@ServerModuleCountRead, nil, 'MODULECOUNT');
    RegisterPropertyHelper(@ServerModulesRead, nil, 'MODULES');
  end;

  // timer
  with ri.Add(TPSTimer) do
  begin
    RegisterMethod(@TPSTimer.Start, 'START');
    RegisterMethod(@TPSTimer.Stop, 'STOP');
    RegisterPropertyHelper(@ItemReadServer, nil, 'SERVER');
    RegisterPropertyHelper(@TimerTitleRead, nil, 'TITLE');
    RegisterPropertyHelper(@TimerIntervalRead, @TimerIntervalWrite, 'INTERVAL');
    RegisterPropertyHelper(@TimerRunningRead, @TimerRunningWrite, 'RUNNING');
  end;

  // module
  with ri.Add(TPSModule) do
  begin
    RegisterMethod(@TPSModule.Reset, 'RESET');
    RegisterPropertyHelper(@ItemReadServer, nil, 'SERVER');
    RegisterPropertyHelper(@ModuleTitleRead, nil, 'TITLE');
    RegisterPropertyHelper(@ModuleAnalogInputCountRead, nil, 'ANALOGINPUTCOUNT');
    RegisterPropertyHelper(@ModuleAnalogInputsRead, nil, 'ANALOGINPUTS');
    RegisterPropertyHelper(@ModuleDigitalInputCountRead, nil, 'DIGITALINPUTCOUNT');
    RegisterPropertyHelper(@ModuleDigitalInputsRead, nil, 'DIGITALINPUTS');
    RegisterPropertyHelper(@ModuleDigitalOutputCountRead, nil, 'DIGITALOUTPUTCOUNT');
    RegisterPropertyHelper(@ModuleDigitalOutputsRead, nil, 'DIGITALOUTPUTS');
    RegisterPropertyHelper(@ModuleRelayCountRead, nil, 'RELAYCOUNT');
    RegisterPropertyHelper(@ModuleRelaysRead, nil, 'RELAYS');
    RegisterPropertyHelper(@ModuleWiegandCountRead, nil, 'WIEGANDCOUNT');
    RegisterPropertyHelper(@ModuleWiegandsRead, nil, 'WIEGANDS');
    RegisterPropertyHelper(@ModuleRS232CountRead, nil, 'RS232COUNT');
    RegisterPropertyHelper(@ModuleRS232sRead, nil, 'RS232S');
    RegisterPropertyHelper(@ModuleRS485CountRead, nil, 'RS485COUNT');
    RegisterPropertyHelper(@ModuleRS485sRead, nil, 'RS485S');
    RegisterPropertyHelper(@ModuleMotorCountRead, nil, 'MOTORCOUNT');
    RegisterPropertyHelper(@ModuleMotorsRead, nil, 'MOTORS');
  end;

  // analog input
  with ri.Add(TPSAnalogInput) do
  begin
    RegisterPropertyHelper(@ItemReadServer, nil, 'SERVER');
    RegisterPropertyHelper(@DeviceReadModule, nil, 'MODULE');
    RegisterPropertyHelper(@AnalogInputTitleRead, nil, 'TITLE');
    RegisterPropertyHelper(@AnalogInputValueRead, nil, 'VALUE');
  end;

  // digital input
  with ri.Add(TPSDigitalInput) do
  begin
    RegisterPropertyHelper(@ItemReadServer, nil, 'SERVER');
    RegisterPropertyHelper(@DeviceReadModule, nil, 'MODULE');
    RegisterPropertyHelper(@DigitalInputTitleRead, nil, 'TITLE');
    RegisterPropertyHelper(@DigitalInputStateRead, nil, 'STATE');
  end;

  // digital output
  with ri.Add(TPSDigitalOutput) do
  begin
    RegisterMethod(@TPSDigitalOutput.Control, 'CONTROL');
    RegisterMethod(@TPSDigitalOutput.Open, 'OPEN');
    RegisterMethod(@TPSDigitalOutput.Close, 'CLOSE');
    RegisterPropertyHelper(@ItemReadServer, nil, 'SERVER');
    RegisterPropertyHelper(@DeviceReadModule, nil, 'MODULE');
    RegisterPropertyHelper(@DigitalOutputTitleRead, nil, 'TITLE');
    RegisterPropertyHelper(@DigitalOutputStateRead, nil, 'STATE');
  end;

  // relay
  with ri.Add(TPSRelay) do
  begin
    RegisterMethod(@TPSRelay.Control, 'CONTROL');
    RegisterMethod(@TPSRelay.Open, 'OPEN');
    RegisterMethod(@TPSRelay.Close, 'CLOSE');
    RegisterPropertyHelper(@ItemReadServer, nil, 'SERVER');
    RegisterPropertyHelper(@DeviceReadModule, nil, 'MODULE');
    RegisterPropertyHelper(@RelayTitleRead, nil, 'TITLE');
    RegisterPropertyHelper(@RelayStateRead, nil, 'STATE');
  end;

  // wiegand
  with ri.Add(TPSWiegand) do
  begin
    RegisterPropertyHelper(@ItemReadServer, nil, 'SERVER');
    RegisterPropertyHelper(@DeviceReadModule, nil, 'MODULE');
    RegisterPropertyHelper(@WiegandTitleRead, nil, 'TITLE');
    RegisterPropertyHelper(@WiegandDataRead, nil, 'DATA');
  end;

  // RS232
  with ri.Add(TPSRS232) do
  begin
    RegisterMethod(@TPSRS232.Clear, 'CLEAR');
    RegisterPropertyHelper(@ItemReadServer, nil, 'SERVER');
    RegisterPropertyHelper(@DeviceReadModule, nil, 'MODULE');
    RegisterPropertyHelper(@RS232TitleRead, nil, 'TITLE');
    RegisterPropertyHelper(@RS232DataRead, nil, 'STRING');
  end;

  // RS485
  with ri.Add(TPSRS485) do
  begin
    RegisterMethod(@TPSRS485.Clear, 'CLEAR');
    RegisterPropertyHelper(@ItemReadServer, nil, 'SERVER');
    RegisterPropertyHelper(@DeviceReadModule, nil, 'MODULE');
    RegisterPropertyHelper(@RS485TitleRead, nil, 'TITLE');
    RegisterPropertyHelper(@RS485DataRead, nil, 'STRING');
  end;

  // motor
  with ri.Add(TPSMotor) do
  begin
    RegisterMethod(@TPSMotor.Start, 'START');
    RegisterMethod(@TPSMotor.Stop, 'STOP');
    RegisterPropertyHelper(@ItemReadServer, nil, 'SERVER');
    RegisterPropertyHelper(@DeviceReadModule, nil, 'MODULE');
    RegisterPropertyHelper(@MotorTitleRead, nil, 'TITLE');
    RegisterPropertyHelper(@MotorStateRead, nil, 'INTEGER');
  end;
end;

initialization
  _Log := TLogLogger.GetLogger('SCRIPT');

end.

