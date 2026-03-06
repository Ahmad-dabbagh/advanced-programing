-- src/Render.hs
module Render where

import Graphics.Gloss
import Types

cellSize :: Float
cellSize = 15

toScreen :: (Int,Int) -> Pos -> (Float, Float)
toScreen (w,h) (x,y) =
  let xf = fromIntegral x * cellSize
      yf = fromIntegral y * cellSize
      x0 = xf - fromIntegral w * cellSize / 2 + cellSize/2
      y0 = yf - fromIntegral h * cellSize / 2 + cellSize/2
  in (x0, y0)

drawCell :: (Int,Int) -> Color -> Pos -> Picture
drawCell grid c p =
  let (x,y) = toScreen grid p
  in translate x y $ color c $ rectangleSolid cellSize cellSize

renderGame :: Game -> Picture
renderGame g =
  pictures $
    [ drawCell (grid g) red (food g)
    , translate (-380) 380 $ scale 0.15 0.15 $ color white $ text (scoreText g)
    ]
    ++ drawSnakes (grid g) (snakes g)
    ++ gameOverOverlay g

drawSnakes :: (Int,Int) -> [Snake] -> [Picture]
drawSnakes grid ss =
  concatMap drawOne (zip ([0 :: Int ..]) ss)
  where
    drawOne (i,s) =
      let col = if i == 0 then green else blue
      in map (drawCell grid col) (body s)

scoreText :: Game -> String
scoreText g =
  case snakes g of
    [s1]    -> "Score: " ++ show (score s1)
    [s1,s2] -> "P1: " ++ show (score s1) ++ "  P2: " ++ show (score s2)
    _       -> ""

gameOverOverlay :: Game -> [Picture]
gameOverOverlay g =
  if screen g == GameOver
  then
    [ color (makeColor 0 0 0 0.6) $ rectangleSolid 2000 2000
    , color white $ translate (-220) 0 $ scale 0.3 0.3 $ text "GAME OVER - press R"
    ]
  else []
