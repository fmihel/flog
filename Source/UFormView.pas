unit UFormView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,  StdCtrls, UClassView, Menus, ActnList,
  PlatformDefaultStyleActnCtrls, ActnMan, ExtCtrls, Buttons;
const
    C_FILE = 'E:\Delphi7\LogMonitor\data\access1.log';
type
  TfrmView = class(TForm)
    Memo: TMemo;
    ActionManager1: TActionManager;
    PopupMenu1: TPopupMenu;
    actClose: TAction;
    close1: TMenuItem;
    actClear: TAction;
    clear1: TMenuItem;
    PanelName: TPanel;
    PanelNameText: TLabel;
    SpeedButton6: TSpeedButton;
    Timer1: TTimer;
    SpeedButton7: TSpeedButton;
    procedure actClearExecute(Sender: TObject);
    procedure actCloseExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure PanelNameMouseDown(Sender: TObject; Button: TMouseButton; Shift:
        TShiftState; X, Y: Integer);
    procedure PanelNameMouseMove(Sender: TObject; Shift: TShiftState; X, Y:
        Integer);
    procedure PanelNameMouseUp(Sender: TObject; Button: TMouseButton; Shift:
        TShiftState; X, Y: Integer);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
    fMovet:boolean;
    fMovetX:integer;
    fMovetY:integer;
    procedure AlignPanel;
  public
    { Public declarations }
    view:TView;
    function LoadFile(aFileName:string):boolean;
    procedure DoNewData(sender:TObject;str:string);
    procedure DoActivate(Sender:TObject;Activate:boolean);

  end;

var
  frmView: TfrmView;

implementation

uses
  UFormMain, ULog, UParam;

{$R *.dfm}
function GetVisibleLineCount(Memo: TMemo): Integer;
var
  DC: HDC;
  SaveFont: HFONT;
  TextMetric: TTextMetric;
  EditRect: TRect;
begin
  DC := GetDC(0);
  SaveFont := SelectObject(DC, Memo.Font.Handle);
  GetTextMetrics(DC, TextMetric);
  SelectObject(DC, SaveFont);
  ReleaseDC(0, DC);

  Memo.Perform(EM_GETRECT, 0, LPARAM(@EditRect));
  Result := (EditRect.Bottom - EditRect.Top) div TextMetric.tmHeight;
end;
function IsVisibleScrollbar(Memo:TMemo):boolean;
begin
    result:=GetVisibleLineCount(Memo)<Memo.Lines.Count;
end;
function MouseOnCtrl(Ctrl:TWinControl):boolean;
var
  MyPoint : TPoint;
begin
  MyPoint := Ctrl.ScreenToClient(Mouse.CursorPos);

  if PtInRect(Ctrl.ClientRect, MyPoint) then
     result:=true
  else
    result:=false;

end;
procedure TfrmView.actClearExecute(Sender: TObject);
var s:TStringList;
begin
    s:=TSTringList.Create;
    try
    try
        s.SaveToFile(self.view.FileName);
    except
    on e:Exception do
    begin

    end;
    end;
    finally
        s.Free;
    end;
end;

procedure TfrmView.actCloseExecute(Sender: TObject);
begin
    close;
end;

procedure TfrmView.DoActivate(Sender: TObject; Activate: boolean);
begin
    if Activate then begin
        Memo.ScrollBars:=ssBoth;
        PanelName.Visible:=false;
    end else begin
        Memo.ScrollBars:=ssNone;
        if (frmMain.LastFormPlaceMode='') then
            PanelName.Visible:=true;
    end;

    SendMessage(Memo.Handle, EM_LINESCROLL, 0,memo.Lines.Count);
    AlignPanel;
end;

procedure TfrmView.DoNewData(sender: TObject; str: string);
begin
    TfrmMain(owner).MessageToTray(Utf8ToAnsi(str));
end;

procedure TfrmView.FormClose(Sender: TObject; var Action: TCloseAction);
var i:integer;
begin
    Action:=caFree;
    i:=param.Files.IndexOf(Caption);
    if (i>=0) then
        param.Files.Delete(i);
end;

procedure TfrmView.FormDestroy(Sender: TObject);
begin
    view.Free;
end;

function TfrmView.LoadFile(aFileName: string): boolean;
begin
    view.LoadFile(aFileName);
    caption:=aFileName;
    result:=true;
    PanelNameText.Caption:=ExtractFileName(aFileName);
end;

procedure TfrmView.FormCreate(Sender: TObject);
begin
    view:=TView.Create();
    view.OnNewData:=DoNewData;
    view.memo:=Memo;
    view.Form:=self;
    fMovet:=false;

end;
procedure TfrmView.AlignPanel();
begin
    PanelName.Top:=0;
    PanelName.Left:=Width-PanelName.Width-16;

    if (IsVisibleScrollBar(Memo) and (Memo.ScrollBars<>ssNone)) then
        PanelName.Left:=PanelName.Left-18;
end;
procedure TfrmView.FormResize(Sender: TObject);
begin
    if self.WindowState = wsMaximized then
        frmMain.LastFormPlaceMode:='';
    AlignPanel();
end;

procedure TfrmView.PanelNameMouseDown(Sender: TObject; Button: TMouseButton;
    Shift: TShiftState; X, Y: Integer);
begin
    fMovet:=true;
    fMovetX:=Mouse.CursorPos.X;
    fMovetY:=Mouse.CursorPos.Y;
end;

procedure TfrmView.PanelNameMouseMove(Sender: TObject; Shift: TShiftState; X,
    Y: Integer);
begin
    if fMovet then begin
        //frmMain.Left:=frmMain.Left+1;
        frmMain.Left:=frmMain.Left+Mouse.CursorPos.X - fMovetX;
        frmMain.Top:=frmMain.Top+Mouse.CursorPos.Y - fMovetY;
        fMovetX:=Mouse.CursorPos.X;
        fMovetY:=Mouse.CursorPos.Y;
    end;
end;

procedure TfrmView.PanelNameMouseUp(Sender: TObject; Button: TMouseButton;
    Shift: TShiftState; X, Y: Integer);
begin
    fMovet:=false;
end;

procedure TfrmView.Timer1Timer(Sender: TObject);
var
    TopLine:integer;
begin
    if PanelName.Visible then begin

        if (MouseOnCtrl(self))  then begin

             if ( (Memo.ScrollBars=ssNone) and (GetVisibleLineCount(Memo) < Memo.Lines.Count) ) then begin
                TopLine:=Memo.Perform(EM_GETFIRSTVISIBLELINE, 0, 0);
                Memo.ScrollBars:=ssBoth;
                SendMessage(Memo.Handle, EM_LINESCROLL, 0,TopLine);
                AlignPanel;
             end;
        end else begin
             if (Memo.ScrollBars=ssBoth) then begin
                TopLine:=Memo.Perform(EM_GETFIRSTVISIBLELINE, 0, 0);
                Memo.ScrollBars:=ssNone;
                SendMessage(Memo.Handle, EM_LINESCROLL, 0,TopLine);
                AlignPanel;
             end;

        end;
    end;
end;

end.
