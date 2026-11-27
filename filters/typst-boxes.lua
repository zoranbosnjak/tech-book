-- Typst output needs filters to style 'Divs'

-- Inform luacheck about some globals, provided by 'pandoc'.
-- luacheck: globals Div

function Div(div)
    local ref = "style.divs.default"
    if div.classes:includes('info') then
        ref = "style.divs.info"
    elseif div.classes:includes('warning') then
        ref = "style.divs.warning"
    elseif div.classes:includes('login') then
        ref = "style.divs.login"
    end

    div.attributes["typst:width"] = "100%"
    div.attributes["typst:above"] = "1em"
    div.attributes["typst:below"] = "1em"
    div.attributes["typst:inset"] = "2em"
    div.attributes["typst:radius"] = "4pt"
    div.attributes["typst:fill"] = ref .. ".fill"
    div.attributes["typst:stroke"] = "("
        .. "left: 5pt + " .. ref .. ".border"
        .. ", top: 1pt + style.divs.default.border"
        .. ", right: 1pt + style.divs.default.border"
        .. ", bottom: 1pt + style.divs.default.border"
        .. ")"
    return div

end

