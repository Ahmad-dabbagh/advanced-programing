-- |
-- Module      : Main
-- Description : CLI CRUD Application for Student Management
--
-- This module provides the main entry point and IO functions for the
-- student management CLI application.

module Main where

import Student
import Operations
import Parsing
import System.Directory (doesFileExist)
import System.IO (hFlush, stdout)

-- ============================================================================
-- Main Entry Point
-- ============================================================================

-- | Main entry point - starts with empty student list or loads from file
main :: IO ()
main = do
  putStrLn "=== Student Management System ==="
  putStrLn "Loading students..."
  students <- loadStudentsOrEmpty "students.csv"
  putStrLn ("Loaded " ++ show (length students) ++ " students.")
  mainLoop students

-- ============================================================================
-- Main Loop
-- ============================================================================

-- | The main menu loop - recursively processes user commands
--
-- The student list is passed as an argument and updated with each operation.
-- This is how we maintain state in a purely functional way.
mainLoop :: [Student] -> IO ()
mainLoop students = do
  showMenu
  choice <- prompt "Enter choice"
  case choice of
    "1" -> do listAllStudents students
              mainLoop students
    "2" -> do newStudents <- handleAddStudent students
              mainLoop newStudents
    "3" -> do handleFindStudent students
              mainLoop students
    "4" -> do newStudents <- handleUpdateGrade students
              mainLoop newStudents
    "5" -> do newStudents <- handleDeleteStudent students
              mainLoop newStudents
    "6" -> do handleSave students
              mainLoop students
    "7" -> do newStudents <- handleLoad
              mainLoop newStudents
    "8" -> do putStrLn "Goodbye!"
              -- No recursive call = exit
    _   -> do putStrLn "Invalid choice. Please try again."
              mainLoop students

-- | Display the main menu
showMenu :: IO ()
showMenu = do
  putStrLn ""
  putStrLn "=== Menu ==="
  putStrLn "1. List all students"
  putStrLn "2. Add a student"
  putStrLn "3. Find student by ID"
  putStrLn "4. Update student grade"
  putStrLn "5. Delete student"
  putStrLn "6. Save to file"
  putStrLn "7. Load from file"
  putStrLn "8. Quit"

-- ============================================================================
-- Input Helpers
-- ============================================================================

-- | Display a prompt and read a line of input
prompt :: String -> IO String
prompt text = do
  putStr (text ++ ": ")
  hFlush stdout  -- Ensure prompt is displayed before reading
  getLine

-- | Safely read an Int from user input
--
-- Returns Nothing if input is not a valid integer.
getInt :: String -> IO (Maybe Int)
getInt promptText = do
  input <- prompt promptText
  return (safeReadInt input)

-- | Keep asking until we get a valid Int
getIntRequired :: String -> IO Int
getIntRequired promptText = do
  maybeInt <- getInt promptText
  case maybeInt of
    Just n  -> return n
    Nothing -> do
      putStrLn "Invalid number. Please try again."
      getIntRequired promptText
  -- TODO: Call getInt, if Nothing print error and recurse
  -- Pattern:
  --   do
  --     maybeInt <- getInt promptText
  --     case maybeInt of
  --       Just n  -> return n
  --       Nothing -> do
  --         putStrLn "Invalid number. Please try again."
  --         getIntRequired promptText

-- ============================================================================
-- Menu Handlers (IO Functions)
-- ============================================================================

-- | List all students
listAllStudents :: [Student] -> IO ()
listAllStudents [] = putStrLn "No students in the system."
listAllStudents students =
  mapM_
    (\(i, s) ->
        putStrLn $
          show i ++ ". "
          ++ studentName s ++ " ("
          ++ show (studentId s) ++ ") - "
          ++ show (studentGrade s) ++ " - "
          ++ studentMajor s
    )
    (zip [1..] students)

  -- TODO: Print each student with a number
  -- Example output:
  --   1. Alice (12345) - 87 - CS
  --   2. Bob (12346) - 45 - Math
  -- Hint: Use zip [1..] students, then mapM_ to print each

-- | Handle adding a new student
--
-- Prompts for student details, creates student, adds to list.
-- Returns updated list.
handleAddStudent :: [Student] -> IO [Student]
handleAddStudent students = do
  name <- prompt "Name"
  sid  <- getIntRequired "ID"
  grade <- getIntRequired "Grade"
  major <- prompt "Major"

  let newStudent = Student name sid grade major

  if studentExists sid students
    then do
      putStrLn "Student with this ID already exists!"
      return students
    else do
      putStrLn ("Added: " ++ name)
      return (addStudent newStudent students)

  -- TODO:
  -- 1. Prompt for name, id, grade, major
  -- 2. Create Student record
  -- 3. Check if ID already exists (use addStudentIfNew or check manually)
  -- 4. Print confirmation
  -- 5. Return updated list
  --
  -- Pattern:
  --   do
  --     name <- prompt "Name"
  --     studentId <- getIntRequired "ID"
  --     grade <- getIntRequired "Grade"
  --     major <- prompt "Major"
  --     let newStudent = Student name studentId grade major
  --     if studentExists studentId students
  --       then do putStrLn "Student with this ID already exists!"
  --               return students
  --       else do putStrLn ("Added: " ++ name)
  --               return (addStudent newStudent students)

-- | Handle finding a student by ID
handleFindStudent :: [Student] -> IO ()
handleFindStudent students = do
  sid <- getIntRequired "ID"
  case findStudent sid students of
    Just s ->
      putStrLn $
        studentName s ++ " ("
        ++ show (studentId s) ++ ") - "
        ++ show (studentGrade s) ++ " - "
        ++ studentMajor s
    Nothing ->
      putStrLn "Student not found."

  -- TODO:
  -- 1. Prompt for ID
  -- 2. Use findStudent (pure function)
  -- 3. Print result (found or not found)

-- | Handle updating a student's grade
--
-- Returns updated list.
handleUpdateGrade :: [Student] -> IO [Student]
handleUpdateGrade students = do
  sid <- getIntRequired "ID"

  if not (studentExists sid students)
    then do
      putStrLn "Student not found."
      return students
    else do
      newGrade <- getIntRequired "New grade"
      let updated = updateGrade sid newGrade students
      putStrLn "Grade updated."
      return updated

  -- TODO:
  -- 1. Prompt for ID
  -- 2. Check if student exists
  -- 3. If not, print error and return unchanged list
  -- 4. If yes, prompt for new grade
  -- 5. Use updateGrade (pure function)
  -- 6. Print confirmation
  -- 7. Return updated list

-- | Handle deleting a student
--
-- Returns updated list.
handleDeleteStudent :: [Student] -> IO [Student]
handleDeleteStudent students = do
  sid <- getIntRequired "ID"

  if not (studentExists sid students)
    then do
      putStrLn "Student not found."
      return students
    else do
      let updated = deleteStudent sid students
      putStrLn "Student deleted."
      return updated

  -- TODO:
  -- 1. Prompt for ID
  -- 2. Check if student exists
  -- 3. If not, print error and return unchanged list
  -- 4. If yes, use deleteStudent (pure function)
  -- 5. Print confirmation
  -- 6. Return updated list

-- | Handle saving to file
handleSave :: [Student] -> IO ()
handleSave students = do
  filename <- prompt "Filename (default: students.csv)"
  let path = if null filename then "students.csv" else filename
  saveStudents path students
  putStrLn ("Saved to " ++ path)

  -- TODO:
  -- 1. Prompt for filename (or use default "students.csv")
  -- 2. Save using saveStudents
  -- 3. Print confirmation

-- | Handle loading from file
--
-- Returns loaded list (or empty if file not found).
handleLoad :: IO [Student]
handleLoad = do
  filename <- prompt "Filename"
  exists <- doesFileExist filename

  if not exists
    then do
      putStrLn "File not found."
      return []
    else do
      students <- loadStudents filename
      putStrLn ("Loaded " ++ show (length students) ++ " students.")
      return students

  -- TODO:
  -- 1. Prompt for filename
  -- 2. Check if file exists
  -- 3. If not, print error and return empty list
  -- 4. If yes, load and return students

-- ============================================================================
-- File I/O Functions
-- ============================================================================

-- | Load students from a CSV file
loadStudents :: FilePath -> IO [Student]
loadStudents path = do
  contents <- readFile path
  return (parseStudents contents)

-- | Save students to a CSV file
saveStudents :: FilePath -> [Student] -> IO ()
saveStudents path students = writeFile path (formatStudents students)

-- | Load students if file exists, otherwise return empty list
loadStudentsOrEmpty :: FilePath -> IO [Student]
loadStudentsOrEmpty path = do
  exists <- doesFileExist path
  if exists
    then loadStudents path
    else return []

-- ============================================================================
-- Display Helpers
-- ============================================================================

-- | Format a student for display (not CSV)
--
-- >>> displayStudent (Student "Alice" 12345 87 "CS")
-- "Alice (12345) - 87 - CS"
displayStudent :: Student -> String
displayStudent s =
  studentName s ++ " (" ++ show (studentId s) ++ ") - " ++
  show (studentGrade s) ++ " - " ++ studentMajor s

-- | Print a numbered list of students
printNumberedStudents :: [Student] -> IO ()
printNumberedStudents students =
  mapM_ printOne (zip [1..] students)
  where
    printOne :: (Int, Student) -> IO ()
    printOne (n, s) = putStrLn (show n ++ ". " ++ displayStudent s)
