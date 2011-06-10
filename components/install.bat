@echo off

SET OUTPUT=%~d0%~p0
if not "%1" == "" SET OUTPUT=%1

echo Tools output folder: %OUTPUT%
echo Make sure the %OUTPUT% path is included in the PATH variable


cd pxlib\ERISGen
dcc32 -q -b -n. -dFINALVERSION -u.. ERISGen.dpr
copy ERISGen.exe %OUTPUT%

cd ..\..\pxvcl
dcc32 -q -b -n. -dFINALVERSION -u.. pxvcl_d7.dpk

cd ..\dunit\src
dcc32 -q -b dunit-cli.dpr
copy dunit-cli.exe %OUTPUT%

cd ..\..\synedit\Packages
dcc32 -q -b SynEdit_R7_PE.dpk
dcc32 -q -b SynEdit_D7_PE.dpk

cd ..\..\uib\packages
dcc32 -q -b JvUIBD7RPE.dpk

cd ..\..\pascalscript\Source
dcc32 -q -b PascalScript_Core_D7_Personal.dpk
