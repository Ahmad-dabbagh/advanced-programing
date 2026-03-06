module Punto.Player where

import System.Random (RandomGen, split)
import System.Random.Shuffle (shuffle')
import Punto.Core

-- | Create a standard deck of 18 cards for a color.
createColorDeck :: Color -> [Card]
createColorDeck c = [Card c v | v <- [1 .. 9], _ <- [1, 2 :: Int]]

-- | Create players for a given number of players.
createPlayers :: Int -> [[Color]] -> [Bool] -> [[Card]] -> [Player]
createPlayers n colors isBots decks =
  [ Player i (colors !! i) (decks !! i) (isBots !! i) 0
  | i <- [0 .. n - 1]
  ]

-- | Initialize the game for N players.
initDeck :: (RandomGen g) => Int -> g -> [Player]
initDeck 2 g =
  let c1 = [Red, Blue]
      c2 = [Green, Yellow]
      d1 = shuffle' (concatMap createColorDeck c1) 36 g
      d2 = shuffle' (concatMap createColorDeck c2) 36 (snd (split g))
  in createPlayers 2 [c1, c2] [False, False] [d1, d2]
initDeck 3 g =
  -- 3 players: 1 color each + 6 from the 4th color
  let extra = createColorDeck Yellow
      (e1, e23) = splitAt 6 (shuffle' extra 18 g)
      (e2, e3) = splitAt 6 e23
      d1 = shuffle' (createColorDeck Red ++ e1) 24 g
      d2 = shuffle' (createColorDeck Blue ++ e2) 24 g
      d3 = shuffle' (createColorDeck Green ++ e3) 24 g
  in createPlayers 3 [[Red], [Blue], [Green]] [False, False, False] [d1, d2, d3]
initDeck 4 g =
  let d1 = shuffle' (createColorDeck Red) 18 g
      d2 = shuffle' (createColorDeck Blue) 18 (snd (split g))
      d3 = shuffle' (createColorDeck Green) 18 (snd (split (snd (split g))))
      d4 = shuffle' (createColorDeck Yellow) 18 (snd (split (snd (split (snd (split g))))))
  in createPlayers 4 [[Red], [Blue], [Green], [Yellow]] [False, False, False, False] [d1, d2, d3, d4]
initDeck _ _ = []
