// ----------------------------------------------------------------------------
// file: Resources.pas - a part of AplaSter system
// date: 2005-09-08
// auth: Matthias Hryniszak
// desc: resources for configuration editor
// ----------------------------------------------------------------------------

unit Resources;

{$IFOPT D+}
  {$DEFINE DEBUG}
{$ENDIF}

interface

resourcestring
  SConfigurationEditor = 'Configuration editor';
  SConfiguration = 'Configuration';
  SCode = 'Code';
  SProperties = 'Properties';
  SEvents = 'Events';
  SInformation = 'Information';
  SError = 'Error';
  SQuestion = 'Question';
  SWarning = 'Warning';
  SConfirmation = 'Confirmation';
  STitle = 'Title';
  SDescription = 'Description';
  STag = 'Tag';
  SInterval = 'Interval';
  SBitrate = 'Bitrate';
  SDataBits = 'Data bits';
  SParity = 'Parity';
  SStopBits = 'Stop bits';
  SDeltaChange = 'Delta change';
  SIPAddress = 'IP address';
  SNetmask = 'Netmask';
  SMACAddress = 'MAC address';
  SOnData = 'OnData';
  SOnOpen = 'OnOpen';
  SOnClose = 'OnClose';
  SOnTimer = 'OnTimer';
  SOnBegin = 'OnBegin';
  SOnEnd = 'OnEnd';
  SOnStart = 'OnStart';
  SOnStop = 'OnStop';
  SOnConnected = 'OnConnected';
  SOnDisconnected = 'OnDisconnected';
  SOnInitialized = 'OnInitialized';
  SErrorEventHandlerByThatNameNotFound = 'Error: Event handler by that name not found';
  SServer = 'Server';
  SModule = 'Module';
  SAnalogInput = 'Analog input';
  SDigitalInput = 'Digital input';
  SDigitalOutput = 'Digital output';
  SRelay = 'Relay';
  SWiegand = 'Wiegand';
  SRS232 = 'RS232';
  SRS485 = 'RS485';
  SMotor = 'Motor';
  STimer = 'Timer';
  SFolder = 'Folder';
  SNoName = 'No name';
  SNotConfigured = 'not configured';
  SMissingMACAddress = 'missing MAC address'; 
  // Parser strings
  SOpeningBraceExpected = '"(" expected but "%s" found';
  SColonOrCommaExpected = '":" or "," expected but %s found';
  SSemicolonOrClosingBraceExpected = '";" or ")" expected but "%d" found';
  SParameterNameExpected = 'Parameter name expected but "%s" found';
  STypeNameExpected = 'Type name expected but "%s" found';
  SColonExpected = '":" expected but "%s" found';
  SSemicolonExpected = '";" expected but "%s" found';
  SSyntaxError = 'Syntax error';
  SEnterEventHandlerName = 'Enter name for new event handler';
  SName = 'Name';
  SErrorAProcedureByThatNameAlreadyExists = 'Error: a procedure by that name already exists';
  SErrorIsNotAValidEventHandlerName = 'Error: "%s" is not a valid handler name';
  SInvalidIPAddress = 'Invalid IP address';
  SInvalidNetmaskAddress = 'Invalid network mask';
  SInvalidMACAddress = 'Invalid MAC address';
  SInvalidInterval = 'Invalid interval';
  SInvalidDeltaChangeValue = 'Invalid DeltaChange value';
  SInvalidDataBisValue = '%d is not in the valid DataBits range (16..128)';
  SConfigurationHasBeenChangedSaveChanges = 'Current configuration has been modifed. do you whant to save changes?';
  SOpenNetworkConfiguration = 'Open network configuration...';
  SSaveNetworkConfigurationAs = 'Save network configuration as...';
  SConfigurationFilter = 'Network configurations (*.cfg;*.xml)|*.cfg;*.xml|Network configuration binary (*.cfg)|*.cfg|Network configuration source (*.xml)|*.xml|All files (*.*)|*.*';
  SThereHasBeenAnErrorWhileLoadingNetworkConfiguration = 'There has been an error while loading network configuration.'#13#10#13#10'%s';

  SFile = '&File';
  SNew = '&New';
  SNewHint = 'Create a new network configuration';
  SOpen = '&Open';
  SOpenhint = 'Open a previously saved network configuration';
  SSave = '&Save';
  SSaveHint = 'Save the current network configuration';
  SSaveAs = 'Save &as';
  SSAveAsHint = 'Save the current network configuration with a new file name';
  SCommitConfiguration = 'Commit';
  SCommitConfigurationHint = 'Commit configuration';
  SRetriveCurrentConfiguration = 'Retrieve current';
  SRetriveCurrentConfigurationHint = 'Retrieve current configuration';
  SExit = 'E&xit';
  SExitHint = 'Closes the network configuration editor';

  SEdit = '&Edit';
  SEditHint = 'Edit operations';
  SAddServer = 'Add &server';
  SAddServerHint = 'Create a new server';
  SAddTimer = 'Add &timer';
  SAddTimerHint = 'Create a new timer';
  SAddModule = 'Add &module';
  SAddModuleHint = 'Create a new module';
  SAddFolder = 'Add &folder';
  SAddFolderHint = 'Create a new folder';
  SDeleteSelectedItem = 'Delete selected item';
  SDeleteSelectedItemHint = 'Delete selected item';

  SHelp = '&Help';
  SHelpHint = 'Help';

  SAbout = '&About...';
  SAboutHint = 'Show informations about this application';

  SAboutBoxContent = 'TODO: information about the application';
  SAboutBox = 'About...';

  SAreYouSureYouWantToDeleteThisServerAndAllItsSubcomponents = 'Are you sure you want to delete this server and all it''s subcomponents?';
  SAreYouSureYouWantToDeleteThisTimer = 'Are you sure you want to delete this timer?';
  SAreYouSureYouWantToDeleteThisModule = 'Are you sure you want to delete this module?';
  SAreYouSureYouWantToDeleteThisFolder = 'Are you sure you want to delete this folder?';

  SEditorPosition = 'Line: %d  Column: %d';
  SRecordingMacro = 'Recording macro...';

  SCut = 'C&ut';
  SCopy = '&Copy';
  SPaste = '&Paste';
  SSelectAll = 'Select &all';

  SScriptDebugger = 'PascalScript debugger';
  SRun = '&Run';
  SCompile = '&Compile';
  SExecute = '&Execute';
  STerminate = '&Terminate';
  SStepOver = 'Step &over';
  SStepInto = 'Step &into';
  SToggleBreakpoint = '&Toggle breakpoint';
  SEvaluate = 'E&valuate';
  SScriptHasBeenModofiedSaveChanges = 'The script has been modified. Do you want to save the changes now?';
  SDialogFilter = 'Pascal Script (*.psc)|*.psc|All files (*.*)|*.*';
  SAboutText = 'About application...';
  SOutput = 'Output';
  SExpression = '&Expression';
  SResult = '&Result';
  SNewValue = '&New value';
  SWindow = '&Window';
  SEvaluateModify = 'Evaluate/Modify';
  SGetValue = 'Enter text (Readln)';
  SValue = 'Value';
  SToolbar = 'Toolbar';
  SUndo = '&Undo';
  SRedo = '&Redo';

  // Parser strings
  SSymbolExpected = 'Symbol expected but "%s" found';

  SFunctionsAndProcedures = 'Functions and procedures';
  SList = 'List';
  SOk = 'Ok';
  SCancel = 'Cancel';

  STools = '&Tools';
  SToolsHint = 'Additional tools';
  SFunctionsAndProceduresList = 'Functions and procedures list';
  SType = 'Type';
  SLine = 'Line';  

  SDebuggerIsStillRunningTerminate = 'Debugger is still running. Do you want to terminate?';

  SPascalScript = '&PascalScript';
  SPascalScriptHint = 'Enable controling of network configuration using PascalScript';

  SUnknownElement = 'Unknown element';

  // server script resourcestrings
  SErrorWhileGettingLocalIPAddress = 'Error: %d while getting local IP address';
  SErrorNo = 'Error: %d';
  SCompileScript = 'Compile script';
  
implementation

end.

