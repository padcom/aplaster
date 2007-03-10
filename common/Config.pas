// ----------------------------------------------------------------------------
// file: Config.pas - a part of AplaSter system
// date: 2005-09-08
// auth: Matthias Hryniszak
// desc: definition of configuration objects
// ----------------------------------------------------------------------------

unit Config;

{$IFOPT D+}
  {$DEFINE DEBUG}
{$ENDIF}

interface

uses
  Classes, SysUtils,
  PxDataFile,
  ConfigFile;

const
  BITRATE_2400        = 0;
  BITRATE_4800        = 1;
  BITRATE_9600        = 2;
  BITRATE_19200       = 3;
  BITRATE_38400       = 4;
  BITRATE_57600       = 5;
  BITRATE_115200      = 6;
  DATABITS_7          = 0;
  DATABITS_8          = 1;
  PARITY_NONE         = 0;
  PARITY_ODD          = 1;
  PARITY_EVEN         = 2;
  STOPBITS_ONE        = 0;
  STOPBITS_ONEANDHALF = 1;
  STOPBITS_TWO        = 2;

type
  TConfig = class;
  TConfigItemList = class;
  TServerList = class;
  TModule = class;
  TModuleList = class;
  TTimerList = class;
  TAnalogInputList = class;
  TDigitalInputList = class;
  TDigitalOutputList = class;
  TRelayList = class;
  TWiegandList = class;
  TRS232List = class;
  TRS485List = class;
  TMotorList = class;
  TFolderList = class;

  TConfigItem = class (TObject)
  private
    FDataObject: TPxDataRecord;
    FConfig: TConfig;
    FParent: TConfigItem;
    FItems: TConfigItemList;
    function GetId: TIdentifier;
  protected
    procedure UpdateLists; virtual;
  public
    constructor Create(AConfig: TConfig; AParent: TConfigItem; ADataObject: TPxDataRecord); virtual;
    destructor Destroy; override;
    property Id: TIdentifier read GetId;
    property Config: TConfig read FConfig;
    property DataObject: TPxDataRecord read FDataObject;
    property Parent: TConfigItem read FParent;
    property Items: TConfigItemList read FItems;
  end;

  TConfigItemList = class (TList)
  private
    function GetItem(Index: Integer): TConfigItem;
  public
    property Items[Index: Integer]: TConfigItem read GetItem; default;
  end;

  TServer = class (TConfigItem)
  private
    FModules: TModuleList;
    FTimers: TTimerList;
    FFolders: TFolderList;
    function GetData: TServerData;
  protected
    procedure UpdateLists; override;
  public
    constructor Create(AConfig: TConfig; AParent: TConfigItem; ADataObject: TPxDataRecord); override;
    destructor Destroy; override;
    property D: TServerData read GetData;
    property Modules: TModuleList read FModules;
    property Timers: TTimerList read FTimers;
    property Folders: TFolderList read FFolders;
  end;

  TServerList = class (TList)
  private
    function GetItem(Index: Integer): TServer;
  public
    property Items[Index: Integer]: TServer read GetItem; default;
  end;

  TModule = class (TConfigItem)
  private
    FAnalogInputs: TAnalogInputList;
    FDigitalInputs: TDigitalInputList;
    FDigitalOutputs: TDigitalOutputList;
    FRelays: TRelayList;
    FWiegands: TWiegandList;
    FRS232s: TRS232List;
    FRS485s: TRS485List;
    FMotors: TMotorList;
    function GetData: TModuleData;
  protected
    procedure UpdateLists; override;
  public
    constructor Create(AConfig: TConfig; AParent: TConfigItem; ADataObject: TPxDataRecord); override;
    destructor Destroy; override;
    property D: TModuleData read GetData;
    property AnalogInputs: TAnalogInputList read FAnalogInputs;
    property DigitalInputs: TDigitalInputList read FDigitalInputs;
    property DigitalOutputs: TDigitalOutputList read FDigitalOutputs;
    property Relays: TRelayList read FRelays;
    property Wiegands: TWiegandList read FWiegands;
    property RS232s: TRS232List read FRS232s;
    property RS485s: TRS485List read FRS485s;
    property Motors: TMotorList read FMotors;
  end;

  TModuleList = class (TList)
  private
    function GetItem(Index: Integer): TModule;
  public
    property Items[Index: Integer]: TModule read GetItem; default;
  end;

  TModuleDevice = class (TConfigItem)
  private
    function GetModule: TModule;
  protected
    function GetDevId: Byte; virtual; abstract;
  public
    property Module: TModule read GetModule;
    property DevId: Byte read GetDevId;
  end;

  TAnalogInput = class (TModuleDevice)
  private
    function GetData: TAnalogInputData;
  protected
    function GetDevId: Byte; override;
  public
    property D: TAnalogInputData read GetData;
  end;

  TAnalogInputList = class (TList)
  private
    function GetItem(Index: Integer): TAnalogInput;
  public
    property Items[Index: Integer]: TAnalogInput read GetItem; default;
  end;

  TDigitalInput = class (TModuleDevice)
  private
    function GetData: TDigitalInputData;
  protected
    function GetDevId: Byte; override;
  public
    property D: TDigitalInputData read GetData;
  end;

  TDigitalInputList = class (TList)
  private
    function GetItem(Index: Integer): TDigitalInput;
  public
    property Items[Index: Integer]: TDigitalInput read GetItem; default;
  end;

  TDigitalOutput = class (TModuleDevice)
  private
    function GetData: TDigitalOutputData;
  protected
    function GetDevId: Byte; override;
  public
    property D: TDigitalOutputData read GetData;
  end;

  TDigitalOutputList = class (TList)
  private
    function GetItem(Index: Integer): TDigitalOutput;
  public
    property Items[Index: Integer]: TDigitalOutput read GetItem; default;
  end;

  TRelay = class (TModuleDevice)
  private
    function GetData: TRelayData;
  protected
    function GetDevId: Byte; override;
  public
    property D: TRelayData read GetData;
  end;

  TRelayList = class (TList)
  private
    function GetItem(Index: Integer): TRelay;
  public
    property Items[Index: Integer]: TRelay read GetItem; default;
  end;

  TWiegand = class (TModuleDevice)
  private
    function GetData: TWiegandData;
  protected
    function GetDevId: Byte; override;
  public
    property D: TWiegandData read GetData;
  end;

  TWiegandList = class (TList)
  private
    function GetItem(Index: Integer): TWiegand;
  public
    property Items[Index: Integer]: TWiegand read GetItem; default;
  end;

  TRS232 = class (TModuleDevice)
  private
    function GetData: TRS232Data;
  protected
    function GetDevId: Byte; override;
  public
    property D: TRS232Data read GetData;
  end;

  TRS232List = class (TList)
  private
    function GetItem(Index: Integer): TRS232;
  public
    property Items[Index: Integer]: TRS232 read GetItem; default;
  end;

  TRS485 = class (TModuleDevice)
  private
    function GetData: TRS485Data;
  protected
    function GetDevId: Byte; override;
  public
    property D: TRS485Data read GetData;
  end;

  TRS485List = class (TList)
  private
    function GetItem(Index: Integer): TRS485;
  public
    property Items[Index: Integer]: TRS485 read GetItem; default;
  end;

  TMotor = class (TModuleDevice)
  private
    function GetData: TMotorData;
  protected
    function GetDevId: Byte; override;
  public
    property D: TMotorData read GetData;
  end;

  TMotorList = class (TList)
  private
    function GetItem(Index: Integer): TMotor;
  public
    property Items[Index: Integer]: TMotor read GetItem; default;
  end;

  TTimer = class (TConfigItem)
  private
    function GetData: TTimerData;
  public
    property D: TTimerData read GetData;
  end;

  TTimerList = class (TList)
  private
    function GetItem(Index: Integer): TTimer;
  public
    property Items[Index: Integer]: TTimer read GetItem; default;
  end;

  TFolder = class (TConfigItem)
  private
    FTimers: TTimerList;
    FModules: TModuleList;
    function GetData: TFolderData;
    function GetServer: TServer;
  protected
    procedure UpdateLists; override;
  public
    constructor Create(AConfig: TConfig; AParent: TConfigItem; ADataObject: TPxDataRecord); override;
    destructor Destroy; override;
    property D: TFolderData read GetData;
    property Server: TServer read GetServer;
    property Timers: TTimerList read FTimers;
    property Modules: TModuleList read FModules; 
  end;

  TFolderList = class (TList)
  private
    function GetItem(Index: Integer): TFolder;
  public
    property Items[Index: Integer]: TFolder read GetItem; default;
  end;

  TConfig = class (TObject)
  private
    FConfigFile: TConfigFile;
    FServers: TServerList;
  protected
    procedure RecreateServers;
    procedure RecreateTimers(Server: TServer);
    procedure RecreateModules(Server: TServer);
    procedure RecreateAnalogInputs(Module: TModule);
    procedure RecreateDigitalInputs(Module: TModule);
    procedure RecreateDigitalOutputs(Module: TModule);
    procedure RecreateRelays(Module: TModule);
    procedure RecreateWiegands(Module: TModule);
    procedure RecreateRS232s(Module: TModule);
    procedure RecreateRS485s(Module: TModule);
    procedure RecreateMotors(Module: TModule);
    procedure RecreateFolders(Server: TServer);
    procedure RecreateItems;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure UpdateLists;
    procedure LoadFile(FileName: String);
    procedure LoadStream(S: TStream);
    procedure Save(FileName: String = '');
    procedure SaveStream(S: TStream);
    property ConfigFile: TConfigFile read FConfigFile;
    property Servers: TServerList read FServers;
  end;

implementation

{ TConfigItem }

{ Private declarations }

function TConfigItem.GetId: TIdentifier;
begin
  if Assigned(DataObject) then
    Result := DataObject.RecordID
  else
    Result := INVALID_IDENTIFIER_VALUE;
end;

{ Protected declarations }

procedure TConfigItem.UpdateLists;
var
  I: Integer;
begin
  for I := 0 to Items.Count - 1 do
    Items[I].UpdateLists;
end;

{ Public declarations }

constructor TConfigItem.Create(AConfig: TConfig; AParent: TConfigItem; ADataObject: TPxDataRecord);
begin
  inherited Create;
  FConfig := AConfig;
  FDataObject := ADataObject;
  FParent := AParent;
  FItems := TConfigItemList.Create;
  if Assigned(Parent) then
    Parent.Items.Add(Self);
end;

destructor TConfigItem.Destroy;
begin
  if Assigned(Parent) then
    Parent.Items.Remove(Self);
  while Items.Count > 0 do
    Items[Items.Count - 1].Free;
  FreeAndNil(FItems);
  inherited Destroy;
end;

{ TConfigItemList }

{ Private declarations }

function TConfigItemList.GetItem(Index: Integer): TConfigItem;
begin
  Result := TObject(Get(Index)) as TConfigItem;
end;

{ TServer }

{ Private declarations }

function TServer.GetData: TServerData;
begin
  Result := DataObject as TServerData;
end;

{ Protected declarations }

procedure TServer.UpdateLists;
var
  I: Integer;
begin
  inherited UpdateLists;
  Modules.Clear;
  Timers.Clear;
  Folders.Clear;
  for I := 0 to Items.Count - 1 do
    if Items[I] is TModule then
      Modules.Add(Items[I])
    else if Items[I] is TTimer then
      Timers.Add(Items[I])
    else if Items[I] is TFolder then
      Folders.Add(Items[I])
end;

{ Public declarations }

constructor TServer.Create(AConfig: TConfig; AParent: TConfigItem; ADataObject: TPxDataRecord);
begin
  inherited Create(AConfig, AParent, ADataObject);
  FModules := TModuleList.Create;
  FTimers := TTimerList.Create;
  FFolders := TFolderList.Create;
end;

destructor TServer.Destroy;
begin
  FreeAndNil(FFolders);
  FreeAndNil(FTimers);
  FreeAndNil(FModules);
  inherited Destroy;
end;

{ TServerList }

{ Private declarations }

function TServerList.GetItem(Index: Integer): TServer;
begin
  Result := TObject(Get(Index)) as TServer;
end;

{ TModule }

{ Private declarations }

function TModule.GetData: TModuleData;
begin
  Result := DataObject as TModuleData;
end;

{ Protected declarations }

procedure TModule.UpdateLists;
var
  I: Integer;
begin
  inherited UpdateLists;
  AnalogInputs.Clear;
  DigitalInputs.Clear;
  DigitalOutputs.Clear;
  Relays.Clear;
  Wiegands.Clear;
  RS232s.Clear;
  RS485s.Clear;
  Motors.Clear;
  for I := 0 to Items.Count - 1 do
    if Items[I] is TAnalogInput then
      AnalogInputs.Add(Items[I])
    else if Items[I] is TDigitalInput then
      DigitalInputs.Add(Items[I])
    else if Items[I] is TDigitalOutput then
      DigitalOutputs.Add(Items[I])
    else if Items[I] is TRelay then
      Relays.Add(Items[I])
    else if Items[I] is TWiegand then
      Wiegands.Add(Items[I])
    else if Items[I] is TRS232 then
      RS232s.Add(Items[I])
    else if Items[I] is TRS485 then
      RS485s.Add(Items[I])
    else if Items[I] is TMotor then
      Motors.Add(Items[I])
end;

{ Public declarations }

constructor TModule.Create(AConfig: TConfig; AParent: TConfigItem; ADataObject: TPxDataRecord);
begin
  inherited Create(AConfig, AParent, ADataObject);
  FAnalogInputs := TAnalogInputList.Create;
  FDigitalInputs := TDigitalInputList.Create;
  FDigitalOutputs := TDigitalOutputList.Create;
  FRelays := TRelayList.Create;
  FWiegands := TWiegandList.Create;
  FRS232s := TRS232List.Create;
  FRS485s := TRS485List.Create;
  FMotors := TMotorList.Create;
end;

destructor TModule.Destroy;
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

{ TModuleList }

{ Private declarations }

function TModuleList.GetItem(Index: Integer): TModule;
begin
  Result := TObject(Get(Index)) as TModule;
end;

{ TModuleDevice }

{ Private declarations }

function TModuleDevice.GetModule: TModule;
begin
  REsult := Parent as TModule;
end;

{ TAnalogInput }

{ Private declarations }

function TAnalogInput.GetData: TAnalogInputData;
begin
  Result := DataObject as TAnalogInputData;
end;

{ Protected declarations }

function TAnalogInput.GetDevId: Byte;
begin
  Result := D.DevId;
end;

{ TAnalogInputList }

{ Private declarations }

function TAnalogInputList.GetItem(Index: Integer): TAnalogInput;
begin
  Result := TObject(Get(Index)) as TAnalogInput;
end;

{ TDigitalInput }

{ Private declarations }

function TDigitalInput.GetData: TDigitalInputData;
begin
  Result := DataObject as TDigitalInputData;
end;

{ Protected declarations }

function TDigitalInput.GetDevId: Byte;
begin
  Result := D.DevId;
end;

{ TDigitalInputList }

{ Private declarations }

function TDigitalInputList.GetItem(Index: Integer): TDigitalInput;
begin
  Result := TObject(Get(Index)) as TDigitalInput;
end;

{ TDigitalOutput }

{ Private declarations }

function TDigitalOutput.GetData: TDigitalOutputData;
begin
  Result := DataObject as TDigitalOutputData;
end;

{ Protected declarations }

function TDigitalOutput.GetDevId: Byte;
begin
  Result := D.DevId;
end;

{ TDigitalOutputList }

{ Private declarations }

function TDigitalOutputList.GetItem(Index: Integer): TDigitalOutput;
begin
  Result := TObject(Get(Index)) as TDigitalOutput;
end;

{ TRelay }

{ Private declarations }

function TRelay.GetData: TRelayData;
begin
  Result := DataObject as TRelayData;
end;

{ Protected declarations }

function TRelay.GetDevId: Byte;
begin
  Result := D.DevId;
end;

{ TRelayList }

{ Private declarations }

function TRelayList.GetItem(Index: Integer): TRelay;
begin
  Result := TObject(Get(Index)) as TRelay;
end;

{ TWiegand }

{ Private declarations }

function TWiegand.GetData: TWiegandData;
begin
  Result := DataObject as TWiegandData;
end;

{ Protected declarations }

function TWiegand.GetDevId: Byte;
begin
  Result := D.DevId;
end;

{ TWiegandList }

{ Private declarations }

function TWiegandList.GetItem(Index: Integer): TWiegand;
begin
  Result := TObject(Get(Index)) as TWiegand;
end;

{ TRS232 }

{ Private declarations }

function TRS232.GetData: TRS232Data;
begin
  Result := DataObject as TRS232Data;
end;

{ Protected declarations }

function TRS232.GetDevId: Byte;
begin
  Result := D.DevId;
end;

{ TRS232List }

{ Private declarations }

function TRS232List.GetItem(Index: Integer): TRS232;
begin
  Result := TObject(Get(Index)) as TRS232;
end;

{ TRS485 }

{ Private declarations }

function TRS485.GetData: TRS485Data;
begin
  Result := DataObject as TRS485Data;
end;

{ Protected declarations }

function TRS485.GetDevId: Byte;
begin
  Result := D.DevId;
end;

{ TRS485List }

{ Private declarations }

function TRS485List.GetItem(Index: Integer): TRS485;
begin
  Result := TObject(Get(Index)) as TRS485;
end;

{ TMotor }

{ Private declarations }

function TMotor.GetData: TMotorData;
begin
  Result := DataObject as TMotorData;
end;

{ Protected declarations }

function TMotor.GetDevId: Byte;
begin
  Result := D.DevId;
end;

{ TMotorList }

{ Private declarations }

function TMotorList.GetItem(Index: Integer): TMotor;
begin
  Result := TObject(Get(Index)) as TMotor;
end;

{ TTimer }

{ Private declarations }

function TTimer.GetData: TTimerData;
begin
  Result := DataObject as TTimerData;
end;

{ Public declarations }

{ TTimerList }

{ Private declarations }

function TTimerList.GetItem(Index: Integer): TTimer;
begin
  Result := TObject(Get(Index)) as TTimer;
end;

{ TFolder }

{ Private declarations }

function TFolder.GetData: TFolderData;
begin
  Result := DataObject as TFolderData;
end;

function TFolder.GetServer: TServer;
begin
  Result := Parent as TServer; 
end;

{ Protected declarations }

procedure TFolder.UpdateLists;
var
  I: Integer;
begin
  Timers.Clear;
  Modules.Clear;

  // recreate items
  for I := 0 to Server.Items.Count - 1 do
    if (Server.Items[I] is TTimer) and (TTimer(Server.Items[I]).D.FolderId = D.Id) then
      Timers.Add(Server.Items[I])
    else if (Server.Items[I] is TModule) and (TModule(Server.Items[I]).D.FolderId = D.Id) then
      Modules.Add(Server.Items[I])
end;

{ Public declarations }

constructor TFolder.Create(AConfig: TConfig; AParent: TConfigItem; ADataObject: TPxDataRecord);
begin
  inherited Create(AConfig, AParent, ADataObject);
  FTimers := TTimerList.Create;
  FModules := TModuleList.Create;
end;

destructor TFolder.Destroy;
begin
  FreeAndNil(FModules);
  FreeAndNil(FTimers);
  inherited Destroy;
end;

{ TFolderList }

{ Private declarations }

function TFolderList.GetItem(Index: Integer): TFolder;
begin
  Result := TObject(Get(Index)) as TFolder;
end;

{ TConfig }

{ Private declarations }

{ Protected declarations }

procedure TConfig.RecreateServers;
var
  I: Integer;
  Server: TServer;
begin
  for I := 0 to ConfigFile.ServerDatas.Count - 1 do
  begin
    Server := TServer.Create(Self, nil, ConfigFile.ServerDatas[I]);
    Servers.Add(Server);
    RecreateTimers(Server);
    RecreateModules(Server);
    RecreateFolders(Server);
  end;
end;

procedure TConfig.RecreateTimers(Server: TServer);
var
  I: Integer;
begin
  for I := 0 to ConfigFile.TimerDatas.Count - 1 do
    if ConfigFile.TimerDatas[I].ParentId = Server.Id then
      TTimer.Create(Self, Server, ConfigFile.TimerDatas[I]);
end;

procedure TConfig.RecreateModules(Server: TServer);
var
  I: Integer;
  Module: TModule;
begin
  for I := 0 to ConfigFile.ModuleDatas.Count - 1 do
    if ConfigFile.ModuleDatas[1].ParentId = Server.Id then
    begin
      Module := TModule.Create(Self, Server, ConfigFile.ModuleDatas[I]);
      RecreateAnalogInputs(Module);
      RecreateDigitalInputs(Module);
      RecreateDigitalOutputs(Module);
      RecreateRelays(Module);
      RecreateWiegands(Module);
      RecreateRS232s(Module);
      RecreateRS485s(Module);
      RecreateMotors(Module);
    end;
end;

procedure TConfig.RecreateAnalogInputs(Module: TModule);
var
  I: Integer;
begin
  for I := 0 to ConfigFile.AnalogInputDatas.Count - 1 do
    if ConfigFile.AnalogInputDatas[I].ParentId = Module.Id then
      TAnalogInput.Create(Self, Module, ConfigFile.AnalogInputDatas[I]);
end;

procedure TConfig.RecreateDigitalInputs(Module: TModule);
var
  I: Integer;
begin
  for I := 0 to ConfigFile.DigitalInputDatas.Count - 1 do
    if ConfigFile.DigitalInputDatas[I].ParentId = Module.Id then
      TDigitalInput.Create(Self, Module, ConfigFile.DigitalInputDatas[I]);
end;

procedure TConfig.RecreateDigitalOutputs(Module: TModule);
var
  I: Integer;
begin
  for I := 0 to ConfigFile.DigitalOutputDatas.Count - 1 do
    if ConfigFile.DigitalOutputDatas[I].ParentId = Module.Id then
      TDigitalOutput.Create(Self, Module, ConfigFile.DigitalOutputDatas[I]);
end;

procedure TConfig.RecreateRelays(Module: TModule);
var
  I: Integer;
begin
  for I := 0 to ConfigFile.RelayDatas.Count - 1 do
    if ConfigFile.RelayDatas[I].ParentId = Module.Id then
      TRelay.Create(Self, Module, ConfigFile.RelayDatas[I]);
end;

procedure TConfig.RecreateWiegands(Module: TModule);
var
  I: Integer;
begin
  for I := 0 to ConfigFile.WiegandDatas.Count - 1 do
    if ConfigFile.WiegandDatas[I].ParentId = Module.Id then
      TWiegand.Create(Self, Module, ConfigFile.WiegandDatas[I]);
end;

procedure TConfig.RecreateRS232s(Module: TModule);
var
  I: Integer;
begin
  for I := 0 to ConfigFile.RS232Datas.Count - 1 do
    if ConfigFile.RS232Datas[I].ParentId = Module.Id then
      TRS232.Create(Self, Module, ConfigFile.RS232Datas[I]);
end;

procedure TConfig.RecreateRS485s(Module: TModule);
var
  I: Integer;
begin
  for I := 0 to ConfigFile.RS485Datas.Count - 1 do
    if ConfigFile.RS485Datas[I].ParentId = Module.Id then
      TRS485.Create(Self, Module, ConfigFile.RS485Datas[I]);
end;

procedure TConfig.RecreateMotors(Module: TModule);
var
  I: Integer;
begin
  for I := 0 to ConfigFile.MotorDatas.Count - 1 do
    if ConfigFile.MotorDatas[I].ParentId = Module.Id then
      TMotor.Create(Self, Module, ConfigFile.MotorDatas[I]);
end;

procedure TConfig.RecreateFolders(Server: TServer);
var
  I: Integer;
begin
  for I := 0 to ConfigFile.FolderDatas.Count - 1 do
    if ConfigFile.FolderDatas[I].ServerId = Server.Id then
      TFolder.Create(Self, Server, ConfigFile.FolderDatas[I]);
end;

procedure TConfig.RecreateItems;
begin
  RecreateServers;
  UpdateLists;
end;

{ Public declarations }

constructor TConfig.Create;
begin
  inherited Create;
  FConfigFile := TConfigFile.Create;
  FServers := TServerList.Create;
  RecreateItems;
end;

destructor TConfig.Destroy;
begin
  Clear;
  FreeAndNil(FServers);
  FreeAndNil(FConfigFile);
  inherited Destroy;
end;

procedure TConfig.Clear;
var
  I: Integer;
begin
  for I := 0 to Servers.Count - 1 do
    Servers[I].Free;
  FServers.Clear;
  ConfigFile.Clear(True);
  RecreateItems;
end;

procedure TConfig.UpdateLists;
var
  I: Integer;
begin
  for I := 0 to Servers.Count - 1 do
    Servers[I].UpdateLists;
end;

procedure TConfig.LoadFile(FileName: String);
var
  FileType: string;
begin
  Clear;
  ConfigFile.Clear(False);

  FileType := UpperCase(ExtractFileExt(FileName));
  if FileType = '.XML' then
  begin
    ConfigFile.LoadXmlFile(FileName);
    ConfigFile.Modified := False;
  end
  else
    ConfigFile.Load(FileName);
  RecreateItems;
end;

procedure TConfig.LoadStream(S: TStream);
begin
  Clear;
  ConfigFile.Clear(False);
  ConfigFile.Load(S);
  ConfigFile.FileName := '';
  RecreateItems;
end;

procedure TConfig.Save(FileName: String = '');
var
  FileType: string;
begin
  Assert((FileName <> '') or (ConfigFile.FileName <> ''), 'Error: no file name given');

  if FileName = '' then
    FileName := ConfigFile.FileName;

  FileType := UpperCase(ExtractFileExt(FileName));
  if FileType = '.XML' then
  begin
    ConfigFile.SaveXmlFile(FileName);
    ConfigFile.Modified := False;
  end
  else
    ConfigFile.Save(FileName);
end;

procedure TConfig.SaveStream(S: TStream);
begin
  ConfigFile.Save(S);
end;

end.

