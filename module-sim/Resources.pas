// ----------------------------------------------------------------------------
// file: Resources.pas - a part of AplaSter system
// date: 2005-09-08
// auth: Matthias Hryniszak
// desc: resources for module simulator
// ----------------------------------------------------------------------------

unit Resources;

{$IFOPT D+}
  {$DEFINE DEBUG}
{$ENDIF}

interface

resourcestring
  SModuleSimulator = 'Module simulator';
  SAnalogInput = 'Analog input';
  SDigitalInput = 'Digital input';
  SDigitalOutput = 'Digital output';
  SRelay = 'Relay';
  SWiegand = 'Wiegand';
  SRS232 = 'RS232';
  SMotor = 'Motor';
  SSend = 'Send';

  SDebug1Hint = 'Close RELAY1 after 50 for 100 break by DI0 and terminate by DI1';
  SDebug2Hint = 'Open RELAY1';
  SDebug3Hint = 'Close DIGITAL1';
  SDebug4Hint = 'Open DIGITAL1';
  SDebug5Hint = 'Start MOTOR0 after 100 for 200 break by DI3 terminate by DI4';
  SDebug6Hint = 'Stop MOTOR0';

implementation

end.
