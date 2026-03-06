module Game.Types where

import Data.Map (Map)

data Color = Red | Blue | Green | Yellow
  deriving (Show, Eq, Ord, Enum, Bounded)

data Card = Card
  { cardColor :: Color
  , cardValue :: Int
  } deriving (Show, Eq)

type PlayerId = Int

data PlayerType = Human | Bot
  deriving (Show, Eq)

data Difficulty = Easy | Medium
  deriving (Show, Eq)

type Pos = (Int, Int)

-- | A stack of cards at a position. The head is the top-most card.
type Stack = [Card]

-- | Board as a mapping from (Int, Int) to a stack of cards.
-- This fulfills the grid requirement while allowing for dynamic boundaries.
type Board = Map Pos Stack

data GamePhase = Drawing | Placing | RoundEnded | GameEnded
  deriving (Show, Eq)

data Player = Player
  { playerId     :: PlayerId
  , playerColors :: [Color]
  , playerDeck   :: [Card]
  , playerType   :: PlayerType
  , difficulty   :: Maybe Difficulty
  , roundsWon    :: Int
  } deriving (Show, Eq)

data GameState = GameState
  { board              :: Board
  , players            :: [Player]
  , currentPlayerIdx   :: Int
  , currentCard        :: Maybe Card
  , phase              :: GamePhase
  , winner             :: Maybe PlayerId
  , numPlayers         :: Int
  } deriving (Show, Eq)
