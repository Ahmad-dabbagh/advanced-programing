package tictactoegood

import (
	"fmt"
	"io"
)

// Renderer renders the board state to the user.
type Renderer interface {
	// Render writes the current board state to the output.
	Render(b Board) error
}

// TerminalRenderer renders the board as a UTF-8 box-drawing grid.
type TerminalRenderer struct {
	out io.Writer
}

// NewTerminalRenderer creates a renderer writing to out.
func NewTerminalRenderer(out io.Writer) *TerminalRenderer {
	return &TerminalRenderer{out: out}
}

// Render prints the board using UTF-8 box-drawing characters.
// Example output:
//
//	╔═══╦═══╦═══╗
//	║ X ║   ║ O ║
//	╠═══╬═══╬═══╣
//	║   ║ X ║   ║
//	╠═══╬═══╬═══╣
//	║   ║   ║ O ║
//	╚═══╩═══╩═══╝
func (r *TerminalRenderer) Render(b Board) error {
	_ = fmt.Fprintln // suppress unused import if stub
	panic("not implemented")
}
