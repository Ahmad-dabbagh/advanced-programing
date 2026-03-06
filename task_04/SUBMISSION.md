# Task 04: Submission

**Student Name**: [Ahmad Dabbagh]
**Date**: [18.02]

---

## What to Submit

1. **Implemented functions** in the `.hs` files:
   - `a-datatypes/src/Student.hs`
   - `b-processing/src/Processing.hs`

2. **Written answers** in this file (below)

---

## Written Answers

### Question 1: Record Syntax vs Positional Constructors

Consider these two ways to define a data type:

```haskell
-- Version A: Positional
data StudentA = StudentA String Int Int String

-- Version B: Record syntax
data StudentB = StudentB
  { studentName  :: String
  , studentId    :: Int
  , studentGrade :: Int
  , studentMajor :: String
  }
```

**a) What are the advantages of using record syntax (Version B)?**

Record syntax is clearer because each field has a name, so it’s harder to mix up the order of values when constructing a Student. It also automatically gives you accessor functions like studentName and makes updates nicer with record updaate syntax (e.g., changing only the grade). Overalle it’s more readable and easier to maintain, especially when the data type has several fields.

**b) When might you prefer positional constructors (Version A)?**

Positional constructors can be fine when th e type is very small and the field order is obvious (like 2–3 fields), or when you don’t need named accessors and updates. They can also be a bit more lightweight in simple code or quicke exercises, and sometimes pattern matching can feel simpler when you just match on the constructor arguments directly.

---

### Question 2: The Maybe Type

**a) Explain what the `Maybe` type represents and why it exists.**

The Maybe type represents a value that may or may not exist. It has two possibilities: Just value when a result is present, and Nothing when no result is available. It exists mainly to avoid runtime errors caused by missing values and to force the programmer to handle both cases explicitly. This makes programs safer because failure is represented in the type system instead of relying on crashes or undefined behavior.

**b) Consider these two functions:**

```haskell
-- Version 1: Unsafe
findStudent :: Int -> [Student] -> Student

-- Version 2: Safe
findStudent :: Int -> [Student] -> Maybe Student
```

Why is Version 2 considered safer? What happens in each version if no student is found?

Version 2 is safer because it explicitly models the possibility of failure using Maybe. If no student is found, it returns Nothing, which forces the caller to handele that case. In Version 1, the function must still return a Student, so if no match exists it could crash, use an invalid default, or produce undefined behavior. Using Maybe makes the absence of a result visible in the type signature and reduces the chance of runtime errors.

**c) Write the pattern matching code to handle a `Maybe Student` value and print either "Not found" or the student's name:**

```haskell
printResult :: Maybe Student -> IO ()
printResult ms = -- YOUR CODE HERE
   case ms of
      Nothing -> putStrLn "Not found"
      Just s  -> putStrLn (studentName s)
---

### Question 3: Function Styles

Consider these equivalent implementations:

```haskell
-- Style A: Explicit
getNames1 :: [Student] -> [String]
getNames1 students = map (\s -> studentName s) students

-- Style B: Simplified lambda
getNames2 :: [Student] -> [String]
getNames2 students = map studentName students

-- Style C: Point-free
getNames3 :: [Student] -> [String]
getNames3 = map studentName
```

**a) Explain why all three versions are equivalent.**

All three versions do the same thing: they apply map to a function that extracts the name from each Student. In Style A the extraction function is written explicitly as a lambda (\s -> studentName s). In Style B, that lambda is simplified because studentName already has the right type,, so (\s -> studentName s) is identical to just studentName. Style C is the samme again, just written point-free: map studentName returns a function that expects the list of students and maps studentName over it.

**b) Which style do you find most readable? Why?**

I find Style B the most readable. It’s clear and direct (map studentName students), but still shows the input list explicitly, which helps when reading code step by step. Styl A is more verbose than needed, and Style C can be nice once you’re used to it, but point-free style sometimes becomes harder to follow when expressions get more complex.

---

### Question 4: Combining Concepts

**a) Explain what this function does, step by step:**

```haskell
averageGrade :: [Student] -> Maybe Double
averageGrade [] = Nothing
averageGrade students = Just (fromIntegral total / fromIntegral count)
  where
    total = foldr (\s acc -> studentGrade s + acc) 0 students
    count = length students
```

This function calculates the average grade of a list of students. First, it checks if the list is empty; if it is, it returns Nothing. Otherwise, it calculates the total sum of all grades using foldr, where each student’s grade is added to an accumulator starting from 0. Then it counts how many students are in the list using length. After that,, it converts both the total and the count to Double using fromIntegral so that division works with fractional numbers. Finally, it divides the total by the count and wraps the result in Just, indicating a successful calculation.

**b) Why does this function return `Maybe Double` instead of just `Double`?**

It returns Maybe Double because the average cannot be computed when the list is empty. If the function returned just Double, it would need to invent a fake value or cause an errorr when dividing by zero. Using Maybe makes the possibility of failure explicit: Nothing means there were no students, and Just value means the average was successfully calculated.

---

### Question 5: Accessor Functions

**a) When you define a data type with record syntax, Haskell automatically generates accessor functions. Given:**

```haskell
data Point = Point { pointX :: Int, pointY :: Int }
```

What is the type of `pointX`? Write it out.

The accessor function pointX is automatically generated by Haskell from the record definition. Its type is:
   pointX :: Point -> Int
it takes a value of type Point and returns the Int stored in the pointX field.

**b) Why might you still want to write your own accessor function even when Haskell generates one automatically?**

You might want to write your own accessor if you need additional logic, validation, or transformation instead of just returning the raw field. Custome accessors can also help hide implementation details or provide a clearer API if the internal structure changes later. Sometimes a custom accessor makes th e intention of the code more explicit or easier to understand.

---

### Bonus Question (Optional)

The `Maybe` type is called a "monad" in Haskell. Without going into full detail, what problem do monads help solve when working with `Maybe` values in sequence?

For example, consider a function that must look up a student, then get their grade, then check if they pass:

```haskell
lookupStudent :: Int -> [Student] -> Maybe Student
getGrade :: Student -> Int
isPassing :: Int -> Bool

-- How do we chain these together when the first might return Nothing?
```

When working with Maybe values, monads help solve the problem of chaining multiple operations where any step might fail. Instead of manually checking for Nothing after every function call, the Maybe monad allows computations to be combined so that if one step returns Nothing, the whole chain automaetically stops and returns Nothing. This avoids deeply nested case expressions and makes the code cleaner and easier to read. For example, using monadic binding (>>=), we can first attempt lookupStudent, and only if it returns Just student continue with getting th e grade and checking if they pass.

---

## Checklist

### Code and Answers

- [ ] `Student` data type defined with record syntax
- [ ] Manual accessor functions implemented
- [ ] Constructor helpers implemented
- [ ] Predicates with `Maybe` implemented
- [ ] Safe lookup functions returning `Maybe`
- [ ] Filtering functions implemented
- [ ] Mapping functions implemented
- [ ] Folding functions implemented
- [ ] Multiple function styles demonstrated
- [ ] All doctests pass (`stack test` in both folders)
- [ ] All questions answered

### Submission

- [ ] Code pushed to personal Git repository
- [ ] This file filled in with answers

**Remember**: Do NOT use AI assistants for this task.
