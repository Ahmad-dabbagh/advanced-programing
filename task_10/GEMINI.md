# Gemini CLI Project Mandates - Punto

- **Pure Logic First**: All game mechanics, rule validation, and AI decision-making must be implemented as pure functions in the `Game.*` modules.
- **Doctests**: Every pure function must include `doctests` for verification and documentation.
- **Separation of Concerns**: Keep the game state transitions and logic entirely independent of the `Brick` UI.
- **Deterministic AI**: Bots must be pure functions that take a seed or RNG state as input to remain deterministic and testable.
- **Standard Style**: Follow standard Haskell naming conventions (camelCase) and maintain clear module boundaries.
