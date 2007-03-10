include delphi.inc
include ../compiler.inc

all: ConfigFile.pas uPSI_Config.pas uPSI_ConfigFile.pas

clean: clean-common

clean-common:
	rm -f ConfigFile.pas uPSI_Config.pas uPSI_ConfigFile.pas APLASTER.FDB

ConfigFile.pas: ConfigFile.xdf
	ERISGen.exe -q -i ConfigFile.xdf

uPSI_Config.pas: Config.pas
	..\\psimp\\psimp.exe Config.pas

uPSI_ConfigFile.pas: ConfigFile.pas
	..\\psimp\\psimp.exe ConfigFile.pas

APLASTER.FDB: Database.sql
	-isql -q -i Database.sql
	mv C:/APLASTER.FDB .
       