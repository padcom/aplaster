// ----------------------------------------------------------------------------
// file: FormDebugEvaluate.pas
// date: 2005-09-08
// auth: Matthias "Padcom" Hryniszak
// desc: Evaluate window of the cfged application.
// ----------------------------------------------------------------------------

unit FormDebugEvaulate;

{$IFOPT D+}
  {$DEFINE DEBUG}
{$ENDIF}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Menus;
                  
type
  TFrmDebugEvaluate = class(TForm)
    LblExpression: TLabel;
    CbbExpression: TComboBox;
    LblResult: TLabel;
    MemResult: TMemo;
    LblNewValue: TLabel;
    CbbNewValue: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormResize(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure CbbExpressionKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure CbbNewValueKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
    procedure AssignLanguage;
  public
    { Public declarations }
  end;

var
  FrmDebugEvaluate: TFrmDebugEvaluate;

implementation

uses
  Resources, FormDebugMain;

{$R *.dfm}

{ Private declarations }

procedure TFrmDebugEvaluate.AssignLanguage;
begin
  Caption := StripHotkey(SEvaluateModify);
  LblExpression.Caption := SExpression + ':';
  CbbExpression.Clear;
  LblResult.Caption := SResult + ':';
  MemResult.Clear;
  LblNewValue.Caption := SNewValue + ':';
  CbbNewValue.Clear;
end;

{ Public declarations }

procedure TFrmDebugEvaluate.FormCreate(Sender: TObject);
begin
  AssignLanguage;
end;

procedure TFrmDebugEvaluate.FormDestroy(Sender: TObject);
begin
//
end;

procedure TFrmDebugEvaluate.FormShow(Sender: TObject);
begin
//
end;

procedure TFrmDebugEvaluate.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
//
end;

procedure TFrmDebugEvaluate.FormResize(Sender: TObject);
begin
//
end;

procedure TFrmDebugEvaluate.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE:
      Close;
  end;
end;

procedure TFrmDebugEvaluate.CbbExpressionKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_RETURN:
    begin
      // reevaluate the expression
      MemResult.Text := FrmDebugMain.Debugger.GetVarContents(CbbExpression.Text);
      // "simulate" delphi behaviour :)
      CbbExpression.SelectAll;
      Key := 0;
    end;
  end;
end;

procedure TFrmDebugEvaluate.CbbNewValueKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
// todo: modify the value of expression being evaluated
//  case Key of
//    VK_RETURN:
//    begin
//      FrmMain.Debugger.Exec.GetVar2(CbbExpression.Text)^.
//      Key := 0;
//    end;
//  end;
end;

end.
