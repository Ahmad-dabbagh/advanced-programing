# AI Development Log for Punto

## Tools Used
- Gemini CLI (as the primary developer agent)
- Haskell Language Server (implied in the environment)

## What Worked
- **Initial Project Structuring:** The agent successfully proposed a modular structure (Core, Board, Player, AI, Logic, UI) that aligned well with the requirements for separating pure logic from rendering and state.
- **Rules Interpretation:** The agent used `web_fetch` to gather rules from a PDF link, ensuring the implementation followed the official game mechanics (e.g., 6x6 grid, overstacking rules, tie-breaking).
- **Incremental Implementation:** Starting with core data types and board logic allowed for early verification via doctests before the UI was introduced.
- **Handling UI Complexity:** The agent correctly identified that Brick requires `OverloadedStrings` and `Text` instead of `String` for many widgets, and resolved `AttrName` and `attrName` issues that often arise in different Brick versions.

## What Didn't Work / Needed Manual Help
- **Cabal Dependency Management:** Some manual intervention was needed to ensure all dependencies (`microlens`, `vty`, `random-shuffle`, `text`) were present in both `library` and `executable` sections of the `.cabal` file.
- **Doctest with Template Haskell:** Running `doctest` on modules using `makeLenses` (Template Haskell) proved difficult without a more complex setup (like `cabal-doctest`). The decision was made to temporarily remove lenses to prioritize passing doctests as required by the spec.
- **Interactive UI Testing:** Since the environment doesn't allow interactive UI testing, the agent relied on `cabal build` to ensure structural correctness and compiler satisfaction.

## Design Decisions
- **Manual Lenses vs Record Syntax:** Opted for record syntax and simple data manipulation to maintain compatibility with basic doctest setups, fulfilling the requirement for tested pure functions.
- **Bot Logic:** Implemented a `Greedy` bot that scores moves based on maximizing its own row length, providing a simple yet effective opponent for the terminal UI.
