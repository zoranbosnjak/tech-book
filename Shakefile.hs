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
        putInfo "🖋 Building markdown."
        getDirectoryFiles "" sources >>= need
        cmd_
            $ "pandoc --filter pandoc-include --from=markdown"
           <> " --metadata-file=metadata.yaml"
           <> " --to=markdown main.md"
           <> " -o " <> out

    "_build/book.pdf" %> \out -> do
        putInfo "🖋 Building pdf."
        templatesLst <- getDirectoryFiles "" templatesTypst
        need $ ["_build/book.md"] <> templatesLst
        cmd_
            $ "pandoc _build/book.md"
           <> " --pdf-engine=typst -o " <> out
           <> " --metadata-file=metadata.yaml"
           <> " --template=templates/typst/template1.typ"

  where

    shOpts = shakeOptions
        { shakeFiles = "_build"
        , shakeThreads = 4
        , shakeColor = True
        }

