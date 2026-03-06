module Punto.AI where

import System.Random (RandomGen, randomR)
import Punto.Core
import Punto.Board
import Data.List (maximumBy)
import Data.Ord (comparing)
import qualified Data.Map as Map

-- | Pick a random legal move.
randomBotMove :: (RandomGen g) => Board -> Card -> g -> (Pos, g)
randomBotMove b card g =
  let moves = getLegalMoves b card
      (idx, g') = randomR (0, length moves - 1) g
  in (moves !! idx, g')

-- | Pick a move that results in the longest row for the player.
greedyBotMove :: Board -> Card -> [Color] -> Pos
greedyBotMove b card playerColors =
  let moves = getLegalMoves b card
      score move =
        let b' = placeCard b move card
            maxLen = maximum (0 : [currentMaxRow b' c | c <- playerColors])
        in maxLen
  in maximumBy (comparing score) moves

-- | Helper to find the maximum row length for a color on the board.
currentMaxRow :: Board -> Color -> Int
currentMaxRow b c =
  let keys = Map.keys b
  in if null keys then 0
     else maximum (0 : [maxRowAt b (x, y) c | (x, y) <- keys])

maxRowAt :: Board -> Pos -> Color -> Int
maxRowAt b (x, y) c =
  maximum (0 : [rowLengthInDirection b (x, y) (dx, dy) c | (dx, dy) <- [(1,0), (0,1), (1,1), (1,-1)]])

rowLengthInDirection :: Board -> Pos -> (Int, Int) -> Color -> Int
rowLengthInDirection b (sx, sy) (dx, dy) c =
  let positions = [(sx + dx*i, sy + dy*i) | i <- [0 .. 5]] -- Max 6x6
      matches p = case topCard b p of
                    Just card -> cardColor card == c
                    Nothing -> False
      row = takeWhile matches positions
  in length row
