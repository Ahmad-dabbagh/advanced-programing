-- |
-- Module      : Parsing
-- Description : Task_05a - CSV Parsing (Pure Functions)
--
-- This module provides pure functions for parsing CSV data into Student records
-- and formatting Student records back to CSV. All functions are pure and can be
-- tested with doctests.

module Parsing where

import Data.List (intercalate)

-- ============================================================================
-- Student Data Type
-- ============================================================================

-- | Student record with name, ID, grade, and major
data Student = Student
  { studentName  :: String
  , studentId    :: Int
  , studentGrade :: Int
  , studentMajor :: String
  } deriving (Show, Eq)

-- ============================================================================
-- Part 1: String Splitting
-- ============================================================================

-- | Split a string on a delimiter character
--
-- This is the key helper function for CSV parsing.
--
-- >>> splitOn ',' "Alice,12345,87,CS"
-- ["Alice","12345","87","CS"]
--
-- >>> splitOn ',' "hello"
-- ["hello"]
--
-- >>> splitOn ',' ""
-- [""]
--
-- >>> splitOn ',' "a,,b"
-- ["a","","b"]
--
-- >>> splitOn ',' ",a,b,"
-- ["","a","b",""]
splitOn :: Char -> String -> [String]
splitOn delim = go ""
  where
    go acc [] = [reverse acc]
    go acc (c:cs)
      | c == delim = reverse acc : go "" cs
      | otherwise  = go (c:acc) cs

  -- TODO: Implement using recursion or foldr
  -- Hint: Build up the current word, when you hit the delimiter,
  -- add the current word to the result and start a new one

-- ============================================================================
-- Part 2: Safe Number Parsing
-- ============================================================================

-- | Safely parse a string to an Int, returning Nothing on failure
--
-- >>> safeReadInt "123"
-- Just 123
--
-- >>> safeReadInt "-42"
-- Just (-42)
--
-- >>> safeReadInt "abc"
-- Nothing
--
-- >>> safeReadInt "12.5"
-- Nothing
--
-- >>> safeReadInt ""
-- Nothing
--
-- >>> safeReadInt "123abc"
-- Nothing

safeReadInt :: String -> Maybe Int
safeReadInt s =
  case reads s :: [(Int, String)] of
    [(n, "")] -> Just n
    _         -> Nothing

  -- TODO: Use 'reads' function
  -- reads "123" :: [(Int, String)] gives [(123, "")]
  -- reads "abc" :: [(Int, String)] gives []
  -- Only return Just if there's exactly one parse with no remainder

-- ============================================================================
-- Part 3: Parsing CSV to Student
-- ============================================================================

-- | Parse a single CSV line into a Student
--
-- CSV format: name,id,grade,major
--
-- >>> parseStudent "Alice,12345,87,CS"
-- Just (Student {studentName = "Alice", studentId = 12345, studentGrade = 87, studentMajor = "CS"})
--
-- >>> parseStudent "Bob,12346,45,Math"
-- Just (Student {studentName = "Bob", studentId = 12346, studentGrade = 45, studentMajor = "Math"})
--
-- >>> parseStudent "invalid"
-- Nothing
--
-- >>> parseStudent ""
-- Nothing
--
-- >>> parseStudent "Alice,notanumber,87,CS"
-- Nothing
--
-- >>> parseStudent "Alice,12345,notanumber,CS"
-- Nothing
--
-- >>> parseStudent "TooMany,1,2,3,Fields"
-- Nothing
--
-- >>> parseStudent "TooFew,1,2"
-- Nothing

parseStudent :: String -> Maybe Student
parseStudent line =
  case splitOn ',' line of
    [name, idStr, gradeStr, major] ->
      case (safeReadInt idStr, safeReadInt gradeStr) of
        (Just sid, Just grade) ->
          Just (Student name sid grade major)
        _ -> Nothing
    _ -> Nothing

  -- TODO: Split on comma, check for exactly 4 fields,
  -- parse id and grade as Int, construct Student if all succeed
  -- Return Nothing if anything fails

-- | Parse multiple CSV lines into a list of Students
--
-- Skips lines that fail to parse (invalid lines are silently dropped)
--
-- >>> parseStudents "Alice,12345,87,CS\nBob,12346,45,Math"
-- [Student {studentName = "Alice", studentId = 12345, studentGrade = 87, studentMajor = "CS"},Student {studentName = "Bob", studentId = 12346, studentGrade = 45, studentMajor = "Math"}]
--
-- >>> parseStudents ""
-- []
--
-- >>> parseStudents "Alice,12345,87,CS\ninvalid\nBob,12346,45,Math"
-- [Student {studentName = "Alice", studentId = 12345, studentGrade = 87, studentMajor = "CS"},Student {studentName = "Bob", studentId = 12346, studentGrade = 45, studentMajor = "Math"}]
--
-- >>> parseStudents "invalid\nalso invalid"
-- []
parseStudents :: String -> [Student]
parseStudents input =
  [s | Just s <- map parseStudent (lines input)]


  -- TODO: Split on newlines, parse each line, keep only successful parses
  -- Hint: Use 'lines' to split, 'map' to parse, then filter out Nothing values
  -- Or use mapMaybe from Data.Maybe

-- ============================================================================
-- Part 4: Formatting Student to CSV
-- ============================================================================

-- | Format a single Student as a CSV line
--
-- >>> formatStudent (Student "Alice" 12345 87 "CS")
-- "Alice,12345,87,CS"
--
-- >>> formatStudent (Student "Bob" 12346 45 "Math")
-- "Bob,12346,45,Math

formatStudent :: Student -> String
formatStudent (Student name sid grade major) =
  name ++ "," ++ show sid ++ "," ++ show grade ++ "," ++ major

  -- TODO: Combine fields with commas
  -- Hint: Use 'show' to convert Int to String, then concatenate

-- | Format a list of Students as CSV (multiple lines)
--
-- >>> formatStudents [Student "Alice" 12345 87 "CS", Student "Bob" 12346 45 "Math"]
-- "Alice,12345,87,CS\nBob,12346,45,Math"
--
-- >>> formatStudents []
-- ""
--
-- >>> formatStudents [Student "Alice" 12345 87 "CS"]
-- "Alice,12345,87,CS"

formatStudents :: [Student] -> String
formatStudents students =
  intercalate "\n" (map formatStudent students)

  -- TODO: Format each student, join with newlines
  -- Hint: Use 'map' and 'unlines' (but watch out - unlines adds trailing newline)
  -- Or use intercalate "\n" from Data.List

-- ============================================================================
-- Part 5: Round-Trip Property
-- ============================================================================

-- | Verify that formatting then parsing returns the original
--
-- This is a "round-trip" property - important for data integrity!
--
-- >>> let s = Student "Alice" 12345 87 "CS" in parseStudent (formatStudent s)
-- Just (Student {studentName = "Alice", studentId = 12345, studentGrade = 87, studentMajor = "CS"})
--
-- >>> let students = [Student "A" 1 90 "X", Student "B" 2 80 "Y"] in parseStudents (formatStudents students) == students
-- True

-- ============================================================================
-- Part 6: Helper Functions for Maybe
-- ============================================================================

-- | Extract values from a list of Maybe, discarding Nothing
--
-- This is like 'catMaybes' from Data.Maybe
--
-- >>> catMaybes' [Just 1, Nothing, Just 2, Nothing, Just 3]
-- [1,2,3]
--
-- >>> catMaybes' [Nothing, Nothing]
-- []
--
-- >>> catMaybes' []
-- []
catMaybes' :: [Maybe a] -> [a]
catMaybes' xs = [v | Just v <- xs]
-- TODO: Implement using foldr or list comprehension

-- | Apply a function and keep only Just results
--
-- This is like 'mapMaybe' from Data.Maybe
--
-- >>> mapMaybe' safeReadInt ["1", "abc", "2", "def", "3"]
-- [1,2,3]
--
-- >>> mapMaybe' safeReadInt []
-- []
mapMaybe' :: (a -> Maybe b) -> [a] -> [b]
mapMaybe' f xs = catMaybes' (map f xs)
-- TODO: Implement using map and catMaybes', or with foldr

-- ============================================================================
-- Sample Data for Testing
-- ============================================================================

-- | Sample CSV data
sampleCSV :: String
sampleCSV = "Alice,12345,87,CS\nBob,12346,45,Math\nCarol,12347,92,CS"

-- | Sample students
sampleStudents :: [Student]
sampleStudents =
  [ Student "Alice" 12345 87 "CS"
  , Student "Bob"   12346 45 "Math"
  , Student "Carol" 12347 92 "CS"
  ]

-- ============================================================================
-- Experiments (try in GHCi)
-- ============================================================================

-- >>> splitOn ',' "a,b,c"
-- >>> lines "a\nb\nc"
-- >>> unlines ["a", "b", "c"]
-- >>> reads "123" :: [(Int, String)]
-- >>> reads "abc" :: [(Int, String)]
