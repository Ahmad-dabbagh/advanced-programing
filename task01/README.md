# Task 01 – The Accountant

## Approach
The solution processes all monetary values in integer cents to avoid floating-point inaccuracies.
For each contractor, the 33% operational fee is calculated using integer arithmetic.
To ensure exact reconciliation, rounding differences are handled explicitly by distributing leftover cents.

Two implementations are provided:
- A native C++ solution for performance and full control over memory and arithmetic.
- An AWK scripting solution demonstrating the same logic in a scripting environment.

## Optimizations
- No floating-point arithmetic is used.
- Single-pass processing of the input file.
- C++ implementation avoids global sorting by using remainder buckets.
- AWK implementation uses minimal external tools only where necessary.

## Edge Cases
- Contractors with missing salary values are ignored.
- Salaries with decimal fractions are rounded to two decimals (HALF-UP).
- The sum of all deductions is guaranteed to match 33% of total revenue.

## Build & Run

### C++
```bash
g++ -O2 -std=c++17 accountant.cpp -o accountant
./accountant test_1m.csv
