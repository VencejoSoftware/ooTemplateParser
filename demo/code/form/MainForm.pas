unit MainForm;

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, DateUtils,
  ooParser, ooParser.Element.Intf, ooParser.ElementList,
  ooParser.Callback, ooParser.Variable, ooParser.Constant,
  ooTagSubstitute,
  ooText.Match.WordInsensitive, ooText.Match.WordSensitive;

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
  lbResult.Caption := TTagSubstitute.New('[<', '>]', _TemplateTagList, TTextMatchWordInsensitive.New)
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
