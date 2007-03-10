// ----------------------------------------------------------------------------
// file: FormMain.pas - a part of AplaSter system
// date: 2005-09-08
// auth: Matthias Hryniszak
// desc: main form for situaltion monitor
// ----------------------------------------------------------------------------

unit FormMain;

{$IFOPT D+}
  {$DEFINE DEBUG}
{$ENDIF}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, Menus, ComCtrls,
  Config, StdActns;

type
  TFrmMain = class(TForm)
    MainMenu: TMainMenu;
    StatusBar: TStatusBar;
    Actions: TActionList;
    MnuFile: TMenuItem;
    MniFileExit: TMenuItem;
    MnuWindow: TMenuItem;
    MniWindowTileHorizontal: TMenuItem;
    MniWindowCascade: TMenuItem;
    MniMinimizeAll: TMenuItem;
    N1: TMenuItem;
    ActFileExit: TAction;
    MniWindowTileVertical: TMenuItem;
    ActWindowCascade: TWindowCascade;
    ActWindowTileHorizontal: TWindowTileHorizontal;
    ActWindowTileVertical: TWindowTileVertical;
    ActWindowMinimizeAll: TWindowMinimizeAll;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormResize(Sender: TObject);
    procedure ActFileExitExecute(Sender: TObject);
  private
    { Private declarations }
    FConfig: TConfig;
    procedure AssignLanguage;
  public
    { Public declarations }
    property Config: TConfig read FConfig;
  end;

var
  FrmMain: TFrmMain;

implementation

uses
  PxSettings, Resources, Storage;

{$R *.dfm}

{ Private declarations }

procedure TFrmMain.AssignLanguage;
begin
  Application.Title := SMonitorTitle;
  Caption := SMonitorTitle;
  MnuFile.Caption := SFile;
  ActFileExit.Caption := SExit;
  MnuWindow.Caption := SWindow;
  ActWindowCascade.Caption := SCascade;
  ActWindowTileHorizontal.Caption := STileHorizontal;
  ActWindowTileVertical.Caption := STileVertical;
  ActWindowMinimizeAll.Caption := SMinimizeAll;
end;

{ Public declarations }

procedure TFrmMain.FormCreate(Sender: TObject);
var
  Storage: TFileStorage;
  S: TStream;
  ConfigFileName: string;
begin
  AssignLanguage;

  ConfigFileName := IniFile.ReadString('settings', 'configfile', 'netconfig.cfg');

  FConfig := TConfig.Create;
  try
    S := TMemoryStream.Create;
    try
      Storage := TFileStorageFactory.CreateFileStorage;
      try
        Storage.Load(ConfigFileName, S);
      finally
        Storage.Free;
      end;
      S.Position := 0;
      FConfig.LoadStream(S);
    finally
      S.Free;
    end;
  except
    on E: Exception do
    begin
      MessageBox(Handle, PChar(SErrorWhileConnectingToDatabaseServer), PChar(SCriticalError), MB_ICONERROR or MB_OK);
      Application.Terminate;
    end;
  end;
end;

procedure TFrmMain.FormDestroy(Sender: TObject);
begin
//
end;

procedure TFrmMain.FormShow(Sender: TObject);
begin
//
end;

procedure TFrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
//
end;

procedure TFrmMain.FormResize(Sender: TObject);
begin
//
end;

procedure TFrmMain.ActFileExitExecute(Sender: TObject);
begin
  Close;
end;

end.

