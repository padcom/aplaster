// ----------------------------------------------------------------------------
// file: FormMain.pas - a part of AplaSter system
// date: 2005-09-08
// auth: Matthias Hryniszak
// desc: main form for the configuration editor
// ----------------------------------------------------------------------------

unit FormMain;

{$IFOPT D+}
  {$DEFINE DEBUG}
{$ENDIF}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, ComCtrls, ImgList, StdCtrls, ExtCtrls, Grids, Menus,
  ToolWin, Editors,
  SynEdit, SynEditHighlighter, SynHighlighterPas, SynEditPlugins, SynMacroRecorder, SynEditTypes,
  uPSComponent, uPSCompiler,
  PropertyEditor,
  Config, ConfigFile, ConfigFactory, ConfigManipulator, ViewBuilders, ViewUtils, ViewUtilsForCfgEd;

const
  PAGE_STRUCTURE              = 0;
  PAGE_CODE                   = 1;

type
  TFrmMain = class(TForm)
    ImlIcons: TImageList;
    Actions: TActionList;
    Toolbar: TToolBar;
    StatusBar: TStatusBar;
    PnlInspector: TPanel;
    TbcNetworkItem: TTabControl;
    PpeNetworkItem: TPropertyEditor;
    CbbNetworkItem: TComboBox;
    SplWorkspace: TSplitter;
    HltPascal: TSynPasSyn;
    PgcWorkspace: TPageControl;
    TbsConfigEditor: TTabSheet;
    TrvNetworkStructure: TTreeView;
    TbsCodeEditor: TTabSheet;
    SplCodeEditor: TSplitter;
    EdtCode: TSynEdit;
    EdtCodeMacroRecorder: TSynMacroRecorder;
    LbxMessages: TListBox;
    MainMenu: TMainMenu;
    MnuFile: TMenuItem;
    MniExit: TMenuItem;
    MnuServer: TPopupMenu;
    MnuModule: TPopupMenu;
    MnuTimer: TPopupMenu;
    ActFileNew: TAction;
    ActFileOpen: TAction;
    ActFileSave: TAction;
    ActFileSaveAs: TAction;
    ActFileExit: TAction;
    MniFileNew: TMenuItem;
    MniFileOpen: TMenuItem;
    MniFileSave: TMenuItem;
    MniFileSaveAs: TMenuItem;
    N1: TMenuItem;
    BtnNewConfig: TToolButton;
    BtnSeparator1: TToolButton;
    BtnOpenConfig: TToolButton;
    BtnSave: TToolButton;
    ActEditAddServer: TAction;
    ActEditAddTimer: TAction;
    ActEditAddModule: TAction;
    ActEditAddFolder: TAction;
    ActEditDeleteCurrent: TAction;
    MnuEdit: TMenuItem;
    MniEditAddServer: TMenuItem;
    MniEditAddTimer: TMenuItem;
    MniEditAddModule: TMenuItem;
    N2: TMenuItem;
    MniDeleteCurrent: TMenuItem;
    ActHelpAbout: TAction;
    MnuHelp: TMenuItem;
    MniHelpAbout: TMenuItem;
    BtnSeparator2: TToolButton;
    BtnAddServer: TToolButton;
    BtnAddTimer: TToolButton;
    BtnAddModule: TToolButton;
    BtnSeparator3: TToolButton;
    BtnDeleteCurrent: TToolButton;
    BtnSeparator4: TToolButton;
    BtnAbout: TToolButton;
    MniServerAddTimer: TMenuItem;
    MniServerAddModule: TMenuItem;
    N3: TMenuItem;
    MniServerDelete: TMenuItem;
    MniModuleDelete: TMenuItem;
    MniTimerDelete: TMenuItem;
    ActFileCommitConfig: TAction;
    ActFileRetrieveConfig: TAction;
    N4: TMenuItem;
    MniFileCommitConfig: TMenuItem;
    MniFileRetriveConfig: TMenuItem;
    MnuTools: TMenuItem;
    MniFunctionList: TMenuItem;
    ActFuncProcList: TAction;
    MnuCode: TPopupMenu;
    MniCodeCut: TMenuItem;
    MniCodeCopy: TMenuItem;
    MniCodePaste: TMenuItem;
    N5: TMenuItem;
    MniCodeSelectAll: TMenuItem;
    ActCodeCut: TAction;
    ActCodeCopy: TAction;
    ActCodePaste: TAction;
    ActCodeSelectAll: TAction;
    BtntAddFolder: TToolButton;
    MnuFolder: TPopupMenu;
    MniFolderDelete: TMenuItem;
    PascalScript: TPSScript;
    ActCodeCompile: TAction;
    MniCodeCompile: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormResize(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TrvNetworkStructureChange(Sender: TObject; Node: TTreeNode);
    procedure TrvNetworkStructureCustomDrawItem(Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure CbbNetworkItemChange(Sender: TObject);
    procedure CbbNetworkItemDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure TbcNetworkItemChange(Sender: TObject);
    procedure PpeNetworkItemGetProperties(Sender, Data: TObject; Group: Word; var Properties: TProperties);
    procedure PpeNetworkItemGetPropertyValue(Sender, Data: TObject; Group: Word; Prop: TProperty; var Value: WideString);
    procedure PpeNetworkItemSetPropertyValue(Sender, Data: TObject; Group: Word; Prop: TProperty; Value: WideString);
    procedure PpeNetworkItemPropertyButtonClick(Sender, Data: TObject; Group: Word; Prop: TProperty; ButtonId: Cardinal);
    procedure PpeNetworkItemUpdateListBoxContent(Sender, Data: TObject; Group: Word; Prop: TProperty; Items: TStrings; var ItemIndex: Integer);
    procedure PpeNetworkItemPropertySelected(Sender, Data: TObject; Group: Word; Prop: TProperty);
    procedure PpeNetworkItemEditorDblClick(Sender, Data: TObject; Group: Word; Prop: TProperty);
    procedure EdtCodeChange(Sender: TObject);
    procedure EdtCodeKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EdtCodeStatusChange(Sender: TObject; Changes: TSynStatusChanges);
    procedure EdtCodeMacroRecorderStateChange(Sender: TObject);
    procedure ActFileNewExecute(Sender: TObject);
    procedure ActFileOpenExecute(Sender: TObject);
    procedure ActFileSaveExecute(Sender: TObject);
    procedure ActFileSaveUpdate(Sender: TObject);
    procedure ActFileSaveAsExecute(Sender: TObject);
    procedure ActFileExitExecute(Sender: TObject);
    procedure ActEditAddServerExecute(Sender: TObject);
    procedure ActEditAddServerUpdate(Sender: TObject);
    procedure ActEditAddTimerExecute(Sender: TObject);
    procedure ActEditAddTimerUpdate(Sender: TObject);
    procedure ActEditAddModuleExecute(Sender: TObject);
    procedure ActEditAddModuleUpdate(Sender: TObject);
    procedure ActEditDeleteCurrentExecute(Sender: TObject);
    procedure ActEditDeleteCurrentUpdate(Sender: TObject);
    procedure ActHelpAboutExecute(Sender: TObject);
    procedure ActFileCommitConfigExecute(Sender: TObject);
    procedure ActFileRetrieveConfigExecute(Sender: TObject);
    procedure ActCodeCutExecute(Sender: TObject);
    procedure ActCodeCutUpdate(Sender: TObject);
    procedure ActCodeCopyExecute(Sender: TObject);
    procedure ActCodeCopyUpdate(Sender: TObject);
    procedure ActCodePasteExecute(Sender: TObject);
    procedure ActCodePasteUpdate(Sender: TObject);
    procedure ActCodeSelectAllExecute(Sender: TObject);
    procedure ActEditAddFolderExecute(Sender: TObject);
    procedure ActEditAddFolderUpdate(Sender: TObject);
    procedure ActFuncProcListExecute(Sender: TObject);
    procedure ActFuncProcListUpdate(Sender: TObject);
    procedure TrvNetworkStructureMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure TrvNetworkStructureStartDrag(Sender: TObject; var DragObject: TDragObject);
    procedure TrvNetworkStructureDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure TrvNetworkStructureDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure ActCodeCompileExecute(Sender: TObject);
    procedure LbxMessagesDblClick(Sender: TObject);
    procedure LbxMessagesKeyPress(Sender: TObject; var Key: Char);
    procedure ActFileCommitConfigUpdate(Sender: TObject);
  private
    { Private declarations }
    FConfig: TConfig;
    FConfigTreeDisplayer: TConfigTreeDisplayer;
    FChanging: Boolean;
    FEditors: TEditorList;
    function CheckFileSaved: Boolean;
    function SelectPopupMenu(Node: TTreeNode): TPopupMenu;
    function SelectedServer: TServer;
    procedure AssignLanguage;
    procedure DisplayWindowTitle;
    procedure DisplayNetworkStructure;
    procedure ShowHint(Sender: TObject);
    procedure InitializeScripting;
    procedure DeleteItemFromComboBox(Item: Pointer);
    procedure DeleteItemFromTreeView(Item: Pointer);
    procedure DeleteItemsFromComboBox(List: TList);
    procedure DeleteModule(Module: TModule);
    procedure DeleteFolder(Folder: TFolder);
    procedure DeleteTimer(Timer: TTimer);
    procedure DeleteServer(Server: TServer);
    function ConfirmServerDeletion(Server: TServer): Boolean;
    function ConfirmTimerDeletion(Timer: TTimer): Boolean;
    function ConfirmFolderDeletion(Folder: TFolder): Boolean;
    function ConfirmModuleDeletion(Module: TModule): Boolean;
    procedure CreateConfigurationObject;
    procedure CreatePropertyEditors;
    procedure DestroyPropertyEditors;
    procedure CreateConfigTreeDisplayer;
  protected
    property Config: TConfig read FConfig;
  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;

implementation

uses
  PxDataFile,
  Resources, Icons, Storage, Options,
  FormFunctionList, PasUtils,
  ScriptObjects, uPSI_BaseTypes, uPSI_Config, uPSI_ConfigFile;

{$R *.dfm}

{ Private declarations }

function TFrmMain.CheckFileSaved: Boolean;
begin
  Result := True;
  if FConfig.ConfigFile.Modified then
    case MessageBox(Handle, PChar(SConfigurationHasBeenChangedSaveChanges), PChar(SQuestion), MB_ICONQUESTION or MB_YESNOCANCEL) of
      ID_YES:
      begin
        ActFileSave.Execute;
        if FConfig.ConfigFile.Modified then
          Result := False;
      end;
      ID_CANCEL:
        Result := False;
    end;
end;

function TFrmMain.SelectPopupMenu(Node: TTreeNode): TPopupMenu;
begin
  if not (Assigned(Node) and Assigned(Node.Data)) then
    Result := nil
  else if TObject(Node.Data) is TServer then
    Result := MnuServer
  else if TObject(Node.Data) is TTimer then
    Result := MnuTimer
  else if TObject(Node.Data) is TModule then
    Result := MnuModule
  else if TObject(Node.Data) is TFolder then
    Result := MnuFolder
  else
    Result := nil;
end;

function TFrmMain.SelectedServer: TServer;
var
  Node: TTreeNode;
begin
  Result := nil;
  Node := TrvNetworkStructure.Selected;
  while Assigned(Node) and Assigned(Node.Data) do
  begin
    if Tobject(Node.Data) is TServer then
    begin
      Result := Node.Data;
      Break;
    end
    else Node := Node.Parent;
  end;
end;

procedure TFrmMain.AssignLanguage;
begin
  Caption := SConfigurationEditor;
  Application.Title := SConfigurationEditor;
  TbcNetworkItem.Tabs[0] := SProperties;
  TbcNetworkItem.Tabs[1] := SEvents;
  TbsConfigEditor.Caption := SConfiguration;
  TbsCodeEditor.Caption := SCode;

  MnuFile.Caption := SFile;
  ActFileNew.Caption := SNew;
  ActFileNew.Hint := SNewHint;
  ActFileOpen.Caption := SOpen;
  ActFileOpen.Hint := SOpenHint;
  ActFileSave.Caption := SSave;
  ActFileSave.Hint := SSaveHint;
  ActFileSaveAs.Caption := SSaveAs;
  ActFileSaveAs.Hint := SSaveAsHint;
  ActFileCommitConfig.Caption := SCommitConfiguration;
  ActFileCommitConfig.Hint := SCommitConfigurationHint;
  ActFileRetrieveConfig.Caption := SRetriveCurrentConfiguration;
  ActFileRetrieveConfig.Hint := SRetriveCurrentConfigurationHint;
  ActFileExit.Caption := SExit;
  ActFileExit.Hint := SExitHint;

  MnuEdit.Caption := SEdit;
  ActEditAddServer.Caption := SAddServer;
  ActEditAddServer.Hint := SAddServerHint;
  ActEditAddTimer.Caption := SAddTimer;
  ActEditAddTimer.Hint := SAddTimerHint;
  ActEditAddModule.Caption := SAddModule;
  ActEditAddModule.Hint := SAddModuleHint;
  ActEditDeleteCurrent.Caption := SDeleteSelectedItem;
  ActEditDeleteCurrent.Hint := SDeleteSelectedItemHint;

  MnuTools.Caption := STools;
  MnuTools.Hint := SToolsHint;
  ActFuncProcList.Caption := SFunctionsAndProcedures;
  ActFuncProcList.Hint := SFunctionsAndProceduresList;
  ActCodeCompile.Caption := SCompileScript;

  MnuHelp.Caption := SHelp;
  ActHelpAbout.Caption := SAbout;
  ActHelpAbout.Hint := SAboutHint;

  ActCodeCut.Caption := SCut;
  ActCodeCopy.Caption := SCopy;
  ActCodePaste.Caption := SPaste;
  ActCodeSelectAll.Caption := SSelectAll;
end;

procedure TFrmMain.DisplayNetworkStructure;
var
  Builder: TNetworkViewBuilder;
begin
  DisplayWindowTitle;

  FChanging := True;
  try
    Builder := TNetworkViewBuilder.Create(FConfig);
    try
      Builder.BuildNodes(TrvNetworkStructure.Items);
      Builder.BuildList(CbbNetworkItem.Items);
    finally
      Builder.Free;
    end;
  finally
    FChanging := False;
  end;

  if TrvNetworkStructure.Items.Count > 0 then
    TrvNetworkStructure.Selected := TrvNetworkStructure.Items[0]
  else
  begin
    TrvNetworkStructure.Selected := nil;
    PpeNetworkItem.Data := nil;
  end;
  EdtCode.Text := FConfig.ConfigFile.GlobalData.Code;
end;

procedure TFrmMain.DisplayWindowTitle;
begin
  if FConfig.ConfigFile.FileName <> '' then
    Caption := SConfigurationEditor + ' [' + FConfig.ConfigFile.FileName + ']'
  else
    Caption := SConfigurationEditor;
end;

procedure TFrmMain.ShowHint(Sender: TObject);
begin
  StatusBar.SimpleText := Application.Hint;
end;

procedure TFrmMain.InitializeScripting;
begin
  TPSPluginItem(PascalScript.Plugins.Add).Plugin := TPSImport_BaseTypes.Create(Self);
  TPSPluginItem(PascalScript.Plugins.Add).Plugin := TPSImport_ConfigFile.Create(Self);
  TPSPluginItem(PascalScript.Plugins.Add).Plugin := TPSImport_Config.Create(Self);
  TPSPluginItem(PascalScript.Plugins.Add).Plugin := TPSScriptObjects.Create(Self);
end;

procedure TFrmMain.DeleteItemFromComboBox(Item: Pointer);
var
  I: Integer;
begin
  CbbNetworkItem.Items.BeginUpdate;
  try
    for I := 0 to CbbNetworkItem.Items.Count - 1 do
      if CbbNetworkItem.Items.Objects[I] = Item then
      begin
        CbbNetworkItem.Items.Delete(I);
        Break;
      end;
  finally
    CbbNetworkItem.Items.EndUpdate;
  end;
end;

procedure TFrmMain.DeleteItemFromTreeView(Item: Pointer);
var
  I: Integer;
begin
  TrvNetworkStructure.Items.BeginUpdate;
  try
    for I := 0 to TrvNetworkStructure.Items.Count - 1 do
      if TrvNetworkStructure.Items[I].Data = Item then
      begin
        TrvNetworkStructure.Selected := TrvNetworkStructure.Items[I].Parent;
        TrvNetworkStructure.Items.Delete(TrvNetworkStructure.Items[I]);
        Break;
      end;
  finally
    TrvNetworkStructure.Items.EndUpdate;
  end;
end;

procedure TFrmMain.DeleteItemsFromComboBox(List: TList);
var
  I, J: Integer;
begin
  for I := 0 to List.Count - 1 do
    for J := 0 to CbbNetworkItem.Items.Count - 1 do
      if List[I] = CbbNetworkItem.Items.Objects[J] then
      begin
        CbbNetworkItem.Items.Delete(J);
        Break;
      end;
end;

procedure TFrmMain.DeleteModule(Module: TModule);
begin
  CbbNetworkItem.Items.BeginUpdate;
  try
    DeleteItemsFromComboBox(Module.AnalogInputs);
    DeleteItemsFromComboBox(Module.DigitalInputs);
    DeleteItemsFromComboBox(Module.DigitalOutputs);
    DeleteItemsFromComboBox(Module.Relays);
    DeleteItemsFromComboBox(Module.Wiegands);
    DeleteItemsFromComboBox(Module.RS232s);
    DeleteItemsFromComboBox(Module.RS485s);
    DeleteItemsFromComboBox(Module.Motors);
    DeleteItemFromComboBox(Module);
  finally
    CbbNetworkItem.Items.EndUpdate;
  end;
  DeleteItemFromTreeView(Module);
end;

procedure TFrmMain.DeleteFolder(Folder: TFolder);
var
  Server: TServer;
  I: Integer;
begin
  Server := TFolder(PpeNetworkItem.Data).Server;
  TConfigManipulator.Instance(FConfig).DeleteFolder(PpeNetworkItem.Data as TFolder);
  DisplayNetworkStructure;
  for I := 0 to TrvNetworkStructure.Items.Count - 1 do
    if TrvNetworkStructure.Items[I].Data = Server then
    begin
      TrvNetworkStructure.Selected := TrvNetworkStructure.Items[I];
      TrvNetworkStructure.Selected.Expand(False);
      Exit; // no extra processing needed here
    end;
end;

procedure TFrmMain.DeleteTimer(Timer: TTimer);
begin
  DeleteItemFromComboBox(Timer);
  DeleteItemFromTreeView(Timer);
end;

procedure TFrmMain.DeleteServer(Server: TServer);
var
  I: Integer;
begin
  for I := 0 to Server.Modules.Count - 1 do
    DeleteModule(Server.Modules[I]);
  DeleteItemsFromComboBox(Server.Modules);
  DeleteItemsFromComboBox(Server.Timers);
  DeleteItemsFromComboBox(Server.Folders);
  DeleteItemFromComboBox(Server);
  DeleteItemFromTreeView(Server);
end;

function TFrmMain.ConfirmServerDeletion(Server: TServer): Boolean;
begin
  Result := MessageBox(Handle,
    PChar(SAreYouSureYouWantToDeleteThisServerAndAllItsSubcomponents),
    PChar(SConfirmation),
    MB_ICONQUESTION or MB_YESNO or MB_DEFBUTTON2) = ID_YES;
end;

function TFrmMain.ConfirmTimerDeletion(Timer: TTimer): Boolean;
begin
  Result := MessageBox(Handle,
    PChar(SAreYouSureYouWantToDeleteThisTimer),
    PChar(SConfirmation),
    MB_ICONQUESTION or MB_YESNO or MB_DEFBUTTON2) = ID_YES;
end;

function TFrmMain.ConfirmFolderDeletion(Folder: TFolder): Boolean;
begin
  Result := MessageBox(Handle,
    PChar(SAreYouSureYouWantToDeleteThisFolder),
    PChar(SConfirmation),
    MB_ICONQUESTION or MB_YESNO or MB_DEFBUTTON2) = ID_YES;
end;

function TFrmMain.ConfirmModuleDeletion(Module: TModule): Boolean;
begin
  Result := MessageBox(Handle,
    PChar(SAreYouSureYouWantToDeleteThisModule),
    PChar(SConfirmation),
    MB_ICONQUESTION or MB_YESNO or MB_DEFBUTTON2) = ID_YES;
end;

procedure TFrmMain.CreateConfigurationObject;
begin
  FConfig := TConfig.Create;
  if (TOptions.Instance.ConfigFileName <> '') and FileExists(TOptions.Instance.ConfigFileName) then
    try
      FConfig.LoadFile(TOptions.Instance.ConfigFileName);
      DisplayWindowTitle;
    except
      FConfig.Clear;
    end
  else
    FConfig.ConfigFile.Modified := False;
end;

procedure TFrmMain.CreatePropertyEditors;
begin
  FEditors := TEditorList.Create;
  FEditors.RegisterEditor(TServer, TServerEditor.Create(FConfig, PpeNetworkItem, EdtCode));
  FEditors.RegisterEditor(TModule, TModuleEditor.Create(FConfig, PpeNetworkItem, EdtCode));
  FEditors.RegisterEditor(TAnalogInput, TAnalogInputEditor.Create(FConfig, PpeNetworkItem, EdtCode));
  FEditors.RegisterEditor(TDigitalInput, TDigitalInputEditor.Create(FConfig, PpeNetworkItem, EdtCode));
  FEditors.RegisterEditor(TDigitalOutput, TDigitalOutputEditor.Create(FConfig, PpeNetworkItem, EdtCode));
  FEditors.RegisterEditor(TRelay, TRelayEditor.Create(FConfig, PpeNetworkItem, EdtCode));
  FEditors.RegisterEditor(TWiegand, TWiegandEditor.Create(FConfig, PpeNetworkItem, EdtCode));
  FEditors.RegisterEditor(TRS232, TRS232Editor.Create(FConfig, PpeNetworkItem, EdtCode));
  FEditors.RegisterEditor(TRS485, TRS485Editor.Create(FConfig, PpeNetworkItem, EdtCode));
  FEditors.RegisterEditor(TMotor, TMotorEditor.Create(FConfig, PpeNetworkItem, EdtCode));
  FEditors.RegisterEditor(TTimer, TTimerEditor.Create(FConfig, PpeNetworkItem, EdtCode));
  FEditors.RegisterEditor(TFolder, TFolderEditor.Create(FConfig, PpeNetworkItem, EdtCode));
end;

procedure TFrmMain.DestroyPropertyEditors;
var
  Editor: TEditor;
begin
  while FEditors.Count > 0 do
  begin
    Editor := FEditors[0];
    FEditors.UnregisterEditor(Editor);
    Editor.Free;
  end;
  FreeAndNil(FEditors);
end;

procedure TFrmMain.CreateConfigTreeDisplayer;
begin
  FConfigTreeDisplayer := TConfigTreeDisplayerForCfgEd.Create;
end;

{ Public declarations }

procedure TFrmMain.FormCreate(Sender: TObject);
begin
  AssignLanguage;
  InitializeScripting;

  Application.OnHint := ShowHint;

  CreateConfigurationObject;
  CreatePropertyEditors;
  CreateConfigTreeDisplayer;

  // make the configuration editor the active editor
  PgcWorkspace.ActivePageIndex := 0;
end;

procedure TFrmMain.FormDestroy(Sender: TObject);
begin
  DestroyPropertyEditors;
  FreeAndNil(FConfigTreeDisplayer);
  FreeAndNil(FConfig);
end;

procedure TFrmMain.FormShow(Sender: TObject);
begin
  DisplayNetworkStructure;
end;

procedure TFrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if FConfig.ConfigFile.Modified then
    case MessageBox(Handle, PChar(SConfigurationHasBeenChangedSaveChanges), PChar(SQuestion), MB_ICONQUESTION or MB_YESNOCANCEL) of
      ID_YES:
      begin
        ActFileSave.Execute;
        if FConfig.ConfigFile.Modified then
          CanClose := False;
      end;
      ID_CANCEL:
        CanClose := False;
    end;
end;

procedure TFrmMain.FormResize(Sender: TObject);
begin
//
end;

procedure TFrmMain.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_F11:
    begin
      // toggle between config tree, code editor, and property editor
      if Assigned(ActiveControl) and (ActiveControl.Parent = PpeNetworkItem) then
      begin
        case PgcWorkspace.ActivePageIndex of
          PAGE_STRUCTURE:
            TrvNetworkStructure.SetFocus;
          PAGE_CODE:
            EdtCode.SetFocus;
        end;
      end
      else
        PpeNetworkItem.SetFocus;
    end;
  end;
end;

procedure TFrmMain.TrvNetworkStructureChange(Sender: TObject; Node: TTreeNode);
var
  I: Integer;
begin
  TrvNetworkStructure.PopupMenu := SelectPopupMenu(Node);

  if FChanging then Exit;

  // find the same element in property editor's combo box
  FChanging := True;
  try
    CbbNetworkItem.ItemIndex := -1;
    if Assigned(Node) then
    begin
      PpeNetworkItem.Data := Node.Data;
      for I := 0 to CbbNetworkItem.Items.Count - 1 do
        if CbbNetworkItem.Items.Objects[I] = Node.Data then
        begin
          CbbNetworkItem.ItemIndex := I;
          Break;
        end;
    end
    else
      PpeNetworkItem.Data := nil;
  finally
    FChanging := False;
  end;
end;

procedure TFrmMain.TrvNetworkStructureCustomDrawItem(Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  if Node.Data = nil then
    Node.Text := 'nil'
  else
    Node.Text := FConfigTreeDisplayer.GetTitle(Node.Data);
end;

procedure TFrmMain.CbbNetworkItemChange(Sender: TObject);
var
  I: Integer;
begin
  if FChanging then Exit;

  // find the same element in configuration tree
  FChanging := True;
  try
    PpeNetworkItem.Data := CbbNetworkItem.Items.Objects[CbbNetworkItem.ItemIndex];
    TrvNetworkStructure.Selected := nil;
    for I := 0 to TrvNetworkStructure.Items.Count - 1 do
      if TrvNetworkStructure.Items[I].Data = CbbNetworkItem.Items.Objects[CbbNetworkItem.ItemIndex] then
      begin
        TrvNetworkStructure.Selected := TrvNetworkStructure.Items[I];
        TrvNetworkStructure.Selected.MakeVisible;
        Break;
      end;
  finally
    FChanging := False;
  end;
end;

procedure TFrmMain.CbbNetworkItemDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
  function GetDepth(Item: TConfigItem): Integer;
  begin
    Result := 1;
    if Item <> nil then
      Result := Result + GetDepth(Item.Parent);
  end;
var
  S: String;
begin
  with CbbNetworkItem do
  begin
    if Items.Objects[Index] = nil then
      S := 'nil'
    else
      S := FConfigTreeDisplayer.GetTitle(Items.Objects[Index] as TConfigItem);

    Canvas.FillRect(Rect);
    if odComboBoxEdit in State then
      Canvas.TextRect(Rect, Rect.Left + 3, Rect.Top + 1, S)
    else
      Canvas.TextRect(Rect, Rect.Left + (GetDepth(Items.Objects[Index] as TConfigItem) * 3), Rect.Top + 1, S);
  end;
end;

procedure TFrmMain.TbcNetworkItemChange(Sender: TObject);
begin
  PpeNetworkItem.Group := TbcNetworkItem.TabIndex;
end;

procedure TFrmMain.PpeNetworkItemGetProperties(Sender, Data: TObject; Group: Word; var Properties: TProperties);
var
  Editor: TEditor;
begin
  Editor := FEditors.ByClass[Data.ClassType];
  if Assigned(Editor) then
    Editor.GetProperties(Sender, Data, Group, Properties)
  else
    SetLength(Properties, 0);
end;

procedure TFrmMain.PpeNetworkItemGetPropertyValue(Sender, Data: TObject; Group: Word; Prop: TProperty; var Value: WideString);
var
  Editor: TEditor;
begin
  Editor := FEditors.ByClass[Data.ClassType];
  if Assigned(Editor) then
    Editor.GetPropertyValue(Sender, Data, Group, Prop, Value);
end;

procedure TFrmMain.PpeNetworkItemSetPropertyValue(Sender, Data: TObject; Group: Word; Prop: TProperty; Value: WideString);
var
  Editor: TEditor;
begin
  Editor := FEditors.ByClass[Data.ClassType];
  if Assigned(Editor) then
    Editor.SetPropertyValue(Sender, Data, Group, Prop, Value);

  FConfig.ConfigFile.Modified := True;
  TrvNetworkStructure.Invalidate;
  CbbNetworkItem.Invalidate;
end;

procedure TFrmMain.PpeNetworkItemPropertyButtonClick(Sender: TObject; Data: TObject; Group: Word; Prop: TProperty; ButtonId: Cardinal);
var
  Editor: TEditor;
begin
  Editor := FEditors.ByClass[Data.ClassType];
  if Assigned(Editor) then
    Editor.PropertyButtonClick(Sender, Data, Group, Prop, ButtonId);
end;

procedure TFrmMain.PpeNetworkItemUpdateListBoxContent(Sender, Data: TObject; Group: Word; Prop: TProperty; Items: TStrings; var ItemIndex: Integer);
var
  Editor: TEditor;
begin
  Editor := FEditors.ByClass[Data.ClassType];
  if Assigned(Editor) then
    Editor.UpdateListBoxContent(Sender, Data, Group, Prop, Items, ItemIndex);
end;

procedure TFrmMain.PpeNetworkItemEditorDblClick(Sender, Data: TObject; Group: Word; Prop: TProperty);
var
  Editor: TEditor;
begin
  Editor := FEditors.ByClass[Data.ClassType];
  if Assigned(Editor) then
    Editor.EditorDblClick(Sender, Data, Group, Prop);
end;

procedure TFrmMain.PpeNetworkItemPropertySelected(Sender, Data: TObject; Group: Word; Prop: TProperty);
begin
//
end;

procedure TFrmMain.EdtCodeChange(Sender: TObject);
begin
  FConfig.ConfigFile.GlobalData.Code := EdtCode.Text;
  FConfig.ConfigFile.GlobalData.Modified := True;
  FConfig.ConfigFile.Modified := True;
end;

procedure TFrmMain.EdtCodeKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
//
end;

procedure TFrmMain.EdtCodeStatusChange(Sender: TObject; Changes: TSynStatusChanges);
begin
  if EdtCodeMacroRecorder.State = msRecording then
    StatusBar.SimpleText := SRecordingMacro
  else
    StatusBar.SimpleText := Format(SEditorPosition, [EdtCode.CaretY, EdtCode.CaretX]);
end;

procedure TFrmMain.EdtCodeMacroRecorderStateChange(Sender: TObject);
begin
  if EdtCodeMacroRecorder.State = msRecording then
    StatusBar.SimpleText := SRecordingMacro
  else
    StatusBar.SimpleText := Format(SEditorPosition, [EdtCode.CaretY, EdtCode.CaretX]);
end;

procedure TFrmMain.ActFileNewExecute(Sender: TObject);
begin
  if not CheckFileSaved then
    Exit;
    
  FConfig.Clear;
  FConfig.ConfigFile.Modified := False;
  FConfig.ConfigFile.FileName := '';
  DisplayNetworkStructure;
end;

procedure TFrmMain.ActFileOpenExecute(Sender: TObject);
begin
  if not CheckFileSaved then
    Exit;

  with TOpenDialog.Create(nil) do
  begin
    Title := SOpenNetworkConfiguration;
    Filter := SConfigurationFilter;
    DefaultExt := '.cfg';
    Options := Options + [ofPathMustExist, ofFileMustExist];
    if Execute then
    begin
      FConfig.Clear;
      DisplayNetworkStructure;
      try
        FConfig.LoadFile(FileName);
        FConfig.ConfigFile.FileName := FileName;
      except
        on E: Exception do
        begin
          FConfig.Clear;
          MessageBox(Handle, PChar(Format(SThereHasBeenAnErrorWhileLoadingNetworkConfiguration, [E.Message])), PChar(SError), MB_ICONERROR or MB_OK);
          FConfig.ConfigFile.Modified := False;
          FConfig.ConfigFile.FileName := '';
        end;
      end;
      Caption := SConfigurationEditor;
      DisplayNetworkStructure;
    end;
    Free;
  end;
end;

procedure TFrmMain.ActFileSaveExecute(Sender: TObject);
begin
  if FConfig.ConfigFile.FileName = '' then
    ActFileSaveAs.Execute
  else
    FConfig.Save(FConfig.ConfigFile.FileName);
end;

procedure TFrmMain.ActFileSaveUpdate(Sender: TObject);
begin
  ActFileSave.Enabled := FConfig.ConfigFile.Modified;
end;

procedure TFrmMain.ActFileSaveAsExecute(Sender: TObject);
begin
  with TSaveDialog.Create(nil) do
  begin
    Title := SSaveNetworkConfigurationAs;
    Filter := SConfigurationFilter;
    DefaultExt := '.cfg';
    Options := Options + [ofPathMustExist, ofOverwritePrompt];
    FileName := FConfig.ConfigFile.FileName;
    if Execute then
      FConfig.Save(FileName);
    DisplayWindowTitle;
    Free;
  end;
end;

procedure TFrmMain.ActFileExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TFrmMain.ActEditAddServerExecute(Sender: TObject);
var
  I: Integer;
  Server: TServer;
begin
  Server := TConfigFactory.CreateServer(FConfig);
  DisplayNetworkStructure;
  for I := 0 to TrvNetworkStructure.Items.Count - 1 do
    if TrvNetworkStructure.Items[I].Data = Server then
    begin
      TrvNetworkStructure.Selected := TrvNetworkStructure.Items[I];
      TrvNetworkStructure.Selected.Expand(True);
      Break;
    end;
end;

procedure TFrmMain.ActEditAddServerUpdate(Sender: TObject);
begin
  ActEditAddServer.Enabled := PgcWorkspace.ActivePageIndex = PAGE_STRUCTURE;
end;

procedure TFrmMain.ActEditAddTimerExecute(Sender: TObject);
var
  I: Integer;
  Server: TServer;
  Timer: TTimer;
begin
  Server := SelectedServer;

  if Assigned(Server) then
  begin
    Timer := TConfigFactory.CreateTimer(Server);
    DisplayNetworkStructure;
    for I := 0 to TrvNetworkStructure.Items.Count - 1 do
      if TrvNetworkStructure.Items[I].Data = Timer then
      begin
        TrvNetworkStructure.Selected := TrvNetworkStructure.Items[I];
        TrvNetworkStructure.Selected.Expand(True);
        Break;
      end;
  end;
end;

procedure TFrmMain.ActEditAddTimerUpdate(Sender: TObject);
begin
  ActEditAddTimer.Enabled := (SelectedServer <> nil) and (PgcWorkspace.ActivePageIndex = PAGE_STRUCTURE);
end;

procedure TFrmMain.ActEditAddModuleExecute(Sender: TObject);
var
  I: Integer;
  Server: TServer;
  Module: TModule;
begin
  Server := SelectedServer;

  if Assigned(Server) then
  begin
    Module := TConfigFactory.CreateModule(Server);
    DisplayNetworkStructure;
    for I := 0 to TrvNetworkStructure.Items.Count - 1 do
      if TrvNetworkStructure.Items[I].Data = Module then
      begin
        TrvNetworkStructure.Selected := TrvNetworkStructure.Items[I];
        TrvNetworkStructure.Selected.Expand(True);
        Break;
      end;
  end;
end;

procedure TFrmMain.ActEditAddModuleUpdate(Sender: TObject);
begin
  ActEditAddModule.Enabled := (SelectedServer <> nil) and (PgcWorkspace.ActivePageIndex = PAGE_STRUCTURE);
end;

procedure TFrmMain.ActEditAddFolderExecute(Sender: TObject);
var
  I: Integer;
  Server: TServer;
  Folder: TFolder;
begin
  Server := SelectedServer;

  if Assigned(Server) then
  begin
    Folder := TConfigFactory.CreateFolder(Server);
    DisplayNetworkStructure;
    for I := 0 to TrvNetworkStructure.Items.Count - 1 do
      if TrvNetworkStructure.Items[I].Data = Folder then
      begin
        TrvNetworkStructure.Selected := TrvNetworkStructure.Items[I];
        TrvNetworkStructure.Selected.Expand(True);
        Break;
      end;
  end;
end;

procedure TFrmMain.ActEditAddFolderUpdate(Sender: TObject);
begin
  ActEditAddFolder.Enabled := (SelectedServer <> nil) and (PgcWorkspace.ActivePageIndex = PAGE_STRUCTURE);
end;

procedure TFrmMain.ActEditDeleteCurrentExecute(Sender: TObject);
var
  Data: Pointer;
begin
  Data := PpeNetworkItem.Data;

  if (PpeNetworkItem.Data is TServer) and ConfirmServerDeletion(Data) then
  begin
    DeleteServer(Data);
    TConfigManipulator.Instance(FConfig).DeleteServer(Data);
  end
  else if (PpeNetworkItem.Data is TTimer) and ConfirmTimerDeletion(Data) then
  begin
    DeleteTimer(Data);
    TConfigManipulator.Instance(FConfig).DeleteTimer(Data);
  end
  else if (PpeNetworkItem.Data is TFolder) and ConfirmFolderDeletion(Data) then
  begin
    DeleteFolder(Data);
    // no extra processing needed as DeleteFolder re-displays the whole
    // network structure (at least it should). it a matter of what folders
    // really are - they are just containers for other elements belonging
    // to the server.
  end
  else if (PpeNetworkItem.Data is TModule) and ConfirmModuleDeletion(Data) then
  begin
    DeleteModule(Data);
    TConfigManipulator.Instance(FConfig).DeleteModule(Data);
  end;
end;

procedure TFrmMain.ActEditDeleteCurrentUpdate(Sender: TObject);
begin
  ActEditDeleteCurrent.Enabled :=
    Assigned(PpeNetworkItem.Data) and (
      (PpeNetworkItem.Data is TServer) or
      (PpeNetworkItem.Data is TTimer) or
      (PpeNetworkItem.Data is TModule) or
      (PpeNetworkItem.Data is TFolder)
    ) and (PgcWorkspace.ActivePageIndex = PAGE_STRUCTURE);
end;

procedure TFrmMain.ActHelpAboutExecute(Sender: TObject);
begin
  MessageBox(Handle, PChar(SAboutBoxContent), PChar(SAboutBox), MB_ICONINFORMATION or MB_OK);
end;

procedure TFrmMain.ActFileCommitConfigExecute(Sender: TObject);
var
  Storage: TFileStorage;
  S: TStream;
begin
  Screen.Cursor := crHourGlass;
  try
    S := TMemoryStream.Create;
    try
      FConfig.ConfigFile.Save(S);
      S.Position := 0;
      Storage := TFileStorageFactory.CreateFileStorage;
      try
        Storage.Save(TOptions.Instance.ConfigFileName, S);
      finally
        Storage.Free;
      end;
    finally
      S.Free;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TFrmMain.ActFileCommitConfigUpdate(Sender: TObject);
begin
  ActFileCommitConfig.Enabled := Config.ConfigFile.Records.Count > 2;
end;

procedure TFrmMain.ActFileRetrieveConfigExecute(Sender: TObject);
var
  Storage: TFileStorage;
  S: TStream;
begin
  if FConfig.ConfigFile.Modified then
    case MessageBox(Handle, PChar(SConfigurationHasBeenChangedSaveChanges), PChar(SQuestion), MB_ICONQUESTION or MB_YESNOCANCEL) of
      ID_YES:
      begin
        ActFileSave.Execute;
        if FConfig.ConfigFile.Modified then
          Exit;
      end;
      ID_CANCEL:
        Exit;
    end;

  Screen.Cursor := crHourGlass;
  try
    S := TMemoryStream.Create;
    try
      Storage := TFileStorageFactory.CreateFileStorage;
      try
        Storage.Load(TOptions.Instance.ConfigFileName, S);
      finally
        Storage.Free;
      end;
      FConfig.LoadStream(S);
      DisplayNetworkStructure;
    finally
      S.Free;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TFrmMain.ActCodeCutExecute(Sender: TObject);
begin
  EdtCode.CutToClipboard;
end;

procedure TFrmMain.ActCodeCutUpdate(Sender: TObject);
begin
  ActCodeCut.Enabled := EdtCode.SelLength > 0;
end;

procedure TFrmMain.ActCodeCopyExecute(Sender: TObject);
begin
  EdtCode.CopyToClipboard;
end;

procedure TFrmMain.ActCodeCopyUpdate(Sender: TObject);
begin
  ActCodeCopy.Enabled := EdtCode.SelLength > 0;
end;

procedure TFrmMain.ActCodePasteExecute(Sender: TObject);
begin
  EdtCode.PasteFromClipboard;
end;

procedure TFrmMain.ActCodePasteUpdate(Sender: TObject);
begin
  ActCodePaste.Enabled := EdtCode.CanPaste
end;

procedure TFrmMain.ActCodeSelectAllExecute(Sender: TObject);
begin
  EdtCode.SelectAll;
end;

procedure TFrmMain.ActFuncProcListExecute(Sender: TObject);
var
  I, J: Integer;
  L: TProcFuncList;
  S: String;
  Coord: TBufferCoord;
begin
  L := TProcFuncList.Create;
  try
    // make a function/procedure list
    FillProcFuncList(EdtCode.Text, L);
    if L.Count > 0 then
    begin
      // show a dialog to select one
      with TFrmFunctionList.Create(nil) do
      begin
        for I := 0 to L.Count - 1 do
        begin
          // construct displayed line

          S := L[I].Name;
          // parameters?
          if L[I].ParamCount > 0 then
            S := S + '(';
          for J := 0 to L[I].ParamCount - 1 do
          begin
            // parameter name, colon and type
            S := S + L[I].Params[J].Name + ': ' + L[I].Params[J].Type_;

            // are there any more parameters?
            if J < L[I].ParamCount - 1 then
              S := S + '; '
            else
              S := S + ')';
          end;

          // is this a function? if so add function result value
          if L[I].Kind = ptFunction then
            S := S + ': ' + L[I].ReturnType + ';'
          else
            S := S + ';';

          // add the element to the list box together with a pointer to
          // the TProcFunc object
          with LivItems.Items.Add do
          begin
            // store the data so that we can easy get the line to go to after
            // the user clicks Ok.
            Data := L[I];

            // first, main caption (constructed above)
            Caption := S;

            // function or procedure?
            case L[I].Kind of
              ptFunction:
                SubItems.Add('function');
              ptProcedure:
                SubItems.Add('procedure');
            end;

            // and as the last column the information about it where the
            // is defined (line number)
            SubItems.Add(IntToStr(L[I].Line));
          end;
        end;

        // select the first item in the list
        LivItems.ItemIndex := 0;

        if ShowModal = mrOk then
        begin
          // jump to the selected function or procedure
          Coord.Char := 1; Coord.Line := TProcFunc(LivItems.Items[LivItems.ItemIndex].Data).Line;
          EdtCode.CaretXY := Coord;
          // make the editor the currently active control
          EdtCode.SetFocus;
        end;

        // free the selector dialog box
        Free;
      end;
    end;
  finally
    // dispose the list itself
    L.Free;
  end;
end;

procedure TFrmMain.ActFuncProcListUpdate(Sender: TObject);
begin
  ActFuncProcList.Enabled := (PgcWorkspace.ActivePageIndex = PAGE_CODE) and (EdtCode.Text <> '');
end;

// ----------------------------------------------------------------------------
// Folders editor
// ----------------------------------------------------------------------------

type
  TItemDragObject = class (TDragObjectEx)
    Item: TConfigItem;
    SourceNode: TTreeNode;
  end;

procedure TFrmMain.TrvNetworkStructureMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Node: TTreeNode;
begin
  if Button = mbLeft then
  begin
    // start dragging if there's anything to drag
    Node := TrvNetworkStructure.GetNodeAt(X, Y);
    if Assigned(Node) and Assigned(Node.Data) and ((TObject(Node.Data) is TModule) or (TObject(Node.Data) is TTimer)) then
      TrvNetworkStructure.BeginDrag(False, 10);
  end;
end;

procedure TFrmMain.TrvNetworkStructureStartDrag(Sender: TObject; var DragObject: TDragObject);
var
  Node: TTreeNode;
  P: TPoint;
begin
  // create dragged information
  P := TrvNetworkStructure.ScreenToClient(Mouse.CursorPos);
  Node := TrvNetworkStructure.GetNodeAt(P.X, P.Y);
  Assert(
   Assigned(Node) and Assigned(Node.Data) and ((TObject(Node.Data) is TModule) or (TObject(Node.Data) is TTimer)),
   'Error: invalid node in TrvNetworkStructureStartDrag'
  );
  DragObject := TItemDragObject.Create;
  TItemDragObject(DragObject).Item := Node.Data;
  TItemDragObject(DragObject).SourceNode := Node;
end;

procedure TFrmMain.TrvNetworkStructureDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
var
  Dest: TConfigItem;
  Node: TTreeNode;
  P: TPoint;
begin
  // accept only servers and folders and only if it's not the current folder of the dragged element
  P := TrvNetworkStructure.ScreenToClient(Mouse.CursorPos);
  Node := TrvNetworkStructure.GetNodeAt(P.X, P.Y);
  if Assigned(Node) and Assigned(Node.Data) and ((TObject(Node.Data) is TServer) or (TObject(Node.Data) is TFolder)) then
  begin
    Dest := Node.Data;

    if Dest is TServer then
    begin
      if TItemDragObject(Source).Item is TTimer then
        with  TTimer(TItemDragObject(Source).Item) do
          Accept := D.FolderId <> 0
      else if TItemDragObject(Source).Item is TModule then
        with TModule(TItemDragObject(Source).Item) do
          Accept := D.FolderId <> 0
      else
        Accept := False
    end
    else if Dest is TFolder then
    begin
      if TItemDragObject(Source).Item is TTimer then
        with TTimer(TItemDragObject(Source).Item) do
          Accept := D.FolderId <> D.Id
      else if TItemDragObject(Source).Item is TModule then
        with TModule(TItemDragObject(Source).Item) do
          Accept := D.FolderId <> D.Id
      else
        Accept := False
    end
    else Accept := False;
  end
  else
    Accept := False;
end;

procedure TFrmMain.TrvNetworkStructureDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  Dest: TConfigItem;
  Node: TTreeNode;
  P: TPoint;
  Builder: TNetworkViewBuilder;
begin
  // move the dragged element from source group to destination group
  P := TrvNetworkStructure.ScreenToClient(Mouse.CursorPos);
  Node := TrvNetworkStructure.GetNodeAt(P.X, P.Y);
  Assert(
    Assigned(Node) and Assigned(Node.Data) and ((TObject(Node.Data) is TServer) or (TObject(Node.Data) is TFolder)),
    'Error: invalid node in TrvNetworkStructureDragDrop'
  );
  Dest := Node.Data;
  if TItemDragObject(Source).Item is TModule then
  begin
    if Dest is TServer then
      TModule(TItemDragObject(Source).Item).D.FolderId := 0
    else if dest is TFolder then
      TModule(TItemDragObject(Source).Item).D.FolderId := Dest.Id;
    TItemDragObject(Source).Item.DataObject.Modified := True;
  end
  else if TItemDragObject(Source).Item is TTimer then
  begin
    if Dest is TServer then
      TTimer(TItemDragObject(Source).Item).D.FolderId := 0
    else if dest is TFolder then
      TTimer(TItemDragObject(Source).Item).D.FolderId := Dest.Id;
    TItemDragObject(Source).Item.DataObject.Modified := True;
  end;

  FConfig.UpdateLists;

  // move the dragged element from source folder to destination folder
  TrvNetworkStructure.Items.BeginUpdate;
  try
    TItemDragObject(Source).SourceNode.Delete;
    Builder := TNetworkViewBuilder.Create(FConfig);
    try
      if TItemDragObject(Source).Item is TModule then
        Builder.BuildModuleNode(TrvNetworkStructure.Items, Node, TItemDragObject(Source).Item as TModule).Selected := True
      else if TItemDragObject(Source).Item is TTimer then
        Builder.BuildTimerNode(TrvNetworkStructure.Items, Node, TItemDragObject(Source).Item as TTimer).Selected := True
    finally
      Builder.Free;
    end;
  finally
    TrvNetworkStructure.Items.EndUpdate;
  end;
end;

// ----------------------------------------------------------------------------
// script compilation
// ----------------------------------------------------------------------------

procedure TFrmMain.ActCodeCompileExecute(Sender: TObject);
var
  I: Integer;
  Success: Boolean;
begin
  PgcWorkspace.ActivePageIndex := PAGE_CODE;
  EdtCode.SetFocus;

  // compile the script and show compilation results
  PascalScript.Script.Assign(EdtCode.Lines);

  LbxMessages.Items.BeginUpdate;
  try
    LbxMessages.Items.Clear;
    Success := PascalScript.Compile;
    for I := 0 to PascalScript.Comp.MsgCount - 1 do
      LbxMessages.Items.Add(PascalScript.Comp.Msg[I].MessageToString);
    if Success then
      LbxMessages.Items.Add('Compilation successfull')
    else
      LbxMessages.SetFocus;

    // make sure there's an element selected
    if LbxMessages.Items.Count > 0 then
      LbxMessages.ItemIndex := 0;
  finally
    LbxMessages.Items.EndUpdate;
  end;
end;

// extract column and row from a message
function GetCRFromMsg(S: String; var C, R: Integer): Boolean;
var
  P1, P2, P3: Integer;
begin
  P1 := Pos('(', S);
  P2 := Pos(':', S);
  P3 := Pos(')', S);
  if (P1 > 0) and (P3 > 0) and (P2 > P1) and (P2 < P3) then
  begin
    C := StrToIntDef(Copy(S, P1+1, P2-P1-1), -1);
    R := StrToIntDef(Copy(S, P2+1, P3-P2-1), -1);
  end;
  Result := (C <> -1) and (R <> -1);
end;

procedure TFrmMain.LbxMessagesDblClick(Sender: TObject);
var
  Index, C, R: Integer;
begin
  // jump to an error/warning/hint message from the compiler message list
  Index := LbxMessages.ItemAtPos(LbxMessages.ScreenToClient(Mouse.CursorPos), True);
  if Index <> -1 then
  begin
    if GetCRFromMsg(LbxMessages.Items[Index], C, R) then
    begin
      EdtCode.CaretX := R;
      EdtCode.CaretY := C;
      EdtCode.SetFocus;
    end;
  end;
end;

procedure TFrmMain.LbxMessagesKeyPress(Sender: TObject; var Key: Char);
var
  C, R: Integer;
begin
  if (Key = #13) and (LbxMessages.ItemIndex <> -1) then
  begin
    // jump to an error/warning/hint message from the compiler message list
    if GetCRFromMsg(LbxMessages.Items[LbxMessages.ItemIndex], C, R) then
    begin
      EdtCode.CaretX := R;
      EdtCode.CaretY := C;
      EdtCode.SetFocus;
    end;
  end
  else if Key = #27 then
    // jump to code editor
    EdtCode.SetFocus;
end;

end.


