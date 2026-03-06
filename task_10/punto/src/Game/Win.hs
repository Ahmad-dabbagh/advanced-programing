{-# LANGUAGE LambdaCase #-}
module Game.Win where

import qualified Data.Map as Map
import Game.Types
import Game.Board

-- | Target row length to win.
-- 2 players: 5 cards.
-- 3-4 players: 4 cards.
targetLength :: Int -> Int
targetLength n
  | n == 2    = 5
  | otherwise = 4

-- | Check if a player with given colors has won on the board.
--
-- >>> import qualified Data.Map as Map
-- >>> let b = Map.fromList [((0,0), [Card Red 1]), ((1,0), [Card Red 2]), ((2,0), [Card Red 3]), ((3,0), [Card Red 4])]
-- >>> winCheck 4 [Red] b
-- True
-- >>> winCheck 5 [Red] b
-- False
winCheck :: Int -> [Color] -> Board -> Bool
winCheck target colors b =
  any (winCheckFromPos target colors b) (Map.keys b)

winCheckFromPos :: Int -> [Color] -> Board -> Pos -> Bool
winCheckFromPos target colors b (x, y) =
  any (checkDirection target colors b (x, y)) [(1,0), (0,1), (1,1), (1,-1)]

checkDirection :: Int -> [Color] -> Board -> Pos -> (Int, Int) -> Bool
checkDirection target colors b (sx, sy) (dx, dy) =
  let positions = [(sx + dx*i, sy + dy*i) | i <- [0 .. target - 1]]
      matches p = case topCard b p of
                    Just c -> cardColor c `elem` colors
                    Nothing -> False
  in all matches positions

-- | Calculate tie-breaker score for a player.
-- Returns (count of rows of length target-1, sum of values in those rows).
calculateTieScore :: Int -> [Color] -> Board -> (Int, Int)
calculateTieScore target colors b =
  let rows = getAllRows target colors b
      count = length rows
      totalValue = sum [sum (map cardValue r) | r <- rows]
  in (count, totalValue)

getAllRows :: Int -> [Color] -> Board -> [[Card]]
getAllRows target colors b =
  [ row
  | pos <- Map.keys b
  , dir <- [(1,0), (0,1), (1,1), (1,-1)]
  , let row = getRowAt target colors b pos dir
  , length row == target - 1
  ]

getRowAt :: Int -> [Color] -> Board -> Pos -> (Int, Int) -> [Card]
getRowAt target colors b (sx, sy) (dx, dy) =
  let positions = [(sx + dx*i, sy + dy*i) | i <- [0 .. target - 1]]
      getCard p = case topCard b p of
                    Just c | cardColor c `elem` colors -> Just c
                    _ -> Nothing
      cards = map getCard positions
  in if all (\case Just _ -> True; _ -> False) (take (target - 1) cards)
     then [c | Just c <- take (target - 1) cards]
     else []
