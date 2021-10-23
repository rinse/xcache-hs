module XCache.Cli.XCacheGetPathArgument
    ( XCacheGetPathArgument (..)
    , xcacheGetPathArgumentParserInfo
    ) where

import           Control.Monad.Writer.Strict
import           Options.Applicative
import           RIO
import           XCache.Cli.Utils

newtype XCacheGetPathArgument = XCacheGetPathArgument
    { inputCommand :: NonEmpty Text
    } deriving (Read, Show)

xcacheGetPathArgumentParser :: Parser XCacheGetPathArgument
xcacheGetPathArgumentParser = XCacheGetPathArgument <$> inputCommandParser

xcacheGetPathArgumentParserInfo :: ParserInfo XCacheGetPathArgument
xcacheGetPathArgumentParserInfo =
    (helper <*> xcacheGetPathArgumentParser) `info` mods
    where
    mods = execWriter $ do
        tell $ progDesc "Print the path to the cache file."
        tell forwardOptions
