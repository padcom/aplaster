// ----------------------------------------------------------------------------
// file: Storage.pas - a part of AplaSter system
// date: 2005-09-08
// auth: Matthias Hryniszak
// desc: definition of various shared-files access methods
// ----------------------------------------------------------------------------

unit Storage;

{$IFOPT D+}
  {$DEFINE DEBUG}
{$ENDIF}

interface

uses
  Windows, Classes, SysUtils,
  JvUIB,
  PxSettings;

type
  TFileStorage = class (TObject)
    procedure Load(FileName: String; S: TStream); virtual; abstract;
    procedure Save(FileName: String; S: TStream); virtual; abstract;
  end;

  TFileStorageFactory = class (TObject)
    class function CreateFileStorage: TFileStorage;
  end;

  TLocalFileStorage = class (TFileStorage)
    procedure Load(FileName: String; S: TStream); override;
    procedure Save(FileName: String; S: TStream); override;
  end;

  TDBFileStorage = class (TFileStorage)
  private
    FDatabase: TJvUIBDataBase;
    FTransaction: TJvUIBTransaction;
  public
    constructor Create(Database: String);
    destructor Destroy; override;
    procedure Load(FileName: String; S: TStream); override;
    procedure Save(FileName: String; S: TStream); override;
  end;

implementation

uses
  RtlConsts, OptionsBase;

{ TFileStorage }

{ TFileStorageFactory }

class function TFileStorageFactory.CreateFileStorage: TFileStorage;
begin
  Result := nil;
  with TOptionsBase.Create do
    try
      case ConfigSource of
        csLocalFile:
          Result := TLocalFileStorage.Create;
        csDatabase:
          Result := TDBFileStorage.Create(DBServer + ':' + DBDatabase);
      end;
    finally
      Free;
    end;
end;

{ TLocalFileStorage }

procedure TLocalFileStorage.Load(FileName: String; S: TStream);
var
  Source: TStream;
begin
  Source := TFileStream.Create(FileName, fmOpenRead);
  try
    S.CopyFrom(Source, Source.Size);
    S.Position := 0;
  finally
    Source.Free;
  end;
end;

procedure TLocalFileStorage.Save(FileName: String; S: TStream);
var
  Destination: TStream;
begin
  Destination := TFileStream.Create(FileName, fmCreate);
  try
    Destination.CopyFrom(S, S.Size);
  finally
    Destination.Free;
  end;
end;

{ TDBFileStorage }

constructor TDBFileStorage.Create(Database: String);
begin
  inherited Create;
  FDatabase := TJvUIBDataBase.Create(nil);
  FDatabase.DatabaseName := Database;
  FDatabase.UserName := 'SYSDBA';
  FDatabase.PassWord := 'masterkey';
  FDatabase.Connected := True;
  FTransaction := TJvUIBTransaction.Create(nil);
  FTransaction.DataBase := FDatabase;
end;

destructor TDBFileStorage.Destroy;
begin
  FreeAndNil(FTransaction);
  FreeAndNil(FDatabase);
  inherited Destroy;
end;

procedure TDBFileStorage.Load(FileName: String; S: TStream);
var
  Table: TJvUIBQuery;
begin
  S.Size := 0;
  Table := TJvUIBQuery.Create(nil);
  try
    Table.DataBase := FDatabase;
    Table.Transaction := FTransaction;
    Table.SQL.Text := 'SELECT f_content FROM t_files WHERE (f_filename=:f_filename)';
    Table.Params.ByNameAsString['f_filename'] := FileName;
    Table.Open;
    if not Table.Eof then
      Table.ReadBlob('f_content', S)
    else
      raise EFOpenError.Create(@SFOpenError, FileName);
  finally
    Table.Free;
  end;
end;

procedure TDBFileStorage.Save(FileName: String; S: TStream);
var
  Table: TJvUIBQuery;
begin
  S.Position := 0;
  Table := TJvUIBQuery.Create(nil);
  try
    Table.Transaction := FTransaction;
    Table.SQL.Text := 'SELECT f_filename FROM t_files WHERE f_filename=:f_filename';
    Table.Params.ByNameAsString['f_filename'] := FileName;
    Table.Open;
    if Table.Eof then
    begin
      Table.Close;
      Table.SQL.Text := 'INSERT INTO t_files (f_filename, f_content) VALUES (:f_filename, :f_content)';
      Table.Params.ByNameAsString['f_filename'] := FileName;
      Table.ParamsSetBlob('f_content', S);
      Table.ExecSQL;
      Table.Transaction.Commit;
    end
    else
    begin
      Table.Close;
      Table.SQL.Text := 'UPDATE t_files SET f_content=:f_content WHERE f_filename=:f_filename';
      Table.Params.ByNameAsString['f_filename'] := FileName;
      Table.ParamsSetBlob('f_content', S);
      Table.ExecSQL;
      Table.Transaction.Commit;
    end;
  finally
    Table.Free;
  end;
end;

end.

