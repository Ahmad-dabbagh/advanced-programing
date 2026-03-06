# Task 09: Code Review Exercise

| Item           | Details                                                |
|----------------|--------------------------------------------------------|
| **Date**       | Wednesday, 18th of February                            |
| **Deadline**   | Wednesday, 25th of February, 08:00                     |
| **OBLIG**      | **YES** (last haskell oblig, yay)                      |
| **Type**       | **In-The-Class** Group Activity, **individual** submission |
| **AI**         | **NO** - do not use AI                                 |
| **Coding**     | No coding. Code comprehension only.                    |
| **PeerReview** | **NO**                                                 |

You are given two complete, working implementations of the same Snake game in Haskell.
Both compile and run.  Your task is to read both codebases carefully, compare them,
and record your findings in the sections below.

---

## How to run the games

```
cd snake{1,2} && stack run
```

Play both games, including two-player mode. Test by playing.

---

## Part 1 — First impressions

Play both games and note any behavioural differences you observe.

> **1.1** Does either game behave incorrectly or unexpectedly?  Describe what you observe.

```


Snake 1 feels “tight” and consistent: movement, eating, and two-player outcomes behave predictably.

Snake 2 can behave unexpectedly around food placement:
- A newly spawned food item can appear on top of an existing food item (so the food count looks “wrong” / a food seems to vanish).
- In two-player mode, a newly spawned food item can appear inside the other snake (or inside player 2), which can cause immediate/instant eating or unfair outcomes.

These issues follow from how snake2 computes occupied cells when respawning food (it does not include all relevant occupied cells).

:contentReference[oaicite:0]{index=0}
```

---

## Part 2 — Module structure

Read the module headers (the `module ... where` line and the `import` lines) of each
corresponding file pair: `Types.hs`, `Logic.hs`, `Render.hs`, `Game.hs`.

> **2.1** What is the first structural difference you notice between the module headers?
> Which project's modules are easier to understand at a glance, and why?

```

The first big difference is that snake1 uses explicit export lists and selective imports, while snake2 mostly uses “module X where” with no export list and broad imports.

Example:
- snake1’s Logic module clearly documents what it exports (initialState, stepGame, stepSnake, checkGameOver, etc.) and groups exports by purpos. :contentReference[oaicite:1]{index=1}
- snake2’s Logic module export everything implicitly (“module Logic where”), so you can’t tell the intended public API at a glance. :contentReference[oaicite:2]{index=2}

Because of that, snake1 is easier to understand at a glance: you see the intended interface immediately and you see fewer “mystery dependencies”.

:contentReference[oaicite:3]{index=3}

```

> **2.2** In `snake2/src/Game.hs`, the line `import Logic` appears in `Game.hs`.
> What names does this import bring into scope?  Is that a problem?  Compare with
> `snake1/src/Game.hs`.

```
Your answer:
In snake2, `import Logic` brings *all* top-level names from Logic into scope (because Logic has no export list). That includes not only stepGame/initialState, but also helper functions like snakeBody, snakeDir, spawnFood, etc. :contentReference[oaicite:4]{index=4} :contentReference[oaicite:5]{index=5}

That’s a problem because:
- It hides what Game actually depends on (harder to read/review).
- It increases the chance of accidental name clashes (now or after refactors).
- It makes it easier to accidentally use an internal helper from another module without meaning to.

Snake1 avoids this by importing only what it needs:
`import Logic (initialState, stepGame, oppositeDir)` and `import Render (drawUI, theAttrMap)`.
:contentReference[oaicite:6]{index=6}
```

> **2.3** One project defines constants such as grid width, grid height, food count,
> and tick interval.  The other does not.  Find where each project handles these values.
> Notice every file and line in `snake2` where a raw number (like `40` or `150000`) appears in place of a named constant.

```
Your answer:
Snake1 defines named constantes in Types.hs:
gridW,, gridH, foodCount, tickIntervalUs.
 :contentReference[oaicite:7]{index=7}

These are then used in Game/Logic/Render (e.g., threadDelay tickIntervalUs, loops over 0..gridW-1, etc.).
:contentReference[oaicite:8]{index=8}
:contentReference[oaicite:9]{index=9}
:contentReference[oaicite:10]{index=10}

Snake2 hard-codes “magic numbers” in multiple places:
- Game.hs: tick interval is literally `threadDelay 150000`. :contentReference[oaicite:11]{index=11}
- Logic.hs: wrap-around is hard-coded as `mod 40` and allCells uses 0..39; foodCount is hard-coded via spawnFoodN 3.
:contentReference[oaicite:12]{index=12}
:contentReference[oaicite:13]{index=13}

- Render.hs: the grid is hard-coded as `[0..39]` for both x and y, so the board size is duplicated again.
:contentReference[oaicite:14]{index=14}
```

---

## Part 3 — Data types

Read `Types.hs` in both projects.

> **3.1** How is the `Snake` type defined differently in the two projects?  What are the practical consequences of each choice when you need to read or update a field?


Your answer:
Snake1 uses a record type with named fields:
  data Snake = Snake { snakeBody :: [Coord], snakeDir :: Direction, snakeScore :: Int } deriving (Eq, Show) :contentReference[oaicite:15]{index=15}
This makes reading/updating fields easy and explicit:
  s { snakeDir = d } or snakeScore s

Snake2 uses a positional constructor:
  data Snake = Snake [Coord] Direction Int :contentReference[oaicite:16]{index=16}
So to read/update a field you must pattern match and rebuild:
  case s of Snake b d sc -> Snake b newDir sc

Practical consequence: snake1 updates are clearer and safer (less “which argument was score again?”). snake2 code tends to duplicate pattern matches and is easier to break during refactors. :contentReference[oaicite:17]{index=17} :contentReference[oaicite:18]{index=18}```

```

> **3.2** `snake2` represents the game outcome (winner, draw, game over) as `Maybe Int`.
> `snake1` uses a different approach.  Describe the difference.
> What can go wrong with the `snake2` approach that cannot go wrong in `snake1`?

```
Your answer:
Snake2 uses `winner :: Maybe Int` and interprets integers like:
Just 0 = draw, Just 1/2 = some player wins, and “Just _” is a catch-all. :contentReference[oaicite:19]{index=19} :contentReference[oaicite:20]{index=20}

Snake1 uses a proper sum type:
  data Winner = P1Wins | P2Wins | Draw
and stores `gsWinner :: Maybe Winner`. :contentReference[oaicite:21]{index=21}

What can go wrong in snake2:
- You can accidentally store an invalid value like `Just 7`.
- Different parts of the code could disagree on what “1” means.
- The compiler cannot help you if you forget to handle a case, because “Int” has infinitely many values.

In snake1, invalid winners are unrepresentable: it’s impossible to store “Just 7” as a Winner, so that entire class of bugs is prevented by the type system. :contentReference[oaicite:22]{index=22}
```

> **3.3** Try printing a `GameState` value in a GHCi session for each project (`stack ghci`, then construct a value).  What happens?  Why?

```
Your answer:
Snake1: printing GameState works, because GameState (and Snake) derive Show. :contentReference[oaicite:23]{index=23}

Snake2: printing GameState fails with a “No instance for (Show GameState)” styl error, because snake2’s GameState  does not derive Show (and Snake also has no deriving clause). :contentReference[oaicite:24]{index=24}
```

---

## Part 4 — Game logic (`Logic.hs`)

> **4.1** Find the function that moves the snake one step forward in each project.
> How many times is the snake actually moved per tick in `snake2`?
> Compare with `snake1`.  Is there a difference?

```
Your answer:
Snake2 moves snakes with `moveSnake`. :contentReference[oaicite:25]{index=25}
Snake1 moves snakes with `advanceSnake` (used inside `stepSnake`). :contentReference[oaicite:26]{index=26} :contentReference[oaicite:27]{index=27}

In snake2, each tick *computes* movement twice when food is eaten:
- It first does `moved1 = moveSnake s1 False`
- If food was eaten, it then computes `moveSnake s1 True` again (starting from the original s1)
So the snake ends up advanced by one cell in the final state, but the movement logic is re-run (duplicated) in the “ate food” path. :contentReference[oaicite:28]{index=28}

Snake1 computes a single step in one place via stepSnake (compute nextHead/eatFood/advanceSnake once). :contentReference[oaicite:29]{index=29}
```

> **4.2** In `snake2`, when a snake eats food, a replacement food item is spawned.
> Read the code that computes which cells are "occupied" before spawning.
> What cells does it include?  What cells does it miss?
> What incorrect behaviour can this cause?

```
Your answer:
In snake2, the occupied set for respawning food is incomplete:
- For player 1 it uses `occ1 = Set.fromList (snakeBody s1)` (only snake1’s body, and it’s the *old* snake1 body). :contentReference[oaicite:30]{index=30}
- It does NOT include existing food cells, so the replacement food can spawn on top of remaining food.
- For player 2 it uses `occ2 = Set.fromList (snakeBody s1'')` (only snake1’s body!), which misses snake2’s body entirely and also misses the food cells. :contentReference[oaicite:31]{index=31}

Incorrect behaviour this can cause:
- Food can spawn on food (looks like food count is wrong / food disappears).
- Food can spawn inside the other snake (especially inside snake2), causing instant “free” eating or unfair scores.
```

> **4.3** `snake2/src/Logic.hs` calls `head`, `tail`, and `init` directly on lists.
> `snake1` does not.  Why is this significant?  Under what circumstances would these calls crash?

```
Your answer:
head/tail/init are partial functions: they crash on empty lists (and init also crashes on empty lists).

Snake2 uses them directly in core logic:
- getHead uses `head body`
- moveSnake uses `head body` and `init body`
- selfColl uses `head body` and `tail body` :contentReference[oaicite:32]{index=32}

They crash if a snake body becomes empty, or (for init) if the code ever tries to move a snake with an empty body.
The current game “assumes” snakes always have length ≥ 3, but that invariant is not enforced by the type (Snake is just a list), so a future change/refactor/bug could break the invariant and turn into a runtime crash.

Snake1 avoids this by pattern matching and keeping functions total (e.g., selfCollision returns False on []), which makes both debugging and doctesting safer. :contentReference[oaicite:33]{index=33}
```

> **4.4** Look at `spawnFood` in `snake2`.  Find the line that uses `!!`.
> What happens if the list it indexes into is empty?

```
Your answer:
The line is: `free !! idx`. :contentReference[oaicite:34]{index=34}

If `free` is empty, then indexing crashes at runtime (“Prelude.!!: index too large”).
Also, snake2 computes `randomR (0, length free - 1)` which becomes `randomR (0, -1)` when free is empty, which is another serious failure mode. :contentReference[oaicite:35]{index=35}
```

> **4.5** How is the `stepGame` function structured in `snake2` compared to `snake1`?
> Count the number of distinct responsibilities each version handles.
> Which version would be easier to debug if food spawning broke?  Why?

```
Your answer:
Snake2 stepGame is monolithic and mixes many responsibilities in one place:
1) move snake1, 2) detect/eat food for snake1, 3) respawn food, 4) update score,
5) move snake2, 6) detect/eat food for snake2, 7) respawn food again,
8) collision checks, 9) winner/phase updates, 10) high score updates. :contentReference[oaicite:36]{index=36}

Snake1 stepGame composes smaller, focused helpers:
- occupiedCells
- stepSnake (per-snake move/eat/spawn/score)
- checkGameOver
So stepGame mainly “orchestrates” rather than “does everything”. :contentReference[oaicite:37]{index=37}

Snake1 would be easier to debug if food spawning broke because the spawning logic is isolated (spawnFood/eatFood/stepSnake) and already structured for independent reasoning (and doctests). Snake2 duplicates food logic inline twice, so you have to debug two similar-but-not-identical code paths. :contentReference[oaicite:38]{index=38} :contentReference[oaicite:39]{index=39}
```

> **4.6** `snake2` uses `fromJust` in one place.  Find it.  Explain why it is considered a **code smell**.  Why does it happen to not crash here?  Could a future refactor cause it to crash?

```
Your answer:
Snake2 uses fromJust when building the initial occupied set:
`Set.fromList (snakeBody (fromJust ms2))` inside the `if m == TwoPlayer` branch. :contentReference[oaicite:40]{index=40}

It’s a code smell because fromJust crashes if the value is Nothing, so it encodes a hidden assumption (“this is definitely Just”) without enforcing it.

It does not crash here because ms2 is set to Just initSnake2 exactly when m == TwoPlayer, so the guard makes it safe *today*. :contentReference[oaicite:41]{index=41}

Yes, a future refactor could make it crash: if someone changes how ms2 is created, changes the guard, or reorders logic, the fromJust may become reachable with Nothing.
Snake1 avoids this by using `maybe Set.empty bodySet ms2`, which is total and refactor-safe. :contentReference[oaicite:42]{index=42}
```

---

## Part 5 — Rendering (`Render.hs`)

> **5.1** `drawCell` in `snake2` is called once for every cell in the grid.
> How many cells are in the grid?  How many times does `Set.fromList` get called per frame as a result?  Compare this with `snake1`'s approach.

```
Your answer:
The grid is 40×40 = 1600 cells. :contentReference[oaicite:43]{index=43}

In snake2, drawCell rebuilds sets per cell:
- `s1b = Set.fromList (tail (snakeBody s1))` is done once per cell → 1600 times per frame.
- In two-player mode, `s2b = Set.fromList (tail (snakeBody s2))` is also done once per cell → +1600 times per frame.
So up to ~3200 Set.fromList calls per frame in two-player. :contentReference[oaicite:44]{index=44}

Snake1 precomputes all these sets once per frame in toRenderState, then each cell just does Set.member lookups. :contentReference[oaicite:45]{index=45} :contentReference[oaicite:46]{index=46}
```

> **5.2** In `snake2/src/Render.hs`, the sentinel value `(-1, -1)` is used.
> What does it represent?  What is the risk of using a magic coordinate as a sentinel instead of a proper type?

```
Your answer:
(-1, -1) represents “there is no player 2 snake” (so no player 2 head) in single-player mode. :contentReference[oaicite:47]{index=47}

Risk:
- It encodes “absence” as a fake coordinate rather than as a type (like Maybe Coord).
- If the coordinate system changes (or wrap-around logic changes), that magic value could accidentally become meaningful, or someone could forget it’s a sentinel and treat it as real data.
- The compiler can’t help you enforce correct handling of “no snake2”.
```

> **5.3** How are terminal colours connected to widget drawing in each project?
> In `snake2` what happens if you make a typo in one of the colour name strings?

```

Your answer:
Both projects use Brick attributes via `withAttr (attrName "...")` and provide an `AttrMap`.

Snake2 uses short attribute names as raw strings inline in drawCell ("s1h", "s1b", "fd", etc.), and maps them in theAttrMap. :contentReference[oaicite:48]{index=48} :contentReference[oaicite:49]{index=49}
If you typo one of those strings in drawCell or theAttrMap, Brick will treat it as a different attribute name and you’ll silently get default styling (wrong/no colour) instead of an obvious compile-time error.

Snake1 centralizes attribute names as top-level constants (snake1HeadAttr, foodAttr, etc.) and uses them consistently, so typos are less likely and localized. :contentReference[oaicite:50]{index=50} :contentReference[oaicite:51]{index=51}
```

> **5.4** Look at `drawUI` in `snake2` and `snake1`.  Both perform the same dispatch based on game phase.  Which syntax is used in each?  Which makes it easier for the compiler to warn about a missing case?

```
Your answer:
Snake2 uses nested if/else based on equality checks:
if phase gs == Menu then ... else if phase gs == Playing then ... else ...
:contentReference[oaicite:52]{index=52}

Snake1 uses a `case` expression on gsPhase:
case gsPhase gs of Menu -> ...; Playing -> ...; GameOver -> ...
:contentReference[oaicite:53]{index=53}

The case-expression version (snake1) makes it easier for the compiler to warn about non-exhaustive pattern matches if a new phase is added later.
```

---

## Part 6 — Event handling (`Game.hs`)

> **6.1** In `snake2`, each handler function receives the current `GameState` as an explicit argument (e.g., `handleMenu gs ev`).  In `snake1`, a different Haskell pattern is used.  Identify the difference.  What is the potential risk with the `snake2` approach?

```
Your answer:
Snake2 threads state explicitly into handlers and often updates with `put` using that passed-in gs (e.g., handleMenu gs ev, setDir1 gs d). :contentReference[oaicite:54]{index=54}

Snake1 uses the State monad style: handlers do not take gs explicitly; they use `get/gets` and update using `modify`, which applies a function to the current state inside EventM. :contentReference[oaicite:55]{index=55} :contentReference[oaicite:56]{index=56}

Potential risk in snake2:
You can accidentally update from a stale snapshot (you compute a new state from an older gs rather than the latest one).
This is especially risky if you later refactor handlers to do multiple updates, compose updates, or reuse helpers—`modify` composes safely, while “pass gs + put” is easier to get subtly wrong. :contentReference[oaicite:57]{index=57}
```

> **6.2** The 180° direction guard (preventing a snake from reversing) is written differently in the two projects.  Find both implementations.  Count the number of boolean conditions in `snake2`'s version.  How many in `snake1`?  Which is easier to read and maintain?

```

Your answer:
Snake2 implements it as four explicit boolean disjunctions:
(d==Up && dir==Down) || (d==Down && dir==Up) || (d==Left && dir==Right) || (d==Right && dir==Left)
So: 4 boolean conditions. :contentReference[oaicite:58]{index=58}

Snake1 implements it as a single comparison using oppositeDir:
if d == oppositeDir (snakeDir s1) then ...
So: 1 boolean condition. :contentReference[oaicite:59]{index=59} :contentReference[oaicite:60]{index=60}

Snake1 is easier to read and maintain: if you ever extend Direction (e.g., diagonals), you update oppositeDir once, not 4+ conditions scattered in handlers.

```

---

## Part 7 — Testing

> **7.1** Run `stack test` in each project.  What does each test suite do?

```
Your answer:

Snake 1:
Running `stack test` executes a doctest runner. The test executable discovers and runs all doctest examples (lines starting with >>>) inside:

- src/Types.hs
- src/Logic.hs
- src/Render.hs

IO-heavy modules like Game are intentionally excluded. This means the test suite validates many pure functions directly through their documented examples.
:contentReference[oaicite:0]{index=0}

Snake 2:
Running `stack test` does not execute any real tests. The test executable simply prints "No tests." and exits, meaning there is effectively no automated test coverage.
:contentReference[oaicite:1]{index=1}
```

> **7.2** Look at `Logic.hs` in each project.  Which functions have doctest examples in `snake1`?  Try to write a doctest for `selfColl` in `snake2` — what makes it difficult?

```
Your answer:


> **7.3** Why is it easier to write tests for `snake1`'s `checkGameOver` and `stepSnake` than for the equivalent logic in `snake2`'s `stepGame`?

```
Your answer:

Snake 1:
Many functions include doctest examples (>>>), such as:

- initSnake1 / initSnake2
- initialState
- wrapCoord
- nextHead
- snakeHead
- dropLast
- advanceSnake
- selfCollision
- snakeCollision
- occupiedCells
- checkGameOver

These examples make it easy to verify behavior and serve as executable documentation.

Snake 2:
Writing a doctest for `selfColl` is difficult because the implementation directly uses partial functions like `head` and `tail`. If a test uses an edge case such as an empty snake body, the function crashes instead of returning a value. This makes edge-case testing unsafe and reduces testability.
Snake 1 separates responsibilities into small, pure functions:

- stepSnake handles movement and food interaction for a single snake.
- checkGameOver handles outcome logic independently.

Each function has a clear purpose and well-defined inputs and outputs, making them straightforward to test individually.

Snake 2 combines many responsibilities inside one large function (`stepGame`), including movement, food spawning, scoring, collision detection, and winner determination. Because multiple behaviors are tightly coupled, testing a single feature requires constructing complex game states and navigating many branches, which makes unit testing harder.```

---

## Part 8 — Summary

> **8.1** List all the bad patterns you identified in `snake2`, in your own words.


```
Pattern 1: No explicit module export lists; broad imports (“import Logic”) hide real dependencies. :contentReference[oaicite:71]{index=71} :contentReference[oaicite:72]{index=72}
Pattern 2: Magic numbers (40, 150000, 3) duplicated across files instead of named constants. :contentReference[oaicite:73]{index=73} :contentReference[oaicite:74]{index=74} :contentReference[oaicite:75]{index=75}
Pattern 3: Using Maybe Int for winner (magic integers) instead of an ADT (Winner). :contentReference[oaicite:76]{index=76} :contentReference[oaicite:77]{index=77}
Pattern 4: Partial list functions (head/tail/init/!!) in core logic that can crash if invariants are violated. :contentReference[oaicite:78]{index=78}
Pattern 5: Food spawning uses an incomplete occupied-set, allowing food to spawn on food / in snakes (especially in two-player). :contentReference[oaicite:79]{index=79}
Pattern 6: Rendering rebuilds sets inside drawCell, causing huge redundant work per frame (performance smell). :contentReference[oaicite:80]{index=80}
Pattern 7: Sentinel coordinate (-1,-1) used to represent “no snake2 head”. :contentReference[oaicite:81]{index=81}
Pattern 8: Event handlers pass gs explicitly + use put based on that snapshot (more refactor-risk than modify). :contentReference[oaicite:82]{index=82}
Pattern 9: fromJust usage (unsafe) in initialState. :contentReference[oaicite:83]{index=83}
...
```

> **8.2** For each bad pattern above, describe the corresponding good practice used in `snake1`.

```
Pattern 1 fix: snake1 uses explicit export lists and selective imports so module APIs are clear. :contentReference[oaicite:84]{index=84} :contentReference[oaicite:85]{index=85}
Pattern 2 fix: snake1 defines gridW/gridH/foodCount/tickIntervalUs in Types.hs and reuses them everywhere. :contentReference[oaicite:86]{index=86}
Pattern 3 fix: snake1 uses a Winner ADT (P1Wins/P2Wins/Draw) so invalid winners are unrepresentable. :contentReference[oaicite:87]{index=87}
Pattern 4 fix: snake1 uses total functions and pattern matching for edge cases (e.g., selfCollision handles []). :contentReference[oaicite:88]{index=88}
Pattern 5 fix: snake1 builds a full occupied set (snakes + existing food) before spawning replacement food. :contentReference[oaicite:89]{index=89}
Pattern 6 fix: snake1 precomputes render sets once per frame via RenderState/toRenderState. :contentReference[oaicite:90]{index=90}
Pattern 7 fix: snake1 represents absence with proper types (Maybe Snake / Maybe Coord), not fake coordinates. :contentReference[oaicite:91]{index=91}
Pattern 8 fix: snake1 uses modify/get/gets inside EventM so updates are applied to the current state safely. :contentReference[oaicite:92]{index=92}
Pattern 9 fix: snake1 uses `maybe`-based code (total) rather than fromJust for optional snake2. :contentReference[oaicite:93]{index=93}...
```

> **8.3** Which single change to `snake2` do you think would have the largest
> positive impact on correctness?  Justify your answer.

```
Your answer:
Fix food spawning to use a complete occupied set (both snakes’ bodies + all current food cells) before choosing a new food cell.

Right now snake2’s occupied set is incomplete, which can spawn food on top of food or inside the other snake, producing incorrect gameplay. :contentReference[oaicite:94]{index=94}
This is a correctness bug (not just style/performance), and it affects both single-player (food-on-food) and two-player (food inside the other snake).

```

---

## Part 9 — Reflection

> **9.1** Have you ever written code similar to `snake2` in your own projects? Which patterns and code smells did you recognise from your own experience?

```
Your answer:
Yes — I recognise the “works now, but fragile later” style:
- Magic numbers duplicated across files.
- Using Int “codes” instead of a proper sum type.
- Putting too much logic in one big function (stepGame) with duplicated branches.

I’ve written similar code before when I focused on getting a working version quickly and postponed refactoring.
```

> **9.2** What surprises you the most about the difference between the two implementations?

``
Your answer:
The biggest surprise is how small design choices create huge downstream differences:
- snake1’s use of proper types (Winner) and small pure helper functions (stepSnake/checkGameOver) makes the whole program easier to reason about.
- snake2 “looks similar” on the surface, but hidden unsafe assumptions (fromJust/head/!! and incomplete occupied sets) produce real gameplay bugs and make testing much harder.
```

> **9.3** After studying these two snake implementations, what do you think about your own version? What could you improve, and what you got right already? Can you identify code smells in your own snake game?

Your answer:
My main takeaways for my own snake game are:
- Improve correctness by enforcing invariants with types (use ADTs instead of Int codes; use Maybe for “optional” values instead of sentinels).
- Reduce crash risk by avoiding head/tail/init/!! in core logic (prefer pattern matching / total helpers).
- Refactor game stepping into smaller pure functions (one responsibility each), so tests can target them directly.
- Centralize constants (grid size, tick rate) instead of duplicating numbers.

What I likely got right already (if my game runs): the overall loop and basic snake mechanics. But I should actively look for the same smells as snake2: magic numbers, big step function, and partial list functions.
