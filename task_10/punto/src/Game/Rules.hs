module Game.Rules where

import qualified Data.Map as Map
import Game.Types
import Game.Board

-- | Re-export or define placeCard. 
-- In this module, it just delegates to Game.Board.placeCard.
placeCard :: Board -> Pos -> Card -> Board
placeCard = Game.Board.placeCard

-- | Check if stacking is allowed at a position.
-- Stacking is allowed ONLY if the new card's value is strictly higher than the current top card.
--
-- >>> import qualified Data.Map as Map
-- >>> let b = Map.fromList [((0,0), [Card Red 5])]
-- >>> stackAllowed b (0,0) (Card Blue 6)
-- True
-- >>> stackAllowed b (0,0) (Card Blue 5)
-- False
-- >>> stackAllowed b (1,1) (Card Blue 5)
-- True
stackAllowed :: Board -> Pos -> Card -> Bool
stackAllowed b pos newCard =
  case topCard b pos of
    Nothing -> True
    Just top -> cardValue newCard > cardValue top

-- | Check if a position is adjacent (including diagonals) to any existing card.
isAdjacent :: Board -> Pos -> Bool
isAdjacent b pos
  | Map.null b = True -- First card is always "adjacent"
  | otherwise = any (`Map.member` b) (adjacentPositions pos)

-- | Check if a card can be placed at a position according to all rules:
-- 1. Board size must not exceed 6x6.
-- 2. Card must be adjacent to at least one existing card OR stacked on an existing card.
-- 3. Stacking allowed only if new value > existing value.
--
-- >>> import qualified Data.Map as Map
-- >>> let b = Map.fromList [((0,0), [Card Red 5])]
-- >>> isLegalMove b (0,1) (Card Red 3)
-- True
-- >>> isLegalMove b (0,0) (Card Red 6)
-- True
-- >>> isLegalMove b (0,0) (Card Red 4)
-- False
-- >>> isLegalMove b (6,0) (Card Red 4)
-- False
isLegalMove :: Board -> Pos -> Card -> Bool
isLegalMove b pos card =
  isWithin6x6 b pos && (isAdjacent b pos || Map.member pos b) && stackAllowed b pos card
