-- | Brick application wiring: event handler, tick loop, and entry point.
--
-- This module is the only place in the project that performs 'IO'.
-- All game logic lives in "Logic" (pure functions); all drawing lives in
-- "Render" (pure functions).  'Game' just wires them into the Brick loop.
module Game (runGame) where

import Control.Concurrent (forkIO, threadDelay)
import Control.Monad (forever, void)
import Control.Monad.IO.Class (liftIO)
import System.Random (newStdGen)

import Brick hiding (Direction)
import Brick.BChan (newBChan, writeBChan)
import qualified Graphics.Vty as V
import Graphics.Vty.Platform.Unix (mkVty)

import Types
import Logic (initialState, stepGame, oppositeDir)
import Render (drawUI, theAttrMap)

-- ---------------------------------------------------------------------------
-- Brick app record
-- ---------------------------------------------------------------------------

app :: App GameState Tick Name
app = App
  { appDraw         = drawUI
  , appChooseCursor = neverShowCursor
  , appHandleEvent  = handleEvent
  , appStartEvent   = return ()
  , appAttrMap      = const theAttrMap
  }

-- ---------------------------------------------------------------------------
-- Event handling
-- ---------------------------------------------------------------------------

-- | Top-level event dispatcher: routes each event to the correct handler
-- based on the current game phase.
handleEvent :: BrickEvent Name Tick -> EventM Name GameState ()
handleEvent ev = do
  gs <- get
  case gsPhase gs of
    Menu     -> handleMenu ev
    Playing  -> handlePlaying ev
    GameOver -> handleGameOver ev

-- | Menu phase: choose a game mode or quit.
handleMenu :: BrickEvent Name Tick -> EventM Name GameState ()
handleMenu (VtyEvent (V.EvKey (V.KChar '1') [])) = do
  rng <- liftIO newStdGen
  hs  <- gets gsHighScore
  put =<< liftIO (pure $ initialState SinglePlayer hs rng)
handleMenu (VtyEvent (V.EvKey (V.KChar '2') [])) = do
  rng <- liftIO newStdGen
  hs  <- gets gsHighScore
  put =<< liftIO (pure $ initialState TwoPlayer hs rng)
handleMenu (VtyEvent (V.EvKey (V.KChar 'q') [])) = halt
handleMenu (VtyEvent (V.EvKey V.KEsc []))         = halt
handleMenu _                                       = return ()

-- | Playing phase: advance the game on each tick, or update the direction
-- on keypress.  Uses 'modify' so no stale 'GameState' is ever captured.
handlePlaying :: BrickEvent Name Tick -> EventM Name GameState ()
handlePlaying (AppEvent Tick) = modify stepGame
handlePlaying (VtyEvent (V.EvKey key [])) =
  case key of
    -- Player 1: WASD
    V.KChar 'w' -> setDir1 DUp
    V.KChar 's' -> setDir1 DDown
    V.KChar 'a' -> setDir1 DLeft
    V.KChar 'd' -> setDir1 DRight
    -- Player 2: arrow keys (silently ignored in single-player via setDir2)
    V.KUp    -> setDir2 DUp
    V.KDown  -> setDir2 DDown
    V.KLeft  -> setDir2 DLeft
    V.KRight -> setDir2 DRight
    -- Quit
    V.KChar 'q' -> halt
    V.KEsc       -> halt
    _            -> return ()
handlePlaying _ = return ()

-- | Game-over phase: return to the menu or quit.
handleGameOver :: BrickEvent Name Tick -> EventM Name GameState ()
handleGameOver (VtyEvent (V.EvKey (V.KChar 'r') [])) = modify (\gs -> gs { gsPhase = Menu })
handleGameOver (VtyEvent (V.EvKey (V.KChar 'q') [])) = halt
handleGameOver (VtyEvent (V.EvKey V.KEsc []))         = halt
handleGameOver _                                       = return ()

-- ---------------------------------------------------------------------------
-- Direction helpers (use 'modify' — no explicit state threading)
-- ---------------------------------------------------------------------------

-- | Update player 1's direction.  A 180° reversal is silently ignored to
-- prevent instant self-collision from a bad keypress.
setDir1 :: Direction -> EventM Name GameState ()
setDir1 d = modify $ \gs ->
  let s1 = gsSnake1 gs
  in if d == oppositeDir (snakeDir s1)
       then gs
       else gs { gsSnake1 = s1 { snakeDir = d } }

-- | Update player 2's direction.  No-op in single-player mode.
setDir2 :: Direction -> EventM Name GameState ()
setDir2 d = modify $ \gs ->
  case gsSnake2 gs of
    Nothing -> gs
    Just s2 ->
      if d == oppositeDir (snakeDir s2)
        then gs
        else gs { gsSnake2 = Just (s2 { snakeDir = d }) }

-- ---------------------------------------------------------------------------
-- Entry point
-- ---------------------------------------------------------------------------

-- | Initialise the Brick event loop and launch the game.
--
-- A background thread fires a 'Tick' event every 'tickIntervalUs'
-- microseconds via a bounded 'BChan' (capacity 1).  The capacity cap
-- ensures that if rendering falls behind, surplus ticks are dropped rather
-- than queued, keeping the game speed consistent.
runGame :: IO ()
runGame = do
  rng  <- newStdGen
  chan <- newBChan 1
  -- Tick thread: fires at a fixed interval.  The ThreadId is discarded;
  -- the thread is implicitly killed when the process exits.
  void $ forkIO $ forever $ do
    writeBChan chan Tick
    threadDelay tickIntervalUs
  -- The menu state carries only the high score; all other fields are
  -- placeholders that are replaced when the player chooses a mode.
  let menuState = GameState
        { gsPhase     = Menu
        , gsMode      = SinglePlayer  -- overwritten on mode selection
        , gsSnake1    = Snake [] DRight 0  -- not used in Menu phase
        , gsSnake2    = Nothing
        , gsFood      = []             -- not used in Menu phase
        , gsRng       = rng
        , gsHighScore = 0
        , gsWinner    = Nothing
        }
  let buildVty = mkVty V.defaultConfig
  initialVty <- buildVty
  void $ customMain initialVty buildVty (Just chan) app menuState
