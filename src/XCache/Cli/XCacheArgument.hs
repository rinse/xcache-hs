module XCache.Cli.XCacheArgument where

import           Control.Monad.Writer.Strict
import           Options.Applicative
import           RIO
import           XCache.Cli.XCacheDiffArgument
import           XCache.Cli.XCacheGetArgument
import           XCache.Cli.XCacheGetPathArgument
import           XCache.Cli.XCacheStoreArgument

data XCacheArgument
    = XCacheGet XCacheGetArgument
    | XCacheGetPath XCacheGetPathArgument
    | XCacheStore XCacheStoreArgument
    | XCacheDiff XCacheDiffArgument
    deriving (Read, Show)

xcacheArgumentParser :: Parser XCacheArgument
xcacheArgumentParser = subparser . execWriter $ do
    tell . command "get" $ XCacheGet <$> xcacheGetArgumentParserInfo
    tell . command "get-path" $ XCacheGetPath <$> xcacheGetPathArgumentParserInfo
    tell . command "store" $ XCacheStore <$> xcacheStoreArgumentParserInfo
    tell . command "diff" $ XCacheDiff <$> xcacheDiffArgumentParserInfo

xcacheArgumentParserInfo :: ParserInfo XCacheArgument
xcacheArgumentParserInfo = (helper <*> xcacheArgumentParser) `info` mods
    where
    mods = execWriter $ do
        tell $ progDesc "A command executor with cache."
        tell forwardOptions
