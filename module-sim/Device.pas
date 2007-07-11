unit Device;

interface

uses
  Classes, SysUtils;

type
  TSendCommandEvent = procedure (Command, DevId, DataSize: Byte; Data: Pointer) of object;

implementation

end.
