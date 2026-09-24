import Development.Shake
import Development.Shake.Command
import Development.Shake.FilePath
import Development.Shake.Util

sources =
    [ "Shakefile.hs"
    , "main.md"
    , "content//*.md"
    , "bibliography.bib"
    , "metadata.yaml"
    ]

targets =
    [ "_build/book.md"
    , "_build/book.rst"
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
        lst <- getDirectoryFiles "" sources
        liftIO $ mapM_ putStrLn lst

    "_build/book.md" %> \out -> do
        putInfo "🖋 Building markdown."
        getDirectoryFiles "" sources >>= need
        cmd_
            $ "pandoc --filter pandoc-include --from=markdown"
           <> " --to=markdown main.md"
           <> " -o " <> out

    "_build/book.rst" %> \out -> do
        putInfo "🖋 Building rst."
        need ["_build/book.md"]
        cmd_ $ "pandoc _build/book.md -o " <> out

  where

    shOpts = shakeOptions
        { shakeFiles = "_build"
        , shakeThreads = 4
        , shakeColor = True
        }

