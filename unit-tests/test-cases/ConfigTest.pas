unit ConfigTest;

interface

uses
  Classes, SysUtils, TestFramework,
  Config, ConfigFile;

type
  TConfigTest = class (TTestCase)
  private
    FConfig: TConfig;
    procedure CreateLooseObjects;
    procedure FillStreamWithConfigFile(S: TStream);
  protected
    procedure Setup; override;
    procedure Teardown; override;
    property Config: TConfig read FConfig;
  published
    procedure TestConfigEmpty;
    procedure TestUpdateLists;
    procedure TestLoadStream;
    procedure TestSaveStream;
    procedure TestRecreateItems;
  end;

implementation

{ TConfigTest }

{ Private declarations }

procedure TConfigTest.CreateLooseObjects;
var
  Server: TServer;
  Folder: TFolder;
  Module: TModule;
  Timer: TTimer;
begin
  Config.Clear;
  Server := TServer.Create(Config, nil, Config.ConfigFile.AddServerData);
  Config.Servers.Add(Server);
  Module := TModule.Create(Config, Server, Config.ConfigFile.AddModuleData);
  Module.D.ParentId := Server.D.Id;
  Timer := TTimer.Create(Config, Server, Config.ConfigFile.AddTimerData);
  Timer.D.ParentId := Server.D.Id;
  Folder := TFolder.Create(Config, Server, Config.ConfigFile.AddFolderData);
  Folder.D.ServerId := Server.D.Id;
  Module := TModule.Create(Config, Server, Config.ConfigFile.AddModuleData);
  Module.D.ParentId := Server.D.Id;
  Module.D.FolderId := Folder.D.Id;
  Timer := TTimer.Create(Config, Server, Config.ConfigFile.AddTimerData);
  Timer.D.ParentId := Server.D.Id;
  Timer.D.FolderId := Folder.D.Id;
end;

procedure TConfigTest.FillStreamWithConfigFile(S: TStream);
begin
  CreateLooseObjects;
  S.Size := 0;
  S.Position := 0;
  Config.ConfigFile.Save(S);
end;

{ Protected declarations }

procedure TConfigTest.Setup;
begin
  FConfig := TConfig.Create;
end;

procedure TConfigTest.Teardown;
begin
  FreeAndNil(FConfig);
end;

{ Published declarations }

procedure TConfigTest.TestConfigEmpty;
begin
  CheckEquals(2, Config.ConfigFile.Records.Count, 'Error: there should be only 2 records in Records list');
end;

procedure TConfigTest.TestUpdateLists;
begin
  CreateLooseObjects;
  Config.UpdateLists;
  CheckEquals(1, Config.Servers.Count);
  CheckEquals(2, Config.Servers[0].Modules.Count);
  CheckEquals(2, Config.Servers[0].Timers.Count);
  CheckEquals(1, Config.Servers[0].Folders.Count);
  CheckEquals(1, Config.Servers[0].Folders[0].Modules.Count);
  CheckEquals(1, Config.Servers[0].Folders[0].Timers.Count);
  Check(Config.Servers[0].Modules[0] <> Config.Servers[0].Modules[1], 'Error: the same module is at index 0 and 1');
  Check(Config.Servers[0].Timers[0] <> Config.Servers[0].Timers[1], 'Error: the same timer is at index 0 and 1');
end;

procedure TConfigTest.TestLoadStream;
var
  TmpStream: TStream;
begin
  TmpStream := TMemoryStream.Create;
  try
    FillStreamWithConfigFile(TmpStream);
    TmpStream.Position := 0;
    Config.LoadStream(TmpStream);
    CheckEquals(764, TmpStream.Position);
  finally
    TmpStream.Free;
  end;
end;

procedure TConfigTest.TestSaveStream;
var
  TmpStream: TStream;
begin
  TmpStream := TMemoryStream.Create;
  try
    FillStreamWithConfigFile(TmpStream);
    CheckEquals(764, TmpStream.Position);
    CheckEquals(764, TmpStream.Size);
  finally
    TmpStream.Free;
  end;
end;

procedure TConfigTest.TestRecreateItems;
var
  TmpStream: TStream;
begin
  TmpStream := TMemoryStream.Create;
  try
    FillStreamWithConfigFile(TmpStream);
    TmpStream.Position := 0;
    Config.LoadStream(TmpStream);
  finally
    TmpStream.Free;
  end;
  CheckEquals(1, Config.Servers.Count);
  CheckEquals(2, Config.Servers[0].Modules.Count);
  CheckEquals(2, Config.Servers[0].Timers.Count);
  CheckEquals(1, Config.Servers[0].Folders.Count);
  CheckEquals(1, Config.Servers[0].Folders[0].Modules.Count);
  CheckEquals(1, Config.Servers[0].Folders[0].Timers.Count);
  Check(Config.Servers[0].Modules[0] <> Config.Servers[0].Modules[1], 'Error: the same module is at index 0 and 1');
  Check(Config.Servers[0].Timers[0] <> Config.Servers[0].Timers[1], 'Error: the same timer is at index 0 and 1');
end;

initialization
  RegisterTest('', TConfigTest.Suite);

end.

