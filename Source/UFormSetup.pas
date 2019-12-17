unit UFormSetup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrmSetup = class(TForm)
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    Label1: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSetup: TfrmSetup;

implementation

{$R *.dfm}

end.
