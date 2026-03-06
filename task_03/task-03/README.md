# Task 03: Lists and Functional Patterns

| Item           | Details                                                |
|----------------|--------------------------------------------------------|
| **Date**       | Wednesday, 21st of January                             |
| **Deadline**   | Wednesday, 04th of February, 8:00 (start of class)     |
| **OBLIG**      | **YES** - This task is part of OBLIGATORY work         |
| **Type**       | **At-Home**, Group Activity, **individual** submission |
| **AI**         | **Do not use**                                         |
| **Coding**     | Code it all yourself, by hand                          |
| **PeerReview** | No                                                     |

---

## Overview

This task builds on Task_02, introducing data structures and functional patterns:

| Subtask                                 | Topic               | Key Concepts                                      |
|-----------------------------------------|---------------------|---------------------------------------------------|
| [a-tuples](./a-tuples/)                 | Tuples              | Pairs, triples, fst, snd, pattern matching        |
| [b-lists](./b-lists/)                   | Lists               | Construction, comprehensions, basic operations    |
| [c-map](./c-map/)                       | Map                 | Transforming lists, lambdas, function composition |
| [d-recursion-fold](./d-recursion-fold/) | Recursion & Folding | Recursive patterns, `foldr`, `foldl`              |

---

## Learning Objectives

By the end of this task, you should be able to:

### Core Skills (demonstrate without help)

- Create and deconstruct tuples
- Use `fst` and `snd` for pairs
- Pattern match on tuples
- Construct lists using `:` and `[]`
- Use basic list functions: `length`, `null`, `reverse`, `take`, `drop`
- Write list comprehensions
- Apply `map` to transform lists
- Write lambda expressions

### Extended Skills (with help from online resources)

- Implement recursive functions on lists
- Use `foldr` and `foldl`
- Recognize common fold patterns

---

## Prerequisites

- Completed Task_02
- Comfortable with `stack build`, `stack test`, `stack ghci`
- Basic understanding of functions and types

### Recommended Versions

| Tool  | Version |
|-------|---------|
| Stack | 3.9.1   |
| GHC   | 9.10.3  |
| LTS   | 24.28   |

Verify your stack version:

```bash
stack --version
```

---

## Resources

- Haskell books
- GHCi (interactive interpreter)
- [Hoogle](https://hoogle.haskell.org) - Haskell API search
- Task_02 materials (review as needed)

---

## Quick Reference

### Tuples

```haskell
pair :: (Int, String)
pair = (42, "hello")

fst pair        -- 42
snd pair        -- "hello"

let (x, y) = pair  -- pattern match
```

### Lists

```haskell
list :: [Int]
list = [1, 2, 3]       -- sugar for 1:2:3:[]

head list              -- 1
tail list              -- [2, 3]
length list            -- 3
list !! 1              -- 2 (index)
[1..5]                 -- [1,2,3,4,5]
[x * 2 | x <- [1..3]]  -- [2,4,6]
```

### Map and Lambda

```haskell
map (*2) [1,2,3]         -- [2,4,6]
map (\x -> x + 1) [1,2]  -- [2,3]
```

### Folding

```haskell
foldr (-) 0 [1,2,3]  --  2 (right fold)
foldl (-) 0 [1,2,3]  -- -6 (left fold)
```

---

## Task_03a: Tuples

**Goal**: Work with tuples - fixed-size collections of different types

### What You'll Learn

- Creating pairs `(a, b)` and triples `(a, b, c)`
- Using `fst` and `snd` for pairs
- Pattern matching on tuples
- Functions that return tuples

### Key Concepts

**Pairs:**

```haskell
pair :: (Int, String)
pair = (42, "hello")

fst pair   -- 42
snd pair   -- "hello"
```

**Pattern Matching:**

```haskell
let (x, y) = (1, 2)
-- x is 1, y is 2

addPair :: (Int, Int) -> Int
addPair (a, b) = a + b
```

**Triples (use pattern matching - no built-in fst/snd):**

```haskell
getFirst :: (a, b, c) -> a
getFirst (x, _, _) = x
```

### GHCi Exploration

```bash
cd a-tuples && stack ghci
```

Try:

```haskell
let pair = (1, "hello")
fst pair
snd pair
let (x, y) = pair
x
y
let triple = (1, 2, 3)
```

### Functions to Implement

Complete the TODOs in `src/Tuples.lhs`:

- `swap` - swap elements of a pair
- `addPairs` - add corresponding elements of two pairs
- `firstOfThree` - get first element of a triple
- Functions that return tuples

### Run Tests

```bash
cd a-tuples && stack test
```

### Checkpoint

You're done when:

- `swap` reverses pair elements
- `addPairs` adds corresponding elements
- Can extract elements from triples
- Can write functions returning tuples
- All tests pass

---

## Task_03b: Lists

**Goal**: Construct and manipulate lists, understand list structure

### What You'll Learn

- List construction with `:` and `[]`
- List operations: `head`, `tail`, `++`, `length`, etc.
- List comprehensions
- Implementing basic operations yourself

### Key Concepts

**List Construction:**

```haskell
[1, 2, 3]           -- list literal
1 : 2 : 3 : []      -- same thing, explicit cons
[1..10]             -- range
[1,3..10]           -- range with step
```

**Basic Operations:**

```haskell
head [1,2,3]        -- 1
tail [1,2,3]        -- [2,3]
[1,2] ++ [3,4]      -- [1,2,3,4]
length [1,2,3]      -- 3
null []             -- True
reverse [1,2,3]     -- [3,2,1]
take 2 [1,2,3,4]    -- [1,2]
drop 2 [1,2,3,4]    -- [3,4]
[1,2,3] !! 1        -- 2 (index)
```

**List Comprehensions:**

```haskell
[x * 2 | x <- [1..5]]                    -- [2,4,6,8,10]
[x | x <- [1..10], even x]               -- [2,4,6,8,10]
[(x,y) | x <- [1,2], y <- ['a','b']]     -- [(1,'a'),(1,'b'),(2,'a'),(2,'b')]
```

### GHCi Exploration

```bash
cd b-lists && stack ghci
```

Try:

```haskell
[1, 2, 3]
1 : 2 : 3 : []
[1..10]
[1,3..10]
['a'..'z']
head [1,2,3]
tail [1,2,3]
[1,2,3] ++ [4,5]
length [1,2,3]
null []
reverse [1,2,3]
take 2 [1,2,3,4,5]
drop 2 [1,2,3,4,5]
[x * 2 | x <- [1..5]]
[x | x <- [1..10], even x]
[(x, y) | x <- [1,2], y <- ['a','b']]
```

### Functions to Implement

Complete the TODOs in `src/Lists.lhs`:

- `mlength` - count elements (without using `length`)
- `mreverse` - reverse a list (without using `reverse`)
- `mconcat` - concatenate two lists (without using `++`)
- List comprehension exercises

### Run Tests

```bash
cd b-lists && stack test
```

### Checkpoint

You're done when:

- `mlength` counts elements (no `length`)
- `mreverse` reverses (no `reverse`)
- `mconcat` concatenates (no `++`)
- List comprehension exercises complete
- All tests pass

---

## Task_03c: Map

**Goal**: Transform lists using `map` and lambda expressions

### What You'll Learn

- Using `map` to apply a function to every element
- Writing lambda expressions `\x -> ...`
- Implementing your own `mmap`
- Function composition

### Key Concepts

**The map Function:**

```haskell
map :: (a -> b) -> [a] -> [b]

map (+1) [1,2,3]        -- [2,3,4]
map (*2) [1,2,3]        -- [2,4,6]
map show [1,2,3]        -- ["1","2","3"]
map length ["hi","hey"] -- [2,3]
```

**Lambda Expressions (anonymous functions):**

```haskell
\x -> x + 1             -- function that adds 1
\x -> x * x             -- function that squares
\x y -> x + y           -- function of two arguments

(\x -> x + 1) 5         -- 6
map (\x -> x * x) [1,2,3]  -- [1,4,9]
```

**Partial Application:**

```haskell
add :: Int -> Int -> Int
add x y = x + y

add 1       -- a function waiting for second arg
map (add 1) [1,2,3]  -- same as map (+1) [1,2,3]
```

### GHCi Exploration

```bash
cd c-map && stack ghci
```

Try:

```haskell
map (+1) [1,2,3]
map (*2) [1,2,3]
map show [1,2,3]
map length ["hi", "hello", "hey"]
\x -> x + 1
(\x -> x + 1) 5
map (\x -> x * x) [1,2,3]
\x y -> x + y
(\x y -> x + y) 3 4
```

### Functions to Implement

Complete the TODOs in `src/Mapping.lhs`:

- Use `map` with named functions
- Use `map` with lambda expressions
- Implement `mmap` - your own version of map
- Function composition with `map`

### Run Tests

```bash
cd c-map && stack test
```

### Checkpoint

You're done when:
- Used `map` with named functions
- Used `map` with lambda expressions
- Implemented `mmap` yourself
- Understand partial application
- All tests pass

---

## Task_03d: Recursion and Folding

**Goal**: Implement recursive functions and understand fold patterns

### What You'll Learn

- Recursive functions with base case and recursive case
- `foldr` (right fold)
- `foldl` (left fold)
- Recognizing fold patterns

### Key Concepts

**Recursion Pattern:**

```haskell
myFunc []     = baseCase       -- what to return for empty list
myFunc (x:xs) = ... x ... myFunc xs ...  -- use head, recurse on tail
```

**foldr (Right Fold):**

```haskell
foldr :: (a -> b -> b) -> b -> [a] -> b

-- Conceptually:
foldr f z [1,2,3] = f 1 (f 2 (f 3 z))
                  = 1 `f` (2 `f` (3 `f` z))

-- Examples:
foldr (+) 0 [1,2,3]   -- 6
foldr (*) 1 [1,2,3]   -- 6
foldr (:) [] [1,2,3]  -- [1,2,3]
```

**foldl (Left Fold):**

```haskell
foldl :: (b -> a -> b) -> b -> [a] -> b

-- Conceptually:
foldl f z [1,2,3] = f (f (f z 1) 2) 3
                  = ((z `f` 1) `f` 2) `f` 3

-- For (+) and (*), same result as foldr
-- For (-) and non-commutative ops, different!
```

**When They Differ:**

```haskell
foldr (-) 0 [1,2,3]  -- 1 - (2 - (3 - 0)) = 2
foldl (-) 0 [1,2,3]  -- ((0 - 1) - 2) - 3 = -6
```

### GHCi Exploration

```bash
cd d-recursion-fold && stack ghci
```

Try:

```haskell
foldr (+) 0 [1,2,3]
foldl (+) 0 [1,2,3]
foldr (:) [] [1,2,3]
foldr (-) 0 [1,2,3]
foldl (-) 0 [1,2,3]  -- different result!
```

### Functions to Implement

Complete the TODOs in `src/Recursion.lhs`:

- `msum` - sum of list (recursive, then with fold)
- `mproduct` - product of list
- `mand` - all True?
- `mor` - any True?
- `mlength` using fold

For each function, implement:

1. Recursive version
2. `foldr` version
3. `foldl` version (where applicable)

### Run Tests

```bash
cd d-recursion-fold && stack test
```

### Written Answers

Answer the questions in [SUBMISSION.md](./SUBMISSION.md):

1. When does `foldr` vs `foldl` matter?
2. What is the difference in evaluation?

### Checkpoint

You're done when:

- Recursive versions of sum, product, etc.
- Same functions using `foldr`
- Same functions using `foldl`
- Understand when `foldr` vs `foldl` matters
- All tests pass

---

## Troubleshooting

### "Non-exhaustive patterns"

You're missing a case, usually the empty list `[]`

### "Infinite type"

Check you're not accidentally creating circular definitions

### Stack overflow

- Check your base case terminates
- For large lists, consider `foldl'` (strict left fold)

**Remember**: Do NOT use AI assistants for this task.
