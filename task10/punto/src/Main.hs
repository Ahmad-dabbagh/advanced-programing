module Main where

import Brick
import Punto.Core
import Punto.Player
import Punto.UI
import System.Random (getStdGen)
import qualified Data.Map as Map

main :: IO ()
main = do
  g <- getStdGen
  let numPlayers = 2
      ps = initDeck numPlayers g
      -- Make player 1 a bot
      ps' = case ps of
        (p0:p1:rest) -> p0 : p1 { _isBot = True } : rest
        _ -> ps
      gs = GameState
        { _board            = Map.empty
        , _players          = ps'
        , _currentPlayerIdx = 0
        , _currentCard      = Nothing
        , _phase            = Drawing
        , _winner           = Nothing
        , _numPlayers       = numPlayers
        }
      ui = UIState gs (0, 0)
  _ <- defaultMain theApp ui
  return ()
