{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit TagSubstitute_test;

interface

uses
  SysUtils, DateUtils,
  Parser, ParserElement, ParserElementList,
  ParserCallback, ParserVariable, ParserConstant,
  TagSubstitute,
  SensitiveWordMatch, InsensitiveWordMatch,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TTagSubstituteTest = class sealed(TTestCase)
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

procedure TTagSubstituteTest.TestComplex;
var
  TagSubstitute: IParser;
  TemplateTagList: IParserElementList<IParserElement>;
begin
  TemplateTagList := TParserElementList<IParserElement>.New;
  TemplateTagList.Add(TParserVariable.New('D', TParserCallback.New(GetDayCallback)));
  TemplateTagList.Add(TParserVariable.New('M', TParserCallback.New(GetMonthCallback)));
  TemplateTagList.Add(TParserVariable.New('Y', TParserCallback.New(GetYearCallback)));
  TemplateTagList.Add(TParserVariable.New('DATE', TParserCallback.New(GetDateCallback)));
  TagSubstitute := TTagSubstitute.New('[<', '>]', TemplateTagList, TInsensitiveWordMatch.NewDefault);
  CheckEquals(Format('Current date: %s-%s-%s or [%s]', [GetDay, GetMonth, GetYear, GetDate]),
    TagSubstitute.Evaluate('Current date: [<D>]-[<M>]-[<Y>] or [[<dAtE>]]'));
end;

procedure TTagSubstituteTest.TestComplexStaticValue;
var
  TagSubstitute: IParser;
  TemplateTagList: IParserElementList<IParserElement>;
begin
  TemplateTagList := TParserElementList<IParserElement>.New;
  TagSubstitute := TTagSubstitute.New('<<', '>>', TemplateTagList, TInsensitiveWordMatch.NewDefault);
  TemplateTagList.Add(TParserConstant.New('A', 'A-Value'));
  TemplateTagList.Add(TParserConstant.New('B', 'B-Value'));
  TemplateTagList.Add(TParserConstant.New('C', 'C-Value'));
  CheckEquals('Test value for A-Value and C-Value and C-Value',
    TagSubstitute.Evaluate('Test value for <<A>> and <<C>> and <<C>>'));
end;

procedure TTagSubstituteTest.TestEvaluateFirstDelimiter;
var
  TagSubstitute: IParser;
  TemplateTagList: IParserElementList<IParserElement>;
begin
  TemplateTagList := TParserElementList<IParserElement>.New;
  TagSubstitute := TTagSubstitute.New(':', EmptyStr, TemplateTagList, TInsensitiveWordMatch.NewDefault);
  TemplateTagList.Add(TParserVariable.New('D', TParserCallback.New(GetDayCallback)));
  CheckEquals(Format('Test %s%s D: none, %s', [GetDay, GetDay, GetDay]),
    TagSubstitute.Evaluate('Test :D:D D: none, :D'));
end;

procedure TTagSubstituteTest.TestEvaluateLastDelimiter;
var
  TagSubstitute: IParser;
  TemplateTagList: IParserElementList<IParserElement>;
begin
  TemplateTagList := TParserElementList<IParserElement>.New;
  TagSubstitute := TTagSubstitute.New(EmptyStr, '@', TemplateTagList, TInsensitiveWordMatch.NewDefault);
  TemplateTagList.Add(TParserVariable.New('D', TParserCallback.New(GetDayCallback)));
  CheckEquals(Format('Test :D %s none, D@%s', [GetDay, GetDay]), TagSubstitute.Evaluate('Test :D D@ none, D@D@'));
end;

procedure TTagSubstituteTest.TestEvaluateTwoDelimiter;
var
  TagSubstitute: IParser;
  TemplateTagList: IParserElementList<IParserElement>;
begin
  TemplateTagList := TParserElementList<IParserElement>.New;
  TagSubstitute := TTagSubstitute.New('{', '}', TemplateTagList, TInsensitiveWordMatch.NewDefault);
  TemplateTagList.Add(TParserVariable.New('D', TParserCallback.New(GetDayCallback)));
  CheckEquals(Format('Test %s {D none, D}', [GetDay]), TagSubstitute.Evaluate('Test {D} {D none, D}'));
end;

procedure TTagSubstituteTest.TestEvaluateFirstDelimiterWhole;
var
  TagSubstitute: IParser;
  TemplateTagList: IParserElementList<IParserElement>;
begin
  TemplateTagList := TParserElementList<IParserElement>.New;
  TagSubstitute := TTagSubstitute.New(':', EmptyStr, TemplateTagList, TInsensitiveWordMatch.NewDefault);
  TemplateTagList.Add(TParserVariable.New('D', TParserCallback.New(GetDayCallback)));
  CheckEquals(Format('Test %s%s D: none, %s,%s', [GetDay, GetDay, GetDay, GetDay]),
    TagSubstitute.Evaluate('Test :D:D D: none, :D,:D'));
end;

procedure TTagSubstituteTest.TestEvaluateLastDelimiterWhole;
var
  TagSubstitute: IParser;
  TemplateTagList: IParserElementList<IParserElement>;
begin
  TemplateTagList := TParserElementList<IParserElement>.New;
  TagSubstitute := TTagSubstitute.New(EmptyStr, ':', TemplateTagList, TInsensitiveWordMatch.NewDefault);
  TemplateTagList.Add(TParserVariable.New('D', TParserCallback.New(GetDayCallback)));
  CheckEquals(Format('Test :D:D %s none, %s,%s', [GetDay, GetDay, GetDay]),
    TagSubstitute.Evaluate('Test :D:D D: none, D:,D:'));
end;

procedure TTagSubstituteTest.TestEvaluateCaseSensitive;
var
  TagSubstitute: IParser;
  TemplateTagList: IParserElementList<IParserElement>;
begin
  TemplateTagList := TParserElementList<IParserElement>.New;
  TagSubstitute := TTagSubstitute.New('{{', '}}', TemplateTagList, TSensitiveWordMatch.NewDefault);
  TemplateTagList.Add(TParserVariable.New('d', TParserCallback.New(GetDayCallback)));
  CheckEquals(Format('Test {{D}} none %s', [GetDay]), TagSubstitute.Evaluate('Test {{D}} none {{d}}'));
end;

initialization

RegisterTest(TTagSubstituteTest {$IFNDEF FPC}.Suite {$ENDIF});

end.
