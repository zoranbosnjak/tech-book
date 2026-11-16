-- text related functions

local namespace = {}

-- get (first, remaining) characters from UTF-8 string
namespace.uncons_utf8 = function(s)
    local ix2 = utf8.offset(s, 2)
    assert(ix2, "empty string")
    return { s:sub(1, ix2 - 1), s:sub(ix2) }
end
namespace.take_utf8 = function(s) return namespace.uncons_utf8(s)[1] end
namespace.drop_utf8 = function(s) return namespace.uncons_utf8(s)[2] end

-- find index of the given (utf-8) character inside alphabet
namespace.ord = function(alphabet, c)
    -- Alphabet is in the form { {"A", "a"}, {"B", "b"}, ...}
    -- We try capital letters first, then lower.
    local ix = 0
    for _, p in ipairs(alphabet) do
        ix = ix + 1
        if c == p[1] then return ix end
    end
    for _, p in ipairs(alphabet) do
        ix = ix + 1
        if c == p[2] then return ix end
    end
    -- fallback if not found
    return 0
end

-- sort list of strings by explicitely provided alphabet
namespace.sort_utf8 = function(alphabet, lst)
    -- helper function to extract index from alphabet list
    local function is_less(s1, s2)
        if s1 == "" and s2 == "" then return false end
        if s1 == "" and s2 ~= "" then return true end
        if s1 ~= "" and s2 == "" then return false end
        local a = namespace.ord(alphabet, namespace.take_utf8(s1))
        local b = namespace.ord(alphabet, namespace.take_utf8(s2))
        if a < b then return true end
        if b < a then return false end
        return is_less(namespace.drop_utf8(s1), namespace.drop_utf8(s2))
    end
    table.sort(lst, is_less)
end

-- convert 1 character to upper case, consider alphabet
namespace.upper1 = function(alphabet, c)
    for _, p in ipairs(alphabet) do
        if c == p[1] or c == p[2] then return p[1] end
    end
    return c
end

return namespace

