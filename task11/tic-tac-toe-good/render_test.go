package tictactoegood_test

import (
	"bytes"
	"strings"
	"testing"
	ttt "tic-tac-toe-good"
)

func TestTerminalRendererRender(t *testing.T) {
	tests := []struct {
		name        string
		setup       func(b *ttt.Board)
		wantContain string
	}{
		// TODO: empty board contains box chars, X at pos 0 shows X in top-left
	}
	for _, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			b := ttt.NewBoard()
			if tc.setup != nil {
				tc.setup(&b)
			}
			out := &bytes.Buffer{}
			r := ttt.NewTerminalRenderer(out)
			if err := r.Render(b); err != nil {
				t.Fatalf("Render: %v", err)
			}
			if !strings.Contains(out.String(), tc.wantContain) {
				t.Errorf("Render output missing %q\ngot:\n%s", tc.wantContain, out.String())
			}
		})
	}
}
