module XCache.Cli.XCacheDiffArgument
    ( XCacheDiffArgument (..)
    , xcacheDiffArgumentParserInfo
    ) where

import           Control.Monad.Writer.Strict
import           Options.Applicative
import           RIO
import           XCache.Cli.Utils

data XCacheDiffArgument = XCacheDiffArgument
    { discardOnFail :: Bool
    , inputCommand  :: NonEmpty Text
    } deriving (Read, Show)

xcacheDiffArgumentParser :: Parser XCacheDiffArgument
xcacheDiffArgumentParser = XCacheDiffArgument <$> discardOnFailParser <*> inputCommandParser

xcacheDiffArgumentParserInfo :: ParserInfo XCacheDiffArgument
xcacheDiffArgumentParserInfo =
    (helper <*> xcacheDiffArgumentParser) `info` mods
    where
    mods = execWriter $ do
        tell $ progDesc "Run the given command, store the result on cache and print diff from the previous result."
        tell forwardOptions
