// Second level typst template to define exact document format.

#import "style.typ": style

// Helper function (currently unused)
#let content-to-string(content) = {
  if content.has("text") {
    content.text
  } else if content.has("children") {
    content.children.map(content-to-string).join("")
  } else if content.has("body") {
    content-to-string(content.body)
  } else if content == [ ] {
    " "
  }
}

#let cover-page(title, date, version, gitrev, publisher) = {
  let hline = line(length: 100%, stroke: 2pt)
  page(numbering: none, header: none, footer: none)[
    #line(length: 100%, stroke: 2pt)
    #v(12pt)
    #align(right)[#image("../../content/img1.png", width: 2cm)]
    #align(center)[
      #v(1fr)
      #text(size: 24pt, weight: "bold")[
        #title
      ]\
      #text(size: 12pt, weight: "bold")[
        Release #version (#gitrev)]
      #v(2.5fr)
      #text(size: 10pt)[
        #publisher\
        #date
      ]
    ]
    #line(length: 100%, stroke: 2pt)
  ]
}

#let thin-line() = line(
  length: 100%,
  stroke: (
    paint: rgb("#8b8b8b"),
    thickness: 0.5pt,
  ),
)

#let page-header(title, version, gitrev) = context {
  set text(size: 10pt, fill: rgb("#070707"))
  let position = if calc.odd(here().page()) { right } else { left }
  align(position, [#title, Release #version (#gitrev)])
  thin-line()
}

// Extract name of the current level-1 chapter
#let current-chapter() = context {
  let chapters = query(heading.where(level: 1).before(here()))
  if chapters.len() > 0 {
    chapters.last().body
  } else {
    []
  }
}

#let page-footer() = context {
  thin-line()
  set text(size: 10pt, fill: rgb("#070707"))
  let pn = counter(page).display("1/1", both: true)
  let chap = current-chapter()
  if calc.odd(here().page()) {
    [ #pn #h(1fr) #chap ]
  }
  else {
    [ #chap #h(1fr) #pn ]
  }
}

#let toc-entry(entry) = {
  let c = rgb("#084b63")
  show link: set text(
    fill: c
  )

  set text(fill: c)

  let inner = [
    #entry.body()
    #h(0.5em)
    #box(width: 1fr, entry.fill)
    #h(0.5em)
    #text(fill: c)[#entry.page()]
  ]

  link(
    entry.element.location(),
    entry.indented(entry.prefix(), inner),
  )
}

#let main-toc() = {
  show heading: set block(
    above: 0cm,
    below: style.toc.heading-space,
  )

  show heading: set text(
    size: style.toc.heading-size,
  )

  show outline.entry.where(level: 1): set text(
    weight: "bold",
  )

  show outline.entry.where(level: 1): set block(
    above: 1em,
  )

  show outline.entry: set text(
    size: style.toc.entry-size,
  )

  show outline.entry: toc-entry

  outline(
    title: [Content:],
    depth: 2,
    target: heading.where(level:1).or(heading.where(level:2)),
    indent: style.toc.indent,
  )
  pagebreak()
}

#let figures-toc() = {
  show heading: set block(
    above: 0cm,
    below: style.toc.heading-space,
  )

  show heading: set text(
    size: style.toc.heading-size,
  )

  show outline.entry: set text(
    size: style.toc.entry-size,
  )

  show outline.entry: toc-entry

  outline(
    title: [Figures:],
    target: figure.where(kind: image),
    indent: style.toc.indent,
  )
  pagebreak()
}

#let tables-toc() = {
  show heading: set block(
    above: 0cm,
    below: style.toc.heading-space,
  )

  show heading: set text(
    size: style.toc.heading-size,
  )

  show outline.entry: set text(
    size: style.toc.entry-size,
  )

  show outline.entry: toc-entry

  outline(
    title: [Tables:],
    target: figure.where(kind: table),
    indent: style.toc.indent,
  )

  pagebreak()
}

#let chapter-minitoc(chapter) = {
  if chapter.level == 1 and chapter.outlined { context {
    let following = selector(
      heading.where(outlined: true)
    ).after(chapter.location(), inclusive: false)

    let boundaries = query(following).filter(h => h.level <= 1)
    let target = following

    if boundaries.len() > 0 {
      target = target.before(
        boundaries.first().location(),
        inclusive: false,
      )
    }

    // Check L2 title
    if query(target).any(h => h.level == 2) {
      block(
        above: 1em,
        below: 1em,
      )[
        #show outline.entry : set text(
          weight: "regular"
        )
        #show outline.entry: set text(
          size: style.toc.entry-size,
        )
        #show outline.entry: toc-entry
        #outline(
          title: none,
          target: target,
          depth: 2,
          indent: 0pt,
        )
      ]

      pagebreak(weak: true)
    }
  }}
}

// apply style to the main content
#let chapters(doc) = {

  show heading.where(level: 1): set text(
    size: style.heading.level1.size,
    weight: style.heading.level1.weight,
    fill: style.heading.level1.color,
  )

  show heading.where(level: 1): set block(
    above: style.heading.level1.above,
    below: style.heading.level1.below,
  )

  show heading.where(level: 2): set text(
    size: style.heading.level2.size,
    weight: style.heading.level2.weight,
    fill: style.heading.level2.color,
  )

  show heading.where(level: 2): set block(
    above: style.heading.level2.above,
    below: style.heading.level2.below,
  )

  show heading: it => {
    if it.level >= 3 {
      set text(
        size: style.heading.deeper.size,
        weight: style.heading.deeper.weight,
        fill: style.heading.deeper.color,
      )
      set block(
        above: style.heading.deeper.above,
        below: style.heading.deeper.below,
      )
      it
    } else {
      it
    }
  }

  show heading: chapter => {
    if chapter.level <= 2 {
      pagebreak(weak: true)
    }
    chapter
    chapter-minitoc(chapter)
  }

  show bibliography: references => {
    pagebreak(weak: true)
    references
  }

  // quotes
  show quote: val => {
    set align(left)
    set text(style.quote.text)
    val
  }
  show quote.where(block: true): block.with(
    stroke: (left: 4pt + gray, rest: none),
    fill: style.quote.fill,
    inset: (left: 0.2em, top: 1.2em, right: 0.2em, bottom: 1.2em),
  )

  // code blocks
  show raw.where(block: true): block.with(
    fill: style.code.fill,
    inset: 10pt,
    radius: 4pt,
    width: 100%,
    stroke: 1pt + style.code.border,
  )

  doc
}

// style 'Div' according to given class
#let div(body, cls: none) = {
  let ref = if cls == "info" { style.divs.info }
            else if cls == "warning" { style.divs.warning }
            else { style.divs.default }

  block(
    width: 100%,
    above: 1em,
    below: 1em,
    inset: 2em,
    radius: 4pt,
    fill: ref.fill,
    stroke: (
      left: 5pt + ref.border,
      top: 1pt + style.divs.default.border,
      right: 1pt + style.divs.default.border,
      bottom: 1pt + style.divs.default.border,
    ),
  )[ #body ]
}

// Document template entry point
#let conf(doc, title, keywords, date, version, gitrev, publisher,
    font, sectionnumbering) = {
  set document(
    title: title,
    keywords: keywords,
  )
  set page(
    paper: "a4",
    binding: left,
    margin: (
      inside: 3.5cm,
      outside: 3.5cm,
      top: 2.5cm,
      bottom: 2.5cm,
    ),
    header: page-header(title, version, gitrev),
    header-ascent: 0.75cm,
    footer: page-footer(),
    footer-descent: 0.75cm,
    columns: 1,
  )
  set par(justify: true)
  set text(
    font: font,
    size: 12pt,
  )
  set heading(numbering: (..numbers) => {
    let parts = numbers.pos()

    if parts.len() <= 2 {
      // L1: 1, 2 …; L2: 1.1, 1.2 …
      numbering(sectionnumbering, ..parts)
    } else {
      // Od L3 naprej uporabimo simbole.
      let symbols = style.heading.symbols
      let index = calc.min(parts.len() - 3, symbols.len() - 1)
      symbols.at(index)
    }
  })

  set table(
    stroke: style.table.stroke,
    inset: style.table.inset,
    fill: (_, y) => if y == 0 {
      style.table.header-fill
    } else {
      style.table.body-fill
    },
  )

  show link: set text(
    fill: rgb("#0513da"),
  )

  cover-page(title, date, version, gitrev, publisher)
  main-toc()
  figures-toc()
  tables-toc()
  chapters(doc)
}

