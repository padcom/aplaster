unit PaintBoxEx;

interface

uses
  Windows, Messages, Classes, Graphics, Controls, ExtCtrls, Forms;

type
  TPaintBoxEx = class (TPaintBox)
  private
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
  public
    constructor Create(AOwner: TComponent); override;
  end;

procedure Register;

implementation

{ TPaintBoxEx }

{ Private declarations }

procedure TPaintBoxEx.WMEraseBkgnd(var Message: TWMEraseBkgnd);
begin
end;

{ Public declarations }

constructor TPaintBoxEx.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csOpaque];
end;

{ *** }

procedure Register;
begin
  RegisterComponents('PxVCL', [TPaintBoxEx]);
end;

end.
