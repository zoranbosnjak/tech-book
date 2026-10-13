-- Pandoc filter to include only some selected chapters during development
-- process.
--
-- A pattern string is passed as meta data 'only-chapters' in the form:
-- "foo|bar|baz", where 'foo', 'bar', 'baz' are the actual patterns to compare
-- each chapter with.

-- Inform luacheck about some globals, provided by 'pandoc'.
-- luacheck: globals pandoc PANDOC_SCRIPT_FILE

-- set path for local imports
local filter_dir = pandoc.path.directory(PANDOC_SCRIPT_FILE)
package.path = filter_dir .. "/?.lua;" .. package.path

local logging = require 'logging' -- luacheck: ignore
local common = require 'common' -- luacheck: ignore

-- split string on '|'
local function split_arg(arg)
    local result = {}
    for word in arg:gmatch("([^|]+)") do
        table.insert(result, word)
    end
    return result
end

-- helper function to format "chapter>subchapter>..."
local function fmt_chapter(lst)
    return table.concat(lst, ">")
end

-- collect chapters we explicitely want to keep
local function collect_keep(match, doc)
    local current = {}
    local result = {}
    doc:walk { Header = function(el)
        current = common.take(el.level-1, current)
        table.insert(current, el.identifier)
        local s = fmt_chapter(current)
        if match(s) then
            table.insert(result, s)
        end
    end}
    return result
end

-- find remote references inside chapters we are keeping
local function collect_refs(keep, doc)
    local flag = false
    local current = {}
    local result = {}
    doc:walk {
        traverse = 'topdown',
        Header = function(el)
            current = common.take(el.level-1, current)
            table.insert(current, el.identifier)
            local s = fmt_chapter(current)
            if common.is_elem(s, keep) then
                flag = true
            else
                flag = false
            end
        end,
        Link = function(el)
            if flag then
                table.insert(result, el.target)
            end
        end
    }
    return result
end

-- determine i 's' is a subchapter we want to keep
local function is_subchapter(keep, s)
    for _, s0 in ipairs(keep) do
        if s:find(s0, 1, true) == 1 then
            return true
        end
    end
    return false
end

-- strip the document to contain only required chapters and
-- the necessary references
local function strip(keep, refs, doc)
    local current = {}
    local flag = false
    local new_blocks = {}
    for _, el in ipairs(doc.blocks) do
        if el.t == "Header" then
            current = common.take(el.level-1, current)
            table.insert(current, el.identifier)
            local s = fmt_chapter(current)
            if is_subchapter(keep, s) then
                flag = true
            else
                flag = false
            end
            local my_ref = "#" .. el.identifier
            if common.is_elem(my_ref, refs) or flag then
                table.insert(new_blocks, el)
            end
        else
            if flag then
                table.insert(new_blocks, el)
            end
        end
    end
    return pandoc.Pandoc(new_blocks, doc.meta)
end

-- main filter entry point
function Pandoc(doc) -- luacheck: ignore
    local arg = doc.meta["only-chapters"]
    if not arg then
        return doc
    end
    -- remove flag such that it won't influence doc
    doc.meta["only-chapters"] = nil

    -- create chapter matching function, based on given argument
    local match = function(s)
        for _, pat in ipairs(split_arg(arg)) do
            if s:lower():match(pat:lower()) then
                return true
            end
        end
        return false
    end

    local keep = collect_keep(match, doc)
    local refs = collect_refs(keep, doc)
    return strip(keep, refs, doc)
end

