// ----------------------------------------------------------------------------
// file: FormEvaluate.pas
// date: 2005-09-08
// auth: Matthias "Padcom" Hryniszak
// desc: Functions list window of the cfged application.
// ----------------------------------------------------------------------------

unit FormFunctionList;

{$IFOPT D+}
  {$DEFINE DEBUG}
{$ENDIF}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;
                  
type
  TFrmFunctionList = class(TForm)
    LblList: TLabel;
    BtnOk: TButton;
    BtnCancel: TButton;
    LivItems: TListView;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormResize(Sender: TObject);
    procedure LivItemsDblClick(Sender: TObject);
  private
    { Private declarations }
    procedure AssignLanguage;
  public
    { Public declarations }
  end;

implementation

uses
  Resources;

{$R *.dfm}

{ Private declarations }

procedure TFrmFunctionList.AssignLanguage;
begin
  Caption := SFunctionsAndProcedures;
  LblList.Caption := SList;
  BtnOk.Caption := SOk;
  BtnCancel.Caption := SCancel;
  LivItems.Columns[0].Caption := SName;
  LivItems.Columns[1].Caption := SType;
  LivItems.Columns[2].Caption := SLine;
end;

{ Public declarations }

procedure TFrmFunctionList.FormCreate(Sender: TObject);
begin
  LivItems.Columns.Add;
  LivItems.Columns.Add;
  LivItems.Columns.Add;
  AssignLanguage;
end;

procedure TFrmFunctionList.FormDestroy(Sender: TObject);
begin
//
end;

procedure TFrmFunctionList.FormShow(Sender: TObject);
begin
  FormResize(Sender);
  LivItems.SetFocus;
  LivItems.ItemIndex := 0;
end;

procedure TFrmFunctionList.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
//
end;

procedure TFrmFunctionList.FormResize(Sender: TObject);
begin
  LivItems.Columns[1].Width := 120;
  LivItems.Columns[2].Width := 50;
  LivItems.Columns[0].Width := LivItems.ClientWidth - LivItems.Columns[1].Width - LivItems.Columns[2].Width;
end;

procedure TFrmFunctionList.LivItemsDblClick(Sender: TObject);
var
  P: TPoint;
begin
  P := LivItems.ScreenToClient(Mouse.CursorPos);
  if BtnOk.Enabled and Assigned(LivItems.GetItemAt(P.X, P.Y)) then
    BtnOk.Click;
end;

end.
