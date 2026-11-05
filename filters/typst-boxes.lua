-- typst output needs filters for custom divs
--
-- Wrap each 'Div' in a typst function call.
-- This function will do the div styling.

-- Inform luacheck about some globals, provided by 'pandoc'.
-- luacheck: globals pandoc PANDOC_SCRIPT_FILE Div

function Div(el)
    local cls
    if el.classes:includes('info') then
        cls = 'cls: "info"'
    elseif el.classes:includes('warning') then
        cls = 'cls: "warning"'
    else
        cls = 'cls: none'
    end
    return pandoc.RawBlock('typst',
        '#div(' .. cls .. ')[' .. pandoc.utils.stringify(el.content) .. ']')
end

