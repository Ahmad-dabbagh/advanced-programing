{-# LANGUAGE OverloadedStrings #-}
module Punto.UI where

import Brick
import Brick.Widgets.Border
import Brick.Widgets.Border.Style
import Brick.Widgets.Center
import qualified Brick.Widgets.Core as C
import qualified Graphics.Vty as V
import Punto.Core
import Punto.Board
import Punto.Logic
import qualified Data.Map as Map
import Data.Maybe (fromMaybe)
import System.Random (mkStdGen)
import qualified Data.Text as T

data Name = BoardPos Pos | UIOther deriving (Eq, Ord, Show)

-- | The UI State.
data UIState = UIState
  { _gameState :: GameState
  , _cursor    :: Pos
  }

drawUI :: UIState -> [Widget Name]
drawUI st =
  let gs = _gameState st
      info = vBox
        [ txt ("Player: " <> T.pack (show (_currentPlayerIdx gs)))
        , if _isBot ((_players gs) !! (_currentPlayerIdx gs)) then txt "(Bot)" else txt "(Human)"
        , txt ("Phase: " <> T.pack (show (_phase gs)))
        , case _currentCard gs of
            Just c -> hBox [txt "Drawn: ", withAttr (colorAttr (cardColor c)) (txt (T.pack (show (cardValue c))))]
            Nothing -> txt "Drawn: None"
        , case _winner gs of
            Just w -> withAttr (attrName "cursor") (txt ("WINNER: Player " <> T.pack (show w)))
            Nothing -> txt ""
        , txt "Controls: Arrows to move, Space to draw/place, Q to quit"
        ]
  in [center $ hBox [drawBoard st, padLeft (Pad 2) info]]

drawBoard :: UIState -> Widget Name
drawBoard st =
  let b = _board (_gameState st)
      (minX, maxX, minY, maxY) = fromMaybe (-2, 2, -2, 2) (getBoundaries b)
      -- Expand by 1 to allow placing next to existing
      rows = [minY - 1 .. maxY + 1]
      cols = [minX - 1 .. maxX + 1]
  in vBox [ hBox [ drawCell st (x, y) | x <- cols ] | y <- rows ]

drawCell :: UIState -> Pos -> Widget Name
drawCell st pos =
  let b = _board (_gameState st)
      card = topCard b pos
      isCursor = _cursor st == pos
      cellContent = case card of
        Just c -> withAttr (colorAttr (cardColor c)) (txt (T.pack (show (cardValue c))))
        Nothing -> txt "."
      box = if isCursor
            then withAttr (attrName "cursor") (C.padAll 1 cellContent)
            else C.padAll 1 cellContent
  in C.hLimit 3 $ C.vLimit 3 $ center box

colorAttr :: Color -> AttrName
colorAttr Red = attrName "red"
colorAttr Blue = attrName "blue"
colorAttr Green = attrName "green"
colorAttr Yellow = attrName "yellow"

theApp :: App UIState e Name
theApp = App
  { appDraw         = drawUI
  , appChooseCursor = showFirstCursor
  , appHandleEvent  = handleEvent
  , appStartEvent   = return ()
  , appAttrMap      = const theMap
  }

theMap :: AttrMap
theMap = attrMap V.defAttr
  [ (attrName "red", V.withForeColor V.defAttr V.red)
  , (attrName "blue", V.withForeColor V.defAttr V.blue)
  , (attrName "green", V.withForeColor V.defAttr V.green)
  , (attrName "yellow", V.withForeColor V.defAttr V.yellow)
  , (attrName "cursor", V.withStyle V.defAttr V.reverseVideo)
  ]

handleEvent :: BrickEvent Name e -> EventM Name UIState ()
handleEvent (VtyEvent (V.EvKey V.KUp [])) = modify (\s -> s { _cursor = let (x, y) = _cursor s in (x, y - 1) })
handleEvent (VtyEvent (V.EvKey V.KDown [])) = modify (\s -> s { _cursor = let (x, y) = _cursor s in (x, y + 1) })
handleEvent (VtyEvent (V.EvKey V.KLeft [])) = modify (\s -> s { _cursor = let (x, y) = _cursor s in (x - 1, y) })
handleEvent (VtyEvent (V.EvKey V.KRight [])) = modify (\s -> s { _cursor = let (x, y) = _cursor s in (x + 1, y) })
handleEvent (VtyEvent (V.EvKey (V.KChar ' ') [])) = do
  st <- get
  let gs = _gameState st
      idx = _currentPlayerIdx gs
      p = (_players gs) !! idx
  if _isBot p
    then let (gs', _) = performBotMove gs (mkStdGen 42)
         in put (st { _gameState = gs' })
    else case _phase gs of
      Drawing -> put (st { _gameState = drawCard gs })
      Placing -> put (st { _gameState = placeCurrentCard gs (_cursor st) })
      _ -> return ()
handleEvent (VtyEvent (V.EvKey (V.KChar 'q') [])) = halt
handleEvent _ = return ()
