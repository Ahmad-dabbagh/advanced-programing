# Punto Game Specification

## Rules
- **Players**: 2–4.
- **Goal**: 
  - 2 Players: 5-in-a-row.
  - 3–4 Players: 4-in-a-row.
- **Card Distribution**:
  - 2 Players: 2 colors each (36 cards).
  - 3 Players: 1 color each + 6 neutral (shuffled in).
  - 4 Players: 1 color each.
- **Card Placement**:
  - Adjacency: New cards must touch existing cards.
  - 6x6 Grid: The total grid area cannot exceed 6x6.
  - Stacking: A card can be placed on top of another ONLY if the new value is strictly higher.
- **Win Conditions**: Achieving the target length (4 or 5) of same-colored cards in a row (horizontal, vertical, diagonal).
- **Tie-Breaking**:
  - Most rows of length (target - 1).
  - Highest sum of values in those rows.

## Assumptions & Decisions
- **Grid Coordination**: We use `(Int, Int)` with `(0,0)` as the initial placement. The 6x6 limit is checked dynamically.
- **Player Types**: Both human and bots are supported. Bots use a deterministic RNG seed.
- **Pure Logic**: The game state and transition logic are entirely pure.

## Implementation Details
- **Modules**: `Game.Types`, `Game.Board`, `Game.Rules`, `Game.Win`.
- **Testing**: Comprehensive `doctests` for all pure logic.
