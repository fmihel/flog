unit UClassView;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,StdCtrls;

type
    THaveNewDataEvent = procedure (sender:TObject;str:string) of object;
    TBeforeAddToMemoEvent = procedure (Sender: TObject) of object;
    TView = class(TObject)
    private
        fCount: LongInt;
        fFileName: string;
        fForm: TForm;
        fMemo: TMemo;
        fOnBeforeAddToMemo: TBeforeAddToMemoEvent;
        fOnNewData: THaveNewDataEvent;
        fPosition: LongInt;
        fPreloadCount: Integer;
        fSize: LongInt;
        function ExTrim(str: string): string;
    protected
        stream: TStream;
        procedure addToMemo(s:string); overload;
        procedure addToMemo(s: TStrings); overload;
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
        property OnBeforeAddToMemo: TBeforeAddToMemoEvent read
            fOnBeforeAddToMemo write fOnBeforeAddToMemo;
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

procedure TView.addToMemo(s:string);
begin
    if (Assigned(fOnBeforeAddToMemo)) then
            fOnBeforeAddToMemo(self);
    memo.Lines.Add(Utf8ToAnsi(s));
end;

procedure TView.addToMemo(s: TStrings);
begin
    if (Assigned(fOnBeforeAddToMemo)) then
            fOnBeforeAddToMemo(self);
    memo.Lines.AddStrings(s);
end;

function TView.ChangeType: Integer;
begin
end;

procedure TView.createStream;
begin
    stream:=TFileStream.Create(FileName,fmOpenRead);
    //TFileStream(stream).LoadFromFile(FileName,fmOpenRead);
end;

function TView.ExTrim(str: string): string;
var
    space: string;
begin

    space:='[<'+IntToStr(random(1000))+'space'+IntToStr(random(1000))+'>]';
    result:=StringReplace(str,' ',space,[rfReplaceAll, rfIgnoreCase]);
    result:=StringReplace(Trim(result),space,' ',[rfReplaceAll, rfIgnoreCase]);

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

    const cMaxCount = 5; // максимальное кол-во строк отображаемое а хинте
    var
        cCount: Integer;

        s: AnsiChar;
        cSize: LongInt;
        cCursor: Integer;
        outString: string;
        cResult:TStringList;   /// список строк для отображения в хинте
        i:integer;

        cLines:TStringList;

begin
    createStream();
    cResult:=TStringList.Create;
    cLines:=TStringList.Create;
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
    //                        self.addToMemo(outString);
                        cLines.Add(Utf8ToAnsi(outString));
                            //result:=outString;
                        if (Trim(outString)<>'') then begin
                            cResult.Add(ExTrim(outString));
                            if cResult.Count>cMaxCount then
                                cResult.Delete(0);
                        end;
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
    //            self.addToMemo(outString);
            cLines.Add(Utf8ToAnsi(outString));
               //result:=outString;
            if (Trim(outString)<>'') then begin
                cResult.Add(ExTrim(outString));

                if cResult.Count>cMaxCount then
                    cResult.Delete(0);
            end;
        end;

            // формируем спиоск строк к отображению в хинте
        cCount:=cMaxCount;
        if (cResult.Count<cCount) then
            cCount:=cResult.Count;
        for i := 0 to cCount-1 do begin
            if (i>0) then
                result:=result+#13#10;
            result:=result+cResult.Strings[i];
        end;
        if (cLines.count>0) then begin
            self.AddToMemo(cLines);
        end;
        // ----------------------------------------

    except

    end;

    cLines.Free;
    cResult.Free;
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
