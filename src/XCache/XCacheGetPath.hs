module XCache.XCacheGetPath (run) where

import           RIO
import           Turtle                           (encodeString, testpath)
import           XCache.Cli.XCacheGetPathArgument (XCacheGetPathArgument (..))
import           XCache.Env                       (HasXCacheFolder (..))
import           XCache.Utils                     (xcachePath)

run :: (HasLogFunc env, HasXCacheFolder env) => XCacheGetPathArgument -> RIO env ()
run XCacheGetPathArgument {inputCommand} = do
    filePath <- xcachePath inputCommand
    isCacheFound <- testpath filePath
    if isCacheFound
        then liftIO . Prelude.putStrLn . encodeString $ filePath
        else logError "xcache: The command is not cached."
