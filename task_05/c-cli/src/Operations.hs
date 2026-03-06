-- |
-- Module      : Operations
-- Description : Pure CRUD operations on Student lists
--
-- This module provides pure functions for Create, Read, Update, Delete operations.
-- All functions are pure and can be tested with doctests.

module Operations where

import Student
import Data.List (partition)

-- ============================================================================
-- READ Operations
-- ============================================================================

-- | Find a student by ID
--
-- >>> findStudent 12345 sampleStudents
-- Just (Student {studentName = "Alice", studentId = 12345, studentGrade = 87, studentMajor = "CS"})
--
-- >>> findStudent 99999 sampleStudents
-- Nothing
findStudent :: Int -> [Student] -> Maybe Student
findStudent _ [] = Nothing
findStudent sid (s:ss)
  | studentId s == sid = Just s
  | otherwise          = findStudent sid ss
 -- TODO: Implement

-- | Check if a student with given ID exists
--
-- >>> studentExists 12345 sampleStudents
-- True
--
-- >>> studentExists 99999 sampleStudents
-- False
studentExists :: Int -> [Student] -> Bool
studentExists sid students =
  case findStudent sid students of
    Just _  -> True
    Nothing -> False
-- TODO: Implement using findStudent

-- | Get all students in a specific major
--
-- >>> map studentName (studentsInMajor "CS" sampleStudents)
-- ["Alice","Carol"]
studentsInMajor :: String -> [Student] -> [Student]
studentsInMajor major students =
  filter (\s -> studentMajor s == major) students
 -- TODO: Implement

-- | Count students
--
-- >>> countStudents sampleStudents
-- 4
countStudents :: [Student] -> Int
countStudents = length

-- ============================================================================
-- CREATE Operations
-- ============================================================================

-- | Add a student to the list (prepends to front)
--
-- >>> let newStudent = Student "Eve" 12349 75 "Biology"
-- >>> length (addStudent newStudent sampleStudents)
-- 5
--
-- >>>  studentName (head(addStudent (Student "Eve" 12349 75 "Biology") sampleStudents))
-- "Eve"
addStudent :: Student -> [Student] -> [Student]
addStudent student students =
  student : students
 -- TODO: Implement (simple cons operation)

-- | Add a student only if ID doesn't already exist
--
-- >>> let newStudent = Student "Eve" 12349 75 "Biology"
-- >>> length (addStudentIfNew newStudent sampleStudents)
-- 5
--
-- >>> let duplicate = Student "Fake" 12345 50 "X"
-- >>> length (addStudentIfNew duplicate sampleStudents)
-- 4
addStudentIfNew :: Student -> [Student] -> [Student]
addStudentIfNew student students =
  if studentExists (studentId student) students
     then students
     else student : students
-- TODO: Check if ID exists first

-- ============================================================================
-- UPDATE Operations
-- ============================================================================

-- | Update a student's grade by ID
--
-- >>> let updated = updateGrade 12346 80 sampleStudents
-- >>> fmap studentGrade (findStudent 12346 updated)
-- Just 80
--
-- >>> let notFound = updateGrade 99999 100 sampleStudents
-- >>> length notFound
-- 4
updateGrade :: Int -> Int -> [Student] -> [Student]
updateGrade sid newGrade students =
  map updateOne students
  where
    updateOne s
      | studentId s == sid = s { studentGrade = newGrade }
      | otherwise          = s

  -- TODO: Update the grade of student with matching ID
  -- If ID not found, return list unchanged
  -- Hint: Use map with a conditional

-- | Update a student's major by ID
--
-- >>> let updated = updateMajor 12345 "Math" sampleStudents
-- >>> fmap studentMajor (findStudent 12345 updated)
-- Just "Math"
updateMajor :: Int -> String -> [Student] -> [Student]
updateMajor sid newMajor students =
  map updateOne students
  where
    updateOne s
      | studentId s == sid = s { studentMajor = newMajor }
      | otherwise          = s
-- TODO: Similar to updateGrade

-- | Add bonus points to a student by ID (capped at 100)
--
-- >>> let updated = addBonus 12345 10 sampleStudents
-- >>> fmap studentGrade (findStudent 12345 updated)
-- Just 97
--
-- >>> let updated2 = addBonus 12347 20 sampleStudents
-- >>> fmap studentGrade (findStudent 12347 updated2)
-- Just 100
addBonus :: Int -> Int -> [Student] -> [Student]
addBonus sid bonus students =
  map updateOne students
  where
    updateOne s
      | studentId s == sid =
          s { studentGrade = min 100 (studentGrade s + bonus) }
      | otherwise          = s
-- TODO: Implement with grade capped at 100

-- ============================================================================
-- DELETE Operations
-- ============================================================================

-- | Delete a student by ID
--
-- >>> length (deleteStudent 12345 sampleStudents)
-- 3
--
-- >>> studentExists 12345 (deleteStudent 12345 sampleStudents)
-- False
--
-- >>> length (deleteStudent 99999 sampleStudents)
-- 4
deleteStudent :: Int -> [Student] -> [Student]
deleteStudent sid students =
  filter (\s -> studentId s /= sid) students
 -- TODO: Use filter to remove student with matching ID

-- | Delete all students in a major
--
-- >>> length (deleteByMajor "CS" sampleStudents)
-- 2
deleteByMajor :: String -> [Student] -> [Student]
deleteByMajor major students =
  filter (\s -> studentMajor s /= major) students
 -- TODO: Implement

-- | Delete all failing students (grade < 50)
--
-- >>> length (deleteFailing sampleStudents)
-- 3
--
-- >>> all (\s -> studentGrade s >= 50) (deleteFailing sampleStudents)
-- True
deleteFailing :: [Student] -> [Student]
deleteFailing students =
  filter (\s -> studentGrade s >= 50) students
 -- TODO: Implement

-- ============================================================================
-- Bulk Operations
-- ============================================================================

-- | Apply a curve to all grades (add points, cap at 100)
--
-- >>> map studentGrade (curveAll 10 sampleStudents)
-- [97,55,100,88]
curveAll :: Int -> [Student] -> [Student]
curveAll bonus students =
  map (\s -> s { studentGrade = min 100 (studentGrade s + bonus) }) students
 -- TODO: Implement using map

-- | Get summary statistics
--
-- >>> let (passing, failing) = partitionByPassing sampleStudents
-- >>> (length passing, length failing)
-- (3,1)
partitionByPassing :: [Student] -> ([Student], [Student])
partitionByPassing students =
  partition (\s -> studentGrade s >= 50) students

  -- TODO: Split into (passing, failing) lists
  -- Hint: Use partition from Data.List, or implement with foldr

-- ============================================================================
-- Helper: catMaybes equivalent
-- ============================================================================

-- | Filter Nothing values from a list of Maybe
--
-- >>> catMaybes' [Just 1, Nothing, Just 2]
-- [1,2]
catMaybes' :: [Maybe a] -> [a]
catMaybes' [] = []
catMaybes' (Nothing : xs) = catMaybes' xs
catMaybes' (Just x : xs) = x : catMaybes' xs
