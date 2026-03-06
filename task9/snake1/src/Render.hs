-- | Brick rendering: converts 'GameState' into Brick widgets.
--
-- The key design principle here is the 'RenderState' record: all
-- 'Set'-based lookups are pre-computed once per frame in 'toRenderState'
-- rather than rebuilt inside the per-cell 'cellWidget' function
-- (which is called 40x40 = 1600 times per frame).
module Render
  ( drawUI
  , theAttrMap
    -- * Exported for testing
  , RenderState (..)
  , toRenderState
  , gameResultText
  ) where

import Data.Set (Set)
import qualified Data.Set as Set

import Brick hiding (RenderState)
import Brick.Widgets.Border (border, borderWithLabel, hBorder)
import Brick.Widgets.Center (center, hCenter)
import Graphics.Vty.Attributes (defAttr, withForeColor)
import qualified Graphics.Vty.Attributes.Color as C

import Types
import Logic (snakeHead)

-- ---------------------------------------------------------------------------
-- Pre-computed render data
-- ---------------------------------------------------------------------------

-- | All the per-frame rendering data derived from 'GameState'.
-- Building this once avoids redundant 'Set.fromList' calls inside
-- 'cellWidget', which is called once per grid cell every frame.
data RenderState = RenderState
  { rs1Head :: Maybe Coord   -- ^ Head of snake 1.
  , rs1Body :: Set Coord     -- ^ Body cells of snake 1 (excluding head).
  , rs2Head :: Maybe Coord   -- ^ Head of snake 2, if present.
  , rs2Body :: Set Coord     -- ^ Body cells of snake 2 (excluding head).
  , rsFood  :: Set Coord     -- ^ All current food positions.
  } deriving (Eq, Show)

-- | Build a 'RenderState' from the current 'GameState'.
-- This is a pure function and can be tested independently of Brick.
--
-- >>> import System.Random (mkStdGen)
-- >>> let s1 = Snake [(5,5),(4,5),(3,5)] DRight 0
-- >>> let gs = GameState Playing SinglePlayer s1 Nothing [(1,1),(2,2),(3,3)] (mkStdGen 0) 0 Nothing
-- >>> rs1Head (toRenderState gs)
-- Just (5,5)
-- >>> Set.size (rs1Body (toRenderState gs))
-- 2
-- >>> rs2Head (toRenderState gs)
-- Nothing
-- >>> Set.size (rsFood (toRenderState gs))
-- 3
toRenderState :: GameState -> RenderState
toRenderState gs = RenderState
  { rs1Head = snakeHead s1
  , rs1Body = Set.fromList (drop 1 (snakeBody s1))
  , rs2Head = gsSnake2 gs >>= snakeHead
  , rs2Body = maybe Set.empty (Set.fromList . drop 1 . snakeBody) (gsSnake2 gs)
  , rsFood  = Set.fromList (gsFood gs)
  }
  where
    s1 = gsSnake1 gs

-- ---------------------------------------------------------------------------
-- Attribute names and colour map
-- ---------------------------------------------------------------------------

snake1HeadAttr, snake1BodyAttr :: AttrName
snake1HeadAttr = attrName "snake1Head"
snake1BodyAttr = attrName "snake1Body"

snake2HeadAttr, snake2BodyAttr :: AttrName
snake2HeadAttr = attrName "snake2Head"
snake2BodyAttr = attrName "snake2Body"

foodAttr :: AttrName
foodAttr = attrName "food"

titleAttr :: AttrName
titleAttr = attrName "title"

-- | Attribute map: wires attribute names to VTY terminal colours.
theAttrMap :: AttrMap
theAttrMap = attrMap defAttr
  [ (snake1HeadAttr, withForeColor defAttr C.brightGreen)
  , (snake1BodyAttr, withForeColor defAttr C.green)
  , (snake2HeadAttr, withForeColor defAttr C.brightBlue)
  , (snake2BodyAttr, withForeColor defAttr C.blue)
  , (foodAttr,       withForeColor defAttr C.brightYellow)
  , (titleAttr,      withForeColor defAttr C.brightWhite)
  ]

-- ---------------------------------------------------------------------------
-- Top-level draw dispatcher
-- ---------------------------------------------------------------------------

-- | Main draw function passed to the Brick 'App'.
drawUI :: GameState -> [Widget Name]
drawUI gs = case gsPhase gs of
  Menu     -> [drawMenu]
  Playing  -> [drawPlaying gs]
  GameOver -> [drawGameOver gs]

-- ---------------------------------------------------------------------------
-- Menu screen
-- ---------------------------------------------------------------------------

drawMenu :: Widget Name
drawMenu = center $
  borderWithLabel (withAttr titleAttr $ str " SNAKE ") $
  padAll 2 $
  vBox
    [ hCenter $ withAttr titleAttr $ str "╔══════════════════╗"
    , hCenter $ withAttr titleAttr $ str "║   S N A K E      ║"
    , hCenter $ withAttr titleAttr $ str "╚══════════════════╝"
    , str " "
    , hCenter $ str "1  -  Single Player"
    , hCenter $ str "2  -  Two Player"
    , str " "
    , hCenter $ str "Q  -  Quit"
    ]

-- ---------------------------------------------------------------------------
-- Playing screen
-- ---------------------------------------------------------------------------

drawPlaying :: GameState -> Widget Name
drawPlaying gs =
  hBox
    [ drawGrid gs
    , padLeft (Pad 2) (drawScorePanel gs)
    ]

-- | Render the 40×40 grid as a bordered widget.
-- 'toRenderState' is called once here; the resulting 'RenderState' is
-- shared across all 1600 'cellWidget' calls.
drawGrid :: GameState -> Widget Name
drawGrid gs =
  let rs = toRenderState gs
  in border $
     vBox [ hBox [ cellWidget rs (x, y) | x <- [0 .. gridW - 1] ]
          | y <- [0 .. gridH - 1]
          ]

-- | Render a single cell using pre-computed 'Set' lookups (all O(log n)).
cellWidget :: RenderState -> Coord -> Widget Name
cellWidget rs coord
  | Just coord == rs1Head rs      = withAttr snake1HeadAttr (str "@")
  | coord `Set.member` rs1Body rs = withAttr snake1BodyAttr (str "o")
  | Just coord == rs2Head rs      = withAttr snake2HeadAttr (str "#")
  | coord `Set.member` rs2Body rs = withAttr snake2BodyAttr (str "x")
  | coord `Set.member` rsFood  rs = withAttr foodAttr       (str "*")
  | otherwise                     = str " "

-- | Score and controls panel displayed to the right of the grid.
drawScorePanel :: GameState -> Widget Name
drawScorePanel gs =
  vBox
    [ border $ padAll 1 $ vBox $
        [ withAttr titleAttr $ str "SCORES"
        , hBorder
        , str $ "P1:   " ++ show (snakeScore (gsSnake1 gs))
        ] ++
        [ str $ "P2:   " ++ show (snakeScore s2)
        | Just s2 <- [gsSnake2 gs]
        ] ++
        [ str $ "Best: " ++ show (gsHighScore gs) ]
    , padTop (Pad 1) $ border $ padAll 1 $ vBox $
        [ withAttr titleAttr $ str "CONTROLS"
        , hBorder
        , str "P1:  W A S D"
        ] ++
        [ str "P2: ↑ ← ↓ →"
        | gsMode gs == TwoPlayer
        ] ++
        [ str ""
        , str "Q: Quit"
        ]
    ]

-- ---------------------------------------------------------------------------
-- Game-over screen
-- ---------------------------------------------------------------------------

-- | Human-readable outcome text for the game-over screen.
-- Extracted as a pure function so it can be tested independently.
--
-- >>> gameResultText SinglePlayer Nothing
-- "Game Over"
-- >>> gameResultText TwoPlayer (Just P1Wins)
-- "Player 1 wins!"
-- >>> gameResultText TwoPlayer (Just P2Wins)
-- "Player 2 wins!"
-- >>> gameResultText TwoPlayer (Just Draw)
-- "Draw!"
gameResultText :: GameMode -> Maybe Winner -> String
gameResultText SinglePlayer _              = "Game Over"
gameResultText TwoPlayer    (Just P1Wins)  = "Player 1 wins!"
gameResultText TwoPlayer    (Just P2Wins)  = "Player 2 wins!"
gameResultText TwoPlayer    (Just Draw)    = "Draw!"
gameResultText TwoPlayer    Nothing        = "Game Over"  -- should not occur

drawGameOver :: GameState -> Widget Name
drawGameOver gs =
  center $
  borderWithLabel (withAttr titleAttr $ str " GAME OVER ") $
  padAll 2 $
  vBox $
    [ hCenter $ withAttr titleAttr $ str (gameResultText (gsMode gs) (gsWinner gs))
    , str " "
    , hCenter $ str $ "P1 score: " ++ show (snakeScore (gsSnake1 gs))
    ] ++
    [ hCenter $ str $ "P2 score: " ++ show (snakeScore s2)
    | Just s2 <- [gsSnake2 gs]
    ] ++
    [ hCenter $ str $ "Best score: " ++ show (gsHighScore gs)
    , str " "
    , hCenter hBorder
    , str " "
    , hCenter $ str "R - Restart (Menu)"
    , hCenter $ str "Q - Quit"
    ]
