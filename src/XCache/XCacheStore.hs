module XCache.XCacheStore (run, xcacheStore) where

import qualified Data.Text                      as T
import qualified Data.Text.IO                   as T
import           RIO
import           Turtle                         (mktree, parent, shellStrict,
                                                 writeTextFile)
import           XCache.Cli.XCacheStoreArgument (XCacheStoreArgument (..))
import           XCache.Env                     (HasXCacheFolder (..))
import           XCache.Utils                   (xcachePath)

run :: HasXCacheFolder env => XCacheStoreArgument -> RIO env ()
run XCacheStoreArgument {discardOnFail, inputCommand} =
    xcacheStore inputCommand discardOnFail >>= liftIO . T.putStr

xcacheStore :: (MonadIO m, MonadReader env m, HasXCacheFolder env) => NonEmpty Text -> Bool -> m Text
xcacheStore inputCommand discardOnFail = do
    (exitCode, output) <- shellStrict (T.unwords . toList $ inputCommand) mempty
    let isFailed = exitCode /= ExitSuccess
    if isFailed && discardOnFail then pure "" else do
        filePath <- xcachePath inputCommand
        mktree $ parent filePath
        liftIO $ do
            writeTextFile filePath output
            pure output
