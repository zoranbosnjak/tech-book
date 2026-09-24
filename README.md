# Tech book experiments

## build process

```bash
nix-shell

shake                   # build all targets

shake clean             # cleanup _build directory
shake _build/book.md    # build individual target (e.g. markdown)
shake -h                # show all options

./bin/watch             # monitor file changes, auto rebuild

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

