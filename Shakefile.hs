{-# LANGUAGE LambdaCase #-}

import Control.Monad (when)
import Data.Maybe (mapMaybe)
import Data.List (intercalate)
import System.Console.GetOpt

import Development.Shake
import Development.Shake.FilePath

newtype Flags
    = OnlyChapters String
    deriving (Show, Eq)

flags :: [OptDescr (Either a Flags)]
flags =
    [ Option ['c'] ["only-chapters"] (ReqArg (Right . OnlyChapters) "PAT")
        "Only include chapters matching 'chap-subchap'."
    ]

sources :: [String]
sources =
    [ "Shakefile.hs"
    , "main.md"
    , "content//"
    , "filters//"
    , "metadata.yaml"
    , "bibliography.bib"
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
    [ "_build/book.inc"
    , "_build/book.md"
    , "_build/book.native"
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

assetDir :: String -> Rules()
assetDir s = do
    phonyAsset s
    copyAsset s

main :: IO ()
main = shakeArgsWith shOpts flags $ \flags' newTargets -> pure $ Just $ do

    let actualTargets = if null newTargets then targets else newTargets

    want $ actualTargets <>
        [ wantAsset "content"
        , wantAsset "templates"
        , wantAsset "assets"
        ]

    assetDir "content"
    assetDir "templates"
    assetDir "assets"

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

    "_build/book.inc" %> \out -> do
        putInfo "🖋 Handle markdown includes."
        getDirectoryFiles "" sources >>= need
        cmd_
            $ "pandoc main.md"
           <> " --filter pandoc-include"
           <> " --from=markdown-auto_identifiers"
           <> " --to=markdown"
           <> " -o " <> out

    "_build/book.md" %> \out -> do
        putInfo "🖋 Building markdown output."
        let onlyChaptersList = flip mapMaybe flags' $ \case
                OnlyChapters ch -> Just ch
            onlyChaptersString
                = (\s -> "\"" <> s <> "\"")
                $ intercalate "|" onlyChaptersList
            onlyChaptersFilter = case onlyChaptersList of
                [] -> ""
                _ ->
                    " --lua-filter filters/only-chapters.lua"
                    <> " -M only-chapters=" <> onlyChaptersString
        when (onlyChaptersList /= []) $ do
            putWarn $ "⥹ Only include chapters: " <> onlyChaptersString

        need ["_build/book.inc"]
        cmd_ Shell
            $ "pandoc _build/book.inc"
           <> onlyChaptersFilter
           <> " --lua-filter filters/review.lua"
           <> " --from=markdown"
           <> " --to=markdown"
           <> " -o " <> out

    "_build/book.native" %> \out -> do
        putInfo "🖋 Building native output."
        need ["_build/book.md"]
        cmd_
            $ "pandoc _build/book.md -o " <> out
           <> " --from markdown"
           <> " --to native"

    "_build/book.typ" %> \out -> do
        putInfo "🖋 Building typst output."
        lst <- getDirectoryFiles "" templatesTypst
        need $ lst <> ["_build/book.md"]
        cmd_
            $ "pandoc _build/book.md -o " <> out
           <> " --from markdown"
           <> " --to typst"
           <> " --abbreviations=assets/abbrevs.txt"
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
           <> " --abbreviations=assets/abbrevs.txt"
           <> " --template=templates/html/template.html"
           <> " --css templates/html/style.css"
           <> " -M document-css=false"
           <> " --include-in-header templates/html/in-header.html"
           <> " --include-before-body templates/html/before-body.html"
           <> " --include-after-body templates/html/after-body.html"

  where

    shOpts = shakeOptions
        { shakeFiles = "_build"
        , shakeThreads = 4
        , shakeColor = True
        }

