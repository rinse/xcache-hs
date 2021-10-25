module XCache.Env where

import           RIO
import           Turtle (FilePath)

data Env = Env
    { envLogFunc      :: LogFunc
    , envXCacheFolder :: Turtle.FilePath
    }

instance HasLogFunc Env where
    logFuncL = lens envLogFunc $ \x y -> x { envLogFunc = y }

class HasXCacheFolder env where
    xcacheFolderL :: Lens' env Turtle.FilePath

instance HasXCacheFolder Env where
    xcacheFolderL = lens envXCacheFolder $ \x y -> x { envXCacheFolder = y }
