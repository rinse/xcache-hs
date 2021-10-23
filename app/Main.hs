module Main where

import           Control.Monad.Cont
import           Options.Applicative       (execParser)
import           RIO
import           XCache.Cli.XCacheArgument (xcacheArgumentParserInfo)
import           XCache.Lib                (run)

data Env = Env
    { envLogFunc :: LogFunc
    }

instance HasLogFunc Env where
    logFuncL = lens envLogFunc $ \x y -> x { envLogFunc = y }

main :: IO ()
main =
    flip runContT return $ do
        logFunc <- logOptionsHandle stderr False >>= ContT . withLogFunc
        let env = Env logFunc
        runRIO env $
            liftIO (execParser xcacheArgumentParserInfo) >>= run
