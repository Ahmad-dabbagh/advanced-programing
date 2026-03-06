Task_03d: Recursion and Folding
===============================

Most list operations follow a common pattern that can be expressed
either with explicit recursion or with folds.

> module Recursion where


Understanding foldr vs foldl: Visual Execution Trace
----------------------------------------------------

Before implementing, let's visualize how foldr and foldl evaluate differently.

**foldr (right fold)** - builds from the RIGHT, associates to the right:

    foldr f z [1,2,3]
    = f 1 (foldr f z [2,3])
    = f 1 (f 2 (foldr f z [3]))
    = f 1 (f 2 (f 3 (foldr f z [])))
    = f 1 (f 2 (f 3 z))
    = 1 `f` (2 `f` (3 `f` z))

Example with subtraction:

    foldr (-) 0 [1,2,3]
    = 1 - (2 - (3 - 0))
    = 1 - (2 - 3)
    = 1 - (-1)
    = 2

**foldl (left fold)** - builds from the LEFT, associates to the left:

    foldl f z [1,2,3]
    = foldl f (f z 1) [2,3]
    = foldl f (f (f z 1) 2) [3]
    = foldl f (f (f (f z 1) 2) 3) []
    = f (f (f z 1) 2) 3
    = ((z `f` 1) `f` 2) `f` 3

Example with subtraction:

    foldl (-) 0 [1,2,3]
    = ((0 - 1) - 2) - 3
    = ((-1) - 2) - 3
    = (-3) - 3
    = -6

**Key insight**: For commutative operations like (+) and (*), both give
the same result. For non-commutative operations like (-), they differ!


Part 1: Sum - Three Ways
------------------------

Implement sum of a list three different ways.

> -- | Sum using explicit recursion
> --
> -- >>> msumRec []
> -- 0
> --
> -- >>> msumRec [1,2,3,4]
> -- 10
> --
> msumRec :: [Int] -> Int
> msumRec [] = 0
> msumRec (x:xs)= x + msumRec xs   -- TODO: Implement with recursion


> -- | Sum using foldr
> --
> -- >>> msumFoldr []
> -- 0
> --
> -- >>> msumFoldr [1,2,3,4]
> -- 10
> --
> msumFoldr :: [Int] -> Int
> msumFoldr [] = 0
> msumFoldr xs = foldr (+) 0 xs   -- TODO: Implement with foldr


> -- | Sum using foldl
> --
> -- >>> msumFoldl []
> -- 0
> --
> -- >>> msumFoldl [1,2,3,4]
> -- 10
> --
> msumFoldl :: [Int] -> Int
> msumFoldl [] = 0
> msumFoldl xs = foldl (+) 0 xs  -- TODO: Implement with foldl


Part 2: Product - Three Ways
----------------------------

> -- | Product using recursion
> --
> -- >>> mproductRec []
> -- 1
> --
> -- >>> mproductRec [1,2,3,4]
> -- 24
> --
> mproductRec :: [Int] -> Int
> mproductRec [] = 1
> mproductRec (x:xs) = x * mproductRec xs  -- TODO: Implement


> -- | Product using foldr
> --
> -- >>> mproductFoldr [1,2,3,4]
> -- 24
> --
> mproductFoldr :: [Int] -> Int
> mproductFoldr xs = foldl (*) 1 xs   -- TODO: Implement


Part 3: Length using Fold
-------------------------

> -- | Length using foldr
> --
> -- >>> mlengthFoldr []
> -- 0
> --
> -- >>> mlengthFoldr [1,2,3,4,5]
> -- 5
> --
> -- >>> mlengthFoldr "hello"
> -- 5
> --
> mlengthFoldr :: [a] -> Int
> mlengthFoldr [] = 0
> mlengthFoldr xs = foldr(\ _ acc -> acc+1) 0 xs   -- TODO: Hint: ignore element, just count


Part 4: Boolean Operations
--------------------------

> -- | Are all elements True? (recursion)
> --
> -- >>> mandRec []
> -- True
> --
> -- >>> mandRec [True, True, True]
> -- True
> --
> -- >>> mandRec [True, False, True]
> -- False
> --
> mandRec :: [Bool] -> Bool
> mandRec [] = True
> mandRec (x:xs) = x && mandRec xs   -- TODO: Implement


> -- | Are all elements True? (foldr)
> --
> -- >>> mandFoldr [True, True]
> -- True
> --
> -- >>> mandFoldr [True, False]
> -- False
> --
> mandFoldr :: [Bool] -> Bool
> mandFoldr xs = foldr (&&) True xs  -- TODO: Implement with foldr //remember the starting value of fold


> -- | Is any element True? (foldr)
> --
> -- >>> morFoldr []
> -- False
> --
> -- >>> morFoldr [False, False, True]
> -- True
> --
> morFoldr :: [Bool] -> Bool
> morFoldr xs = foldr (||) False xs  -- TODO: Implement with foldr


Part 5: Reverse using Fold
--------------------------

This is tricky! Think about which fold to use.

> -- | Reverse using foldl
> --
> -- >>> mreverseFoldl []
> -- []
> --
> -- >>> mreverseFoldl [1,2,3]
> -- [3,2,1]
> --
> mreverseFoldl :: [a] -> [a]
> mreverseFoldl xs = foldl (\acc x -> x : acc) [] xs   -- TODO: Hint: foldl is natural for this


Part 6: Map using Fold
----------------------

> -- | Map using foldr
> --
> -- >>> mmapFoldr (+1) [1,2,3]
> -- [2,3,4]
> --
> -- >>> mmapFoldr (*2) [1,2,3]
> -- [2,4,6]
> --
> mmapFoldr :: (a -> b) -> [a] -> [b]
> mmapFoldr f xs = foldr (\x acc -> f x:acc) [] xs   -- TODO: Implement map using foldr


Part 7: Filter using Fold
-------------------------

> -- | Filter using foldr
> --
> -- >>> mfilterFoldr even [1,2,3,4,5,6]
> -- [2,4,6]
> --
> -- >>> mfilterFoldr (>3) [1,2,3,4,5]
> -- [4,5]
> --
> mfilterFoldr :: (a -> Bool) -> [a] -> [a]
> mfilterFoldr f xs = foldr (\x acc ->if f x then x:acc else  acc) [] xs  -- TODO: Implement filter using foldr


Part 8: Real-World Example - Shopping Cart
------------------------------------------

Let's apply folding to a practical scenario: calculating shopping cart totals.

A cart item is represented as (Price, Quantity):

> type Price = Double
> type Quantity = Int
> type CartItem = (Price, Quantity)

> -- | Calculate total cost of a single item
> --
> -- >>> itemTotal (9.99, 2)
> -- 19.98
> --
> itemTotal :: CartItem -> Double
> itemTotal (price, qty) = price * fromIntegral qty

> -- | Calculate total cost of entire shopping cart
> --
> -- >>> cartTotal [(9.99, 2), (4.50, 3), (2.00, 1)]
> -- 35.48
> --
> -- >>> cartTotal []
> -- 0.0
> --
> cartTotal :: [CartItem] -> Double
> cartTotal xs = round2(foldr (\item acc->itemTotal item + acc) 0.0 xs)
>   where
>      round2 :: Double -> Double 
>      round2 x = fromIntegral (round (x* 100))/100 -- TODO: Use foldr with itemTotal

> -- | Apply a discount percentage to all prices
> --
> -- >>> applyDiscount 10 [(100.0, 1), (50.0, 2)]
> -- [(90.0,1),(45.0,2)]
> --
> applyDiscount :: Double -> [CartItem] -> [CartItem]
> applyDiscount percent xs = map (\(price, qty)-> (price - price*percent/100, qty)) xs  -- TODO: Use map with lambda


Experiments
-----------

Try these in GHCi to understand foldr vs foldl:

    > foldr (-) 0 [1,2,3]
    > foldl (-) 0 [1,2,3]
    > -- Why are they different? (See visual trace above!)

    > foldr (:) [] [1,2,3]
    > foldl (flip (:)) [] [1,2,3]

    > foldr (++) [] ["a","b","c"]
    > foldl (++) [] ["a","b","c"]

Shopping cart experiments:

    > let cart = [(9.99, 2), (4.50, 3), (2.00, 1)]
    > map itemTotal cart
    > sum (map itemTotal cart)

Think about: which operations give the same result with foldr and foldl?
