package tictactoegood_test

import (
	"bytes"
	"strings"
	"testing"
	ttt "tic-tac-toe-good"
)

func TestHumanPlayerChooseMove(t *testing.T) {
	tests := []struct {
		name    string
		input   string
		wantPos int
		wantErr error
	}{
		// TODO: valid input "5\n" -> pos 4, out of range "10\n" -> ErrOutOfBounds, non-numeric "abc\n" -> ErrInvalidMove
	}
	for _, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			in := strings.NewReader(tc.input)
			out := &bytes.Buffer{}
			p := ttt.NewHumanPlayer(ttt.PlayerX, in, out)
			b := ttt.NewBoard()
			pos, err := p.ChooseMove(b)
			if err != tc.wantErr {
				t.Errorf("ChooseMove: err = %v, want %v", err, tc.wantErr)
			}
			if err == nil && pos != tc.wantPos {
				t.Errorf("ChooseMove: pos = %d, want %d", pos, tc.wantPos)
			}
		})
	}
}

func TestAIPlayerChooseMove(t *testing.T) {
	// TODO: verify AI always returns a valid empty cell position
}
