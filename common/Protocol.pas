// ----------------------------------------------------------------------------
// file: Protocol.pas - a part of AplaSter system
// date: 2005-09-08
// auth: Matthias Hryniszak
// desc: data transmission protocol definition
// ----------------------------------------------------------------------------

unit Protocol;

{$IFOPT D+}
  {$DEFINE DEBUG}
{$ENDIF}

interface

// ----------------------------------------------------------------------------
// Base command definitions (packet header and command base)
// ----------------------------------------------------------------------------

const
  CMD_BASE = 10;

type
  PPacketHeader = ^TPacketHeader;
  TPacketHeader = packed record
    Command : Byte;
    DevId   : Byte;
    DataSize: Byte;
  end;

const
  HEADER_SIZE = SizeOf(TPacketHeader);

// ----------------------------------------------------------------------------
// Server commands
// ----------------------------------------------------------------------------

const
  CMD_SERVER_BASE  = CMD_BASE;
  CMD_SERVER_START = CMD_SERVER_BASE;
  CMD_SERVER_STOP  = CMD_SERVER_BASE + 1;

// ----------------------------------------------------------------------------
// Module commands
// ----------------------------------------------------------------------------

const
  CMD_MODULE_BASE                   = CMD_BASE + 10;
  CMD_MODULE_PING                   = CMD_MODULE_BASE;
  CMD_MODULE_PONG                   = CMD_MODULE_BASE + 1;
  CMD_MODULE_RESET                  = CMD_MODULE_BASE + 2;
  CMD_MODULE_REQUEST_NETWORK_CONFIG = CMD_MODULE_BASE + 3;
  CMD_MODULE_NETWORK_CONFIG         = CMD_MODULE_BASE + 4;
  CMD_MODULE_CONNECTED              = CMD_MODULE_BASE + 5;
  CMD_MODULE_DISCONNECTED           = CMD_MODULE_BASE + 6;
  CMD_MODULE_INITIALIZED            = CMD_MODULE_BASE + 7;

type
  PModuleRequestNetworkConfigRec = ^TModuleRequestNetworkConfigRec;
  TModuleRequestNetworkConfigRec = packed record
    MAC    : array[0..5] of Byte;
  end;

  PModuleNetworkConfigRec = ^TModuleNetworkConfigRec;
  TModuleNetworkConfigRec = packed record
    MAC    : array[0..5] of Byte;
    IP     : LongWord;
    Netmask: LongWord;
    Gateway: LongWord;
    Server : LongWord;
  end;

// ----------------------------------------------------------------------------
// Analog input commands
// ----------------------------------------------------------------------------

const
  CMD_ANALOG_INPUT_BASE           = CMD_BASE + 20;
  CMD_ANALOG_INPUT_DATA           = CMD_ANALOG_INPUT_BASE + 0;
  CMD_ANALOG_INPUT_GET_STATUS     = CMD_ANALOG_INPUT_BASE + 1;
  CMD_ANALOG_INPUT_STATUS         = CMD_ANALOG_INPUT_BASE + 2;
  CMD_ANALOG_INPUT_REQUEST_CONFIG = CMD_ANALOG_INPUT_BASE + 3;
  CMD_ANALOG_INPUT_CONFIG         = CMD_ANALOG_INPUT_BASE + 4;

type
  PAnalogInputDataRec = ^TAnalogInputDataRec;
  TAnalogInputDataRec = packed record
    Value: Word;
  end;

  PAnalogInputStatusRec = ^TAnalogInputStatusRec;
  TAnalogInputStatusRec = TAnalogInputDataRec;

  PAnalogInputConfigRec = ^TAnalogInputConfigRec;
  TAnalogInputConfigRec = packed record
    Histeresis: Word;
  end;

// ----------------------------------------------------------------------------
// Digital input commands
// ----------------------------------------------------------------------------

const
  CMD_DIGITAL_INPUT_BASE        = CMD_BASE + 30;
  CMD_DIGITAL_INPUT_OPEN        = CMD_DIGITAL_INPUT_BASE + 0;
  CMD_DIGITAL_INPUT_CLOSE       = CMD_DIGITAL_INPUT_BASE + 1;
  CMD_DIGITAL_INPUT_GET_STATUS  = CMD_DIGITAL_INPUT_BASE + 2;
  CMD_DIGITAL_INPUT_STATUS      = CMD_DIGITAL_INPUT_BASE + 3;

  DIGITAL_INPUT_STATUS_OFF      = 0;
  DIGITAL_INPUT_STATUS_ON       = 1;

type
  PDigitalInputStatusRec = ^TDigitalInputStatusRec;
  TDigitalInputStatusRec = packed record
    Status: Byte;
  end;

// ----------------------------------------------------------------------------
// Digital output commands
// ----------------------------------------------------------------------------

const
  CMD_DIGITAL_OUTPUT_BASE       = CMD_BASE + 40;
  CMD_DIGITAL_OUTPUT_CONTROL    = CMD_DIGITAL_OUTPUT_BASE + 0;
  CMD_DIGITAL_OUTPUT_GET_STATUS = CMD_DIGITAL_OUTPUT_BASE + 1;
  CMD_DIGITAL_OUTPUT_STATUS     = CMD_DIGITAL_OUTPUT_BASE + 2;

  DIGITAL_OUTPUT_STATUS_OFF     = 0;
  DIGITAL_OUTPUT_STATUS_ON      = 1;

type
  PDigitalOutputControlRec = ^TDigitalOutputControlRec;
  TDigitalOutputControlRec = packed record
    States        : Byte; // bit 0: Initial state; bit 1: Final state
    Delay         : Word;
    Duration      : Word;
    BreakDevId    : Byte;
    TerminateDevId: Byte;
  end;

  PDigitalOutputStatusRec = ^TDigitalOutputStatusRec;
  TDigitalOutputStatusRec = packed record
    Status: Byte;
  end;

// ----------------------------------------------------------------------------
// Relay commands
// ----------------------------------------------------------------------------

const
  CMD_RELAY_BASE       = CMD_BASE + 50;
  CMD_RELAY_CONTROL    = CMD_RELAY_BASE + 0;
  CMD_RELAY_GET_STATUS = CMD_RELAY_BASE + 1;
  CMD_RELAY_STATUS     = CMD_RELAY_BASE + 2;

  RELAY_STATUS_OFF     = 0;
  RELAY_STATUS_ON      = 1;

type
  PRelayControlRec = ^TRelayControlRec;
  TRelayControlRec = packed record
    States        : Byte; // bit 0: Initial state; bit 1: Final state
    Delay         : Word;
    Duration      : Word;
    BreakDevId    : Byte;
    TerminateDevId: Byte;
  end;

  PRelayStatusRec = ^TRelayStatusRec;
  TRelayStatusRec = packed record
    Status: Byte;
  end;

// ----------------------------------------------------------------------------
// Wiegand commands
// ----------------------------------------------------------------------------

const
  CMD_WIEGAND_BASE           = CMD_BASE + 60;
  CMD_WIEGAND_DATA           = CMD_WIEGAND_BASE + 0;
  CMD_WIEGAND_REQUEST_CONFIG = CMD_WIEGAND_BASE + 1;
  CMD_WIEGAND_CONFIG         = CMD_WIEGAND_BASE + 2;

type
  PWiegandDataRec = ^TWiegandDataRec;
  TWiegandDataRec = packed record
    Data: LongWord;
  end;

  PWiegandConfigRec = ^TWiegandConfigRec;
  TWiegandConfigRec = packed record
    Bits: Byte;
  end;

// ----------------------------------------------------------------------------
// RS232 commands
// ----------------------------------------------------------------------------

const
  CMD_RS232_BASE           = CMD_BASE + 70;
  CMD_RS232_DATA           = CMD_RS232_BASE + 0;
  CMD_RS232_REQUEST_CONFIG = CMD_RS232_BASE + 1;
  CMD_RS232_CONFIG         = CMD_RS232_BASE + 2;

type
  PRS232DataRec = ^TRS232DataRec;
  TRS232DataRec = packed record
    Data: array[0..255-SizeOf(TPacketHeader)] of Byte;
  end;

  PRS232ConfigRec = ^TRS232ConfigRec;
  TRS232ConfigRec = packed record
    Baudrate: Word;
    DataBits: Byte;
    Parity  : Byte;
    StopBits: Byte;
  end;

// ----------------------------------------------------------------------------
// RS485 commands
// ----------------------------------------------------------------------------

const
  CMD_RS485_BASE           = CMD_BASE + 80;
  CMD_RS485_DATA           = CMD_RS485_BASE + 0;
  CMD_RS485_REQUEST_CONFIG = CMD_RS485_BASE + 1;
  CMD_RS485_CONFIG         = CMD_RS485_BASE + 2;

type
  PRS485DataRec = ^TRS485DataRec;
  TRS485DataRec = packed record
    Data: array[0..255-SizeOf(TPacketHeader)] of Byte;
  end;

// ----------------------------------------------------------------------------
// Motor commands
// ----------------------------------------------------------------------------

const
  CMD_MOTOR_BASE   = CMD_BASE + 90;
  CMD_MOTOR_START  = CMD_MOTOR_BASE + 0;
  CMD_MOTOR_STOP   = CMD_MOTOR_BASE + 1;
  CMD_MOTOR_STATUS = CMD_MOTOR_BASE + 2;

type
  PMotorStartRec = ^TMotorStartRec;
  TMotorStartRec = packed record
    Polarity      : Byte;
    Delay         : Word;
    Duration      : Word;
    BreakDevId    : Byte;
    TerminateDevId: Byte;
    StopKind      : Byte;
  end;

  PMotorStopRec = ^TMotorStopRec;
  TMotorStopRec = packed record
    StopKind: Byte;
  end;

  PMotorStatusRec = ^TMotorStatusRec;
  TMotorStatusRec = packed record
    Direction: Byte;
  end;

// ----------------------------------------------------------------------------
// Timer commands
// ----------------------------------------------------------------------------

const
  CMD_TIMER_BASE  = CMD_BASE + 100;
  CMD_TIMER_TIMER = CMD_TIMER_BASE + 0;

// ----------------------------------------------------------------------------
// TimeJob commands
// ----------------------------------------------------------------------------

const
  CMD_TIMEJOB_BASE  = CMD_BASE + 110;
  CMD_TIMEJOB_BEGIN = CMD_TIMEJOB_BASE + 0;
  CMD_TIMEJOB_END   = CMD_TIMEJOB_BASE + 1;

implementation

end.

