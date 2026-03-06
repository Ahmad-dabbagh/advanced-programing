-- src/Logic.hs
module Logic where

import System.Random (StdGen, randomR)
import Types

-- move one step based on direction
stepPos :: Dir -> Pos -> Pos
stepPos U (x,y) = (x, y+1)
stepPos D (x,y) = (x, y-1)
stepPos L (x,y) = (x-1, y)
stepPos R (x,y) = (x+1, y)

-- wrapping world
wrap :: (Int,Int) -> Pos -> Pos
wrap (w,h) (x,y) = (x `mod` w, y `mod` h)

-- compute next head position with wrapping
nextHead :: (Int,Int) -> Snake -> Pos
nextHead gr s = wrap gr (stepPos (dir s) (head (body s)))

-- move snake (grow if True)
moveSnake :: (Int,Int) -> Bool -> Snake -> Snake
moveSnake gr grow s =
  let newH = nextHead gr s
      newB = if grow then newH : body s else newH : init (body s)
  in s { body = newB }

-- collision checks
selfCollision :: Snake -> Bool
selfCollision s =
  case body s of
    []     -> False
    h:rest -> h `elem` rest

hitsOther :: Snake -> Snake -> Bool
hitsOther a b =
  case body a of
    []    -> False
    h:_   -> h `elem` body b

-- food
eatsFood :: Pos -> Snake -> Bool
eatsFood f s =
  case body s of
    []   -> False
    h:_  -> h == f

stepOne :: (Int,Int) -> Pos -> Snake -> (Snake, Bool)
stepOne gr f s =
  let ate = eatsFood f s
      s'  = moveSnake gr ate s
  in (s', ate)

stepTwo :: (Int,Int) -> Pos -> Snake -> Snake -> ((Snake, Snake), (Bool, Bool))
stepTwo gr f s1 s2 =
  let ate1 = eatsFood f s1
      ate2 = eatsFood f s2
      s1'  = moveSnake gr ate1 s1
      s2'  = moveSnake gr ate2 s2
  in ((s1', s2'), (ate1, ate2))

isDeadAgainst :: Snake -> Snake -> Bool
isDeadAgainst me other = selfCollision me || hitsOther me other

allOccupied :: [Snake] -> [Pos]
allOccupied ss = concatMap body ss

spawnFood :: (Int,Int) -> [Snake] -> StdGen -> (Pos, StdGen)
spawnFood (w,h) ss gen =
  let occ = allOccupied ss
      (x, g1) = randomR (0, w-1) gen
      (y, g2) = randomR (0, h-1) g1
      p = (x,y)
  in if p `elem` occ then spawnFood (w,h) ss g2 else (p, g2)

-- game step
stepGame :: Game -> Game
stepGame g
  | screen g == GameOver = g
  | otherwise =
      case snakes g of
        [s1]      -> stepSingle g s1
        [s1, s2]  -> stepMulti g s1 s2
        _         -> g

stepSingle :: Game -> Snake -> Game
stepSingle g s1 =
  let (s1', ate) = stepOne (grid g) (food g) s1
      dead       = selfCollision s1'
      newScore   = score s1 + if ate then 1 else 0
      s1''       = s1' { alive = not dead, score = newScore }

      (newFood, gen') =
        if ate then spawnFood (grid g) [s1''] (rng g) else (food g, rng g)

      newScreen = if dead then GameOver else Running
  in g { snakes = [s1''], food = newFood, rng = gen', screen = newScreen }

stepMulti :: Game -> Snake -> Snake -> Game
stepMulti g s1 s2 =
  let ((s1', s2'), (ate1, ate2)) = stepTwo (grid g) (food g) s1 s2

      dead1 = isDeadAgainst s1' s2'
      dead2 = isDeadAgainst s2' s1'

      s1'' = s1' { alive = not dead1, score = score s1 + if ate1 then 1 else 0 }
      s2'' = s2' { alive = not dead2, score = score s2 + if ate2 then 1 else 0 }

      (newFood, gen') =
        if ate1 || ate2
        then spawnFood (grid g) [s1'', s2''] (rng g)
        else (food g, rng g)

      newScreen = if dead1 || dead2 then GameOver else Running
  in g { snakes = [s1'', s2''], food = newFood, rng = gen', screen = newScreen }

-- initial snakes + reset
initialSnake1 :: Snake
initialSnake1 =
  Snake { body = [(10,10),(9,10),(8,10)], dir = R, alive = True, score = 0 }

initialSnake2 :: Snake
initialSnake2 =
  Snake { body = [(30,30),(31,30),(32,30)], dir = L, alive = True, score = 0 }

resetGame :: Bool -> Game -> Game
resetGame twoPlayers g =
  let ss = if twoPlayers then [initialSnake1, initialSnake2] else [initialSnake1]
      (f, gen') = spawnFood (grid g) ss (rng g)
  in g { snakes = ss, food = f, rng = gen', screen = Running }
tick :: Float -> Game -> Game
tick dt g
  | screen g == GameOver = g
  | otherwise =
      let a = accum g + dt
      in if a >= tickLen g
         then tick (a - tickLen g) (stepGame (g { accum = 0 }))
         else g { accum = a }
