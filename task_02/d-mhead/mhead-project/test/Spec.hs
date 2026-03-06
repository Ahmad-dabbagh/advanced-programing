module Main where

import Test.Hspec
import Test.QuickCheck
import Lib

main :: IO ()
main = hspec $ do

  describe "mhead1 (pattern matching)" $ do
    it "returns first element of [1,2,3]" $
      mhead1 [1,2,3] `shouldBe` 1

    it "returns first character of string" $
      mhead1 "Hello" `shouldBe` 'H'

    it "behaves like head for non-empty lists" $ property $
      \xs -> not (null (xs :: [Int])) ==> mhead1 xs == head xs

  describe "mhead2 (index operator)" $ do
    it "returns first element of [1,2,3]" $
      mhead2 [1,2,3] `shouldBe` 1

    it "behaves like head for non-empty lists" $ property $
      \xs -> not (null (xs :: [Int])) ==> mhead2 xs == head xs

  describe "mhead3 (using take)" $ do
    it "returns first element of [1,2,3]" $
      mhead3 [1,2,3] `shouldBe` 1

    it "behaves like head for non-empty lists" $ property $
      \xs -> not (null (xs :: [Int])) ==> mhead3 xs == head xs

  describe "mhead4 (using foldr1)" $ do
    it "returns first element of [1,2,3]" $
      mhead4 [1,2,3] `shouldBe` 1

    it "behaves like head for non-empty lists" $ property $
      \xs -> not (null (xs :: [Int])) ==> mhead4 xs == head xs

  -- Add tests for your bonus implementations here!
  -- describe "mhead5 (your method)" $ do
  --   it "behaves like head" $ property $
  --     \xs -> not (null (xs :: [Int])) ==> mhead5 xs == head xs
