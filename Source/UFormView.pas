unit UFormView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,  StdCtrls, UClassView, Menus, ActnList,
  PlatformDefaultStyleActnCtrls, ActnMan, ExtCtrls;
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
    N1: TMenuItem;
    PanelName: TPanel;
    PanelNameText: TLabel;
    procedure actClearExecute(Sender: TObject);
    procedure actCloseExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
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


end;

procedure TfrmView.FormResize(Sender: TObject);
begin
    if self.WindowState = wsMaximized then
        frmMain.LastFormPlaceMode:='';
    PanelName.Top:=0;
    PanelName.Left:=Width-PanelName.Width-16;

end;

end.
