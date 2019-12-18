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
    SpeedButton2: TSpeedButton;
    actSetup: TAction;
    SpeedButton3: TSpeedButton;
    actCascade: TAction;
    actHoriz: TAction;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    actStayOnTop: TAction;
    procedure FormCreate(Sender: TObject);
    procedure actAddExecute(Sender: TObject);
    procedure actGoToTrayExecute(Sender: TObject);
    procedure actReturnFromTrayExecute(Sender: TObject);
    procedure actSetupExecute(Sender: TObject);
    procedure actCascadeExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure actHorizExecute(Sender: TObject);
    procedure actStayOnTopExecute(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations}
  public
    { Public declarations }
    procedure MessageToTray(str:string);
  end;

var
  frmMain: TfrmMain;

implementation

uses
  UFormSetup;

{$R *.dfm}

procedure TfrmMain.FormCreate(Sender: TObject);
begin
    frmSetup.initTimer;
    actStayOnTopExecute(nil);
end;

procedure TfrmMain.actAddExecute(Sender: TObject);
var view:TfrmView;
begin
    if (OpenDialog1.Execute()) then
    begin
        view:=TfrmView.Create(self);
        view.LoadFile(OpenDialog1.FileName);
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
end;

procedure TfrmMain.actSetupExecute(Sender: TObject);
begin
    frmSetup.ShowModal();
end;

procedure TfrmMain.actCascadeExecute(Sender: TObject);
begin
  self.Cascade;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
    Color:=$003F342C;
    self.BringToFront;

end;

procedure TfrmMain.actHorizExecute(Sender: TObject);
begin
    TileMode:=tbHorizontal;
    Tile();
end;

procedure TfrmMain.actStayOnTopExecute(Sender: TObject);
begin
    if actStayOnTop.Caption='on top: OFF'  then begin
        actStayOnTop.Caption:='on top: ON';
        SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0,SWP_NoMove or SWP_NoSize);
    end else begin
        SetWindowPos(Handle, HWND_NOTOPMOST, 0, 0, 0, 0,SWP_NoMove or SWP_NoSize);
        actStayOnTop.Caption:='on top: OFF';
    end;
end;


procedure TfrmMain.MessageToTray(str: string);
begin
    if (not Visible) then begin
        TrayIcon1.BalloonHint:=str;
        TrayIcon1.ShowBalloonHint;
    end;
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
