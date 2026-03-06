package tictactoegood_test

import (
	"bytes"
	"errors"
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
		{
			name:    "valid input",
			input:   "5\n",
			wantPos: 4,
			wantErr: nil,
		},
		{
			name:    "out of range",
			input:   "10\n",
			wantPos: 0,
			wantErr: ttt.ErrOutOfBounds,
		},
		{
			name:    "non numeric",
			input:   "abc\n",
			wantPos: 0,
			wantErr: ttt.ErrInvalidMove,
		},
	}

	for _, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			in := strings.NewReader(tc.input)
			out := &bytes.Buffer{}

			p := ttt.NewHumanPlayer(ttt.PlayerX, in, out)
			b := ttt.NewBoard()

			pos, err := p.ChooseMove(b)

			if tc.wantErr == nil {
				if err != nil {
					t.Fatalf("ChooseMove: err = %v, want nil", err)
				}
				if pos != tc.wantPos {
					t.Fatalf("ChooseMove: pos = %d, want %d", pos, tc.wantPos)
				}
				return
			}

			if !errors.Is(err, tc.wantErr) {
				t.Fatalf("ChooseMove: err = %v, want %v", err, tc.wantErr)
			}
		})
	}
}

func TestAIPlayerChooseMove(t *testing.T) {
	p := ttt.NewAIPlayer(ttt.PlayerO)

	t.Run("chooses only empty in-bounds positions", func(t *testing.T) {
		b := ttt.NewBoard()

		// Occupy some cells
		_ = b.Set(0, ttt.PlayerX)
		_ = b.Set(4, ttt.PlayerO)

		for i := 0; i < 50; i++ {
			pos, err := p.ChooseMove(b)
			if err != nil {
				t.Fatalf("ChooseMove: err = %v, want nil", err)
			}
			if pos < 0 || pos >= ttt.CellCount {
				t.Fatalf("ChooseMove: pos = %d out of bounds", pos)
			}
			if b.Get(pos) != ttt.Empty {
				t.Fatalf("ChooseMove: pos = %d not empty", pos)
			}
		}
	})

	t.Run("full board returns ErrGameOver", func(t *testing.T) {
		b := ttt.NewBoard()
		for i := 0; i < ttt.CellCount; i++ {
			_ = b.Set(i, ttt.PlayerX)
		}

		_, err := p.ChooseMove(b)
		if !errors.Is(err, ttt.ErrGameOver) {
			t.Fatalf("ChooseMove: err = %v, want %v", err, ttt.ErrGameOver)
		}
	})
}
