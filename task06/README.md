# Task 06: Galactic Greetings

| Item           | Details                                                |
|----------------|--------------------------------------------------------|
| **Date**       | Wednesday, 4th of February                             |
| **Deadline**   | Wednesday, 4th of February, 12:15 (end of class)       |
| **OBLIG**      | No                                                     |
| **Type**       | In-Class, **Individual** submission                    |
| **AI**         | **Do not use** for code generation                     |
| **Coding**     | Code it all yourself, by hand                          |
| **PeerReview** | No                                                     |

---

## Overview

Earth has received signals from an extraterrestrial civilization! Your mission is to decode these cosmic transmissions using Haskell's error handling capabilities with `Maybe` and `Either` types.

This task focuses on composing validation checks **elegantly** using the bind operator `(>>=)` and applicative operators `<$>` and `<*>`.

---

## Learning Objectives

### Core Skills (demonstrate without help)

- Use `Maybe` type for computations that might fail
- Use `Either` type for computations with informative error messages
- Compose validation checks **elegantly** composing the solution from building blocks, e.g.
  - Use bind operator `(>>=)`
  - Use applicative operators `<$>` and `<*>` for elegant composition 
  - Chain multiple validation steps without do-notation
  - Design modular validation pipelines
- Write pure functions with comprehensive doctests

---

### Maybe Type

```haskell
-- Maybe represents optional values
data Maybe a = Nothing | Just a

-- Safe division example
safeDiv :: Int -> Int -> Maybe Int
safeDiv _ 0 = Nothing
safeDiv x y = Just (x `div` y)
```

### Either Type

```haskell
-- Either for errors with messages
data Either a b = Left a | Right b

-- Left = error, Right = success
safeDivE :: Int -> Int -> Either String Int
safeDivE _ 0 = Left "Division by zero"
safeDivE x y = Right (x `div` y)
```

### Bind Operator (>>=)

```haskell
-- Chain computations that might fail
(>>=) :: Maybe a -> (a -> Maybe b) -> Maybe b

-- Example: chain two operations
Just 10 >>= safeDiv 100 >>= safeDiv 2
-- Result: Just 5

Nothing >>= safeDiv 100
-- Result: Nothing
```

### Applicative Operators

```haskell
-- Apply function inside functor
(<$>) :: Functor f => (a -> b) -> f a -> f b
(+1) <$> Just 5  -- Just 6

-- Apply wrapped function to wrapped value
(<*>) :: Applicative f => f (a -> b) -> f a -> f b
Just (+) <*> Just 3 <*> Just 4  -- Just 7
```

---

## Task_06: Galactic Greetings Decoder

**Goal**: Decode extraterrestrial transmissions using validation with Maybe and Either

### The Story

Earth has received cosmic transmissions - sequences of positive integers from an alien civilization. Communication is only possible if certain conditions are met!

### Transmission Decoding Rules

1. **Unique Min-Max**: The minimum and maximum numbers must each appear exactly once (be unique)
2. **Even Sum**: The sum of minimum and maximum must be even (divisible by 2)
3. **The Message**: Count occurrences of `(min + max) / 2` - that's the cosmic message!

### Example

For transmission: `5 5 5 8 1 2 3 4 9 8 2 3 4`

- Minimum: 1 (unique)
- Maximum: 9 (unique)
- Sum: 10 (even)
- Magic number: (1 + 9) / 2 = 5
- Count of 5s: 3
- **The message is 3!**

For transmission: `5 5 5 8 1 2 3 4 9 8 2 3 4 1`

- Minimum: 1 (appears twice - NOT unique!)
- **Communication interference detected!**

### Constraints

All of the below must be completed:

- Use bind operator `(>>=)` and/or applicative operators `<$>` and `<*>` to compose validation checks
- All code written **without** `do-notation`
- IMPORTANT - Do not use `mapM` or `mapM_` (AI likes to suggest it)

### GHCi Exploration

```bash
cd task_06 && stack ghci
```

Try:

```haskell
-- Test Maybe operations
Just 5 >>= \x -> Just (x * 2)
Nothing >>= \x -> Just (x * 2)

-- Test Either operations
Right 5 >>= \x -> Right (x * 2)
Left "error" >>= \x -> Right (x * 2)

-- Applicative style
(+) <$> Just 3 <*> Just 4
```

### Run Tests

```bash
cd task_06 && stack test
```

**Remember**: Do NOT use AI assistants for this task.
