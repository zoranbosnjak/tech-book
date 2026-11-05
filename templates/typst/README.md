# Typst templates

There are 2 levels of customization:

- level1: used during conversion from `markdown` to `typst` format
- level2: used during `typst` to `pdf` processing

Pandoc provides defaults for both levels, however this document uses
custom versions of both templates. In addition, some configurable
settings are defined in a separate style file.

```
template1-pandoc.typ    <- level1 template
template2-typst.typ     <- level2 template
style.typ               <- style file, used by level2 template
```

