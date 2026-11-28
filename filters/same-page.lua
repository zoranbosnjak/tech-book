-- Pandoc filter for keeping blocks on the same page
--
-- Usage in markdown
--
-- ::: same-page
-- - say hello
-- - done
-- :::

-- Inform luacheck about some globals, provided by 'pandoc'.
-- luacheck: globals Div FORMAT pandoc

function Div(div)
    if not div.classes:includes("same-page") then return nil end
    if FORMAT:match("^typst") then
        local body = pandoc.write(pandoc.Pandoc(div.content), "typst")
        return pandoc.RawBlock("typst",
            "#block(breakable: false)[\n" .. body .. "\n]")
    elseif FORMAT:match("^html") then
        return div.content
    end
end

