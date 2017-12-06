{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ooTemplateParser;

interface

uses
  SysUtils,
  ooText.Match.Intf, ooText.Replace,
  ooText.Match.WordInsensitive,
  ooTemplateParser.Tag.List,
  ooParser.Variable, ooParser.Intf;

type
  TTemplateParser = class sealed(TInterfacedObject, IParser)
  strict private
    _TagBegin, _TagEnd: String;
    _TagList: ITemplateTagList;
    _TextMatch: ITextMatch;
  private
    function ReplaceTag(const Text, Tag, Value: String): String;
    function TagName(const Tag: IParserVariable): String;
  public
    function Evaluate(const Text: String): String;
    constructor Create(const TagBegin, TagEnd: String; const TagList: ITemplateTagList; const TextMatch: ITextMatch);
    class function New(const TagBegin, TagEnd: String; const TagList: ITemplateTagList;
      const TextMatch: ITextMatch): IParser;
  end;

implementation

function TTemplateParser.TagName(const Tag: IParserVariable): String;
begin
  Result := _TagBegin + Tag.Name + _TagEnd;
end;

function TTemplateParser.ReplaceTag(const Text, Tag, Value: String): String;
begin
  Result := TTextReplace.NewFromString(Text, _TextMatch).AllMatches(Tag, Value);
end;

function TTemplateParser.Evaluate(const Text: String): String;
var
  i: Integer;
  TemplateTag: IParserVariable;
begin
  Result := Text;
  for i := 0 to Pred(_TagList.Count) do
  begin
    TemplateTag := _TagList.Item(i);
    Result := ReplaceTag(Result, TagName(TemplateTag), TemplateTag.Value);
  end;
end;

constructor TTemplateParser.Create(const TagBegin, TagEnd: String; const TagList: ITemplateTagList;
  const TextMatch: ITextMatch);
begin
  _TagBegin := TagBegin;
  _TagEnd := TagEnd;
  _TagList := TagList;
  _TextMatch := TextMatch;
end;

class function TTemplateParser.New(const TagBegin, TagEnd: String; const TagList: ITemplateTagList;
  const TextMatch: ITextMatch): IParser;
begin
  Result := TTemplateParser.Create(TagBegin, TagEnd, TagList, TextMatch);
end;

end.
