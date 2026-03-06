# Task 02: Introduction to Haskell

| Item           | Details                                                         |
|----------------|-----------------------------------------------------------------|
| **Date**       | Wednesday, 21st of January                                      |
| **Deadline**   | Wednesday, 21st of January, 11:59 (end of class)                |
| **OBLIG**      | No                                                              |
| **Type**       | **In-Class**, Small Group Activities, **individual** submission |
| **AI**         | **Do not use**                                                  |
| **Coding**     | Code it all yourself, by hand                                   |
| **PeerReview** | No                                                              |

## Resources

- Haskell books
- GHCi (interactive interpreter)
- [Hoogle](https://hoogle.haskell.org) - Haskell API search
- [HSpec QuickCheck Guide](https://hspec.github.io/quickcheck.html)

## Tools

- `stack` - Haskell build tool
- Simple text editor (neovim, vim, notepad) - avoid IDEs for this task
- Haskell compiler (through stack)

### Recommended Versions

| Tool  | Version |
|-------|---------|
| Stack | 3.9.1   |
| GHC   | 9.10.3  |
| LTS   | 24.28   |

Verify your stack version:

```bash
stack --version
```

---

## Learning Objectives

By the end of this task, you should be able to:

### Core Skills (demonstrate without help)

- Declare and define simple functions in Haskell
- Use basic types: Int, Float, String, lists
- Write a "Hello World" program
- Read input from standard input
- Print text to standard output
- Use simple `do`-notation in main
- Write doctest tests
- Use GHCi for interactive development
- Use `stack` to build, test, and run projects

### Extended Skills (with help from online resources)

- Define custom types with `newtype`
- Write QuickCheck property tests
- Explain type safety concepts

---

## Overview

This task introduces you to Haskell programming through hands-on subtasks:

| Subtask | Topic | Approach |
|---------|-------|----------|
| Task_02a | Hello World | Create project with `stack new` |
| Task_02b | Hello Name | Extend your project with IO |
| Task_02c | Age Calculator | Pre-generated skeleton, type safety |
| Task_02d | mhead Function | Multiple implementations, testing |

---

## Where to Go Next

1. **[INSTRUCTIONS.md](./INSTRUCTIONS.md)** - Step-by-step guide for each subtask
2. **[SUBMISSION.md](./SUBMISSION.md)** - What to submit and where
3. **Subtask folders**: [a-helloworld](./a-helloworld/), [b-helloname](./b-helloname/), [c-age](./c-age/), [d-mhead](./d-mhead/)

---

## Quick Reference

### Common Stack Commands

```bash
stack new projectname simple   # Create new project
stack build                    # Compile the project
stack run                      # Run the executable
stack test                     # Run tests
stack ghci                     # Start interactive REPL
```

### Common GHCi Commands

```haskell
:load Main          -- Load a module
:reload             -- Reload current module
:type expression    -- Show type of expression
:info name          -- Show info about name
:quit               -- Exit GHCi
```
