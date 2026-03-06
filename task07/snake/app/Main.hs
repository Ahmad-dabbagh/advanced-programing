-- app/Main.hs
module Main where

import Graphics.Gloss
import Graphics.Gloss.Interface.Pure.Game (play)
import System.Random (getStdGen, StdGen)

import Types
import Logic
import Render
import Input

main :: IO ()
main = do
  gen <- getStdGen
  let g0 = initialGame gen
  play
    (InWindow "Snake" (800,800) (100,100))
    black
    60
    g0
    renderGame
    handleInput
    step

initialGame :: StdGen -> Game
initialGame gen =
  let gridSize = (40,40)
      s1 = initialSnake1
      (f, gen') = spawnFood gridSize [s1] gen
  in Game
      { snakes  = [s1]
      , food    = f
      , grid    = gridSize
      , rng     = gen'
      , screen  = Running
      , accum   = 0
      , tickLen = 0.12
      }

-- temporary: moves every frame (fast). We'll add proper timed ticks later.
step :: Float -> Game -> Game
step dt g = tick dt g
