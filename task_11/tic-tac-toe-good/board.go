package tictactoegood

// Constants - no magic numbers anywhere.
const (
	BoardSize    = 3
	CellCount    = BoardSize * BoardSize
	WinLineCount = 8 // 3 rows + 3 columns + 2 diagonals

	// Player marks and empty cells.
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
	// Board{} is already all Empty (""), so this is correct.
	return Board{}
}

// Set places a player mark at the given position (0-based index).
// Returns ErrOutOfBounds if pos invalid, ErrCellOccupied if taken.
func (b *Board) Set(pos int, player Cell) error {
	if pos < 0 || pos >= CellCount {
		return ErrOutOfBounds
	}

	if player != Cell(PlayerX) && player != Cell(PlayerO) {
		return ErrInvalidMove
	}

	if (*b)[pos] != Empty {
		return ErrCellOccupied
	}

	(*b)[pos] = player
	return nil
}

// Get returns the cell value at position pos.
func (b Board) Get(pos int) Cell {
	if pos < 0 || pos >= CellCount {
		return Empty
	}
	return b[pos]
}

// IsFull returns true if no empty cells remain.
func (b Board) IsFull() bool {
	for i := 0; i < CellCount; i++ {
		if b[i] == Empty {
			return false
		}
	}
	return true
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
	lines := WinningLines()
	for _, line := range lines {
		i0, i1, i2 := line[0], line[1], line[2]
		first := b[i0]
		if first == Empty {
			continue
		}

		v1 := b[i1]
		v2 := b[i2]

		// Rewritten to avoid gocritic badCond.
		if v1 == v2 && first == v1 {
			return first
		}
	}
	return Empty
}
