# Task_02d: mhead Function

**Goal**: Implement your own `head` function in multiple ways, with doctests and property tests

## What You'll Do

1. Copy the pre-generated skeleton project
2. Implement `mhead` in at least 3 different ways
3. Add doctests to each implementation
4. Write QuickCheck property tests
5. Run all tests

## Instructions

See [../INSTRUCTIONS.md](../INSTRUCTIONS.md) for detailed step-by-step guidance.

## Getting Started

```bash
cp -r mhead-project ~/your-workspace/
cd ~/your-workspace/task_02/mhead-project
stack build
stack test
```

## Implementation Ideas

Try implementing `mhead` in different ways:

1. **Pattern matching**: `mhead (x:_) = x`
2. **Using `!!`**: `mhead xs = xs !! 0`
3. **Using `take`**: `mhead xs = let [x] = take 1 xs in x`
4. **Using `foldr1`**: `mhead = foldr1 (\x _ -> x)`
5. **Using case**: `mhead xs = case xs of (x:_) -> x`
6. ...and more!

## Doctests

Every function should have doctests:

```haskell
-- | mhead1 returns the first element using pattern matching
--
-- >>> mhead1 [1,2,3]
-- 1
--
-- >>> mhead1 "Hello"
-- 'H'
```

## QuickCheck Property Tests

Write a property that states: "For any non-empty list, mhead behaves like head"

```haskell
it "behaves like head" $ property $
  \xs -> not (null (xs :: [Int])) ==> mhead1 xs == head xs
```

## Key Concepts

- Pattern matching on lists: `(x:xs)`, `[]`
- Doctests: `-- >>> expression` / `-- result`
- Property-based testing with QuickCheck
- The `==>` (implication) operator for preconditions

## Checkpoint

You're done when:

- [ ] At least 3 different implementations
- [ ] All implementations have doctests
- [ ] Doctests pass (`stack test`)
- [ ] QuickCheck property tests pass
- [ ] You can explain each implementation
