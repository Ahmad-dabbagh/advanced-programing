module Punto.Logic where

import Punto.Core
import Punto.Board
import Punto.Player
import Punto.AI
import System.Random (RandomGen, split)
import qualified Data.Map as Map

-- | Draw a card for the current player.
drawCard :: GameState -> GameState
drawCard st =
  let idx = _currentPlayerIdx st
      ps = _players st
      p = ps !! idx
      deck = _playerDeck p
  in case deck of
    (c:cs) ->
      let p' = p { _playerDeck = cs }
          ps' = take idx ps ++ [p'] ++ drop (idx + 1) ps
      in st { _players = ps', _currentCard = Just c, _phase = Placing }
    [] -> st -- Should handle empty deck case (tie check)

-- | Place the current card at the given position.
placeCurrentCard :: GameState -> Pos -> GameState
placeCurrentCard st pos =
  case _currentCard st of
    Nothing -> st
    Just card ->
      if isLegalMove (_board st) pos card
      then
        let newBoard = placeCard (_board st) pos card
            newSt = st { _board = newBoard, _currentCard = Nothing }
        in checkRoundEnd newSt
      else st

-- | Check if the current round has ended (win or tie).
checkRoundEnd :: GameState -> GameState
checkRoundEnd st =
  let idx = _currentPlayerIdx st
      p = (_players st) !! idx
      target = targetLength (_numPlayers st)
      won = checkWin target (_playerColors p) (_board st)
  in if won
     then st { _phase = RoundEnded, _winner = Just (_playerId p) }
     else nextTurn st

-- | Advance to the next player's turn.
nextTurn :: GameState -> GameState
nextTurn st =
  let nextIdx = (_currentPlayerIdx st + 1) `mod` _numPlayers st
  in st { _currentPlayerIdx = nextIdx, _phase = Drawing }

-- | Perform a bot move if the current player is a bot and it's their turn to place.
performBotMove :: (RandomGen g) => GameState -> g -> (GameState, g)
performBotMove st g =
  case _phase st of
    Placing ->
      let idx = _currentPlayerIdx st
          p = (_players st) !! idx
      in if _isBot p
         then case _currentCard st of
                Nothing -> (st, g)
                Just card ->
                  -- For now, let's say all bots are greedy unless we add a difficulty field.
                  let pos = greedyBotMove (_board st) card (_playerColors p)
                  in (placeCurrentCard st pos, g)
         else (st, g)
    Drawing ->
      let idx = _currentPlayerIdx st
          p = (_players st) !! idx
      in if _isBot p
         then (drawCard st, g)
         else (st, g)
    _ -> (st, g)
