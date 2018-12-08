{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit MainForm;

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, DateUtils,
  Parser, ParserElement, ParserElementList,
  ParserCallback, ParserVariable, ParserConstant,
  TagSubstitute,
  InsensitiveWordMatch, SensitiveWordMatch;

type
  TMainForm = class(TForm)
    edTemplate: TEdit;
    btnApply: TButton;
    lbResult: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
  private
    _TemplateTagList: IParserElementList<IParserElement>;
  end;

var
  NewMainForm: TMainForm;

implementation

{$IFDEF FPC}
{$R *.lfm}
{$ELSE}
{$R *.dfm}
{$ENDIF}

function GetDayCallback(const aCallBack: IParserCallback): string;
var
  d: word;
begin
  d := DayOf(now);
  if d < 10 then
    Result := '0' + IntToStr(d)
  else
    Result := IntToStr(d);
end;

function GetMonthCallback(const aCallBack: IParserCallback): string;
var
  d: word;
begin
  d := MonthOf(now);
  if d < 10 then
    Result := '0' + IntToStr(d)
  else
    Result := IntToStr(d);
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

procedure TMainForm.btnApplyClick(Sender: TObject);
begin
  lbResult.Caption := TTagSubstitute.New('[<', '>]', _TemplateTagList, TInsensitiveWordMatch.NewDefault)
    .Evaluate(edTemplate.Text)
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  _TemplateTagList := TParserElementList<IParserElement>.New;
  _TemplateTagList.Add(TParserVariable.New('D', TParserCallback.New(GetDayCallback)));
  _TemplateTagList.Add(TParserVariable.New('M', TParserCallback.New(GetMonthCallback)));
  _TemplateTagList.Add(TParserVariable.New('Y', TParserCallback.New(GetYearCallback)));
  edTemplate.Text := 'Current date: [<D>]-[<M>]-[<Y>]';
end;

end.
