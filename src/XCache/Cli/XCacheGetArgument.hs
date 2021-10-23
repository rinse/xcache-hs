module XCache.Cli.XCacheGetArgument
    ( XCacheGetArgument (..)
    , xcacheGetArgumentParserInfo
    ) where

import           Control.Monad.Writer.Strict
import           Options.Applicative
import           RIO
import           XCache.Cli.Utils

newtype XCacheGetArgument = XCacheGetArgument
    { inputCommand :: NonEmpty Text
    } deriving (Read, Show)

xcacheGetArgumentParser :: Parser XCacheGetArgument
xcacheGetArgumentParser = XCacheGetArgument <$> inputCommandParser

xcacheGetArgumentParserInfo :: ParserInfo XCacheGetArgument
xcacheGetArgumentParserInfo =
    (helper <*> xcacheGetArgumentParser) `info` mods
    where
    mods = execWriter $ do
        tell $ progDesc "Print the previous result of the given command from cache."
        tell forwardOptions
