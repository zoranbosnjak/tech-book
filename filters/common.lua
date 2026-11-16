-- Common functions

-- Inform luacheck about some globals, provided by 'pandoc'.
-- luacheck: globals pandoc

local namespace = {}

-- helper function to detect a placeholder in markdown
namespace.placeholder = function(cls)
    return pandoc.Para({pandoc.Span("", {class = cls})})
end

-- take some number of elements from the list
namespace.take = function(n, tbl)
    local result = {}
    for i = 1, math.min(n, #tbl) do
        result[i] = tbl[i]
    end
    return result
end

-- determine if 'el' is a member of the list 'lst'
namespace.is_elem = function(el, lst)
    for _, val in ipairs(lst) do
        if el == val then
            return true
        end
    end
    return false
end

-- the the first UTF-8 character out of a string
namespace.first_character = function(s)
    local next_char = utf8.offset(s, 2)
    return next_char and s:sub(1, next_char - 1) or s
end

return namespace

