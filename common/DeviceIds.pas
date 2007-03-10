// ----------------------------------------------------------------------------
// file: DeviceIds.pas - a part of AplaSter system
// date: 2005-09-08
// auth: Matthias Hryniszak
// desc: definition of hardware ids for devices
// ----------------------------------------------------------------------------

unit DeviceIds;

{$IFOPT D+}
  {$DEFINE DEBUG}
{$ENDIF}

interface

const
  DID_MODULE         = 0;
  DID_ANALOGINPUT0   = 1;
  DID_ANALOGINPUT1   = 2;
  DID_DIGITALINPUT0  = 3;
  DID_DIGITALINPUT1  = 4;
  DID_DIGITALINPUT2  = 5;
  DID_DIGITALINPUT3  = 6;
  DID_DIGITALINPUT4  = 7;
  DID_DIGITALINPUT5  = 8;
  DID_DIGITALINPUT6  = 9;
  DID_DIGITALINPUT7  = 10;
  DID_DIGITALOUTPUT0 = 11;
  DID_DIGITALOUTPUT1 = 12;
  DID_DIGITALOUTPUT2 = 13;
  DID_DIGITALOUTPUT3 = 14;
  DID_DIGITALOUTPUT4 = 15;
  DID_DIGITALOUTPUT5 = 16;
  DID_RELAY0         = 17;
  DID_RELAY1         = 18;
  DID_RELAY2         = 19;
  DID_WIEGAND0       = 20;
  DID_WIEGAND1       = 21;
  DID_RS2320         = 22;
  DID_RS4850         = 23;
  DID_RS4851         = 24;
  DID_MOTOR0         = 25;
  
  DID_UNKNOWN        = 255;

implementation

end.

