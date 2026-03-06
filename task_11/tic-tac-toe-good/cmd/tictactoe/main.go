package main

import (
	"fmt"
	"os"

	ttt "tic-tac-toe-good"
)

var version = "0.0.0-dev"

func main() {
	fmt.Fprintf(os.Stdout, "tic-tac-toe %s\n", version)

	renderer := ttt.NewTerminalRenderer(os.Stdout)
	human := ttt.NewHumanPlayer(ttt.PlayerX, os.Stdin, os.Stdout)
	ai := ttt.NewAIPlayer(ttt.PlayerO)

	game := ttt.NewGame(human, ai, renderer, os.Stdout)

	result, err := game.Run()
	if err != nil {
		fmt.Fprintf(os.Stderr, "game error: %v\n", err)
		os.Exit(1)
	}

	if result.Draw {
		fmt.Fprintln(os.Stdout, "It's a draw!")
		return
	}
	fmt.Fprintf(os.Stdout, "Player %s wins!\n", result.Winner)
}
