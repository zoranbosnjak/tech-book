function Pandoc(doc)

    local value = doc.meta["only-chapters"]
    if value then
        print("Found:", pandoc.utils.stringify(value))
        -- remove flag such that it won't influence doc
        doc.meta["only-chapters"] = nil
    end

    return doc
end

