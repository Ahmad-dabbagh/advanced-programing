-- src/Types.hs
module Types where

import System.Random (StdGen)

type Pos = (Int, Int)

data Dir = U | D | L | R
  deriving (Eq, Show)

data Screen = Running | GameOver
  deriving (Eq, Show)

data Snake = Snake
  { body  :: [Pos]
  , dir   :: Dir
  , alive :: Bool
  , score :: Int
  }
  deriving (Show)

data Game = Game
  { snakes  :: [Snake]
  , food    :: Pos
  , grid    :: (Int, Int)
  , rng     :: StdGen
  , screen  :: Screen
  , accum   :: Float
  , tickLen :: Float
  }
  deriving (Show)
