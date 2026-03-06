package tictactoegood

import "io"

// Player represents any participant in the game — human or AI.
type Player interface {
	// Symbol returns this player's board marker (PlayerX or PlayerO).
	Symbol() Cell
	// ChooseMove returns a 0-based board position for the next move.
	// It must return ErrGameOver if no moves are available.
	ChooseMove(b Board) (int, error)
}

// HumanPlayer reads moves from an io.Reader (typically os.Stdin).
type HumanPlayer struct {
	symbol Cell
	in     io.Reader
	out    io.Writer
}

// NewHumanPlayer creates a human player reading from in and prompting to out.
func NewHumanPlayer(symbol Cell, in io.Reader, out io.Writer) *HumanPlayer {
	panic("not implemented")
}

func (h *HumanPlayer) Symbol() Cell { return h.symbol }

// ChooseMove prompts the human and reads a 1-9 position, returning 0-based index.
// Returns ErrInvalidMove for non-numeric input, ErrOutOfBounds for out-of-range.
func (h *HumanPlayer) ChooseMove(b Board) (int, error) {
	panic("not implemented")
}

// AIPlayer picks a random empty cell.
type AIPlayer struct {
	symbol Cell
}

// NewAIPlayer creates an AI player with the given symbol.
func NewAIPlayer(symbol Cell) *AIPlayer {
	panic("not implemented")
}

func (a *AIPlayer) Symbol() Cell { return a.symbol }

// ChooseMove picks a uniformly random empty cell from the board.
// Returns ErrGameOver if the board is full.
func (a *AIPlayer) ChooseMove(b Board) (int, error) {
	panic("not implemented")
}
