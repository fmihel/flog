unit ULog;

interface

procedure log(msg:string);

implementation

uses
  Windows;

procedure log(msg:string);
begin
    Windows.OutputDebugString(PWideChar(msg));
end;
end.
