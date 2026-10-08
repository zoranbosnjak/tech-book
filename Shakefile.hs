import Development.Shake
import Development.Shake.Command
import Development.Shake.FilePath
import Development.Shake.Util

sources :: [String]
sources =
    [ "Shakefile.hs"
    , "main.md"
    , "content//"
    , "metadata.yaml"
    ]

templatesTypst :: [String]
templatesTypst =
    [ "templates/typst//"
    ]

templatesHtml :: [String]
templatesHtml =
    [ "templates/html//"
    ]

targets :: [String]
targets =
    [ "_build/book.md"
    , "_build/book.typ"
    , "_build/book.pdf"
    , "_build/book.html"
    ]

wantAsset :: String -> FilePath
wantAsset = (<>) "copy-"

phonyAsset :: String -> Rules ()
phonyAsset s = phony val $ do
    files <- getDirectoryFiles s ["//*"]
    need [("_build/" <> s) </> f | f <- files]
  where
    val = "copy-" <> s

copyAsset :: String -> Rules ()
copyAsset s = ("_build/" <> s <> "//*") %> \out -> do
    let src = s </> dropDirectory1 (dropDirectory1 out)
    copyFileChanged src out

main :: IO ()
main = shakeArgs shOpts $ do

    want $ targets <>
        [ wantAsset "content"
        , wantAsset "templates"
        ]

    phonyAsset "content"
    phonyAsset "templates"

    copyAsset "content"
    copyAsset "templates"

    phony "clean" $ do
        putInfo "🧹 Cleaning files."
        removeFilesAfter "_build" ["//*"]
        putInfo "✅ Clean complete."

    phony "_sources" $ do
        putInfo "Actual source files:"
        lst <- getDirectoryFiles ""
            $ sources
           <> templatesTypst
           <> templatesHtml
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

    "_build/book.pdf" %> \out -> do
        putInfo "🖋 Building pdf output."
        need
            [ "_build/book.typ"
            , "_build/templates/typst/template2.typ"
            ]
        cmd_ $ "typst compile _build/book.typ " <> out

    "_build/book.html" %> \out -> do
        putInfo "🖋 Building html output."
        lst <- getDirectoryFiles "" templatesHtml
        need $ lst <>
            [ "_build/book.md"
            , "_build/templates/html/style.css"
            ]
        cmd_
            $ "pandoc _build/book.md -o " <> out
           <> " --from markdown"
           <> " --to html5"
           <> " --template=templates/html/template.html"
           <> " --css templates/html/style.css"
           <> " --include-in-header templates/html/in-header.html"
           <> " --include-before-body templates/html/before-body.html"
           <> " --include-after-body templates/html/after-body.html"

  where

    shOpts = shakeOptions
        { shakeFiles = "_build"
        , shakeThreads = 4
        , shakeColor = True
        }

