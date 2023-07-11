unit UTrayForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, UFormMain;

type
  TfrmTray = class(TForm)
    Timer1: TTimer;
    Memo1: TMemo;
    SpeedButton8: TSpeedButton;
    Panel1: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure Memo1Click(Sender: TObject);
    procedure Memo1DblClick(Sender: TObject);
    procedure SpeedButton8Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Show(aMsg:string);
  end;

var
  frmTray: TfrmTray;

procedure ViewTray(aMsg:string);
implementation

{$R *.dfm}

procedure ViewTray(aMsg:string);
var
  frm: TfrmTray;
begin
    frm:=TfrmTray.Create(Application);
    frm.Show(aMsg);
    frm.Visible:=true;
end;

procedure TfrmTray.FormCreate(Sender: TObject);
begin
    Left:=    Screen.Width- width-5;
    Top:=    Screen.Height- height-32;
end;

procedure TfrmTray.Memo1Click(Sender: TObject);
begin
    frmMain.actReturnFromTrayExecute(nil);
    close;
end;

procedure TfrmTray.Memo1DblClick(Sender: TObject);
begin
end;

{ TForm1 }

procedure TfrmTray.Show(aMsg: string);
begin
    Memo1.Lines.Text:=aMsg;

end;

procedure TfrmTray.SpeedButton8Click(Sender: TObject);
begin
    close;
end;

procedure TfrmTray.Timer1Timer(Sender: TObject);
begin
Close;
end;

end.
