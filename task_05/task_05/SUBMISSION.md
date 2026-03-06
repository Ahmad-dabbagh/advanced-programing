# Task 05: Submission

**Student Name**: [ahmad Dabbagh]
**Date**: [10.02.2026]

---

## What to Submit

1. **Implemented functions** in the `.hs` files:
   - `a-parsing/src/Parsing.hs`
   - `b-fileio/src/FileIO.hs`
   - `c-cli/src/Student.hs`
   - `c-cli/src/Operations.hs`
   - `c-cli/src/Parsing.hs`
   - `c-cli/src/Main.hs`

2. **Written answers** in this file (below)

---

## Written Answers

### Question 1: Pure Functions vs IO Functions

**a) Look at these two functions from your implementation:**

```haskell
-- Function A
parseStudent :: String -> Maybe Student

-- Function B
loadStudents :: FilePath -> IO [Student]
```

Explain the fundamental difference between these two functions. What makes one "pure" and the other "impure"?

parseStudent is a pure function because its output depends only on its input. For the same input string, it will always return the same result, and it does not interact with the outside.

loadStudents is an impure function, it works in the IO context. It reads data from a file, so its result depends on the external environment, and it may fail or return different results even when given the same file path.

**b) Which of these two functions can have doctests? Why can't the other one be easily tested with doctests?**

parseStudent can be tested with doctests because it is pure and deterministic. Its behavior is predictable and does not depend on external state.
loadStudents cannot be easily tested with doctests because it performs file I/O. Testing it would require specific files to exist, which makes doctests unreliable for this kind of function.



### Question 2: Testability

**a) Consider this design decision: we made `deleteStudent` a pure function:**

```haskell
deleteStudent :: Int -> [Student] -> [Student]
deleteStudent sid students = filter (\s -> studentId s /= sid) students
```

Instead of an IO function:

```haskell
deleteStudentIO :: Int -> IO ()  -- Hypothetically modifies some global state
```

Why is the pure version easier to test?

The pure deleteStudent function is easier to test because it always produces the same output for the same input and has no side effects. It only depends on its arguments and does not interact with files, user input, or global state. This makes its behavior predictable and easy to verify with simple tests.
An IO-based version would depend on external state (like files or mutable data), which makes tests harder to control, slower, and less reliable.

**b) Write a doctest for the pure `deleteStudent` function that verifies it correctly removes a student with ID 12345 from a list:**

```haskell
-- |
-- >>> length (deleteStudent 12345 sampleStudents)
-- 3
--
-- >>> studentExists 12345 (deleteStudent 12345 sampleStudents)
-- False

---

### Question 3: The CLI Loop Pattern

**a) Explain why the main loop function calls itself recursively:**

```haskell
mainLoop :: [Student] -> IO ()
mainLoop students = do
  choice <- getChoice
  case choice of
    "1" -> do listStudents students
              mainLoop students      -- Why recursive call?
    "5" -> putStrLn "Goodbye!"       -- Why no recursive call here?
    ...
```

The mainLoop calls itself recursively to repeate the menu after each command. In Haskell we don’t usually use while loops, so recursion is the normal way to keep a CLI program running. After handling an option (like listing students), calling mainLoop students starts the next “iteration” of the program.

For the quit option (like "5" -> putStrLn "Goodbye!"), there is no recursive call because that’s the exit case: if we called mainLoop again, the program would never stop.
**b) How does th state (list of students) change between iterations? For example, what happens to `students` when a new student is added?**

The “state” (the list of students) changes by passing an updated list into the next recursive call. Nothing is mutated in place. For example, when a new student is added, the handler returns a new list, and then the program continues with mainLoop newStudents. The old students list still exists conceptually, but the loop keeps using the new version going forward.


### Question 4: Error Handling

**a) Why does `parseStudent` return `Maybe Student` instead of just `Student`?**

parseStudent returns Maybe Student because parsing can fail. The input string might be malformed, missing fields, or contain invalid numbers. Using Maybe allows the function to safely represent failure (Nothing) instead of crashing the program, and forces the caller to handle that case explicitly.

**b) What would happen if we used `read` instead of safe parsing for the student ID?**

```haskell
-- Dangerous version
parseStudentUnsafe :: String -> Student
parseStudentUnsafe line =
  let [name, idStr, gradeStr, major] = splitOn ',' line
  in Student name (read idStr) (read gradeStr) major
```

Give an example input that would crash this function.
If we used read instead of safe parrsing, the program could crash at runtime when the input is invalid. The function read throws an exception if the string cannot be parsed as a number.
For example, this input would crash parseStudentUnsafe:
"Alice,abc,90,CS" because read"abc" is not an integer

---

### Question 5: Separation of Concerns

In the CLI project, we organized code into separate modules:

- `Student.hs` - Data type definition
- `Operations.hs` - Pure functions (find, update, delete)
- `Main.hs` - IO functions and main loop

**a) What are the benefits of this separation?**

Separating the project into different files makes the code easier to understand and maintain because each module has one clear responsibility. It also improves testability: the pure logic in Operations.hs can be tested with doctests without dealing with IO. On top of that, changes become safer and more localized (you can modify UI/IO code in Main.hs without accidentally breaking the core logic), and the code is more reusable (the same pure functions could be reused in another interface, like a web app).

**b) If you needed to change the CSV format (e.g., add a new field), which files would need to change?**

If the CSV format changes (for example adding a new field), you would mainly update the parsing/formatting layer: the file that contains parseStudent / parseStudents and formatStudent / formatStudents (often Parsing.hs or FileIO.hs, depending on your structure).
You would also likely update Student.hs because the Student data type would need the new field.
Operations.hs might not need changes unless the new field affects the logic (like filtering, updating, etc.). Main.hs only needs changes if the CLI now asks the user for that new field or prints it.



---

### Question 6: The IO Type

**a) Explain in your own words what `IO String` means. How is it different from just `String`?**

IO String means an action that will produce a String when it is executed, usually by interacting with the outside world (like reading user input or a file). A plain String is just a value that already exists. The key difference is that IO String represents something that does work to get the string, while String is just data with no side effects.

**b) Why can't you write a function with this signature?**

```haskell
extractString :: IO String -> String  -- This is impossible to write safely
```
You can’t write IO String -> String because that would mean extracting a value from an IO action without being in the IO context. That would break Haskell’s safety rules. IO actions must stay inside IO, otherwise the language couldn’t control side effects and things would become unpredictible and unsafe to reason abot.


---

### Bonus Question (Optional)

The pattern of "parse, process, format" that we used:

```haskell
The pattern of "parse, process, format" that we used:

```haskell
The pattern of "parse, process, format" that we used:

```haskell
The pattern of "parse, process, format" that we used:

```haskell
processFile :: FilePath -> FilePath -> IO ()
processFile input output = do
  contents <- readFile input           -- IO: read
  let students = parseStudents contents -- Pure: parse
  let processed = map updateSomething students  -- Pure: process
  let formatted = formatStudents processed -- Pure: format
  writeFile output formatted           -- IO: write
```

This is sometimes called the "functional core, imperative shell" pattern. Why is this considered good design?

This is considered good design because it clearly separates what the program does from how it interacts with the outside world. The parsing, processing, and formatting parts are pure functions, which makes them easy to test, reason about, and reuse. You can run them on sample data without touching files or user input, which reduces bugs and makes behavior more predictable.

The IO code is kept in a thin outer layer that just connects everything together. This makes changes safer: if you change how data is stored or read, the core logic usually stays the same. Overall, the code becomes easier to maintain, easier to debug, and more stable over time, even if the program groows or gets more complex.


---

## Checklist

### Code and Answers

**Task_05a: CSV Parsing**

- [ ] `splitOn` function implemented
- [ ] `parseStudent` returns `Maybe Student`
- [ ] `parseStudents` handles multiple lines
- [ ] `formatStudent` and `formatStudents` work
- [ ] All doctests pass (`cd a-parsing && stack test`)

**Task_05b: File I/O**

- [ ] `loadStudents` reads from file
- [ ] `saveStudents` writes to file
- [ ] File operations tested in GHCi

**Task_05c: CLI CRUD**

- [ ] Menu displays correctly
- [ ] List, Add, Find, Update, Delete operations work
- [ ] Save/Load file operations work
- [ ] Invalid input handled gracefully
- [ ] Application runs (`cd c-cli && stack build && stack run`)

**Written Answers**

