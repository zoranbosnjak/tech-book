-- Common functions

-- Inform luacheck about some globals, provided by 'pandoc'.
-- luacheck: globals pandoc PANDOC_SCRIPT_FILE

local filter_dir = pandoc.path.directory(PANDOC_SCRIPT_FILE)
package.path = filter_dir .. "/?.lua;" .. package.path

local logging = require 'logging'

local namespace = {}

local debug = logging.temp
namespace.debug = debug

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

-- extract first UTF-8 character out of a string
namespace.take_utf8 = function(s)
    local next_char = utf8.offset(s, 2)
    return next_char and s:sub(1, next_char - 1) or s
end

-- drop first UTF-8 character from a string
namespace.drop_utf8 = function(s)
    local next_pos = utf8.offset(s, 2)
    return next_pos and s:sub(next_pos) or ""
end

namespace.set2list = function(set)
    local result = {}
    for value in pairs(set) do
        result[#result + 1] = value
    end
    return result
end

namespace.si_alphabet =
    { "a", "b", "c", "č", "d"
    , "e", "f", "g", "h", "i"
    , "j", "k", "l", "m", "n"
    , "o", "p", "r", "s", "š"
    , "t", "u", "v", "z", "ž"
    }

-- return sorted set of strings, by explicitely provided alphabet
namespace.sorted = function(alphabet, lst)
    debug("debug1", lst)
    -- helper function to extract index from alphabet list
    local function ord(x)
        for i, c in ipairs(alphabet) do
            if x == c then return i end
        end
        error("character not found")
    end

    -- make a copy
    result = {}
    for i, value in ipairs(lst) do
        result[i] = value
    end
    debug("debug2", result)

    local function is_less(s1, s2)
        debug("compare0", s1, s2)
        if s1 == "" then
            debug("compare1", s1, s2, "True")
            return True
        end
        if s2 == "" then
            debug("compare1", s1, s2, "False")
            return False
        end
        local a = ord(namespace.take_utf8(s1))
        local b = ord(namespace.take_utf8(s2))
        debug('compare-ords', a, b)
        if a < b then
            debug("compare2", a, b, "True")
            return True
        end
        if b < a then
            debug("compare2", a, b, "False")
            return False
        end

        return is_less(namespace.drop_utf8(s1), namespace.drop_utf8(s2))
    end

    table.sort(result, is_less)
    debug("debug3", result)
    return result
end

return namespace

