module XCache.Lib (run) where

import           RIO
import           XCache.Cli.XCacheArgument (XCacheArgument (..))
import qualified XCache.XCacheDiff         as XCacheDiff
import qualified XCache.XCacheGet          as XCacheGet
import qualified XCache.XCacheGetPath      as XCacheGetPath
import qualified XCache.XCacheStore        as XCacheStore

run :: HasLogFunc env => XCacheArgument -> RIO env ()
run (XCacheGet arguments)     = XCacheGet.run arguments
run (XCacheGetPath arguments) = XCacheGetPath.run arguments
run (XCacheStore arguments)   = XCacheStore.run arguments
run (XCacheDiff arguments)    = XCacheDiff.run arguments
