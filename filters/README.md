# Working with pandoc lua filters

## luacheck

Use `luacheck` for static analysis.

```bash
luacheck filters/
```

## logging

Use [logging](https://github.com/pandoc-ext/logging) module for debug output.

```bash
# run to download the latest version locally
curl https://raw.githubusercontent.com/pandoc-ext/logging/refs/heads/main/logging.lua > logging.lua
```

Use it like this:

```lua
local filter_dir = pandoc.path.directory(PANDOC_SCRIPT_FILE)
package.path = filter_dir .. "/?.lua;" .. package.path

local logging = require 'logging'

function Para(para)
    logging.temp('para', para)
end
```

Another option is to use `print`, like this:

```lua
print("Debug:", pandoc.utils.stringify(args))
```

## pagegreak

Use [[https://github.com/pandoc-ext/pagebreak]] to replace `\newpage` in
markdown to `#pagebreak()` in typst.

```bash
# run to download the latest version locally
curl https://raw.githubusercontent.com/pandoc-ext/pagebreak/refs/heads/main/pagebreak.lua > pagebreak.lua
```

Inside markdown, insert `\newpage`, surrounded by empty lines. Such as:

```markdown
Some content...

\newpage

This other content will start on the new page.
```

