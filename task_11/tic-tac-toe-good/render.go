package tictactoegood

import (
	"fmt"
	"io"
)

type Renderer interface {
	Render(b Board) error
}

type TerminalRenderer struct {
	out io.Writer
}

func NewTerminalRenderer(out io.Writer) *TerminalRenderer {
	return &TerminalRenderer{out: out}
}

func cellToPrintable(c Cell) string {
	if c == Empty {
		return " "
	}
	return string(c)
}

const (
	i0 = 0
	i1 = 1
	i2 = 2
	i3 = 3
	i4 = 4
	i5 = 5
	i6 = 6
	i7 = 7
	i8 = 8
)

func (r *TerminalRenderer) Render(b Board) error {
	if _, err := fmt.Fprintln(r.out, "╔═══╦═══╦═══╗"); err != nil {
		return err
	}

	if _, err := fmt.Fprintf(r.out, "║ %s ║ %s ║ %s ║\n",
		cellToPrintable(b.Get(i0)),
		cellToPrintable(b.Get(i1)),
		cellToPrintable(b.Get(i2)),
	); err != nil {
		return err
	}

	if _, err := fmt.Fprintln(r.out, "╠═══╬═══╬═══╣"); err != nil {
		return err
	}

	if _, err := fmt.Fprintf(r.out, "║ %s ║ %s ║ %s ║\n",
		cellToPrintable(b.Get(i3)),
		cellToPrintable(b.Get(i4)),
		cellToPrintable(b.Get(i5)),
	); err != nil {
		return err
	}

	if _, err := fmt.Fprintln(r.out, "╠═══╬═══╬═══╣"); err != nil {
		return err
	}

	if _, err := fmt.Fprintf(r.out, "║ %s ║ %s ║ %s ║\n",
		cellToPrintable(b.Get(i6)),
		cellToPrintable(b.Get(i7)),
		cellToPrintable(b.Get(i8)),
	); err != nil {
		return err
	}

	_, err := fmt.Fprintln(r.out, "╚═══╩═══╩═══╝")
	return err
}
