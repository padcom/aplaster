// ----------------------------------------------------------------------------
// file: Network.pas - a part of AplaSter system
// date: 2005-09-08
// auth: Matthias Hryniszak
// desc: data transmission definition
// ----------------------------------------------------------------------------

unit Network;

{$IFOPT D+}
  {$DEFINE DEBUG}
{$ENDIF}

interface

uses
  Windows, Messages, Winsock, Classes, SysUtils, StrUtils,
  PxDataFile,
  Config, ScriptObjects;

const
  RX_PORT     = 8000;
  TX_PORT     = 8001;

  WM_RXSOCKET = WM_USER + 21;
  WM_TXSOCKET = WM_USER + 22;

  CHECK_ALIVE_TIMER_INTERVAL = 5000;

type
  TNetwork = class;

  // --------------------------------------------------------------------------
  // Network object (singleton)
  // --------------------------------------------------------------------------

  TNetwork = class (TObject)
  private
    FCheckAliveTimer: THandle;
    FConfig: TConfig;
    FServer: TPSServer;
    FRxSocket: TSocket;
    FTxSocket: TSocket;
    function GetLocalIP: String;
  protected
    procedure CreateSockets(hWindow: THandle);
  public
    constructor Create(hWindow: THandle; AConfig: TConfig);
    destructor Destroy; override;
    procedure Read(Sender: String; Buffer: array of Byte);
    procedure Write(IP: String; Command: Byte; DevId: Byte; Data: Pointer; DataSize: Byte);
    property LocalIP: String read GetLocalIP;
    property Server: TPSServer read FServer write FServer;
  end;

implementation

uses
  Protocol, Resources, ConfigFile;

{ TNetwork }

{ Private declarations }

function TNetwork.GetLocalIP: String;
var
  ac: String;
  phe: PHostEnt;
begin
  SetLength(ac, 1024);
  if gethostname(PChar(ac), Length(ac)) = SOCKET_ERROR then
    raise Exception.CreateFmt(SErrorWhileGettingLocalIPAddress, [WSAGetLastError])
  else
    SetLength(ac, StrLen(PChar(ac)));

  phe := gethostbyname(PChar(ac));
  if (phe = nil) or (phe^.h_length <> 4) then
    raise Exception.CreateFmt(SErrorNo, [WSAGetLastError]);

  Result := inet_ntoa(in_addr(Pointer(phe^.h_addr_list^)^));
end;

{ Protected declarations }

procedure TNetwork.CreateSockets(hWindow: THandle);
var
  Addr: TSockAddrIn;
begin
  // create Rx socket
  FRxSocket := socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
  if FRxSocket = INVALID_SOCKET then
    raise Exception.Create(SErrorCannotCreateSocket);
  Addr.sin_family := AF_INET;
  Addr.sin_port := htons(RX_PORT);
  Addr.sin_addr.S_addr := INADDR_ANY;
  if bind(FRxSocket, Addr, SizeOf(Addr)) <> 0 then
    raise Exception.Create(SErrorCannotBindSocket);
  if WSAAsyncSelect(FRxSocket, hWindow, WM_RXSOCKET, FD_READ) <> 0 then
    raise Exception.Create('Error: cannot select socket events');

  // create Tx socket
  FTxSocket := socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
  if FTxSocket = INVALID_SOCKET then
    raise Exception.Create(SErrorCannotCreateSocket);
  Addr.sin_family := AF_INET;
  Addr.sin_port := 0;
  Addr.sin_addr.S_addr := INADDR_ANY;
  if bind(FTxSocket, Addr, SizeOf(Addr)) <> 0 then
    raise Exception.Create(SErrorCannotBindSocket);
  if WSAAsyncSelect(FTxSocket, hWindow, WM_TXSOCKET, FD_WRITE) <> 0 then
    raise Exception.Create(SErrorCannotSelectSocketEvents);
end;

// check-alive timer function

var
  //
  // This is no good. A global variable just to access the network object instance.
  // But AFAIK there's no other method of passing a variable to the timer's callback procedure
  //
  __Network_for_check_alive_timer: TNetwork;

procedure CheckAliveTimer(hwnd: HWND; uMsg: UINT; idEvent: UINT; dwTime: DWORD); stdcall;
var
  I: Integer;
  Network: TNetwork;
  Module: TPSModule;
begin
  Network := __Network_for_check_alive_timer;
  for I := 0 to Network.Server.Modules.Count - 1 do
  begin
    Module := Network.Server.Modules[I];
    if Module.AliveStatus = asUnknown then
      Module.OnDisconnected
    else
      Module.Ping;
  end;
end;

{ Public declarations }

constructor TNetwork.Create(hWindow: THandle; AConfig: TConfig);
var
  WSAData: TWSAData;
begin
  inherited Create;

  FConfig := AConfig;

  // initialize WinSock subsystem
  WSAStartup($101, WSAData);

  CreateSockets(hWindow);

  // initialize check-alive timer
  __Network_for_check_alive_timer := Self;
  FCheckAliveTimer := SetTimer(0, 0, CHECK_ALIVE_TIMER_INTERVAL, @CheckAliveTimer);
end;

destructor TNetwork.Destroy;
begin
  KillTimer(0, FCheckAliveTimer);
  __Network_for_check_alive_timer := nil;
  closesocket(FRxSocket);
  closesocket(FTxSocket);
  WSACleanup;
  inherited Destroy;
end;

procedure TNetwork.Read(Sender: String; Buffer: array of Byte);
type
  PData = ^TData;
  TData = array[0..255] of Byte;
var
  Header: PPacketHeader;
  Data  : PData;
  I, J  : Integer;
  Module: TPSModule;
  Device: TPSItem;
begin
  // data are to be received

  // check if a valid server is available
  if Server = nil then
    Exit;

  // check if we have receiced at least a valid header data length
  if Length(Buffer) < SizeOf(TPacketHeader) then
    Exit;

  // initialize temporary pointers
  Header := @Buffer[0];
  if Header^.DataSize > 0 then
    Data := @Buffer[SizeOf(TPacketHeader)]
  else
    Data := nil;

  // check if all data has been received
  if Length(Buffer) <> SizeOf(TPacketHeader) + Header^.DataSize then
    Exit;

  // check if we can receive a valid packet
  Device := nil;

  // check if the command was sent by a module
  for I := 0 to Server.Modules.Count - 1 do
    if Server.Modules[I].D.IP = Sender then
    begin
      Module := Server.Modules[I];
      Device := Module;

      for J := 0 to Server.Modules[I].Items.Count - 1 do
        if (Module.Items[J] is TPSDevice) and (TPSDevice(Module.Items[J]).DevId = Header^.DevId) then
        begin
          Device := Module.Items[J] as TPSDevice;
          Break;
        end;

      Break;
    end;

  // check if the sender is a timer or time job (server-specific objects)
  if Device = nil then
    for I := 0 to Server.Timers.Count - 1 do
      if IntToStr(Server.Timers[I].D.Id) = Sender then
      begin
        Device := Server.Timers[I];
        Break;
      end;

  // check if the sender is a server itself or an unconfigured network entity
  // for which the server is to provide a valid network configuration
  if (Device = nil) and (Sender = LocalIP) or (Sender = '255.255.255.255') then
    Device := Server;

  // is this packet from a known network element
  if Assigned(Device) then
    Device.Process(Header.Command, Header.DevId, Data, Header.DataSize);
end;

procedure TNetwork.Write(IP: String; Command: Byte; DevId: Byte; Data: Pointer; DataSize: Byte);
type
  PData = ^TData;
  TData = array[0..255] of Byte;
var
  Buffer : array[0..(255+SizeOf(TPacketHeader))] of Byte;
  Header : PPacketHeader;
  Data_  : PData;
  Addr   : TSockAddrIn;
begin
  // initialize temporary pointers
  Header := @Buffer[0];
  Header^.DataSize := DataSize;
  if Header^.DataSize > 0 then
    Data_ := @Buffer[SizeOf(TPacketHeader)]
  else
    Data_ := nil;

  // compose packet header
  Header^.Command  := Command;
  Header^.DevId    := DevId;
  Header^.DataSize := DataSize;
  if Assigned(Data_) then
    Move(Data^, Data_^, DataSize);

  // send buffer (header + data)
  Addr.sin_family := AF_INET;
  Addr.sin_port   := htons(TX_PORT);
  Addr.sin_addr.S_addr := inet_addr(PChar(IP));
  sendto(FTxSocket, Buffer[0], SizeOf(TPacketHeader) + DataSize, 0, Addr, SizeOf(Addr));
end;

end.

