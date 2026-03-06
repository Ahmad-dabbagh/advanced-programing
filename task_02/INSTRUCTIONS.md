# Task 02: Step-by-Step Instructions

This guide walks you through each subtask in detail. Work through them in order.

---

## Prerequisites

Before starting, verify your setup:

```bash
# Check stack is installed
stack --version

# If not installed, see: https://docs.haskellstack.org/en/stable/install_and_upgrade/
```

---

## Task_02a: Hello World

**Goal**: Create your first Haskell project and print "Hello World"

### Step a.1: Create a New Project

Open your terminal and navigate to your workspace:

```bash
cd ~/your-workspace-path
stack new helloworld simple
cd helloworld
```

This creates a minimal project structure:

```bash
helloworld/
├── ... (markdown files)
├── helloworld.cabal
├── Setup.hs
├── stack.yaml
└── src/Main.hs
```

### Step a.2: Examine the Generated Files

Open `Main.hs` and study its contents:

```haskell
module Main where

main :: IO ()
main = do
  putStrLn "hello world"
```

**Key concepts**:

- `module Main where` - declares the main module
- `main :: IO ()` - type signature: main returns an IO action with no result
- `putStrLn` - prints a string with newline

### Step a.3: Build and Run

```bash
stack build
stack run
```

You should see: `hello world`

### Step a.4: Modify the Output

Edit `Main.hs` to print exactly "Hello World" (with capital letters):

```haskell
main :: IO ()
main = putStrLn "Hello World"
```

Rebuild and verify:

```bash
stack build && stack run
```

### Step a.5: Experiment in GHCi

```bash
stack ghci
```

Try these commands:

```haskell
putStrLn "Hello World"
:type putStrLn
:info String
:quit
```

**Checkpoint**: You should have a working "Hello World" program.

---

## Task_02b: Hello Name

**Goal**: Read user input and respond with a greeting

### Step b.1: Understanding IO

In Haskell, IO operations are sequenced using `do` notation:

```haskell
main :: IO ()
main = do
  -- action 1
  -- action 2
  -- action 3
```

### Step b.2: Reading Input

The function `getLine :: IO String` reads a line of text from standard input.

Modify your `Main.hs`:

```haskell
module Main where

main :: IO ()
main = do
  putStrLn "What is your name?"
  name <- getLine
  putStrLn ("Hello " ++ name)
```

**Key concepts**:

- `name <- getLine` - binds the result of an IO action to a variable
- `++` - string concatenation operator

### Step b.3: Test Your Program

```bash
stack build && stack run
```

Expected interaction:

```bash
What is your name?
Mariusz
Hello Mariusz
```

### Step b.4: Alternative Concatenation

You can also use `concat` or the `<>` operator:

```haskell
putStrLn (concat ["Hello ", name])
-- or
putStrLn ("Hello " <> name)
```

**Checkpoint**: Your program asks for a name and greets the user.

---

## Task_02c: Age Calculator

**Goal**: Work with numbers and understand type safety

For this subtask, use the pre-generated skeleton in:

```bash
c-age/age-project/
```

### Step c.1: Copy the Skeleton

```bash
cp -r c-age/age-project ~/your-workspace/
cd ~/your-workspace/age-project
```

### Step c.2: Open the Literate Haskell File

Open `src/Main.lhs` in your editor. This is a **literate Haskell** file where:

- Regular text is documentation
- Lines starting with `>` are Haskell code

### Step c.3: Implement the Age Calculator

Your program should:

1. Ask for the user's name
2. Ask for their age
3. Calculate age + 10
4. Print the result

Example interaction:

```bash
Hi, what is your name?
Mariusz
and what is your age?
21
Hello Mariusz, in 10 years you will be 31.
```

**Hints**:

- Use `read :: String -> Int` to convert strings to numbers
- Use `show :: Int -> String` to convert numbers to strings

### Step c.4: Type Safety Challenge

In the same file, implement two functions:

#### `addNumber` (Generic)

```haskell
addNumber :: Num a => a -> a -> a
```

This should work with any numeric type (Int, Float, Double, etc.)

#### `addAge` (Type-Safe)

First, define a custom type:

```haskell
newtype Age = Age Int
```

Then implement:

```haskell
addAge :: Age -> Age -> Age
```

### Step c.5: Answer the Questions

In `c-age/ANSWERS.md`, explain:

1. What is the difference between Version A (`newtype`) and Version B (type alias)?
2. When would you use strict type safety vs generic functions?

### Step c.6: Build and Test

```bash
stack build
stack run
```

**Checkpoint**: Age calculator works and you understand type safety concepts.

---

## Task_02d: mhead Function

**Goal**: Implement your own `head` function multiple ways, with tests

Use the pre-generated skeleton in:

```bash
d-mhead/mhead-project/
```

### Step d.1: Copy the Skeleton

```bash
cp -r d-mhead/mhead-project ~/your-workspace/
cd ~/your-workspace/mhead-project
```

### Step d.2: Implement mhead (Multiple Ways)

Open `src/Lib.lhs` and implement `mhead` in at least 3 different ways:

#### Way 1: Pattern Matching

```haskell
mhead1 :: [a] -> a
mhead1 (x:_) = x
```

#### Way 2: Using `!!`

```haskell
mhead2 :: [a] -> a
mhead2 xs = xs !! 0
```

#### Way 3: Using `take` and Pattern Matching

```haskell
mhead3 :: [a] -> a
mhead3 xs = let [x] = take 1 xs in x
```

#### Way 4: Using `foldr1`

```haskell
mhead4 :: [a] -> a
mhead4 = foldr1 (\x _ -> x)
```

Try to discover more implementations yourself!

### Step d.3: Add Doctests

Add documentation and doctests to each implementation:

```haskell
-- | mhead1 returns the first element using pattern matching
--
-- >>> mhead1 [1,2,3]
-- 1
--
-- >>> mhead1 "Hello"
-- 'H'
```

### Step d.4: Run Doctests

```bash
stack test
```

### Step d.5: Add QuickCheck Property Tests

Open `test/Spec.hs` and add property tests comparing your implementation to `head`:

```haskell
import Test.Hspec
import Test.QuickCheck
import Lib

main :: IO ()
main = hspec $ do
  describe "mhead1" $ do
    it "behaves like head for non-empty lists" $ property $
      \xs -> not (null (xs :: [Int])) ==> mhead1 xs == head xs
```

The property states: "For any non-empty list, mhead1 returns the same result as head"

### Step d.6: Run All Tests

```bash
stack test
```

**Checkpoint**: Multiple mhead implementations with passing doctests and property tests.

---

## Summary

After completing all subtasks, you should have:

1. **helloworld project** - Task_02a & Task_02b
2. **age-project** - Task_02c with type safety
3. **mhead-project** - Task_02d with tests
4. **Answers file** - Written explanations

See [SUBMISSION.md](./SUBMISSION.md) for how to submit your work.

---

## Troubleshooting

### "Could not find module"

Run `stack build` first, then `stack ghci`

### "Couldn't match type"

Check your type signatures match the implementations

### "parse error"

Check indentation - Haskell is indentation-sensitive

### Doctests not running

Make sure `doctest` is in your dependencies (see package.yaml)
