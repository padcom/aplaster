// ----------------------------------------------------------------------------
// file: PasUtils.pas - a part of AplaSter system
// date: 2005-09-08
// auth: Matthias Hryniszak
// desc: pascal scripting utilities 
// ----------------------------------------------------------------------------

unit PasUtils;

{$IFOPT D+}
  {$DEFINE DEBUG}
{$ENDIF}

interface

uses
  Classes, SysUtils;

type
  //
  // This type determinates if it's a function or procedure
  //
  TProcedureType = (ptFunction, ptProcedure);

  //
  // Parameter definition
  //
  TParamType = record
    Name: String;
    Type_: String;
  end;

  //
  // Function/Procedure definition
  //
  TProcFunc = class (TObject)
  private
    FKind: TProcedureType;
    FName: String;
    FReturnType: String;
    FParams: array of TParamType;
    FLine: Integer;
    FPosition: Integer;
    function GetParamCount: Integer;
    function GetParam(Index: Integer): TParamType;
  public
    // function or procedure
    property Kind: TProcedureType read FKind;
    // function/procedure name
    property Name: String read FName;
    // functions only: return value
    property ReturnType: String read FReturnType;
    // count of parameters
    property ParamCount: Integer read GetParamCount;
    // parameters for this function/procedure
    property Params[Index: Integer]: TParamType read GetParam;
    // source code line where the fucntion is defined
    property Line: Integer read FLine;
    // source code position where the fucntion is defined
    property Position: Integer read FPosition;
  end;

  //
  // A list of TProcFunc objects
  //
  TProcFuncList = class (TList)
  private
    function GetItem(Index: Integer): TProcFunc;
  public
    procedure Clear; override;
    property Items[Index: Integer]: TProcFunc read GetItem; default;
  end;

//
// This function gets a list of all function and procedure declarations
// in the specified source code and stores it in the List.
//
procedure FillProcFuncList(Source: String; List: TProcFuncList);

implementation

uses
  RtlConsts, Resources;

{ TProcFunc }

{ Private declarations }

function TProcFunc.GetParamCount: Integer;
begin
  Result := Length(FParams);
end;

function TProcFunc.GetParam(Index: Integer): TParamType;
begin
  Result := FParams[Index];
end;

{ Public declarations }

{ TProcFuncList }

{ Private declarations }

function TProcFuncList.GetItem(Index: Integer): TProcFunc;
begin
  Result := TObject(Get(Index)) as TProcFunc;
end;

{ Public declarations }

procedure TProcFuncList.Clear;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    Items[I].Free;
  inherited Clear;
end;

{ *** }

// TParser - taken from Classes.pas, modifed to support other string delimiters
//           and to skip Pascal and Delphi (//) comments

const
  ParseBufSize = 65536;

{ TParser special tokens }

  toEOF     = Char(0);
  toSymbol  = Char(1);
  toString  = Char(2);
  toInteger = Char(3);
  toFloat   = Char(4);

type
  TParser = class(TObject)
  private
    FStream: TStream;
    FOrigin: Longint;
    FBuffer: PChar;
    FBufPtr: PChar;
    FBufEnd: PChar;
    FSourcePtr: PChar;
    FSourceEnd: PChar;
    FTokenPtr: PChar;
    FStringPtr: PChar;
    FSourceLine: Integer;
    FSaveChar: Char;
    FToken: Char;
    FStringDelimiter: Char;
    procedure ReadBuffer;
    procedure SkipBlanks;
  public
    constructor Create(Stream: TStream; StringDelimiter: Char);
    destructor Destroy; override;
    procedure Error(const Ident: string);
    procedure ErrorFmt(const Ident: string; const Args: array of const);
    procedure ErrorStr(const Message: string);
    function NextToken: Char;
    function SourcePos: Longint;
    function TokenFloat: Extended;
    function TokenInt: Int64;
    function TokenString: string;
    property SourceLine: Integer read FSourceLine;
    property Token: Char read FToken;
  end;

constructor TParser.Create(Stream: TStream; StringDelimiter: Char);
begin
  inherited Create;
  FStream := Stream;
  GetMem(FBuffer, ParseBufSize);
  FBuffer[0] := #0;
  FBufPtr := FBuffer;
  FBufEnd := FBuffer + ParseBufSize;
  FSourcePtr := FBuffer;
  FSourceEnd := FBuffer;
  FTokenPtr := FBuffer;
  FSourceLine := 1;
  FStringDelimiter := StringDelimiter;
  NextToken;
end;

destructor TParser.Destroy;
begin
  if FBuffer <> nil then
  begin
    FStream.Seek(Longint(FTokenPtr) - Longint(FBufPtr), 1);
    FreeMem(FBuffer, ParseBufSize);
  end;
end;

procedure TParser.Error(const Ident: string);
begin
  ErrorStr(Ident);
end;

procedure TParser.ErrorFmt(const Ident: string; const Args: array of const);
begin
  ErrorStr(Format(Ident, Args));
end;

procedure TParser.ErrorStr(const Message: string);
begin
  raise EParserError.CreateResFmt(@SParseError, [Message, FSourceLine]);
end;

function TParser.NextToken: Char;
var
  P: PChar;
  NextCharIsNotControl: Boolean;
begin
  SkipBlanks;
  P := FSourcePtr;
  FTokenPtr := P;
  if P^ = FStringDelimiter then
  begin
    NextCharIsNotControl := False;
    repeat
      Inc(P);
      if P^ in [#0, #10, #13] then Error(SInvalidString)
      else if P^ = '\' then
        NextCharIsNotControl := True
      else if (not NextCharIsNotControl) and (P^ = FStringDelimiter) then Break
      else if NextCharIsNotControl then NextCharIsNotControl := False;
    until False;
    FStringPtr := P;
    P := P + 1;
    FTokenPtr := FTokenPtr + 1;
    Result := toString;
  end
  else
    case P^ of
      'A'..'Z', 'a'..'z', '_':
      begin
        Inc(P);
        while P^ in ['A'..'Z', 'a'..'z', '0'..'9', '_'] do Inc(P);
        Result := toSymbol;
      end;
      '$':
      begin
        Inc(P);
        while P^ in ['0'..'9', 'A'..'F', 'a'..'f'] do Inc(P);
        Result := toInteger;
      end;
      '-', '0'..'9':
      begin
        Inc(P);
        while P^ in ['0'..'9'] do Inc(P);
        Result := toInteger;
        while P^ in ['0'..'9', '.', 'e', 'E', '+', '-'] do
        begin
          Inc(P);
          Result := toFloat;
        end;
      end;
      else
      begin
        Result := P^;
        if Result <> toEOF then Inc(P);
      end;
    end;
  FSourcePtr := P;
  FToken := Result;
end;

procedure TParser.ReadBuffer;
var
  Count: Integer;
begin
  Inc(FOrigin, FSourcePtr - FBuffer);
  FSourceEnd[0] := FSaveChar;
  Count := FBufPtr - FSourcePtr;
  if Count <> 0 then Move(FSourcePtr[0], FBuffer[0], Count);
  FBufPtr := FBuffer + Count;
  Inc(FBufPtr, FStream.Read(FBufPtr[0], FBufEnd - FBufPtr));
  FSourcePtr := FBuffer;
  FSourceEnd := FBufPtr;
  if FSourceEnd = FBufEnd then
  begin
    FSourceEnd := LineStart(FBuffer, FSourceEnd - 1);
    if FSourceEnd = FBuffer then Error(SLineTooLong);
  end;
  FSaveChar := FSourceEnd[0];
  FSourceEnd[0] := #0;
end;

procedure TParser.SkipBlanks;
begin
  repeat
    case FSourcePtr^ of
      '/':
      begin
        // "//" comment
        if (FSourcePtr + 1)^ = '/' then
        begin
          while FSourcePtr^ <> #10 do
          begin
            Inc(FSourcePtr);
            if FSourcePtr^ = #0 then
            begin
              ReadBuffer;
              if FSourcePtr^ = #0 then Exit;
            end;
          end;
          Inc(FSourceLine);
        end
        else
          Break;
      end;
      '{':
      begin
        // "{ }" comment
        while FSourcePtr^ = '}' do
        begin
          Inc(FSourcePtr);
          if FSourcePtr^ = #0 then
          begin
            ReadBuffer;
            if FSourcePtr^ = #0 then Exit;
          end
          else if FSourcePtr^ = #10 then
            Inc(FSourceLine);
        end;
      end;
      '(':
      begin
        // "(* *)" comment
        if (FSourcePtr + 1)^ = '*' then
          while (FSourcePtr^ = '*') and ((FSourcePtr + 1)^ = ')') do
          begin
            Inc(FSourcePtr);
            if FSourcePtr^ = #0 then
            begin
              ReadBuffer;
              if FSourcePtr^ = #0 then Exit;
            end
            else if FSourcePtr^ = #10 then
              Inc(FSourceLine);
          end
        else
          Break;
      end;
      #0:
      begin
        ReadBuffer;
        if FSourcePtr^ = #0 then Exit;
        Continue;
      end;
      #10:
        Inc(FSourceLine);
      #13:
        ;
      else if FSourcePtr^ >= #33 then
        Exit;
    end;
    Inc(FSourcePtr);
  until False;
end;

function TParser.SourcePos: Longint;
begin
  Result := FOrigin + (FTokenPtr - FBuffer);
end;

function TParser.TokenFloat: Extended;
begin
  Result := StrToFloat(TokenString);
end;

function TParser.TokenInt: Int64;
begin
  Result := StrToInt64(TokenString);
end;

function TParser.TokenString: string;
var
  L: Integer;
begin
  Result := '';
  if FToken = toString then
    L := FStringPtr - FTokenPtr
  else
    L := FSourcePtr - FTokenPtr;
  SetString(Result, FTokenPtr, L);
end;

procedure FillProcFuncList(Source: String; List: TProcFuncList);
  function ReadNameAndParametersTillClosingBrace(P: TParser; F: TProcFunc): Boolean;
  var
    I: Integer;
    Expected: (exName, exColonOrComma, exTypeName, exSemicolonOrBrace);
  begin
    Result := False;
    // get function/procedure name
    if P.NextToken <> toSymbol then
      P.ErrorFmt(SSymbolExpected, [P.TokenString]);
    F.FName := P.TokenString;
    // check opening brace or end of definition
    P.NextToken;
    if P.Token in [':',';'] then
    begin
      // parameter-less definition

      // move one left so that the colon can be read by caller
      Dec(P.FSourcePtr);
      Result := True;
      Exit;
    end
    else if P.Token <> '(' then
      P.ErrorFmt(SOpeningBraceExpected, [P.TokenString]);

    Expected := exName;
    while P.NextToken <> toEOF do
      case P.Token of
        toSymbol:
          case Expected of
            exName:
            begin
              // get parameter name
              SetLength(F.FParams, Length(F.FParams) + 1);
              F.FParams[Length(F.FParams) - 1].Name := P.TokenString;
              Expected := exColonOrComma;
            end;
            exColonOrComma:
              P.ErrorFmt(SColonOrCommaExpected, [P.TokenString]);
            exTypeName:
            begin
              // get parameter type
              for I := Length(F.FParams) - 1 downto 0 do
                if F.FParams[I].Type_ = '' then
                  F.FParams[I].Type_ := P.TokenString
                else
                  Break;
              Expected := exSemicolonOrBrace;
            end;
            exSemicolonOrBrace:
              P.ErrorFmt(SSemicolonOrClosingBraceExpected, [P.TokenString]);
          end;
        ':':
        begin
          case Expected of
            exColonOrComma:
              // next element should be type name
              Expected := exTypeName;
            exName:
              P.ErrorFmt(SParameterNameExpected, [P.TokenString]);
            exTypeName:
              P.ErrorFmt(STypeNameExpected, [P.TokenString]);
            exSemicolonOrBrace:
              P.ErrorFmt(SSemicolonOrClosingBraceExpected, [P.TokenString]);
          end;
        end;
        ';':
        begin
          case Expected of
            exColonOrComma:
              P.ErrorFmt(SSemicolonOrClosingBraceExpected, [P.TokenString]);
            exName:
              P.ErrorFmt(SParameterNameExpected, [P.TokenString]);
            exTypeName:
              P.ErrorFmt(STypeNameExpected, [P.TokenString]);
            exSemicolonOrBrace:
              // next element should be variable name
              Expected := exName;
          end;
        end;
        ')':
        begin
          case Expected of
            exColonOrComma:
              P.ErrorFmt(SColonOrCommaExpected, [P.TokenString]);
            exName:
            begin
              if F.ParamCount = 0 then
              begin
                // end of function/procedure declaration
                Result := True;
                Break;
              end
              else P.ErrorFmt(SParameterNameExpected, [P.TokenString]);
            end;
            exTypeName:
              P.ErrorFmt(STypeNameExpected, [P.TokenString]);
            exSemicolonOrBrace:
            begin
              // end of function/procedure declaration
              Result := True;
              Break;
            end;
          end;
        end;
        ',':
        begin
          case Expected of
            exColonOrComma:
              // next element should be variable name
              Expected := exName;
            exName:
              P.ErrorFmt(SParameterNameExpected, [P.TokenString]);
            exTypeName:
              P.ErrorFmt(STypeNameExpected, [P.TokenString]);
            exSemicolonOrBrace:
              P.ErrorFmt(SSemicolonOrClosingBraceExpected, [P.TokenString]);
          end;
        end;
        else
          // something unexpected has happend
          P.Error(SSyntaxError);
      end;
  end;
var
  S: TStream;
  P: TParser;
  F: TProcFunc;
begin
  if not Assigned(List) then
    raise Exception.Create('Error: List cannot be nil'); // do not translate

  // make a stream of the given source code (required by TParser constructor)
  S := TStringStream.Create(Source);
  try
    F := nil;
    // create parser object and use ' as string delimiter
    P := TParser.Create(S, '''');
    try
      while P.Token <> toEOF do
        case P.Token of
          toSymbol:
          begin
            // check if this is a known token (functino or procedure)
            if AnsiSameText('function', P.TokenString) then
            begin
              // read function definition
              F := TProcFunc.Create;
              F.FKind := ptFunction;
              F.FLine := P.SourceLine;
              F.FPosition := P.SourcePos;
              if ReadNameAndParametersTillClosingBrace(P, F) then
              begin
                // read function's result code

                // check colon at the end of base definition
                if P.NextToken <> ':' then
                  P.ErrorFmt(SColonExpected, [P.TokenString]);
                // check type name
                if P.NextToken <> toSymbol then
                  P.ErrorFmt(STypeNameExpected, [P.TokenString]);
                F.FReturnType := P.TokenString;
                // check semicolon at the end
                if P.NextToken <> ';' then
                  P.ErrorFmt(SSemicolonExpected, [P.TokenString]);
              end
              else P.NextToken;

              if Assigned(F) then
                List.Add(F);
            end
            else if AnsiSameText('procedure', P.TokenString) then
            begin
              // read procedure definition
              F := TProcFunc.Create;
              F.FKind := ptProcedure;
              F.FLine := P.SourceLine;
              F.FPosition := P.SourcePos;
              if ReadNameAndParametersTillClosingBrace(P, F) then
              begin
                // check semicolon at the end
                if P.NextToken <> ';' then
                  P.ErrorFmt(SSemicolonExpected, [P.TokenString]);
              end
              else
              begin
                // this is nighter a function or a procedure
                FreeAndNil(F);
              end;

              if Assigned(F) then
              begin
                // the declaration has been successfully decoded
                // add it to the functions/procedures list
                List.Add(F);
              end;
            end
            else P.NextToken;
          end
          else
            P.NextToken;
        end;
    finally
      // make sure the parser object gets disposed
      P.Free;
    end;
  finally
      // make sure the stream object gets disposed
    S.Free;
  end;
end;

end.
