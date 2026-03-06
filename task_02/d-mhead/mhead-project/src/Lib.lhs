Task_02d: mhead Implementations
================================

This module contains multiple implementations of the `head` function.
Your task is to implement each variant and understand how they work.

Module Declaration
------------------

> module Lib
>   ( mhead1
>   , mhead2
>   , mhead3
>   , mhead4
>   ) where


Implementation 1: Pattern Matching
----------------------------------

The most idiomatic way in Haskell. Pattern match on the list constructor.

> -- | mhead1 returns the first element using pattern matching
> --
> -- >>> mhead1 [1,2,3]
> -- 1
> --
> -- >>> mhead1 "Hello"
> -- 'H'
> --
> mhead1 :: [a] -> a
> mhead1 = undefined  -- TODO: Implement using pattern matching


Implementation 2: Index Operator
--------------------------------

Use the `!!` operator to get element at index 0.

> -- | mhead2 returns the first element using index operator
> --
> -- >>> mhead2 [1,2,3]
> -- 1
> --
> -- >>> mhead2 ['a','b','c']
> -- 'a'
> --
> mhead2 :: [a] -> a
> mhead2 = undefined  -- TODO: Implement using !!


Implementation 3: Using take
----------------------------

Take the first element and extract it with pattern matching.

> -- | mhead3 returns the first element using take
> --
> -- >>> mhead3 [1,2,3]
> -- 1
> --
> -- >>> mhead3 [True, False]
> -- True
> --
> mhead3 :: [a] -> a
> mhead3 = undefined  -- TODO: Implement using take


Implementation 4: Using foldr1
------------------------------

Use foldr1 to keep only the first element.

> -- | mhead4 returns the first element using foldr1
> --
> -- >>> mhead4 [1,2,3]
> -- 1
> --
> -- >>> mhead4 "abc"
> -- 'a'
> --
> mhead4 :: [a] -> a
> mhead4 = undefined  -- TODO: Implement using foldr1


Bonus Implementations
---------------------

Try to implement more variants! Some ideas:

- Using `case` expression
- Using guards
- Using `fst` and `splitAt`
- Using list comprehension (tricky!)

Add your bonus implementations below:

-- > mhead5 :: [a] -> a
-- > mhead5 = undefined


Notes
-----

All these implementations are **partial functions** - they will
crash on empty lists. In real code, you would use `Maybe`:

    safeHead :: [a] -> Maybe a
    safeHead []    = Nothing
    safeHead (x:_) = Just x

We use partial functions here to match the behavior of the
built-in `head` function for learning purposes.
