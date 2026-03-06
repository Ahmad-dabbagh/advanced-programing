# Task 10: Punto

| Item           | Details                                                |
|----------------|--------------------------------------------------------|
| **Date**       | Wednesday, 18th of February                            |
| **Deadline**   | Wednesday, 4th of March, 08:00                         |
| **OBLIG**      | **NO**                                                 |
| **Type**       | **At-Home**, **individual** submission                 |
| **AI**         | **Use** - use AI for help, explanations and coding     |
| **Coding**     | Code as much with the help of AI.                      |
| **PeerReview** | **YES** - This task will be peer-reviewed.             |

## Overview

In this task, you will implement the card game **Punto** in Haskell, using a GUI or text-based terminal UI framework of your choice.

Rules of the game: https://gf-api.gamefactory-games.com/spielanleitungen/646214_en.pdf

A short video overview of the rules and gameplay: https://www.youtube.com/watch?v=BeLhh-yb8Hk

Read both before you start. Write your own SPEC.md summarising your interpretation of the rules and any decisions you make.

## Requirements

- Implement Punto for 2–4 players (human or AI-controlled)
- Use any Haskell GUI or terminal UI framework. Options include:
  - **Brick** — terminal/text-based UI (recommended for simplicity)
  - **Gloss** — 2D vector graphics
  - **SDL2** — hardware-accelerated graphics
  - **GTK** — widget-based UI
  - Ask in `#haskell` before picking a dependency to make sure it works in the course environment
- Separate modules for game logic, rendering, and state management
- All pure functions tested with `doctests`

## Playing against computer

Implement simple logic such that the game can be played by a human against bots (1 or 2).
The computer should only be able to make legal moves. 
The computer should have varying level of "intelligence" to make good moves in the game,
but the computer should NOT cheat (by knowing the order of the cards it has, or by cheating with the cards).
Implement simple heuristics in order for the computer.

## Project Structure

Your submission must include:

- **SPEC.md** — your game specification: rules you implemented, any variants or decisions, and non-functional details
- **AI.md** — how you used AI tools during development; what worked, what didn't, where you needed manual help
- Well-structured Haskell source with clear module separation

## Final Remarks

- Submit individually.
- Work in groups to solve dependency and tooling problems.
- Use AI as much as you can — ask AI, ask other students, ask TAs.
- There will be a Peer Review for this task.
