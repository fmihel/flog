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
    cbAlwaysOnTop: TCheckBox;
    cbHideScrollBarOnInActive: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure CommonChange(Sender: TObject);
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
    procedure initDefault;
  end;

var
  frmSetup: TfrmSetup;

implementation

uses UFormMain, UParam, ULog;

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

procedure TfrmSetup.CommonChange(Sender: TObject);
begin
    if (canChange()) then begin
        beginChange();
        param.beginChange();
        try try

            param.IndexOfIntervalRefresh := cbInterval.ItemIndex;
            param.trayOnMinimize:=cbTrayOnMinimize.Checked;
            param.alwaysOnTop:=cbAlwaysOnTop.Checked;
            param.HideScrollBarOnInActive:=cbHideScrollBarOnInActive.Checked;

        except on e:Exception do begin
            log(e.Message,'CommonChange',ClassName);
        end;end;
        finally
            param.endChange();
            endChange();
        end;
    end;
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
        beginChange();
        param.beginChange();

        cbInterval.ItemIndex:=param.IndexOfIntervalRefresh;
        cbTrayOnMinimize.Checked:=param.trayOnMinimize;
        cbAlwaysOnTop.Checked:=param.alwaysOnTop;
        cbHideScrollBarOnInActive.Checked := param.HideScrollBarOnInActive;

        param.endChange(false);
        endChange();
    end;
end;


procedure TfrmSetup.initDefault;
begin
    //beginChange();
    param.initDefault;
    //endChange();
end;

end.
