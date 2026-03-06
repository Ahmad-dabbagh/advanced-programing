module Punto.Board where

import Data.Map (Map)
import qualified Data.Map as Map
import Data.Maybe (fromMaybe)
import Punto.Core

-- $setup
-- >>> :set -isrc
-- >>> import qualified Data.Map as Map
-- >>> import Punto.Core

-- | Get the current boundaries of the board (minX, maxX, minY, maxY).
-- Returns Nothing if the board is empty.
getBoundaries :: Board -> Maybe (Int, Int, Int, Int)
getBoundaries b
  | Map.null b = Nothing
  | otherwise =
      let keys = Map.keys b
          xs = map fst keys
          ys = map snd keys
      in Just (minimum xs, maximum xs, minimum ys, maximum ys)

-- | Check if a position is within the potential 6x6 grid.
-- A position is valid if adding it doesn't make the total width or height > 6.
isWithin6x6 :: Board -> Pos -> Bool
isWithin6x6 b (nx, ny) =
  case getBoundaries b of
    Nothing -> True -- First card can be anywhere
    Just (minX, maxX, minY, maxY) ->
      let newMinX = min minX nx
          newMaxX = max maxX nx
          newMinY = min minY ny
          newMaxY = max maxY ny
      in (newMaxX - newMinX < 6) && (newMaxY - newMinY < 6)

-- | Check if a position is adjacent (including diagonals) to any existing card.
isAdjacent :: Board -> Pos -> Bool
isAdjacent b (nx, ny)
  | Map.null b = True -- First card is always "adjacent"
  | otherwise = any (\(x, y) -> abs (x - nx) <= 1 && abs (y - ny) <= 1) (Map.keys b)

-- | Check if a card can be placed at a position.
--
-- >>> let b = Map.fromList [((0,0), [Card Red 5])]
-- >>> isLegalMove b (0,1) (Card Red 3)
-- True
-- >>> isLegalMove b (0,0) (Card Red 3)
-- False
-- >>> isLegalMove b (0,0) (Card Red 7)
-- True
-- >>> isLegalMove b (10,10) (Card Red 7)
-- False
isLegalMove :: Board -> Pos -> Card -> Bool
isLegalMove b pos card =
  let withinGrid = isWithin6x6 b pos
      adjacent = isAdjacent b pos
      higherValue = case topCard b pos of
                      Nothing -> True
                      Just top -> cardValue card > cardValue top
  in withinGrid && adjacent && higherValue

-- | Place a card on the board.
placeCard :: Board -> Pos -> Card -> Board
placeCard b pos card =
  Map.insertWith (++) pos [card] b

-- | Get all possible legal moves for a card on the current board.
getLegalMoves :: Board -> Card -> [Pos]
getLegalMoves b card
  | Map.null b = [(0, 0)]
  | otherwise =
      case getBoundaries b of
        Nothing -> [(0, 0)]
        Just (minX, maxX, minY, maxY) ->
          [ (x, y)
          | x <- [minX - 1 .. maxX + 1]
          , y <- [minY - 1 .. maxY + 1]
          , isLegalMove b (x, y) card
          ]

-- | Check if a player with given colors has won on the board.
--
-- >>> let b = Map.fromList [((0,0), [Card Red 1]), ((1,0), [Card Red 2]), ((2,0), [Card Red 3]), ((3,0), [Card Red 4])]
-- >>> checkWin 4 [Red] b
-- True
-- >>> checkWin 5 [Red] b
-- False
checkWin :: Int -> [Color] -> Board -> Bool
checkWin target colors b =
  any (checkWinFromPos target colors b) (Map.keys b)

checkWinFromPos :: Int -> [Color] -> Board -> Pos -> Bool
checkWinFromPos target colors b (x, y) =
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
  in if all (\c -> case c of Just _ -> True; _ -> False) (take (target - 1) cards)
     then [c | Just c <- take (target - 1) cards]
     else []
