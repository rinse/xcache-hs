module XCache.Cli.XCacheStoreArgument
    ( XCacheStoreArgument (..)
    , xcacheStoreArgumentParserInfo
    ) where

import           Control.Monad.Writer.Strict
import           Options.Applicative
import           RIO
import           XCache.Cli.Utils

data XCacheStoreArgument = XCacheStoreArgument
    { discardOnFail :: Bool
    , inputCommand  :: NonEmpty Text
    } deriving (Read, Show)

xcacheStoreArgumentParser :: Parser XCacheStoreArgument
xcacheStoreArgumentParser = XCacheStoreArgument <$> discardOnFailParser <*> inputCommandParser

xcacheStoreArgumentParserInfo :: ParserInfo XCacheStoreArgument
xcacheStoreArgumentParserInfo =
    (helper <*> xcacheStoreArgumentParser) `info` mods
    where
    mods = execWriter $ do
        tell $ progDesc "Run the given command, store the result on cache and print the result."
        tell forwardOptions
