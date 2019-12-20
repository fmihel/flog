unit ULog;

interface

procedure log(aMsg:string;aFuncName:string = '';aClassName:string='');

implementation

uses
  Windows, Forms;

procedure log(aMsg:string;aFuncName:string = '';aClassName:string='');
var
    cMsg:string;
    cPoint:string;
    cApp:string;
begin
    cApp:=Application.ExeName;
    if (aClassName<>'') or (aFuncName<>'') then
        cApp:=cApp+':';

    if (aClassName<>'') and (aFuncName<>'') then
        cPoint:='.'
    else
        cPoint:='';

    cMsg:='{ '+cApp+aClassName+cPoint+aFuncName+' } '+aMsg;

    Windows.OutputDebugString(PWideChar(cMsg));
end;
end.
