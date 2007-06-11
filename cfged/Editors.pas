unit Editors;

{$IFOPT D+}
  {$DEFINE DEBUG}
{$ENDIF}

interface

uses
  Windows, Classes, SysUtils, Dialogs,
  PropertyEditor, SynEdit,
  PxDataFile,
  Config, ConfigFile, PasUtils;

const
  GROUP_PROPERTIES   = 0;
  GROUP_EVENTS       = 1;

const
  BITRATE : array[0..6] of String = ('2400', '4800', '9600', '19200', '38400', '57600', '115200'); 
  DATABITS: array[0..1] of String = ('7', '8');
  PARITY  : array[0..2] of String = ('None', 'Odd', 'Even');
  STOPBITS: array[0..2] of String = ('1', '1,5', '2');

type
  TCheckParamListCallback = function(EventId: TIdentifier; Item: TProcFunc): Boolean of object;

  TEditor = class (TObject)
  private
    FConfig: TConfig;
    FEditor: TPropertyEditor;
    FCodeEditor: TSynEdit;
  protected
    function CheckEventHandler(Name: WideString): WideString;
    procedure GetEventHandlerList(CheckParamList: TCheckParamListCallback; EventId: TIdentifier; EventHandlers: TStrings; CurrentHandler: WideString; var CurrentIndex: Integer);
    function CreateGotoEventHandler(CheckParamList: TCheckParamListCallback; EventId: TIdentifier; Parameters: String; var CurrentHandler: String): Integer;
    procedure GotoEditorLine(Line: Integer);
  public
    constructor Create(AConfig: TConfig; AEditor: TPropertyEditor; ACodeEditor: TSynEdit); virtual;
    destructor Destroy; override;
    procedure GetProperties(Sender, Data: TObject; Group: Word; var Properties: TProperties); virtual; abstract;
    procedure GetPropertyValue(Sender, Data: TObject; Group: Word; Prop: TProperty; var Value: WideString); virtual; abstract;
    procedure SetPropertyValue(Sender, Data: TObject; Group: Word; Prop: TProperty; Value: WideString); virtual; abstract;
    procedure UpdateListBoxContent(Sender, Data: TObject; Group: Word; Prop: TProperty; ListItems: TStrings; var ItemIndex: Integer); virtual; abstract;
    procedure PropertyButtonClick(Sender, Data: TObject; Group: Word; Prop: TProperty; ButtonId: LongWord); virtual; abstract;
    procedure EditorDblClick(Sender, Data: TObject; Group: Word; Prop: TProperty); virtual; abstract;
    property Config: TConfig read FConfig;
    property Editor: TPropertyEditor read FEditor;
  end;

  TEditorList = class (TList)
  private
    function GetItemByClass(EditedClass: TClass): TEditor; overload;
    function GetItemByIndex(Index: Integer): TEditor; overload;
  public
    procedure RegisterEditor(EditedClass: TClass; Editor: TEditor);
    procedure UnregisterEditor(Editor: TEditor);
    property Items[Index: Integer]: TEditor read GetItemByIndex; default;
    property ByClass[EditedClass: TClass]: TEditor read GetItemByClass; 
  end;

  TServerEditor = class (TEditor)
  protected
    function CheckOnStartStopParams(EventId: TIdentifier; Item: TProcFunc): Boolean;
  public
    procedure GetProperties(Sender, Data: TObject; Group: Word; var Properties: TProperties); override;
    procedure GetPropertyValue(Sender, Data: TObject; Group: Word; Prop: TProperty; var Value: WideString); override;
    procedure SetPropertyValue(Sender, Data: TObject; Group: Word; Prop: TProperty; Value: WideString); override;
    procedure UpdateListBoxContent(Sender, Data: TObject; Group: Word; Prop: TProperty; ListItems: TStrings; var ItemIndex: Integer); override;
    procedure PropertyButtonClick(Sender, Data: TObject; Group: Word; Prop: TProperty; ButtonId: LongWord); override;
    procedure EditorDblClick(Sender, Data: TObject; Group: Word; Prop: TProperty); override;
  end;

  TTimerEditor = class (TEditor)
  private
    function CheckOnTimerParams(EventId: TIdentifier; Item: TProcFunc): Boolean;
  public
    procedure GetProperties(Sender, Data: TObject; Group: Word; var Properties: TProperties); override;
    procedure GetPropertyValue(Sender, Data: TObject; Group: Word; Prop: TProperty; var Value: WideString); override;
    procedure SetPropertyValue(Sender, Data: TObject; Group: Word; Prop: TProperty; Value: WideString); override;
    procedure UpdateListBoxContent(Sender, Data: TObject; Group: Word; Prop: TProperty; ListItems: TStrings; var ItemIndex: Integer); override;
    procedure PropertyButtonClick(Sender, Data: TObject; Group: Word; Prop: TProperty; ButtonId: LongWord); override;
    procedure EditorDblClick(Sender, Data: TObject; Group: Word; Prop: TProperty); override;
  end;

  TModuleEditor = class (TEditor)
  protected
    function CheckOnInitializedConnectedDisconnectedParams(EventId: TIdentifier; Item: TProcFunc): Boolean;
  public
    procedure GetProperties(Sender, Data: TObject; Group: Word; var Properties: TProperties); override;
    procedure GetPropertyValue(Sender, Data: TObject; Group: Word; Prop: TProperty; var Value: WideString); override;
    procedure SetPropertyValue(Sender, Data: TObject; Group: Word; Prop: TProperty; Value: WideString); override;
    procedure UpdateListBoxContent(Sender, Data: TObject; Group: Word; Prop: TProperty; ListItems: TStrings; var ItemIndex: Integer); override;
    procedure PropertyButtonClick(Sender, Data: TObject; Group: Word; Prop: TProperty; ButtonId: LongWord); override;
    procedure EditorDblClick(Sender, Data: TObject; Group: Word; Prop: TProperty); override;
  end;

  TAnalogInputEditor = class (TEditor)
  private
    function CheckOnDataParams(EventId: TIdentifier; Item: TProcFunc): Boolean;
  public

    procedure GetProperties(Sender, Data: TObject; Group: Word; var Properties: TProperties); override;
    procedure GetPropertyValue(Sender, Data: TObject; Group: Word; Prop: TProperty; var Value: WideString); override;
    procedure SetPropertyValue(Sender, Data: TObject; Group: Word; Prop: TProperty; Value: WideString); override;
    procedure UpdateListBoxContent(Sender, Data: TObject; Group: Word; Prop: TProperty; ListItems: TStrings; var ItemIndex: Integer); override;
    procedure PropertyButtonClick(Sender, Data: TObject; Group: Word; Prop: TProperty; ButtonId: LongWord); override;
    procedure EditorDblClick(Sender, Data: TObject; Group: Word; Prop: TProperty); override;
  end;

  TDigitalInputEditor = class (TEditor)
  private
    function CheckOnOpenCloseParams(EventId: TIdentifier; Item: TProcFunc): Boolean;
  public
    procedure GetProperties(Sender, Data: TObject; Group: Word; var Properties: TProperties); override;
    procedure GetPropertyValue(Sender, Data: TObject; Group: Word; Prop: TProperty; var Value: WideString); override;
    procedure SetPropertyValue(Sender, Data: TObject; Group: Word; Prop: TProperty; Value: WideString); override;
    procedure UpdateListBoxContent(Sender, Data: TObject; Group: Word; Prop: TProperty; ListItems: TStrings; var ItemIndex: Integer); override;
    procedure PropertyButtonClick(Sender, Data: TObject; Group: Word; Prop: TProperty; ButtonId: LongWord); override;
    procedure EditorDblClick(Sender, Data: TObject; Group: Word; Prop: TProperty); override;
  end;

  TDigitalOutputEditor = class (TEditor)
    procedure GetProperties(Sender, Data: TObject; Group: Word; var Properties: TProperties); override;
    procedure GetPropertyValue(Sender, Data: TObject; Group: Word; Prop: TProperty; var Value: WideString); override;
    procedure SetPropertyValue(Sender, Data: TObject; Group: Word; Prop: TProperty; Value: WideString); override;
    procedure UpdateListBoxContent(Sender, Data: TObject; Group: Word; Prop: TProperty; ListItems: TStrings; var ItemIndex: Integer); override;
    procedure PropertyButtonClick(Sender, Data: TObject; Group: Word; Prop: TProperty; ButtonId: LongWord); override;
    procedure EditorDblClick(Sender, Data: TObject; Group: Word; Prop: TProperty); override;
  end;

  TRelayEditor = class (TEditor)
    procedure GetProperties(Sender, Data: TObject; Group: Word; var Properties: TProperties); override;
    procedure GetPropertyValue(Sender, Data: TObject; Group: Word; Prop: TProperty; var Value: WideString); override;
    procedure SetPropertyValue(Sender, Data: TObject; Group: Word; Prop: TProperty; Value: WideString); override;
    procedure UpdateListBoxContent(Sender, Data: TObject; Group: Word; Prop: TProperty; ListItems: TStrings; var ItemIndex: Integer); override;
    procedure PropertyButtonClick(Sender, Data: TObject; Group: Word; Prop: TProperty; ButtonId: LongWord); override;
    procedure EditorDblClick(Sender, Data: TObject; Group: Word; Prop: TProperty); override;
  end;

  TWiegandEditor = class (TEditor)
  private
    function CheckOnDataParams(EventId: TIdentifier; Item: TProcFunc): Boolean;
  public
    procedure GetProperties(Sender, Data: TObject; Group: Word; var Properties: TProperties); override;
    procedure GetPropertyValue(Sender, Data: TObject; Group: Word; Prop: TProperty; var Value: WideString); override;
    procedure SetPropertyValue(Sender, Data: TObject; Group: Word; Prop: TProperty; Value: WideString); override;
    procedure UpdateListBoxContent(Sender, Data: TObject; Group: Word; Prop: TProperty; ListItems: TStrings; var ItemIndex: Integer); override;
    procedure PropertyButtonClick(Sender, Data: TObject; Group: Word; Prop: TProperty; ButtonId: LongWord); override;
    procedure EditorDblClick(Sender, Data: TObject; Group: Word; Prop: TProperty); override;
  end;

  TRS232Editor = class (TEditor)
  private
    function CheckOnDataParams(EventId: TIdentifier; Item: TProcFunc): Boolean;
  public
    procedure GetProperties(Sender, Data: TObject; Group: Word; var Properties: TProperties); override;
    procedure GetPropertyValue(Sender, Data: TObject; Group: Word; Prop: TProperty; var Value: WideString); override;
    procedure SetPropertyValue(Sender, Data: TObject; Group: Word; Prop: TProperty; Value: WideString); override;
    procedure UpdateListBoxContent(Sender, Data: TObject; Group: Word; Prop: TProperty; ListItems: TStrings; var ItemIndex: Integer); override;
    procedure PropertyButtonClick(Sender, Data: TObject; Group: Word; Prop: TProperty; ButtonId: LongWord); override;
    procedure EditorDblClick(Sender, Data: TObject; Group: Word; Prop: TProperty); override;
  end;

  TRS485Editor = class (TEditor)
  private
    function CheckOnDataParams(EventId: TIdentifier; Item: TProcFunc): Boolean;
  public
    procedure GetProperties(Sender, Data: TObject; Group: Word; var Properties: TProperties); override;
    procedure GetPropertyValue(Sender, Data: TObject; Group: Word; Prop: TProperty; var Value: WideString); override;
    procedure SetPropertyValue(Sender, Data: TObject; Group: Word; Prop: TProperty; Value: WideString); override;
    procedure UpdateListBoxContent(Sender, Data: TObject; Group: Word; Prop: TProperty; ListItems: TStrings; var ItemIndex: Integer); override;
    procedure PropertyButtonClick(Sender, Data: TObject; Group: Word; Prop: TProperty; ButtonId: LongWord); override;
    procedure EditorDblClick(Sender, Data: TObject; Group: Word; Prop: TProperty); override;
  end;

  TMotorEditor = class (TEditor)
  public
    procedure GetProperties(Sender, Data: TObject; Group: Word; var Properties: TProperties); override;
    procedure GetPropertyValue(Sender, Data: TObject; Group: Word; Prop: TProperty; var Value: WideString); override;
    procedure SetPropertyValue(Sender, Data: TObject; Group: Word; Prop: TProperty; Value: WideString); override;
    procedure UpdateListBoxContent(Sender, Data: TObject; Group: Word; Prop: TProperty; ListItems: TStrings; var ItemIndex: Integer); override;
    procedure PropertyButtonClick(Sender, Data: TObject; Group: Word; Prop: TProperty; ButtonId: LongWord); override;
    procedure EditorDblClick(Sender, Data: TObject; Group: Word; Prop: TProperty); override;
  end;

  TFolderEditor = class (TEditor)
  public
    procedure GetProperties(Sender, Data: TObject; Group: Word; var Properties: TProperties); override;
    procedure GetPropertyValue(Sender, Data: TObject; Group: Word; Prop: TProperty; var Value: WideString); override;
    procedure SetPropertyValue(Sender, Data: TObject; Group: Word; Prop: TProperty; Value: WideString); override;
    procedure UpdateListBoxContent(Sender, Data: TObject; Group: Word; Prop: TProperty; ListItems: TStrings; var ItemIndex: Integer); override;
    procedure PropertyButtonClick(Sender, Data: TObject; Group: Word; Prop: TProperty; ButtonId: LongWord); override;
    procedure EditorDblClick(Sender, Data: TObject; Group: Word; Prop: TProperty); override;
  end;

implementation

uses
  FormMain, Resources, RegExpr;

{ TEditor }

{ Private declarations }

{ Protected declarations }

function TEditor.CheckEventHandler(Name: WideString): WideString;
var
  I: Integer;
  List: TProcFuncList;
begin
  Result := '';

  List := TProcFuncList.Create;
  try
    FillProcFuncList(Config.ConfigFile.GlobalData.Code, List);
    for I := 0 to List.Count - 1 do
      if (List[I].Kind = ptProcedure) and AnsiSameText(List[I].Name, Name) then
      begin
        Result := List[I].Name;
        Break;
      end;
  finally
    List.Free;
  end;
end;

procedure TEditor.GetEventHandlerList(CheckParamList: TCheckParamListCallback; EventId: TIdentifier; EventHandlers: TStrings; CurrentHandler: WideString; var CurrentIndex: Integer);
var
  I, Index: Integer;
  List: TProcFuncList;
begin
  List := TProcFuncList.Create;
  try
    FillProcFuncList(Config.ConfigFile.GlobalData.Code, List);
    for I := 0 to List.Count - 1 do
      if (List[I].Kind = ptProcedure) and Assigned(CheckParamList) and CheckParamList(EventId, List[I]) then
      begin
        Index := EventHandlers.Add(List[I].Name);
        if AnsiCompareText(CurrentHandler, List[I].Name) = 0 then
          CurrentIndex := Index;
      end;
  finally
    List.Free;
  end;
end;

function TEditor.CreateGotoEventHandler(CheckParamList: TCheckParamListCallback; EventId: TIdentifier; Parameters: String; var CurrentHandler: String): Integer;
var
  I: Integer;
  List: TProcFuncList;
  S: String;
begin
  Result := -1;

  List := TProcFuncList.Create;
  try
    FillProcFuncList(Config.ConfigFile.GlobalData.Code, List);

    for I := 0 to List.Count - 1 do
      if (List[I].Kind = ptProcedure) and CheckParamList(EventId, List[I]) and (AnsiCompareText(List[I].Name, CurrentHandler) = 0) then
      begin
        Result := List[I].Position;
        Break;
      end;

    if (Result = -1) and InputQuery(SEnterEventHandlerName, SName, CurrentHandler) then
    begin
      if not IsValidIdent(CurrentHandler) then
        raise Exception.CreateFmt(SErrorIsNotAValidEventHandlerName, [CurrentHandler]);
      for I := 0 to List.Count - 1 do
        if AnsiCompareText(List[I].Name, CurrentHandler) = 0 then
          raise Exception.Create(SErrorAProcedureByThatNameAlreadyExists);

      S := 'procedure ' + CurrentHandler + '(' + Parameters + ');'#13#10'begin'#13#10'  '#13#10'end;'#13#10;
      Result := Length(Config.ConfigFile.GlobalData.Code) + 2 + Length(S) - 10;
      if Config.ConfigFile.GlobalData.Code <> '' then
      begin
        Config.ConfigFile.GlobalData.Code := Config.ConfigFile.GlobalData.Code + #13#10 + S;
        Result := Result + 2;
      end
      else
        Config.ConfigFile.GlobalData.Code := S;
    end;
  finally
    List.Free;
  end;
end;

procedure TEditor.GotoEditorLine(Line: Integer);
begin
  // set carret position
  FCodeEditor.CaretX := 1;
  FCodeEditor.CaretY := Line;
  // if we are inside a newly created procedure body skip 2 spaces right
  if FCodeEditor.WordAtCursor = '' then
    FCodeEditor.CaretX := 3;
  // calculate top line
  FCodeEditor.TopLine := Line - ((FCodeEditor.Height div FCodeEditor.LineHeight) div 2);
  // make sure carret is in visible area
  FCodeEditor.EnsureCursorPosVisible;
end;

{ Public declarations }

constructor TEditor.Create(AConfig: TConfig; AEditor: TPropertyEditor; ACodeEditor: TSynEdit);
begin
  inherited Create;
  FConfig := AConfig;
  FEditor := AEditor;
  FCodeEditor := ACodeEditor;
end;

destructor TEditor.Destroy;
begin
  inherited Destroy;
end;

{ TEditorList }

{ Private declarations }

type
  TEditorAssociation = class (TObject)
    EditedClass: TClass;
    Editor: TEditor;
  end;

function TEditorList.GetItemByClass(EditedClass: TClass): TEditor;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to Count - 1 do
    if TEditorAssociation(Get(I)).EditedClass = EditedClass then
    begin
      Result := TEditorAssociation(Get(I)).Editor;
      Break;
    end;
end;

function TEditorList.GetItemByIndex(Index: Integer): TEditor;
begin
  Result := (TObject(Get(Index)) as TEditorAssociation).Editor;
end;

{ Public declarations }

procedure TEditorList.RegisterEditor(EditedClass: TClass; Editor: TEditor);
var
  Association: TEditorAssociation;
begin
  Assert(ByClass[EditedClass] = nil, Format('Error: editor for %s is already registered', [EditedClass.ClassName]));
  Association := TEditorAssociation.Create;
  Association.EditedClass := EditedClass;
  Association.Editor := Editor;
  Add(Association);
end;

procedure TEditorList.UnregisterEditor(Editor: TEditor);
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    if TEditorAssociation(Get(I)).Editor = Editor then
    begin
      TObject(Get(I)).Free;
      Delete(I);
      Exit;
    end;
  Assert(False, 'Error: editor not registered');
end;

{ TServerEditor }

{ Protected declarations }

function TServerEditor.CheckOnStartStopParams(EventId: TIdentifier; Item: TProcFunc): Boolean;
begin
  Result :=
    (Item.ParamCount = 1) and
    (AnsiCompareText(Item.Params[0].Type_, 'TPSServer') = 0);
end;

{ Public declarations }

procedure TServerEditor.GetProperties(Sender, Data: TObject; Group: Word; var Properties: TProperties);
begin
  Assert(Data is TServer, Format('Invalid object class %s', [Data.ClassName]));

  case Group of
    GROUP_PROPERTIES:
    begin
      SetLength(Properties, 4);
      Properties[0] := TPropertyEditor.MakeProperty(propidServerDataTitle, STitle);
      Properties[1] := TPropertyEditor.MakeProperty(propidServerDataDescription, SDescription);
      Properties[2] := TPropertyEditor.MakeProperty(propidServerDataTag, STag);
      Properties[3] := TPropertyEditor.MakeProperty(propidServerDataIP, SIPAddress);
    end;
    GROUP_EVENTS:
    begin
      SetLength(Properties, 2);
      Properties[0] := TPropertyEditor.MakeProperty(propidServerDataOnStart, SOnStart, 1);
      Properties[1] := TPropertyEditor.MakeProperty(propidServerDataOnStop, SOnStop, 1);
    end;
  end;
end;

procedure TServerEditor.GetPropertyValue(Sender, Data: TObject; Group: Word; Prop: TProperty; var Value: WideString);
begin
  Assert(Data is TServer, Format('Invalid object class %s', [Data.ClassName]));

  with Data as TServer do
    case Prop.Id of
      propidServerDataTag:
        Value := IntToStr(D.Tag);
      propidServerDataTitle:
        Value := D.Title;
      propidServerDataDescription:
        Value := D.Description;
      propidServerDataIP:
        Value := D.IP;
      propidServerDataOnStart:
        Value := CheckEventHandler(D.OnStart);
      propidServerDataOnStop:
        Value := CheckEventHandler(D.OnStop);
    end;
end;

procedure TServerEditor.SetPropertyValue(Sender, Data: TObject; Group: Word; Prop: TProperty; Value: WideString);
begin
  Assert(Data is TServer, Format('Invalid object class %s', [Data.ClassName]));

  with Data as TServer do
  begin
    case Prop.Id of
      propidServerDataTag:
        D.Tag := StrToInt(Value);
      propidServerDataTitle:
        D.Title := Value;
      propidServerDataDescription:
        D.Description := Value;
      propidServerDataIP:
        D.IP := Value;
      propidServerDataOnStart:
      begin
        D.OnStart := CheckEventHandler(Value);
        Value := D.OnStart;
      end;
      propidServerDataOnStop:
      begin
        D.OnStop := CheckEventHandler(Value);
        Value := D.OnStop;
      end;
    end;
    D.Modified := True;
  end;
end;

procedure TServerEditor.UpdateListBoxContent(Sender, Data: TObject; Group: Word; Prop: TProperty; ListItems: TStrings; var ItemIndex: Integer);
begin
  Assert(Data is TServer, Format('Invalid object class %s', [Data.ClassName]));

  with Data as TServer do
    case Prop.Id of
      propidServerDataOnStart:
        GetEventHandlerList(CheckOnStartStopParams, propidServerDataOnStart, ListItems, D.OnStart, ItemIndex);
      propidServerDataOnStop:
        GetEventHandlerList(CheckOnStartStopParams, propidServerDataOnStop, ListItems, D.OnStop, ItemIndex);
    end;
end;

procedure TServerEditor.PropertyButtonClick(Sender, Data: TObject; Group: Word; Prop: TProperty; ButtonId: LongWord);
begin
  Assert(Data is TServer, Format('Invalid object class %s', [Data.ClassName]));
end;

procedure TServerEditor.EditorDblClick(Sender, Data: TObject; Group: Word; Prop: TProperty);
var
  S: String;
  Index: Integer;
begin
  Assert(Data is TServer, Format('Invalid object class %s', [Data.ClassName]));

  with Data as TServer do
    case Prop.Id of
      propidServerDataOnStart:
      begin
        S := D.OnStart;
        Index := CreateGotoEventHandler(CheckOnStartStopParams, Prop.Id, 'Sender: TPSServer', S);
        if Index <> -1 then
        begin
          if D.OnStart <> S then
          begin
            D.OnStart := S;
            Config.ConfigFile.Modified := True;
            Editor.UpdateContent;
          end;
          FCodeEditor.Text := Config.ConfigFile.GlobalData.Code;
          GotoEditorLine(FCodeEditor.CharIndexToRowCol(Index).Line);
          FrmMain.PgcWorkspace.ActivePage := FrmMain.TbsCodeEditor;
          FCodeEditor.SetFocus;
        end;
      end;
      propidServerDataOnStop:
      begin
        S := D.OnStop;
        Index := CreateGotoEventHandler(CheckOnStartStopParams, Prop.Id, 'Sender: TPSServer', S);
        if Index <> -1 then
        begin
          if D.OnStop <> S then
          begin
            D.OnStop := S;
            Config.ConfigFile.Modified := True;
            Editor.UpdateContent;
          end;
          FCodeEditor.Text := Config.ConfigFile.GlobalData.Code;
          GotoEditorLine(FCodeEditor.CharIndexToRowCol(Index).Line);
          FrmMain.PgcWorkspace.ActivePage := FrmMain.TbsCodeEditor;
          FCodeEditor.SetFocus;
        end;
      end;
    end;
end;

{ TTimerEditor }

{ Private declarations }

function TTimerEditor.CheckOnTimerParams(EventId: TIdentifier; Item: TProcFunc): Boolean;
begin
  Result :=
    (Item.ParamCount = 1) and
    (AnsiCompareText(Item.Params[0].Type_, 'TPSTimer') = 0);
end;

{ Public declarations }

procedure TTimerEditor.GetProperties(Sender, Data: TObject; Group: Word; var Properties: TProperties);
begin
  Assert(Data is TTimer, Format('Invalid object class %s', [Data.ClassName]));

  case Group of
    GROUP_PROPERTIES:
    begin
      SetLength(Properties, 4);
      Properties[0] := TPropertyEditor.MakeProperty(propidTimerDataTitle, STitle);
      Properties[1] := TPropertyEditor.MakeProperty(propidTimerDataDescription, SDescription);
      Properties[2] := TPropertyEditor.MakeProperty(propidTimerDataInterval, SInterval);
      Properties[3] := TPropertyEditor.MakeProperty(propidTimerDataTag, STag);
    end;
    GROUP_EVENTS:
    begin
      SetLength(Properties, 1);
      Properties[0] := TPropertyEditor.MakeProperty(propidTimerDataOnTimer, SOnTimer, 1);
    end;
  end;
end;

procedure TTimerEditor.GetPropertyValue(Sender, Data: TObject; Group: Word; Prop: TProperty; var Value: WideString);
begin
  Assert(Data is TTimer, Format('Invalid object class %s', [Data.ClassName]));

  with Data as TTimer do
    case Prop.Id of
      propidTimerDataTag:
        Value := IntToStr(D.Tag);
      propidTimerDataInterval:
        Value := IntToStr(D.Interval);
      propidTimerDataTitle:
        Value := D.Title;
      propidTimerDataDescription:
        Value := D.Description;
      propidTimerDataOnTimer:
      begin
        D.OnTimer := CheckEventHandler(D.OnTimer);
        Value := D.OnTimer;
      end;
    end;
end;

procedure TTimerEditor.SetPropertyValue(Sender, Data: TObject; Group: Word; Prop: TProperty; Value: WideString);
begin
  Assert(Data is TTimer, Format('Invalid object class %s', [Data.ClassName]));

  with Data as TTimer do
  begin
    case Prop.Id of
      propidTimerDataTag:
        D.Tag := StrToInt(Value);
      propidTimerDataInterval:
        D.Interval := StrToInt(Value);
      propidTimerDataTitle:
        D.Title := Value;
      propidTimerDataDescription:
        D.Description := Value;
      propidTimerDataOnTimer:
        D.OnTimer := CheckEventHandler(Value);
    end;
    D.Modified := True;
  end;
end;

procedure TTimerEditor.UpdateListBoxContent(Sender, Data: TObject; Group: Word; Prop: TProperty; ListItems: TStrings; var ItemIndex: Integer);
begin
  Assert(Data is TTimer, Format('Invalid object class %s', [Data.ClassName]));

  with Data as TTimer do
    case Prop.Id of
      propidTimerDataOnTimer:
        GetEventHandlerList(CheckOnTimerParams, propidTimerDataOnTimer, ListItems, D.OnTimer, ItemIndex);
    end;
end;

procedure TTimerEditor.PropertyButtonClick(Sender, Data: TObject; Group: Word; Prop: TProperty; ButtonId: LongWord);
begin
  Assert(Data is TTimer, Format('Invalid object class %s', [Data.ClassName]));
end;

procedure TTimerEditor.EditorDblClick(Sender, Data: TObject; Group: Word; Prop: TProperty);
var
  Index: Integer;
  S: String;
begin
  Assert(Data is TTimer, Format('Invalid object class %s', [Data.ClassName]));

  with Data as TTimer do
    case Prop.Id of
      propidTimerDataOnTimer:
      begin
        S := D.OnTimer;
        Index := CreateGotoEventHandler(CheckOnTimerParams, Prop.Id, 'Sender: TPSTimer', S);
        if Index <> -1 then
        begin
          if D.OnTimer <> S then
          begin
            D.OnTimer := S;
            Config.ConfigFile.Modified := True;
            Editor.UpdateContent;
          end;
          FCodeEditor.Text := Config.ConfigFile.GlobalData.Code;
          GotoEditorLine(FCodeEditor.CharIndexToRowCol(Index).Line);
          FrmMain.PgcWorkspace.ActivePage := FrmMain.TbsCodeEditor;
          FCodeEditor.SetFocus;
        end;
      end;
    end;
end;

{ TModuleEditor }

{ Protected declarations }

function TModuleEditor.CheckOnInitializedConnectedDisconnectedParams(EventId: TIdentifier; Item: TProcFunc): Boolean;
begin
  Result :=
    (Item.ParamCount = 1) and
    (AnsiCompareText(Item.Params[0].Type_, 'TPSModule') = 0);
end;

{ Public declarations }

procedure TModuleEditor.GetProperties(Sender, Data: TObject; Group: Word; var Properties: TProperties);
begin
  Assert(Data is TModule, Format('Invalid object class %s', [Data.ClassName]));

  case Group of
    GROUP_PROPERTIES:
    begin
      SetLength(Properties, 6);
      Properties[0] := TPropertyEditor.MakeProperty(propidModuleDataTitle, STitle);
      Properties[1] := TPropertyEditor.MakeProperty(propidModuleDataDescription, SDescription);
      Properties[2] := TPropertyEditor.MakeProperty(propidModuleDataTag, STag);
      Properties[3] := TPropertyEditor.MakeProperty(propidModuleDataIP, SIPAddress);
      Properties[4] := TPropertyEditor.MakeProperty(propidModuleDataNetmask, SNetmask);
      Properties[5] := TPropertyEditor.MakeProperty(propidModuleDataMAC, SMACAddress);
    end;
    GROUP_EVENTS:
    begin
      SetLength(Properties, 3);
      Properties[0] := TPropertyEditor.MakeProperty(propidModuleDataOnConnected, SOnConnected, 1);
      Properties[1] := TPropertyEditor.MakeProperty(propidModuleDataOnDisconnected, SOnDisconnected, 1);
      Properties[2] := TPropertyEditor.MakeProperty(propidModuleDataOnInitialized, SOnInitialized, 1);
    end;
  end;
end;

procedure TModuleEditor.GetPropertyValue(Sender, Data: TObject; Group: Word; Prop: TProperty; var Value: WideString);
begin
  Assert(Data is TModule, Format('Invalid object class %s', [Data.ClassName]));

  with Data as TModule do
    case Prop.Id of
      propidModuleDataTag:
        Value := IntToStr(D.Tag);
      propidModuleDataTitle:
        Value := D.Title;
      propidModuleDataDescription:
        Value := D.Description;
      propidModuleDataIP:
        Value := D.IP;
      propidModuleDataNetmask:
        Value := D.Netmask;
      propidModuleDataMAC:
        Value := UpperCase(D.MAC);
      propidModuleDataOnInitialized:
      begin
        D.OnInitialized := CheckEventHandler(D.OnInitialized);
        Value := D.OnInitialized;
      end;
      propidModuleDataOnConnected:
      begin
        D.OnConnected := CheckEventHandler(D.OnConnected);
        Value := D.OnConnected;
      end;
      propidModuleDataOnDisconnected:
      begin
        D.OnDisconnected := CheckEventHandler(D.OnDisconnected);
        Value := D.OnDisconnected;
      end;
    end;
end;

procedure TModuleEditor.SetPropertyValue(Sender, Data: TObject; Group: Word; Prop: TProperty; Value: WideString);
begin
  Assert(Data is TModule, Format('Invalid object class %s', [Data.ClassName]));

  with Data as TModule do
  begin
    case Prop.Id of
      propidModuleDataTag:
        D.Tag := StrToInt(Value);
      propidModuleDataTitle:
        D.Title := Value;
      propidModuleDataDescription:
        D.Description := Value;
      propidModuleDataIP:
        D.IP := Value;
      propidModuleDataNetmask:
        D.Netmask := Value;
      propidModuleDataMAC:
        D.MAC := UpperCase(Value);
      propidModuleDataOnInitialized:
        D.OnInitialized := CheckEventHandler(Value);
      propidModuleDataOnConnected:
        D.OnConnected := CheckEventHandler(Value);
      propidModuleDataOnDisconnected:
        D.OnDisconnected := CheckEventHandler(Value);
    end;
    D.Modified := True;
  end;
end;

procedure TModuleEditor.UpdateListBoxContent(Sender, Data: TObject; Group: Word; Prop: TProperty; ListItems: TStrings; var ItemIndex: Integer);
begin
  Assert(Data is TModule, Format('Invalid object class %s', [Data.ClassName]));

  with Data as TModule do
    case Prop.Id of
      propidModuleDataOnInitialized:
        GetEventHandlerList(CheckOnInitializedConnectedDisconnectedParams, propidModuleDataOnInitialized, ListItems, D.OnInitialized, ItemIndex);
      propidModuleDataOnConnected:
        GetEventHandlerList(CheckOnInitializedConnectedDisconnectedParams, propidModuleDataOnConnected, ListItems, D.OnConnected, ItemIndex);
      propidModuleDataOnDisconnected:
        GetEventHandlerList(CheckOnInitializedConnectedDisconnectedParams, propidModuleDataOnDisconnected, ListItems, D.OnDisconnected, ItemIndex);
    end;
end;

procedure TModuleEditor.PropertyButtonClick(Sender, Data: TObject; Group: Word; Prop: TProperty; ButtonId: LongWord);
begin
  Assert(Data is TModule, Format('Invalid object class %s', [Data.ClassName]));
end;

procedure TModuleEditor.EditorDblClick(Sender, Data: TObject; Group: Word; Prop: TProperty);
var
  S: String;
  Index: Integer;
begin
  Assert(Data is TModule, Format('Invalid object class %s', [Data.ClassName]));

  with Data as TModule do
    case Prop.Id of
      propidModuleDataOnInitialized:
      begin
        S := D.OnInitialized;
        Index := CreateGotoEventHandler(CheckOnInitializedConnectedDisconnectedParams, Prop.Id, 'Sender: TPSModule', S);
        if Index <> -1 then
        begin
          if D.OnInitialized <> S then
          begin
            D.OnInitialized := S;
            Config.ConfigFile.Modified := True;
            Editor.UpdateContent;
          end;
          FCodeEditor.Text := Config.ConfigFile.GlobalData.Code;
          GotoEditorLine(FCodeEditor.CharIndexToRowCol(Index).Line);
          FrmMain.PgcWorkspace.ActivePage := FrmMain.TbsCodeEditor;
          FCodeEditor.SetFocus;
        end;
      end;
      propidModuleDataOnConnected:
      begin
        S := D.OnConnected;
        Index := CreateGotoEventHandler(CheckOnInitializedConnectedDisconnectedParams, Prop.Id, 'Sender: TPSModule', S);
        if Index <> -1 then
        begin
          if D.OnConnected <> S then
          begin
            D.OnConnected := S;
            Config.ConfigFile.Modified := True;
            Editor.UpdateContent;
          end;
          FCodeEditor.Text := Config.ConfigFile.GlobalData.Code;
          GotoEditorLine(FCodeEditor.CharIndexToRowCol(Index).Line);
          FrmMain.PgcWorkspace.ActivePage := FrmMain.TbsCodeEditor;
          FCodeEditor.SetFocus;
        end;
      end;
      propidModuleDataOnDisconnected:
      begin
        S := D.OnDisconnected;
        Index := CreateGotoEventHandler(CheckOnInitializedConnectedDisconnectedParams, Prop.Id, 'Sender: TPSModule', S);
        if Index <> -1 then
        begin
          if D.OnDisconnected <> S then
          begin
            D.OnDisconnected := S;
            Config.ConfigFile.Modified := True;
            Editor.UpdateContent;
          end;
          FCodeEditor.Text := Config.ConfigFile.GlobalData.Code;
          GotoEditorLine(FCodeEditor.CharIndexToRowCol(Index).Line);
          FrmMain.PgcWorkspace.ActivePage := FrmMain.TbsCodeEditor;
          FCodeEditor.SetFocus;
        end;
      end;
    end;
end;

{ TAnalogInputEditor }

{ Private declarations }

function TAnalogInputEditor.CheckOnDataParams(EventId: TIdentifier; Item: TProcFunc): Boolean;
begin
  Result :=
    (Item.ParamCount = 2) and
    (AnsiCompareText(Item.Params[0].Type_, 'TPSAnalogInput') = 0) and
    (AnsiCompareText(Item.Params[1].Type_, 'Integer') = 0);
end;

{ Public declarations }

procedure TAnalogInputEditor.GetProperties(Sender, Data: TObject; Group: Word; var Properties: TProperties);
begin
  Assert(Data is TAnalogInput, Format('Invalid object class %s', [Data.ClassName]));

  case Group of
    GROUP_PROPERTIES:
    begin
      SetLength(Properties, 4);
      Properties[0] := TPropertyEditor.MakeProperty(propidAnalogInputDataTitle, STitle);
      Properties[1] := TPropertyEditor.MakeProperty(propidAnalogInputDataDescription, SDescription);
      Properties[2] := TPropertyEditor.MakeProperty(propidAnalogInputDataDeltaChange, SDeltaChange);
      Properties[3] := TPropertyEditor.MakeProperty(propidAnalogInputDataTag, STag);
    end;
    GROUP_EVENTS:
    begin
      SetLength(Properties, 1);
      Properties[0] := TPropertyEditor.MakeProperty(propidAnalogInputDataOnData, SOnData, 1);
    end;
  end;
end;

procedure TAnalogInputEditor.GetPropertyValue(Sender, Data: TObject; Group: Word; Prop: TProperty; var Value: WideString);
begin
  Assert(Data is TAnalogInput, Format('Invalid object class %s', [Data.ClassName]));

  with Data as TAnalogInput do
    case Prop.Id of
      propidAnalogInputDataDeltaChange:
        Value := IntToStr(D.DeltaChange);
      propidAnalogInputDataTag:
        Value := IntToStr(D.Tag);
      propidAnalogInputDataTitle:
        Value := D.Title;
      propidAnalogInputDataDescription:
        Value := D.Description;
      propidAnalogInputDataOnData:
      begin
        D.OnData := CheckEventHandler(D.OnData);
        Value := D.OnData;
      end;
    end;
end;

procedure TAnalogInputEditor.SetPropertyValue(Sender, Data: TObject; Group: Word; Prop: TProperty; Value: WideString);
begin
  Assert(Data is TAnalogInput, Format('Invalid object class %s', [Data.ClassName]));

  with Data as TAnalogInput do
  begin
    case Prop.Id of
      propidAnalogInputDataDeltaChange:
        D.DeltaChange := StrToInt(Value);
      propidAnalogInputDataTag:
        D.Tag := StrToInt(Value);
      propidAnalogInputDataTitle:
        D.Title := Value;
      propidAnalogInputDataDescription:
        D.Description := Value;
      propidAnalogInputDataOnData:
        D.OnData := CheckEventHandler(Value);
    end;
    D.Modified := True;
  end;
end;

procedure TAnalogInputEditor.UpdateListBoxContent(Sender, Data: TObject; Group: Word; Prop: TProperty; ListItems: TStrings; var ItemIndex: Integer);
begin
  Assert(Data is TAnalogInput, Format('Invalid object class %s', [Data.ClassName]));

  with Data as TAnalogInput do
    case Prop.Id of
      propidAnalogInputDataOnData:
        GetEventHandlerList(CheckOnDataParams, propidAnalogInputDataOnData, ListItems, D.OnData, ItemIndex);
    end;
end;

procedure TAnalogInputEditor.PropertyButtonClick(Sender, Data: TObject; Group: Word; Prop: TProperty; ButtonId: LongWord);
begin
  Assert(Data is TAnalogInput, Format('Invalid object class %s', [Data.ClassName]));
end;

procedure TAnalogInputEditor.EditorDblClick(Sender, Data: TObject; Group: Word; Prop: TProperty);
var
  Index: Integer;
  S: String;
begin
  Assert(Data is TAnalogInput, Format('Invalid object class %s', [Data.ClassName]));

  with Data as TAnalogInput do
    case Prop.Id of
      propidAnalogInputDataOnData:
      begin
        S := D.OnData;
        Index := CreateGotoEventHandler(CheckOnDataParams, Prop.Id, 'Sender: TPSAnalogInput; Data: Integer', S);
        if Index <> -1 then
        begin
          if D.OnData <> S then
          begin
            D.OnData := S;
            Config.ConfigFile.Modified := True;
            Editor.UpdateContent;
          end;
          FCodeEditor.Text := Config.ConfigFile.GlobalData.Code;
          GotoEditorLine(FCodeEditor.CharIndexToRowCol(Index).Line);
          FrmMain.PgcWorkspace.ActivePage := FrmMain.TbsCodeEditor;
          FCodeEditor.SetFocus;
        end;
      end;
    end;
end;

{ TDigitalInputEditor }

{ Private declarations }

function TDigitalInputEditor.CheckOnOpenCloseParams(EventId: TIdentifier; Item: TProcFunc): Boolean;
begin
  Result :=
    (Item.ParamCount = 1) and
    (AnsiCompareText(Item.Params[0].Type_, 'TPSDigitalInput') = 0);
end;

{ Public declarations }

procedure TDigitalInputEditor.GetProperties(Sender, Data: TObject; Group: Word; var Properties: TProperties);
begin
  Assert(Data is TDigitalInput, Format('Invalid object class %s', [Data.ClassName]));

  case Group of
    GROUP_PROPERTIES:
    begin
      SetLength(Properties, 3);
      Properties[0] := TPropertyEditor.MakeProperty(propidDigitalInputDataTitle, STitle);
      Properties[1] := TPropertyEditor.MakeProperty(propidDigitalInputDataDescription, SDescription);
      Properties[2] := TPropertyEditor.MakeProperty(propidDigitalInputDataTag, STag);
    end;
    GROUP_EVENTS:
    begin
      SetLength(Properties, 2);
      Properties[0] := TPropertyEditor.MakeProperty(propidDigitalInputDataOnOpen, SOnOpen, 1);
      Properties[1] := TPropertyEditor.MakeProperty(propidDigitalInputDataOnClose, SOnClose, 1);
    end;
  end;
end;

procedure TDigitalInputEditor.GetPropertyValue(Sender, Data: TObject; Group: Word; Prop: TProperty; var Value: WideString);
begin
  Assert(Data is TDigitalInput, Format('Invalid object class %s', [Data.ClassName]));

  with Data as TDigitalInput do
    case Prop.Id of
      propidDigitalInputDataTag:
        Value := IntToStr(D.Tag);
      propidDigitalInputDataTitle:
        Value := D.Title;
      propidDigitalInputDataDescription:
        Value := D.Description;
      propidDigitalInputDataOnOpen:
      begin
        D.OnOpen := CheckEventHandler(D.OnOpen);
        Value := D.OnOpen;
      end;
      propidDigitalInputDataOnClose:
      begin
        D.OnClose := CheckEventHandler(D.OnClose);
        Value := D.OnClose;
      end;
    end;
end;

procedure TDigitalInputEditor.SetPropertyValue(Sender, Data: TObject; Group: Word; Prop: TProperty; Value: WideString);
begin
  Assert(Data is TDigitalInput, Format('Invalid object class %s', [Data.ClassName]));

  with Data as TDigitalInput do
  begin
    case Prop.Id of
      propidDigitalInputDataTag:
        D.Tag := StrToInt(Value);
      propidDigitalInputDataTitle:
        D.Title := Value;
      propidDigitalInputDataDescription:
        D.Description := Value;
      propidDigitalInputDataOnOpen:
        D.OnOpen := CheckEventHandler(Value);
      propidDigitalInputDataOnClose:
        D.OnClose := CheckEventHandler(Value);
    end;
    D.Modified := True;
  end;
end;

procedure TDigitalInputEditor.UpdateListBoxContent(Sender, Data: TObject; Group: Word; Prop: TProperty; ListItems: TStrings; var ItemIndex: Integer);
begin
  Assert(Data is TDigitalInput, Format('Invalid object class %s', [Data.ClassName]));

  with Data as TDigitalInput do
    case Prop.Id of
      propidDigitalInputDataOnOpen:
        GetEventHandlerList(CheckOnOpenCloseParams, propidDigitalInputDataOnOpen, ListItems, D.OnOpen, ItemIndex);
      propidDigitalInputDataOnClose:
        GetEventHandlerList(CheckOnOpenCloseParams, propidDigitalInputDataOnClose, ListItems, D.OnClose, ItemIndex);
    end;
end;

procedure TDigitalInputEditor.PropertyButtonClick(Sender, Data: TObject; Group: Word; Prop: TProperty; ButtonId: LongWord);
begin
  Assert(Data is TDigitalInput, Format('Invalid object class %s', [Data.ClassName]));
end;

procedure TDigitalInputEditor.EditorDblClick(Sender, Data: TObject; Group: Word; Prop: TProperty);
var
  Index: Integer;
  S: String;
begin
  Assert(Data is TDigitalInput, Format('Invalid object class %s', [Data.ClassName]));

  with Data as TDigitalInput do
    case Prop.Id of
      propidDigitalInputDataOnOpen:
      begin
        S := D.OnOpen;
        Index := CreateGotoEventHandler(CheckOnOpenCloseParams, Prop.Id, 'Sender: TPSDigitalInput', S);
        if Index <> -1 then
        begin
          if D.OnOpen <> S then
          begin
            D.OnOpen := S;
            Config.ConfigFile.Modified := True;
            Editor.UpdateContent;
          end;
          FCodeEditor.Text := Config.ConfigFile.GlobalData.Code;
          GotoEditorLine(FCodeEditor.CharIndexToRowCol(Index).Line);
          FrmMain.PgcWorkspace.ActivePage := FrmMain.TbsCodeEditor;
          FCodeEditor.SetFocus;
        end;
      end;
      propidDigitalInputDataOnClose:
      begin
        S := D.OnClose;
        Index := CreateGotoEventHandler(CheckOnOpenCloseParams, Prop.Id, 'Sender: TPSDigitalInput', S);
        if Index <> -1 then
        begin
          if D.OnClose <> S then
          begin
            D.OnClose := S;
            Config.ConfigFile.Modified := True;
            Editor.UpdateContent;
          end;
          FCodeEditor.Text := Config.ConfigFile.GlobalData.Code;
          GotoEditorLine(FCodeEditor.CharIndexToRowCol(Index).Line);
          FrmMain.PgcWorkspace.ActivePage := FrmMain.TbsCodeEditor;
          FCodeEditor.SetFocus;
        end;
      end;
    end;
end;

{ TDigitalOutputEditor }

procedure TDigitalOutputEditor.GetProperties(Sender, Data: TObject; Group: Word; var Properties: TProperties);
begin
  Assert(Data is TDigitalOutput, Format('Invalid object class %s', [Data.ClassName]));

  case Group of
    GROUP_PROPERTIES:
    begin
      SetLength(Properties, 3);
      Properties[0] := TPropertyEditor.MakeProperty(propidDigitalOutputDataTitle, STitle);
      Properties[1] := TPropertyEditor.MakeProperty(propidDigitalOutputDataDescription, SDescription);
      Properties[2] := TPropertyEditor.MakeProperty(propidDigitalOutputDataTag, STag);
    end;
    GROUP_EVENTS:
      SetLength(Properties, 0);
  end;
end;

procedure TDigitalOutputEditor.GetPropertyValue(Sender, Data: TObject; Group: Word; Prop: TProperty; var Value: WideString);
begin
  Assert(Data is TDigitalOutput, Format('Invalid object class %s', [Data.ClassName]));

  with Data as TDigitalOutput do
    case Prop.Id of
      propidDigitalOutputDataTag:
        Value := IntToStr(D.Tag);
      propidDigitalOutputDataTitle:
        Value := D.Title;
      propidDigitalOutputDataDescription:
        Value := D.Description;
    end;
end;

procedure TDigitalOutputEditor.SetPropertyValue(Sender, Data: TObject; Group: Word; Prop: TProperty; Value: WideString);
begin
  Assert(Data is TDigitalOutput, Format('Invalid object class %s', [Data.ClassName]));

  with Data as TDigitalOutput do
  begin
    case Prop.Id of
      propidDigitalOutputDataTag:
        D.Tag := StrToInt(Value);
      propidDigitalOutputDataTitle:
        D.Title := Value;
      propidDigitalOutputDataDescription:
        D.Description := Value;
    end;
    D.Modified := True;
  end;
end;

procedure TDigitalOutputEditor.UpdateListBoxContent(Sender, Data: TObject; Group: Word; Prop: TProperty; ListItems: TStrings; var ItemIndex: Integer);
begin
  Assert(Data is TDigitalOutput, Format('Invalid object class %s', [Data.ClassName]));
end;

procedure TDigitalOutputEditor.PropertyButtonClick(Sender, Data: TObject; Group: Word; Prop: TProperty; ButtonId: LongWord);
begin
  Assert(Data is TDigitalOutput, Format('Invalid object class %s', [Data.ClassName]));
end;

procedure TDigitalOutputEditor.EditorDblClick(Sender, Data: TObject; Group: Word; Prop: TProperty);
begin
  Assert(Data is TDigitalOutput, Format('Invalid object class %s', [Data.ClassName]));
end;

{ TRelayEditor }

procedure TRelayEditor.GetProperties(Sender, Data: TObject; Group: Word; var Properties: TProperties);
begin
  Assert(Data is TRelay, Format('Invalid object class %s', [Data.ClassName]));

  case Group of
    GROUP_PROPERTIES:
    begin
      SetLength(Properties, 3);
      Properties[0] := TPropertyEditor.MakeProperty(propidRelayDataTitle, STitle);
      Properties[1] := TPropertyEditor.MakeProperty(propidRelayDataDescription, SDescription);
      Properties[2] := TPropertyEditor.MakeProperty(propidRelayDataTag, STag);
    end;
    GROUP_EVENTS:
      SetLength(Properties, 0);
  end;
end;

procedure TRelayEditor.GetPropertyValue(Sender, Data: TObject; Group: Word; Prop: TProperty; var Value: WideString);
begin
  Assert(Data is TRelay, Format('Invalid object class %s', [Data.ClassName]));

  with Data as TRelay do
    case Prop.Id of
      propidRelayDataTag:
        Value := IntToStr(D.Tag);
      propidRelayDataTitle:
        Value := D.Title;
      propidRelayDataDescription:
        Value := D.Description;
    end;
end;

procedure TRelayEditor.SetPropertyValue(Sender, Data: TObject; Group: Word; Prop: TProperty; Value: WideString);
begin
  Assert(Data is TRelay, Format('Invalid object class %s', [Data.ClassName]));

  with Data as TRelay do
  begin
    case Prop.Id of
      propidRelayDataTag:
        D.Tag := StrToInt(Value);
      propidRelayDataTitle:
        D.Title := Value;
      propidRelayDataDescription:
        D.Description := Value;
    end;
    D.Modified := True;
  end;
end;

procedure TRelayEditor.UpdateListBoxContent(Sender, Data: TObject; Group: Word; Prop: TProperty; ListItems: TStrings; var ItemIndex: Integer);
begin
  Assert(Data is TRelay, Format('Invalid object class %s', [Data.ClassName]));
end;

procedure TRelayEditor.PropertyButtonClick(Sender, Data: TObject; Group: Word; Prop: TProperty; ButtonId: LongWord);
begin
  Assert(Data is TRelay, Format('Invalid object class %s', [Data.ClassName]));
end;

procedure TRelayEditor.EditorDblClick(Sender, Data: TObject; Group: Word; Prop: TProperty);
begin
  Assert(Data is TRelay, Format('Invalid object class %s', [Data.ClassName]));
end;

{ TWiegandEditor }

{ Private declarations }

function TWiegandEditor.CheckOnDataParams(EventId: TIdentifier; Item: TProcFunc): Boolean;
begin
  Result :=
    (Item.ParamCount = 2) and
    (AnsiCompareText(Item.Params[0].Type_, 'TPSWiegand') = 0) and
    (AnsiCompareText(Item.Params[1].Type_, 'Integer') = 0);
end;

{ Public declarations }

procedure TWiegandEditor.GetProperties(Sender, Data: TObject; Group: Word; var Properties: TProperties);
begin
  Assert(Data is TWiegand, Format('Invalid object class %s', [Data.ClassName]));

  case Group of
    GROUP_PROPERTIES:
    begin
      SetLength(Properties, 4);
      Properties[0] := TPropertyEditor.MakeProperty(propidWiegandDataTitle, STitle);
      Properties[1] := TPropertyEditor.MakeProperty(propidWiegandDataDescription, SDescription);
      Properties[2] := TPropertyEditor.MakeProperty(propidWiegandDataDataBits, SDataBits);
      Properties[3] := TPropertyEditor.MakeProperty(propidWiegandDataTag, STag);
    end;
    GROUP_EVENTS:
    begin
      SetLength(Properties, 1);
      Properties[0] := TPropertyEditor.MakeProperty(propidWiegandDataOnData, SOnData, 1);
    end;
  end;
end;

procedure TWiegandEditor.GetPropertyValue(Sender, Data: TObject; Group: Word; Prop: TProperty; var Value: WideString);
begin
  Assert(Data is TWiegand, Format('Invalid object class %s', [Data.ClassName]));

  with Data as TWiegand do
    case Prop.Id of
      propidWiegandDataTag:
        Value := IntToStr(D.Tag);
      propidWiegandDataDataBits:
        Value := IntToStr(D.DataBits);
      propidWiegandDataTitle:
        Value := D.Title;
      propidWiegandDataDescription:
        Value := D.Description;
      propidWiegandDataOnData:
      begin
        D.OnData := CheckEventHandler(D.OnData);
        Value := D.OnData;
      end;
    end;
end;

procedure TWiegandEditor.SetPropertyValue(Sender, Data: TObject; Group: Word; Prop: TProperty; Value: WideString);
begin
  Assert(Data is TWiegand, Format('Invalid object class %s', [Data.ClassName]));

  with Data as TWiegand do
  begin
    case Prop.Id of
      propidWiegandDataTag:
        D.Tag := StrToInt(Value);
      propidWiegandDataDataBits:
        D.DataBits := StrToInt(Value);
      propidWiegandDataTitle:
        D.Title := Value;
      propidWiegandDataDescription:
        D.Description := Value;
      propidWiegandDataOnData:
        D.OnData := CheckEventHandler(Value);
    end;
    D.Modified := True;
  end;
end;

procedure TWiegandEditor.UpdateListBoxContent(Sender, Data: TObject; Group: Word; Prop: TProperty; ListItems: TStrings; var ItemIndex: Integer);
begin
  Assert(Data is TWiegand, Format('Invalid object class %s', [Data.ClassName]));

  with Data as TWiegand do
    case Prop.Id of
      propidWiegandDataOnData:
        GetEventHandlerList(CheckOnDataParams, propidWiegandDataOnData, ListItems, D.OnData, ItemIndex);
    end;
end;

procedure TWiegandEditor.PropertyButtonClick(Sender, Data: TObject; Group: Word; Prop: TProperty; ButtonId: LongWord);
begin
  Assert(Data is TWiegand, Format('Invalid object class %s', [Data.ClassName]));
end;

procedure TWiegandEditor.EditorDblClick(Sender, Data: TObject; Group: Word; Prop: TProperty);
var
  Index: Integer;
  S: String;
begin
  Assert(Data is TWiegand, Format('Invalid object class %s', [Data.ClassName]));

  with Data as TWiegand do
    case Prop.Id of
      propidWiegandDataOnData:
      begin
        S := D.OnData;
        Index := CreateGotoEventHandler(CheckOnDataParams, Prop.Id, 'Sender: TPSWiegand; Data: Integer', S);
        if Index <> -1 then
        begin
          if D.OnData <> S then
          begin
            D.OnData := S;
            Config.ConfigFile.Modified := True;
            Editor.UpdateContent;
          end;
          FCodeEditor.Text := Config.ConfigFile.GlobalData.Code;
          GotoEditorLine(FCodeEditor.CharIndexToRowCol(Index).Line);
          FrmMain.PgcWorkspace.ActivePage := FrmMain.TbsCodeEditor;
          FCodeEditor.SetFocus;
        end;
      end;
    end;
end;

{ TRS232Editor }

{ Private declarations }

function TRS232Editor.CheckOnDataParams(EventId: TIdentifier; Item: TProcFunc): Boolean;
begin
  Result :=
    (Item.ParamCount = 2) and
    (AnsiCompareText(Item.Params[0].Type_, 'TPSRS232') = 0) and
    (AnsiCompareText(Item.Params[1].Type_, 'Char') = 0);
end;

{ Public declarations }

procedure TRS232Editor.GetProperties(Sender, Data: TObject; Group: Word; var Properties: TProperties);
begin
  Assert(Data is TRS232, Format('Invalid object class %s', [Data.ClassName]));

  case Group of
    GROUP_PROPERTIES:
    begin
      SetLength(Properties, 7);
      Properties[0] := TPropertyEditor.MakeProperty(propidRS232DataTitle, STitle);
      Properties[1] := TPropertyEditor.MakeProperty(propidRS232DataDescription, SDescription);
      Properties[2] := TPropertyEditor.MakeProperty(propidRS232DataBitrate, SBitrate, 1);
      Properties[3] := TPropertyEditor.MakeProperty(propidRS232DataDataBits, SDataBits, 1);
      Properties[4] := TPropertyEditor.MakeProperty(propidRS232DataParity, SParity , 1);
      Properties[5] := TPropertyEditor.MakeProperty(propidRS232DataStopBits, SStopBits, 1);
      Properties[6] := TPropertyEditor.MakeProperty(propidRS232DataTag, STag);
    end;
    GROUP_EVENTS:
    begin
      SetLength(Properties, 1);
      Properties[0] := TPropertyEditor.MakeProperty(propidRS232DataOnData, SOnData, 1);
    end;
  end;
end;

procedure TRS232Editor.GetPropertyValue(Sender, Data: TObject; Group: Word; Prop: TProperty; var Value: WideString);
begin
  Assert(Data is TRS232, Format('Invalid object class %s', [Data.ClassName]));

  with Data as TRS232 do
    case Prop.Id of
      propidRS232DataTag:
        Value := IntToStr(D.Tag);
      propidRS232DataBitrate:
        Value := BITRATE[D.Bitrate];
      propidRS232DataDataBits:
        Value := DATABITS[D.DataBits];
      propidRS232DataParity:
        Value := PARITY[D.Parity];
      propidRS232DataStopBits:
        Value := STOPBITS[D.StopBits];
      propidRS232DataTitle:
        Value := D.Title;
      propidRS232DataDescription:
        Value := D.Description;
      propidRS232DataOnData:
      begin
        D.OnData := CheckEventHandler(D.OnData);
        Value := D.OnData;
      end;
    end;
end;

procedure TRS232Editor.SetPropertyValue(Sender, Data: TObject; Group: Word; Prop: TProperty; Value: WideString);
var
  I: Integer;
begin
  Assert(Data is TRS232, Format('Invalid object class %s', [Data.ClassName]));

  with Data as TRS232 do
  begin
    case Prop.Id of
      propidRS232DataTag:
        D.Tag := StrToInt(Value);
      propidRS232DataBitrate:
        for I := 0 to Length(BITRATE) - 1 do
          if AnsiCompareText(BITRATE[I], Value) = 0 then
          begin
            D.Bitrate := I;
            Break;
          end;
      propidRS232DataDataBits:
        for I := 0 to Length(DATABITS) - 1 do
          if AnsiCompareText(DATABITS[I], Value) = 0 then
          begin
            D.DataBits := I;
            Break;
          end;
      propidRS232DataParity:
        for I := 0 to Length(PARITY) - 1 do
          if AnsiCompareText(PARITY[I], Value) = 0 then
          begin
            D.Parity := I;
            Break;
          end;
      propidRS232DataStopBits:
        for I := 0 to Length(STOPBITS) - 1 do
          if AnsiCompareText(STOPBITS[I], Value) = 0 then
          begin
            D.StopBits := I;
            Break;
          end;
      propidRS232DataTitle:
        D.Title := Value;
      propidRS232DataDescription:
        D.Description := Value;
      propidRS232DataOnData:
        D.OnData := CheckEventHandler(Value);
    end;
    D.Modified := True;
  end;
end;

procedure TRS232Editor.UpdateListBoxContent(Sender, Data: TObject; Group: Word; Prop: TProperty; ListItems: TStrings; var ItemIndex: Integer);
var
  I: Integer;
begin
  Assert(Data is TRS232, Format('Invalid object class %s', [Data.ClassName]));

  with Data as TRS232 do
    case Prop.Id of
      propidRS232DataOnData:
        GetEventHandlerList(CheckOnDataParams, propidRS232DataOnData, ListItems, D.OnData, ItemIndex);
      propidRS232DataBitrate:
      begin
        for I := 0 to Length(BITRATE) - 1 do
          ListItems.Add(BITRATE[I]);
        ItemIndex := D.Bitrate;
      end;
      propidRS232DataDataBits:
      begin
        for I := 0 to Length(DATABITS) - 1 do
          ListItems.Add(DATABITS[I]);
        ItemIndex := D.DataBits;
      end;
      propidRS232DataParity:
      begin
        for I := 0 to Length(PARITY) - 1 do
          ListItems.Add(PARITY[I]);
        ItemIndex := D.Parity;
      end;
      propidRS232DataStopBits:
      begin
        for I := 0 to Length(STOPBITS) - 1 do
          ListItems.Add(STOPBITS[I]);
        ItemIndex := D.StopBits;
      end;
    end;
end;

procedure TRS232Editor.PropertyButtonClick(Sender, Data: TObject; Group: Word; Prop: TProperty; ButtonId: LongWord);
begin
  Assert(Data is TRS232, Format('Invalid object class %s', [Data.ClassName]));
end;

procedure TRS232Editor.EditorDblClick(Sender, Data: TObject; Group: Word; Prop: TProperty);
var
  Index: Integer;
  S: String;
begin
  Assert(Data is TRS232, Format('Invalid object class %s', [Data.ClassName]));

  with Data as TRS232 do
    case Prop.Id of
      propidRS232DataOnData:
      begin
        S := D.OnData;
        Index := CreateGotoEventHandler(CheckOnDataParams, Prop.Id, 'Sender: TPSRS232; Data: Char', S);
        if Index <> -1 then
        begin
          if D.OnData <> S then
          begin
            D.OnData := S;
            Config.ConfigFile.Modified := True;
            Editor.UpdateContent;
          end;
          FCodeEditor.Text := Config.ConfigFile.GlobalData.Code;
          GotoEditorLine(FCodeEditor.CharIndexToRowCol(Index).Line);
          FrmMain.PgcWorkspace.ActivePage := FrmMain.TbsCodeEditor;
          FCodeEditor.SetFocus;
        end;
      end;
    end;
end;

{ TRS485Editor }

{ Private declarations }

function TRS485Editor.CheckOnDataParams(EventId: TIdentifier; Item: TProcFunc): Boolean;
begin
  Result :=
    (Item.ParamCount = 2) and
    (AnsiCompareText(Item.Params[0].Type_, 'TPSRS485') = 0) and
    (AnsiCompareText(Item.Params[1].Type_, 'Char') = 0);
end;

{ Public declarations }

procedure TRS485Editor.GetProperties(Sender, Data: TObject; Group: Word; var Properties: TProperties);
begin
  Assert(Data is TRS485, Format('Invalid object class %s', [Data.ClassName]));

  case Group of
    GROUP_PROPERTIES:
    begin
      SetLength(Properties, 7);
      Properties[0] := TPropertyEditor.MakeProperty(propidRS485DataTitle, STitle);
      Properties[1] := TPropertyEditor.MakeProperty(propidRS485DataDescription, SDescription);
      Properties[2] := TPropertyEditor.MakeProperty(propidRS485DataBitrate, SBitrate, 1);
      Properties[3] := TPropertyEditor.MakeProperty(propidRS485DataDataBits, SDataBits, 1);
      Properties[4] := TPropertyEditor.MakeProperty(propidRS485DataParity, SParity , 1);
      Properties[5] := TPropertyEditor.MakeProperty(propidRS485DataStopBits, SStopBits, 1);
      Properties[6] := TPropertyEditor.MakeProperty(propidRS485DataTag, STag);
    end;
    GROUP_EVENTS:
    begin
      SetLength(Properties, 1);
      Properties[0] := TPropertyEditor.MakeProperty(propidRS485DataOnData, SOnData, 1);
    end;
  end;
end;

procedure TRS485Editor.GetPropertyValue(Sender, Data: TObject; Group: Word; Prop: TProperty; var Value: WideString);
begin
  Assert(Data is TRS485, Format('Invalid object class %s', [Data.ClassName]));

  with Data as TRS485 do
    case Prop.Id of
      propidRS485DataTag:
        Value := IntToStr(D.Tag);
      propidRS485DataBitrate:
        Value := BITRATE[D.Bitrate];
      propidRS485DataDataBits:
        Value := DATABITS[D.DataBits];
      propidRS485DataParity:
        Value := PARITY[D.Parity];
      propidRS485DataStopBits:
        Value := STOPBITS[D.StopBits];
      propidRS485DataTitle:
        Value := D.Title;
      propidRS485DataDescription:
        Value := D.Description;
      propidRS485DataOnData:
      begin
        D.OnData := CheckEventHandler(D.OnData);
        Value := D.OnData;
      end;
    end;
end;

procedure TRS485Editor.SetPropertyValue(Sender, Data: TObject; Group: Word; Prop: TProperty; Value: WideString);
var
  I: Integer;
begin
  Assert(Data is TRS485, Format('Invalid object class %s', [Data.ClassName]));

  with Data as TRS485 do
  begin
    case Prop.Id of
      propidRS485DataTag:
        D.Tag := StrToInt(Value);
      propidRS485DataBitrate:
        for I := 0 to Length(BITRATE) - 1 do
          if AnsiCompareText(BITRATE[I], Value) = 0 then
          begin
            D.Bitrate := I;
            Break;
          end;
      propidRS485DataDataBits:
        for I := 0 to Length(DATABITS) - 1 do
          if AnsiCompareText(DATABITS[I], Value) = 0 then
          begin
            D.DataBits := I;
            Break;
          end;
      propidRS485DataParity:
        for I := 0 to Length(PARITY) - 1 do
          if AnsiCompareText(PARITY[I], Value) = 0 then
          begin
            D.Parity := I;
            Break;
          end;
      propidRS485DataStopBits:
        for I := 0 to Length(STOPBITS) - 1 do
          if AnsiCompareText(STOPBITS[I], Value) = 0 then
          begin
            D.StopBits := I;
            Break;
          end;
      propidRS485DataTitle:
        D.Title := Value;
      propidRS485DataDescription:
        D.Description := Value;
      propidRS485DataOnData:
        D.OnData := CheckEventHandler(Value);
    end;
    D.Modified := True;
  end;
end;

procedure TRS485Editor.UpdateListBoxContent(Sender, Data: TObject; Group: Word; Prop: TProperty; ListItems: TStrings; var ItemIndex: Integer);
var
  I: Integer;
begin
  Assert(Data is TRS485, Format('Invalid object class %s', [Data.ClassName]));

  with Data as TRS485 do
    case Prop.Id of
      propidRS485DataOnData:
        GetEventHandlerList(CheckOnDataParams, propidRS485DataOnData, ListItems, D.OnData, ItemIndex);
      propidRS485DataBitrate:
      begin
        for I := 0 to Length(BITRATE) - 1 do
          ListItems.Add(BITRATE[I]);
        ItemIndex := D.Bitrate;
      end;
      propidRS485DataDataBits:
      begin
        for I := 0 to Length(DATABITS) - 1 do
          ListItems.Add(DATABITS[I]);
        ItemIndex := D.DataBits;
      end;
      propidRS485DataParity:
      begin
        for I := 0 to Length(PARITY) - 1 do
          ListItems.Add(PARITY[I]);
        ItemIndex := D.Parity;
      end;
      propidRS485DataStopBits:
      begin
        for I := 0 to Length(STOPBITS) - 1 do
          ListItems.Add(STOPBITS[I]);
        ItemIndex := D.StopBits;
      end;
    end;
end;

procedure TRS485Editor.PropertyButtonClick(Sender, Data: TObject; Group: Word; Prop: TProperty; ButtonId: LongWord);
begin
  Assert(Data is TRS485, Format('Invalid object class %s', [Data.ClassName]));
end;

procedure TRS485Editor.EditorDblClick(Sender, Data: TObject; Group: Word; Prop: TProperty);
var
  Index: Integer;
  S: String;
begin
  Assert(Data is TRS485, Format('Invalid object class %s', [Data.ClassName]));

  with Data as TRS485 do
    case Prop.Id of
      propidRS485DataOnData:
      begin
        S := D.OnData;
        Index := CreateGotoEventHandler(CheckOnDataParams, Prop.Id, 'Sender: TPSRS485; Data: Char', S);
        if Index <> -1 then
        begin
          if D.OnData <> S then
          begin
            D.OnData := S;
            Config.ConfigFile.Modified := True;
            Editor.UpdateContent;
          end;
          FCodeEditor.Text := Config.ConfigFile.GlobalData.Code;
          GotoEditorLine(FCodeEditor.CharIndexToRowCol(Index).Line);
          FrmMain.PgcWorkspace.ActivePage := FrmMain.TbsCodeEditor;
          FCodeEditor.SetFocus;
        end;
      end;
    end;
end;

{ TMotorEditor }

procedure TMotorEditor.GetProperties(Sender, Data: TObject; Group: Word; var Properties: TProperties);
begin
  Assert(Data is TMotor, Format('Invalid object class %s', [Data.ClassName]));

  case Group of
    GROUP_PROPERTIES:
    begin
      SetLength(Properties, 3);
      Properties[0] := TPropertyEditor.MakeProperty(propidMotorDataTitle, STitle);
      Properties[1] := TPropertyEditor.MakeProperty(propidMotorDataDescription, SDescription);
      Properties[2] := TPropertyEditor.MakeProperty(propidMotorDataTag, STag);
    end;
    GROUP_EVENTS:
      SetLength(Properties, 0);
  end;
end;

procedure TMotorEditor.GetPropertyValue(Sender, Data: TObject; Group: Word; Prop: TProperty; var Value: WideString);
begin
  Assert(Data is TMotor, Format('Invalid object class %s', [Data.ClassName]));

  with Data as TMotor do
    case Prop.Id of
      propidMotorDataTag:
        Value := IntToStr(D.Tag);
      propidMotorDataTitle:
        Value := D.Title;
      propidMotorDataDescription:
        Value := D.Description;
    end;
end;

procedure TMotorEditor.SetPropertyValue(Sender, Data: TObject; Group: Word; Prop: TProperty; Value: WideString);
begin
  Assert(Data is TMotor, Format('Invalid object class %s', [Data.ClassName]));

  with Data as TMotor do
  begin
    case Prop.Id of
      propidMotorDataTag:
        D.Tag := StrToInt(Value);
      propidMotorDataTitle:
        D.Title := Value;
      propidMotorDataDescription:
        D.Description := Value;
    end;
    D.Modified := True;
  end;
end;

procedure TMotorEditor.UpdateListBoxContent(Sender, Data: TObject; Group: Word; Prop: TProperty; ListItems: TStrings; var ItemIndex: Integer);
begin
  Assert(Data is TMotor, Format('Invalid object class %s', [Data.ClassName]));
end;

procedure TMotorEditor.PropertyButtonClick(Sender, Data: TObject; Group: Word; Prop: TProperty; ButtonId: LongWord);
begin
  Assert(Data is TMotor, Format('Invalid object class %s', [Data.ClassName]));
end;

procedure TMotorEditor.EditorDblClick(Sender, Data: TObject; Group: Word; Prop: TProperty);
begin
  Assert(Data is TMotor, Format('Invalid object class %s', [Data.ClassName]));
end;

{ TFolderEditor }

{ Public declarations }

procedure TFolderEditor.GetProperties(Sender, Data: TObject; Group: Word; var Properties: TProperties);
begin
  Assert(Data is TFolder, Format('Invalid object class %s', [Data.ClassName]));

  case Group of
    GROUP_PROPERTIES:
    begin
      SetLength(Properties, 1);
      Properties[0] := TPropertyEditor.MakeProperty(propidFolderDataTitle, STitle);
    end;
    GROUP_EVENTS: ;
  end;
end;

procedure TFolderEditor.GetPropertyValue(Sender, Data: TObject; Group: Word; Prop: TProperty; var Value: WideString);
begin
  Assert(Data is TFolder, Format('Invalid object class %s', [Data.ClassName]));

  with Data as TFolder do
    case Prop.Id of
      propidFolderDataTitle:
        Value := D.Title;
    end;
end;

procedure TFolderEditor.SetPropertyValue(Sender, Data: TObject; Group: Word; Prop: TProperty; Value: WideString);
begin
  Assert(Data is TFolder, Format('Invalid object class %s', [Data.ClassName]));

  with Data as TFolder do
    case Prop.Id of
      propidFolderDataTitle:
        D.Title := Value;
    end;
end;

procedure TFolderEditor.UpdateListBoxContent(Sender, Data: TObject; Group: Word; Prop: TProperty; ListItems: TStrings; var ItemIndex: Integer);
begin
  Assert(Data is TFolder, Format('Invalid object class %s', [Data.ClassName]));
end;

procedure TFolderEditor.PropertyButtonClick(Sender, Data: TObject; Group: Word; Prop: TProperty; ButtonId: LongWord);
begin
  Assert(Data is TFolder, Format('Invalid object class %s', [Data.ClassName]));
end;

procedure TFolderEditor.EditorDblClick(Sender, Data: TObject; Group: Word; Prop: TProperty);
begin
  Assert(Data is TFolder, Format('Invalid object class %s', [Data.ClassName]));
end;

end.

