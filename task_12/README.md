# Task 12: Haskell — Recursion and Expression Evaluation

| Item           | Details                                                    |
| ------------   | ---------------------------------------------------------- |
| **Date**       | Wednesday, 4th of March                                    |
| **Deadline**   | Wednesday, 18th of March, 8:00                             |
| **OBLIG**      | **NO**                                                     |
| **Type**       | **In-Class+Home**, **individual** submission               |
| **AI**         | **Do NOT use** — complete this task manually, without AI   |
| **Coding**     | Implement manually; AI assistance is **not allowed**.      |
| **PeerReview** | **No**                                                     |

## Rules

- **No AI tools** — this task must be done manually, without any AI assistance. This is to ensure you practice the skills yourself.
- Submit individually.
- `stack test` must pass with all doctests green before submission.
- Use **semantic commits**. Each commit should represent a single logical change and follow the Conventional Commits format (e.g., `fix: …`, `feat: …`, `test: …`).

## Overview

This task has two independent parts, each in its own Stack project:

- `recursion/` — in-class exercises on normal vs. tail recursion
- `calculator/` — three implementations of a simple RPN expression evaluator

Work through both parts during the in-class session. Start with whichever you find more comfortable.

---

## Part 1: Recursion (`recursion/`)

### Background: Normal vs. Tail Recursion

A function is **tail-recursive** when the recursive call is the very last operation
performed — there is no pending work left to do once the call returns.

Consider these two versions of `sum`:

```haskell
-- NOT tail-recursive: after the recursive call returns, we still need to add x
sumList :: [Int] -> Int
sumList []     = 0
sumList (x:xs) = x + sumList xs
```

```haskell
-- Tail-recursive: the recursive call IS the last operation
sumListAcc :: [Int] -> Int -> Int
sumListAcc []     acc = acc
sumListAcc (x:xs) acc = sumListAcc xs (x + acc)
```

In `sumList`, each call waits for the recursive result before performing the addition.
This builds up a chain of pending additions on the **call stack** — one frame per list
element. For a list of many elements this will cause a stack overflow.

In `sumListAcc`, the running total is carried forward in the `acc` accumulator.
There is no pending work; the compiler (and the Haskell runtime) can **reuse the same
stack frame** on each call. This is called **tail-call optimisation (TCO)**.

### Notes about folds

- `foldl'` is the strict tail-recursive fold, that guarantees no stack frame usage.
- `foldr` typically is not tail recursive, and builds operations on the stack.

### The Accumulator Pattern

The standard technique for converting a recursive function to tail-recursive form is to
introduce a helper function that carries an accumulator:

```haskell
-- Public interface: hides the accumulator from the caller
totalScore :: [Int] -> Int
totalScore xs = go xs 0           -- start the accumulator at 0
  where
    go []     acc = acc           -- base case: return the accumulated result
    go (y:ys) acc = go ys (acc + y)  -- tail call: pass updated accumulator
```

The caller sees only `totalScore :: [Int] -> Int`. The `go` helper and its `acc`
parameter are an implementation detail inside the `where` clause.

### Getting Started

```bash
cd recursion
stack test    # run all doctests (will fail on unimplemented stubs — that is normal)
stack run     # run the demo of the Section A examples
```

### Section A: Recognise Tail Recursion

Open `src/Lib.hs` and study the four functions in Section A.
For **each function**, add a short comment directly in the source file that answers:

1. **Is this function tail-recursive?**
2. **Why / why not?** (one sentence is enough)

The functions are `sumList`, `myProductAcc`, `collatzSteps`, and `reverseMovesAcc`.

### Section B: Convert to Tail-Recursive

Implement the five functions marked `error "not implemented"` in `src/Lib.hs`.
Each function has:

- a comment showing the naive (non-tail-recursive) reference implementation
- a set of **doctests** that specify the expected behaviour

Run `stack test` frequently to check your progress. A passing test means the function
is correctly implemented.

| # | Function        | Hint                                                          |
|---|-----------------|---------------------------------------------------------------|
| 1 | `totalScore`    | Simple accumulator starting at `0`                            |
| 2 | `reverseMoves`  | Accumulator starts as `[]`; use the `reverseMovesAcc` pattern |
| 3 | `collatzLength` | Counter accumulator starting at `0`                           |
| 4 | `stairCount`    | Two-value accumulator `(a, b)`; think Fibonacci               |
| 5 | `myMap`         | Accumulator collects results in reverse; `reverse` at the end |

---

## Part 2: Calculator (`calculator/`)

### Background: Stack-Based Machines (brief)

Modern CPUs are **register-based**: they operate on named registers (e.g. `eax`, `rbx` on x86).
**Stack-based virtual machines** — such as the JVM bytecode engine, CPython, and the
Forth language — use a stack instead: operators pop their inputs from the top of the
stack and push the result back.

This design makes expression evaluation particularly elegant: there is no need to name
intermediate values or manage registers. The stack is the only workspace.

### Background: Reverse Polish Notation (RPN)

In **Reverse Polish Notation (RPN)**, also called *postfix notation*, operators come
*after* their operands. This matches the natural evaluation order of a stack machine.

**Example:** `3 4 + 5 *` means `(3 + 4) × 5 = 35`

Step-by-step stack trace (top of stack shown on the left):

```
Token   Stack          Notes
------  -------------  -------------------------------------------
3       [3]
4       [4, 3]
+       [7]            pop 4 and 3, push 4+3=7
5       [5, 7]
*       [35]           pop 5 and 7, push 5×7=35
```

At the end, exactly one element should remain on the stack — that is the result.
If the stack has more or fewer than one element, the expression was invalid.

More examples:

| RPN expression         | Infix equivalent       | Result |
|------------------------|------------------------|--------|
| `3 4 +`                | `3 + 4`                | `7`    |
| `2 3 * 4 5 * +`        | `(2×3) + (4×5)`        | `26`   |
| `3 4 + 5 *`            | `(3 + 4) × 5`          | `35`   |
| `5 1 2 + 4 * + 3 -`    | `5 + (1+2)×4 − 3`      | `14`   |

### Background: Parsing with `words`

We parse RPN expressions using the standard `words` function, which splits a `String`
on whitespace:

```haskell
words "3 4 + 5 *"  ===  ["3", "4", "+", "5", "*"]
```

Each word is then matched to a `Token`:

```haskell
data Token = TNum Int | TPlus | TMul

parseToken :: String -> Maybe Token
parseToken "+" = Just TPlus
parseToken "*" = Just TMul
parseToken s   = case reads s of      -- 'reads' safely parses an Int from a String
  [(n, "")] -> Just (TNum n)
  _         -> Nothing                -- unknown token → Nothing
```

This approach avoids any external parser library (no Parsec). The `Maybe` type signals
parse failure: if any single token is invalid, `tokenize` returns `Nothing` and the
whole evaluation fails immediately.

### The Three Versions

The `calculator/` project contains three implementations of the same RPN evaluator,
each written in a progressively more idiomatic Haskell style. Read them in order.

#### Version 1 — Pure `Maybe`, Explicit Threading

Every function takes the `Stack` as an explicit parameter and returns `Maybe Stack`.
Each `Maybe` value is inspected manually using `case` expressions.
The code is correct and fully testable, but the repeated pattern
`case ... of { Nothing -> Nothing; Just x -> ... }` becomes tedious to write.

#### Version 2 — Monadic Composition (`>>=` and `do`-notation)

The same logic, rewritten using Haskell's `do`-notation and `foldM`.
The `Maybe` short-circuiting is handled implicitly by the monad — we only
describe the happy path, and `Nothing` propagates automatically.
Compare this carefully with Version 1 to see how much boilerplate disappears.

#### Version 3 — `StateT Stack Maybe`

The stack becomes **implicit state** managed by `StateT`.
Operations such as `pushS` and `popS` are small `Calc ()` actions that are
composed together in a `do`-block. `mapM_` sequences them over the token list;
`execStateT` runs the whole computation and extracts the final stack.
This version reads almost like an imperative description of the algorithm, yet
remains purely functional and fully type-safe.

```haskell
type Calc a = StateT Stack Maybe a
```

### Getting Started

```bash
cd calculator
stack test    # run all doctests (exercise stubs will fail until you implement them)
stack run     # run the comparison demo of all three versions
```

### Exercises

The exercises are at the bottom of `src/Lib.hs`. Each has a stub
(`error "not implemented"`) and doctests that define the expected behaviour.
Run `stack test` to see which ones are still failing.

| # | Function  | Description                                               |
|---|-----------|-----------------------------------------------------------|
| 1 | `exEval1` | Extend V1 to support the MINUS (`-`) operator             |
| 2 | `exEval2` | Extend V2 to support SWAP (exchange the top two elements) |
| 3 | `exEval3` | Extend V3 to support DUP (duplicate the top element)      |

**Hints for Exercise 1 (MINUS):**

- Add a `TMinus` constructor to `Token` (or create a local extended token type inside the function/where clause).
- Update `tokenize` (or write a local `tokenize'`) to handle `"-"` as subtraction.
- Operand order matters: `"5 3 -"` should give `5 − 3 = 2`, not `3 − 5`.
  Before the `-` operator the stack holds `[3, 5]` (3 on top, 5 below).
  Pop `b = 3` first, then pop `a = 5`, and push `a - b = 2`.

**Hints for Exercise 2 (SWAP):**

- SWAP does not consume numeric operands; it just reorders the top two elements.
- Stack `[b, a, rest…]` becomes `[a, b, rest…]` after SWAP.

**Hints for Exercise 3 (DUP):**

- DUP copies the top element: `[x, rest…]` becomes `[x, x, rest…]`.
- Implement a `dupS :: Calc ()` action using `popS` and two `pushS` calls,
  then add a `TDup` case to your extended step function.
