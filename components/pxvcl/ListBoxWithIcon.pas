unit ListBoxWithIcon;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TGetImageIndexEvent = procedure (Sender: TObject; Index: Integer; var ImageIndex: Integer) of object;

  TListBoxWithIcon = class(TListBox)
  private
    { Private declarations }
    FImages: TImageList;
    FGetImageIndex: TGetImageIndexEvent;
    procedure CNDrawItem(var Message: TWMDrawItem); message CN_DRAWITEM;
  protected
    { Protected declarations }
    procedure DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState); override;
  public
    { Public declarations }
  published
    { Published declarations }
    property Images: TImageList read FImages write FImages;
    property OnGetImageIndex: TGetImageIndexEvent read FGetImageIndex write FGetImageIndex;
  end;

procedure Register;

implementation

{ TListBoxWithIcon }

procedure TListBoxWithIcon.CNDrawItem(var Message: TWMDrawItem);
var
  IconWidth: Integer;
begin
  if Assigned(Images) then
    IconWidth := Images.Width
  else
    IconWidth := 0;
  with Message.DrawItemStruct^ do
    if not UseRightToLeftAlignment then
      rcItem.Left := rcItem.Left + IconWidth
    else
      rcItem.Right := rcItem.Right - IconWidth;
  inherited;
end;

procedure TListBoxWithIcon.DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  ImageIndex: Integer;
  Bitmap: TBitmap;
  IconWidth, IconHeight: Integer;
begin
  if Assigned(Images) then
  begin
    IconWidth := Images.Width;
    IconHeight := Images.Height;
  end
  else
  begin
    IconWidth := 0;
    IconHeight := 0;
  end;
  if Assigned(FGetImageIndex) and Assigned(FImages) then
  begin
    FGetImageIndex(Self, Index, ImageIndex);
    if ImageIndex > -1 then
    begin
      Bitmap := TBitmap.Create;
      FImages.GetBitmap(ImageIndex, Bitmap);
      Canvas.Draw(Rect.Left - IconWidth, Rect.Top + ((Rect.Bottom - Rect.Top - IconHeight) div 2), Bitmap);
      Bitmap.Free;
    end;
  end;
  inherited;
end;

{ *** }

procedure Register;
begin
  RegisterComponents('PxVCL', [TListBoxWithIcon]);
end;

end.


