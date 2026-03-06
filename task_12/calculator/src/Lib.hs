-- | Task 12 — Part 2: RPN Calculator
--
-- Three implementations of a simple Reverse Polish Notation (RPN) calculator.
--
-- __Supported input__: a space-separated string, e.g. @"3 4 + 5 *"@.
-- Tokens are: non-negative or negative integer literals, @"+"@, @"*"@.
--
-- __Error handling__: all errors return 'Nothing'. The calculator fails on the
-- first error and does not report the nature of the failure.
--
-- __Versions__:
--
-- * "Version 1" — Pure 'Maybe', explicit stack threading (correct, but verbose)
-- * "Version 2" — Monadic composition with @do@-notation and 'foldM' (clean)
-- * "Version 3" — @StateT Stack Maybe@ (stack as implicit state, very readable)
--
-- The exercises are at the bottom of this file.
-- Run @stack test@ to check your doctest progress.
module Lib
    ( -- * Token type and tokenizer
      Token (..)
    , Stack
    , tokenize
      -- * Version 1: Pure Maybe with explicit stack threading
    , stepV1
    , evalTokensV1
    , eval1
      -- * Version 2: Monadic composition
    , stepV2
    , eval2
      -- * Version 3: StateT Stack Maybe
    , Calc
    , pushS
    , popS
    , applyOpS
    , stepV3
    , eval3
      -- * Exercises
    , exEval1
    , exEval2
    , exEval3
    ) where

import Control.Monad             (foldM)
import Control.Monad.Trans.Class (lift)
import Control.Monad.Trans.State (StateT, execStateT, get, modify, put)

-- ===========================================================================
-- SHARED: TOKEN TYPE AND TOKENIZER
-- ===========================================================================

-- | A token in an RPN expression.
--
-- The calculator supports integer literals, addition, and multiplication.
data Token
    = TNum Int  -- ^ An integer literal, e.g. @TNum 42@
    | TPlus     -- ^ The @+@ operator
    | TMul      -- ^ The @*@ operator
    deriving (Show, Eq)

-- | The calculator's working memory: a list of integers, top element first.
type Stack = [Int]

-- | Convert a single whitespace-delimited word into a 'Token'.
--
-- Returns 'Nothing' for any unrecognised input.
-- Uses 'reads' to safely parse integer literals (handles negative numbers too).
--
-- >>> parseToken "3"
-- Just (TNum 3)
-- >>> parseToken "+"
-- Just TPlus
-- >>> parseToken "*"
-- Just TMul
-- >>> parseToken "-5"
-- Just (TNum (-5))
-- >>> parseToken "foo"
-- Nothing
-- >>> parseToken ""
-- Nothing
parseToken :: String -> Maybe Token
parseToken "+" = Just TPlus
parseToken "*" = Just TMul
parseToken s   = case reads s of
    [(n, "")] -> Just (TNum n)
    _         -> Nothing

-- | Tokenize an RPN expression string into a list of 'Token's.
--
-- Splits the input on whitespace using 'words', then converts each word with
-- 'parseToken'. Returns 'Nothing' if any token is unrecognised.
--
-- >>> tokenize "3 4 +"
-- Just [TNum 3,TNum 4,TPlus]
-- >>> tokenize "3 4 + 5 *"
-- Just [TNum 3,TNum 4,TPlus,TNum 5,TMul]
-- >>> tokenize ""
-- Just []
-- >>> tokenize "foo"
-- Nothing
-- >>> tokenize "3 4 bad +"
-- Nothing
tokenize :: String -> Maybe [Token]
tokenize = mapM parseToken . words

-- ===========================================================================
-- VERSION 1: PURE Maybe WITH EXPLICIT STACK THREADING
-- ===========================================================================

-- | Process a single token by updating the stack (Version 1).
--
-- Returns 'Nothing' if the stack does not contain enough operands.
--
-- Notice: for binary operators, @b@ is popped first (it was pushed last, so
-- it sits on top), then @a@. The result of @a `op` b@ is pushed back.
--
-- >>> stepV1 [] (TNum 3)
-- Just [3]
-- >>> stepV1 [3] (TNum 4)
-- Just [4,3]
-- >>> stepV1 [4, 3] TPlus
-- Just [7]
-- >>> stepV1 [4, 3] TMul
-- Just [12]
-- >>> stepV1 [3] TPlus
-- Nothing
-- >>> stepV1 [] TPlus
-- Nothing
stepV1 :: Stack -> Token -> Maybe Stack
stepV1 stack      (TNum n) = Just (n : stack)
stepV1 (b:a:rest) TPlus    = Just ((a + b) : rest)
stepV1 (b:a:rest) TMul     = Just ((a * b) : rest)
stepV1 _          _        = Nothing

-- | Process a list of tokens starting from the given stack (Version 1).
--
-- Manually inspects each 'Maybe' with a 'case' expression.
-- Returns 'Nothing' on the first failure.
--
-- >>> evalTokensV1 [TNum 3, TNum 4, TPlus] []
-- Just [7]
-- >>> evalTokensV1 [TPlus] []
-- Nothing
evalTokensV1 :: [Token] -> Stack -> Maybe Stack
evalTokensV1 []     stack = Just stack
evalTokensV1 (t:ts) stack =
    case stepV1 stack t of
        Nothing     -> Nothing
        Just stack' -> evalTokensV1 ts stack'

-- | Evaluate an RPN expression string (Version 1).
--
-- Returns 'Nothing' on any parse or evaluation error, including:
-- * an unrecognised token
-- * not enough operands for an operator
-- * more than one value remaining on the stack at the end
--
-- >>> eval1 "3 4 +"
-- Just 7
-- >>> eval1 "3 4 + 5 *"
-- Just 35
-- >>> eval1 "2 3 * 4 5 * +"
-- Just 26
-- >>> eval1 "42"
-- Just 42
-- >>> eval1 "+"
-- Nothing
-- >>> eval1 "3 4 + 5"
-- Nothing
-- >>> eval1 "foo"
-- Nothing
eval1 :: String -> Maybe Int
eval1 input =
    case tokenize input of
        Nothing     -> Nothing
        Just tokens ->
            case evalTokensV1 tokens [] of
                Just [result] -> Just result
                _             -> Nothing

-- ===========================================================================
-- VERSION 2: MONADIC COMPOSITION
-- ===========================================================================

-- | Process a single token by updating the stack (Version 2).
--
-- >>> stepV2 [] (TNum 7)
-- Just [7]
-- >>> stepV2 [2, 5] TMul
-- Just [10]
-- >>> stepV2 [3] TPlus
-- Nothing
stepV2 :: Stack -> Token -> Maybe Stack
stepV2 stack      (TNum n) = Just (n : stack)
stepV2 (b:a:rest) TPlus    = Just ((a + b) : rest)
stepV2 (b:a:rest) TMul     = Just ((a * b) : rest)
stepV2 _          _        = Nothing

-- | Evaluate an RPN expression string using monadic composition (Version 2).
--
-- >>> eval2 "3 4 +"
-- Just 7
-- >>> eval2 "3 4 + 5 *"
-- Just 35
-- >>> eval2 "2 3 * 4 5 * +"
-- Just 26
-- >>> eval2 "42"
-- Just 42
-- >>> eval2 "+"
-- Nothing
-- >>> eval2 "3 4 + 5"
-- Nothing
-- >>> eval2 "foo"
-- Nothing
eval2 :: String -> Maybe Int
eval2 input = do
    tokens     <- tokenize input
    finalStack <- foldM stepV2 [] tokens
    case finalStack of
        [result] -> Just result
        _        -> Nothing

-- ===========================================================================
-- VERSION 3: StateT Stack Maybe
-- ===========================================================================

-- | The calculator monad: a stateful computation over a 'Stack' that can fail.
type Calc a = StateT Stack Maybe a

-- | Push an integer onto the top of the stack.
pushS :: Int -> Calc ()
pushS n = modify (n :)

-- | Pop an integer from the top of the stack.
popS :: Calc Int
popS = do
    stack <- get
    case stack of
        []     -> lift Nothing
        (x:xs) -> put xs >> return x

-- | Apply a binary operator to the top two stack elements.
applyOpS :: (Int -> Int -> Int) -> Calc ()
applyOpS op = do
    b <- popS
    a <- popS
    pushS (op a b)

-- | Process a single token in the 'Calc' monad (Version 3).
stepV3 :: Token -> Calc ()
stepV3 (TNum n) = pushS n
stepV3 TPlus    = applyOpS (+)
stepV3 TMul     = applyOpS (*)

-- | Evaluate an RPN expression string using 'StateT' (Version 3).
--
-- >>> eval3 "3 4 +"
-- Just 7
-- >>> eval3 "3 4 + 5 *"
-- Just 35
-- >>> eval3 "2 3 * 4 5 * +"
-- Just 26
-- >>> eval3 "42"
-- Just 42
-- >>> eval3 "+"
-- Nothing
-- >>> eval3 "3 4 + 5"
-- Nothing
-- >>> eval3 "foo"
-- Nothing
eval3 :: String -> Maybe Int
eval3 input = do
    tokens     <- tokenize input
    finalStack <- execStateT (mapM_ stepV3 tokens) []
    case finalStack of
        [result] -> Just result
        _        -> Nothing

-- ===========================================================================
-- EXERCISES
-- ===========================================================================

-- EXERCISE 1 ----------------------------------------------------------------

-- | Extend Version 1 to support the MINUS (@-@) operator.
--
-- >>> exEval1 "5 3 -"
-- Just 2
-- >>> exEval1 "10 3 - 2 *"
-- Just 14
-- >>> exEval1 "3 10 -"
-- Just (-7)
-- >>> exEval1 "3 4 + 5 *"
-- Just 35
-- >>> exEval1 "3 4 bad"
-- Nothing
exEval1 :: String -> Maybe Int
exEval1 input =
    case evalWordsV1 (words input) [] of
        Just [result] -> Just result
        _             -> Nothing
  where
    -- Explicit recursion, explicit stack threading (Version 1 style)
    evalWordsV1 :: [String] -> Stack -> Maybe Stack
    evalWordsV1 []     stack = Just stack
    evalWordsV1 (w:ws) stack =
        case stepWordV1 stack w of
            Nothing     -> Nothing
            Just stack' -> evalWordsV1 ws stack'

    -- Supports integer literals, "+", "*", "-"
    stepWordV1 :: Stack -> String -> Maybe Stack
    stepWordV1 stack w =
        case reads w of
            [(n, "")] -> Just (n : stack)  -- push number
            _         -> case w of
                "+" -> case stack of
                    (b:a:rest) -> Just ((a + b) : rest)
                    _          -> Nothing
                "*" -> case stack of
                    (b:a:rest) -> Just ((a * b) : rest)
                    _          -> Nothing
                "-" -> case stack of
                    (b:a:rest) -> Just ((a - b) : rest)
                    _          -> Nothing
                _   -> Nothing

-- EXERCISE 2 ----------------------------------------------------------------

-- | Extend Version 2 with a SWAP operation.
--
-- >>> exEval2 "3 4 swap -"
-- Just 1
-- >>> exEval2 "5 3 swap -"
-- Just (-2)
-- >>> exEval2 "2 3 * 4 5 * +"
-- Just 26
-- >>> exEval2 "4 swap"
-- Nothing
exEval2 :: String -> Maybe Int
exEval2 input = do
    finalStack <- foldM stepWordV2 [] (words input)
    case finalStack of
        [result] -> Just result
        _        -> Nothing
  where
    -- foldM short-circuits on the first Nothing (Version 2 style)
    stepWordV2 :: Stack -> String -> Maybe Stack
    stepWordV2 stack w =
        case reads w of
            [(n, "")] -> Just (n : stack)  -- push number
            _         -> case w of
                "+" -> case stack of
                    (b:a:rest) -> Just ((a + b) : rest)
                    _          -> Nothing
                "*" -> case stack of
                    (b:a:rest) -> Just ((a * b) : rest)
                    _          -> Nothing
                "-" -> case stack of
                    (b:a:rest) -> Just ((a - b) : rest)
                    _          -> Nothing
                "swap" -> case stack of
                    (x:y:rest) -> Just (y : x : rest)
                    _          -> Nothing
                _   -> Nothing

-- EXERCISE 3 ----------------------------------------------------------------

-- | Extend Version 3 with a DUP operation.
--
-- >>> exEval3 "3 dup *"
-- Just 9
-- >>> exEval3 "5 dup + dup +"
-- Just 20
-- >>> exEval3 "3 4 + dup *"
-- Just 49
-- >>> exEval3 "dup"
-- Nothing
exEval3 :: String -> Maybe Int
exEval3 input = do
    finalStack <- execStateT (mapM_ stepWordV3 (words input)) []
    case finalStack of
        [result] -> Just result
        _        -> Nothing
  where
    -- StateT Stack Maybe: stack is implicit state (Version 3 style)
    stepWordV3 :: String -> Calc ()
    stepWordV3 w =
        case reads w of
            [(n, "")] -> pushS n
            _         -> case w of
                "+"   -> applyOpS (+)
                "*"   -> applyOpS (*)
                "dup" -> dupS
                _     -> lift Nothing

    -- Duplicate the top element (fails if stack is empty via popS)
    dupS :: Calc ()
    dupS = do
        x <- popS
        pushS x
        pushS x
