-- src/Input.hs
module Input where

import Graphics.Gloss.Interface.Pure.Game
  ( Event(..), Key(..), SpecialKey(..), KeyState(..) )
import Types
import Logic (resetGame)

opposite :: Dir -> Dir -> Bool
opposite U D = True
opposite D U = True
opposite L R = True
opposite R L = True
opposite _ _ = False

setDir :: Dir -> Snake -> Snake
setDir d s =
  if opposite d (dir s) then s else s { dir = d }

updateSnake :: Int -> (Snake -> Snake) -> Game -> Game
updateSnake i f g =
  let ss = snakes g
  in if i < 0 || i >= length ss
     then g
     else g { snakes = take i ss ++ [f (ss !! i)] ++ drop (i+1) ss }

handleInput :: Event -> Game -> Game
handleInput ev g =
  case ev of
    -- Restart (keeps current mode: 1 snake or 2 snakes)
    EventKey (Char 'r') Down _ _ -> resetGame (length (snakes g) == 2) g
    EventKey (Char 'R') Down _ _ -> resetGame (length (snakes g) == 2) g

    -- Player 1: WASD
    EventKey (Char 'w') Down _ _ -> updateSnake 0 (setDir U) g
    EventKey (Char 's') Down _ _ -> updateSnake 0 (setDir D) g
    EventKey (Char 'a') Down _ _ -> updateSnake 0 (setDir L) g
    EventKey (Char 'd') Down _ _ -> updateSnake 0 (setDir R) g

    -- Player 2: Arrow keys (only works if 2nd snake exists)
    EventKey (SpecialKey KeyUp) Down _ _    -> updateSnake 1 (setDir U) g
    EventKey (SpecialKey KeyDown) Down _ _  -> updateSnake 1 (setDir D) g
    EventKey (SpecialKey KeyLeft) Down _ _  -> updateSnake 1 (setDir L) g
    EventKey (SpecialKey KeyRight) Down _ _ -> updateSnake 1 (setDir R) g

    _ -> g
