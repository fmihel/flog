program flog;

uses
  Forms,
  UFormMain in '..\Source\UFormMain.pas' {frmMain},
  UFormView in '..\Source\UFormView.pas' {frmView},
  UClassView in '..\Source\UClassView.pas',
  UFormSetup in '..\Source\UFormSetup.pas' {frmSetup},
  UParam in '..\Source\UParam.pas',
  ULog in '..\Source\ULog.pas',
  UMatching in '..\Source\UMatching.pas',
  UStr in '..\Source\UStr.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmSetup, frmSetup);
  Application.Run;
end.
