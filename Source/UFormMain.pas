unit UFormMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormView, StdCtrls, ExtCtrls, ToolWin, ComCtrls,
  PlatformDefaultStyleActnCtrls, ActnList, ActnMan, Menus, Buttons,
  AppEvnts, ImgList, UMatching;

type
  TfrmMain = class(TForm)
    Panel1: TPanel;
    Timer1: TTimer;
    ActionManager1: TActionManager;
    actAdd: TAction;
    OpenDialog1: TOpenDialog;
    TrayIcon1: TTrayIcon;
    PopupMenu1: TPopupMenu;
    actReturnFromTray: TAction;
    actGoToTray: TAction;
    show1: TMenuItem;
    SpeedButton1: TSpeedButton;
    actSetup: TAction;
    SpeedButton3: TSpeedButton;
    actCascade: TAction;
    actHoriz: TAction;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    actStayOnTop: TAction;
    SpeedButton2: TSpeedButton;
    actClear: TAction;
    clear1: TMenuItem;
    ApplicationEvents1: TApplicationEvents;
    actShowBorder: TAction;
    actHideBorder: TAction;
    SpeedButton6: TSpeedButton;
    PanelReSize: TPanel;
    Image1: TImage;
    SpeedButton7: TSpeedButton;
    ImageList1: TImageList;
    SpeedButton8: TSpeedButton;
    actExit: TAction;
    actMaximizedWindow: TAction;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure actAddExecute(Sender: TObject);
    procedure actGoToTrayExecute(Sender: TObject);
    procedure actReturnFromTrayExecute(Sender: TObject);
    procedure actSetupExecute(Sender: TObject);
    procedure actCascadeExecute(Sender: TObject);
    procedure actClearExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure actHorizExecute(Sender: TObject);
    procedure actShowBorderExecute(Sender: TObject);
    procedure actHideBorderExecute(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure actMaximizedWindowExecute(Sender: TObject);
    procedure ApplicationEvents1Activate(Sender: TObject);
    procedure ApplicationEvents1Deactivate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Panel1MouseDown(Sender: TObject; Button: TMouseButton; Shift:
        TShiftState; X, Y: Integer);
    procedure Panel1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure Panel1MouseUp(Sender: TObject; Button: TMouseButton; Shift:
        TShiftState; X, Y: Integer);
    procedure PanelReSizeMouseDown(Sender: TObject; Button: TMouseButton; Shift:
        TShiftState; X, Y: Integer);
    procedure PanelReSizeMouseMove(Sender: TObject; Shift: TShiftState; X, Y:
        Integer);
    procedure PanelReSizeMouseUp(Sender: TObject; Button: TMouseButton; Shift:
        TShiftState; X, Y: Integer);
    procedure Timer1Timer(Sender: TObject);
  private

    fMovet:boolean;
    fMovetX:integer;
    fMovetY:integer;

    fXPos:integer;
    fYPos:integer;

    fSizing:boolean;
    fSizeX:integer;
    fSizeY:integer;
    fSizeW:integer;
    fSizeH:integer;

    procedure _initTimer;
    procedure _initAlwaysOnTop;
    { Private declarations}
  public
    { Public declarations }
    IniFile:string;
    LastFormPlaceMode:string;

    procedure MessageToTray(str:string);
    procedure FromParam(sender:TObject);
    procedure DoActivate(Sender:TObject;Activate:boolean);
    procedure StoryPos;
    procedure ReStoryPos;
  end;

var
  frmMain: TfrmMain;

implementation

uses
  UFormSetup, UParam, ULog;

{$R *.dfm}

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
    param.SaveToFile(IniFile);
    param.Free;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
    fSizing:=false;
    LastFormPlaceMode:='';
    IniFile:=ExtractFilePath(Application.ExeName)+'flog.ini';
    param:=TParam.Create();
    param.OnChange(FromParam);

    fMovet:=false;

end;

procedure TfrmMain.actAddExecute(Sender: TObject);
var view:TfrmView;
begin
    if (OpenDialog1.Execute()) then
    begin
        view:=TfrmView.Create(self);
        view.LoadFile(OpenDialog1.FileName);
        param.Files.Add(OpenDialog1.FileName);
    end;
end;

procedure TfrmMain.actGoToTrayExecute(Sender: TObject);
begin
    TrayIcon1.Visible:=true;
    Visible:=false;
end;

procedure TfrmMain.actReturnFromTrayExecute(Sender: TObject);
begin
    TrayIcon1.Visible:=true;
    Visible:=true;
    Application.ProcessMessages;
    if (WindowState = wsMinimized) then begin
        WindowState:=wsNormal;
        ReStoryPos;
    end;
end;

procedure TfrmMain.actSetupExecute(Sender: TObject);
begin
    frmSetup.ShowModal();
end;

procedure TfrmMain.actCascadeExecute(Sender: TObject);
begin
  self.Cascade;
  LastFormPlaceMode:='Cascade';

end;

procedure TfrmMain.actClearExecute(Sender: TObject);
var
  child: TForm;
  i: Integer;
begin
    for i:=0 to self.MDIChildCount-1 do begin
        child:=self.MDIChildren[i];
        TfrmView(child).actClearExecute(Sender);
    end;


end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
    Color:=$001E1E1E;
    self.BringToFront;
end;

procedure TfrmMain.actHorizExecute(Sender: TObject);
begin
    TileMode:=tbHorizontal;
    Tile();
    LastFormPlaceMode:='TileHorizontal';
end;

procedure TfrmMain.actShowBorderExecute(Sender: TObject);
begin
   DoActivate(Sender,true);

end;

procedure TfrmMain.actHideBorderExecute(Sender: TObject);
begin
    DoActivate(Sender,false);
end;

procedure TfrmMain.actExitExecute(Sender: TObject);
begin
    close;
end;

procedure TfrmMain.actMaximizedWindowExecute(Sender: TObject);
begin
    if WindowState=wsMaximized then
    begin
        WindowState:=wsNormal;
    end
    else
    begin
        WindowState:=wsMaximized;
    end;
end;

procedure TfrmMain.ApplicationEvents1Activate(Sender: TObject);
begin
    //DoActivate(Sender,true);
end;

procedure TfrmMain.ApplicationEvents1Deactivate(Sender: TObject);
begin
    //DoActivate(Sender,false);
end;

procedure TfrmMain.DoActivate(Sender: TObject; Activate: boolean);
var
  child: TForm;
  i: Integer;
begin
    if Activate then begin
        BorderStyle:=bsSizeable;
        Panel1.Visible:=true;
        PanelResize.Visible:=false;
    end else begin
        BorderStyle:=bsNone;
        Panel1.Visible:=false;
        PanelResize.Visible:=true;
    end;

    for i:=0 to self.MDIChildCount-1 do begin
        child:=self.MDIChildren[i];
        TfrmView(child).DoActivate(Sender,Activate);
    end;

    if (LastFormPlaceMode = 'TileHorizontal') then
        actHoriz.Execute()
    else if (LastFormPlaceMode = 'Cascade') then
        actCascade.Execute();

end;

procedure TfrmMain.FormPaint(Sender: TObject);
var
    i:integer;
    view:TfrmView;
    cFile:string;
begin
    if not param.LoadFromFile(IniFile) then
        frmSetup.initDefault
    else begin
        for i:=0 to param.Files.Count - 1 do begin
            cFile:=param.Files.Strings[i];
            if (FileExists(cFile)) then begin
                view:=TfrmView.Create(self);
                view.LoadFile(cFile);
            end;
        end;
        if self.MDIChildCount = 1 then begin
            self.MDIChildren[0].WindowState:=wsMaximized;
        end else if self.MDIChildCount > 1 then begin
            actHoriz.Execute();
        end;
    end;
    OnPaint:=nil;
end;

procedure TfrmMain.FormResize(Sender: TObject);
begin
    if ((WindowState = wsMinimized) and (param.trayOnMinimize)) then begin
        StoryPos();
        actGoToTrayExecute(Sender);
    end;
end;


procedure TfrmMain.MessageToTray(str: string);
var cLen:integer;
    m:TMatching;
    cRec:TMatchingParseRec;
    cOut:string;
    cTemplate:string;
begin
    OutputDebugString(PChar(str));
    cOut:='';
    if (not Visible) then begin
        cOut:=str;

        if (Trim(param.TrayOutFilter)<>'') then begin
            m:=TMatching.Create;

            cOut:=Matching.Reverse(cOut);
            cTemplate:=Matching.Reverse(param.TrayOutFilter);

            if (m.Matching(cOut,cTemplate)) then begin
                cRec:=m.Parse.Item[0];
                cOut := copy(cOut,cRec.Pos,cRec.Len);
                cOut:=Trim(Matching.reverse(cOut));
                if (param.TrayOutLen>0) then begin
                    clen:=Length(cOut);
                    if (cLen>param.TrayOutLen) then
                        cOut:=copy(cOut,1,param.TrayOutLen);
                end;
            end;
            m.Free;
        end
        else if (param.TrayOutLen>0) then begin
            clen:=Length(str);
            if (cLen>param.TrayOutLen) then
                cOut:=copy(str,cLen-param.TrayOutLen+1,param.TrayOutLen);
        end;

        TrayIcon1.BalloonHint:=cOut;
        TrayIcon1.ShowBalloonHint;
    end;
end;


procedure TfrmMain.ReStoryPos;
begin
    Left:=fXPos;
    Top:=fYPos;
end;

procedure TfrmMain.StoryPos;
begin
    fXPos:=Left;
    fYPos:=Top;
end;

procedure TfrmMain.FromParam(sender: TObject);
begin
    // передаем парметры в компоненты
    _initTimer();
    _initAlwaysOnTop();
end;

procedure TfrmMain.Panel1MouseDown(Sender: TObject; Button: TMouseButton;
    Shift: TShiftState; X, Y: Integer);
begin
    fMovet:=true;
    fMovetX:=Mouse.CursorPos.X;
    fMovetY:=Mouse.CursorPos.Y;
end;

procedure TfrmMain.Panel1MouseMove(Sender: TObject; Shift: TShiftState; X, Y:
    Integer);
begin
    if fMovet then begin
        //frmMain.Left:=frmMain.Left+1;
        frmMain.Left:=frmMain.Left+Mouse.CursorPos.X - fMovetX;
        frmMain.Top:=frmMain.Top+Mouse.CursorPos.Y - fMovetY;
        fMovetX:=Mouse.CursorPos.X;
        fMovetY:=Mouse.CursorPos.Y;
    end;

end;

procedure TfrmMain.Panel1MouseUp(Sender: TObject; Button: TMouseButton; Shift:
    TShiftState; X, Y: Integer);
begin
    fMovet:=false;

end;

procedure TfrmMain.PanelReSizeMouseDown(Sender: TObject; Button: TMouseButton;
    Shift: TShiftState; X, Y: Integer);
begin
    fSizing:=true;
    fSizeX:=Mouse.CursorPos.X;
    fSizeY:=Mouse.CursorPos.Y;
    fSizeW:=Width;
    fSizeH:=Height;
end;

procedure TfrmMain.PanelReSizeMouseMove(Sender: TObject; Shift: TShiftState; X,
    Y: Integer);
begin
    if fSizing then begin
        frmMain.Width:=fSizeW+(Mouse.CursorPos.X - fSizeX);
        frmMain.Height:=fSizeH+(Mouse.CursorPos.Y - fSizeY);
    end;
end;

procedure TfrmMain.PanelReSizeMouseUp(Sender: TObject; Button: TMouseButton;
    Shift: TShiftState; X, Y: Integer);
begin
    fSizing:=false;
end;


procedure TFrmMain._initTimer();
begin
    if ( param.IndexOfIntervalRefresh = 0 ) then
    begin
        Timer1.Enabled:=false;
        exit;
    end;

    Timer1.Enabled:=true;

    if (param.IndexOfIntervalRefresh = 1 ) then
        Timer1.Interval:=1*1000;

    if (param.IndexOfIntervalRefresh = 2 ) then
        Timer1.Interval:=2*1000;

    if (param.IndexOfIntervalRefresh = 3 ) then
        Timer1.Interval:=5*1000;

    if (param.IndexOfIntervalRefresh = 4 ) then
        Timer1.Interval:=10*1000;

    if (param.IndexOfIntervalRefresh = 5 ) then
        Timer1.Interval:=60*1000;

end;

procedure TfrmMain._initAlwaysOnTop();
begin
    if param.alwaysOnTop  then
        SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0,SWP_NoMove or SWP_NoSize)
    else
        SetWindowPos(Handle, HWND_NOTOPMOST, 0, 0, 0, 0,SWP_NoMove or SWP_NoSize);
end;

procedure TfrmMain.Timer1Timer(Sender: TObject);
var
  child: TForm;
  i: Integer;
begin
    for i:=0 to self.MDIChildCount-1 do begin
        child:=self.MDIChildren[i];
        TfrmView(child).view.update();
    end;


end;

end.
