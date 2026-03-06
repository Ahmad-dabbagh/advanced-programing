# Task_02a: Hello World

**Goal**: Create your first Haskell project and print "Hello World"

## What You'll Do

1. Use `stack new` to create a new Haskell project
2. Examine the generated project structure
3. Build and run your first Haskell program
4. Experiment with GHCi

## Instructions

See [../INSTRUCTIONS.md](../INSTRUCTIONS.md) for detailed step-by-step guidance.

## Quick Start

```bash
cd ~/your-workspace-path
stack new helloworld simple
cd helloworld
stack build
stack run
```

## Expected Output

```bash
Hello World
```

## Key Concepts

- `module Main where` - module declaration
- `main :: IO ()` - type signature for main
- `putStrLn` - print string with newline
- `stack build` - compile your project
- `stack run` - execute the compiled program

## Checkpoint

You're done when:

- [ ] Your project builds without errors
- [ ] Running the program prints "Hello World"
- [ ] You've tried some commands in `stack ghci`
