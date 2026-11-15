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

    return pandoc.RawInline("typst", '#ref(<' .. id .. '>, form: "page")')
  end

  -- Keep the ordinary clickable link in HTML and other formats.
  return nil
end

