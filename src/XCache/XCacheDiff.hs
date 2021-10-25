module XCache.XCacheDiff (run, xcacheDiff) where

import           Data.Algorithm.DiffContext    (getContextDiff,
                                                prettyContextDiff)
import qualified Data.Text                     as T
import qualified Data.Text.IO                  as T
import           RIO
import           Text.PrettyPrint              (render, zeroWidthText)
import           Turtle                        (mktree, parent, touch)
import           XCache.Cli.XCacheDiffArgument (XCacheDiffArgument (..))
import           XCache.Env                    (HasXCacheFolder (..))
import           XCache.Utils                  (xcachePath)
import           XCache.XCacheGet              (xcacheGet)
import           XCache.XCacheStore            (xcacheStore)

run :: HasXCacheFolder env => XCacheDiffArgument -> RIO env ()
run XCacheDiffArgument {discardOnFail, inputCommand} =
    xcacheDiff inputCommand discardOnFail >>= liftIO . T.putStr

xcacheDiff :: (MonadIO m, MonadReader env m, HasXCacheFolder env) => NonEmpty Text -> Bool -> m Text
xcacheDiff inputCommand discardOnFail = do
    touchCache inputCommand
    previousResult <- T.lines <$> xcacheGet inputCommand
    newResult <- T.lines <$> xcacheStore inputCommand discardOnFail
    let diffs = getContextDiff 0 previousResult newResult
    pure . T.pack . render $ prettyContextDiff "previousResult" "newResult" (zeroWidthText . T.unpack) diffs

touchCache :: (MonadIO m, MonadReader env m, HasXCacheFolder env) => NonEmpty Text -> m ()
touchCache inputCommand = do
    filePath <- xcachePath inputCommand
    mktree $ parent filePath
    touch filePath
