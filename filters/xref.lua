-- Pandoc filter for cross references in PDF.
--
-- Attach {.xref} class to some 'link' and this filter will
-- turn it to '#ref' in typst.

-- Inform luacheck about some globals, provided by 'pandoc'.
-- luacheck: globals pandoc Link FORMAT

function Link(el)
  if not el.classes:includes("xref") then
    return nil
  end

  if FORMAT:match("typst") then
    local id = el.target:match("^#(.+)$")
    if not id then
      pandoc.log.warn("xref link must target a local heading, e.g. #intro")
      return nil
    end

    return pandoc.RawInline(
        "typst",
        '#context { let target = query(<' .. id ..
        '>).first(); link(<' .. id ..
        '>)[#target.body (#ref(<' .. id ..
        '>, form: "page"))] }'
    )

  end

  -- Keep the ordinary clickable link in HTML and other formats.
  return nil
end

