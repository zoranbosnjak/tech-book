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

local locations = {}
local used_ids = {}
local sequence = 0

local function remember_id(el)
  local id = el.identifier
  if id and id ~= "" then
    used_ids[id] = true
  end
end

local function new_id()
  local id

  repeat
    sequence = sequence + 1
    id = "idx-" .. sequence
  until not used_ids[id]

  used_ids[id] = true
  return id
end

local function collect_index(el)
  local attrs = el.attributes
  local value = attrs and attrs.index

  if value and value ~= "" then
    local id = el.identifier

    -- Keep an existing identifier; otherwise assign a unique one.
    if not id or id == "" then
      id = new_id()
      el.identifier = id
    end

    locations[#locations + 1] = {
      value = value,
      id = id,
    }
  end

  return el
end

local function first_character(s)
  local next_char = utf8.offset(s, 2)
  return next_char and s:sub(1, next_char - 1) or s
end

local collect_existing = {
  Block = remember_id,
  Inline = remember_id,
}

local collect_indexes = {
  Block = collect_index,
  Inline = collect_index,
  CodeBlock = collect_index,
}

local function typst_string(s)
  return '"' .. s:gsub("\\", "\\\\"):gsub('"', '\\"')
             :gsub("\n", "\\n"):gsub("\r", "\\r") .. '"'
end

local function make_location_link(location)
  if FORMAT:match("typst") then
    local raw = "#link(<" .. location.id .. ">)[#text("
      .. typst_string(location.value) .. ")]"
    return pandoc.RawInline("typst", raw)
  else
    return pandoc.Link(
      { pandoc.Str(location.value) },
      "#" .. location.id
    )
  end
end

local use_locations = {
  Para = function(el)
    local groups = {}
    local group_order = {}

    for _, location in ipairs(locations) do
      local initial = first_character(location.value)

      if not groups[initial] then
        groups[initial] = {}
        group_order[#group_order + 1] = initial
      end

      groups[initial][#groups[initial] + 1] = location
    end

    local added_group = false

    for _, initial in ipairs(group_order) do
      if added_group then
        el.content:insert(pandoc.Str(";"))
        el.content:insert(pandoc.Space())
      end

      el.content:insert(pandoc.Str(initial .. ":"))
      el.content:insert(pandoc.Space())

      for i, location in ipairs(groups[initial]) do
        if i > 1 then
          el.content:insert(pandoc.Str(","))
          el.content:insert(pandoc.Space())
        end

        el.content:insert(make_location_link(location))
      end

      added_group = true
    end

    return el
  end,
}

function Pandoc(doc)
  locations = {}
  used_ids = {}
  sequence = 0

  -- First record all existing IDs so generated ones won't conflict.
  doc = doc:walk(collect_existing)

  -- Then collect indexed elements and assign IDs where they lack one.
  doc = doc:walk(collect_indexes)

  -- Finally append grouped links to each paragraph.
  doc = doc:walk(use_locations)

  return doc
end

