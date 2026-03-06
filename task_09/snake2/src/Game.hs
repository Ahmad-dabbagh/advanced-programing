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
import Logic
import Render

app :: App GameState Tick Name
app = App
  { appDraw         = drawUI
  , appChooseCursor = neverShowCursor
  , appHandleEvent  = handleEvent
  , appStartEvent   = return ()
  , appAttrMap      = const theAttrMap
  }

handleEvent :: BrickEvent Name Tick -> EventM Name GameState ()
handleEvent ev = do
  gs <- get
  case phase gs of
    Menu     -> handleMenu gs ev
    Playing  -> handlePlaying gs ev
    GameOver -> handleGameOver gs ev

handleMenu :: GameState -> BrickEvent Name Tick -> EventM Name GameState ()
handleMenu gs (VtyEvent (V.EvKey (V.KChar '1') [])) = do
  r <- liftIO newStdGen
  put $ initialState SinglePlayer (hiScore gs) r
handleMenu gs (VtyEvent (V.EvKey (V.KChar '2') [])) = do
  r <- liftIO newStdGen
  put $ initialState TwoPlayer (hiScore gs) r
handleMenu _ (VtyEvent (V.EvKey (V.KChar 'q') [])) = halt
handleMenu _ (VtyEvent (V.EvKey V.KEsc []))         = halt
handleMenu _ _                                       = return ()

handlePlaying :: GameState -> BrickEvent Name Tick -> EventM Name GameState ()
handlePlaying gs (AppEvent Tick) = put (stepGame gs)
handlePlaying gs (VtyEvent (V.EvKey key [])) =
  case key of
    V.KChar 'w' -> setDir1 gs DUp
    V.KChar 's' -> setDir1 gs DDown
    V.KChar 'a' -> setDir1 gs DLeft
    V.KChar 'd' -> setDir1 gs DRight
    V.KUp       -> setDir2 gs DUp
    V.KDown     -> setDir2 gs DDown
    V.KLeft     -> setDir2 gs DLeft
    V.KRight    -> setDir2 gs DRight
    V.KChar 'q' -> halt
    V.KEsc      -> halt
    _           -> return ()
handlePlaying _ _ = return ()

handleGameOver :: GameState -> BrickEvent Name Tick -> EventM Name GameState ()
handleGameOver gs (VtyEvent (V.EvKey (V.KChar 'r') [])) =
  put $ gs { phase = Menu }
handleGameOver _ (VtyEvent (V.EvKey (V.KChar 'q') [])) = halt
handleGameOver _ (VtyEvent (V.EvKey V.KEsc []))         = halt
handleGameOver _ _                                       = return ()

setDir1 :: GameState -> Direction -> EventM Name GameState ()
setDir1 gs d =
  let (Snake _ dir _) = snake1 gs
  in if (d == DUp   && dir == DDown)  || (d == DDown  && dir == DUp)   ||
        (d == DLeft && dir == DRight) || (d == DRight && dir == DLeft)
       then return ()
       else put $ gs { snake1 = case snake1 gs of Snake b _ s -> Snake b d s }

setDir2 :: GameState -> Direction -> EventM Name GameState ()
setDir2 gs d =
  case snake2 gs of
    Nothing -> return ()
    Just (Snake b dir s) ->
      if (d == DUp   && dir == DDown)  || (d == DDown  && dir == DUp)   ||
         (d == DLeft && dir == DRight) || (d == DRight && dir == DLeft)
        then return ()
        else put $ gs { snake2 = Just (Snake b d s) }

runGame :: IO ()
runGame = do
  r    <- newStdGen
  chan <- newBChan 1
  void $ forkIO $ forever $ do
    writeBChan chan Tick
    threadDelay 150000
  let menuState = GameState Menu SinglePlayer initSnake1 Nothing [] r 0 Nothing
  let buildVty  = mkVty V.defaultConfig
  iv <- buildVty
  void $ customMain iv buildVty (Just chan) app menuState
