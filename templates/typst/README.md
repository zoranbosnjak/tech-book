# Typst templates

There are 2 levels of customization, using templates... It might be necessary
to update templates with new versions of pandoc or typst.

## Level1 - pandoc template for typst

`template1.typ` - works on pandoc level to convert markdown files into typst
format. Use for basic customization, such as margins, fonts,...

Template starting point was derived from:
- running `pandoc -D typst > out.typ`
- or from pandoc sources `pandoc/data/templates/default.typst`

## Level2 - raw typst template

`template2.typ` - works on a typst level and has all typst typesetting power.

Template starting point was derived from:
- pandoc sources `pandoc/data/templates/template.typst`

