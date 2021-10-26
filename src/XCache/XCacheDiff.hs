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
run XCacheDiffArgument {discardOnFail, unified, inputCommand} =
    xcacheDiff inputCommand unified discardOnFail >>= liftIO . T.putStr

xcacheDiff :: (MonadIO m, MonadReader env m, HasXCacheFolder env) => NonEmpty Text -> Int -> Bool -> m Text
xcacheDiff inputCommand numContext discardOnFail = do
    touchCache inputCommand
    previousResult <- T.lines <$> xcacheGet inputCommand
    newResult <- T.lines <$> xcacheStore inputCommand discardOnFail
    let diffs = getContextDiff numContext previousResult newResult
    pure . T.pack . render $ prettyContextDiff "prev" "new" (zeroWidthText . T.unpack) diffs

touchCache :: (MonadIO m, MonadReader env m, HasXCacheFolder env) => NonEmpty Text -> m ()
touchCache inputCommand = do
    filePath <- xcachePath inputCommand
    mktree $ parent filePath
    touch filePath
