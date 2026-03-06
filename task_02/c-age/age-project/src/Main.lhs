Task_02c: Age Calculator
========================

This is a literate Haskell file. Text is documentation by default.
Lines starting with `>` are Haskell code.

Module Declaration
------------------

> module Main where

Part 1: Age Calculator
----------------------

Implement a program that:
1. Asks for the user's name
2. Asks for their age
3. Calculates their age in 10 years
4. Prints a greeting with the result

Hints:
- Use `getLine` to read input
- Use `read` to convert String to Int
- Use `show` to convert Int to String

> main :: IO ()
> main = do
>   -- TODO: Implement the age calculator
>   putStrLn "Hi, what is your name?"
>   name <- getLine    //
>   putStrLn "and what is your age?"
>	age<- getLine		//	
	age = read age :: Int	//
	putStrLn(age)		//	
>   -- TODO: Read age, convert to Int, add 10
>   -- TODO: Print result
>   putStrLn "TODO: Implement me!"


Part 2: Generic Addition
------------------------

The `addNumber` function should work with any numeric type.
The type class constraint `Num a` ensures we can use `+`.

> -- | Add two numbers of any numeric type
> --
> -- >>> addNumber 1 2
> -- 3
> --
> -- >>> addNumber 1.5 2.5
> -- 4.0
> --
> addNumber :: Num a => a -> a -> a
> addNumber = undefined  -- TODO: Implement this


Part 3: Type-Safe Age Addition
------------------------------

Version A: Using newtype
~~~~~~~~~~~~~~~~~~~~~~~~

A `newtype` creates a distinct type that is different from its
underlying representation. The compiler enforces that you cannot
mix Age with Int accidentally.

> -- | Age represents a person's age in years
> newtype Age = Age Int
>   deriving (Show, Eq)

> -- | Add two Age values together
> --
> -- >>> addAge (Age 10) (Age 5)
> -- Age 15
> --
> addAge :: Age -> Age -> Age
> addAge = undefined  -- TODO: Implement this


Version B: Using type alias
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Uncomment and compare with Version A. What's different?

-- type AgeAlias = Int
--
-- addAgeAlias :: AgeAlias -> AgeAlias -> AgeAlias
-- addAgeAlias x y = x + y


Experiments
-----------

After implementing, try these in GHCi:

    stack ghci

    > addNumber (1 :: Int) (2 :: Int)
    > addNumber (1.0 :: Float) (2.0 :: Float)
    > addAge (Age 10) (Age 20)
    > addAge 10 20           -- What happens?
    > addAge (Age 10) 20     -- What happens?

Think about why some work and others don't.
