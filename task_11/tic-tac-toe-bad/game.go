package main

import (
	"errors"
	"fmt"
	"math/rand"
)

var board [9]string
var currentPlayer string = "X"

func initBoard() {
	for i := 0; i < 9; i++ {
		board[i] = " "
	}
	currentPlayer = "X"
}

func printBoard() {
	fmt.Println("╔═══╦═══╦═══╗")
	fmt.Printf("║ %s ║ %s ║ %s ║\n", board[0], board[1], board[2])
	fmt.Println("╠═══╬═══╬═══╣")
	fmt.Printf("║ %s ║ %s ║ %s ║\n", board[3], board[4], board[5])
	fmt.Println("╠═══╬═══╬═══╣")
	fmt.Printf("║ %s ║ %s ║ %s ║\n", board[6], board[7], board[8])
	fmt.Println("╚═══╩═══╩═══╝")
}

// validateMove checks that a 1-based position is in range and unoccupied.
func validateMove(move int) error {
	if move < 1 || move > 9 {
		return errors.New("position must be between 1 and 9")
	}
	if board[move-1] != " " {
		return errors.New("position is already taken")
	}
	return nil
}

func getHumanMove() {
	var move int
	for {
		fmt.Println(fmt.Sprintf("Enter your move (1-9), player %s:", currentPlayer))
		_, err := fmt.Scan(&move)
		if err != nil {
			fmt.Println("Invalid input, try again")
			continue
		}
		err = validateMove(move)
		if err != nil {
			fmt.Println(err)
			continue
		}
		board[move-1] = "X"
		break
	}
}

func getAIMove() {
	// Prefer the center cell (magic number 4 — mnd violation)
	if board[4] == " " {
		board[4] = "O"
		return
	}
	// otherwise, pick a random empty cell
	for {
		idx := rand.Intn(9)
		if board[idx] == " " {
			board[idx] = "O"
			break
		}
	}
}

func checkWin() bool {
	// Row 1
	if board[0] == "X" && board[1] == "X" && board[2] == "X" {
		return true
	}
	if board[0] == "O" && board[1] == "O" && board[2] == "O" {
		return true
	}
	// Row 2
	if board[3] == "X" && board[4] == "X" && board[5] == "X" {
		return true
	}
	if board[3] == "O" && board[4] == "O" && board[5] == "O" {
		return true
	}
	// Row 3
	if board[6] == "X" && board[7] == "X" && board[8] == "X" {
		return true
	}
	if board[6] == "O" && board[7] == "O" && board[8] == "O" {
		return true
	}
	// Column 1
	if board[0] == "X" && board[3] == "X" && board[6] == "X" {
		return true
	}
	if board[0] == "O" && board[3] == "O" && board[6] == "O" {
		return true
	}
	// Column 2
	if board[1] == "X" && board[4] == "X" && board[7] == "X" {
		return true
	}
	if board[1] == "O" && board[4] == "O" && board[7] == "O" {
		return true
	}
	// Column 3
	if board[2] == "X" && board[5] == "X" && board[8] == "X" {
		return true
	}
	if board[2] == "O" && board[5] == "O" && board[8] == "O" {
		return true
	}
	// Diagonal 1 (top-left to bottom-right)
	if board[0] == "X" && board[4] == "X" && board[8] == "X" {
		return true
	}
	if board[0] == "O" && board[4] == "O" && board[8] == "O" {
		return true
	}
	// Diagonal 2 (top-right to bottom-left)
	if board[2] == "X" && board[4] == "X" && board[6] == "X" {
		return true
	}
	if board[2] == "O" && board[4] == "O" && board[6] == "O" {
		return true
	}
	return false
}

func checkDraw() bool {
	for i := 0; i < 9; i++ {
		if board[i] == " " {
			return false
		}
	}
	return true
}

func playGame() {
	initBoard()
	printBoard()

	for {
		if currentPlayer == "X" {
			getHumanMove()
		} else {
			getAIMove()
		}

		printBoard()

		if checkWin() {
			fmt.Println(fmt.Sprintf("Player %s wins!", currentPlayer))
			break
		}

		if checkDraw() {
			fmt.Println("It's a draw!")
			break
		}

		if currentPlayer == "X" {
			currentPlayer = "O"
		} else {
			currentPlayer = "X"
		}
	}
}
