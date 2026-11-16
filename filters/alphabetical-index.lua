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

