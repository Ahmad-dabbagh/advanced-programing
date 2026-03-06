package tictactoegood_test

import (
	"bytes"
	"strings"
	"testing"
	ttt "tic-tac-toe-good"
)

func TestGameRun(t *testing.T) {
	tests := []struct {
		name       string
		p1Moves    []int // pre-scripted moves for player 1
		p2Moves    []int // pre-scripted moves for player 2
		wantWinner ttt.Cell
		wantDraw   bool
	}{
		// TODO: X wins on first row, O wins on diagonal, full board draw
	}
	for _, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			_ = strings.NewReader("")
			out := &bytes.Buffer{}
			// TODO: construct scripted players, run game, assert result
			_ = out
		})
	}
}
