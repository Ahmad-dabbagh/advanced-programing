-- |
-- Module      : FileIO
-- Description : Task_05b - File I/O for Student Data
--
-- This module provides functions to load and save student data from/to CSV files.
-- It demonstrates how to combine pure parsing functions with IO operations.

module FileIO where

import System.Directory (doesFileExist)
-- import Parsing
-- ============================================================================
-- Student Data Type (same as Parsing module)
-- ============================================================================

-- | Student record
data Student = Student
  { studentName  :: String
  , studentId    :: Int
  , studentGrade :: Int
  , studentMajor :: String
  } deriving (Show, Eq)

-- ============================================================================
-- Pure Parsing Functions (copy from Task_05a or import)
-- ============================================================================

-- | Split a string on a delimiter character
--
-- >>> splitOn ',' "Alice,12345,87,CS"
-- ["Alice","12345","87","CS"]
splitOn :: Char -> String -> [String]
splitOn delim = go ""
  where
    go acc [] = [reverse acc]
    go acc (c:cs)
      | c == delim = reverse acc : go "" cs
      | otherwise  = go (c:acc) cs
-- TODO: Copy implementation from Task_05a

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
 -- TODO: Copy implementation from Task_05a

-- | Parse a single CSV line into a Student
--
-- >>> parseStudent "Alice,12345,87,CS"
-- Just (Student {studentName = "Alice", studentId = 12345, studentGrade = 87, studentMajor = "CS"})
parseStudent :: String -> Maybe Student
parseStudent line =
  case splitOn ',' line of
    [name, idStr, gradeStr, major] ->
      case (safeReadInt idStr, safeReadInt gradeStr) of
        (Just sid, Just grade) -> Just (Student name sid grade major)
        _                      -> Nothing
    _ -> Nothing
-- TODO: Copy implementation from Task_05a

-- | Parse multiple CSV lines into a list of Students
--
-- >>> parseStudents "Alice,12345,87,CS\nBob,12346,45,Math"
-- [Student {studentName = "Alice", studentId = 12345, studentGrade = 87, studentMajor = "CS"},Student {studentName = "Bob", studentId = 12346, studentGrade = 45, studentMajor = "Math"}]
parseStudents :: String -> [Student]
parseStudents input =
  foldr step [] (map parseStudent (lines input))
  where
    step (Just s) acc = s : acc
    step Nothing  acc = acc
-- TODO: Copy implementation from Task_05a

-- | Format a single Student as a CSV line
--
-- >>> formatStudent (Student "Alice" 12345 87 "CS")
-- "Alice,12345,87,CS"
formatStudent :: Student -> String
formatStudent (Student name sid grade major) =
  name ++ "," ++ show sid ++ "," ++ show grade ++ "," ++ major
-- TODO: Copy implementation from Task_05a

-- | Format a list of Students as CSV
--
-- >>> formatStudents [Student "Alice" 12345 87 "CS"]
-- "Alice,12345,87,CS"
formatStudents :: [Student] -> String
formatStudents [] = ""
formatStudents ss = foldr1 (\a b -> a ++ "\n" ++ b) (map formatStudent ss)
-- TODO: Copy implementation from Task_05a

-- ============================================================================
-- Part 1: Basic File I/O
-- ============================================================================

-- | Load students from a CSV file
--
-- This function:
-- 1. Reads the file contents (IO)
-- 2. Parses the contents using pure function (pure)
-- 3. Returns the list of students (IO)
--
-- Example usage in GHCi:
-- >>> students <- loadStudents "students.csv"
-- >>> print students
loadStudents :: FilePath -> IO [Student]
loadStudents path = do
  exists <- doesFileExist path
  if not exists
    then return []
    else do
      content <- readFile path
      return (parseStudents content)

  -- TODO: Use readFile to get contents, then parseStudents
  -- Pattern:
  --   do
  --     contents <- readFile path
  --     return (parseStudents contents)

-- | Save students to a CSV file
--
-- This function:
-- 1. Formats students using pure function (pure)
-- 2. Writes to file (IO)
--
-- Example usage in GHCi:
-- >>> saveStudents "output.csv" [Student "Alice" 12345 87 "CS"]
saveStudents :: FilePath -> [Student] -> IO ()
saveStudents path students =
  writeFile path (formatStudents students)  -- TODO: Use formatStudents to get string, then writeFile
  -- Pattern:
  --   writeFile path (formatStudents students)
  -- Or with do-notation if you prefer

-- ============================================================================
-- Part 2: Safe File Operations
-- ============================================================================

-- | Check if a student file exists
--
-- Example usage in GHCi:
-- >>> exists <- studentFileExists "students.csv"
-- >>> print exists
studentFileExists :: FilePath -> IO Bool
studentFileExists path = doesFileExist path
  -- TODO: Use doesFileExist from System.Directory

-- | Load students from file if it exists, otherwise return empty list
--
-- This is safer than loadStudents because it won't crash on missing file.
--
-- Example usage in GHCi:
-- >>> students <- loadStudentsOrEmpty "maybe-missing.csv"
loadStudentsOrEmpty :: FilePath -> IO [Student]
loadStudentsOrEmpty path = do
  exists <- doesFileExist path
  if exists
    then loadStudents path
    else return []
  -- TODO: Check if file exists first
  -- If yes, load students
  -- If no, return empty list
  -- Pattern:
  --   do
  --     exists <- doesFileExist path
  --     if exists
  --       then loadStudents path
  --       else return []

-- ============================================================================
-- Part 3: File Operations with Feedback
-- ============================================================================

-- | Load students and print a message about how many were loaded
--
-- Example output:
-- "Loaded 3 students from students.csv"
loadStudentsWithMessage :: FilePath -> IO [Student]
loadStudentsWithMessage path = do
  students <- loadStudents path
  putStrLn ("Loaded " ++ show (length students) ++ " students from " ++ path)
  return students  
  -- TODO: Load students, print message with count, return students
  -- Pattern:
  --   do
  --     students <- loadStudents path
  --     putStrLn ("Loaded " ++ show (length students) ++ " students from " ++ path)
  --     return students

-- | Save students and print a confirmation message
--
-- Example output:
-- "Saved 3 students to output.csv"
saveStudentsWithMessage :: FilePath -> [Student] -> IO ()
saveStudentsWithMessage path students = do
  saveStudents path students
  putStrLn ("Saved " ++ show (length students) ++ " students to " ++ path)
  -- TODO: Save students, then print confirmation message

-- ============================================================================
-- Part 4: Combining Pure Logic with IO
-- ============================================================================

-- | Load students, apply a pure transformation, save to new file
--
-- This demonstrates the "functional core, imperative shell" pattern:
-- 1. Read data (IO)
-- 2. Transform data (pure)
-- 3. Write data (IO)
--
-- Example: Add 5 bonus points to all students
-- >>> processStudentFile "input.csv" "output.csv" (map (addBonus 5))
processStudentFile :: FilePath -> FilePath -> ([Student] -> [Student]) -> IO ()
processStudentFile inputPath outputPath transform = do
  students <- loadStudents inputPath
  let transformed = transform students
  saveStudents outputPath transformed
  -- TODO: Load from input, apply transform, save to output
  -- Pattern:
  --   do
  --     students <- loadStudents inputPath
  --     let transformed = transform students
  --     saveStudents outputPath transformed

-- | Helper: Add bonus points to a student (pure function)
--
-- >>> addBonus 5 (Student "Alice" 12345 87 "CS")
-- Student {studentName = "Alice", studentId = 12345, studentGrade = 92, studentMajor = "CS"}
--
-- >>> addBonus 20 (Student "Bob" 1 95 "X")
-- Student {studentName = "Bob", studentId = 1, studentGrade = 100, studentMajor = "X"}
addBonus :: Int -> Student -> Student
addBonus bonus s = s { studentGrade = min 100 (studentGrade s + bonus) }

-- ============================================================================
-- Part 5: Error Handling (Optional Challenge)
-- ============================================================================

-- | Try to load students, returning either an error message or the students
--
-- This uses Either for error handling instead of crashing.
--
-- Example usage:
-- >>> result <- tryLoadStudents "students.csv"
-- >>> case result of
-- >>>   Left err -> putStrLn ("Error: " ++ err)
-- >>>   Right students -> print students
tryLoadStudents :: FilePath -> IO (Either String [Student])
tryLoadStudents path = undefined
  -- TODO (Optional): Check if file exists
  -- If not, return Left "File not found: <path>"
  -- If yes, load and return Right students
  -- Hint: Use Either type: Left for errors, Right for success

-- ============================================================================
-- Sample Data for Testing
-- ============================================================================

-- | Sample students for manual testing
sampleStudents :: [Student]
sampleStudents =
  [ Student "Alice" 12345 87 "CS"
  , Student "Bob"   12346 45 "Math"
  , Student "Carol" 12347 92 "CS"
  ]

-- | Create a test file with sample data
--
-- Run this in GHCi to set up test data:
-- >>> createTestFile
--createTestFile :: IO ()
--createTestFile = saveStudents "test-students.csv" sampleStudents

-- ============================================================================
-- Experiments (try in GHCi)
-- ============================================================================

-- First create a test file:
-- >>> createTestFile
--
-- Then try:
-- >>> students <- loadStudents "test-students.csv"
-- >>> print students
-- >>> length students
--
-- >>> saveStudents "copy.csv" students
-- >>> loadStudents "copy.csv"
--
-- >>> processStudentFile "test-students.csv" "curved.csv" (map (addBonus 10))
-- >>> loadStudents "curved.csv"
