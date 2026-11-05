// configurable style settings

#let style = (

  toc: (
    heading-space: 1cm,
    heading-size: 18pt,
    entry-size: 12pt,
    indent: 2em,
  ),

  heading: (
    level1: (
      size: 24pt,
      weight: "bold",
      color: black,
      above: 0pt,
      below: 1em,
    ),
    level2: (
      size: 18pt,
      weight: "bold",
      color: black,
      above: 0pt,
      below: 1em,
    ),
    deeper: (
      size: 14pt,
      weight: "bold",
      color: black,
      above: 1.5em,
      below: 0.5em,
    ),
    symbols: ("✚", "◆", "☆", "↘"),
  ),

  table: (
    stroke: 1pt + black,
    header-fill: gray.lighten(30%),
    body-fill: gray.lighten(90%),
    inset: 6pt,
  ),

  divs: (
    default: (
      fill: rgb("#ffffcc"),
      border: rgb("#6c757d"),
    ),
    info: (
      fill: rgb("#ffffcc"),
      border: rgb("#17a2b8"),
    ),
    warning: (
      fill: rgb("#ffffcc"),
      border: rgb("#f54927"),
    ),
  ),

  quote: (
    text: rgb("#000000"),
    fill: silver,
  ),

  code: (
    fill: rgb("#ffffcc"),
    border: rgb("#0000ff"),
  ),

)

