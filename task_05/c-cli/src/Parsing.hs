-- |
-- Module      : Parsing
-- Description : CSV parsing functions (pure)
--
-- This module provides pure functions for parsing and formatting Student CSV data.
-- All functions can be tested with doctests.

module Parsing where

import Student

-- ============================================================================
-- String Splitting
-- ============================================================================

-- | Split a string on a delimiter character
--
-- >>> splitOn ',' "Alice,12345,87,CS"
-- ["Alice","12345","87","CS"]
--
-- >>> splitOn ',' "hello"
-- ["hello"]
--
-- >>> splitOn ',' ""
-- [""]
splitOn :: Char -> String -> [String]
splitOn delim = go ""
  where
    go acc [] = [reverse acc]
    go acc (c:cs)
      | c == delim = reverse acc : go "" cs
      | otherwise  = go (c:acc) cs

 -- TODO: Implement

-- ============================================================================
-- Safe Parsing
-- ============================================================================

-- | Safely parse a string to an Int
--
-- >>> safeReadInt "123"
-- Just 123
--
-- >>> safeReadInt "abc"
-- Nothing
safeReadInt :: String -> Maybe Int
safeReadInt s =
  case reads s :: [(Int, String)] of
    [(n, "")] -> Just n
    _         -> Nothing
 -- TODO: Implement using reads

-- ============================================================================
-- CSV Parsing
-- ============================================================================

-- | Parse a single CSV line into a Student
--
-- >>> parseStudent "Alice,12345,87,CS"
-- Just (Student {studentName = "Alice", studentId = 12345, studentGrade = 87, studentMajor = "CS"})
--
-- >>> parseStudent "invalid"
-- Nothing
parseStudent :: String -> Maybe Student
parseStudent line =
  case splitOn ',' line of
    [name, idStr, gradeStr, major] ->
      case (safeReadInt idStr, safeReadInt gradeStr) of
        (Just sid, Just grade) -> Just (Student name sid grade major)
        _                      -> Nothing
    _ -> Nothing
 -- TODO: Implement

-- | Parse multiple CSV lines into a list of Students
--
-- >>> parseStudents "Alice,12345,87,CS\nBob,12346,45,Math"
-- [Student {studentName = "Alice", studentId = 12345, studentGrade = 87, studentMajor = "CS"},Student {studentName = "Bob", studentId = 12346, studentGrade = 45, studentMajor = "Math"}]
parseStudents :: String -> [Student]
parseStudents input =
  [ s | Just s <- map parseStudent (lines input) ]
  -- TODO: Implement

-- ============================================================================
-- CSV Formatting
-- ============================================================================

-- | Format a single Student as a CSV line
--
-- >>> formatStudent (Student "Alice" 12345 87 "CS")
-- "Alice,12345,87,CS"
formatStudent :: Student -> String
formatStudent (Student name sid grade major) =
  name ++ "," ++ show sid ++ "," ++ show grade ++ "," ++ major
 -- TODO: Implement

-- | Format a list of Students as CSV
--
-- >>> formatStudents [Student "Alice" 12345 87 "CS"]
-- "Alice,12345,87,CS"
formatStudents :: [Student] -> String
formatStudents students =
  unlines (map formatStudent students)
 -- TODO: Implement
