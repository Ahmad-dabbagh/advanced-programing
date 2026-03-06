 Task_03b: Working with Lists
============================

 Lists are the fundamental data structure in Haskell.
 A list is either empty `[]` or a head element followed by a tail: `x:xs`

> module Lists where
> import Prelude hiding (mconcat)


 Part 1: Implement Basic List Functions
 --------------------------------------

 Implement these WITHOUT using the built-in versions.
 Use pattern matching and recursion.

> -- | Count the number of elements in a list
> --
> -- >>> mlength []
> -- 0
> --
> -- >>> mlength [1,2,3]
> -- 3
> --
> -- >>> mlength "hello"
> -- 5
> --
> mlength :: [a] -> Int
> mlength [] = 0
> mlength (_:xs) = 1 + mlength xs  -- TODO: Implement without using length


> -- | Reverse a list
> --
> -- >>> mreverse []
> -- []
> --
> -- >>> mreverse [1,2,3]
> -- [3,2,1]
> --
> -- >>> mreverse "abc"
> -- "cba"
> --
> mreverse :: [a] -> [a]
> mreverse [] = [] 
> mreverse (x:xs) = mreverse xs ++ [x] -- TODO: Implement without using reverse


> -- | Concatenate two lists
> --
> -- >>> mconcat [] [1,2,3]
> -- [1,2,3]
> --
> -- >>> mconcat [1,2] [3,4]
> -- [1,2,3,4]
> --
> -- >>> mconcat "hello" " world"
> -- "hello world"
> --
> mconcat :: [a] -> [a] -> [a]
> mconcat [] ys = ys
> mconcat (x:xs) ys = x : Lists.mconcat xs ys   -- TODO: Implement without using ++


> -- | Take first n elements
> --
> -- >>> mtake 3 [1,2,3,4,5]
> -- [1,2,3]
> --
> -- >>> mtake 0 [1,2,3]
> -- []
> --
> -- >>> mtake 10 [1,2]
> -- [1,2]
> --
> mtake :: Int -> [a] -> [a]
> mtake 0 xs = []
> mtake _ [] = []
> mtake n (x:xs) = x: mtake (n-1) xs   -- TODO: Implement without using take


> -- | Drop first n elements
> --
> -- >>> mdrop 2 [1,2,3,4,5]
> -- [3,4,5]
> --
> -- >>> mdrop 0 [1,2,3]
> -- [1,2,3]
> --
> -- >>> mdrop 10 [1,2]
> -- []
> --
> mdrop :: Int -> [a] -> [a]
> mdrop 0 xs = xs
> mdrop n [] = []
> mdrop n (_:xs) = mdrop (n-1) xs    -- TODO: Implement without using drop


 Part 2: List Comprehensions
 ---------------------------

 List comprehensions provide a concise way to build lists.

> -- | Double each element
> --
> -- >>> doubles [1,2,3]
> -- [2,4,6]
> --
> doubles :: [Int] -> [Int]
> doubles xs = [2*x | x <- xs]  -- TODO: Use list comprehension [... | ...]


> -- | Keep only even numbers
> --
> -- >>> evens [1,2,3,4,5,6]
> -- [2,4,6]
> --
> evens :: [Int] -> [Int]
> evens xs = [x | x <- xs , even x]  -- TODO: Use list comprehension with filter


> -- | Square numbers greater than 3
> --
> -- >>> squareLargeNumbers [1,2,3,4,5]
> -- [16,25]
> --
> squareLargeNumbers :: [Int] -> [Int]
> squareLargeNumbers xs = [x^2 | x <- xs , x > 3]  -- TODO: Combine filter and transform


> -- | All pairs where first < second
> --
> -- >>> orderedPairs [1,2,3]
> -- [(1,2),(1,3),(2,3)]
> --
> orderedPairs :: [Int] -> [(Int, Int)]
> orderedPairs xs = [(x,y) | x <- xs ,y <-xs , y > x]  -- TODO: Use two generators with condition


 Part 3: More List Operations
 ----------------------------

> -- | Check if element is in list
> --
> -- >>> melem 2 [1,2,3]
> -- True
> --
> -- >>> melem 5 [1,2,3]
> -- False
> --
> -- >>> melem 'a' "hello"
> -- False
> --
> melem :: Eq a => a -> [a] -> Bool

> melem _ [] = False
> melem n (x:xs) = (n==x) || melem n xs  -- TODO: Implement


> -- | Remove duplicates (keep first occurrence)
> --
> -- >>> removeDuplicates [1,2,1,3,2,4]
> -- [1,2,3,4]
> --
> -- >>> removeDuplicates "aabbcc"
> -- "abc"
> --
> removeDuplicates :: Eq a => [a] -> [a]
> removeDuplicates xs = go [] xs  -- TODO: Implement
>	where 
>	 go _ [] = [] 
>	 go seen (x:xs) 
>           | melem x seen= go seen xs
>           | otherwise = x: go (x:seen) xs


 Part 4: Real-World Example - Grade Processing
 ---------------------------------------------

 Let's use lists to process student grades (0-100 scale).

> type Grade = Int

> -- | Filter out failing grades (below 50)
> --
> -- >>> passingGrades [45, 72, 38, 91, 55, 49]
> -- [72,91,55]
> --
> passingGrades :: [Grade] -> [Grade]
> passingGrades grades = [x | x <- grades , x >50]
> --can use also passingGrades grades = filter (>50) grades  -- TODO: Use list comprehension with filter


> -- | Count how many students passed
> --
> -- >>> countPassing [45, 72, 38, 91, 55, 49]
> -- 3
> --
> countPassing :: [Grade] -> Int
> countPassing grades = length [x | x <- grades, x>50]  -- TODO: Use length on filtered list


> -- | Get the top N grades (assumes sorted input)
> --
> -- >>> topGrades 3 [91, 85, 78, 72, 65, 55]
> -- [91,85,78]
> --
> topGrades :: Int -> [Grade] -> [Grade]
> topGrades n grades = take n grades -- TODO: Use take 


> -- | Curve all grades by adding points (max 100)
> --
> -- >>> curveGrades 5 [45, 72, 98, 91]
> -- [50,77,100,96]
> --
> curveGrades :: Int -> [Grade] -> [Grade]
> curveGrades points grades = [min 100 (x + points) | x <- grades]
>   -- TODO: Use list comprehension, cap at 100 with min
> -- [if x + points > 100 then 100 else x + points | x <- grades] <== Possible 


> -- | Assign letter grades based on score
> --
> -- >>> letterGrade 92
> -- 'A'
> --
> -- >>> letterGrade 75
> -- 'C'
> --
> -- >>> letterGrade 45
> -- 'F'
> --
> letterGrade :: Grade -> Char
> letterGrade g  
>  | g >= 90 = 'A'
>  | g >=80 = 'B'
>  | g>= 70 = 'C'
>  | g>= 60 = 'D'
>  | otherwise ='F'
>   -- TODO: Use guards: A >= 90, B >= 80, C >= 70, D >= 60, F otherwise


 Experiments
 -----------

 Try these in GHCi:

    > [1..10]
    > [1,3..10]
    > [10,9..1]
    > ['a'..'z']
    > [x^2 | x <- [1..5]]
    > [[1,2], [3,4]] ++ [[5,6]]
    > concat [[1,2], [3,4], [5,6]]

 Grade processing experiments:

    > let grades = [85, 72, 91, 45, 68, 77]
    > [g | g <- grades, g >= 50]          -- passing grades
    > [g + 5 | g <- grades]               -- curve by 5
    > [min 100 (g + 10) | g <- grades]    -- curve, capped at 100
    > length [g | g <- grades, g >= 90]   -- count A grades
