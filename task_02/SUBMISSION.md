# Task 02: Submission Guidelines

## Submission Requirements

Even though you work on tasks in groups, **all students submit individually**.

---

## What to Submit

### 1. Code (Git Repository)

Push the following to your **personal Git workspace**:

```
your-workspace-project-for-task_02/
├── helloworld/           # Task_02a
│   ├── src/Main.hs
│   ├── stack.yaml
│   └── ...
│
├── helloname/           # Task_02b
│   ├── src/Main.hs
│   ├── stack.yaml
│   └── ...
│
├── age-project/          # Task_02c
│   ├── src/Main.lhs
│   ├── stack.yaml
│   └── ...
│
└── mhead-project/        # Task_02d
    ├── src/Lib.lhs
    ├── test/Spec.hs
    ├── stack.yaml
    └── ...
```

### 2. Written Answers (Markdown)

Submit a markdown file named `task02-answers.md` with:

```markdown
# Task 02 Answers

Student Name: [Your Name]
Date: [Date]

## Task_02a and Task_02b

Document where everything is, and how to run things, and how long
it takes to run the commands on your laptop, with `time`,
e.g. `time stack run`

## Task_02c: Type Safety

### Question 1: Version A vs Version B

[Your explanation here - what is the difference between using
`newtype Age = Age Int` vs `type Age = Int`?]

### Question 2: When to Use Each

[Your explanation of when strict type safety is preferable
vs generic functions]

## Task_02d: mhead Implementations

### Implementations

List all the ways you implemented mhead:

1. Pattern matching: `mhead1 (x:_) = x`
2. [Your other implementations...]

### Test Results

[Paste your test output or describe which tests pass]

### Reflection

[What did you learn about different ways to work with lists?]
```

---

## Submission Checklist

Use this checklist to verify your progress:

- [ ] Task_02a: Hello World prints correctly
- [ ] Task_02b: Program asks for name and greets user
- [ ] Task_02c: Age calculator computes future age
- [ ] Task_02c: `addNumber` works with generic types
- [ ] Task_02c: `addAge` enforces type safety
- [ ] Task_02c: Written answers explain the difference
- [ ] Task_02d: At least 3 different mhead implementations
- [ ] Task_02d: Doctests pass for all implementations
- [ ] Task_02d: QuickCheck property tests pass
- [ ] All projects build without errors (`stack build`)
- [ ] Code is pushed to your personal Git repository
- [ ] Written answers are complete and submitted

---

## How to Know You're On Track

### Task_02a & Task_02b: IO Basics

You're ready to move on when:

- Your program compiles and runs
- You can explain what `<-` does in `do` notation
- You understand the difference between `putStrLn` and `print`

### Task_02c: Type Safety

You're ready to move on when:

- You can articulate why `newtype` provides stronger guarantees
- Your age calculator handles the string-to-int conversion
- You can explain when generic vs specific types are appropriate

### Task_02d: Multiple Approaches

You're ready to move on when:

- You have multiple working implementations
- All doctests pass
- Your QuickCheck property demonstrates equivalence to `head`
- You can explain how each implementation works

---

## Getting Help

During class:

- Ask your group members
- Ask the instructor
- Use allowed resources (Haskell books, Hoogle, GHCi)

**Remember**: Do NOT use AI assistants for this task.
