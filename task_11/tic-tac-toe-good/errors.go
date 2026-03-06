package tictactoegood

import "errors"

// Sentinel errors for the tictactoe package.
var (
	ErrInvalidMove   = errors.New("invalid move")
	ErrCellOccupied  = errors.New("cell already occupied")
	ErrOutOfBounds   = errors.New("move out of bounds")
	ErrGameOver      = errors.New("game is already over")
)
