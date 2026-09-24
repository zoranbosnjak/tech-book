# Tech book experiments

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

