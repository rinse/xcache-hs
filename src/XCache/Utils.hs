module XCache.Utils
    ( xcachePath
    , xcacheFileName
    , defaultXCacheFolder
    ) where

import           Crypto.Hash
import qualified Data.Text          as T
import qualified Data.Text.Encoding as T
import           RIO
import           Turtle             (FilePath, fromText, home, (</>))
import           XCache.Env

defaultXCacheFolder :: MonadIO m => m Turtle.FilePath
defaultXCacheFolder = do
    h <- home
    pure $ h </> xcacheFolder

xcacheFolder :: IsString a => a
xcacheFolder = ".xcache"

xcachePath :: (MonadReader env m, HasXCacheFolder env) => NonEmpty Text -> m Turtle.FilePath
xcachePath command = do
    folder <- view xcacheFolderL
    pure $ folder </> xcacheFileName command

xcacheFileName :: NonEmpty Text -> Turtle.FilePath
xcacheFileName = fromText . sha256 . T.unwords . toList

sha256 :: Text -> Text
sha256 = T.pack . show . hash256 . T.encodeUtf8
    where hash256 = hash :: ByteString -> Digest SHA256
