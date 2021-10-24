module XCache.Utils
    ( xcachePath
    , xcacheFileName
    , defaultXCachePath
    ) where

import           Crypto.Hash
import qualified Data.Text          as T
import qualified Data.Text.Encoding as T
import           RIO
import           Turtle             (FilePath, fromText, home, (</>))

xcachePath :: Turtle.FilePath -> Turtle.FilePath -> Turtle.FilePath
xcachePath baseFolder fileName = baseFolder </> xcacheFolder </> fileName

xcacheFolder :: IsString a => a
xcacheFolder = ".xcache"

xcacheFileName :: NonEmpty Text -> Turtle.FilePath
xcacheFileName = fromText . sha256 . T.unwords . toList

sha256 :: Text -> Text
sha256 = T.pack . show . hash256 . T.encodeUtf8
    where hash256 = hash :: ByteString -> Digest SHA256

defaultXCachePath :: MonadIO m => Turtle.FilePath -> m Turtle.FilePath
defaultXCachePath fileName = do
    h <- home
    pure $ xcachePath h fileName
