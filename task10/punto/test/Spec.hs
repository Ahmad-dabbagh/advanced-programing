import Test.DocTest

main :: IO ()
main = do
    putStrLn "Running doctests..."
    doctest ["-isrc", "src/Game/Board.hs", "src/Game/Rules.hs", "src/Game/Win.hs"]
