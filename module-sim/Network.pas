unit Network;

interface

uses
  Windows, Messages, Winsock, Classes, SysUtils,
  Protocol;

const
  RX_PORT     = 8001;
  TX_PORT     = 8000;

  WM_RXSOCKET = WM_USER + 1;
  WM_TXSOCKET = WM_USER + 2;

type 
  TNetwork = class (TComponent)
  private
    FRxSocket: TSocket;
    FTxSocket: TSocket;
    procedure CreateSockets(Handle: THandle);
  public
    constructor Create(AOwner: TComponent; Handle: THandle); reintroduce;
    destructor Destroy; override;
    procedure SendCommand(Command, DevId, DataSize: Byte; Data: Pointer);
  end;

implementation

{ TNetwork }

{ Private declarations }

procedure TNetwork.CreateSockets(Handle: THandle);
var
  Addr: TSockAddrIn;
begin
  // socket to receive packets
  FRxSocket := socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
  if FRxSocket = INVALID_SOCKET then
    raise Exception.CreateFmt('Error: cannot create socket (%d)', [WSAGetLastError]);
  Addr.sin_family := AF_INET;
  Addr.sin_port := htons(RX_PORT);
  Addr.sin_addr.S_addr := INADDR_ANY;
  if bind(FRxSocket, Addr, SizeOf(Addr)) <> 0 then
    raise Exception.CreateFmt('Error: cannot bind socket (%d)', [WSAGetLastError]);
  WSAAsyncSelect(FRxSocket, Handle, WM_RXSOCKET, FD_READ);

  // socket to transmit packets
  FTxSocket := socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
  if FTxSocket = INVALID_SOCKET then
    raise Exception.CreateFmt('Error: cannot create socket (%d)', [WSAGetLastError]);
end;

{ Public declarations }

constructor TNetwork.Create(AOwner: TComponent; Handle: THandle);
var
  WSAData: TWSAData;
begin
  inherited Create(AOwner);
  WSAStartup($101, WSAData);
  CreateSockets(Handle);
end;

destructor TNetwork.Destroy;
begin
  closesocket(FRxSocket);
  closesocket(FTxSocket);
  WSACleanup;
  inherited Destroy;
end;

procedure TNetwork.SendCommand(Command, DevId, DataSize: Byte; Data: Pointer);
var
  Buffer: array of Byte;
  Header: PPacketHeader;
  Addr: TSockAddrIn;
begin
  SetLength(Buffer, SizeOf(TPacketHeader) + DataSize);
  Header := @Buffer[0];
  Header^.Command := Command;
  Header^.DevId := DevId;
  Header^.DataSize := DataSize;
  if DataSize > 0 then
    Move(Data^, Buffer[SizeOf(TPacketHeader)], DataSize);

  // commands are send only to localhost (test setup!)
  Addr.sin_family := AF_INET;
  Addr.sin_port := htons(TX_PORT);
  Addr.sin_addr.S_addr := inet_addr('127.0.0.1');
  sendto(FTxSocket, Buffer[0], Length(Buffer), 0, Addr, SizeOf(Addr));
end;

end.

