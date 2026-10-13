# Tech book experiments

## build process

```bash
nix-shell

shake                   # build all targets

shake clean             # cleanup _build directory
shake _build/book.md    # build individual target (e.g. markdown)
shake -h                # show all options

./bin/watch             # monitor file changes, auto rebuild

# shake does not detect argument changes, this pattern is safer
shake clean && ./bin/watch -c "chap-sub1|chap-sub2"

exit # out of nix-shell
```

## devel

```bash
nix-shell
ghcid --no-title --lint "--command=ghci -Wall Shakefile"
exit # out of nix-shell
```

## File and chapter hiearchy

Root entry to a document is a single file `main.md`, which can include other
markdown files. Each included file can start with the first level heading and
the headings can be incremented automatically during include process.

```markdown
# document root

This is some content...

!include`incrementSection=1` content/chapter1.md

!include`incrementSection=1` content/chapter2.md
```

A `pandoc-include` filter (external program) is required. It's available
on nix, see: <https://pypi.org/project/pandoc-include/>.

```bash
pandoc --filter pandoc-include --from=markdown main.md --to=...
```

## Generate random text

```bash
curl 'https://jaspervdj.be/lorem-markdownum/markdown.txt?no-code=on&num-blocks=50' \
    >> content/random.md \
    && echo "" >> content/random.md
```

## Heading identifiers

All headings are auto-identified. There is an algorithm to turn a title to an
identifier. See [pandoc auto_identifiers extension](https://pandoc.org/MANUAL.html#extension-auto_identifiers).

It is also possible to explicitely put an identifier, like this:

```
# Introduction {#intro}
## Getting started {#getting-started}

Some text, see [Introduction chapter](#intro).
```

## Compile only selected chapters

Use `--only-chapters=PAT` or `-c PAT`, for example:

```bash
shake -c sub1 -c "code%-blocks" -c "a.*b"
```

Please note that `PAT` pattern is a reference-to-chapter (either automatic or
manual), not the title.

