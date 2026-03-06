-- |
-- Module      : Student
-- Description : Student data type definition
--
-- This module defines the Student data type used throughout the application.

module Student where

-- | Student record with name, ID, grade, and major
--
-- >>> Student "Alice" 12345 87 "CS"
-- Student {studentName = "Alice", studentId = 12345, studentGrade = 87, studentMajor = "CS"}
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
--
-- >>> length sampleStudents
-- 4
sampleStudents :: [Student]
sampleStudents =
  [ Student "Alice" 12345 87 "CS"
  , Student "Bob"   12346 45 "Math"
  , Student "Carol" 12347 92 "CS"
  , Student "Dan"   12348 78 "Physics"
  ]
