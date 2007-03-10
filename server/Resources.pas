// ----------------------------------------------------------------------------
// file: Resources.pas - a part of AplaSter system
// date: 2005-09-08
// auth: Matthias Hryniszak
// desc: resources for aplaster server
// ----------------------------------------------------------------------------

unit Resources;

{$IFOPT D+}
  {$DEFINE DEBUG}
{$ENDIF}

interface

resourcestring
  SAplaServer = 'AplaSter Server 1.0';
  SError = 'Error';
  SModules = 'Modules';
  STitle = 'Title';
  SIPAddress = 'IP Address';
  SStatus = 'Status';
  SActive = 'Active';
  SInactive = 'Inactive';
  SResetModule = 'Reset module';
  SReloadConfiguration = 'Reload configuration';
  STerminateServer = 'Terminate server';
  SNoName = 'No name';
  SShowHide = 'Show/Hide server window';
  SErrorWhileGettingLocalIPAddress = 'Error: %d while getting local IP address';
  SErrorNo = 'Error: %d';
  SErrorCannotCreateSocket = 'Error: cannot create socket';
  SErrorCannotBindSocket = 'Error: cannot bind socket (another instance already running?)';
  SErrorCannotSelectSocketEvents = 'Error: cannot select socket events';
  SServerIPAddress = 'Server IP address: %s';
  SThisMachineHasNotBeenconfiguredAsServer = 'This machine has not been configured as AplaSter server';

  SScriptDebugger = 'Script debugger';
  SRun = '&Run';
  SContinue = '&Continue';
  SStepInto = 'Step &into';
  SStepOver = 'Step &over';
  SEvaluate = '&Evaluate';
  SToggleBreakpoint = '&Toggle breakpoint';
  SEvaluateModify = 'Evaluate/Modify';
  SExpression = '&Expression';
  SResult = '&Result';
  SNewValue = '&New value';

  SServer = 'Server';
  SInvalidIPAddress = 'Invalid IP address';
  SNotConfigured = 'Not configured';
  STimer = 'Timer';
  SInvalidInterval = 'Invalid interval';
  SModule = 'Module';
  SInvalidNetmaskAddress = 'Invalid netmask';
  SMissingMACAddress = 'Missing MAC address';
  SInvalidMACAddress = 'Invalid MAC address';
  SAnalogInput = 'Analog input';
  SInvalidDeltaChangeValue = 'Invalid DeltaChange value';
  SDigitalInput = 'Digital input';
  SDigitalOutput = 'Digital output';
  SRelay = 'Relay';
  SWiegand = 'Wiegand';
  SInvalidDataBisValue = 'Invalid DataBits value';
  SRS232 = 'RS232';
  SRS485 = 'RS485';
  SMotor = 'Motor';
  SFolder = 'Folder';
  SUnknownElement = 'Unknown element (%s)';

  SOpen = 'Open';
  SClose = 'Close';
  SAnalogInputStatus = 'Value: %d';
  SRunning = 'Running';
  SNotRunning = 'Not running';

  SServerElements = 'Server elements';

implementation

end.

