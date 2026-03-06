-- | Core data types and constants for the Snake game.
module Types
  ( Coord
  , Direction (..)
  , GameMode (..)
  , GamePhase (..)
  , Winner (..)
  , Snake (..)
  , GameState (..)
  , Name (..)
  , Tick (..)
  , gridW
  , gridH
  , foodCount
  , tickIntervalUs
  ) where

import System.Random (StdGen)

-- ---------------------------------------------------------------------------
-- Type aliases
-- ---------------------------------------------------------------------------

-- | A position on the grid as (column, row), both 0-indexed.
type Coord = (Int, Int)

-- ---------------------------------------------------------------------------
-- Enumerations
-- ---------------------------------------------------------------------------

-- | The four cardinal movement directions.
data Direction = DUp | DDown | DLeft | DRight
  deriving (Eq, Show)

-- | Whether the current game is single- or two-player.
data GameMode = SinglePlayer | TwoPlayer
  deriving (Eq, Show)

-- | The current phase of the application.
data GamePhase
  = Menu      -- ^ Start screen; waiting for the player to choose a mode.
  | Playing   -- ^ Active game; ticks and input are processed.
  | GameOver  -- ^ A collision was detected; waiting for restart or quit.
  deriving (Eq, Show)

-- | Outcome of a finished two-player game.
-- In single-player mode 'gsWinner' is always 'Nothing'.
data Winner
  = P1Wins  -- ^ Player 1's snake survived; Player 2 collided.
  | P2Wins  -- ^ Player 2's snake survived; Player 1 collided.
  | Draw    -- ^ Both snakes collided on the same tick.
  deriving (Eq, Show)

-- ---------------------------------------------------------------------------
-- Game entities
-- ---------------------------------------------------------------------------

-- | State of a single snake.
data Snake = Snake
  { snakeBody  :: [Coord]   -- ^ Body cells; head is the first element.
  , snakeDir   :: Direction -- ^ Current movement direction.
  , snakeScore :: Int       -- ^ Number of food items eaten this game.
  } deriving (Eq, Show)

-- | Complete application state threaded through the Brick event loop.
--
-- Invariant: when 'gsPhase' is 'Playing', 'gsFood' has exactly 'foodCount'
-- elements and neither food nor snake bodies overlap.
data GameState = GameState
  { gsPhase     :: GamePhase
  , gsMode      :: GameMode
  , gsSnake1    :: Snake
  , gsSnake2    :: Maybe Snake  -- ^ 'Nothing' in 'SinglePlayer' mode.
  , gsFood      :: [Coord]      -- ^ Always exactly 'foodCount' items.
  , gsRng       :: StdGen
  , gsHighScore :: Int          -- ^ Best P1 score seen this session.
  , gsWinner    :: Maybe Winner -- ^ Set when 'gsPhase' is 'GameOver'.
  } deriving (Show)

-- ---------------------------------------------------------------------------
-- Brick resource names and custom events
-- ---------------------------------------------------------------------------

-- | Named resources used by Brick (needed for cursor and viewport APIs).
data Name = GameViewport
  deriving (Eq, Ord, Show)

-- | Custom Brick event: one game tick fired by the background thread.
data Tick = Tick

-- ---------------------------------------------------------------------------
-- Constants
-- ---------------------------------------------------------------------------

-- | Width of the play grid in cells.
gridW :: Int
gridW = 40

-- | Height of the play grid in cells.
gridH :: Int
gridH = 40

-- | Number of food items always present on the board simultaneously.
foodCount :: Int
foodCount = 3

-- | Delay between ticks in microseconds (150 ms ≈ 6.7 moves/sec).
tickIntervalUs :: Int
tickIntervalUs = 150000
