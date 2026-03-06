package tictactoegood_test

import (
	"errors"
	"testing"

	ttt "tic-tac-toe-good"
)

func TestNewBoard(t *testing.T) {
	b := ttt.NewBoard()

	for i := 0; i < ttt.CellCount; i++ {
		if b.Get(i) != ttt.Empty {
			t.Fatalf("expected empty board")
		}
	}
}

func TestBoardSet(t *testing.T) {

	tests := []struct {
		name    string
		setup   func(*ttt.Board)
		pos     int
		player  ttt.Cell
		wantErr error
	}{
		{"valid", nil, 0, ttt.PlayerX, nil},

		{"out of bounds", nil, -1, ttt.PlayerX, ttt.ErrOutOfBounds},

		{
			"cell occupied",
			func(b *ttt.Board) {
				_ = b.Set(4, ttt.PlayerO)
			},
			4,
			ttt.PlayerX,
			ttt.ErrCellOccupied,
		},
	}

	for _, tc := range tests {

		t.Run(tc.name, func(t *testing.T) {

			b := ttt.NewBoard()

			if tc.setup != nil {
				tc.setup(&b)
			}

			err := b.Set(tc.pos, tc.player)

			if tc.wantErr == nil {
				if err != nil {
					t.Fatalf("unexpected error: %v", err)
				}
				return
			}

			if !errors.Is(err, tc.wantErr) {
				t.Fatalf("expected %v got %v", tc.wantErr, err)
			}
		})
	}
}
