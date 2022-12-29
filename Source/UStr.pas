unit UStr;
interface
{-$define _log_}
{-$define _debug_}

type
  TGetCountMethod   = (gcmNormal,gcmSuccessive,gcmSuccessiveRight);
type
    TStr = class(TObject)
    public
        class function CharIsNum(c:char): Boolean; static;
        class function GetCountChr(aStr, aSubStr: String; aGetCountMethod:
            TGetCountMethod = gcmNormal): Integer; static;
        class function PosWithoutShield(aSearch:string;aSource:string;
            aShield:string='\'): Integer; static;
        {:
        RPos() возвращает первый символ последней найденной
        подстроки Find в строке Search. Если Find не найдена,
        функция возвращает 0. Подобна реверсированной Pos().
        }
        class function RPos(const aSubStr, aStr: string; aNum: integer = 1):
            Integer; static;
    end;

var
    StrUtils:TStr;

implementation
{$ifdef _log_}uses ULog; {$endif}
// --------------------------------------------------------
{
************************************* TStr *************************************
}
class function TStr.CharIsNum(c:char): Boolean;
begin
    result:=(ord(c)>=48) and (ord(c)<=57);
end;

class function TStr.GetCountChr(aStr, aSubStr: String; aGetCountMethod:
    TGetCountMethod = gcmNormal): Integer;
var
    cPos: Integer;
begin
    result:=0;
    case aGetCountMethod of
        gcmNormal: // просто подсчет уникальных непересекающихся вхождений
        begin
            while (Pos(aSubStr,aStr)>0) do
            begin
                result:=result+1;
                aStr:=copy(aStr,pos(aSubStr,aStr)+length(aSubStr),length(aStr));
            end;
        end;
        gcmSuccessive: // подсчет непересекающихся вхождений подряд с левого края
        begin
            cPos:=Pos(aSubStr,aStr);
            while cPos = 1 do
            begin
                result:=result+1;
                aStr:=copy(aStr,Length(aSubStr)+1,Length(aStr));
                cPos:=Pos(aSubStr,aStr);
            end;
        end;
        gcmSuccessiveRight: // подсчет непересекающихся вхождений подряд с правого края
        begin
            if Length(aStr) >0 then
            begin
                cPos:=RPos(aSubStr,aStr);
                while (cPos>0) and (cPos = Length(aStr)-Length(aSubStr)+1) do
                begin
                    result:=result+1;
                    aStr:=copy(aStr,1,cPos-1);
                    cPos:=RPos(aSubStr,aStr);
                end;
            end;// if Length(aStr) >0 then
        end;
    end;//case;
end;

class function TStr.PosWithoutShield(aSearch:string;aSource:string;
    aShield:string='\'): Integer;
var
    cBool: Boolean;
    cAdd: Integer;
    cStr, cTmp: string;
    cPos: Integer;
    cCount: Integer;
    cLen: Integer;
    cLenMax: Integer;

    function _IsNotShield():boolean;
    begin
      result:=false;
    end;

begin
    result:=0;
    cStr:=aSource;
    //cBool:=false;
    cAdd:=0;
    cLen:=Length(aSearch);
    cLenMax:=Length(aSource);
    // определяет позицию строки поиска, при условии, что она не экранирована aShield
    //  Ex:  PosWithoutShield('*','string\*sring*','\') = 14
    //  Ex:  PosWithoutShield('*','string\\*sring*','\') = 9
    cBool:=true;
    while cBool do
    begin
        cPos:=Pos(aSearch,cStr);
        cBool:=(cPos <> 0);
        if (cBool) then
        begin
            // обрезаем строку и смотри не экранирован ли символ
            cTmp:=Copy(cStr,1,cPos-1);
            cCount:=GetCountChr(cTmp,aShield,gcmSuccessiveRight);
            // если нет экрана или экранов четное ко-во
            if (cCount = 0) or ((cCount and 1) = 0) then
            begin
                cBool:=false;
                result:=cPos+cAdd;
            end
            else
            begin
                cStr:=Copy(cStr,cPos+cLen,cLenMax);
                cAdd:=cAdd+cPos;
                cBool:=true;
            end;
        end
    end;
end;

class function TStr.RPos(const aSubStr, aStr: string; aNum: integer = 1):
    Integer;
var
    cLenStr: Integer;
    cStr: string;
    cLenSubStr: Integer;
begin
    result:=0;
    cLenStr:=Length(aStr);
    cLenSubStr:=Length(aSubStr);
    if cLenSubStr>cLenStr then
    begin
          result:=0;
          exit;
    end;

    cLenStr:=cLenStr-cLenSubStr+1;

    while cLenStr>0 do
    begin
          cStr:=copy(aStr,cLenStr,cLenSubStr);
          if cStr = aSubStr then
          begin
                  aNum:=aNum-1;
                  if aNum = 0 then
                  begin
                          result:=cLenStr;
                          exit;
                  end;
          end;
          cLenStr:=cLenStr-1;
    end;
end;


initialization
end.
