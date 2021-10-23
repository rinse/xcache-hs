module XCache.Cli.Utils where

import           Control.Monad.Writer.Strict
import           Options.Applicative
import           Options.Applicative.NonEmpty
import           RIO

inputCommandParser :: Parser (NonEmpty Text)
inputCommandParser = some1 (strArgument (metavar "COMMAND"))

discardOnFailParser :: Parser Bool
discardOnFailParser = switch . execWriter $ do
    tell $ long "discard-on-fail"
    tell $ help "Do not store a result as cache when the command finishes with non-zero code."
