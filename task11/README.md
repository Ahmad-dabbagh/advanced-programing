# Task 11: Professional Go Practices

| Item           | Details                                                    |
| ------------   | ---------------------------------------------------------- |
| **Date**       | Wednesday, 25th of February                                |
| **Deadline**   | Sunday, 15th of March, 23:59                               |
| **OBLIG**      | **NO**                                                     |
| **Type**       | **At-Home**, **individual** submission                     |
| **AI**         | **Do NOT use** — complete this task manually, without AI   |
| **Coding**     | Implement manually; AI assistance is **not allowed**.      |
| **PeerReview** | **No**                                                     |

## Rules

- **No AI tools** — this task must be done manually, without any AI assistance. This is to ensure you practice the skills yourself.
- The project **must** be a new Gitlab project with individual repo. This will be checked.
- The package must be named `tictactoe` (**not** `tictactoegood` as it is right now).
- Submit individually.
- `make ci` must pass with zero lint warnings and all tests green with the default linters from the Makefile.
- Use **semantic commits**. Each commit should represent a single logical change and follow the Conventional Commits format (e.g., `fix: …`, `feat: …`, `test: …`).
- Use **merge requests**. The commits and MR history is part of the assessment. This is for you to practice gitlab workflows with merge requests - even though it is overkill for single person projects. 
- To obtain "C" grade in this course you have to do this task (it is necessary but insufficient condition).

## Overview

In this task you will practice professional Go development by refactoring a poorly-written
Tic-Tac-Toe implementation into a clean, well-structured codebase.

You are given two projects:

- `tic-tac-toe-bad/` — a working but poorly structured Go program with numerous code-quality issues
- `tic-tac-toe-good/` — a skeleton project with proper module separation, interfaces, and test stubs

Your job is to implement all functions marked `panic("not implemented")` in `tic-tac-toe-good/` by porting the business logic from `tic-tac-toe-bad/`. 
All tests must pass and `make ci` must be green.

## Getting Started

```bash
cd tic-tac-toe-good
make ci       # lint + test + build  (must be green when you submit)
make test     # run tests only
make build    # build the binary to bin/tictactoe
```

## Exercise

### Step 1 — Identify the problems

Run `golangci-lint` on `tic-tac-toe-bad/` and read the output carefully.

```bash
golangci-lint run -E gocritic -E gocyclo -E gosec -E mnd -E goconst -E err113
```

The following linters are enabled (see also `.golangci.yml` in the good project):

| Linter      | What it catches                                      |
|-------------|------------------------------------------------------|
| `mnd`       | Magic numbers — unnamed numeric literals             |
| `goconst`   | Repeated string literals that should be constants    |
| `err113`    | Errors created inline instead of as named sentinels  |
| `gocritic`  | Various style and correctness antipatterns           |
| `gocyclo`   | Functions with too-high cyclomatic complexity        |
| `gosec`     | Security issues (weak random, file permissions, …)   |

Create a task for yourself in Gitlab, (new issue) and list every violation and explain in a comment to the issue.
Then in your commits messages link with `#<number_to_issue>` when you addressing and fixing the issues.


### Step 2 — Implement the good version

Port the logic into `tic-tac-toe-good/` function by function.
Fix each class of problem as you go:

- Replace magic numbers with named constants from `board.go`
- Use sentinel errors from `errors.go` instead of inline `errors.New(…)`
- Split the monolithic `checkWin` into small, focused helpers
- Use `crypto/rand` or the modern `math/rand/v2` API — no deprecated `rand.Seed`
- Eliminate global mutable state — pass values explicitly
- Handle every error return; never silently discard with `_`

### Step 3 — Fill in the tests

The test files contain `// TODO` stubs. Complete them so the table-driven tests cover:

- `TestBoardSet`: valid move, out-of-bounds, cell-occupied
- `TestCheckWin`: row win, column win, diagonal win, no winner, full-board draw
- `TestHumanPlayerChooseMove`: valid input, out-of-range, non-numeric
- `TestAIPlayerChooseMove`: AI always picks a valid empty cell
- `TestTerminalRendererRender`: empty board contains box-drawing chars, placed mark appears

### Step 4 — Use semantic commits

Make one commit per logical change (one per function, or one per linter category fixed).
Use the [Conventional Commits](https://www.conventionalcommits.org/) format:

```bash
fix: replace magic numbers with BoardSize constant
feat: implement Board.Set with sentinel error returns
test: add table-driven tests for CheckWin
```

Open a **Merge Request** when done. Review them, accept, and merge into `main`. The commit history and MR discussion is part of the assessment, so make sure to write clear commit messages and explain your changes in the MR description.

Do not squash commits when merging — the granular commit history is important for demonstrating your workflow and understanding of professional Go practices.


