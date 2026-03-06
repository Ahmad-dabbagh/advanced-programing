-- |
-- Module      : Processing
-- Description : Task_04b - Processing Student Lists
--
-- This module applies functional patterns (map, filter, fold) to lists
-- of custom data types. You'll practice different function writing styles.

module Processing where

-- ============================================================================
-- Student Data Type (redefined for self-contained module)
-- ============================================================================

-- | Student data type with record syntax
data Student = Student
  { studentName  :: String
  , studentId    :: Int
  , studentGrade :: Int
  , studentMajor :: String
  } deriving (Show, Eq)

-- ============================================================================
-- Sample Data
-- ============================================================================

-- | Sample students for testing
alice, bob, carol, dan, eve :: Student
alice = Student "Alice"  12345 87 "CS"
bob   = Student "Bob"    12346 45 "Math"
carol = Student "Carol"  12347 92 "CS"
dan   = Student "Dan"    12348 78 "Physics"
eve   = Student "Eve"    12349 55 "CS"

-- | Sample class list
--
-- >>> length classA
-- 5
classA :: [Student]
classA = [alice, bob, carol, dan, eve]

-- | Empty class for edge case testing
emptyClass :: [Student]
emptyClass = []

-- ============================================================================
-- Part 1: Mapping - Extracting Data
-- ============================================================================

-- Use 'map' to extract information from lists of students.

-- | Get all student names
--
-- Style: Point-free (accessor function directly)
--
-- >>> getNames classA
-- ["Alice","Bob","Carol","Dan","Eve"]
getNames :: [Student] -> [String]
getNames = map studentName -- TODO

-- | Get all student grades
--
-- Style: Explicit argument with lambda
--
-- >>> getGrades classA
-- [87,45,92,78,55]
getGrades :: [Student] -> [Int]
getGrades students =
    map (\s -> studentGrade s) students  -- TODO

-- | Get all unique majors (remove duplicates)
--
-- >>> getMajors classA
-- ["CS","Math","Physics"]
--
-- Hint: Use map, then remove duplicates (you can use nub-like logic or list comprehension)
getMajors :: [Student] -> [String]
getMajors students = removeDuplicates (map studentMajor students)
  where
    removeDuplicates [] = []
    removeDuplicates (x:xs)
      | x `elem` xs = removeDuplicates xs
      | otherwise   = x : removeDuplicates xs


-- ============================================================================
-- Part 2: Filtering - Selecting Students
-- ============================================================================

-- Use 'filter' and list comprehensions to select students.

-- | Get all passing students (grade >= 50)
--
-- Style: Using filter with lambda
--
-- >>> map studentName (passingStudents classA)
-- ["Alice","Carol","Dan","Eve"]
passingStudents :: [Student] -> [Student]
passingStudents =
    filter (\s -> studentGrade s >= 50) -- TODO: Use filter

-- | Get all failing students (grade < 50)
--
-- Style: Using list comprehension
--
-- >>> map studentName (failingStudents classA)
-- ["Bob"]
failingStudents :: [Student] -> [Student]
failingStudents students = [s | s <- students, studentGrade s < 50] -- TODO: Use list comprehension [s | s <- students, ...]

-- | Get students in a specific major
--
-- Style: Using filter with a helper predicate
--
-- >>> map studentName (studentsInMajor "CS" classA)
-- ["Alice","Carol","Eve"]
--
-- >>> studentsInMajor "Biology" classA
-- []
studentsInMajor :: String -> [Student] -> [Student]
studentsInMajor major students = filter isInMajor students
  where
    isInMajor s = studentMajor s == major
  -- TODO: Use filter with a condition on studentMajor

-- | Get honors students (grade >= 90)
--
-- >>> map studentName (honorsStudents classA)
-- ["Carol"]
honorsStudents :: [Student] -> [Student]
honorsStudents = filter (\s -> studentGrade s >= 90) -- TODO: Implement

-- ============================================================================
-- Part 3: Folding - Aggregating Data
-- ============================================================================

-- Use 'foldr' and 'foldl' to compute aggregate values.

-- | Calculate total of all grades
--
-- Style: Using foldr with explicit lambda
--
-- >>> totalGrades classA
-- 357
--
-- >>> totalGrades emptyClass
-- 0
totalGrades :: [Student] -> Int
totalGrades = foldr (\s acc -> studentGrade s + acc) 0-- TODO: Use foldr (\s acc -> ...) 0

-- | Count number of students
--
-- Style: Using foldr (don't use length!)
--
-- >>> countStudents classA
-- 5
--
-- >>> countStudents emptyClass
-- 0
countStudents :: [Student] -> Int
countStudents = foldr (\_ acc -> acc + 1) 0 


-- | Count students in a specific major
--
-- Style: Using foldr with guards in the lambda
--
-- >>> countInMajor "CS" classA
-- 3
--
-- >>> countInMajor "Biology" classA
-- 0
countInMajor :: String -> [Student] -> Int
countInMajor major =
    foldr (\s acc ->
        if studentMajor s == major
            then acc + 1
            else acc
    ) 0 
-- ============================================================================
-- Part 4: Safe Operations with Maybe
-- ============================================================================

-- Operations that might fail should return Maybe.

-- | Calculate average grade, returning Nothing for empty list
--
-- Style: Using guards and where clause
--
-- >>> averageGrade classA
-- Just 71.4
--
-- >>> averageGrade emptyClass
-- Nothing
--
-- >>> averageGrade [alice]
-- Just 87.0
averageGrade :: [Student] -> Maybe Double
averageGrade students
  | null students = Nothing
  | otherwise     = Just (fromIntegral total / fromIntegral cnt)
  where
    total = totalGrades students
    cnt   = countStudents students
  -- TODO: Return Nothing if empty list
  -- Otherwise calculate: fromIntegral (sum of grades) / fromIntegral (count)
  -- Use where clause for helper values

-- | Find the student with highest grade
--
-- Style: Using pattern matching and recursion (or fold)
--
-- >>> fmap studentName (topStudent classA)
-- Just "Carol"
--
-- >>> topStudent emptyClass
-- Nothing
topStudent :: [Student] -> Maybe Student
topStudent []     = Nothing
topStudent (s:ss) = Just (foldr pickTop s ss)
  where
    pickTop x best
      | studentGrade x > studentGrade best = x
      | otherwise = best 
  -- TODO: Return Nothing for empty list
  -- Return Just the student with highest grade

-- | Find the student with lowest grade
--
-- >>> fmap studentName (bottomStudent classA)
-- Just "Bob"
--
-- >>> bottomStudent emptyClass
-- Nothig
bottomStudent :: [Student] -> Maybe Student
bottomStudent []     = Nothing
bottomStudent (s:ss) = Just (foldr pickBottom s ss)
  where
    pickBottom x best
      | studentGrade x < studentGrade best = x
      | otherwise                          = best 

-- ============================================================================
-- Part 5: Transforming Students
-- ============================================================================

-- Create new lists with modified student records.

-- | Add bonus points to all students (capped at 100)
--
-- Style: Using map with record update syntax
--
-- >>> map studentGrade (curveAllGrades 10 classA)
-- [97,55,100,88,65]
curveAllGrades :: Int -> [Student] -> [Student]
curveAllGrades bonus students =
  map (\s -> s { studentGrade = min 100 (studentGrade s + bonus) }) students

  -- TODO: Use map to update each student's grade
  -- Remember to cap at 100 using min

-- | Set all students to the same major
--
-- >>> map studentMajor (setAllMajors "Undeclared" classA)
-- ["Undeclared","Undeclared","Undeclared","Undeclared","Undeclared"]
setAllMajors :: String -> [Student] -> [Student]
setAllMajors major students =
  map (\s -> s { studentMajor = major }) students
 -- TODO: Use map with record update

-- ============================================================================
-- Part 6: Combining Operations
-- ============================================================================

-- Chain multiple operations together.

-- | Get names of passing students
--
-- Style: Function composition with (.)
--
-- >>> passingNames classA
-- ["Alice","Carol","Dan","Eve"]
passingNames :: [Student] -> [String]
passingNames = getNames . passingStudents -- TODO: Compose getNames and passingStudents

-- | Get average grade of CS students only
--
-- >>> averageGradeInMajor "CS" classA
-- Just 78.0
--
-- >>> averageGradeInMajor "Biology" classA
-- Nothing
averageGradeInMajor :: String -> [Student] -> Maybe Double
averageGradeInMajor major students =
  averageGrade (studentsInMajor major students)
  -- TODO: Filter by major, then calculate average

-- | Count passing students in a major
--
-- >>> countPassingInMajor "CS" classA
-- 3
--
-- >>> countPassingInMajor "Math" classA
-- 0
countPassingInMajor :: String -> [Student] -> Int
countPassingInMajor major =
  countStudents . passingStudents . studentsInMajor major
  -- TODO: Filter by major, filter by passing, count

-- ============================================================================
-- Part 7: Different Function Styles (Practice)
-- ============================================================================

-- Implement the same logic in different styles to understand the trade-offs.

-- | Check if any student is failing - Style A: Explicit recursion
--
-- >>> anyFailing1 classA
-- True
--
-- >>> anyFailing1 [alice, carol]
-- False
anyFailing1 :: [Student] -> Bool
anyFailing1 [] = False
anyFailing1 (s:ss)
  | studentGrade s < 50 = True
  | otherwise           = anyFailing1 ss -- TODO: Check s, recurse on ss

-- | Check if any student is failing - Style B: Using foldr
--
-- >>> anyFailing2 classA
-- True
anyFailing2 :: [Student] -> Bool
anyFailing2 =
  foldr (\s acc -> (studentGrade s < 50) || acc) False
 -- TODO: Use foldr with (||)

-- | Check if any student is failing - Style C: Using any
--
-- >>> anyFailing3 classA
-- True
anyFailing3 :: [Student] -> Bool
anyFailing3 =
  any (\s -> studentGrade s < 50)-- TODO: Use any with a predicate

-- | Check if all students are passing - choose your preferred style
--
-- >>> allPassing classA
-- False
--
-- >>> allPassing [alice, carol, dan]
-- True
allPassing :: [Student] -> Bool
allPassing =
  all (\s -> studentGrade s >= 50) -- TODO: Choose your preferred style

-- ============================================================================
-- Part 8: Generating Reports (Strings)
-- ============================================================================

-- Create formatted string output from student data.

-- | Create a simple grade report for one student
--
-- >>> studentReport alice
-- "Alice: 87 (CS)"
studentReport :: Student -> String
studentReport s =
    studentName s ++ ": "
    ++ show (studentGrade s)
    ++ " (" ++ studentMajor s ++ ")"
  -- TODO: Combine name, grade, and major into a formatted string

-- | Create a class roster (list of names, one per line)
--
-- >>> putStrLn (classRoster [alice, bob])
-- 1. Alice
-- 2. Bob
classRoster :: [Student] -> String
classRoster students =
    unlines
      [ show n ++ ". " ++ studentName s
      | (n,s) <- zip [1..] students
      ]
  -- TODO: Number each student, join with newlines
  -- Hint: Use zip [1..] students, then format each pair

-- ============================================================================
-- Experiments (try in GHCi)
-- ============================================================================

-- >>> filter (\s -> studentGrade s > 80) classA
-- >>> map studentName $ filter (\s -> studentMajor s == "CS") classA
--
-- >>> foldr (\s acc -> studentGrade s + acc) 0 classA
-- >>> foldr (\s acc -> if studentGrade s >= 50 then acc + 1 else acc) 0 classA
--
-- Function composition:
-- >>> (map studentName . filter (\s -> studentGrade s >= 90)) classA
--
-- Working with Maybe:
-- >>> case topStudent classA of { Nothing -> "No students"; Just s -> "Top: " ++ studentName s }
--
-- Using fmap on Maybe:
-- >>> fmap studentName (topStudent classA)
-- >>> fmap (* 2) (Just 5)
-- >>> fmap (* 2) Nothing
