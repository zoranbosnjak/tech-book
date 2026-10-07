import Development.Shake
import Development.Shake.Command
import Development.Shake.FilePath
import Development.Shake.Util

sources =
    [ "Shakefile.hs"
    , "main.md"
    , "content//*.md"
    , "metadata.yaml"
    ]

templatesTypst =
    [ "templates/typst//"
    ]

targets =
    [ "_build/book.md"
    , "_build/book.typ"
    , "_build/book.pdf"
    ]

main :: IO ()
main = shakeArgs shOpts $ do

    want targets

    phony "clean" $ do
        putInfo "🧹 Cleaning files."
        removeFilesAfter "_build" ["//*"]
        putInfo "✅ Clean complete."

    phony "_sources" $ do
        putInfo "Actual source files:"
        lst <- getDirectoryFiles ""
            $ sources
           <> templatesTypst
        liftIO $ mapM_ putStrLn lst

    "_build/book.md" %> \out -> do
        putInfo "🖋 Building markdown output."
        getDirectoryFiles "" sources >>= need
        cmd_
            $ "pandoc --filter pandoc-include --from=markdown"
           <> " --metadata-file=metadata.yaml"
           <> " --to=markdown main.md"
           <> " -o " <> out

    "_build/book.typ" %> \out -> do
        putInfo "🖋 Building typst output."
        lst <- getDirectoryFiles "" templatesTypst
        need $ lst <> ["_build/book.md"]
        cmd_
            $ "pandoc _build/book.md -o " <> out
           <> " --from markdown"
           <> " --to typst"
           <> " --metadata-file=metadata.yaml"
           <> " --template=templates/typst/template1.typ"
           <> " -V template=templates/typst/template2.typ"

    "_build/templates/typst/template2.typ" %> \out -> do
        putInfo "🖋 Copy typst template."
        copyFile' "templates/typst/template2.typ" out

    "_build/book.pdf" %> \out -> do
        putInfo "🖋 Building pdf output."
        need
            [ "_build/book.typ"
            , "_build/templates/typst/template2.typ"
            ]
        cmd_ $ "typst compile _build/book.typ " <> out

  where

    shOpts = shakeOptions
        { shakeFiles = "_build"
        , shakeThreads = 4
        , shakeColor = True
        }

