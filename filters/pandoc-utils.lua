-- Pandoc related helper functions

-- Inform luacheck about some globals, provided by 'pandoc'.
-- luacheck: globals pandoc

local namespace = {}

-- helper function to detect a placeholder in markdown
namespace.placeholder = function(cls)
    return pandoc.Para({pandoc.Span("", {class = cls})})
end

return namespace

