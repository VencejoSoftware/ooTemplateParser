{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit TemplateParser_test;

interface

uses
  SysUtils, DateUtils,
  ooParser.Intf, ooParser.Callback, ooParser.Variable,
  ooTemplateParser, ooTemplateParser.Tag.List,
  ooText.Match.WordInsensitive, ooText.Match.WordSensitive,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TTemplateParserTest = class(TTestCase)
  published
    procedure TestComplex;
    procedure TestComplexStaticValue;
    procedure TestEvaluateFirstDelimiter;
    procedure TestEvaluateLastDelimiter;
    procedure TestEvaluateTwoDelimiter;
    procedure TestEvaluateFirstDelimiterWhole;
    procedure TestEvaluateLastDelimiterWhole;
    procedure TestEvaluateCaseSensitive;
  end;

implementation

function GetDay: string;
var
  d: word;
begin
  d := DayOf(now);
  if d < 10 then
    Result := '0' + IntToStr(d)
  else
    Result := IntToStr(d);
end;

function GetDayCallback(const aCallBack: IParserCallback): string;
begin
  Result := GetDay;
end;

function GetMonth: string;
var
  d: word;
begin
  d := MonthOf(now);
  if d < 10 then
    Result := '0' + IntToStr(d)
  else
    Result := IntToStr(d);
end;

function GetMonthCallback(const aCallBack: IParserCallback): string;
begin
  Result := GetMonth;
end;

function GetYear: string;
var
  d: word;
begin
  d := YearOf(now);
  Result := IntToStr(d);
end;

function GetYearCallback(const aCallBack: IParserCallback): string;
begin
  Result := GetYear;
end;

function GetDate: string;
var
  d, m: word;
begin
  d := DayOf(now);
  if d < 10 then
    Result := '0' + IntToStr(d) + '/'
  else
    Result := IntToStr(d) + '/';
  m := MonthOf(now);
  if m < 10 then
    Result := Result + '0' + IntToStr(m) + '/'
  else
    Result := IntToStr(m) + '/';
  Result := Result + IntToStr(YearOf(now));
end;

function GetDateCallback(const aCallBack: IParserCallback): string;
begin
  Result := GetDate;
end;

procedure TTemplateParserTest.TestComplex;
var
  TemplateParser: IParser;
  TemplateTagList: ITemplateTagList;
begin
  TemplateTagList := TTemplateTagList.New;
  TemplateTagList.Add(TParserVariable.New('D', TParserCallback.New(GetDayCallback)));
  TemplateTagList.Add(TParserVariable.New('M', TParserCallback.New(GetMonthCallback)));
  TemplateTagList.Add(TParserVariable.New('Y', TParserCallback.New(GetYearCallback)));
  TemplateTagList.Add(TParserVariable.New('DATE', TParserCallback.New(GetDateCallback)));
  TemplateParser := TTemplateParser.New('[<', '>]', TemplateTagList, TTextMatchWordInsensitive.New);
  CheckEquals(Format('Current date: %s-%s-%s or [%s]', [GetDay, GetMonth, GetYear, GetDate]),
    TemplateParser.Evaluate('Current date: [<D>]-[<M>]-[<Y>] or [[<dAtE>]]'));
end;

procedure TTemplateParserTest.TestComplexStaticValue;
var
  TemplateParser: IParser;
  TemplateTagList: ITemplateTagList;
begin
  TemplateTagList := TTemplateTagList.New;
  TemplateParser := TTemplateParser.New('<<', '>>', TemplateTagList, TTextMatchWordInsensitive.New);
  TemplateTagList.Add(TParserVariable.New('A', 'A-Value'));
  TemplateTagList.Add(TParserVariable.New('B', 'B-Value'));
  TemplateTagList.Add(TParserVariable.New('C', 'C-Value'));
  CheckEquals('Test value for A-Value and C-Value and C-Value',
    TemplateParser.Evaluate('Test value for <<A>> and <<C>> and <<C>>'));
end;

procedure TTemplateParserTest.TestEvaluateFirstDelimiter;
var
  TemplateParser: IParser;
  TemplateTagList: ITemplateTagList;
begin
  TemplateTagList := TTemplateTagList.New;
  TemplateParser := TTemplateParser.New(':', EmptyStr, TemplateTagList, TTextMatchWordInsensitive.New);
  TemplateTagList.Add(TParserVariable.New('D', TParserCallback.New(GetDayCallback)));
  CheckEquals(Format('Test %s:D D: none, %s', [GetDay, GetDay]), TemplateParser.Evaluate('Test :D:D D: none, :D'));
end;

procedure TTemplateParserTest.TestEvaluateLastDelimiter;
var
  TemplateParser: IParser;
  TemplateTagList: ITemplateTagList;
begin
  TemplateTagList := TTemplateTagList.New;
  TemplateParser := TTemplateParser.New(EmptyStr, '@', TemplateTagList, TTextMatchWordInsensitive.New);
  TemplateTagList.Add(TParserVariable.New('D', TParserCallback.New(GetDayCallback)));
  CheckEquals(Format('Test :D %s none, D@%s', [GetDay, GetDay]), TemplateParser.Evaluate('Test :D D@ none, D@D@'));
end;

procedure TTemplateParserTest.TestEvaluateTwoDelimiter;
var
  TemplateParser: IParser;
  TemplateTagList: ITemplateTagList;
begin
  TemplateTagList := TTemplateTagList.New;
  TemplateParser := TTemplateParser.New('{', '}', TemplateTagList, TTextMatchWordInsensitive.New);
  TemplateTagList.Add(TParserVariable.New('D', TParserCallback.New(GetDayCallback)));
  CheckEquals(Format('Test %s {D none, D}', [GetDay]), TemplateParser.Evaluate('Test {D} {D none, D}'));
end;

procedure TTemplateParserTest.TestEvaluateFirstDelimiterWhole;
var
  TemplateParser: IParser;
  TemplateTagList: ITemplateTagList;
begin
  TemplateTagList := TTemplateTagList.New;
  TemplateParser := TTemplateParser.New(':', EmptyStr, TemplateTagList, TTextMatchWordInsensitive.New);
  TemplateTagList.Add(TParserVariable.New('D', TParserCallback.New(GetDayCallback)));
  CheckEquals(Format('Test %s:D D: none, %s,%s', [GetDay, GetDay, GetDay]),
    TemplateParser.Evaluate('Test :D:D D: none, :D,:D'));
end;

procedure TTemplateParserTest.TestEvaluateLastDelimiterWhole;
var
  TemplateParser: IParser;
  TemplateTagList: ITemplateTagList;
begin
  TemplateTagList := TTemplateTagList.New;
  TemplateParser := TTemplateParser.New(EmptyStr, ':', TemplateTagList, TTextMatchWordInsensitive.New);
  TemplateTagList.Add(TParserVariable.New('D', TParserCallback.New(GetDayCallback)));
  CheckEquals(Format('Test :D:D %s none, %s,%s', [GetDay, GetDay, GetDay]),
    TemplateParser.Evaluate('Test :D:D D: none, D:,D:'));
end;

procedure TTemplateParserTest.TestEvaluateCaseSensitive;
var
  TemplateParser: IParser;
  TemplateTagList: ITemplateTagList;
begin
  TemplateTagList := TTemplateTagList.New;
  TemplateParser := TTemplateParser.New('{{', '}}', TemplateTagList, TTextMatchWordSensitive.New);
  TemplateTagList.Add(TParserVariable.New('d', TParserCallback.New(GetDayCallback)));
  CheckEquals(Format('Test {{D}} none %s', [GetDay]), TemplateParser.Evaluate('Test {{D}} none {{d}}'));
end;

initialization

RegisterTest(TTemplateParserTest {$IFNDEF FPC}.Suite {$ENDIF});

end.
