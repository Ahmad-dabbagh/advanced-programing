-- | Pure game logic for the Snake game.
--
-- All functions in this module are pure; randomness is threaded explicitly
-- via 'StdGen' so every function is deterministic and easily testable.
module Logic
  ( -- * Initial state
    initialState
  , initSnake1
  , initSnake2
    -- * Coordinate helpers
  , wrapCoord
  , nextHead
  , snakeHead
    -- * Snake movement
  , advanceSnake
  , dropLast
    -- * Collision detection
  , selfCollision
  , snakeCollision
    -- * Occupied-cell tracking
  , occupiedCells
    -- * Direction helpers
  , oppositeDir
    -- * Game step
  , stepGame
  , stepSnake
  , checkGameOver
  ) where

import Data.Maybe (listToMaybe)
import Data.Set (Set)
import qualified Data.Set as Set
import System.Random (StdGen, randomR)

import Types

-- ---------------------------------------------------------------------------
-- Initial state
-- ---------------------------------------------------------------------------

-- | Starting snake for player 1 (left-centre of grid, heading right).
--
-- >>> length (snakeBody initSnake1)
-- 3
-- >>> snakeDir initSnake1
-- DRight
-- >>> snakeScore initSnake1
-- 0
initSnake1 :: Snake
initSnake1 = Snake
  { snakeBody  = [(12, 20), (11, 20), (10, 20)]
  , snakeDir   = DRight
  , snakeScore = 0
  }

-- | Starting snake for player 2 (right-centre of grid, heading left).
--
-- >>> length (snakeBody initSnake2)
-- 3
-- >>> snakeDir initSnake2
-- DLeft
-- >>> snakeScore initSnake2
-- 0
initSnake2 :: Snake
initSnake2 = Snake
  { snakeBody  = [(27, 20), (28, 20), (29, 20)]
  , snakeDir   = DLeft
  , snakeScore = 0
  }

-- | Build a fresh 'GameState' ready to play.
-- The high score from the previous game is carried over via 'hs'.
--
-- >>> import System.Random (mkStdGen)
-- >>> let gs = initialState SinglePlayer 0 (mkStdGen 42)
-- >>> gsPhase gs
-- Playing
-- >>> length (gsFood gs)
-- 3
-- >>> gsSnake2 gs
-- Nothing
-- >>> let gs2 = initialState TwoPlayer 5 (mkStdGen 42)
-- >>> gsMode gs2
-- TwoPlayer
-- >>> gsHighScore gs2
-- 5
initialState :: GameMode -> Int -> StdGen -> GameState
initialState mode hs rng0 =
  let s1   = initSnake1
      ms2  = case mode of
               TwoPlayer    -> Just initSnake2
               SinglePlayer -> Nothing
      -- Seed the occupied set with all snake body cells before placing food.
      occ0 = bodySet s1 `Set.union` maybe Set.empty bodySet ms2
      (food, rng1) = spawnNFood foodCount occ0 rng0 []
  in GameState
      { gsPhase     = Playing
      , gsMode      = mode
      , gsSnake1    = s1
      , gsSnake2    = ms2
      , gsFood      = food
      , gsRng       = rng1
      , gsHighScore = hs
      , gsWinner    = Nothing
      }

-- ---------------------------------------------------------------------------
-- Coordinate helpers
-- ---------------------------------------------------------------------------

-- | Wrap a coordinate into [0, size).
-- Uses 'mod', which always returns a non-negative result for a positive
-- divisor — so stepping off the left or top edge wraps correctly.
--
-- >>> wrapCoord 40 40
-- 0
-- >>> wrapCoord (-1) 40
-- 39
-- >>> wrapCoord 39 40
-- 39
-- >>> wrapCoord 0 40
-- 0
wrapCoord :: Int -> Int -> Int
wrapCoord val size = val `mod` size

-- | Compute the cell a snake's head will move into on the next step.
-- The grid wraps toroidally on all four edges.
--
-- >>> nextHead (Snake [(5,5),(4,5),(3,5)] DRight 0) 40 40
-- (6,5)
-- >>> nextHead (Snake [(0,5),(1,5),(2,5)] DLeft 0) 40 40
-- (39,5)
-- >>> nextHead (Snake [(5,0),(5,1),(5,2)] DUp 0) 40 40
-- (5,39)
-- >>> nextHead (Snake [(5,39),(5,38),(5,37)] DDown 0) 40 40
-- (5,0)
nextHead :: Snake -> Int -> Int -> Coord
nextHead snake w h =
  let (cx, cy) = case snakeBody snake of
                   (c : _) -> c
                   []      -> (0, 0) -- unreachable: snakes always have >= 3 segments
      (nx, ny) = case snakeDir snake of
                   DUp    -> (cx,     cy - 1)
                   DDown  -> (cx,     cy + 1)
                   DLeft  -> (cx - 1, cy    )
                   DRight -> (cx + 1, cy    )
  in (wrapCoord nx w, wrapCoord ny h)

-- | Return the head cell of a snake, or 'Nothing' if the body is empty.
-- In a live game the body is never empty, but returning 'Nothing' keeps
-- this function total and safely testable.
--
-- >>> snakeHead (Snake [(5,5),(4,5),(3,5)] DRight 0)
-- Just (5,5)
-- >>> snakeHead (Snake [] DRight 0)
-- Nothing
snakeHead :: Snake -> Maybe Coord
snakeHead = listToMaybe . snakeBody

-- ---------------------------------------------------------------------------
-- Direction helpers
-- ---------------------------------------------------------------------------

-- | The direction directly opposite to the given one.
--
-- >>> oppositeDir DUp
-- DDown
-- >>> oppositeDir DDown
-- DUp
-- >>> oppositeDir DLeft
-- DRight
-- >>> oppositeDir DRight
-- DLeft
oppositeDir :: Direction -> Direction
oppositeDir DUp    = DDown
oppositeDir DDown  = DUp
oppositeDir DLeft  = DRight
oppositeDir DRight = DLeft

-- ---------------------------------------------------------------------------
-- Snake movement
-- ---------------------------------------------------------------------------

-- | Drop the last element of a list.  Returns the empty list unchanged.
-- Used to remove the tail cell on a non-growing tick.
--
-- >>> dropLast [1, 2, 3 :: Int]
-- [1,2]
-- >>> dropLast [1 :: Int]
-- []
-- >>> dropLast ([] :: [Int])
-- []
-- >>> length (dropLast [1..10 :: Int])
-- 9
dropLast :: [a] -> [a]
dropLast []     = []
dropLast [_]    = []
dropLast (x:xs) = x : dropLast xs

-- | Advance a snake one step.
-- When 'grow' is 'True' the tail segment is kept and the snake grows by
-- one cell; otherwise the tail is dropped, maintaining the same length.
--
-- >>> let s = Snake [(5,5),(4,5),(3,5)] DRight 0
-- >>> snakeBody (advanceSnake 40 40 s False)
-- [(6,5),(5,5),(4,5)]
-- >>> snakeBody (advanceSnake 40 40 s True)
-- [(6,5),(5,5),(4,5),(3,5)]
-- >>> length (snakeBody (advanceSnake 40 40 s False))
-- 3
-- >>> length (snakeBody (advanceSnake 40 40 s True))
-- 4
advanceSnake :: Int -> Int -> Snake -> Bool -> Snake
advanceSnake w h snake grow =
  let newHead = nextHead snake w h
      newBody = newHead : if grow
                            then snakeBody snake
                            else dropLast (snakeBody snake)
  in snake { snakeBody = newBody }

-- ---------------------------------------------------------------------------
-- Collision detection
-- ---------------------------------------------------------------------------

-- | 'True' if the snake's head overlaps any other segment of its own body.
-- This is the self-collision (death) condition.
--
-- >>> selfCollision (Snake [(5,5),(5,5),(6,5)] DRight 0)
-- True
-- >>> selfCollision (Snake [(5,5),(4,5),(3,5)] DRight 0)
-- False
-- >>> selfCollision (Snake [(5,5)] DRight 0)
-- False
-- >>> selfCollision (Snake [] DRight 0)
-- False
selfCollision :: Snake -> Bool
selfCollision snake =
  case snakeBody snake of
    []       -> False
    (h:rest) -> h `elem` rest

-- | 'True' if the head of snake 'a' lands on any cell of snake 'b'.
-- Used to detect one snake running into another.
--
-- >>> snakeCollision (Snake [(5,5),(4,5)] DRight 0) (Snake [(5,5),(5,6)] DDown 0)
-- True
-- >>> snakeCollision (Snake [(4,5),(3,5)] DRight 0) (Snake [(5,5),(4,5),(3,5)] DDown 0)
-- True
-- >>> snakeCollision (Snake [(5,5),(4,5)] DRight 0) (Snake [(9,9),(9,8)] DDown 0)
-- False
-- >>> snakeCollision (Snake [] DRight 0) (Snake [(5,5),(4,5)] DDown 0)
-- False
snakeCollision :: Snake -> Snake -> Bool
snakeCollision a b =
  case snakeHead a of
    Nothing -> False
    Just h  -> h `elem` snakeBody b

-- ---------------------------------------------------------------------------
-- Occupied-cell tracking
-- ---------------------------------------------------------------------------

-- | All cells occupied by a snake's body as a 'Set'.
bodySet :: Snake -> Set Coord
bodySet = Set.fromList . snakeBody

-- | All cells currently occupied by all snakes.
-- Used to prevent food from spawning inside a snake.
--
-- >>> import System.Random (mkStdGen)
-- >>> let gs = initialState SinglePlayer 0 (mkStdGen 42)
-- >>> Set.size (occupiedCells gs) == length (snakeBody (gsSnake1 gs))
-- True
occupiedCells :: GameState -> Set Coord
occupiedCells gs =
  bodySet (gsSnake1 gs)
  `Set.union`
  maybe Set.empty bodySet (gsSnake2 gs)

-- ---------------------------------------------------------------------------
-- Food spawning
-- ---------------------------------------------------------------------------

-- | Pick a random unoccupied cell to place a new food item.
-- Returns the original 'StdGen' unchanged if the board is completely full
-- (unreachable in a normal 40x40 game, but handled for totality).
spawnFood :: Set Coord -> StdGen -> (Coord, StdGen)
spawnFood occ rng =
  let free = filter (`Set.notMember` occ) allCells
  in case free of
       [] -> ((0, 0), rng)  -- board full — unreachable in practice
       _  -> let (idx, rng') = randomR (0, length free - 1) rng
             in (free !! idx, rng')
  where
    allCells = [(x, y) | x <- [0 .. gridW - 1], y <- [0 .. gridH - 1]]

-- | Spawn exactly 'n' food items, accumulating results into 'acc'.
-- Each spawned cell is immediately added to 'occ' so two items never
-- share the same position.
spawnNFood :: Int -> Set Coord -> StdGen -> [Coord] -> ([Coord], StdGen)
spawnNFood 0 _   rng acc = (acc, rng)
spawnNFood n occ rng acc =
  let (c, rng') = spawnFood occ rng
  in spawnNFood (n - 1) (Set.insert c occ) rng' (c : acc)

-- ---------------------------------------------------------------------------
-- Per-snake step
-- ---------------------------------------------------------------------------

-- | Advance one snake by a single tick: move it, eat food if the head
-- lands on a food cell, grow if food was eaten, and increment the score.
-- Returns the updated snake, updated food list, and updated 'StdGen'.
--
-- The 'occ' set should contain every cell that must not receive new food
-- (i.e. both snake bodies plus all surviving food items).
--
-- >>> import System.Random (mkStdGen)
-- >>> let s  = Snake [(5,5),(4,5),(3,5)] DRight 0
-- >>> let (s', _, _) = stepSnake 40 40 s [] Set.empty (mkStdGen 0)
-- >>> snakeBody s'
-- [(6,5),(5,5),(4,5)]
-- >>> snakeScore s'
-- 0
stepSnake :: Int -> Int -> Snake -> [Coord] -> Set Coord -> StdGen
          -> (Snake, [Coord], StdGen)
stepSnake w h snake food occ rng =
  let newHead           = nextHead snake w h
      (food', ate, rng') = eatFood newHead food occ rng
      snake'            = advanceSnake w h snake ate
      snake''           = if ate
                            then snake' { snakeScore = snakeScore snake' + 1 }
                            else snake'
  in (snake'', food', rng')

-- | Attempt to eat food at position 'hd'.
-- If 'hd' is in the food list, removes it, spawns a replacement, and
-- signals growth.  Otherwise the food list and 'StdGen' are unchanged.
eatFood :: Coord -> [Coord] -> Set Coord -> StdGen -> ([Coord], Bool, StdGen)
eatFood hd food occ rng =
  if hd `elem` food
    then
      let food'        = filter (/= hd) food
          occ'         = Set.insert hd occ  -- eaten cell is now occupied by head
          (newF, rng') = spawnFood occ' rng
      in (newF : food', True, rng')
    else (food, False, rng)

-- ---------------------------------------------------------------------------
-- Game-over adjudication
-- ---------------------------------------------------------------------------

-- | Determine whether either (or both) snakes died and update the game
-- phase accordingly.  Also keeps 'gsHighScore' up to date.
--
-- >>> import System.Random (mkStdGen)
-- >>> let gs = initialState SinglePlayer 0 (mkStdGen 42)
-- >>> gsPhase (checkGameOver True False 10 gs)
-- GameOver
-- >>> gsPhase (checkGameOver False False 10 gs)
-- Playing
-- >>> gsHighScore (checkGameOver False False 10 gs)
-- 10
-- >>> gsWinner (checkGameOver True False 0 (initialState TwoPlayer 0 (mkStdGen 0)))
-- Just P2Wins
-- >>> gsWinner (checkGameOver True True 0 (initialState TwoPlayer 0 (mkStdGen 0)))
-- Just Draw
checkGameOver :: Bool -> Bool -> Int -> GameState -> GameState
checkGameOver dead1 dead2 newHigh gs =
  let gs' = gs { gsHighScore = newHigh }
  in case gsMode gs of
       SinglePlayer ->
         if dead1
           then gs' { gsPhase = GameOver, gsWinner = Nothing }
           else gs'
       TwoPlayer ->
         case (dead1, dead2) of
           (False, False) -> gs'
           (True,  True)  -> gs' { gsPhase = GameOver, gsWinner = Just Draw }
           (True,  False) -> gs' { gsPhase = GameOver, gsWinner = Just P2Wins }
           (False, True)  -> gs' { gsPhase = GameOver, gsWinner = Just P1Wins }

-- ---------------------------------------------------------------------------
-- Main game step
-- ---------------------------------------------------------------------------

-- | Advance the entire game by one tick.
-- This is the top-level pure step: move both snakes, handle food, check
-- collisions, and transition to 'GameOver' if necessary.
-- Returns the input state unchanged when not in 'Playing' phase.
stepGame :: GameState -> GameState
stepGame gs
  | gsPhase gs /= Playing = gs
  | otherwise =
      let s1   = gsSnake1 gs
          ms2  = gsSnake2 gs
          food = gsFood gs
          rng  = gsRng gs
          -- Full occupied set: both snake bodies + all food items.
          -- Used so that replacement food never appears inside a snake or
          -- on top of an existing food item.
          occ  = occupiedCells gs `Set.union` Set.fromList food

          -- Advance snake 1.
          (s1', food1, rng1) = stepSnake gridW gridH s1 food occ rng

          -- Advance snake 2 (if present).
          -- Update occ2 to include s1's new position and the updated food
          -- list so snake 2's replacement food is placed correctly.
          occ2 = bodySet s1' `Set.union` Set.fromList food1
          (ms2', food2, rng2) = case ms2 of
            Nothing -> (Nothing, food1, rng1)
            Just s2 ->
              let (s2', food2', rng2') = stepSnake gridW gridH s2 food1 occ2 rng1
              in (Just s2', food2', rng2')

          gs' = gs { gsSnake1 = s1', gsSnake2 = ms2', gsFood = food2, gsRng = rng2 }

          -- Collision detection runs after movement so both snakes have
          -- their final positions for this tick.
          dead1 = selfCollision s1'
                  || maybe False (snakeCollision s1') ms2'
          dead2 = case ms2' of
            Nothing -> False
            Just s2 -> selfCollision s2 || snakeCollision s2 s1'

          newHigh = max (gsHighScore gs) (snakeScore s1')

      in checkGameOver dead1 dead2 newHigh gs'
