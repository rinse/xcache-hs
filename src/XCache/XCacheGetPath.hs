module XCache.XCacheGetPath (run) where

import           RIO
import           Turtle                           (encodeString, testpath)
import           XCache.Cli.XCacheGetPathArgument (XCacheGetPathArgument (..))
import           XCache.Utils

run :: HasLogFunc env => XCacheGetPathArgument -> RIO env ()
run XCacheGetPathArgument {inputCommand} = do
    filePath <- defaultXCachePath $ xcacheFileName inputCommand
    isCacheFound <- testpath filePath
    if isCacheFound
        then liftIO . Prelude.putStrLn . encodeString $ filePath
        else logError "xcache: The command is not cached."
