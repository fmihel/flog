unit UWebLog;

interface

uses
  Classes, SysUtils;
type
    TWebLog = class(TObject)
        data: TStream;
        fCursor: Integer;
        fEof: Boolean;
    private
        fCount: Integer;
        fFileName: string;
        procedure CreateInfo;
    public
        constructor Create(const aFileName:string = '');
        destructor Destroy; override;
        function Eof: Boolean;
        procedure MoveTo(aRow:integer);
        function Row: string;
        property Count: Integer read fCount;
        property FileName: string read fFileName;
    end;

implementation
{ TWebLog }

{
*********************************** TWebLog ************************************
}
constructor TWebLog.Create(const aFileName:string = '');
begin
    inherited Create;

    fFileName:=aFileName;
    fCursor:=0;
    fEof:=false;

    data:=TFileStream.Create();
    TFileStream(data).LoadFromFile(aFileName,fmOpenRead);
end;

destructor TWebLog.Destroy;
begin
    if data<>nil then
        data.Free();

    inherited;
end;

procedure TWebLog.CreateInfo;
var
    cSize: LongInt;
    s: AnsiChar;
begin
    fCursor:=0;
    fEof:=false;
    //-------------------------------
    fCount:=0;
    cSize:=data.Read(s,sizeof(s));

    if (cSize>0) then begin
        fCount:=1;

        while (cSize>0) do begin
            cSize:=data.Read(s,sizeof(s));
            if (Ord(s)=10) then
                fCount:=fCount+1;
        end;

    end else
        fEof:=true;

    data.Position:=0;
    //-------------------------------
end;

function TWebLog.Eof: Boolean;
begin
    result:=fEof;
end;

procedure TWebLog.MoveTo(aRow:integer);
var
    s: string;
    i: Integer;
    cCount: Integer;
begin
    data.Position:=0;

    for i:=0 to aRow-1 do s:=Row();
        exit;
end;

function TWebLog.Row: string;
var
    s: AnsiChar;
    cSize: LongInt;
begin
    result:='';

    cSize:=data.Read(s,sizeof(s));
    if (cSize=0) then begin
        fEof:=true;
        exit;
    end;


    while ((Ord(s)<>10)and(cSize>0)) do begin
        result:=result+s;
        cSize:=data.Read(s,sizeof(s));
        if (cSize=0) then fEof:=true;
    end;

    fCursor:=fCursor+1;
end;

end.
