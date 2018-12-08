{$REGION 'documentation'}
{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Text tag substitute
  @created(09/05/2018)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit TagSubstitute;

interface

uses
  SysUtils,
  Text,
  TextMatch, ReplaceText,
  InsensitiveWordMatch,
  ParserElement, ParserElementList, Parser;

type
{$REGION 'documentation'}
{
  @abstract(Implementation of @link(IParser))
  Replace all tags in text with a defined @link(IParserElement parser element)
  @member(Evaluate @seealso(IParser.Evaluate))
  @member(
    ReplaceTag Replace static tag text in source text
    @param(Text Source text to replace)
    @param(Tag Tag text to replace)
    @param(Value Replacement value)
    @return(Text replaced)
  )
  @member(
    TagName Add delimiters to the tag element
    @param(Element Parser element)
    @return(Tag text with delimiters)
  )
  @member(
    Create Object constructor
    @param(TagBegin Start tag delimiter)
    @param(TagEnd Finish tag delimiter)
    @param(ElementList Parser element catalog)
    @param(TextMatch Text match interface to use in text replace)
  )
  @member(
    New Create a new @classname as interface
    @param(TagBegin Start tag delimiter)
    @param(TagEnd Finish tag delimiter)
    @param(ElementList Parser element catalog)
    @param(TextMatch Text match interface to use in text replace)
  )
}
{$ENDREGION}
  TTagSubstitute = class sealed(TInterfacedObject, IParser)
  strict private
    _TagBegin, _TagEnd: String;
    _ElementList: IParserElementList<IParserElement>;
    _TextMatch: ITextMatch;
  private
    function ReplaceTag(const Text, Tag, Value: String): String;
    function TagName(const Element: IParserElement): String;
  public
    function Evaluate(const Text: String): String;
    constructor Create(const TagBegin, TagEnd: String; const ElementList: IParserElementList<IParserElement>;
      const TextMatch: ITextMatch);
    class function New(const TagBegin, TagEnd: String; const ElementList: IParserElementList<IParserElement>;
      const TextMatch: ITextMatch): IParser;
  end;

implementation

function TTagSubstitute.TagName(const Element: IParserElement): String;
begin
  Result := _TagBegin + Element.Name + _TagEnd;
end;

function TTagSubstitute.ReplaceTag(const Text, Tag, Value: String): String;
begin
  Result := TReplaceText.New(_TextMatch).AllMatches(TText.New(Text), TText.New(Tag), TText.New(Value), 1).Value;
end;

function TTagSubstitute.Evaluate(const Text: String): String;
var
  Element: IParserElement;
begin
  Result := Text;
  for Element in _ElementList do
    Result := ReplaceTag(Result, TagName(Element), Element.Value);
end;

constructor TTagSubstitute.Create(const TagBegin, TagEnd: String; const ElementList: IParserElementList<IParserElement>;
  const TextMatch: ITextMatch);
begin
  _TagBegin := TagBegin;
  _TagEnd := TagEnd;
  _ElementList := ElementList;
  _TextMatch := TextMatch;
end;

class function TTagSubstitute.New(const TagBegin, TagEnd: String; const ElementList: IParserElementList<IParserElement>;
  const TextMatch: ITextMatch): IParser;
begin
  Result := TTagSubstitute.Create(TagBegin, TagEnd, ElementList, TextMatch);
end;

end.
