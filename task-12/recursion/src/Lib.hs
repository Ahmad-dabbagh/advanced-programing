-- | Task 12 — Part 1: Recursion
--
-- This module contains examples and exercises on normal vs. tail recursion.
--
-- __Section A__ — Study the four given functions and identify whether each is
-- tail-recursive. Write your answer as a short comment directly in the source.
--
-- __Section B__ — Implement the tail-recursive versions of the given functions.
-- The naive (non-tail-recursive) reference is shown in a comment above each stub.
-- Run @stack test@ to verify your implementations with the doctests.
module Lib
    ( -- * Section A: Recognise tail recursion (read and identify)
      sumList
    , myProductAcc
    , collatzSteps
    , reverseMovesAcc
      -- * Section B: Convert to tail-recursive (implement these)
    , totalScore
    , reverseMoves
    , collatzLength
    , stairCount
    , myMap
    ) where

-- ===========================================================================
-- SECTION A: RECOGNISE TAIL RECURSION
-- ===========================================================================
-- For each function below, add a comment with:
--   (1) Is it tail-recursive?  YES / NO
--   (2) One-sentence reason why or why not.
-- ===========================================================================


-- | Sum a list of integers.
--
-- Q: Is this tail-recursive? Why or why not?
--
-- >>> sumList [1, 2, 3, 4, 5]
-- 15
-- >>> sumList []
-- 0
sumList :: [Int] -> Int
sumList []     = 0
sumList (x:xs) = x + sumList xs


-- | Compute the product of a list, using an explicit accumulator parameter.
--
-- Q: Is this tail-recursive? Why or why not?
--
-- >>> myProductAcc [1, 2, 3, 4, 5] 1
-- 120
-- >>> myProductAcc [] 1
-- 1
-- >>> myProductAcc [3, 4] 2
-- 24
myProductAcc :: [Int] -> Int -> Int
myProductAcc []     acc = acc
myProductAcc (x:xs) acc = myProductAcc xs (x * acc)


-- | Count the number of steps in the Collatz sequence needed to reach 1.
--
-- The Collatz rule: if n is even, divide by 2; if n is odd, multiply by 3 and
-- add 1. The conjecture is that every positive integer eventually reaches 1.
--
-- Q: Is this tail-recursive? Why or why not?
--
-- >>> collatzSteps 1
-- 0
-- >>> collatzSteps 6
-- 8
-- >>> collatzSteps 27
-- 111
collatzSteps :: Int -> Int
collatzSteps 1 = 0
collatzSteps n
    | even n    = 1 + collatzSteps (n `div` 2)
    | otherwise = 1 + collatzSteps (3 * n + 1)


-- | Reverse a list using an explicit accumulator — a tail-recursive reference.
--
-- This is provided as a worked example. Study it carefully before tackling
-- 'reverseMoves' in Section B.
--
-- Q: Is this tail-recursive? Why or why not?
--
-- >>> reverseMovesAcc [1, 2, 3 :: Int] []
-- [3,2,1]
-- >>> reverseMovesAcc "hello" ""
-- "olleh"
-- >>> reverseMovesAcc ([] :: [Int]) []
-- []
reverseMovesAcc :: [a] -> [a] -> [a]
reverseMovesAcc []     acc = acc
reverseMovesAcc (x:xs) acc = reverseMovesAcc xs (x : acc)


-- ===========================================================================
-- SECTION B: CONVERT TO TAIL-RECURSIVE
-- ===========================================================================
-- Each function below shows the naive (non-tail-recursive) version in a
-- comment. Implement a tail-recursive version using a local helper 'go'
-- inside a 'where' clause.
--
-- General pattern:
--
-- > myFunc xs = go xs initialAccumulator
-- >   where
-- >     go []     acc = acc            -- base case: return result
-- >     go (y:ys) acc = go ys (...)    -- tail call: update accumulator
--
-- Run 'stack test' to verify your implementations with the doctests.
-- ===========================================================================


-- | Compute the total score across a list of game rounds.
--
-- Naive (non-tail-recursive) reference:
--
-- > totalScoreNaive []     = 0
-- > totalScoreNaive (x:xs) = x + totalScoreNaive xs
--
-- Implement a tail-recursive version using a 'go' helper with an accumulator
-- that starts at 0.
--
-- >>> totalScore [10, 5, 20, 15]
-- 50
-- >>> totalScore []
-- 0
-- >>> totalScore [42]
-- 42
totalScore :: [Int] -> Int
totalScore xs = go xs 0
  where
    -- Tail-recursive helper: accumulator holds the running sum
    go :: [Int] -> Int -> Int
    go []     acc = acc
    go (y:ys) acc = go ys (acc + y)
-- | Reverse a sequence of game moves.
--
-- Naive (non-tail-recursive) reference:
--
-- > reverseMovesNaive []     = []
-- > reverseMovesNaive (x:xs) = reverseMovesNaive xs ++ [x]
--
-- Implement a tail-recursive version.
-- Hint: look at 'reverseMovesAcc' in Section A for the pattern.
-- The accumulator starts as [].
--
-- >>> reverseMoves [1, 2, 3, 4, 5 :: Int]
-- [5,4,3,2,1]
-- >>> reverseMoves ([] :: [Int])
-- []
-- >>> reverseMoves [1 :: Int]
-- [1]
reverseMoves :: [a] -> [a]
reverseMoves xs = go xs []
  where
    -- Tail-recursive helper: accumulator holds the reversed prefix
    go :: [a] -> [a] -> [a]
    go []     acc = acc
    go (y:ys) acc = go ys (y : acc)
-- | Count the number of steps in the Collatz sequence to reach 1.
--
-- This is the same mathematical function as 'collatzSteps' in Section A,
-- but you must implement it tail-recursively.
--
-- Look at 'collatzSteps' — is it tail-recursive? Use that analysis to guide
-- your implementation here.
--
-- Naive reference (same as 'collatzSteps'):
--
-- > collatzLengthNaive 1 = 0
-- > collatzLengthNaive n
-- >   | even n    = 1 + collatzLengthNaive (n `div` 2)
-- >   | otherwise = 1 + collatzLengthNaive (3 * n + 1)
--
-- Use a counter accumulator starting at 0.
--
-- >>> collatzLength 1
-- 0
-- >>> collatzLength 6
-- 8
-- >>> collatzLength 27
-- 111
collatzLength :: Int -> Int
collatzLength n = go n 0
  where
    -- Tail-recursive helper: accumulator counts steps taken so far
    go :: Int -> Int -> Int
    go 1 steps = steps
    go k steps
        | even k    = go (k `div` 2) (steps + 1)
        | otherwise = go (3 * k + 1) (steps + 1)
-- | Count the number of ways to climb n stairs, taking 1 or 2 steps at a time.
--
-- This is the Fibonacci-like "staircase problem": from any step, you can move
-- up by 1 or 2. How many distinct paths lead to the top?
--
-- Naive (non-tail-recursive) reference:
--
-- > stairCountNaive 0 = 1
-- > stairCountNaive 1 = 1
-- > stairCountNaive n = stairCountNaive (n-1) + stairCountNaive (n-2)
--
-- Implement a tail-recursive version.
-- Hint: use a __pair__ accumulator @(a, b)@ where
--
-- * @a@ = number of ways for the current step count
-- * @b@ = number of ways for the next step count
--
-- Think about how Fibonacci can be computed iteratively with two variables.
--
-- >>> stairCount 0
-- 1
-- >>> stairCount 1
-- 1
-- >>> stairCount 5
-- 8
-- >>> stairCount 10
-- 89
stairCount :: Int -> Int
stairCount n = go n (1, 1)
  where
    -- Tail-recursive helper:
    -- (a, b) represents (ways(k), ways(k+1)) for the current k
    go :: Int -> (Int, Int) -> Int
    go 0 (a, _) = a
    go k (a, b) = go (k - 1) (b, a + b)

-- | BONUS: A tail-recursive version of 'map'.
--
-- Standard (non-tail-recursive) reference:
--
-- > myMapNaive _ []     = []
-- > myMapNaive f (x:xs) = f x : myMapNaive f xs
--
-- Implement a tail-recursive version using an accumulator.
--
-- Note: the accumulator collects elements in reverse order, so you will need
-- to reverse the final result (using the standard 'reverse' function).
--
-- >>> myMap (* 2) [1, 2, 3, 4, 5 :: Int]
-- [2,4,6,8,10]
-- >>> myMap negate [1, 2, 3 :: Int]
-- [-1,-2,-3]
-- >>> myMap id ([] :: [Int])
-- []
myMap :: (a -> b) -> [a] -> [b]
myMap f xs = reverse (go xs [])
  where
    go [] acc = acc
    go (y:ys) acc = go ys (f y : acc)
