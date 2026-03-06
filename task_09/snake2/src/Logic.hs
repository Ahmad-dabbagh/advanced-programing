module Logic where

import Data.Maybe (fromJust)
import qualified Data.Set as Set
import System.Random (StdGen, randomR)

import Types

snakeBody :: Snake -> [Coord]
snakeBody (Snake b _ _) = b

snakeDir :: Snake -> Direction
snakeDir (Snake _ d _) = d

snakeScore :: Snake -> Int
snakeScore (Snake _ _ s) = s

getHead :: Snake -> Coord
getHead (Snake body _ _) = head body

moveSnake :: Snake -> Bool -> Snake
moveSnake (Snake body dir score) grew =
  let (cx, cy) = head body
      (nx, ny) = case dir of
                   DUp    -> (cx,     cy - 1)
                   DDown  -> (cx,     cy + 1)
                   DLeft  -> (cx - 1, cy    )
                   DRight -> (cx + 1, cy    )
      newHead = (nx `mod` 40, ny `mod` 40)
      newBody = if grew
                  then newHead : body
                  else newHead : init body
  in Snake newBody dir score

spawnFood :: Set.Set Coord -> StdGen -> (Coord, StdGen)
spawnFood occ rng =
  let allCells   = [(x, y) | x <- [0..39], y <- [0..39]]
      free        = filter (\c -> not (Set.member c occ)) allCells
      (idx, rng') = randomR (0, length free - 1) rng
  in (free !! idx, rng')

spawnFoodN :: Int -> Set.Set Coord -> StdGen -> [Coord] -> ([Coord], StdGen)
spawnFoodN 0 _   rng acc = (acc, rng)
spawnFoodN n occ rng acc =
  let (c, rng') = spawnFood occ rng
  in spawnFoodN (n - 1) (Set.insert c occ) rng' (c : acc)

selfColl :: Snake -> Bool
selfColl (Snake body _ _) =
  let h    = head body
      rest = tail body
  in h `elem` rest

headInBody :: Snake -> Snake -> Bool
headInBody a b = head (snakeBody a) `elem` snakeBody b

initSnake1 :: Snake
initSnake1 = Snake [(12, 20), (11, 20), (10, 20)] DRight 0

initSnake2 :: Snake
initSnake2 = Snake [(27, 20), (28, 20), (29, 20)] DLeft 0

initialState :: GameMode -> Int -> StdGen -> GameState
initialState m hs rng0 =
  let s1  = initSnake1
      ms2 = if m == TwoPlayer then Just initSnake2 else Nothing
      occ = Set.fromList (snakeBody s1)
            `Set.union`
            if m == TwoPlayer
              then Set.fromList (snakeBody (fromJust ms2))
              else Set.empty
      (f, r1) = spawnFoodN 3 occ rng0 []
  in GameState Playing m s1 ms2 f r1 hs Nothing

stepGame :: GameState -> GameState
stepGame gs
  | phase gs /= Playing = gs
  | otherwise =
      let s1  = snake1 gs
          ms2 = snake2 gs
          f0  = food gs
          r0  = rng gs

          moved1 = moveSnake s1 False
          h1     = getHead moved1
          occ1   = Set.fromList (snakeBody s1)

          (f1, grew1, r1) =
            if h1 `elem` f0
              then let f'       = filter (/= h1) f0
                       occ'     = Set.insert h1 occ1
                       (nf, r') = spawnFood occ' r0
                   in (nf : f', True, r')
              else (f0, False, r0)

          s1' = if grew1 then moveSnake s1 True else moved1
          s1'' = case s1' of
                   Snake b d sc -> if grew1 then Snake b d (sc + 1) else s1'

          (ms2', f2, r2) = case ms2 of
            Nothing -> (Nothing, f1, r1)
            Just s2 ->
              let moved2 = moveSnake s2 False
                  h2     = getHead moved2
                  occ2   = Set.fromList (snakeBody s1'')
                  (f2', grew2, r2') =
                    if h2 `elem` f1
                      then let f'       = filter (/= h2) f1
                               occ'     = Set.insert h2 occ2
                               (nf, r') = spawnFood occ' r1
                           in (nf : f', True, r')
                      else (f1, False, r1)
                  s2' = if grew2 then moveSnake s2 True else moved2
                  s2'' = case s2' of
                           Snake b d sc -> if grew2 then Snake b d (sc + 1) else s2'
              in (Just s2'', f2', r2')

          gs' = gs { snake1 = s1'', snake2 = ms2', food = f2, rng = r2 }

          dead1 = selfColl s1''
                  || case ms2' of { Nothing -> False; Just s2 -> headInBody s1'' s2 }
          dead2 = case ms2' of
                    Nothing -> False
                    Just s2 -> selfColl s2 || headInBody s2 s1''

          newHi = if snakeScore s1'' > hiScore gs'
                    then snakeScore s1''
                    else hiScore gs'

      in if not dead1 && not dead2
           then gs' { hiScore = newHi }
           else if dead1 && dead2
             then gs' { phase = GameOver, winner = Just 0, hiScore = newHi }
             else if dead1
               then gs' { phase = GameOver, winner = Just 2, hiScore = newHi }
               else gs' { phase = GameOver, winner = Just 1, hiScore = newHi }
