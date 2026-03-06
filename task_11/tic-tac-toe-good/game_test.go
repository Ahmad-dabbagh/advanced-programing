package tictactoegood_test

import (
	"fmt"
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
		{
			name:       "X wins on first row",
			p1Moves:    []int{1, 2, 3},
			p2Moves:    []int{4, 5},
			wantWinner: ttt.PlayerX,
			wantDraw:   false,
		},
		{
			name:       "O wins on diagonal",
			p1Moves:    []int{2, 3, 4},
			p2Moves:    []int{1, 5, 9},
			wantWinner: ttt.PlayerO,
			wantDraw:   false,
		},
		{
			name: "full board draw",
			p1Moves: []int{1, 3, 4, 8, 9},
			p2Moves: []int{2, 5, 6, 7},
			wantWinner: ttt.Empty,
			wantDraw:   true,
		},
	}
	for _, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			_ = strings.NewReader("")
			out := &bytes.Buffer{}
			

			// convert moves to stdin format
			p1Input := ""
			for _, m := range tc.p1Moves {
				p1Input += fmt.Sprintf("%d\n", m)
			}

			p2Input := ""
			for _, m := range tc.p2Moves {
				p2Input += fmt.Sprintf("%d\n", m)
			}

			p1 := ttt.NewHumanPlayer(ttt.PlayerX, strings.NewReader(p1Input), out)
			p2 := ttt.NewHumanPlayer(ttt.PlayerO, strings.NewReader(p2Input), out)

			renderer := ttt.NewTerminalRenderer(out)

			game := ttt.NewGame(p1, p2, renderer, out)

			result, err := game.Run()
			if err != nil {
				t.Fatalf("Run err = %v", err)
			}

			if result.Draw != tc.wantDraw {
				t.Fatalf("Draw = %v, want %v", result.Draw, tc.wantDraw)
			}

			if result.Winner != tc.wantWinner {
				t.Fatalf("Winner = %q, want %q", result.Winner, tc.wantWinner)
			}

			_ = out
		})
	}
}

