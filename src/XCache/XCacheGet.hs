module XCache.XCacheGet (run, xcacheGet) where

import           RIO
import           Turtle                       (input, stdout, strict, testpath)
import           XCache.Cli.XCacheGetArgument (XCacheGetArgument (..))
import           XCache.Env                   (HasXCacheFolder (..))
import           XCache.Utils                 (xcachePath)

run :: (HasLogFunc env, HasXCacheFolder env) => XCacheGetArgument -> RIO env ()
run XCacheGetArgument {inputCommand} = do
    filePath <- xcachePath inputCommand
    isCacheFound <- testpath filePath
    if isCacheFound
        then Turtle.stdout $ input filePath
        else logError "xcache: The command is not cached."

xcacheGet :: (MonadIO m, MonadReader env m, HasXCacheFolder env) => NonEmpty Text -> m Text
xcacheGet inputCommand = do
    filePath <- xcachePath inputCommand
    strict $ input filePath
