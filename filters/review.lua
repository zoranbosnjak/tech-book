-- Pandoc filter that captures 'review' chapter attributes and reinserts review
-- tables to the document. It replaces the following placeholders:
--    '[]{.review-by-chapter}'
--    '[]{.review-by-author}'

-- Inform luacheck about some globals, provided by 'pandoc'.
-- luacheck: globals pandoc PANDOC_SCRIPT_FILE

-- set path for local imports
local filter_dir = pandoc.path.directory(PANDOC_SCRIPT_FILE)
package.path = filter_dir .. "/?.lua;" .. package.path

-- import logging module for debug purposes
local logging = require 'logging' -- luacheck: ignore

-- auxilary function to take some number of elements
local function take(n, tbl)
  local result = {}
  for i = 1, math.min(n, #tbl) do
    result[i] = tbl[i]
  end
  return result
end

-- Remember in which header we currently are.
local current_header = {}

-- reviewers 'accumulator'
local reviewers = {}

-- helper function
local function placeholder (cls)
    return pandoc.Para({pandoc.Span("", {class = cls})})
end

-- collect reviewers during the first document pass
local function collect (el)
    local level = el.level
    local chapter = el.identifier
    local reviewer = el.attributes["review"]

    -- trim current header path to the 'level', then append chapter name
    current_header = take(level-1, current_header)
    table.insert(current_header, chapter)

    -- remember reviewer
    if reviewer ~= nil then
        table.insert(reviewers, { chapter = current_header, reviewer = reviewer })
    end
end

-- helper function to format "chapter -> subchapter -> ..."
local function fmt_chapter(lst)
    return table.concat(lst, " -> ")
end

-- provide table content 'by_chapter'
local function by_chapter()
    local result = {}
    for i, value in ipairs(reviewers) do
        result[i] = pandoc.Row{
            pandoc.Cell(fmt_chapter(value["chapter"])),
            pandoc.Cell(value["reviewer"])
        }
    end
    return result
end

-- provide table content 'by_author'
local function by_author()
    local backwards = {}
    for _, value in ipairs(reviewers) do
        local reviewer = value["reviewer"]
        local lst = backwards[reviewer] or {}
        table.insert(lst, fmt_chapter(value["chapter"]))
        backwards[reviewer] = lst
    end
    local result = {}
    for reviewer, lst in pairs(backwards) do
        local chapters = {}
        for _, chapter in ipairs(lst) do
            table.insert(chapters, pandoc.Plain(chapter))
        end
        table.insert(result, pandoc.Row{
            pandoc.Cell(pandoc.BulletList(chapters)),
            pandoc.Cell(reviewer)
        })
    end
    return result
end

-- helper function to create a table
local function make_table(col1, col2, gen)
    return pandoc.Table(
        pandoc.Caption(),
        {
            { pandoc.AlignLeft, 0.8 },
            { pandoc.AlignLeft, 0.3 },
        },
        pandoc.TableHead{
            pandoc.Row{
                pandoc.Cell(col1),
                pandoc.Cell(col2)
            }
        },
        {
            {
                attr = {},
                body = gen(),
                head = {},
                row_head_columns = 0
            }
        },
        pandoc.TableFoot()
    )
end

-- replace the placeholders during the second document pass
local function replace(el)
    if el == placeholder("review-by-chapter") then
        return make_table("Chapter", "Reviewer", by_chapter)
    end

    if el == placeholder("review-by-author") then
        return make_table("Chapters", "Reviewer", by_author)
    end
end

-- main filter entry point
function Pandoc(doc) -- luacheck: ignore
    -- walk document twice, with 'collect' and 'replace' stages
    return doc:walk { Header = collect }:walk { Para = replace }
end

