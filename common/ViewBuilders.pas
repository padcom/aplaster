// ----------------------------------------------------------------------------
// file: ViewBuilders.pas - a part of AplaSter system
// date: 2005-09-08
// auth: Matthias Hryniszak
// desc: view builder definitions
// ----------------------------------------------------------------------------

unit ViewBuilders;

interface

uses
  Classes, SysUtils, ComCtrls, Log4D,
  PxDataFile,
  Config;

type
  TNetworkViewBuilder = class (TObject)
  private
    FConfig: TConfig;
  protected
    class function Log: TLogLogger;
    procedure AddFoldersNodes(Nodes: TTreeNodes; Root: TTreeNode; Folders: TFolderList);
    procedure AddTimersNodes(Nodes: TTreeNodes; Root: TTreeNode; Timers: TTimerList; FolderId: TIdentifier = 0);
    procedure AddModulesNodes(Nodes: TTreeNodes; Root: TTreeNode; Modules: TModuleList; FolderId: TIdentifier = 0);
    procedure AddAnalogInputsNodes(Nodes: TTreeNodes; Root: TTreeNode; AnalogInputs: TAnalogInputList);
    procedure AddDigitalInputsNodes(Nodes: TTreeNodes; Root: TTreeNode; DigitalInputs: TDigitalInputList);
    procedure AddDigitalOutputsNodes(Nodes: TTreeNodes; Root: TTreeNode; DigitalOutputs: TDigitalOutputList);
    procedure AddRelaysNodes(Nodes: TTreeNodes; Root: TTreeNode; Relays: TRelayList);
    procedure AddWiegandsNodes(Nodes: TTreeNodes; Root: TTreeNode; Wiegands: TWiegandList);
    procedure AddRS232sNodes(Nodes: TTreeNodes; Root: TTreeNode; RS232s: TRS232List);
    procedure AddRS485sNodes(Nodes: TTreeNodes; Root: TTreeNode; RS485s: TRS485List);
    procedure AddMotorsNodes(Nodes: TTreeNodes; Root: TTreeNode; Motors: TMotorList);
    function FindSiblingNodeForTimer(Root: TTreeNode; Timer: TTimer): TTreeNode;
    function FindSiblingForNodeForModule(Root: TTreeNode; Module: TModule): TTreeNode;
  public
    constructor Create(AConfig: TConfig);
    destructor Destroy; override;
    // tree
    procedure BuildNodes(Nodes: TTreeNodes);
    function BuildServerNode(Nodes: TTreeNodes; Root: TTreeNode; Server: TServer): TTreeNode;
    function BuildTimerNode(Nodes: TTreeNodes; Root: TTreeNode; Timer: TTimer): TTreeNode;
    function BuildModuleNode(Nodes: TTreeNodes; Root: TTreeNode; Module: TModule): TTreeNode;
    function BuildAnalogInputNode(Nodes: TTreeNodes; Root: TTreeNode; AnalogInput: TAnalogInput): TTreeNode;
    function BuildDigitalInputNode(Nodes: TTreeNodes; Root: TTreeNode; DigitalInput: TDigitalInput): TTreeNode;
    function BuildDigitalOutputNode(Nodes: TTreeNodes; Root: TTreeNode; DigitalOutput: TDigitalOutput): TTreeNode;
    function BuildRelayNode(Nodes: TTreeNodes; Root: TTreeNode; Relay: TRelay): TTreeNode;
    function BuildWiegandNode(Nodes: TTreeNodes; Root: TTreeNode; Wiegand: TWiegand): TTreeNode;
    function BuildRS232Node(Nodes: TTreeNodes; Root: TTreeNode; RS232: TRS232): TTreeNode;
    function BuildRS485Node(Nodes: TTreeNodes; Root: TTreeNode; RS485: TRS485): TTreeNode;
    function BuildMotorNode(Nodes: TTreeNodes; Root: TTreeNode; Motor: TMotor): TTreeNode;
    function BuildFolderNode(Nodes: TTreeNodes; Root: TTreeNode; Folder: TFolder): TTreeNode;
    // list
    procedure BuildList(List: TStrings);
  end;

implementation

uses
  Icons;

{ TNetworkViewBuilder }

{ Protected declarations }

{ Protected declarations }

class function TNetworkViewBuilder.Log: TLogLogger;
begin
  Result := TLogLogger.GetLogger(Self);
end;

procedure TNetworkViewBuilder.AddFoldersNodes(Nodes: TTreeNodes; Root: TTreeNode; Folders: TFolderList);
var
  I: Integer;
begin
  for I := 0 to Folders.Count - 1 do
    BuildFolderNode(Nodes, Root, Folders[I]);
end;

procedure TNetworkViewBuilder.AddTimersNodes(Nodes: TTreeNodes; Root: TTreeNode; Timers: TTimerList; FolderId: TIdentifier = 0);
var
  I: Integer;
begin
  for I := 0 to Timers.Count - 1 do
    if Timers[I].D.FolderId = FolderId then
      BuildTimerNode(Nodes, Root, Timers[I]);
end;

procedure TNetworkViewBuilder.AddModulesNodes(Nodes: TTreeNodes; Root: TTreeNode; Modules: TModuleList; FolderId: TIdentifier = 0);
var
  I: Integer;
begin
  for I := 0 to Modules.Count - 1 do
    if Modules[I].D.FolderId = FolderId then
      BuildModuleNode(Nodes, Root, Modules[I]);
end;

procedure TNetworkViewBuilder.AddAnalogInputsNodes(Nodes: TTreeNodes; Root: TTreeNode; AnalogInputs: TAnalogInputList);
var
  I: Integer;
begin
  for I := 0 to AnalogInputs.Count - 1 do
    BuildAnalogInputNode(Nodes, Root, AnalogInputs[I]);
end;

procedure TNetworkViewBuilder.AddDigitalInputsNodes(Nodes: TTreeNodes; Root: TTreeNode; DigitalInputs: TDigitalInputList);
var
  I: Integer;
begin
  for I := 0 to DigitalInputs.Count - 1 do
    BuildDigitalInputNode(Nodes, Root, DigitalInputs[I]);
end;

procedure TNetworkViewBuilder.AddDigitalOutputsNodes(Nodes: TTreeNodes; Root: TTreeNode; DigitalOutputs: TDigitalOutputList);
var
  I: Integer;
begin
  for I := 0 to DigitalOutputs.Count - 1 do
    BuildDigitalOutputNode(Nodes, Root, DigitalOutputs[I]);
end;

procedure TNetworkViewBuilder.AddRelaysNodes(Nodes: TTreeNodes; Root: TTreeNode; Relays: TRelayList);
var
  I: Integer;
begin
  for I := 0 to Relays.Count - 1 do
    BuildRelayNode(Nodes, Root, Relays[I]);
end;

procedure TNetworkViewBuilder.AddWiegandsNodes(Nodes: TTreeNodes; Root: TTreeNode; Wiegands: TWiegandList);
var
  I: Integer;
begin
  for I := 0 to Wiegands.Count - 1 do
    BuildWiegandNode(Nodes, Root, Wiegands[I]);
end;

procedure TNetworkViewBuilder.AddRS232sNodes(Nodes: TTreeNodes; Root: TTreeNode; RS232s: TRS232List);
var
  I: Integer;
begin
  for I := 0 to RS232s.Count - 1 do
    BuildRS232Node(Nodes, Root, RS232s[I]);
end;

procedure TNetworkViewBuilder.AddRS485sNodes(Nodes: TTreeNodes; Root: TTreeNode; RS485s: TRS485List);
var
  I: Integer;
begin
  for I := 0 to RS485s.Count - 1 do
    BuildRS485Node(Nodes, Root, RS485s[I]);
end;

procedure TNetworkViewBuilder.AddMotorsNodes(Nodes: TTreeNodes; Root: TTreeNode; Motors: TMotorList);
var
  I: Integer;
begin
  for I := 0 to Motors.Count - 1 do
    BuildMotorNode(Nodes, Root, Motors[I]);
end;

function TNetworkViewBuilder.FindSiblingNodeForTimer(Root: TTreeNode; Timer: TTimer): TTreeNode;
var
  I: Integer;
  Tmp: TTimer;
begin
  Result := nil;
  for I := 0 to Root.Count - 1 do
    if TObject(Root[I].Data) is TTimer then
    begin
      Tmp := Root[I].Data;
      if TServer(Timer.Parent).Timers.IndexOf(Tmp) > TServer(Timer.Parent).Timers.IndexOf(Timer) then
      begin
        Result := Root[I];
        Break;
      end;
    end
    else if TObject(Root[I].Data) is TModule then
    begin
      Result := Root[I];
      Break;
    end;
end;

function TNetworkViewBuilder.FindSiblingForNodeForModule(Root: TTreeNode; Module: TModule): TTreeNode;
var
  I: Integer;
  Tmp: TModule;
begin
  Result := nil;
  for I := 0 to Root.Count - 1 do
    if TObject(Root[I].Data) is TModule then
    begin
      Tmp := Root[I].Data;
      if TServer(Module.Parent).Modules.IndexOf(Tmp) > TServer(Module.Parent).Modules.IndexOf(Module) then
      begin
        Result := Root[I];
        Break;
      end;
    end;
end;

{ Public declarations }

constructor TNetworkViewBuilder.Create(AConfig: TConfig);
begin
  inherited Create;
  FConfig := AConfig;
end;

destructor TNetworkViewBuilder.Destroy;
begin
  inherited Destroy;
end;

procedure TNetworkViewBuilder.BuildNodes(Nodes: TTreeNodes);
var
  I: Integer;
begin
  Nodes.BeginUpdate;
  try
    Nodes.Clear;
    for I := 0 to FConfig.Servers.Count - 1 do
      BuildServerNode(Nodes, nil, FConfig.Servers[I]);
  finally
    Nodes.EndUpdate;
  end;
end;

function TNetworkViewBuilder.BuildServerNode(Nodes: TTreeNodes; Root: TTreeNode; Server: TServer): TTreeNode;
begin
  if Root = nil then
    Result := Nodes.AddObject(nil, '', Server)
  else
    Result := Nodes.AddChildObject(Root, '', Server);
  Result.ImageIndex := IMAGE_INDEX_SERVER;
  Result.SelectedIndex := IMAGE_INDEX_SERVER;
  AddFoldersNodes(Nodes, Result, Server.Folders);
  AddTimersNodes(Nodes, Result, Server.Timers);
  AddModulesNodes(Nodes, Result, Server.Modules);
end;

function TNetworkViewBuilder.BuildTimerNode(Nodes: TTreeNodes; Root: TTreeNode; Timer: TTimer): TTreeNode;
var
  Sibling: TTreeNode;
begin
  if Root = nil then
    Result := Nodes.AddObject(nil, '', Timer)
  else
  begin
    Sibling := FindSiblingNodeForTimer(Root, Timer);
    if Assigned(Sibling) then
      Result := Nodes.AddNode(nil, Sibling, '', Timer, naInsert)
    else
      Result := Nodes.AddNode(nil, Root, '', Timer, naAddChild);
  end;
  Result.ImageIndex := IMAGE_INDEX_TIMER;
  Result.SelectedIndex := IMAGE_INDEX_TIMER;
end;

function TNetworkViewBuilder.BuildModuleNode(Nodes: TTreeNodes; Root: TTreeNode; Module: TModule): TTreeNode;
var
  Sibling: TTreeNode;
begin
  if Root = nil then
    Result := Nodes.AddObject(nil, '', Module)
  else
  begin
    Sibling := FindSiblingForNodeForModule(Root, Module);
    if Assigned(Sibling) then
      Result := Nodes.AddNode(nil, Sibling, '', Module, naInsert)
    else
      Result := Nodes.AddNode(nil, Root, '', Module, naAddChild);
  end;
  Result.ImageIndex := IMAGE_INDEX_MODULE;
  Result.SelectedIndex := IMAGE_INDEX_MODULE;
  AddAnalogInputsNodes(Nodes, Result, Module.AnalogInputs);
  AddDigitalInputsNodes(Nodes, Result, Module.DigitalInputs);
  AddDigitalOutputsNodes(Nodes, Result, Module.DigitalOutputs);
  AddRelaysNodes(Nodes, Result, Module.Relays);
  AddWiegandsNodes(Nodes, Result, Module.Wiegands);
  AddRS232sNodes(Nodes, Result, Module.RS232s);
  AddRS485sNodes(Nodes, Result, Module.RS485s);
  AddMotorsNodes(Nodes, Result, Module.Motors);
end;

function TNetworkViewBuilder.BuildAnalogInputNode(Nodes: TTreeNodes; Root: TTreeNode; AnalogInput: TAnalogInput): TTreeNode;
begin
  if Root = nil then
    Result := Nodes.AddObject(nil, '', AnalogInput)
  else
    Result := Nodes.AddChildObject(Root, '', AnalogInput);
  Result.ImageIndex := IMAGE_INDEX_ANALOGINPUT;
  Result.SelectedIndex := IMAGE_INDEX_ANALOGINPUT;
end;

function TNetworkViewBuilder.BuildDigitalInputNode(Nodes: TTreeNodes; Root: TTreeNode; DigitalInput: TDigitalInput): TTreeNode;
begin
  if Root = nil then
    Result := Nodes.AddObject(nil, '', DigitalInput)
  else
    Result := Nodes.AddChildObject(Root, '', DigitalInput);
  Result.ImageIndex := IMAGE_INDEX_DIGITALINPUT;
  Result.SelectedIndex := IMAGE_INDEX_DIGITALINPUT;
end;

function TNetworkViewBuilder.BuildDigitalOutputNode(Nodes: TTreeNodes; Root: TTreeNode; DigitalOutput: TDigitalOutput): TTreeNode;
begin
  if Root = nil then
    Result := Nodes.AddObject(nil, '', DigitalOutput)
  else
    Result := Nodes.AddChildObject(Root, '', DigitalOutput);
  Result.ImageIndex := IMAGE_INDEX_DIGITALOUTPUT;
  Result.SelectedIndex := IMAGE_INDEX_DIGITALOUTPUT;
end;

function TNetworkViewBuilder.BuildRelayNode(Nodes: TTreeNodes; Root: TTreeNode; Relay: TRelay): TTreeNode;
begin
  if Root = nil then
    Result := Nodes.AddObject(nil, '', Relay)
  else
    Result := Nodes.AddChildObject(Root, '', Relay);
  Result.ImageIndex := IMAGE_INDEX_RELAY;
  Result.SelectedIndex := IMAGE_INDEX_RELAY;
end;

function TNetworkViewBuilder.BuildWiegandNode(Nodes: TTreeNodes; Root: TTreeNode; Wiegand: TWiegand): TTreeNode;
begin
  if Root = nil then
    Result := Nodes.AddObject(nil, '', Wiegand)
  else
    Result := Nodes.AddChildObject(Root, '', Wiegand);
  Result.ImageIndex := IMAGE_INDEX_WIEGAND;
  Result.SelectedIndex := IMAGE_INDEX_WIEGAND;
end;

function TNetworkViewBuilder.BuildRS232Node(Nodes: TTreeNodes; Root: TTreeNode; RS232: TRS232): TTreeNode;
begin
  if Root = nil then
    Result := Nodes.AddObject(nil, '', RS232)
  else
    Result := Nodes.AddChildObject(Root, '', RS232);
  Result.ImageIndex := IMAGE_INDEX_RS232;
  Result.SelectedIndex := IMAGE_INDEX_RS232;
end;

function TNetworkViewBuilder.BuildRS485Node(Nodes: TTreeNodes; Root: TTreeNode; RS485: TRS485): TTreeNode;
begin
  if Root = nil then
    Result := Nodes.AddObject(nil, '', RS485)
  else
    Result := Nodes.AddChildObject(Root, '', RS485);
  Result.ImageIndex := IMAGE_INDEX_RS485;
  Result.SelectedIndex := IMAGE_INDEX_RS485;
end;

function TNetworkViewBuilder.BuildMotorNode(Nodes: TTreeNodes; Root: TTreeNode; Motor: TMotor): TTreeNode;
begin
  if Root = nil then
    Result := Nodes.AddObject(nil, '', Motor)
  else
    Result := Nodes.AddChildObject(Root, '', Motor);
  Result.ImageIndex := IMAGE_INDEX_MOTOR;
  Result.SelectedIndex := IMAGE_INDEX_MOTOR;
end;

function TNetworkViewBuilder.BuildFolderNode(Nodes: TTreeNodes; Root: TTreeNode; Folder: TFolder): TTreeNode;
begin
  if Root = nil then
    Result := Nodes.AddObject(nil, '', Folder)
  else
    Result := Nodes.AddChildObject(Root, '', Folder);
  Result.ImageIndex := IMAGE_INDEX_FOLDER_CLOSE;
  Result.SelectedIndex := IMAGE_INDEX_FOLDER_CLOSE;

  AddTimersNodes(Nodes, Result, Folder.Timers, Folder.D.Id);
  AddModulesNodes(Nodes, Result, Folder.Modules, Folder.D.Id);
end;

procedure TNetworkViewBuilder.BuildList(List: TStrings);
var
  I, J, K: Integer;
begin
  List.BeginUpdate;
  try
    List.Clear;
    for I := 0 to FConfig.Servers.Count - 1 do
    begin
      List.AddObject('', FConfig.Servers[I]);
      for J := 0 to FConfig.Servers[I].Timers.Count - 1 do
        List.AddObject('', FConfig.Servers[I].Timers[J]);
      for J := 0 to FConfig.Servers[I].Modules.Count - 1 do
      begin
        List.AddObject('', FConfig.Servers[I].Modules[J]);
        for K := 0 to FConfig.Servers[I].Modules[J].AnalogInputs.Count - 1 do
          List.AddObject('', FConfig.Servers[I].Modules[J].AnalogInputs[K]);
        for K := 0 to FConfig.Servers[I].Modules[J].DigitalInputs.Count - 1 do
          List.AddObject('', FConfig.Servers[I].Modules[J].DigitalInputs[K]);
        for K := 0 to FConfig.Servers[I].Modules[J].DigitalOutputs.Count - 1 do
          List.AddObject('', FConfig.Servers[I].Modules[J].DigitalOutputs[K]);
        for K := 0 to FConfig.Servers[I].Modules[J].Relays.Count - 1 do
          List.AddObject('', FConfig.Servers[I].Modules[J].Relays[K]);
        for K := 0 to FConfig.Servers[I].Modules[J].Wiegands.Count - 1 do
          List.AddObject('', FConfig.Servers[I].Modules[J].Wiegands[K]);
        for K := 0 to FConfig.Servers[I].Modules[J].RS232s.Count - 1 do
          List.AddObject('', FConfig.Servers[I].Modules[J].RS232s[K]);
        for K := 0 to FConfig.Servers[I].Modules[J].RS485s.Count - 1 do
          List.AddObject('', FConfig.Servers[I].Modules[J].RS485s[K]);
        for K := 0 to FConfig.Servers[I].Modules[J].Motors.Count - 1 do
          List.AddObject('', FConfig.Servers[I].Modules[J].Motors[K]);
      end;
    end;
  finally
    List.EndUpdate;
  end;
end;

end.

