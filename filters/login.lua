-- Pandoc filter for "login" directive.
--
-- To use it, place something like this in a single line:
--
-- !login username password

-- Inform luacheck about some globals, provided by 'pandoc'.
-- luacheck: globals Para pandoc

function Para(el)
    local text = pandoc.utils.stringify(el)
    local rest = text:match("^!login%s+(.+)$")
    if not rest then return nil end

    local args = {}
    for arg in rest:gmatch("%S+") do
        args[#args + 1] = arg
    end

    assert(#args == 2, "Expecting 'username' and 'password' as arguments")
    local username = args[1]
    local password = args[2]

    local blocks = pandoc.Para({
        pandoc.Strong({pandoc.Str("Login:")}),
        pandoc.LineBreak(), pandoc.Str("Username: "), pandoc.Str(username),
        pandoc.LineBreak(), pandoc.Str("Password: {PASS_" .. password .. "}"),
    })

    return pandoc.Div(blocks, pandoc.Attr("", { "login" }))
end

