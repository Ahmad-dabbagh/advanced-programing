module Render where

import qualified Data.Set as Set

import Brick hiding (Direction)
import Brick.Widgets.Border (border, borderWithLabel, hBorder)
import Brick.Widgets.Center (center, hCenter)
import Graphics.Vty.Attributes (defAttr, withForeColor)
import qualified Graphics.Vty.Attributes.Color as C

import Types
import Logic (snakeBody, snakeScore)

drawUI :: GameState -> [Widget Name]
drawUI gs =
  if phase gs == Menu
    then [drawMenu]
    else if phase gs == Playing
      then [drawPlaying gs]
      else [drawGameOver gs]

drawMenu :: Widget Name
drawMenu = center $ border $ padAll 2 $
  vBox
    [ hCenter $ str "S N A K E"
    , str " "
    , hCenter $ str "1  -  Single Player"
    , hCenter $ str "2  -  Two Player"
    , str " "
    , hCenter $ str "Q  -  Quit"
    ]

drawPlaying :: GameState -> Widget Name
drawPlaying gs = hBox [drawGrid gs, padLeft (Pad 2) (drawInfo gs)]

drawGrid :: GameState -> Widget Name
drawGrid gs =
  border $
  vBox [ hBox [ drawCell gs (x, y) | x <- [0..39] ]
       | y <- [0..39] ]

drawCell :: GameState -> Coord -> Widget Name
drawCell gs coord =
  let s1    = snake1 gs
      s1h   = head (snakeBody s1)
      s1b   = Set.fromList (tail (snakeBody s1))
      s2h   = case snake2 gs of
                Nothing -> (-1, -1)
                Just s2 -> head (snakeBody s2)
      s2b   = case snake2 gs of
                Nothing -> Set.empty
                Just s2 -> Set.fromList (tail (snakeBody s2))
  in if coord == s1h
       then withAttr (attrName "s1h") (str "@")
       else if Set.member coord s1b
         then withAttr (attrName "s1b") (str "o")
         else if coord == s2h
           then withAttr (attrName "s2h") (str "#")
           else if Set.member coord s2b
             then withAttr (attrName "s2b") (str "x")
             else if coord `elem` food gs
               then withAttr (attrName "fd") (str "*")
               else str " "

drawInfo :: GameState -> Widget Name
drawInfo gs =
  vBox
    [ border $ padAll 1 $ vBox
        [ str "SCORES"
        , hBorder
        , str $ "P1:   " ++ show (snakeScore (snake1 gs))
        , case snake2 gs of
            Nothing -> str ""
            Just s2 -> str $ "P2:   " ++ show (snakeScore s2)
        , str $ "Best: " ++ show (hiScore gs)
        ]
    , padTop (Pad 1) $ border $ padAll 1 $ vBox
        [ str "CONTROLS"
        , hBorder
        , str "P1:  W A S D"
        , str "P2: arrow keys"
        , str ""
        , str "Q: Quit"
        ]
    ]

drawGameOver :: GameState -> Widget Name
drawGameOver gs =
  center $
  borderWithLabel (str " GAME OVER ") $
  padAll 2 $
  vBox
    [ hCenter $ str result
    , str " "
    , hCenter $ str $ "P1 score: " ++ show (snakeScore (snake1 gs))
    , case snake2 gs of
        Nothing -> str ""
        Just s2 -> hCenter $ str $ "P2 score: " ++ show (snakeScore s2)
    , hCenter $ str $ "Best: " ++ show (hiScore gs)
    , str " "
    , hCenter $ str "R - Restart"
    , hCenter $ str "Q - Quit"
    ]
  where
    result = case winner gs of
               Nothing -> "Game Over"
               Just 0  -> "Draw!"
               Just 1  -> "Player 2 wins!"
               Just 2  -> "Player 1 wins!"
               Just _  -> "Game Over"

theAttrMap :: AttrMap
theAttrMap = attrMap defAttr
  [ (attrName "s1h", withForeColor defAttr C.brightGreen)
  , (attrName "s1b", withForeColor defAttr C.green)
  , (attrName "s2h", withForeColor defAttr C.brightBlue)
  , (attrName "s2b", withForeColor defAttr C.blue)
  , (attrName "fd",  withForeColor defAttr C.brightYellow)
  ]
