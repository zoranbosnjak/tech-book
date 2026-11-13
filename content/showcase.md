# Showcase

A demonstration for various concepts of markdown.

## Unicode

Some non-ascii words: češnja, žaba, el niño...

## Text Formatting

Basic formatting includes **bold**, *italic*, and ***bold italic*** text. You can also use ~~strikethrough~~ and `inline code`.

## header tagging

Try this...

```bash
echo '# chapter {.class1 .class2 tag1="val1" tag2="val2"}' | pandoc -t native
```

## Headings { review="Mojca Novak" }

### Level 3 Heading
#### Level 4 Heading { review="Janez Novak" }
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

Table: Example of table syntax in Markdown.

Example

| Syntax   | Description         | Test              |
| -------- | ------------------- | ----------------- |
| Header 1 | Header 2            | Header 3          |
| `:--`    | `--:` (right align) | `:-:` (center)    |
| Left     | Right               | Center            |
| **Bold** | *Italic*            | ~~Strikethrough~~ |

Table: Example of table syntax.

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

[^b]: Second footnote text.

## Bibliography and citations

- Here is a citation to a classic work in adaptation: [@doe2023example].
- Multiple citations: [@doe2023example; @smith2024handbook].
- Citation with page number: [@smith2024handbook p. 42].

## Horizontal Rule

---

## Custom Divs

::: info
Just for your information.
:::

::: {.warning}
This is a warning message.
:::

::: {author="Jane Doe"}
The only limit to our realization of tomorrow is our doubts of today.
:::

## Blockquotes

A simple bock

> This is a note...

And nested

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

