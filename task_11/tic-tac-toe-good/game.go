package tictactoegood

import (
	"errors"
	"io"
)

type Result struct {
	Winner Cell
	Draw   bool
}

type Game struct {
	board   Board
	players [2]Player
	render  Renderer
	out     io.Writer
}

func NewGame(p1, p2 Player, r Renderer, out io.Writer) *Game {
	return &Game{
		board:   NewBoard(),
		players: [2]Player{p1, p2},
		render:  r,
		out:     out,
	}
}

func (g *Game) Run() (Result, error) {

	if err := g.render.Render(g.board); err != nil {
		return Result{}, err
	}

	turn := 0

	for {

		if g.board.IsFull() {
			return Result{Winner: Empty, Draw: true}, nil
		}

		current := g.players[turn%2]

		for {

			move, err := current.ChooseMove(g.board)

			if err != nil {

				if errors.Is(err, ErrGameOver) {
					return Result{Winner: Empty, Draw: true}, nil
				}

				if errors.Is(err, ErrInvalidMove) ||
					errors.Is(err, ErrOutOfBounds) ||
					errors.Is(err, ErrCellOccupied) {
					continue
				}

				return Result{}, err
			}

			if err := g.board.Set(move, current.Symbol()); err != nil {

				if errors.Is(err, ErrInvalidMove) ||
					errors.Is(err, ErrOutOfBounds) ||
					errors.Is(err, ErrCellOccupied) {
					continue
				}

				return Result{}, err
			}

			break
		}

		if err := g.render.Render(g.board); err != nil {
			return Result{}, err
		}

		if winner := CheckWin(g.board); winner != Empty {
			return Result{Winner: winner}, nil
		}

		if g.board.IsFull() {
			return Result{Draw: true}, nil
		}

		turn++
	}
}
