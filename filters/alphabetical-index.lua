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

    return el
end

local collect_filter = {
    traverse = "topdown",
    Block = collect,
    Inline = collect,
}

local function replace(el)
    if el ~= common.placeholder("index-table") then return el end

    local letters = {}

    -- collect initial letters in a set
    for _, location in ipairs(locations) do
        local initial = common.take_utf8(location.value)
        letters[initial] = true
    end

    local sample = {"asdf", "dsfasd", "ab"}
    -- local result = common.sorted(common.si_alphabet, sample)
    -- common.logging.temp(sample)
    common.debug(common.sorted(common.si_alphabet, sample))
    -- common.logging.temp(common.set2list(letters))
    -- common.logging.temp(common.sorted(common.si_alphabet, common.set2list(letters)))
    -- logging.temp(result)
    -- common.logging.temp('letters', letters)
    -- common.logging.temp('sorted', common.sorted(common.si_alphabet, letters))

    -- for each initial character, show references

end

function Pandoc(doc)
    return doc:walk(collect_filter):walk { Para = replace }
end

