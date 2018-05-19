[![License](https://img.shields.io/badge/License-BSD%203--Clause-blue.svg)](https://opensource.org/licenses/BSD-3-Clause)
[![Build Status](https://travis-ci.org/VencejoSoftware/ooTemplateParser.svg?branch=master)](https://travis-ci.org/VencejoSoftware/ooTemplateParser)

# ooTemplateParser - Object pascal template parser library
Code to use text templates in pascal code

### Documentation
If not exists folder "doc" then run the batch "build_doc". The main entry is ./doc/index.html

### Example
```pascal
var
  TagSubstitute: IParser;
  TemplateTagList: IParserElementList<IParserElement>;
  Text: String;
begin
  TemplateTagList := TParserElementList<IParserElement>.New;
  TagSubstitute := TTagSubstitute.New('<<', '>>', TemplateTagList, TTextMatchWordInsensitive.New);
  TemplateTagList.Add(TParserConstant.New('A', 'A-Value'));
  TemplateTagList.Add(TParserConstant.New('B', 'B-Value'));
  TemplateTagList.Add(TParserConstant.New('C', 'C-Value'));
  Text := TagSubstitute.Evaluate('Test value for <<A>> and <<C>> and <<C>>'));
  // Text = 'Test value for A-Value and C-Value and C-Value'
end;
```

### Demo
See the project example at the demo folder.

## Dependencies
* [ooGeneric](https://github.com/VencejoSoftware/ooGeneric.git) - Generic object oriented list
* [ooText](https://github.com/VencejoSoftware/ooText.git) - Object pascal string library
* [ooParser](https://github.com/VencejoSoftware/ooParser.git) - Interfaces to build a text parser

## Built With
* [Delphi&reg;](https://www.embarcadero.com/products/rad-studio) - Embarcadero&trade; commercial IDE
* [Lazarus](https://www.lazarus-ide.org/) - The Lazarus project

## Contribute
This are an open-source project, and they need your help to go on growing and improving.
You can even fork the project on GitHub, maintain your own version and send us pull requests periodically to merge your work.

## Authors
* **Alejandro Polti** (Vencejo Software team lead) - *Initial work*