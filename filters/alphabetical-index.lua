-- Pandoc filter for "alphabetical index"
--
-- Usage:
--
-- {index="some value"} anywhere in a document, including chapters
-- or words or empty box, like this []{index="my index"}.
--
-- This filter will create alphabetical index table, at this
-- placeholder: []{.index-table}.

-- Inform luacheck about some globals, provided by 'pandoc'.
-- luacheck: globals pandoc PANDOC_SCRIPT_FILE FORMAT Pandoc

local filter_dir = pandoc.path.directory(PANDOC_SCRIPT_FILE)
package.path = filter_dir .. "/?.lua;" .. package.path

local placeholder = require("pandoc-utils").placeholder
local tu = require("text-utils")
local tbl = require("table-utils")
local ab = require("si").alphabet

local sequence = 0
local accumulator = {}

-- collect {index="val"} attributes
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

    -- remember it
    local ids = accumulator[value] or {}
    table.insert(ids, id)
    accumulator[value] = ids

    -- The element might be updated.
    return el
end

local collect_filter = {
    traverse = "topdown",
    Block = collect,
    Inline = collect,
}

local function bigger_font(text)
    local content = { pandoc.Str(text) }

    if FORMAT:match("^typst") then
        return pandoc.Span(content, pandoc.Attr("", {}, {
            ["typst:text:size"] = "18pt"
        }))
    elseif FORMAT:match("^html") then
        return pandoc.Span(content, pandoc.Attr("", {}, {
            style = "font-size: 1.5em"
        }))
    end

    return pandoc.Span(content)
end

local function make_location_link(l)
    if FORMAT:match("typst") then
        local raw = "#ref(<" .. l .. ">, form: \"page\", supplement: none)"
       return pandoc.RawInline("typst", raw)
    else
        return pandoc.Link({ pandoc.Str("ref") }, "#" .. l)
    end
end

local function replace(el)
    if el ~= placeholder("index-table") then return el end

    -- determine and sort initial letters in uppercase
    local initials = {}
    for key, _ in pairs(accumulator) do
        local c = tu.upper1(ab, tu.take_utf8(key))
        initials[c] = true
    end
    initials = tbl.set2list(initials)
    tu.sort_utf8(ab, initials)

    -- for each initial character, show references
    for _, initial in ipairs(initials) do
        el.content:insert(pandoc.LineBreak())
        el.content:insert(bigger_font(initial .. ":"))
        el.content:insert(pandoc.LineBreak())

        local function is_relevant(key, _)
            return tu.upper1(ab, tu.take_utf8(key)) == initial
        end
        local relevant = tbl.map_filter(is_relevant, accumulator)
        local relevant_keys = tbl.map_keys(relevant)
        tu.sort_utf8(ab, relevant_keys)

        for i, key in ipairs(relevant_keys) do
            el.content:insert(pandoc.Str(key .. " ("))
            local values = relevant[key]
            for j, value in ipairs(values) do
                el.content:insert(make_location_link(value))
                if j < #values then
                    el.content:insert(pandoc.Str(", "))
                end
            end
            el.content:insert(pandoc.Str(")"))
            if i < #relevant_keys then
                el.content:insert(pandoc.Str(", "))
            end
        end

        el.content:insert(pandoc.LineBreak())
    end
    return el
end

function Pandoc(doc)
    return doc:walk(collect_filter):walk { Para = replace }
end

