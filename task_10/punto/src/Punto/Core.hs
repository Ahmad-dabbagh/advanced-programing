module Punto.Core where

import Data.Map (Map)
import qualified Data.Map as Map

data Color = Red | Blue | Green | Yellow
  deriving (Show, Eq, Ord, Enum, Bounded)

data Card = Card
  { cardColor :: Color
  , cardValue :: Int
  } deriving (Show, Eq)

type Pos = (Int, Int)

-- | A stack of cards at a position. The head is the top-most card.
type Stack = [Card]

type Board = Map Pos Stack

data GamePhase = Setup | Drawing | Placing | RoundEnded | GameEnded
  deriving (Show, Eq)

data Player = Player
  { _playerId     :: Int
  , _playerColors :: [Color]
  , _playerDeck   :: [Card]
  , _isBot        :: Bool
  , _roundsWon    :: Int
  } deriving (Show, Eq)

data GameState = GameState
  { _board              :: Board
  , _players            :: [Player]
  , _currentPlayerIdx   :: Int
  , _currentCard        :: Maybe Card
  , _phase              :: GamePhase
  , _winner             :: Maybe Int  -- Player ID who won the round/game
  , _numPlayers         :: Int
  } deriving (Show, Eq)

-- | Target row length to win.
-- 2 players: 5 cards.
-- 3-4 players: 4 cards.
targetLength :: Int -> Int
targetLength n
  | n == 2    = 5
  | otherwise = 4

-- | Get the top card at a position.
topCard :: Board -> Pos -> Maybe Card
topCard b p = Map.lookup p b >>= \s -> if null s then Nothing else Just (head s)
