// ----------------------------------------------------------------------------
// file: FormDebugMain.pas
// date: 2005-09-11
// auth: Matthias "Padcom" Hryniszak
// desc: Debugger window of the aplasvr application.
// ----------------------------------------------------------------------------

unit FormDebugMain;

{$IFOPT D+}
  {$DEFINE DEBUG}
{$ENDIF}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, ImgList, ExtCtrls, StdCtrls, ComCtrls, ToolWin, Menus,
  SynEdit, SynEditHighlighter, SynHighlighterPas, SynEditTypes,
  uPSDebugger, uPSCompiler, uPSRuntime, uPSComponent,
  uPSI_BaseTypes, uPSComponent_Default, 
  Config, ConfigFile, ScriptObjects,
  ViewUtils, ViewUtilsForServer;

type
  TFrmDebugMain = class(TForm)
    Actions: TActionList;
    ActRunContinue: TAction;
    ActRunStepInto: TAction;
    ActRunStepOver: TAction;
    ActRunEvaluate: TAction;
    ActRunToggleBreakpoint: TAction;
    Debugger: TPSScriptDebugger;
    EdtCode: TSynEdit;
    HltPascal: TSynPasSyn;
    StatusBar: TStatusBar;
    Splitter: TSplitter;
    PgcDebugTools: TPageControl;
    TbsDebugTree: TTabSheet;
    TrvNetworkStatus: TTreeView;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ActRunContinueExecute(Sender: TObject);
    procedure ActRunContinueUpdate(Sender: TObject);
    procedure ActRunStepIntoExecute(Sender: TObject);
    procedure ActRunStepIntoUpdate(Sender: TObject);
    procedure ActRunStepOverExecute(Sender: TObject);
    procedure ActRunStepOverUpdate(Sender: TObject);
    procedure ActRunEvaluateExecute(Sender: TObject);
    procedure ActRunEvaluateUpdate(Sender: TObject);
    procedure ActRunToggleBreakpointExecute(Sender: TObject);
    procedure EdtCodeSpecialLineColors(Sender: TObject; Line: Integer; var Special: Boolean; var FG, BG: TColor);
    procedure DebuggerBreakpoint(Sender: TObject; const FileName: String; Position, Row, Col: Cardinal);
    procedure DebuggerIdle(Sender: TObject);
    procedure DebuggerLineInfo(Sender: TObject; const FileName: String; Position, Row, Col: Cardinal);
    procedure TrvNetworkStatusCustomDrawItem(Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
  private
    { Private declarations }
    FActiveLine: Integer;
    FResume: Boolean;
    FServer: TPSServer;
    FConfigTreeDisplayer: TConfigTreeDisplayer;
    procedure SetServer(Value: TPSServer);
    procedure AssignLanguage;
  public
    { Public declarations }
    property Server: TPSServer read FServer write SetServer;
  end;

var
  FrmDebugMain: TFrmDebugMain;

implementation

uses
  Resources, FormDebugEvaulate, FormMain,
  ViewBuilders;

{$R *.dfm}

{ Private declarations }

procedure TFrmDebugMain.SetServer(Value: TPSServer);
begin
  if Assigned(FConfigTreeDisplayer) then
    FConfigTreeDisplayer.Free;

  FServer := Value;
  if Assigned(FServer) then
  begin
    EdtCode.Text := FServer.ConfigObject.Config.ConfigFile.GlobalData.Code;
    FConfigTreeDisplayer := TConfigTreeDisplayerForServer.Create(FServer);
  end
  else
    EdtCode.Text := '';
end;

procedure TFrmDebugMain.AssignLanguage;
begin
  Caption := SScriptDebugger;

  ActRunContinue.Caption := SContinue;
  ActRunContinue.Hint := StripHotkey(SContinue);
  ActRunStepInto.Caption := SStepInto;
  ActRunStepInto.Hint := StripHotkey(SStepInto);
  ActRunStepOver.Caption := SStepOver;
  ActRunStepOver.Hint := StripHotkey(SStepOver);
  ActRunEvaluate.Caption := SEvaluate;
  ActRunEvaluate.Hint := StripHotkey(SEvaluate);
  ActRunToggleBreakpoint.Caption := SToggleBreakpoint;
  ActRunToggleBreakpoint.Hint := StripHotkey(SToggleBreakpoint);

  EdtCode.Lines.Clear;

  TbsDebugTree.Caption := SServerElements;
end;

{ Public declarations }

procedure TFrmDebugMain.FormCreate(Sender: TObject);
begin
  AssignLanguage;
  TPSPluginItem(Debugger.Plugins.Add).Plugin := TPSImport_BaseTypes.Create(Self);
  TPSPluginItem(Debugger.Plugins.Add).Plugin := TPSScriptObjects.Create(Self);
end;

procedure TFrmDebugMain.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FConfigTreeDisplayer);
end;

procedure TFrmDebugMain.FormShow(Sender: TObject);
var
  TreeBuilder: TNetworkViewBuilder;
begin
  TreeBuilder := TNetworkViewBuilder.Create(Server.ConfigObject.Config);
  try
    TrvNetworkStatus.Items.BeginUpdate;
    try
      TrvNetworkStatus.Items.Clear;
      // rebuild network tree view
      TreeBuilder.BuildServerNode(TrvNetworkStatus.Items, nil, Server.ConfigObject as TServer);
    finally
      TrvNetworkStatus.Items.EndUpdate;
    end;
  finally
    TreeBuilder.Free;
  end;
end;

procedure TFrmDebugMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  // check if the debugger is still running and if so continue the execution
  if Debugger.Exec.Status = isRunning then
    FResume := True;
end;

procedure TFrmDebugMain.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_F5:
    begin
      // simulate Delphi behaviour (maximize/restore, Classic key bindings)
      if WindowState = wsMaximized then
        WindowState := wsNormal
      else
        WindowState := wsMaximized;
    end;
    VK_ESCAPE:
      Close;
  end;
end;

procedure TFrmDebugMain.ActRunContinueExecute(Sender: TObject);
begin
  // continue execution
  if Debugger.Running then
    FResume := True;
end;

procedure TFrmDebugMain.ActRunContinueUpdate(Sender: TObject);
begin
  ActRunContinue.Enabled := Debugger.Exec.Status = isRunning;
end;

procedure TFrmDebugMain.ActRunStepIntoExecute(Sender: TObject);
begin
  // step into a function. if the executor isn't currently running the
  // script the script gets compiled and executed till the first line
  // of code.
  if Debugger.Exec.Status = isRunning then
    Debugger.StepInto;
end;

procedure TFrmDebugMain.ActRunStepIntoUpdate(Sender: TObject);
begin
  ActRunStepInto.Enabled := Debugger.Exec.Status = isRunning;
end;

procedure TFrmDebugMain.ActRunStepOverExecute(Sender: TObject);
begin
  // step over a function. if the executor isn't currently running the
  // script the script gets compiled and executed till the first line
  // of code.
  if Debugger.Exec.Status = isRunning then
    Debugger.StepOver;
end;

procedure TFrmDebugMain.ActRunStepOverUpdate(Sender: TObject);
begin
  ActRunStepOver.Enabled := Debugger.Exec.Status = isRunning;
end;

procedure TFrmDebugMain.ActRunEvaluateExecute(Sender: TObject);
var
  S: String;
begin
  // evaluate the expression under the cursor
  if Debugger.Exec.Status = isRunning then
  begin
    // get text under cursor
    S := EdtCode.GetWordAtRowCol(EdtCode.CaretXY);
    FrmDebugEvaluate.CbbExpression.Text := S;
    // perform evaluation
    S := Debugger.GetVarContents(S);
    // display results of the evaluation
    FrmDebugEvaluate.MemResult.Text := S;
    // show the Evaluate/Modify dialog
    FrmDebugEvaluate.Show;
    FrmDebugEvaluate.CbbExpression.SelectAll;
    FrmDebugEvaluate.CbbExpression.SetFocus;
  end;
end;

procedure TFrmDebugMain.ActRunEvaluateUpdate(Sender: TObject);
begin
  // this action is available only while debugging the script
  ActRunEvaluate.Enabled := Debugger.Exec.Status = isRunning;
end;

procedure TFrmDebugMain.ActRunToggleBreakpointExecute(Sender: TObject);
begin
  // toggle a breakpoint at the current source line
  if Debugger.HasBreakPoint(Debugger.MainFileName, EdtCode.CaretY) then
    Debugger.ClearBreakPoint(Debugger.MainFileName, EdtCode.CaretY)
  else
    Debugger.SetBreakPoint(Debugger.MainFileName, EdtCode.CaretY);
  // invalidate the editor so that the changes are visible at once
  EdtCode.Refresh;
end;

procedure TFrmDebugMain.EdtCodeSpecialLineColors(Sender: TObject; Line: Integer; var Special: Boolean; var FG, BG: TColor);
begin
  // get special colors for "special" lines
  if Debugger.HasBreakPoint(Debugger.MainFileName, Line) then
  begin
    Special := True;
    if Line = FActiveLine then
    begin
      // a line with breakpoint that's currently being executed
      BG := clWhite;
      FG := clRed;
    end
    else
    begin
      // a line with breakpoint
      FG := clWhite;
      BG := clRed;
    end;
  end
  else if Line = FActiveLine then
  begin
    // a line that's currently being executed
    Special := True;
    FG := clNavy;
    bg := clAqua;
  end
  else Special := False;
end;

procedure TFrmDebugMain.DebuggerBreakpoint(Sender: TObject; const FileName: String; Position, Row, Col: Cardinal);
begin
  // the debugger is stopped due to breakpoint - refresh the editor view,
  // jump to the actual line and if neccecery make the current line visible
  FActiveLine := Row;
  if (FActiveLine < EdtCode.TopLine + 2) or (FActiveLine > EdtCode.TopLine + EdtCode.LinesInWindow - 2) then
    EdtCode.TopLine := FActiveLine - (EdtCode.LinesInWindow div 2);
  EdtCode.CaretY := FActiveLine;
  EdtCode.CaretX := 1;
  EdtCode.Refresh;
  if not Visible then
  begin
    Show;
    BringToFront;
  end;
end;

procedure TFrmDebugMain.DebuggerIdle(Sender: TObject);
begin
  // Debugger's idle loop entry point
  Application.HandleMessage;
  if FResume then
  begin
    // continue to the next line
    FResume := False;
    Debugger.Resume;
    // repaint the editor
    FActiveLine := 0;
    EdtCode.Refresh;
  end;
end;

procedure TFrmDebugMain.DebuggerLineInfo(Sender: TObject; const FileName: String; Position, Row, Col: Cardinal);
begin
  // according to the current execution point update the
  // editor position
  if Debugger.Exec.DebugMode <> dmRun then
  begin
    FActiveLine := Row;
    // if FActiveLine is outside the visible area force it to be visible
    if (FActiveLine < EdtCode.TopLine + 2) or (FActiveLine > EdtCode.TopLine + EdtCode.LinesInWindow - 2) then
      EdtCode.TopLine := FActiveLine - (EdtCode.LinesInWindow div 2);
    EdtCode.CaretY := FActiveLine;
    EdtCode.CaretX := 1;
    EdtCode.Refresh;
  end;
end;

// ----------------------------------------------------------------------------
// Debug tools
// ----------------------------------------------------------------------------

procedure TFrmDebugMain.TrvNetworkStatusCustomDrawItem(Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  if (Node.Data <> nil) and (TObject(Node.Data) is TConfigItem) then
    Node.Text := FConfigTreeDisplayer.GetTitle(Node.Data);
end;

end.

