-- Pandoc filter that captures 'review' chapter attributes
-- and reinserts review tables to the document inside
--    '[]{.review-by-chapter}'
--    '[]{.review-by-author}'

local function take(n, tbl)
  local result = {}
  for i = 1, math.min(n, #tbl) do
    result[i] = tbl[i]
  end
  return result
end

-- Remember in which header we currently are.
local current_header = {}

local reviewers = {}

local function placeholder (cls)
    return pandoc.Para({pandoc.Span("", {class = cls})})
end

local function collect (el)
    level = el.level
    chapter = el.identifier
    reviewer = el.attributes["review"]

    -- trim current header path to the 'level', then append chapter name
    current_header = take(level-1, current_header)
    table.insert(current_header, chapter)

    -- remember reviewer
    if reviewer ~= nil then
        table.insert(reviewers, { chapter = current_header, reviewer = reviewer })
    end
end

local function replace (el)
    if el == placeholder("review-by-chapter") then
        return pandoc.Para("...TODO: by chapter...")
    end

    if el == placeholder("review-by-author") then
        return pandoc.Para("...TODO: by author...")
    end
end

function Pandoc(doc)
    -- walk document twice, with 'collect' and 'replace' staged
    return doc:walk { Header = collect }:walk { Para = replace }
end

