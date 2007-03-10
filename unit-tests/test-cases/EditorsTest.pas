unit EditorsTest;

interface

uses
  Classes, SysUtils, TestFramework,
  Editors;
  
type
  TEditorsTest = class (TTestCase)
  published
  end;

implementation

{ TEditorsTest }

initialization
  RegisterTest('', TEditorsTest.Suite);

end.

