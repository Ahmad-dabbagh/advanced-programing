module Types where

import System.Random (StdGen)

type Coord = (Int, Int)

data Direction = DUp | DDown | DLeft | DRight deriving (Eq, Show)

data GameMode  = SinglePlayer | TwoPlayer      deriving (Eq, Show)

data GamePhase = Menu | Playing | GameOver     deriving (Eq, Show)

data Snake = Snake [Coord] Direction Int

data GameState = GameState
  { phase   :: GamePhase
  , mode    :: GameMode
  , snake1  :: Snake
  , snake2  :: Maybe Snake
  , food    :: [Coord]
  , rng     :: StdGen
  , hiScore :: Int
  , winner  :: Maybe Int
  }

data Name = GameViewport deriving (Eq, Ord, Show)
data Tick = Tick
