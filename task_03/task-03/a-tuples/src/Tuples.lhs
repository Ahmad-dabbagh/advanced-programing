Task_03a: Working with Tuples
=============================

Tuples are fixed-size collections that can hold values of different types.

> module Tuples where


Part 1: Basic Pair Operations
-----------------------------

Pairs are tuples with exactly two elements: `(a, b)`

> -- | Swap the elements of a pair
> --
> -- >>> swap (1, 2)
> -- (2,1)
> --
> -- >>> swap ("hello", True)
> -- (True,"hello")
> --
> swap :: (a, b) -> (b, a)
> swap (x,y) = (y,x)  -- <<==TODO: Implement using pattern matching


> -- | Add corresponding elements of two pairs
> --
> -- >>> addPairs (1, 2) (3, 4)
> -- (4,6)
> --
> -- >>> addPairs (10, 20) (5, 5)
> -- (15,25)
> --
> addPairs :: (Int, Int) -> (Int, Int) -> (Int, Int)
> addPairs (a,b) (c,d)= (a+c, b+d)  -- <<== TODO: Implement this


Part 2: Working with Triples
----------------------------

Triples have three elements: `(a, b, c)`
There's no built-in `fst` or `snd` for triples - use pattern matching.

> -- | Get the first element of a triple
> --
> -- >>> firstOfThree (1, 2, 3)
> -- 1
> --
> -- >>> firstOfThree ("a", "b", "c")
> -- "a"
> --
> firstOfThree :: (a, b, c) -> a
> firstOfThree (x,_,_)= x   -- <<==TODO: Implement


> -- | Get the second element of a triple
> --
> -- >>> secondOfThree (1, 2, 3)
> -- 2
> --
> secondOfThree :: (a, b, c) -> b
> secondOfThree (_,x,_)= x -- <<== TODO: Implement


> -- | Get the third element of a triple
> --
> -- >>> thirdOfThree (1, 2, 3)
> -- 3
> --
> thirdOfThree :: (a, b, c) -> c
> thirdOfThree (_,_,x)= x  -- <<== TODO: Implement


Part 3: Functions Returning Tuples
----------------------------------

Functions can return tuples to return multiple values.

> -- | Return both the head and tail of a list
> --
> -- >>> headAndTail [1,2,3,4]
> -- (1,[2,3,4])
> --
> -- >>> headAndTail "hello"
> -- ('h',"ello")
> --
> headAndTail :: [a] -> (a, [a])
> headAndTail (x:xs) = (x,xs)   -- <<== TODO: Implement


> -- | Split a list at index n, returning both parts
> --
> -- >>> msplitAt 2 [1,2,3,4,5]
> -- ([1,2],[3,4,5])
> --
> -- >>> msplitAt 0 [1,2,3]
> -- ([],[1,2,3])
> --
> msplitAt :: Int -> [a] -> ([a], [a])
> msplitAt n xs = (take n xs,drop n xs)


 undefined  -- TODO: Implement (hint: use take and drop)


Part 4: Combining with Lists
----------------------------

Tuples and lists work well together.

> -- | Pair each element with its index
> --
> -- >>> withIndex "abc"
> -- [(0,'a'),(1,'b'),(2,'c')]
> --
> -- >>> withIndex [10, 20, 30]
> -- [(0,10),(1,20),(2,30)]
> --
> withIndex :: [a] -> [(Int, a)]
> withIndex  xs = zip [0..] xs  -- TODO: Implement (hint: use zip and [0..])


Part 5: Real-World Example - Shopping Cart
------------------------------------------

Tuples are perfect for representing structured data like shopping items.
Each item has a price and quantity: (Price, Quantity)

> type Price = Double
> type Quantity = Int
> type CartItem = (Price, Quantity)

> -- | Calculate total cost of a single cart item
> --
> -- >>> itemCost (9.99, 2)
> -- 19.98
> --
> -- >>> itemCost (4.50, 3)
> -- 13.5
> --
> itemCost :: CartItem -> Double
> itemCost (a,b) = a * fromIntegral b -- TODO: Multiply price by quantity (use fromIntegral)


> -- | Extract all prices from a shopping cart
> --
> -- >>> getPrices [(9.99, 2), (4.50, 3), (2.00, 1)]
> -- [9.99,4.5,2.0]
> --
> getPrices :: [CartItem] -> [Price]
> getPrices xs = map fst xs  -- TODO: Use map with fst


> -- | Extract all quantities from a shopping cart
> --
> -- >>> getQuantities [(9.99, 2), (4.50, 3), (2.00, 1)]
> -- [2,3,1]
> --
> getQuantities :: [CartItem] -> [Quantity]
> getQuantities xs = map snd xs  -- TODO: Use map with snd


> -- | Create a cart item from separate price and quantity
> --
> -- >>> makeItem 9.99 2
> -- (9.99,2)
> --
> makeItem :: Price -> Quantity -> CartItem
> makeItem a b = (a,b)  -- TODO: Create a tuple


Experiments
-----------

Try these in GHCi:

    > (1, "hello", True)
    > fst (1, 2)
    > snd (1, 2)
    > let (a, b, c) = (1, 2, 3) in b
    > zip [1,2,3] ['a','b','c']
    > unzip [(1,'a'), (2,'b')]

Shopping cart experiments:

    > let cart = [(9.99, 2), (4.50, 3), (2.00, 1)]
    > map fst cart                    -- get all prices
    > map snd cart                    -- get all quantities
    > unzip cart                      -- split into (prices, quantities)
    > zip [10.0, 20.0] [1, 2]         -- create cart from two lists
