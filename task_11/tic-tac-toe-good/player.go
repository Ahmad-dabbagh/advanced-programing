package tictactoegood

import (
	"bufio"
	"crypto/rand"
	"io"
	"math/big"
	"strconv"
	"strings"
)

// Player represents something that can choose a move and has a symbol (X or O).
type Player interface {
	ChooseMove(b Board) (int, error)
	Symbol() Cell
}

// HumanPlayer reads moves from an input reader.
type HumanPlayer struct {
	symbol Cell
	in     *bufio.Reader
	out    io.Writer
}

// NewHumanPlayer creates a human player.
// The tests and cmd/tictactoe expect this function to exist.
func NewHumanPlayer(symbol Cell, in io.Reader, out io.Writer) *HumanPlayer {
	return &HumanPlayer{
		symbol: symbol,
		in:     bufio.NewReader(in),
		out:    out,
	}
}

func (p *HumanPlayer) Symbol() Cell {
	return p.symbol
}

// ChooseMove expects a number 1..9 and converts it to board index 0..8.
func (p *HumanPlayer) ChooseMove(_ Board) (int, error) {
	line, err := p.in.ReadString('\n')
	if err != nil && err != io.EOF {
		return 0, err
	}

	line = strings.TrimSpace(line)
	if line == "" {
		return 0, ErrInvalidMove
	}

	n, err := strconv.Atoi(line)
	if err != nil {
		return 0, ErrInvalidMove
	}

	if n < 1 || n > CellCount {
		return 0, ErrOutOfBounds
	}

	return n - 1, nil
}

// AIPlayer picks a legal random move.
type AIPlayer struct {
	symbol Cell
}

// NewAIPlayer creates an AI player.
// The tests expect this function to exist.
func NewAIPlayer(symbol Cell) *AIPlayer {
	return &AIPlayer{symbol: symbol}
}

func (p *AIPlayer) Symbol() Cell {
	return p.symbol
}

func (p *AIPlayer) ChooseMove(b Board) (int, error) {
	empties := make([]int, 0, CellCount)
	for i := 0; i < CellCount; i++ {
		if b[i] == Empty {
			empties = append(empties, i)
		}
	}

	if len(empties) == 0 {
		return 0, ErrGameOver
	}

	// crypto/rand to satisfy gosec (no math/rand)
	nBig, err := rand.Int(rand.Reader, big.NewInt(int64(len(empties))))
	if err != nil {
		return 0, err
	}

	return empties[int(nBig.Int64())], nil
}
