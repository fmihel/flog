unit UFormView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,  StdCtrls, UClassView, Menus, ActnList,
  PlatformDefaultStyleActnCtrls, ActnMan;
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
    procedure actClearExecute(Sender: TObject);
    procedure actCloseExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    view:TView;
    function LoadFile(aFileName:string):boolean;
    procedure DoNewData(sender:TObject;str:string);
  end;

var
  frmView: TfrmView;

implementation

uses
  UFormMain;

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

procedure TfrmView.DoNewData(sender: TObject; str: string);
begin
    TfrmMain(owner).MessageToTray(Utf8ToAnsi(str));
end;

procedure TfrmView.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action:=caFree;
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
end;

procedure TfrmView.FormCreate(Sender: TObject);
begin
    view:=TView.Create();
    view.OnNewData:=DoNewData;
    view.memo:=Memo;
    view.Form:=self;


end;

end.
