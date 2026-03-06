module Game.Board where

import Data.Map (Map)
import qualified Data.Map as Map
import Game.Types

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

-- | Get the top card at a position.
topCard :: Board -> Pos -> Maybe Card
topCard b p = Map.lookup p b >>= \s -> if null s then Nothing else Just (head s)

-- | Place a card on the board.
placeCard :: Board -> Pos -> Card -> Board
placeCard b pos card =
  Map.insertWith (++) pos [card] b

-- | Get all 8 adjacent positions (horizontal, vertical, diagonal).
--
-- >>> adjacentPositions (0,0)
-- [(-1,-1),(-1,0),(-1,1),(0,-1),(0,1),(1,-1),(1,0),(1,1)]
adjacentPositions :: Pos -> [Pos]
adjacentPositions (x, y) =
  [ (x + dx, y + dy)
  | dx <- [-1 .. 1]
  , dy <- [-1 .. 1]
  , not (dx == 0 && dy == 0)
  ]
