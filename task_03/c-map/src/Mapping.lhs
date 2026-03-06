Task_03c: Map and Lambda Expressions
====================================

`map` applies a function to every element of a list.
Lambda expressions let us write anonymous functions inline.

> module Mapping where


Part 1: Using map with Named Functions
--------------------------------------

> -- | Double every number using map
> --
> -- >>> doubleAll [1,2,3]
> -- [2,4,6]
> --
> doubleAll :: [Int] -> [Int]
> doubleAll xs = map (*2) xs  -- TODO: Use map with (*2) or a helper function


> -- | Negate every number
> --
> -- >>> negateAll [1,-2,3]
> -- [-1,2,-3]
> --
> negateAll :: [Int] -> [Int]
> negateAll xs = map negate xs
> --  negateAll xs = map (*(-1)) xs  -- TODO: Use map with negate


> -- | Convert numbers to strings
> --
> -- >>> showAll [1,2,3]
> -- ["1","2","3"]
> --
> showAll :: [Int] -> [String]
> showAll xs = map show xs  -- TODO: Use map with show


> -- | Get lengths of strings
> --
> -- >>> lengths ["hi", "hello", "hey"]
> -- [2,5,3]
> --
> lengths :: [String] -> [Int]
> lengths xs = map length xs -- TODO: Use map with length


Part 2: Using map with Lambda Expressions
-----------------------------------------

Lambda syntax: `\arg1 arg2 -> expression`

> -- | Square every number
> --
> -- >>> squareAll [1,2,3,4]
> -- [1,4,9,16]
> --
> squareAll :: [Int] -> [Int]
> squareAll xs = map (\x -> x * x) xs  -- TODO: Use map with \x -> x * x


> -- | Add 10 to every number
> --
> -- >>> addTen [1,2,3]
> -- [11,12,13]
> --
> addTen :: [Int] -> [Int]
> -- addTen xs = map (+10) xs  -- <<== also works 
> addTen xs = map (\x-> x+10) xs -- TODO: Use map with lambda


> -- | Wrap each element in a list
> --
> -- >>> wrapAll [1,2,3]
> -- [[1],[2],[3]]
> --
> -- >>> wrapAll "abc"
> -- ["a","b","c"]
> --
> wrapAll :: [a] -> [[a]]
> wrapAll xs = map (\x -> [x]) xs  -- TODO: Use map with \x -> [x]


> -- | Create pairs with index
> --
> -- >>> pairWithIndex [10,20,30]
> -- [(0,10),(1,20),(2,30)]
> --
> pairWithIndex :: [a] -> [(Int, a)]
> pairWithIndex xs = map (\(i,x) -> (i,x)) (zip [0..] xs)    -- TODO: Use map with lambda on zip [0..] xs
> -- = zip [0..] xs 

Part 3: Implement Your Own map
------------------------------

> -- | Our own implementation of map
> --
> -- >>> mmap (+1) [1,2,3]
> -- [2,3,4]
> --
> -- >>> mmap length ["a", "bb", "ccc"]
> -- [1,2,3]
> --
> -- >>> mmap (\x -> x * x) [1,2,3]
> -- [1,4,9]
> --
> mmap :: (a -> b) -> [a] -> [b]
> mmap f [] = []                -- <<== dont forget base case
> mmap f (x:xs) = f x : mmap f xs  -- TODO: Implement using recursion


Part 4: Combining Transformations
---------------------------------

> -- | First double, then add 1
> --
> -- >>> doubleThenAddOne [1,2,3]
> -- [3,5,7]
> --
> doubleThenAddOne :: [Int] -> [Int]
> doubleThenAddOne xs = map (\x-> (2*x)+1) xs  -- TODO: Can you do it with one map?


> -- | Apply a function twice to each element
> --
> -- >>> applyTwice (+1) [1,2,3]
> -- [3,4,5]
> --
> -- >>> applyTwice (*2) [1,2,3]
> -- [4,8,12]
> --
> applyTwice :: (a -> a) -> [a] -> [a]
> applyTwice f xs = map (\x-> f (f x)) xs   -- TODO: map with f applied twice


Part 5: Real-World Example - Price Calculations
-----------------------------------------------

Let's apply map to practical pricing scenarios.

> type Price = Double

> -- | Apply a percentage discount to a list of prices
> --
> -- >>> applyDiscount 10 [100.0, 50.0, 25.0]
> -- [90.0,45.0,22.5]
> --
> -- >>> applyDiscount 20 [80.0, 40.0]
> -- [64.0,32.0]
> --
> applyDiscount :: Double -> [Price] -> [Price]
> applyDiscount percent xs = map (\p -> p * (1-percent/100)) xs
>   -- TODO: Use map with lambda: \p -> p * (1 - percent/100)


> -- | Add tax (e.g., 25% VAT) to a list of prices
> --
> -- >>> addTax 25 [100.0, 200.0, 50.0]
> -- [125.0,250.0,62.5]
> --
> addTax :: Double -> [Price] -> [Price]
> addTax percent xs = map (\p-> p * (1+percent/100)) xs
>   -- TODO: Use map with lambda


> -- | Round all prices to 2 decimal places (for display)
> --
> -- >>> roundPrices [9.999, 4.501, 2.005]
> -- [10.0,4.5,2.01]
> --
> roundPrices :: [Price] -> [Price]
> roundPrices = map ( \p -> fromIntegral (round ((p+1e-9)*100))/100)  
>   -- TODO: Use map with: \p -> fromIntegral (round (p * 100)) / 100


> -- | Format prices as strings with currency symbol
> --
> -- >>> formatPrices [9.99, 4.50, 2.00]
> -- ["$9.99","$4.5","$2.0"]
> --
> formatPrices :: [Price] -> [String]
> formatPrices xs = map (\x -> "$"++show x) xs -- we can also use it withoout (xs)on both sides 
>   -- TODO: Use map with lambda that prepends "$" to show


Experiments
-----------

Try these in GHCi:

    > :type map
    > :type (\x -> x + 1)
    > map (\x -> (x, x*x)) [1..5]
    > map (map (+1)) [[1,2], [3,4]]
    > map head ["hello", "world"]

Pricing experiments:

    > let prices = [9.99, 19.99, 4.50]
    > map (* 0.9) prices              -- 10% off
    > map (* 1.25) prices             -- add 25% tax
    > map (\p -> "$" ++ show p) prices  -- format with $
