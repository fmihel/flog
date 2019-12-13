unit UClassView;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,StdCtrls;

type
    THaveNewDataEvent = procedure (sender:TObject;str:string) of object;
    TView = class(TObject)
    private
        fCount: LongInt;
        fFileName: string;
        fForm: TForm;
        fMemo: TMemo;
        fOnNewData: THaveNewDataEvent;
        fPosition: LongInt;
        fPreloadCount: Integer;
        fSize: LongInt;
    protected
        stream: TStream;
        procedure createStream;
        procedure freeStream;
        function GetSize: LongInt;
    public
        constructor Create;
        destructor Destroy; override;
        function ChangeType: Integer;
        function GetCountStrings: LongInt;
        procedure LoadFile(const aFileName: string);
        function Read(aFromRow: Integer = -1): string;
        procedure Update;
        property FileName: string read fFileName;
        property Form: TForm read fForm write fForm;
        property Memo: TMemo read fMemo write fMemo;
        property PreloadCount: Integer read fPreloadCount write fPreloadCount;
    published
        property OnNewData: THaveNewDataEvent read fOnNewData write fOnNewData;
    end;


implementation

{
************************************ TView *************************************
}
constructor TView.Create;
begin
    inherited Create;
    fFileName:='';
    stream:=nil;
    fPreloadCount:=0;
end;

destructor TView.Destroy;
begin
    freeStream();
    inherited Destroy;
end;

function TView.ChangeType: Integer;
begin
end;

procedure TView.createStream;
begin
    stream:=TFileStream.Create(FileName,fmOpenRead);
    //TFileStream(stream).LoadFromFile(FileName,fmOpenRead);
end;

procedure TView.freeStream;
begin
    if (stream<>nil) then
        stream.free;
    stream:=nil;
end;

function TView.GetCountStrings: LongInt;
var
    s: AnsiChar;
    cSize: LongInt;
begin
    createStream();
    result:=0;
    try
        cSize:=stream.Read(s,sizeof(s));

        if (cSize>0) then begin
            result:=1;

            while (cSize>0) do begin
                cSize:=stream.Read(s,sizeof(s));
                if (Ord(s)=10) then
                    result:=result+1;
            end;

        end;

    except

    end;
    freeStream();

    //-------------------------------
end;

function TView.GetSize: LongInt;
begin
    try
        createStream();
        result := stream.Size;
        freeStream();
    except
        result := -1;
    end;
end;

procedure TView.LoadFile(const aFileName: string);
begin
    fFileName:=aFileName;
    fMemo.Clear;
    fSize :=GetSize();

    if (fPreloadCount>0) then begin
        fCount:=GetCountStrings();

        if (fCount>fPreloadCount) then
            Read(fCount-fPreloadCount-1)
        else
            Read(fCount);
        fPosition:=fSize;

    end else begin
        fPosition:=fSize;
        Read();
    end;
end;

function TView.Read(aFromRow: Integer = -1): string;
var
    s: AnsiChar;
    cSize: LongInt;
    cCursor: Integer;
    outString: string;
begin
    createStream();
    try
        cCursor:=0;
        outString:='';
        if (aFromRow = -1) then
            stream.Position:=fPosition;

        cSize:=stream.Read(s,sizeof(s));

        while ( cSize>0 ) do begin

            if (Ord(s) = 10) then begin
                cCursor:=cCursor+1;
                if (aFromRow = -1) or (cCursor > aFromRow) then begin
                    if (outString<>'') then begin
                        memo.Lines.Add(outString);
                        result:=outString;
                    end;
                    outString:='';

                end;
            end else begin
                if (aFromRow = -1) or (cCursor > aFromRow) then
                    outString:=outString + s;
            end;

            cSize:=stream.Read(s,sizeof(s));
        end;
        if (outString<>'') then begin
            memo.Lines.Add(outString);
           result:=outString;
        end;
    except
    end;

    freeStream();
end;

procedure TView.Update;
var
    cCurrentSize: LongInt;
    cLast: string;
begin
    cCurrentSize:=GetSize();
    if (cCurrentSize < fSize ) then begin
        memo.Clear;
        fSize := cCurrentSize;
        fPosition:=fSize;

    end else if (cCurrentSize > fSize ) then begin
        fSize := cCurrentSize;
        cLast :=Read();
        if (Assigned(fOnNewData)) then
            fOnNewData(self,cLast);
        SendMessage(memo.Handle, EM_LINESCROLL, 0,memo.Lines.Count);
        fPosition:=fSize;
    end;
end;



end.
