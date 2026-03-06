module Lib
    ( decodeMessage
    , decodeMessageImproved
    ) where

import Data.List (minimum, maximum)
import Text.Read (readMaybe)

-- Helpers (pure building blocks)

splitWords :: String -> [String]
splitWords = words

parseInts :: String -> Maybe [Int]
parseInts s =
  case traverse readMaybe (splitWords s) of
    Nothing -> Nothing
    Just xs ->
      if null xs then Nothing else Just xs

countOf :: Eq a => a -> [a] -> Int
countOf x = length . filter (== x)

uniqueMinMax :: [Int] -> Maybe (Int, Int)
uniqueMinMax xs =
  let mn = minimum xs
      mx = maximum xs
  in if countOf mn xs == 1 && countOf mx xs == 1
        then Just (mn, mx)
        else Nothing

midPointMaybe :: (Int, Int) -> Maybe Int
midPointMaybe (mn, mx) =
  let s = mn + mx
  in if even s then Just (s `div` 2) else Nothing

messageCount :: Int -> [Int] -> Int
messageCount mid xs = countOf mid xs

-- | Decode an intergalactic message from a string.
-- The message is a sequence of integers separated by spaces.
--
-- >>> decodeMessage "5 5 5 8 1 2 3 4 9 8 2 3 4 1"
-- Nothing
--
-- >>> decodeMessage "5 5 5 8 1 2 3 4 9 8 2 3 4 9"
-- Nothing
--
-- >>> decodeMessage "5 5 5 8 1 2 3 4 9 8 2 3 4 8"
-- Just 3
--
-- >>> decodeMessage "5 5 5 1 2 3 4 8 2 3"
-- Nothing
decodeMessage :: String -> Maybe Int
decodeMessage msg =
  parseInts msg >>= \xs ->
    uniqueMinMax xs >>= \pair ->
      midPointMaybe pair >>= \mid ->
        Just (messageCount mid xs)

-- ===== Either improved =====

parseIntsE :: String -> Either String [Int]
parseIntsE s =
  case traverse readMaybe (splitWords s) of
    Nothing -> Left "Communication interference detected: invalid integer"
    Just xs ->
      if null xs
         then Left "Communication interference detected: empty transmission"
         else Right xs

uniqueMinMaxE :: [Int] -> Either String (Int, Int)
uniqueMinMaxE xs =
  let mn = minimum xs
      mx = maximum xs
      mnOk = countOf mn xs == 1
      mxOk = countOf mx xs == 1
  in case (mnOk, mxOk) of
       (False, _) -> Left "Communication interference detected: minimum number not Unique"
       (True, False) -> Left "Communication interference detected: maximum number not Unique"
       (True, True) -> Right (mn, mx)

midPointE :: (Int, Int) -> Either String Int
midPointE (mn, mx) =
  let s = mn + mx
  in if even s
        then Right (s `div` 2)
        else Left "Communication interference detected: midPoint not even"

-- | Decode an intergalactic message from a string.
-- The message is a sequence of integers separated by spaces.
-- This is an improved version of the previous function, with a more
-- informative error messages.
--
-- >>> decodeMessage Improved "5 5 5 8 1 2 3 4 9 8 2 3 4 1"
-- Left "Communication interference detected: minimum number not Unique"
--
-- >>> decodeMessageeImproved "5 5 5 8 1 2 3 4 9 8 2 3 4 9"
-- Left "Communication interference detected: maximum number not Unique"
--
-- >>> decodeMessageImproved "5 5 5 8 1 2 3 4 9 8 2 3 4 8"
-- Right 3
--
-- >>> decodeMessageImproved "5 5 5 1 2 3 4 8 2 3"
-- Left "Communication interference detected: midPoint not even"
decodeMessageImproved :: String -> Either String Int
decodeMessageImproved msg =
  parseIntsE msg >>= \xs ->
    uniqueMinMaxE xs >>= \pair ->
      midPointE pair >>= \mid ->
        Right (messageCount mid xs)

