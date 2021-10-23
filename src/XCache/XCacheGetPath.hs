module XCache.XCacheGetPath (run) where

import qualified Data.Text                        as T
import           RIO
import           Turtle                           (encodeString, testpath)
import           XCache.Cli.XCacheGetPathArgument (XCacheGetPathArgument (..))
import           XCache.Utils

run :: HasLogFunc env => XCacheGetPathArgument -> RIO env ()
run XCacheGetPathArgument {inputCommand} = do
    filePath <- defaultXCachePath . T.unwords $ toList inputCommand
    isCacheFound <- testpath filePath
    if isCacheFound
        then liftIO . Prelude.putStrLn . encodeString $ filePath
        else logError "xcache: The command is not cached."
