module XCache.XCacheGet (run, xcacheGet) where

import qualified Data.Text                    as T
import           RIO
import           Turtle                       (input, stdout, strict, testpath)
import           XCache.Cli.XCacheGetArgument (XCacheGetArgument (..))
import           XCache.Utils

run :: HasLogFunc env => XCacheGetArgument -> RIO env ()
run XCacheGetArgument {inputCommand} = do
    filePath <- defaultXCachePath . T.unwords $ toList inputCommand
    isCacheFound <- testpath filePath
    if isCacheFound
        then Turtle.stdout $ input filePath
        else logError "xcache: The command is not cached."

xcacheGet :: MonadIO m => NonEmpty Text -> m Text
xcacheGet inputCommand = do
    let inputCommand' = T.unwords $ toList inputCommand
    filePath <- defaultXCachePath inputCommand'
    strict $ input filePath
