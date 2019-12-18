unit UFormSetup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrmSetup = class(TForm)
    cbInterval: TComboBox;
    Label1: TLabel;
    Panel1: TPanel;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure cbIntervalChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure initTimer();

  end;

var
  frmSetup: TfrmSetup;

implementation

uses UFormMain;

{$R *.dfm}

procedure TfrmSetup.Button1Click(Sender: TObject);
begin
    close;
end;

procedure TfrmSetup.cbIntervalChange(Sender: TObject);
var Timer1:TTimer;
begin
    Timer1:=frmMain.Timer1;
    if (cbInterval.ItemIndex = 0 ) then
    begin
        Timer1.Enabled:=false;
        exit;
    end;

    Timer1.Enabled:=true;

    if (cbInterval.ItemIndex = 1 ) then
        Timer1.Interval:=2*1000;

    if (cbInterval.ItemIndex = 2 ) then
        Timer1.Interval:=5*1000;

    if (cbInterval.ItemIndex = 3 ) then
        Timer1.Interval:=10*1000;

    if (cbInterval.ItemIndex = 4 ) then
        Timer1.Interval:=60*1000;

end;

procedure TfrmSetup.initTimer;
begin

end;

end.
