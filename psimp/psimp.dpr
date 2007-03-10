// ----------------------------------------------------------------------------
// file: pasimp.dpr - a part of AplaSter system
// date: 2005-09-08
// auth: Matthias Hryniszak
// desc: pascal script importer project file
// ----------------------------------------------------------------------------

program psimp;

{$APPTYPE CONSOLE}

uses
  FastMM4, Classes, SysUtils,
  ParserU in 'ParserU.pas',
  ParserUtils in 'ParserUtils.pas';

var
  s: TStringList;
  x: TUnitParser;

begin
  if ParamCount = 0 then
  begin
    Writeln('Command Line Unit Importing');
    writeln;
    writeln('psimp <filename>');
    halt(1);
  end;
  s := TStringList.Create;
  try
    s.LoadFromFile(Paramstr(1));
    x := TUnitParser.Create('');
    x.Unitname := ExtractFileName(paramstr(1));
    x.SingleUnit := true;
    x.ParseUnit(s.Text);
    x.SaveToPath(ExtractFilePath(Paramstr(1)));
    Writeln('Successfully processed. Saved to file: '+ExtractFilePath(Paramstr(1))+x.UnitNameCmp);

  finally
    s.Free;
  end;
end.
