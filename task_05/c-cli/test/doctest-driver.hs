module Main where

import Test.DocTest

main :: IO ()
main = doctest ["src/Student.hs", "src/Operations.hs", "src/Parsing.hs"]
