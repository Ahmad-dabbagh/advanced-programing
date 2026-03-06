-- |
-- Module      : Student
-- Description : Task_04a - Defining Custom Data Types
--
-- This module introduces algebraic data types (ADTs) with record syntax,
-- accessor functions, and the Maybe type for safe operations.

module Student where

-- ============================================================================
-- Part 1: Defining the Student Type
-- ============================================================================

-- | A student has a name, ID number, grade (0-100), and major.
--
-- Using record syntax gives us automatic accessor functions:
--
--   * @studentName  :: Student -> String@
--   * @studentId    :: Student -> Int@
--   * @studentGrade :: Student -> Int@
--   * @studentMajor :: Student -> String@
--
data Student = Student
  { studentName  :: String
  , studentId    :: Int
  , studentGrade :: Int
  , studentMajor :: String
  } deriving (Show, Eq)

-- ============================================================================
-- Part 2: Sample Data
-- ============================================================================

-- | Sample students for testing
alice, bob, carol, dan :: Student
alice = Student "Alice" 12345 87 "CS"
bob   = Student "Bob"   12346 45 "Math"
carol = Student "Carol" 12347 92 "CS"
dan   = Student "Dan"   12348 78 "Physics"

-- | A sample list of students
--
-- >>> length sampleStudents
-- 4
sampleStudents :: [Student]
sampleStudents = [alice, bob, carol, dan]

-- ============================================================================
-- Part 3: Manual Accessor Functions
-- ============================================================================

-- Even though record syntax generates accessors automatically, it's useful
-- to understand how to write them manually. Implement these using pattern matching.

-- | Get the student's name (manual implementation)
--
-- >>> getName alice
-- "Alice"
--
-- >>> getName bob
-- "Bob"
getName :: Student -> String
getName (Student name _ _ _) = name-- TODO: Implement using pattern matching

-- | Get the student's ID (manual implementation)
--
-- >>> getId alice
-- 12345
getId :: Student -> Int
getId (Student _ sid _ _)= sid  -- TODO: Implement

-- | Get the student's grade (manual implementation)
--
-- >>> getGrade carol
-- 92
getGrade :: Student -> Int
getGrade (Student _ _ grade _) = grade-- TODO: Implement

-- | Get the student's major (manual implementation)
--
-- >>> getMajor dan
-- "Physics"
getMajor :: Student -> String
getMajor (Student _ _ _ major) = major -- TODO: Implement

-- ============================================================================
-- Part 4: Constructor Helpers
-- ============================================================================

-- Sometimes we want convenience functions to create students with
-- default values or validation.

-- | Create a student with a default grade of 0
--
-- >>> newStudent "Eve" 12349 "Biology"
-- Student {studentName = "Eve", studentId = 12349, studentGrade = 0, studentMajor = "Biology"}
newStudent :: String -> Int -> String -> Student
newStudent name sid major =
    Student name sid 0 major-- TODO: Create a student with grade = 0

-- | Create an honors student (grade automatically set to 95)
--
-- >>> makeHonorsStudent "Frank" 12350 "Chemistry"
-- Student {studentName = "Frank", studentId = 12350, studentGrade = 95, studentMajor = "Chemistry"}
makeHonorsStudent :: String -> Int -> String -> Student
makeHonorsStudent name sid major =
    Student name sid 95 major -- TODO: Create student with grade = 95

-- ============================================================================
-- Part 5: Predicates (Boolean Functions)
-- ============================================================================

-- Predicates are functions that return True or False based on some condition.

-- | Check if a student is passing (grade >= 50)
--
-- >>> isPassing alice
-- True
--
-- >>> isPassing bob
-- False
isPassing :: Student -> Bool
isPassing (Student _ _ grade _) =
    grade >= 50 -- TODO: Implement

-- | Check if a student has honors (grade >= 90)
--
-- >>> isHonors carol
-- True
--
-- >>> isHonors alice
-- False
isHonors :: Student -> Bool
isHonors (Student _ _ grade _) =
    grade >= 90 -- TODO: Implement

-- | Check if a student is in a specific major
--
-- >>> isInMajor "CS" alice
-- True
--
-- >>> isInMajor "Math" alice
-- False
isInMajor :: String -> Student -> Bool
isInMajor majorName (Student _ _ _ major) =
    majorName == major -- TODO: Implement

-- ============================================================================
-- Part 6: The Maybe Type
-- ============================================================================

-- The Maybe type represents values that might not exist.
--
--     data Maybe a = Nothing | Just a
--
-- This is crucial for safe programming - instead of crashing on errors,
-- we return Nothing to indicate failure.

-- | Safely get a letter grade, returns Nothing for invalid grades
--
-- >>> safeLetterGrade alice
-- Just 'B'
--
-- >>> safeLetterGrade carol
-- Just 'A'
--
-- >>> safeLetterGrade (Student "Invalid" 0 150 "X")
-- Nothing
--
-- >>> safeLetterGrade (Student "Invalid" 0 (-5) "X")
-- Nothing
--
-- Grading scale: A >= 90, B >= 80, C >= 70, D >= 60, F >= 0
safeLetterGrade :: Student -> Maybe Char
safeLetterGrade (Student _ _ grade _)
  | grade < 0 || grade > 100 = Nothing
  | grade >= 90              = Just 'A'
  | grade >= 80              = Just 'B'
  | grade >= 70              = Just 'C'
  | grade >= 60              = Just 'D'
  | otherwise                = Just 'F'
  -- TODO: Return Nothing if grade < 0 or > 100
  -- Otherwise return Just 'A', 'B', 'C', 'D', or 'F'

-- | Find a student by ID in a list
--
-- >>> findById 12345 sampleStudents
-- Just (Student {studentName = "Alice", studentId = 12345, studentGrade = 87, studentMajor = "CS"})
--
-- >>> findById 99999 sampleStudents
-- Nothing
findById :: Int -> [Student] -> Maybe Student
findById _ [] = Nothing
findById sid (s@(Student _ idNum _ _) : ss)
  | sid == idNum = Just s
  | otherwise    = findById sid ss -- TODO: Return the first student with matching ID, or Nothing

-- ============================================================================
-- Part 7: Record Update Syntax
-- ============================================================================

-- Haskell provides syntax to create a new record with some fields changed.
-- This doesn't modify the original - it creates a new value.
--
--     student { fieldName = newValue }

-- | Update a student's grade
--
-- >>> setGrade 95 bob
-- Student {studentName = "Bob", studentId = 12346, studentGrade = 95, studentMajor = "Math"}
--
-- >>> studentGrade (setGrade 95 bob)
-- 95
setGrade :: Int -> Student -> Student
setGrade newGrade s =
    s { studentGrade = newGrade } -- TODO: Use record update syntax: s { studentGrade = newGrade }

-- | Add bonus points to a student's grade (max 100)
--
-- >>> addBonus 10 alice
-- Student {studentName = "Alice", studentId = 12345, studentGrade = 97, studentMajor = "CS"}
--
-- >>> addBonus 20 carol
-- Student {studentName = "Carol", studentId = 12347, studentGrade = 100, studentMajor = "CS"}
addBonus :: Int -> Student -> Student
addBonus bonus s =
    s { studentGrade = min 100 (studentGrade s + bonus) }-- TODO: Add bonus but cap at 100 (use min)

-- | Change a student's major
--
-- >>> changeMajor "Biology" alice
-- Student {studentName = "Alice", studentId = 12345, studentGrade = 87, studentMajor = "Biology"}
changeMajor :: String -> Student -> Student
changeMajor newMajor s =
    s { studentMajor = newMajor } -- TODO: Use record update syntax

-- ============================================================================
-- Part 8: Working with Maybe
-- ============================================================================

-- When we have Maybe values, we need to handle both cases (Just and Nothing).

-- | Get the grade of a student found by ID, or a default value
--
-- >>> gradeOrDefault 12345 sampleStudents 0
-- 87
--
-- >>> gradeOrDefault 99999 sampleStudents 0
-- 0
gradeOrDefault :: Int -> [Student] -> Int -> Int
gradeOrDefault sid students defaultGrade =
    case findById sid students of
        Just s  -> studentGrade s
        Nothing -> defaultGrade
  -- TODO: Use findById, then pattern match on Maybe
  -- If found, return the student's grade; otherwise return defaultGrade

-- | Check if a student ID exists in the list
--
-- >>> studentExists 12345 sampleStudents
-- True
--
-- >>> studentExists 99999 sampleStudents
-- False
studentExists :: Int -> [Student] -> Bool
studentExists sid students =
    case findById sid students of
        Just _  -> True
        Nothing -> False
  -- TODO: Use findById and check if result is Just or Nothing

-- ============================================================================
-- Experiments (try in GHCi)
-- ============================================================================

-- >>> alice
-- >>> studentName alice
-- >>> studentGrade alice
--
-- >>> :type studentName
-- >>> :type Just
-- >>> :type Nothing
--
-- >>> findById 12345 sampleStudents
-- >>> findById 99999 sampleStudents
--
-- >>> alice { studentGrade = 100 }
-- >>> alice  -- original unchanged!
--
-- >>> case findById 12345 sampleStudents of { Nothing -> "Not found"; Just s -> studentName s }
