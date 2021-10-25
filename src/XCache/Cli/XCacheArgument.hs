module XCache.Cli.XCacheArgument
    ( XCacheArgument (..)
    , XCacheSubcommand (..)
    , xcacheArgumentParserInfo
    ) where

import           Control.Monad.Writer.Strict
import           Options.Applicative
import           RIO
import           Turtle                           (FilePath)
import           XCache.Cli.XCacheDiffArgument
import           XCache.Cli.XCacheGetArgument
import           XCache.Cli.XCacheGetPathArgument
import           XCache.Cli.XCacheStoreArgument

data XCacheArgument = XCacheArgument
    { xcacheFolder     :: Maybe Turtle.FilePath
    , xcacheSubcommand :: XCacheSubcommand
    }

xcacheArgumentParser :: Parser XCacheArgument
xcacheArgumentParser = XCacheArgument <$> xcacheFolderParser <*> xcacheSubcommandParser
    where
    xcacheFolderParser = optional . strOption . execWriter $ do
        tell $ long "xcache-folder"
        tell . help $ unlines
            [ "The folder where cache files are stored."
            , "The default value is $HOME/.xcache."
            ]

xcacheArgumentParserInfo :: ParserInfo XCacheArgument
xcacheArgumentParserInfo = (helper <*> xcacheArgumentParser) `info` mods
    where
    mods = execWriter $ do
        tell $ progDesc "A command executor with cache."
        tell forwardOptions

data XCacheSubcommand
    = XCacheGet XCacheGetArgument
    | XCacheGetPath XCacheGetPathArgument
    | XCacheStore XCacheStoreArgument
    | XCacheDiff XCacheDiffArgument
    deriving (Read, Show)

xcacheSubcommandParser :: Parser XCacheSubcommand
xcacheSubcommandParser = subparser . execWriter $ do
    tell . command "get" $ XCacheGet <$> xcacheGetArgumentParserInfo
    tell . command "get-path" $ XCacheGetPath <$> xcacheGetPathArgumentParserInfo
    tell . command "store" $ XCacheStore <$> xcacheStoreArgumentParserInfo
    tell . command "diff" $ XCacheDiff <$> xcacheDiffArgumentParserInfo
