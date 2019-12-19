unit UFormSetup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ActnList;

type
  TfrmSetup = class(TForm)
    cbInterval: TComboBox;
    Label1: TLabel;
    Panel1: TPanel;
    Button1: TButton;
    cbTrayOnMinimize: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure cbIntervalChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    fchange:integer;
    procedure beginChange;
    procedure endChange;
    function canChange:boolean;
  public
    { Public declarations }
    procedure FromParam(Sender:TObject);
  end;

var
  frmSetup: TfrmSetup;

implementation

uses UFormMain, UParam;

{$R *.dfm}

procedure TfrmSetup.FormCreate(Sender: TObject);
begin
    param.OnChange(FromParam);
    fchange:=0;
end;


procedure TfrmSetup.beginChange;
begin
    fChange:=fChange+1;
end;

procedure TfrmSetup.Button1Click(Sender: TObject);
begin
    close;
end;

function TfrmSetup.canChange: boolean;
begin
    result:=fchange = 0;
end;

procedure TfrmSetup.cbIntervalChange(Sender: TObject);
begin
    beginChange();
        param.beginChange();
        param.IndexOfIntervalRefresh := cbInterval.ItemIndex;
        param.trayOnMinimize:=cbTrayOnMinimize.Checked;
        param.endChange();
    endChange();
end;

procedure TfrmSetup.endChange;
begin
    fChange:=fChange-1;
end;

procedure TfrmSetup.FormShow(Sender: TObject);
begin
    SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0,SWP_NoMove or SWP_NoSize);
end;

procedure TfrmSetup.FromParam(Sender: TObject);
begin
    if (canChange()) then begin
        param.beginChange();
        cbInterval.ItemIndex:=param.IndexOfIntervalRefresh;
        param.endChange(false);
    end;
end;


end.
