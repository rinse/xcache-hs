module XCache.Utils
    ( xcachePath
    , defaultXCachePath
    ) where

import           Crypto.Hash
import qualified Data.Text          as T
import qualified Data.Text.Encoding as T
import           RIO
import           Turtle             (FilePath, fromText, home, (</>))

xcachePath :: Turtle.FilePath -> Text -> Turtle.FilePath
xcachePath baseFolder command = baseFolder </> xcacheFolder </> fromText fileName
    where
    fileName = sha256 command

xcacheFolder :: IsString a => a
xcacheFolder = ".xcache"

sha256 :: Text -> Text
sha256 = T.pack . show . hash256 . T.encodeUtf8
    where hash256 = hash :: ByteString -> Digest SHA256

defaultXCachePath :: MonadIO m => Text -> m Turtle.FilePath
defaultXCachePath command = do
    h <- home
    pure $ xcachePath h command
