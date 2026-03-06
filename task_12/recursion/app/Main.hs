module Main (main) where

import Lib

main :: IO ()
main = do
    putStrLn "=== Section A: Examples — read and identify tail recursion ==="
    putStrLn ""
    putStrLn $ "sumList [1..5]                   = " ++ show (sumList [1 .. 5])
    putStrLn $ "myProductAcc [1..5] 1            = " ++ show (myProductAcc [1 .. 5] 1)
    putStrLn $ "collatzSteps 27                  = " ++ show (collatzSteps 27)
    putStrLn $ "reverseMovesAcc [1..5 :: Int] [] = "
        ++ show (reverseMovesAcc [1 .. 5 :: Int] [])
    putStrLn ""
    putStrLn "=== Section B: Your implementations ==="
    putStrLn "(Run 'stack test' to verify with doctests.)"
    putStrLn "(Functions below will throw errors until you implement them.)"
