# TODO item list

- version and gitrev present in a document
- PDF front page design
- PDF 2-side output
- main TOC
- per-chapter TOC
- list of tables/images
- auto page break on chapter start
- abecedni seznam
- keywords (ključne besede) segment
- errata segment (samo za PDF)
- reviewers <-> chapter tables
- chapter/subchapter/subsubchapter... symbols
- notes, warnings admonitions (opozorilo, opomba)
- login box
- procedure box
- block quotes rendering
- table rendering
- cross references
- epub output, check on the phone screen
- multi page html output
- abbreviations (do not currently work)
- html output search box
- style sync between html and pdf outputs, some automation is possible with
  lua filters, see [[https://pandoc.org/typst-property-output.html]]
- build only selected chapters
  create filter in the form --only-chapters "regex", where the regex will be
  matched against each "chaptername-subchaptername-subsubchaptername".
  Where the match (ignore case, anywhere in the string...) is found, the
  chapter and all parent chapters will be included in a document.

