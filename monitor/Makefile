include delphi.inc
include ../compiler.inc

all: monitor.mo monitor_pl.mo monitor.exe 

clean: clean-prog

clean-prog:
	rm -f monitor.exe

monitor.exe: monitor.dpr FormMain.pas Resources.pas

uPSI_Factories.pas: Factories.pas
	..\\psimp\\psimp.exe Factories.pas

monitor.mo: monitor.po

monitor_pl.mo: monitor_pl.po


