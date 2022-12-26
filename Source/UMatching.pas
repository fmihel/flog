{:
Данный модуль срдержит класс, 
для сопоставления строки шаблону ( подобно регулярным выражениям)
По умолчанию
* - любой символ и пусто
? - один любой непустой символ
$ - Один или более пробелов
& - ноль или более пробелов
. - аналогично ? но исключая пробел
_ - одна цифра
# - несколько подряд идущих цифр
}
unit UMatching;

interface
//{$define _log_}
//{$define _debug_}

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs;

const

    COUNT_META = 9;
    M_ESCAPE = '\';
    //                                                                          *             ?         [space]        .            _
    strMatchingKeyType:array[0..COUNT_META-1] of string = ('mktNone','mktKey','mktMetaZ','mktMetaP','mktMetaSpace','mktMetaT','mktMetaNum','mktMetaEms','mktMetaCount');
    strMatchingKey:array[0..COUNT_META-1] of string = ('','','*','?','$','.','_','&','#');


type

TMatchingKeyType = (mktNone,mktKey,mktMetaZ,mktMetaP,mktMetaSpace,mktMetaT,mktMetaNum,mktMetaEms,mktMetaCount);

TMatchingParseRec = class;
TMatchingParse = class;
TMatching = class;

    Matching = class(TObject)
    public
        class function Matching(aStr, aTemplate: string; aParse: TMatchingParse
            = nil): Boolean; static;
        class function Extract(aStr, aTemplate: string;aIndexOfReturnedParam:integer):string;overload; static;
        class function Extract(aStr:string; aTemplates:array of string;aIndexs:array of integer;aDefault:string = ''):string;overload; static;

        class function Escape(aStr:string):string;static;
        class function Loop(aStr:string;aTemplate:string;aIndexResult,aIndexFromLoop:integer;aOut:TStrings):boolean;static;

    end;

    TMatchingParseRec = class(TObject)
    public
        KeyType: TMatchingKeyType;
        Len: Integer;
        Pos: Integer;
        LenStory:integer;
        Value: string;
        procedure AssignTo(aTarget: TMatchingParseRec);
    end;

    TMatchingParse = class(TObject)
    private
        fList: TList;
        function getCount: Integer;
        function getItem(Index: Integer): TMatchingParseRec;
    public
        constructor Create; virtual;
        destructor Destroy; override;
        function Add(aRec: TMatchingParseRec): TMatchingParseRec; virtual;
        procedure AssignTo(aTarget: TMatchingParse);
        procedure Clear;
        procedure Delete(aIndex: Integer = -1); virtual;
        function Exists(aMatchingStringRec: TMatchingParseRec): Boolean;
        function IndexOf(aMatchingStringRec: TMatchingParseRec): Integer;
        function NewItem: TMatchingParseRec;
        property Count: Integer read getCount;
        property Item[Index: Integer]: TMatchingParseRec read getItem; default;
    end;

    TMatching = class(TObject)
    private
        fMeta:  array[0..COUNT_META-1] of string;
        fParse: TMatchingParse;
        function _Matching(aStr, aTemplate: string): Boolean;
        function _MatchingLoop(aStr: string; aCurrentKey, aRealPos: integer):
            Boolean;
    function GetMetaP: string;
    procedure SetMetaP(const Value: string);
    function GetMetaSpace: string;
    procedure SetMetaSpace(const Value: string);
    function GetMetaZ: string;
    procedure SetMetaZ(const Value: string);
    function GetMetaNum: string;
    function GetMetaT: string;
    procedure SetMetaNum(const Value: string);
    procedure SetMetaT(const Value: string);
    function GetMetaEms: string;
    procedure SetMetaEms(const Value: string);
    public
        constructor Create;
        destructor Destroy; override;
        function Matching(aStr, aTemplate: string): Boolean;
        function Conf(aStr:string;aParseIndex:integer):string;
        function ConfTrim(aStr:string;aParseIndex:integer):string;
        function ConfInt(aStr: string; aParseIndex: integer): integer;
        function Empty(aStr: string; aParseIndex: integer): boolean;
        property MetaP: string read GetMetaP write SetMetaP;
        property MetaSpace: string read GetMetaSpace write SetMetaSpace;
        property MetaZ: string read GetMetaZ write SetMetaZ;
        property MetaT: string read GetMetaT write SetMetaT;
        property MetaNum: string read GetMetaNum write SetMetaNum;
        property MetaEms: string read GetMetaEms write SetMetaEms;
        property Parse: TMatchingParse read fParse;
    end;


implementation

uses {$ifdef _log_}ULog,  {$endif} UStr;
{
*********************************** Matching ***********************************
}
class function Matching.Escape(aStr: string): string;
var
    cBuild:TStringBuilder;
  i: Integer;
begin
    // экранирование ключевых символов в строке
    cBuild:=TStringBuilder.Create;
    cBuild.Append(aStr);

    for i:=0 to Length(strMatchingKey) - 1 do
    begin
        if (strMatchingKey[i]<>'') then
            cBuild.Replace(strMatchingKey[i],M_ESCAPE+strMatchingKey[i]);
    end;

    result:=cBuild.ToString;
    cBuild.Free;
end;

class function Matching.Extract(aStr, aTemplate: string;
  aIndexOfReturnedParam: integer): string;
var
    cMatch:TMatching;
begin
    result:='';
    cMatch:=TMatching.Create;
    try
        if cMatch.Matching(aStr,aTemplate) then
            result:=cMatch.ConfTrim(aStr,aIndexOfReturnedParam);
    finally
        cMatch.Free;
    end;
end;

class function Matching.Extract(aStr:string; aTemplates:array of string;aIndexs:array of integer;aDefault:string = ''):string;
const
	cFuncName = 'Extract';
var
    cMatch:TMatching;
    cIndex:integer;
  i: Integer;
begin
    {$ifdef _log_} SLog.Stack(ClassName,cFuncName);{$endif}
    cMatch:=TMatching.Create;
    result:=aDefault;
    try
    try
        for i:=0 to length(aTemplates)-1 do
        begin
            if i>=Length(aIndexs) then
                cIndex:=aIndexs[Length(aIndexs)-1]
            else
                cIndex:=aIndexs[i];
            if cMatch.Matching(aStr,aTemplates[i]) then
            begin
                result:=cMatch.ConfTrim(aStr,(cIndex));
                exit;
            end
        end;

    except
    on e:Exception do
    begin
    	{$ifdef _log_}ULog.Error('',e,ClassName,cFuncName);{$endif}
    end;
    end;
    finally
        cMatch.Free;
    end;
end;


class function Matching.Loop(aStr, aTemplate: string;
  aIndexResult,aIndexFromLoop: integer; aOut: TStrings): boolean;
const
	cFuncName = 'Loop';
var
    cMatch:TMatching;
    cOriginal:string;
begin
    // применяем Match к результату обрезанному по aIndexFromLoop
    // а в aOut сохраняем значение из aIndexResult
    // В случае отрицательного сопоставления возварщает полную строку в aOut
    // Удобно для разбора строки на массив
    // Ex: Loop("1,2,3,6-7,4,","*,*",0,2,cOut) -
    // res: cOut[0] = "1"
    //      cOut[1] = "2
    //      cOut[2] = "3"
    //      cOut[3] = "6-7"
    //      cOut[4] = "4"
    //      cOut[5] = ""



    {$ifdef _log_} SLog.Stack(ClassName,cFuncName);{$endif}
    cMatch:=TMatching.Create;
    result:=false;
    aOut.Clear;
    cOriginal:=aStr;
    try
    try
    	//TO DO
        while cMatch.Matching(aStr,aTemplate) do
        begin
            aOut.Add(cMatch.Conf(aStr,aIndexResult));
            aStr:=copy(aStr,cMatch.Parse[aIndexFromLoop].Pos,Length(aStr));
            result:=true;
        end;
        if result then
            aOut.Add(aStr)
        else
            aOut.Add(cOriginal);

    except
    on e:Exception do
    begin
    	{$ifdef _log_}ULog.Error('',e,ClassName,cFuncName);{$endif}
        aOut.Add(cOriginal);
    end;
    end;
    finally
        cMatch.Free;
    end;
end;

class function Matching.Matching(aStr, aTemplate: string; aParse:
    TMatchingParse = nil): Boolean;
var
    cMatch: TMatching;

    const
        cFuncName = 'Matching';

begin
    cMatch:=TMatching.Create();
    try
    try
        result:=cMatch.Matching(aStr,aTemplate);
        if aParse<>nil then
            cMatch.Parse.AssignTo(aParse);
    except
    on e:Exception do
    begin
        {$ifdef _log_}ULog.Error('',e,ClassName,cFuncName);{$endif}
        result:=false;
    end;
    end;
    finally
        cMatch.Free;
    end;
end;

{
****************************** TMatchingParseRec *******************************
}
procedure TMatchingParseRec.AssignTo(aTarget: TMatchingParseRec);
begin
    if (aTarget<>nil) then
    begin
        aTarget.Len:=Len;
        aTarget.Pos:=Pos;
        aTarget.Value:=Value;
        aTarget.LenStory:=LenStory;
        aTarget.KeyType:=KeyType;
    end;
end;

{
******************************** TMatchingParse ********************************
}
constructor TMatchingParse.Create;
begin
    inherited Create;
    fList:=TList.Create;
end;

destructor TMatchingParse.Destroy;
begin
    Clear;
    fList.Free;
    inherited Destroy;
end;

function TMatchingParse.Add(aRec: TMatchingParseRec): TMatchingParseRec;
begin
    try
            result:=aRec;
            fList.Add(result);
    except
            result:=nil;
    end;
end;

procedure TMatchingParse.AssignTo(aTarget: TMatchingParse);
var
    i: Integer;
begin
    if (aTarget<>nil) then
    begin
        aTarget.Clear;
        for i:=0 to Count - 1 do
            Item[i].AssignTo(aTarget.NewItem);

    end;
end;

procedure TMatchingParse.Clear;
begin
    Delete(-1);
end;

procedure TMatchingParse.Delete(aIndex: Integer = -1);
var
    cObj: TMatchingParseRec;
begin
    if aIndex = -1 then
    begin
            while fList.Count>0 do
                Delete(fList.Count-1);
    end
    else
    begin
        cObj:=TMatchingParseRec(fList.Items[aIndex]);
        cObj.Free;
        fList.Delete(aIndex);
    end;
end;

function TMatchingParse.Exists(aMatchingStringRec: TMatchingParseRec): Boolean;
begin
    result:=(IndexOf(aMatchingStringRec)<>-1);
end;

function TMatchingParse.getCount: Integer;
begin
    result:=fList.Count;
end;

function TMatchingParse.getItem(Index: Integer): TMatchingParseRec;
begin
    result:=TMatchingParseRec(fList.Items[Index]);
end;

function TMatchingParse.IndexOf(aMatchingStringRec: TMatchingParseRec): Integer;
begin
    result:=fList.IndexOf(aMatchingStringRec);
end;

function TMatchingParse.NewItem: TMatchingParseRec;
begin
    result:=TMatchingParseRec.Create;
    Add(result);
end;

{
********************************** TMatching ***********************************
}
function TMatching.Conf(aStr: string; aParseIndex: integer): string;
var
  cRec: TMatchingParseRec;
begin
    cRec:=Parse.Item[aParseIndex];
    if cRec<>nil then
        result:=copy(aStr,cRec.Pos,cRec.Len)
    else
        result:='';
end;

function TMatching.Empty(aStr:string;aParseIndex:integer):boolean;
begin
    result:=(ConfTrim(aStr,aParseIndex) = '');
end;

function TMatching.ConfTrim(aStr: string; aParseIndex: integer): string;
begin
    result:=Trim(Conf(aStr,aParseIndex));
end;

function TMatching.ConfInt(aStr: string; aParseIndex: integer): integer;
begin
    try
        result:=StrToInt(ConfTrim(aStr,aParseIndex));
    except
        result:=-3333333;
    end;
end;

constructor TMatching.Create;
begin
    inherited Create;

    fParse:=TMatchingParse.Create;
    fMeta[integer(mktMetaZ)]:='*';
    fMeta[integer(mktMetaP)]:='?';
    fMeta[integer(mktMetaSpace)]:='$';
    fMeta[integer(mktMetaT)]:='.';
    fMeta[integer(mktMetaNum)]:='_';
    fMeta[integer(mktMetaEms)]:='&';
    fMeta[integer(mktMetaCount)]:='#';
end;

destructor TMatching.Destroy;
begin
    fParse.Free;
    inherited Destroy;
end;

function TMatching.GetMetaEms: string;
begin
    result:=fMeta[integer(mktMetaEms)];
end;

function TMatching.GetMetaNum: string;
begin
    result:=fMeta[integer(mktMetaNum)];
end;

function TMatching.GetMetaP: string;
begin
    result:=fMeta[integer(mktMetaP)];
end;

function TMatching.GetMetaSpace: string;
begin
    result:=fMeta[integer(mktMetaSpace)];
end;

function TMatching.GetMetaT: string;
begin
    result:=fMeta[integer(mktMetaT)];
end;

function TMatching.GetMetaZ: string;
begin
    result:=fMeta[integer(mktMetaZ)];
end;

function TMatching.Matching(aStr, aTemplate: string): Boolean;
begin
    result:=_Matching(aStr,aTemplate);
end;

procedure TMatching.SetMetaEms(const Value: string);
begin
    fMeta[integer(mktMetaEms)]:=Value;
end;

procedure TMatching.SetMetaNum(const Value: string);
begin
    fMeta[integer(mktMetaNum)]:=Value;
end;

procedure TMatching.SetMetaP(const Value: string);
begin
    fMeta[integer(mktMetaP)]:=Value;
end;

procedure TMatching.SetMetaSpace(const Value: string);
begin
    fMeta[integer(mktMetaSpace)]:=Value;
end;

procedure TMatching.SetMetaT(const Value: string);
begin
    fMeta[integer(mktMetaT)]:=Value;
end;

procedure TMatching.SetMetaZ(const Value: string);
begin
    fMeta[integer(mktMetaZ)]:=Value;
end;

function TMatching._Matching(aStr, aTemplate: string): Boolean;

var
    cTemplate: string;

    //cPosZ: Integer;
    //cPosP: Integer;
    //cPosS: Integer;

    cPos: Integer;
    cRec: TMatchingParseRec;
    cKeyType: TMatchingKeyType;
    cTmp: string;
    arPos:array[1..COUNT_META-1] of integer;
    cAddToPrev: boolean;
    cBuilder:TStringBuilder;
  i: Integer;

    procedure _set_pos();
    var
            i:integer;
    begin
        for i:=1 to COUNT_META-1 do
             arPos[i]:=StrUtils.PosWithoutShield(fMeta[i],cTemplate);
    end;

    function _absent():boolean;
    var
            i:integer;
    begin
        result:=false;
        for i:=1 to COUNT_META-1 do
            if arPos[i]>0 then
                exit;
        result:=true;
    end;

    procedure _assept();
    var
            i,j:integer;
            cPosUp,cPosDn:integer;
            cBool:boolean;
    begin

         for i:=1 to COUNT_META -1 do
         begin
            cPosUp:=arPos[i];
            cBool:=(cPosUp > 0);
            if (cBool) then
            begin
                for j:=1 to COUNT_META-1 do
                begin
                    if j<>i then
                    begin
                        cPosDn:=arPos[j];
                        cBool:=((cPosUp<cPosDn) or (cPosDn=0)) and cBool;
                    end;
                end;//for j
            end;//if

            if cBool then
            begin
                cPos:=cPosUp;
                cKeyType:=TMatchingKeyType(i);
                break;
            end;
         end;
    end;

    procedure _set_init_len();
    begin
        if (cKeyType = mktMetaP) or (cKeyType = mktMetaT) or (cKeyType = mktMetaNum) or (cKeyType = mktMetaSpace) or (cKeyType = mktMetaCount) then
            cRec.Len:=1
        else
            cRec.Len:=0;
        cRec.LenStory:=cRec.Len;
    end;

    function _remove_shield(aStr:string):string;
    var
        i:integer;
    begin
        i:=1;
        while i<Length(aStr) do
        begin
            if (aStr[i] = M_ESCAPE) and (i<Length(aStr)) and (aStr[i+1]<> M_ESCAPE) then
                delete(aStr,i,1)
            else
                inc(i);
        end;

        result:=aStr;
    end;

    procedure _check_prev();
    begin
        cAddToPrev:=false;
        if fParse.Count>0 then
        begin
            cRec:=fParse.Item[fParse.Count-1];
            if fParse.Item[fParse.Count-1].KeyType <> mktKey then
                cRec:=fParse.NewItem
            else
                cAddToPrev:=true;
        end
        else
            cRec:=fParse.NewItem;

        cRec.KeyType:=mktKey;
    end;

    const
        cFuncName = '_Matching';


begin
    // aTemplate = World1 * World?World
    // * - любое колво и ни одного
    // ? - один лбой символ

    // разбираем строку
    fParse.Clear;
    cBuilder:=TStringBuilder.Create;

    try
    try
        // убираем двойной слеш из экранов
        cTemplate:=cBuilder.Append(aTemplate).Replace(M_ESCAPE+M_ESCAPE,M_ESCAPE+#191).ToString;
        //cTemplate:=aTemplate;

        while Length(cTemplate)>0 do
        begin
            _set_pos();
            if (_absent()) then
            begin
                _check_prev();

                cTemplate:=_remove_shield(cTemplate);
                if cAddToPrev then
                begin
                    cRec.Value:=cRec.Value+cTemplate;
                    cRec.Len:=cRec.Len+Length(cTemplate);
                end
                else
                begin
                    cRec.Value:=cTemplate;
                    cRec.Len:=Length(cTemplate);
                end;
                cRec.LenStory:=cRec.Len;
                cTemplate:='';
            end
            else
            begin
                _assept();

                if cPos>1 then
                begin
                    cTmp:=_remove_shield(copy(cTemplate,1,cPos-1));
                    _check_prev();
                    if cAddToPrev then
                    begin
                        cRec.Value:=cRec.Value+cTmp;
                        cRec.Len:=cRec.Len+Length(cTmp);
                    end
                    else
                    begin
                        cRec.Value:=cTmp;
                        cRec.Len:=Length(cTmp);
                    end;
                    cRec.LenStory:=cRec.Len;
                    //cRec.KeyType:=mktKey;
                    //cRec.Value:=cTmp;
                    //cRec.Len:=Length(cTmp);
                    //cKeys.Add(cTmp);


                    cTmp:=copy(cTemplate,cPos,1);
                    if fParse<>nil then
                    begin
                        cRec:=fParse.NewItem;
                        cRec.KeyType:=cKeyType;
                        cRec.Value:=cTmp;
                        _set_init_len();
                    end;
                    //cKeys.Add(cTmp);
                end
                else
                begin
                    cTmp:=copy(cTemplate,cPos,1);
                    if fParse<>nil then
                    begin
                        cRec:=fParse.NewItem;
                        cRec.KeyType:=cKeyType;
                        cRec.Value:=cTmp;
                        _set_init_len();
                    end;
                    //cKeys.Add(cTmp);
                end;


                cTemplate:=copy(cTemplate,cPos+1,Length(cTemplate));
            end;
        end;

        for i:=0 to fParse.Count-1 do
        begin
                cBuilder.Length:=0;
                fParse.Item[i].Value:=cBuilder.Append(fParse.Item[i].Value).Replace(#191,M_ESCAPE).ToString;
                {$ifdef _debug_} ULog.Log('%d Key=%s Value=%s ',[i,strMatchingKeyType[integer(fParse.Item[i].KeyType)],fParse.Item[i].Value],ClassName,cFuncName);{$endif}
        end;
        // начинаем проходку
        result:=_MatchingLoop(aStr,0,1);

    except
    on e:Exception do
    begin
        {$ifdef _log_}ULog.Error('',e,ClassName,cFuncName);{$endif}
        result:=false;

    end;
    end;
    finally
        //cKeys.Free;
        cBuilder.Free;
    end;
end;

function TMatching._MatchingLoop(aStr: string; aCurrentKey, aRealPos: integer):
    Boolean;
var
    cPos: Integer;
    cRec: TMatchingParseRec;
    cBuf: string;
    cTmp:string;
    cAdd:integer;
    function IsEnd():boolean;
    begin
        result:= (aCurrentKey >= (fParse.Count-1));
    end;

    function _single():boolean;
    begin
        result:=(((Length(aStr) = 1) and IsEnd()) or (Length(aStr)>0) and not IsEnd());
    end;

    function _getendnumpos():integer;
    begin
        result:=0;
        if aStr = '' then
            exit;
        while StrUtils.CharIsNum(Char(aStr[result+1])) do
            result:=result+1;
    end;
    const
        cFuncName = '_MatchingLoop';

begin
    result:=false;

    try
    try
        // получаем текущий ключ
        //cNext:=_GetNextKey(aCurrentKey,aKeys);
        result:=false;
        cRec:=fParse.Item[aCurrentKey];
        cRec.Len:=cRec.LenStory;
        cRec.Pos:=aRealPos;

        case cRec.KeyType of
            mktKey:
            begin
                cPos:=Pos(cRec.Value,aStr);
                if cPos = 1 then
                begin
                    if not IsEnd() then
                    begin
                        cBuf:=copy(aStr,cRec.Len+1,Length(aStr));
                        result:=_MatchingLoop(cBuf, aCurrentKey+1,aRealPos+cRec.Len);
                    end
                    else
                        result:=(cRec.Value = aStr);
                end
                else
                    result:=false;
            end;
            mktMetaZ:
            begin
                result:=false;
                cBuf:=aStr;
                while (not result) do
                begin
                    if not IsEnd() then
                    begin
                        if (Length(cBuf)>0) then
                        begin
                            cBuf:=copy(aStr,cRec.Len+1,Length(aStr));
                            result:=_MatchingLoop(cBuf, aCurrentKey+1,aRealPos+cRec.Len);
                            if not result then
                                cRec.Len:=cRec.Len+1;
                        end
                        else
                            exit;// result = false;
                    end
                    else
                    begin
                        cRec.Len:=Length(aStr);
                        result:=true;
                    end;

                end;//while
            end;
            mktMetaEms:
            begin
                result:=false;
                cBuf:=aStr;
                cRec.Len:=0;
                while (not result) do
                begin
                    if IsEnd() then
                    begin
                        result:=(Trim(cBuf) = '');
                        if result then
                            cRec.Len:=Length(cBuf);
                        exit;
                    end
                    else
                    begin

                        if Length(cBuf) = 0 then
                            exit;

                        cTmp:=copy(aStr,1,cRec.Len);
                        cBuf:=copy(aStr,cRec.Len+1,Length(aStr));

                        if (Trim(cTmp) = '') then
                        begin
                            result:=_MatchingLoop(cBuf, aCurrentKey+1,aRealPos+cRec.Len);
                            if not result then
                                cRec.Len:=cRec.Len+1
                            else
                                exit;
                        end
                        else
                            exit;
                    end;
                end;//while
            end;
            mktMetaP:
            begin
                result:=_single();
                if (result) and (not IsEnd()) then
                begin
                    cBuf:=copy(aStr,cRec.Len+1,Length(aStr));
                    result:=_MatchingLoop(cBuf, aCurrentKey+1,aRealPos+cRec.Len);
                end;
            end;
            mktMetaT:
            begin
                result:=_single() and (aStr[1]<>' ');
                if (result) and (not IsEnd()) then
                begin
                    cBuf:=copy(aStr,cRec.Len+1,Length(aStr));
                    result:=_MatchingLoop(cBuf, aCurrentKey+1,aRealPos+cRec.Len);
                end;
            end;
            mktMetaNum:
            begin
                result:=_single() and (StrUtils.CharIsNum(Char(aStr[1])));
                if (result) and (not IsEnd())then
                begin
                    cBuf:=copy(aStr,cRec.Len+1,Length(aStr));
                    result:=_MatchingLoop(cBuf, aCurrentKey+1,aRealPos+cRec.Len);
                end;
            end;
            mktMetaCount:
            begin
                cAdd:=_getendnumpos();
                result:=(cAdd>0);
                cRec.Len:=0;
                if (result) then
                begin
                    result      :=false;
                    cRec.Len    :=cAdd;

                    while (cRec.Len>0) do
                    begin
                        cBuf:=copy(aStr,cRec.Len+1,Length(aStr));
                        if (Length(cBuf)>0) then
                        begin
                            if (not IsEnd()) then
                            begin
                                result:=_MatchingLoop(cBuf, aCurrentKey+1,aRealPos+cRec.Len);
                                if result then
                                    break;
                            end
                            else
                                break;
                        end
                        else
                        begin
                            if IsEnd() then
                            begin
                                result:=true;
                                break;
                            end
                            else
                            begin
                                result:=_MatchingLoop(cBuf, aCurrentKey+1,aRealPos+cRec.Len);
                                if result then
                                    break;
                            end;
                        end;
                        dec(cRec.Len);
                    end;
                end;
            end;//mktMetaSpace:

            mktMetaSpace:
            begin
                result:=false;
                cBuf:=aStr;
                cRec.Len:=Length(cBuf)-Length(TrimLeft(cBuf));
                //result:= (cRec.Len>0);
                if cRec.Len>0 then
                while (not result) do
                begin
                    if IsEnd() then
                    begin
                        result:=(Length(cBuf)=0) or (Trim(cBuf) = '');
                        if result then
                            cRec.Len:=Length(cBuf);
                        exit;
                    end
                    else
                    begin
                        cBuf:=copy(cBuf,cRec.Len+1,Length(cBuf));
                        result:=_MatchingLoop(cBuf, aCurrentKey+1,aRealPos+cRec.Len);
                        if not result then
                            cRec.Len:=cRec.Len-1;

                        if (result) or (cRec.Len <0) then
                            exit;
                    end;
                end;//while

            end;//mktMetaSpace:

        end;// case
    except
    on e:Exception do
    begin
        {$ifdef _log_}ULog.Error('',e,ClassName,cFuncName);{$endif}
    end;
    end;
    finally

    end;
end;



end.
