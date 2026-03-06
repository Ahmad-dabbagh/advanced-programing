-- | Doctest runner.
-- Discovers and runs all doctests in the library source modules.
-- Pure functions that can be exercised without a terminal are covered here;
-- IO-heavy modules (Game) are excluded.
module Main (main) where

import Test.DocTest (doctest)

main :: IO ()
main = doctest
  [ "-isrc"
  , "src/Types.hs"
  , "src/Logic.hs"
  , "src/Render.hs"
  ]
