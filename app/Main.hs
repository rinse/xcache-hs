module Main where

import           Control.Monad.Cont
import           Options.Applicative       (execParser)
import           RIO
import           XCache.Cli.XCacheArgument (xcacheArgumentParserInfo, XCacheArgument (..))
import           XCache.Env
import           XCache.Lib                (run)
import           XCache.Utils              (defaultXCacheFolder)

main :: IO ()
main = do
    XCacheArgument {xcacheFolder, xcacheSubcommand} <- execParser xcacheArgumentParserInfo
    xcacheFolder' <- (defaultXCacheFolder `maybe` pure) xcacheFolder
    flip runContT return $ do
        logFunc <- logOptionsHandle stderr False >>= ContT . withLogFunc
        let env = Env logFunc xcacheFolder'
        runRIO env $ run xcacheSubcommand
