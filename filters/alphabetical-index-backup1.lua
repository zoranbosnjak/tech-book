-- Pandoc filter for "alphabetical index"
--
-- Usage:
--
-- {index="some value"} anywhere in a document, including chapters
-- or words or empty box, like this []{index="my index"}.
--
-- This filter will create alphabetical index table, at []{.index-table}.

-- Inform luacheck about some globals, provided by 'pandoc'.
-- luacheck: globals pandoc Pandoc

local filter_dir = pandoc.path.directory(PANDOC_SCRIPT_FILE)
package.path = filter_dir .. "/?.lua;" .. package.path

local common = require 'common'

local logging = require 'logging'

local sequence = 0
local locations = {}

-- look for {index="val"} attributes
local function collect(el)
    local attr = el.attr
    local value = attr and attr.attributes and attr.attributes.index
    if not value then return nil end

    -- got it
    sequence = sequence + 1
    local id = "idx-" .. sequence

    -- if the element already has 'identifier', use it
    -- otherwise create a new empty span with the identifier and
    -- insert it just befor the content, so that we can link somewhere
    if el.identifier and el.identifier ~= "" then
        id = el.identifier
    else
        local anchor = pandoc.Span({}, pandoc.Attr(id))
        el.content:insert(1, anchor)
    end

    -- remember location
    locations[sequence] = {
        value = value,
        id = id,
    }

    -- el is potentially modified
    return el
end

local collect_filter = {
    traverse = "topdown",
    Block = collect,
    Inline = collect,
}

local function replace(el)
    if el ~= common.placeholder("index-table") then return el end
    local groups = {}
    local group_order = {}

    local out = {}

    for _, location in ipairs(locations) do
      local initial = common.first_character(location.value):upper()
      local key = pandoc.text.lower(initial)

      if not groups[key] then
        groups[key] = {}
        group_order[#group_order + 1] = key
      end

      groups[key][#groups[key] + 1] = location
    end

    --[[
    for _, location in ipairs(locations) do
        local target = "#" .. location.id
        local label = location.value
        -- logging.temp(target, value)
        el.content:insert( pandoc.Link({ pandoc.Str(label) }, target))
    end
    ]]--

    return el
end

function Pandoc(doc)
    return doc:walk(collect_filter):walk { Para = replace }
end

--[[
local use_locations = {
  Para = function(el)
    local groups = {}
    local group_order = {}

    for _, location in ipairs(locations) do
      local initial = location.value:sub(1, 1):upper()

      if not groups[initial] then
        groups[initial] = {}
        group_order[#group_order + 1] = initial
      end

      groups[initial][#groups[initial] + 1] = location
    end

    local out = pandoc.Inlines()

    for _, initial in ipairs(group_order) do
      if #out > 0 then
        out:insert(pandoc.Str(";"))
        out:insert(pandoc.Space())
      end

      out:insert(pandoc.Str(initial .. ":"))
      out:insert(pandoc.Space())

      for i, location in ipairs(groups[initial]) do
        if i > 1 then
          out:insert(pandoc.Str(","))
          out:insert(pandoc.Space())
        end

        out:insert(pandoc.Link(
          { pandoc.Str(location.value) },
          "#" .. location.id
        ))
      end
    end

    el.content:extend(out)
    return el
  end,
}
]]--

