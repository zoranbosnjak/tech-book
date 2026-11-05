// First level pandoc template, to convert from markdown to typst.

// Define in case if it's used in the markdown document.
#let horizontalrule = line(start: (25%,0%), end: (75%,0%))

// some functions are needed for the filters
#import "templates/typst/template2-typst.typ": div

// Import and use level2 typst template.
#import "templates/typst/template2-typst.typ": conf
#show: doc => conf(
  doc,
  [$title$],
  (),
  [$date$],
  [$version$],
  [$gitrev$],
  [$publisher$],
  ("$mainfont$",),
  "$section-numbering$",
)

// Insert main content.
$body$

// Add bibliography if defined.
$if(bibliography)$
#bibliography($for(bibliography)$"$bibliography$"$sep$,$endfor$)
$endif$

