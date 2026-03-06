# Task_02b: Hello Name

**Goal**: Read user input and respond with a personalized greeting

## What You'll Do

1. Extend your Hello World project
2. Use `getLine` to read user input
3. Use `do` notation to sequence IO actions
4. Concatenate strings

## Instructions

See [../INSTRUCTIONS.md](../INSTRUCTIONS.md) for detailed step-by-step guidance.

## Example Interaction

```bash
What is your name?
Mariusz
Hello Mariusz
```

## Key Code

```haskell
module Main where

main :: IO ()
main = do
  putStrLn "What is your name?"
  name <- getLine
  putStrLn ("Hello " ++ name)
```

## Key Concepts

- `do` notation - sequencing IO actions
- `<-` operator - binding result of IO action to a variable
- `getLine :: IO String` - read a line from standard input
- `++` - string concatenation
- `<>` - alternative concatenation (Semigroup)

## Checkpoint

You're done when:

- [ ] Your program prompts for a name
- [ ] It reads the input correctly
- [ ] It prints a personalized greeting
- [ ] You understand how `<-` differs from `=`
