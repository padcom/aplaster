// ----------------------------------------------------------------------------
// file: FormMain.pas - a part of AplaSter system
// date: 2005-09-08
// auth: Matthias Hryniszak
// desc: aplaster server main window
// ----------------------------------------------------------------------------

unit FormMain;

{$IFOPT D+}
  {$DEFINE DEBUG}
  {$DEFINE ENABLE_SCRIPT_DEBUGGER}
{$ELSE}
  {$I config.inc}
{$ENDIF}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ImgList, Winsock, ShellApi, Menus, ExtCtrls,
  uPSRuntime, uPSComponent, uPSComponent_Default, uPSI_BaseTypes,
  ScriptObjects, Config, Network;

const
  WM_TRAY  = WM_USER + 1;

type
  TFrmMain = class(TForm)
    LivModules: TListView;
    BtnModuleReset: TButton;
    LblModules: TLabel;
    StatusBar: TStatusBar;
    BtnServerReload: TButton;
    BtnServerTerminate: TButton;
    ImlIcons: TImageList;
    MnuTray: TPopupMenu;
    MniShowHide: TMenuItem;
    BtnShowDebugger: TButton;
    PSScript: TPSScript;
    PluginDll: TPSDllPlugin;
    PluginClasses: TPSImport_Classes;
    PluginDateUtils: TPSImport_DateUtils;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormResize(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure BtnModuleResetClick(Sender: TObject);
    procedure BtnServerReloadClick(Sender: TObject);
    procedure BtnServerTerminateClick(Sender: TObject);
    procedure MniShowHideClick(Sender: TObject);
    procedure BtnShowDebuggerClick(Sender: TObject);
  private
    { Private declarations }
    FConfig: TConfig;   // created together with the form
    FNetwork: TNetwork; // created together with the form
    FDoClose: Boolean;  // mark the OnFormClose event as caFree
    procedure AssignLanguage;
    procedure ShowTrayIcon;
    procedure HideTrayIcon;
    procedure LoadConfig;
    procedure DisplayModules;
    procedure ReloadConfig;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure WndProc(var Msg: TMessage); override;
  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;

implementation

uses
  Icons, Storage, Resources,
{$IFDEF ENABLE_SCRIPT_DEBUGGER}
  FormDebugMain, FormDebugEvaulate,
{$ENDIF}
  Protocol, SysConst, Options;

{$R *.dfm}

{ TUIEvents }

type
  TUIEvents = class (TPSEvents)
  private
    function GetListItem(Module: TPSModule): TListItem;
  protected
    procedure OnModuleConnected(Module: TPSModule); override;
    procedure OnModuleDisconnected(Module: TPSModule); override;
  end;

{ Private declarations }

function TUIEvents.GetListItem(Module: TPSModule): TListItem;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to FrmMain.LivModules.Items.Count - 1 do
    if FrmMain.LivModules.Items[I].Data = Module then
    begin
      Result := FrmMain.LivModules.Items[I];
      Break;
    end;
end;

{ Protected declarations }

procedure TUIEvents.OnModuleConnected(Module: TPSModule);
var
  ListItem: TListItem;
begin
  ListItem := GetListItem(Module);
  if Assigned(ListItem) then
    ListItem.SubItems[1] := SActive;
end;

procedure TUIEvents.OnModuleDisconnected(Module: TPSModule);
var
  ListItem: TListItem;
begin
  ListItem := GetListItem(Module);
  if Assigned(ListItem) then
    ListItem.SubItems[1] := SInactive;
end;

{ TFrmMain }

{ Private declarations }

procedure TFrmMain.AssignLanguage;
begin
  Caption := SAplaServer;
  Application.Title := SAplaServer;
  LblModules.Caption := SModules;
  LivModules.Columns[0].Caption := STitle;
  LivModules.Columns[1].Caption := SIPAddress;
  LivModules.Columns[2].Caption := SStatus;
  BtnModuleReset.Caption := SResetModule;
  BtnShowDebugger.Caption := SScriptDebugger;
  BtnServerReload.Caption := SReloadConfiguration;
  BtnServerTerminate.Caption := STerminateServer;
  MniShowHide.Caption := SShowHide;
end;

procedure TFrmMain.ShowTrayIcon;
var
  nid: NOTIFYICONDATA;
begin
  nid.cbSize := SizeOf(nid);
  nid.Wnd := Handle;
  nid.uID := 0;
  nid.uFlags := NIF_MESSAGE or NIF_ICON or NIF_TIP;
  nid.uCallbackMessage := WM_TRAY;
  nid.hIcon := LoadIcon(hInstance, 'MAINICON');
  Move(SAplaServer[1], nid.szTip, Length(SAplaServer) + 1);
  Shell_NotifyIcon(NIM_ADD, @nid);
end;

procedure TFrmMain.HideTrayIcon;
var
  nid: NOTIFYICONDATA;
begin
  nid.cbSize := SizeOf(nid);
  nid.Wnd := Handle;
  nid.uID := 0;
  nid.uCallbackMessage := WM_TRAY;
  Shell_NotifyIcon(NIM_DELETE, @nid);
end;

procedure TFrmMain.LoadConfig;
var
  Storage: TFileStorage;
  S: TStream;
begin
  Screen.Cursor := crHourGlass;
  if Assigned(FNetwork.Server) then
  begin
    FNetwork.Server.Free;
    FNetwork.Server := nil;
  end;
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
      // create new script-enabled structures from server LocalIP capable of sending packets with Send method
{$IFDEF ENABLE_SCRIPT_DEBUGGER}
      FNetwork.Server := RecreateScriptObjects(FConfig, FNetwork.LocalIP, FNetwork.Write, FrmDebugMain.Debugger);
      if Assigned(FNetwork.Server) then
        RecompileScript(FNetwork.Server, FConfig);
      FrmDebugMain.Server := FNetwork.Server;
{$ELSE}
      FNetwork.Server := RecreateScriptObjects(FConfig, FNetwork.LocalIP, FNetwork.Write, PSScript);
      if Assigned(FNetwork.Server) then
        RecompileScript(FNetwork.Server, FConfig);
{$ENDIF}
      if Assigned(FNetwork.Server) then
        FNetwork.Server.Events.Add(TUIEvents.Create);
    finally
      S.Free;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TFrmMain.DisplayModules;
var
  I: Integer;
  IP: String;
begin
  LivModules.Items.BeginUpdate;
  try
    LivModules.Items.Clear;
    if Assigned(FNetwork.Server) then
    begin
      StatusBar.SimpleText := Format(SServerIPAddress, [IP]);
      for I := 0 to FNetwork.Server.Modules.Count - 1 do
        with LivModules.Items.Add, FNetwork.Server.Modules[I] do
        begin
          Data := FNetwork.Server.Modules[I];
          if D.Title <> '' then
            Caption := D.Title
          else
            Caption := SNoName;
          SubItems.Add(D.IP);
          SubItems.Add(SInactive);
          ImageIndex := IMAGE_INDEX_MODULE;
        end
    end
    else
    begin
      MessageBox(Handle, PChar(SThisMachineHasNotBeenconfiguredAsServer), PChar(SError), MB_ICONERROR);
      Application.Terminate;
    end;
    LivModules.Columns[0].Width := LivModules.ClientWidth - LivModules.Columns[1].Width - LivModules.Columns[2].Width;
  finally
    LivModules.Items.EndUpdate;
  end;
end;

procedure TFrmMain.ReloadConfig;
begin
  try
    if Assigned(FNetwork.Server) then
      FNetwork.Server.OnStop;
    LoadConfig;
    DisplayModules;
    if Assigned(FNetwork.Server) then
      FNetwork.Server.OnStart;
  except
    on E: Exception do
    begin
      Application.ShowException(E);
      Application.Terminate;
    end;
  end;
end;

{ Protected declarations }

procedure TFrmMain.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  // remove application window from taskbar
  SetWindowLong(Application.Handle, GWL_EXSTYLE, GetWindowLong(Application.Handle, GWL_EXSTYLE) or WS_EX_TOOLWINDOW);
end;

procedure TFrmMain.WndProc(var Msg: TMessage);
var
  Buffer : array of Byte;
  Addr   : TSockAddrIn;
  AddrLen: Integer;
  Count  : Integer;
begin
  inherited WndProc(Msg);
  case Msg.Msg of
    WM_TRAY:
    begin
      // Tray icon event
      case Msg.LParam of
        WM_LBUTTONUP:
        begin
          if Visible then
            Hide
          else
          begin
            Show;
            SetForegroundWindow(Handle);
          end;
        end;
        WM_RBUTTONUP:
          MnuTray.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);
      end;
      Msg.Result := 0;
    end;
    WM_RXSOCKET:
    begin
      // Rx socket event
      case Msg.lParam of
        FD_READ:
        begin
          // data are ready to be received
          ZeroMemory(@Addr, SizeOf(Addr));
          AddrLen := SizeOf(Addr);
          SetLength(Buffer, 4096);
          Count := recvfrom(Msg.WParam, Buffer[0], Length(Buffer), 0, Addr, AddrLen);
          if Count > 0 then
          begin
            SetLength(Buffer, Count);
            FNetwork.Read(inet_ntoa(Addr.sin_addr), Buffer);
{$IFDEF ENABLE_SCRIPT_DEBUGGER}
            if Assigned(FrmDebugMain) then
              FrmDebugMain.TrvNetworkStatus.Invalidate;
{$ENDIF}
          end;
        end;
      end;
      Msg.Result := 0;
    end;
  end;
end;

{ Public declarations }

procedure TFrmMain.FormCreate(Sender: TObject);
begin
  AssignLanguage;

  FConfig := TConfig.Create;

  try
    FNetwork := TNetwork.Create(Handle, FConfig);
    ShowTrayIcon;

    // scripting initialization
{$IFDEF ENABLE_SCRIPT_DEBUGGER}
    FrmDebugMain := TFrmDebugMain.Create(nil);
    FrmDebugEvaluate := TFrmDebugEvaluate.Create(nil);
    BtnShowDebugger.Visible := True;
{$ELSE}
    TPSPluginItem(PSScript.Plugins.Add).Plugin := TPSImport_BaseTypes.Create(Self);
    TPSPluginItem(PSScript.Plugins.Add).Plugin := TPSScriptObjects.Create(Self);
    BtnShowDebugger.Visible := False;
{$ENDIF}

    // configuration initialization
    ReloadConfig;
  except
    on E: Exception do
    begin
      Application.ShowException(E);
      Application.Terminate;
    end;
  end;
end;

procedure TFrmMain.FormDestroy(Sender: TObject);
begin
  HideTrayIcon;
  FNetwork.Server.Free;
  FNetwork.Server := nil;
  FreeAndNil(FNetwork);
  FreeAndNil(FConfig);
{$IFDEF ENABLE_SCRIPT_DEBUGGER}
  FreeAndNil(FrmDebugEvaluate);
  FreeAndNil(FrmDebugMain);
{$ENDIF}
end;

procedure TFrmMain.FormShow(Sender: TObject);
begin
//
end;

procedure TFrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if FDoClose then
  begin
    Action := caFree;
    // make sure the script engine gets terminated
    if FNetwork.Server.ScriptEngine.Exec.Status in [isPaused, isRunning] then
      FNetwork.Server.ScriptEngine.Stop;
  end
  else
  begin
    Hide;
    Action := caNone;
  end;
end;

procedure TFrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
//
end;

procedure TFrmMain.FormResize(Sender: TObject);
begin
//
end;

procedure TFrmMain.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE:
      Hide;
  end;
end;

procedure TFrmMain.BtnModuleResetClick(Sender: TObject);
begin
  if Assigned(LivModules.Selected) then
    TPSModule(LivModules.Selected.Data).Reset;
end;

procedure TFrmMain.BtnServerReloadClick(Sender: TObject);
begin
  ReloadConfig;
end;

procedure TFrmMain.BtnServerTerminateClick(Sender: TObject);
begin
  FDoClose := True;
  Close;
end;

procedure TFrmMain.MniShowHideClick(Sender: TObject);
begin
  if Visible then
    Hide
  else
  begin
    Show;
    SetForegroundWindow(Handle);
  end;
end;

procedure TFrmMain.BtnShowDebuggerClick(Sender: TObject);
begin
{$IFDEF ENABLE_SCRIPT_DEBUGGER}
  FrmDebugMain.Show;
{$ENDIF}
end;

end.

