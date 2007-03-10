unit ViewBuildersTest;

interface

uses
  Classes, SysUtils, Forms, Controls, ComCtrls, TestFramework,
  Config, ConfigFactory, ViewBuilders;

type
  TViewBuildersTest = class (TTestCase)
  private
    FConfig: TConfig;
    FServer: TServer;
    FForm: TForm;
    FTreeView: TTreeView;
    FViewBuilder: TNetworkViewBuilder;
    procedure CreateTestConfig;
    procedure CreateTestTreeView;
    procedure TreeViewCustomDrawItem(Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure CreateViewBuilder;
  protected
    procedure Setup; override;
    procedure Teardown; override;
    property Server: TServer read FServer;
    property TreeView: TTreeView read FTreeView;
    property ViewBuilder: TNetworkViewBuilder read FViewBuilder;
  published
    procedure TestBuildNodes;
    procedure TestBuildServerNode;
    procedure TestBuildTimerNodeDirect;
    procedure TestBuildTimerNodeInFolder;
    procedure TestBuildModuleNodeDirect;
    procedure TestBuildModuleNodeInFolder;
    procedure TestBuildAnalogInputNode;
    procedure TestBuildDigitalInputNode;
    procedure TestBuildDigitalOutputNode;
    procedure TestBuildRelayNode;
    procedure TestBuildWiegandNode;
    procedure TestBuildRS232Node;
    procedure TestBuildRS485Node;
    procedure TestBuildMotorNode;
    procedure TestBuildFolderNode;
  end;

implementation

{ TViewBuildersTest }

{ Private declarations }

procedure TViewBuildersTest.CreateTestConfig;
var
  Folder: TFolder;
  Module: TModule;
  Timer: TTimer;
begin
  FConfig := TConfig.Create;
  FServer := TConfigFactory.CreateServer(FConfig);
  TConfigFactory.CreateModule(Server);
  TConfigFactory.CreateTimer(Server);
  Folder := TConfigFactory.CreateFolder(Server);
  Module := TConfigFactory.CreateModule(Server);
  Module.D.FolderId := Folder.D.Id;
  Timer := TConfigFactory.CreateTimer(Server);
  Timer.D.FolderId := Folder.D.Id;
  FConfig.UpdateLists;
end;

procedure TViewBuildersTest.CreateTestTreeView;
begin
  FForm := TForm.Create(nil);
  FTreeView := TTreeView.Create(FForm);
  FForm.InsertControl(TreeView);
  TreeView.Align := alClient;
  TreeView.OnCustomDrawItem := TreeViewCustomDrawItem;
end;

procedure TViewBuildersTest.TreeViewCustomDrawItem(Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  Node.Text := TObject(Node.Data).ClassName;
end;

procedure TViewBuildersTest.CreateViewBuilder;
begin
  FViewBuilder := TNetworkViewBuilder.Create(FConfig);
end;

{ Protected declarations }

procedure TViewBuildersTest.Setup;
begin
  CreateTestConfig;
  CreateTestTreeView;
  CreateViewBuilder;
end;

procedure TViewBuildersTest.Teardown;
begin
  FreeAndNil(FViewBuilder);
  FreeAndNil(FForm);
  FreeAndNil(FConfig);
  FServer := nil;
end;

{ Published declarations }

procedure TViewBuildersTest.TestBuildNodes;
begin
  ViewBuilder.BuildNodes(TreeView.Items);
  CheckEquals(56, TreeView.Items.Count);
  CheckEquals(3, TreeView.Items[0].Count);
  CheckEquals(2, TreeView.Items[1].Count);
  CheckEquals(0, TreeView.Items[2].Count);
  CheckEquals(25, TreeView.Items[3].Count);
  CheckEquals(0, TreeView.Items[27].Count);
  CheckEquals(25, TreeView.Items[30].Count);
end;

procedure TViewBuildersTest.TestBuildServerNode;
var
  Node: TTreeNode;
begin
  Node := ViewBuilder.BuildServerNode(TreeView.Items, nil, Server);
  CheckEquals(56, TreeView.Items.Count);
  CheckEquals(3, Node.Count);
  CheckEquals(2, Node.Item[0].Count);
  CheckEquals(0, Node.Item[0].Item[0].Count);
  CheckEquals(25, Node.Item[0].Item[1].Count);
  CheckEquals(0, Node.Item[1].Count);
  CheckEquals(25, Node.Item[2].Count);
end;

procedure TViewBuildersTest.TestBuildTimerNodeDirect;
var
  Node: TTreeNode;
begin
  Node := ViewBuilder.BuildTimerNode(TreeView.Items, nil, Server.Timers[1]);
  CheckEquals(1, TreeView.Items.Count);
  CheckEquals(0, Node.Count);
end;

procedure TViewBuildersTest.TestBuildTimerNodeInFolder;
var
  Node: TTreeNode;
begin
  Node := ViewBuilder.BuildFolderNode(TreeView.Items, nil, Server.Folders[0]);
  CheckEquals(28, TreeView.Items.Count);
  CheckEquals(2, Node.Count);
  CheckEquals(0, Node.Item[0].Count);
end;

procedure TViewBuildersTest.TestBuildModuleNodeDirect;
var
  Node: TTreeNode;
begin
  Node := ViewBuilder.BuildModuleNode(TreeView.Items, nil, Server.Modules[1]);
  CheckEquals(26, TreeView.Items.Count);
  CheckEquals(25, Node.Count);
end;

procedure TViewBuildersTest.TestBuildModuleNodeInFolder;
var
  Node: TTreeNode;
begin
  Node := ViewBuilder.BuildFolderNode(TreeView.Items, nil, Server.Folders[0]);
  CheckEquals(28, TreeView.Items.Count);
  CheckEquals(2, Node.Count);
  CheckEquals(25, Node.Item[1].Count);
end;

procedure TViewBuildersTest.TestBuildAnalogInputNode;
var
  Node: TTreeNode;
begin
  Node := ViewBuilder.BuildAnalogInputNode(TreeView.Items, nil, Server.Modules[0].AnalogInputs[0]);
  CheckEquals(1, TreeView.Items.Count);
  CheckEquals(0, Node.Count);
end;

procedure TViewBuildersTest.TestBuildDigitalInputNode;
var
  Node: TTreeNode;
begin
  Node := ViewBuilder.BuildDigitalInputNode(TreeView.Items, nil, Server.Modules[0].DigitalInputs[0]);
  CheckEquals(1, TreeView.Items.Count);
  CheckEquals(0, Node.Count);
end;

procedure TViewBuildersTest.TestBuildDigitalOutputNode;
var
  Node: TTreeNode;
begin
  Node := ViewBuilder.BuildDigitalOutputNode(TreeView.Items, nil, Server.Modules[0].DigitalOutputs[0]);
  CheckEquals(1, TreeView.Items.Count);
  CheckEquals(0, Node.Count);
end;

procedure TViewBuildersTest.TestBuildRelayNode;
var
  Node: TTreeNode;
begin
  Node := ViewBuilder.BuildRelayNode(TreeView.Items, nil, Server.Modules[0].Relays[0]);
  CheckEquals(1, TreeView.Items.Count);
  CheckEquals(0, Node.Count);
end;

procedure TViewBuildersTest.TestBuildWiegandNode;
var
  Node: TTreeNode;
begin
  Node := ViewBuilder.BuildWiegandNode(TreeView.Items, nil, Server.Modules[0].Wiegands[0]);
  CheckEquals(1, TreeView.Items.Count);
  CheckEquals(0, Node.Count);
end;

procedure TViewBuildersTest.TestBuildRS232Node;
var
  Node: TTreeNode;
begin
  Node := ViewBuilder.BuildRS232Node(TreeView.Items, nil, Server.Modules[0].RS232s[0]);
  CheckEquals(1, TreeView.Items.Count);
  CheckEquals(0, Node.Count);
end;

procedure TViewBuildersTest.TestBuildRS485Node;
var
  Node: TTreeNode;
begin
  Node := ViewBuilder.BuildRS485Node(TreeView.Items, nil, Server.Modules[0].RS485s[0]);
  CheckEquals(1, TreeView.Items.Count);
  CheckEquals(0, Node.Count);
end;

procedure TViewBuildersTest.TestBuildMotorNode;
var
  Node: TTreeNode;
begin
  Node := ViewBuilder.BuildMotorNode(TreeView.Items, nil, Server.Modules[0].Motors[0]);
  CheckEquals(1, TreeView.Items.Count);
  CheckEquals(0, Node.Count);
end;

procedure TViewBuildersTest.TestBuildFolderNode;
var
  Node: TTreeNode;
begin
  Node := ViewBuilder.BuildFolderNode(TreeView.Items, nil, Server.Folders[0]);
  CheckEquals(28, TreeView.Items.Count);
  CheckEquals(2, Node.Count);
  CheckEquals(0, Node.Item[0].Count);
  CheckEquals(25, Node.Item[1].Count);
end;

initialization
  RegisterTest('', TViewBuildersTest.Suite);

end.

