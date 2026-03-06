module Main (main) where

import Lib

-- | Demonstrate all three versions side-by-side on a set of example expressions.
main :: IO ()
main = do
    putStrLn "=== RPN Calculator: Three-Version Comparison ==="
    putStrLn ""
    putStrLn $ col "Expression" ++ col "V1 (explicit)" ++ col "V2 (monadic)" ++ "V3 (StateT)"
    putStrLn (replicate 76 '-')
    mapM_ showRow examples
  where
    examples :: [String]
    examples =
        [ "3 4 +"
        , "3 4 + 5 *"
        , "2 3 * 4 5 * +"
        , "42"
        , "5 1 2 + 4 * + 3 -"   -- 5 + (1+2)*4 - 3 = 14
        , "+"                    -- error: not enough operands
        , "3 4 + 5"              -- error: leftover on stack
        , "foo"                  -- error: bad token
        ]

    col :: String -> String
    col s = s ++ replicate (19 - length s) ' '

    showRow :: String -> IO ()
    showRow e =
        putStrLn $ col e
            ++ col (show (eval1 e))
            ++ col (show (eval2 e))
            ++ show (eval3 e)
