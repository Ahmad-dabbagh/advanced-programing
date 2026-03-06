package tictactoegood

// Constants - no magic numbers anywhere.
const (
	BoardSize    = 3
	CellCount    = BoardSize * BoardSize
	WinLineCount = 8 // 3 rows + 3 columns + 2 diagonals

	// we use nice named constants for player marks and empty cells,
	// instead of bare string literals in the code.
	PlayerX = "X"
	PlayerO = "O"
	Empty   = ""
)

// Cell represents a single cell state on the board.
type Cell string

// Board represents the 3x3 game board.
type Board [CellCount]Cell

// NewBoard returns a fresh empty board.
func NewBoard() Board {
	panic("not implemented")
}

// Set places a player mark at the given position (0-based index).
// Returns ErrOutOfBounds if pos invalid, ErrCellOccupied if taken.
func (b *Board) Set(pos int, player Cell) error {
	panic("not implemented")
}

// Get returns the cell value at position pos.
func (b Board) Get(pos int) Cell {
	panic("not implemented")
}

// IsFull returns true if no empty cells remain.
func (b Board) IsFull() bool {
	panic("not implemented")
}

// WinningLines returns all 8 possible winning line index sets.
func WinningLines() [WinLineCount][BoardSize]int { //nolint:mnd // grid positions are self-documenting
	return [WinLineCount][BoardSize]int{
		{0, 1, 2}, {3, 4, 5}, {6, 7, 8}, // rows
		{0, 3, 6}, {1, 4, 7}, {2, 5, 8}, // columns
		{0, 4, 8}, {2, 4, 6}, // diagonals
	}
}

// CheckWin returns the winning player's Cell, or Empty if no winner yet.
func CheckWin(b Board) Cell {
	// Use WinningLines to check each line for a winner,
	// instead of hardcoding all 8 conditions with nested ifs.
	panic("not implemented")
}
