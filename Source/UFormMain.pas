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
    ComboBox1: TComboBox;
    OpenDialog1: TOpenDialog;
    ComboBox2: TComboBox;
    TrayIcon1: TTrayIcon;
    PopupMenu1: TPopupMenu;
    actReturnFromTray: TAction;
    actGoToTray: TAction;
    show1: TMenuItem;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure actAddExecute(Sender: TObject);
    procedure actGoToTrayExecute(Sender: TObject);
    procedure actReturnFromTrayExecute(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations}
    procedure initTimer();
    procedure initPlace();
  public
    { Public declarations }
    procedure MessageToTray(str:string);
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.FormCreate(Sender: TObject);
begin
    initTimer();
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

procedure TfrmMain.ComboBox1Change(Sender: TObject);
begin
    initTimer();
end;

procedure TfrmMain.ComboBox2Change(Sender: TObject);
begin
    initPlace();
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
    Color:=$003F342C;
    self.BringToFront;

end;

procedure TfrmMain.initPlace;
begin
    if (ComboBox1.ItemIndex = 0 ) then
        self.Cascade;

    if (ComboBox1.ItemIndex = 1 ) then begin
        TileMode:=tbHorizontal;
        Tile();
    end;
    if (ComboBox1.ItemIndex = 2 ) then begin
        TileMode:=tbVertical;
        Tile();
    end;

end;

procedure TfrmMain.initTimer;
begin
    if (ComboBox1.ItemIndex = 0 ) then
    begin
        Timer1.Enabled:=false;
        exit;
    end;

    Timer1.Enabled:=true;

    if (ComboBox1.ItemIndex = 1 ) then
        Timer1.Interval:=2*1000;

    if (ComboBox1.ItemIndex = 2 ) then
        Timer1.Interval:=5*1000;

    if (ComboBox1.ItemIndex = 3 ) then
        Timer1.Interval:=10*1000;

    if (ComboBox1.ItemIndex = 4 ) then
        Timer1.Interval:=60*1000;

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
