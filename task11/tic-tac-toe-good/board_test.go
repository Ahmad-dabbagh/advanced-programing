package tictactoegood_test

import (
	"testing"
	ttt "tic-tac-toe-good"
)

func TestNewBoard(t *testing.T) {
	b := ttt.NewBoard()
	for i := 0; i < ttt.CellCount; i++ {
		if got := b.Get(i); got != ttt.Empty {
			t.Errorf("NewBoard: cell %d = %q, want %q", i, got, ttt.Empty)
		}
	}
}

func TestBoardSet(t *testing.T) {
	tests := []struct {
		name    string
		pos     int
		player  ttt.Cell
		wantErr error
	}{
		// TODO: add cases for valid move, out of bounds, cell occupied
	}
	for _, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			b := ttt.NewBoard()
			err := b.Set(tc.pos, tc.player)
			if err != tc.wantErr {
				t.Errorf("Set(%d): err = %v, want %v", tc.pos, err, tc.wantErr)
			}
		})
	}
}

func TestCheckWin(t *testing.T) {
	tests := []struct {
		name  string
		setup func(b *ttt.Board)
		want  ttt.Cell
	}{
		// TODO: add cases for row win, column win, diagonal win, no winner, full board draw
	}
	for _, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			b := ttt.NewBoard()
			tc.setup(&b)
			if got := ttt.CheckWin(b); got != tc.want {
				t.Errorf("CheckWin: got %q, want %q", got, tc.want)
			}
		})
	}
}
