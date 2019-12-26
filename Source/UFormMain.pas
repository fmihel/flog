unit UFormMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormView, StdCtrls, ExtCtrls, ToolWin, ComCtrls,
  PlatformDefaultStyleActnCtrls, ActnList, ActnMan, Menus, Buttons;

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
    procedure FormPaint(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    procedure _initTimer;
    procedure _initAlwaysOnTop;
    { Private declarations}
  public
    { Public declarations }
    IniFile:string;
    procedure MessageToTray(str:string);
    procedure FromParam(sender:TObject);
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
    IniFile:=ExtractFilePath(Application.ExeName)+'flog.ini';
    param:=TParam.Create();
    param.OnChange(FromParam);
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
    if (WindowState = wsMinimized) then
        WindowState:=wsNormal;
end;

procedure TfrmMain.actSetupExecute(Sender: TObject);
begin
    frmSetup.ShowModal();
end;

procedure TfrmMain.actCascadeExecute(Sender: TObject);
begin
  self.Cascade;
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
            TileMode:=tbHorizontal;
            Tile();
        end;

    end;
    OnPaint:=nil;
end;

procedure TfrmMain.FormResize(Sender: TObject);
begin
    if ((WindowState = wsMinimized) and (param.trayOnMinimize)) then
        actGoToTrayExecute(Sender);
end;


procedure TfrmMain.MessageToTray(str: string);
begin
    if (not Visible) then begin
        TrayIcon1.BalloonHint:=str;
        TrayIcon1.ShowBalloonHint;
    end;
end;

procedure TfrmMain.FromParam(sender: TObject);
begin
    // передаем парметры в компоненты
    _initTimer();
    _initAlwaysOnTop();
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
        Timer1.Interval:=2*1000;

    if (param.IndexOfIntervalRefresh = 2 ) then
        Timer1.Interval:=5*1000;

    if (param.IndexOfIntervalRefresh = 3 ) then
        Timer1.Interval:=10*1000;

    if (param.IndexOfIntervalRefresh = 4 ) then
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
