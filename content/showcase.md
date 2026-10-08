## Text Formatting

Basic formatting includes **bold**, *italic*, and ***bold italic*** text. You can also use ~~strikethrough~~ and `inline code`.

Unicode check: češnja, žaba, el niño...

## Headings

### Level 3 Heading
#### Level 4 Heading
##### Level 5 Heading
###### Level 6 Heading

## Lists

### Unordered Lists

* Level 1, item 1
* Level 1, item 2

  * Level 2, item 1

    * Level 3, item 1
    * Level 3, item 2
  * Level 2, item 2
* Level 1, item 3

### Ordered Lists

1. First item
2. Second item

   1. Sub-item (a)
   2. Sub-item (b)

      1. Sub-sub-item (i)
      2. Sub-sub-item (ii)
3. Third item

### Definition Lists

Term 1
: Definition of term 1, which can be quite long and wrap onto multiple lines.
Still part of the same definition.

Term 2
: Definition of term 2.

## Tables

Example

| Feature | Description | Support |
|---------|------------|---------|
| Tables | Basic tables with alignment | ✓ |
| Lists | Ordered and unordered lists | ✓ |
| Code | Syntax highlighting | ✓ |

Example

| Syntax   | Description         | Test              |
| -------- | ------------------- | ----------------- |
| Header 1 | Header 2            | Header 3          |
| `:--`    | `--:` (right align) | `:-:` (center)    |
| Left     | Right               | Center            |
| **Bold** | *Italic*            | ~~Strikethrough~~ |

## Code Blocks

python:

```python
def hello_world():
    print("Hello, World!")
```

bash:

```bash
cd
echo "Hello world"
sudo ls -l /
```

LaTeX:

```latex
\begin{theorem}
  Let \(G\) be a group. Then \(G\) has a unique identity element.
\end{theorem}
```

HTML:

```html
<table>
  <tr><th>HTML</th><th>Table</th></tr>
  <tr><td>Row A</td><td>Row B</td></tr>
</table>
```

## Images

Here's an example image:

![Example PNG image](img1.png){ width=5.5cm height=auto }

Here's an example image:

![Example SVG image](img2.svg){ width=5.5cm height=auto }

## Cross-references

See [Tables](#tables) for more information.

## Footnotes

Here's a sentence with a footnote[^1].

[^1]: This is the footnote content.

Another sentence with multiple footnotes.[^a][^b]

[^a]: First footnote text.

[^b]: Second footnote text, referencing a LaTeX macro: \$\alpha + \beta = \gamma\$.

## Bibliography and citations

- Here is a citation to a classic work in adaptation: [@doe2023example].
- Multiple citations: [@doe2023example; @smith2024handbook].
- Citation with page number: [@smith2024handbook p. 42].

## Horizontal Rule

---

## Custom Divs

::: {.warning}
This is a warning message styled with custom CSS.
:::

::: {.note}
This is a note message styled differently.
:::

::: {.quote author="Jane Doe"}
The only limit to our realization of tomorrow is our doubts of today.
:::

## Emphasis and Inline Code

You can have *italic* text, **bold** text, and ***bold-italic*** text all in one paragraph.
Strikeout is also supported via ~~strikethrough~~.

Inline code: ``printf("Hello, World!\n");`` is rendered as code.

You can use backticks in code spans by wrapping in more backticks, e.g.:

````
``This is a `code` span``
`````

## Blockquotes

Regular text...

> This is a top-level blockquote.
>
> > This is a nested blockquote.
> >
> > * And it can contain lists
> > * Or other blockquotes
> >
> >   > Nested again!
>
> Back to level 1.
> And you can include formatting like **bold** and *italic* inside.

More regular text...

## Links

* Inline link: [Pandoc Homepage](https://pandoc.org)
* Reference-style link: [GitHub][gh]
* Auto-link: [https://www.example.com](https://www.example.com)

[gh]: https://github.com "GitHub"

## Abbreviations

This document uses abbreviations such as HTML{:.abbr}, LaTeX{:.abbr}, and PDF{:.abbr}.

> **Note:** To enable abbreviations, compile with `--abbreviations`.

## Definition Lists with Inline Formatting

Pandoc Markdown also supports definition lists with inline code and formatting:

Markdown
:  A lightweight markup language with plain-text formatting syntax.

LaTeX
:  A document preparation system and markup language for typesetting.

Pandoc
:  A universal document converter.

## Divs and Custom Attributes

You can create custom‐attributed Divs to test Pandoc’s extension:

::: warning
**Warning:** This is a custom‐styled warning block.
:::

::: note
**Note:** This is a custom note block with *italic* and **bold**.
:::

Pandoc will translate these into `<div class="warning">` or `<div
class="note">` in HTML, or into custom wrappers if you use a LaTeX template
that recognizes `warning` and `note`.

## Cross-references

TODO...

