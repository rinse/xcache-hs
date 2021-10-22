module Lib
    ( someFunc
    ) where

import           RIO

{- $setup
>>> :set -XOverloadedStrings
>>> import Control.Monad
-}

{- |It returns someFunc.
>>> someFunc
"someFunc"

prop> const someFunc x == someFunc

>>> :{
let sth = join
            [ "Hello"
            , ", "
            , "World"
            ]
    in const someFunc sth
:}
"someFunc"
-}
someFunc :: String
someFunc = "someFunc"
