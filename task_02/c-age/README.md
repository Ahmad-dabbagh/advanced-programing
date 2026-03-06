# Task_02c: Age Calculator

**Goal**: Work with numbers, type conversion, and understand type safety

## What You'll Do

1. Copy the pre-generated skeleton project
2. Implement an age calculator in literate Haskell
3. Create generic and type-safe versions of addition
4. Answer questions about type safety

## Instructions

See [../INSTRUCTIONS.md](../INSTRUCTIONS.md) for detailed step-by-step guidance.

## Getting Started

```bash
cp -r age-project ~/your-workspace/
cd ~/your-workspace/age-project
stack build
```

## Example Interaction

```bash
Hi, what is your name?
Mariusz
and what is your age?
21
Hello Mariusz, in 10 years you will be 31.
```

## Type Safety Challenge

Implement two functions:

### `addNumber` - Generic

```haskell
addNumber :: Num a => a -> a -> a
```

Works with any numeric type.

### `addAge` - Type-Safe

```haskell
newtype Age = Age Int

addAge :: Age -> Age -> Age
```

Only accepts Age values, not raw Int.

## Written Questions

Answer these in [ANSWERS.md](./ANSWERS.md):

1. What is the difference between `newtype Age = Age Int` and `type Age = Int`?
2. When should you use strict type safety vs generic functions?

## Key Concepts

- `read :: Read a => String -> a` - parse string to type
- `show :: Show a => a -> String` - convert to string
- `newtype` - create a distinct type with same representation
- `type` - create a type alias (no distinction)
- Type class constraints: `Num a =>`

## Checkpoint

You're done when:

- [ ] Age calculator works correctly
- [ ] `addNumber` works with Int, Float, Double
- [ ] `addAge` only accepts Age values
- [ ] You've answered both questions in ANSWERS.md
