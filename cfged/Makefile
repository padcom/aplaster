include delphi.inc
include ../compiler.inc

all: cfged.mo cfged_pl.mo cfged.exe 

clean: clean-prog

clean-prog:
	rm -f cfged.exe aplaster.cfg

cfged.exe: cfged.dpr FormMain.pas Resources.pas

cfged.mo: cfged.po

cfged_pl.mo: cfged_pl.po

