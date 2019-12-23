unit UParam;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs;

type
    PNotifyEvent = ^TNotifyEvent;
    TNotifyEvents = class(TObject)
    private
        fList: TList;
        function getItems(Index: Integer): PNotifyEvent;
    public
        constructor Create;
        destructor Destroy; override;
        procedure Add(aEvent: TNotifyEvent);
        procedure Change(Sender: TObject);
        property Items[Index: Integer]: PNotifyEvent read getItems; default;
    end;

    TParam = class(TObject)
    private
        fAlwaysOnTop: Boolean;
        fEvents: TNotifyEvents;
        fFiles: TStringList;
        fIndexOfIntervalRefresh: Integer;
        flock: Integer;
        fTrayOnMinimize: Boolean;
        procedure setAlwaysOnTop(Value: Boolean);
        procedure setIndexOfIntervalRefresh(const Value: Integer);
        procedure setTrayOnMinimize(Value: Boolean);
    public
        constructor Create;
        destructor Destroy; override;
        procedure beginChange;
        procedure change;
        procedure endChange(doChangeOnUnlock: Boolean = true);
        procedure initDefault;
        function LoadFromFile(const aFileName: string): Boolean;
        procedure OnChange(aEvent: TNotifyEvent);
        function SaveToFile(const aFileName: string): Boolean;
        property AlwaysOnTop: Boolean read fAlwaysOnTop write setAlwaysOnTop;
        property Files: TStringList read fFiles write fFiles;
        property IndexOfIntervalRefresh: Integer read fIndexOfIntervalRefresh
            write setIndexOfIntervalRefresh;
        property TrayOnMinimize: Boolean read fTrayOnMinimize write
            setTrayOnMinimize;
    end;

var
    param:TParam;

implementation

uses
  ULog;

{
******************************** TNotifyEvents *********************************
}
constructor TNotifyEvents.Create;
begin
    inherited Create;
    fList:=TList.Create;
end;

destructor TNotifyEvents.Destroy;
var
    i: Integer;
    P: PNotifyEvent;
begin
    for i:=0 to fList.Count - 1 do begin
        P:=Items[i];
        Dispose(P);
    end;
    fList.Free;
    inherited Destroy;
end;

procedure TNotifyEvents.Add(aEvent: TNotifyEvent);
var
    P: PNotifyEvent;
begin
    New(P);
    P^:=aEvent;
    fList.Add(P);
end;

procedure TNotifyEvents.Change(Sender: TObject);
var
    i: Integer;
    cEvent: TNotifyEvent;

    const
        cFuncName = 'Change';

begin
    for i:=0 to fList.Count - 1 do begin
        try try
            cEvent := (Items[i])^;
            if Assigned(cEvent) then
                cEvent(sender);

        except on e:Exception do begin
            log(e.Message,cFuncName,ClassName)
        end;end;
        finally

        end;
    end;
end;

function TNotifyEvents.getItems(Index: Integer): PNotifyEvent;
begin
    result:=PNotifyEvent(fList.Items[Index]);
end;

{
************************************ TParam ************************************
}
constructor TParam.Create;
begin
    inherited Create;
    flock:=0;
    fEvents:=TNotifyEvents.Create();
    fFiles:=TStringList.Create;
end;

destructor TParam.Destroy;
begin
    fEvents.Free;
    fFiles.Free;
    inherited Destroy;
end;

procedure TParam.beginChange;
begin
    flock:=flock+1;
end;

procedure TParam.change;
begin
    if ( (flock = 0) ) then
        fEvents.change(self);
end;

procedure TParam.endChange(doChangeOnUnlock: Boolean = true);
begin
    flock:=flock-1;

    if ( flock = 0 ) and (doChangeOnUnlock) then
        change();
end;

procedure TParam.initDefault;
begin
    beginChange();
    try try

        fIndexOfIntervalRefresh:=2;
        fTrayOnMinimize :=true;
        fAlwaysOnTop    :=true;

    except on e:Exception do begin

    end;end;
    finally

    endChange();

    end;
end;

function TParam.LoadFromFile(const aFileName: string): Boolean;
var
    cFile: TStringList;
    cState: string;
    cData: string;
    cName: string;
    cStr: string;
    i: Integer;

    procedure Assept(aName:string;aData:string);
    begin
        if aName = 'IndexOfIntervalRefresh' then begin

            IndexOfIntervalRefresh:=StrToInt(aData);

        end else if aName = 'TrayOnMinimize' then begin

            TrayOnMinimize:=boolean(StrToInt(aData));

        end else if aName = 'AlwaysOnTop' then begin

            AlwaysOnTop:=boolean(StrToInt(aData));

        end else if aName = 'Files' then begin

            Files.Text:=aData;

        end;

    end;

begin
    cFile:=TstringList.Create;
    self.beginChange;
    {$ifdef _log_} SLog.Stack(ClassName,cFuncName);{$endif}
    try
    try
        cState:='name';
        cFile.LoadFromFile(aFileName);
        i:=0;
        while i<cFile.Count do begin
            cStr:=cFile.Strings[i];

            if (cState = 'name') then begin
                cName:=cStr;
                cState:='data';
                cData:='';
            end else if(cState = 'data') then begin

                if (cStr <> '--------------------') then begin
                    if (cData<>'') then
                        cData:=cData+#13#10;
                    cData:=cData+cStr;
                end else begin
                    cState:='name';
                    Assept(cName,cData);
                end;

            end;
            inc(i);
        end;

        result:=true;
    except
    on e:Exception do
    begin
        log(e.Message,'SaveToFile',ClassName);
        result:=false;
    end;
    end;
    finally
        cFile.Free;
        self.endChange;
    end;
end;

procedure TParam.OnChange(aEvent: TNotifyEvent);
begin
    fEvents.Add(aEvent);
end;

function TParam.SaveToFile(const aFileName: string): Boolean;
var
    cFile: TStringList;

    function tag(aName:string;aData:string):string;
    begin
        result:=aName+''+#13#10+''+aData+#13+#10+'--------------------';
    end;
    procedure add(aName:string;aData:string);overload;
    begin
        cFile.Add(tag(aName,aData));
    end;
    procedure add(aName:string;aData:integer);overload;
    begin
        add(aName,IntToStr(aData));
    end;
    procedure add(aName:string;aData:boolean);overload;
    begin
        add(aName,IntToStr(integer(aData)));
    end;

begin
    cFile:=TstringList.Create;
    {$ifdef _log_} SLog.Stack(ClassName,cFuncName);{$endif}
    try
    try
        add('IndexOfIntervalRefresh',IndexOfIntervalRefresh);
        add('TrayOnMinimize',TrayOnMinimize);
        add('AlwaysOnTop',AlwaysOnTop);
        add('Files',Files.Text);
        cFile.SaveToFile(aFileName);

        result:=true;
    except
    on e:Exception do
    begin
        log(e.Message,'SaveToFile',ClassName);
        result:=false;
    end;
    end;
    finally
        cFile.Free;
    end;
end;

procedure TParam.setAlwaysOnTop(Value: Boolean);
begin
    if fAlwaysOnTop <> Value then
    begin
        fAlwaysOnTop := Value;
        change();
    end;
end;

procedure TParam.setIndexOfIntervalRefresh(const Value: Integer);
begin
    if fIndexOfIntervalRefresh <> Value then
    begin
        fIndexOfIntervalRefresh := Value;
        change();
    end;
end;

procedure TParam.setTrayOnMinimize(Value: Boolean);
begin
    if fTrayOnMinimize <> Value then
    begin
        fTrayOnMinimize := Value;
        change();
    end;
end;

end.
