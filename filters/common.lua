-- Common functions

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

return namespace

