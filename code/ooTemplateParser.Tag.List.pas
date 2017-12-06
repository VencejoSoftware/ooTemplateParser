{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ooTemplateParser.Tag.List;

interface

uses
  ooParser.Variable,
  ooParser.Item.List;

type
  ITemplateTagList = interface(IParserItemList<IParserVariable>)
    ['{939882F0-FC28-4782-B30C-9D26D2E5D90A}']
  end;

  TTemplateTagList = class sealed(TParserItemList<IParserVariable>, ITemplateTagList)
  public
    class function New: ITemplateTagList;
  end;

implementation

class function TTemplateTagList.New: ITemplateTagList;
begin
  Result := TTemplateTagList.Create;
end;

end.
