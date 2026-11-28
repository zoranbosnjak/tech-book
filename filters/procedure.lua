-- Pandoc filter for custom list bullets in "procedure" block.
--
-- Usage in markdown
--
-- ::: procedure
-- - say hello
-- - done
-- :::

-- Inform luacheck about some globals, provided by 'pandoc'.
-- luacheck: globals Div FORMAT pandoc

local symbol = "⇲"

function Div(el)
    if not el.classes:includes("procedure") then return nil end

    if FORMAT:match("^typst") then
        local body = pandoc.write(pandoc.Pandoc(el.content), "typst")
        return pandoc.RawBlock("typst",
            "#[\n#set list(marker: [" .. symbol .. "])\n" .. body .. "\n]"
        )
    elseif FORMAT:match("^html") then
        local body = pandoc.write(pandoc.Pandoc(el.content), "html")
        body = body:gsub("<ul>", '<ul class="procedure-bullets">')
        return pandoc.RawBlock("html",
            '<style>.procedure-bullets { list-style-type: "'
            .. symbol .. ' "; }</style>\n' .. body
        )
    end
    return el
end

