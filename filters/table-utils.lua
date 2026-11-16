-- Table related helper functions (list, set, dict,...)

local namespace = {}

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

namespace.set2list = function(set)
    local result = {}
    for value in pairs(set) do
        result[#result + 1] = value
    end
    return result
end

namespace.map_keys = function(arg)
    local result = {}
    for key, _ in pairs(arg) do
        table.insert(result, key)
    end
    return result
end

namespace.map_filter = function(check, arg)
    local result = {}
    for key, val in pairs(arg) do
        if check(key, val) then
            result[key] = val
        end
    end
    return result
end

return namespace

