module LibSpec (spec) where

import           Lib
import           RIO
import           Test.Hspec


spec :: Spec
spec =
    describe "someFunc" $
        it "always returns someFunc" $
            someFunc `shouldBe` "someFunc"
