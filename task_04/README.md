# Task 04: Custom Data Types

| Item           | Details                                                         |
|----------------|-----------------------------------------------------------------|
| **Date**       | Wednesday, 28th of January                                      |
| **Deadline**   | Wednesday, 28th of January, 11:59 (end of class)                |
| **OBLIG**      | No                                                              |
| **Type**       | **In-Class**, Small Group Activities, **individual** submission |
| **AI**         | **Do not use**                                                  |
| **Coding**     | Code it all yourself, by hand                                   |
| **PeerReview** | No                                                              |

---

## Overview

This task introduces custom algebraic data types (ADTs) - a fundamental concept in Haskell that allows you to define your own types with meaningful structure.

| Subtask                           | Topic               | Key Concepts                                              |
|-----------------------------------|---------------------|-----------------------------------------------------------|
| [a-datatypes](./a-datatypes/)     | Defining Data Types | `data`, record syntax, accessors, `Maybe`, `deriving`     |
| [b-processing](./b-processing/)   | Processing Lists    | Applying list operations to custom types, function styles |

---

## Learning Objectives

By the end of this task, you should be able to:

### Core Skills (demonstrate without help)

- Define custom data types using the `data` keyword
- Use record syntax with automatic accessor functions
- Write manual accessor functions
- Use `deriving` for `Show` and `Eq`
- Understand and use the `Maybe` type for safe operations
- Pattern match on custom data types
- Apply `map`, `filter`, and `fold` to lists of custom types
- Write functions in multiple styles (point-free, guards, where/let)

### Extended Skills (with help from online resources)

- Use record update syntax
- Work with `Maybe` in list operations
- Combine multiple functional patterns

---

## Prerequisites

- Completed Task_02 and Task_03
- Comfortable with lists, `map`, `filter`, `foldr`
- Basic understanding of pattern matching

### Recommended Versions

| Tool  | Version |
|-------|---------|
| Stack | 3.9.1   |
| GHC   | 9.10.3  |
| LTS   | 24.28   |

---

## Resources

- Haskell books
- GHCi (interactive interpreter)
- [Hoogle](https://hoogle.haskell.org) - Haskell API search
- Task_02 and Task_03 materials (review as needed)

---

## Quick Reference

### Defining Data Types

```haskell
-- Positional constructor
data Point = Point Int Int

-- Record syntax (generates accessor functions)
data Person = Person
  { personName :: String
  , personAge  :: Int
  } deriving (Show, Eq)

-- Using accessors
getName :: Person -> String
getName p = personName p  -- or just use personName directly
```

### The Maybe Type

```haskell
data Maybe a = Nothing | Just a

-- Safe head function
safeHead :: [a] -> Maybe a
safeHead []    = Nothing
safeHead (x:_) = Just x

-- Pattern matching on Maybe
describeMaybe :: Maybe Int -> String
describeMaybe Nothing  = "No value"
describeMaybe (Just x) = "Value is " ++ show x
```

### Record Update Syntax

```haskell
-- Create a new record with one field changed
updateAge :: Person -> Int -> Person
updateAge p newAge = p { personAge = newAge }
```

### Common Patterns

```haskell
-- Filter with custom type
adults :: [Person] -> [Person]
adults = filter (\p -> personAge p >= 18)

-- Map accessor over list
allNames :: [Person] -> [String]
allNames = map personName

-- Fold with custom type
totalAge :: [Person] -> Int
totalAge = foldr (\p acc -> personAge p + acc) 0
```

---

## Task_04a: Defining Data Types

**Goal**: Define custom data types with record syntax and understand the Maybe type

### What You'll Learn

- Define a `Student` data type using record syntax
- Understand automatic accessor functions
- Write manual accessors for comparison
- Use `deriving` for `Show` and `Eq`
- Understand and use the `Maybe` type

### Key Concepts

**The `data` Keyword:**

```haskell
data TypeName = Constructor Field1Type Field2Type ...
```

**Record Syntax:**

```haskell
data Student = Student
  { studentName  :: String   -- accessor: studentName :: Student -> String
  , studentId    :: Int      -- accessor: studentId :: Student -> Int
  } deriving (Show, Eq)
```

**The Maybe Type:**

```haskell
data Maybe a = Nothing | Just a

-- Used for operations that might fail
safeDiv :: Int -> Int -> Maybe Int
safeDiv _ 0 = Nothing
safeDiv x y = Just (x `div` y)
```

### GHCi Exploration

```bash
cd a-datatypes && stack ghci
```

Try defining simple types:

```haskell
-- Simple enumeration
data Color = Red | Green | Blue

-- Type with data
data Point = Point Int Int

-- Check the type
:type Point
:type Red

-- Create values
let p = Point 3 4
let c = Red
```

Try record syntax:

```haskell
-- Without record syntax (positional)
data PersonV1 = PersonV1 String Int

-- With record syntax (named fields)
data PersonV2 = PersonV2 { name :: String, age :: Int }

-- Record syntax generates accessor functions automatically!
let alice = PersonV2 { name = "Alice", age = 25 }
name alice   -- "Alice"
age alice    -- 25
```

Explore the Maybe type:

```haskell
:info Maybe
-- data Maybe a = Nothing | Just a

Just 5      :: Maybe Int
Nothing     :: Maybe Int
Just "hi"   :: Maybe String

-- Pattern matching on Maybe
let showMaybe mx = case mx of
      Nothing -> "empty"
      Just x  -> "has: " ++ show x

showMaybe Nothing
showMaybe (Just 42)
```

### Functions to Implement

Complete the TODOs in `src/Student.hs`:

1. Define the `Student` data type with record syntax
2. Implement manual accessor functions
3. Implement constructor helpers
4. Implement predicates using `Maybe` where appropriate
5. Implement safe lookup functions returning `Maybe`

### Run Tests

```bash
cd a-datatypes && stack test
```

### Checkpoint

You're done when:

- `Student` data type defined with record syntax
- Manual accessor functions work
- Constructor helpers implemented
- `Maybe` understood and used correctly
- All tests pass

---

## Task_04b: Processing Student Lists

**Goal**: Apply functional patterns to lists of custom data types

### What You'll Learn

- Apply `map`, `filter`, `foldr` to lists of `Student`
- Practice different function writing styles
- Use `Maybe` for safe operations
- Combine multiple patterns

### Key Concepts

**Mapping Over Custom Types:**

```haskell
-- Extract field from all records
allNames :: [Student] -> [String]
allNames = map studentName
```

**Filtering Custom Types:**

```haskell
-- Filter based on field value
passingStudents :: [Student] -> [Student]
passingStudents = filter (\s -> studentGrade s >= 50)
```

**Folding Custom Types:**

```haskell
-- Aggregate field values
totalGrades :: [Student] -> Int
totalGrades = foldr (\s acc -> studentGrade s + acc) 0
```

**Safe Operations with Maybe:**

```haskell
-- Return Nothing for invalid operations
topStudent :: [Student] -> Maybe Student
topStudent [] = Nothing
topStudent students = Just (maximumBy (comparing studentGrade) students)
```

### Function Styles to Practice

```haskell
-- Style 1: Explicit arguments
double1 :: Int -> Int
double1 x = x * 2

-- Style 2: Point-free (no explicit argument)
double2 :: Int -> Int
double2 = (* 2)

-- Style 3: Lambda
double3 :: Int -> Int
double3 = \x -> x * 2

-- Using guards
grade :: Int -> String
grade score
  | score >= 90 = "A"
  | score >= 80 = "B"
  | score >= 70 = "C"
  | otherwise   = "F"

-- Using where
circleArea :: Double -> Double
circleArea r = pi * rSquared
  where rSquared = r * r

-- Using let
circleArea' :: Double -> Double
circleArea' r = let rSquared = r * r in pi * rSquared
```

### Working with Maybe in Lists

```haskell
import Data.Maybe (catMaybes, mapMaybe)

-- Filter out Nothing values
catMaybes [Just 1, Nothing, Just 2, Nothing]  -- [1, 2]

-- Map and filter in one step
mapMaybe (\x -> if x > 0 then Just (x * 2) else Nothing) [-1, 2, -3, 4]  -- [4, 8]
```

### GHCi Exploration

```bash
cd b-processing && stack ghci
```

Try:

```haskell
import Data.Maybe (catMaybes, mapMaybe)

catMaybes [Just 1, Nothing, Just 2, Nothing]
mapMaybe (\x -> if x > 0 then Just (x * 2) else Nothing) [-1, 2, -3, 4]
```

### Functions to Implement

Complete the TODOs in `src/Processing.hs`:

1. **Filtering functions** - using list comprehensions and `filter`
2. **Mapping functions** - extracting data from students
3. **Folding functions** - aggregating student data
4. **Safe functions** - returning `Maybe` for operations that might fail
5. **Various styles** - practice point-free, guards, where/let

### Run Tests

```bash
cd b-processing && stack test
```

### Checkpoint

You're done when:

- Filtering functions implemented
- Mapping functions implemented
- Folding functions implemented
- Safe functions with `Maybe` implemented
- Multiple function styles demonstrated
- All tests pass

---

## Troubleshooting

### "Not in scope: data constructor"

Make sure you've defined your data type before using its constructor.

### "No instance for (Show ...)"

Add `deriving (Show)` to your data type definition.

### "Couldn't match type"

Check that your function returns the correct type, especially when using `Maybe`.

**Remember**: Do NOT use AI assistants for this task.
