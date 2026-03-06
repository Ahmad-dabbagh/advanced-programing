package tictactoegood

import "io"

// Result represents the outcome of a completed game.
type Result struct {
	Winner Cell   // Empty if draw
	Draw   bool
}

// Game orchestrates a full game between two players.
type Game struct {
	board   Board
	players [2]Player
	out     io.Writer
	render  Renderer
}

// NewGame creates a new game with the given players, renderer, and output writer.
func NewGame(p1, p2 Player, r Renderer, out io.Writer) *Game {
	panic("not implemented")
}

// Run executes the game loop until a player wins or the board is full.
// Returns the game Result.
func (g *Game) Run() (Result, error) {
	panic("not implemented")
}
