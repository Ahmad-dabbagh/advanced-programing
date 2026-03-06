# Reflection

## Question 1: The Mechanism of Failure

Bob’s error was caused by rounding each of the individual deductions before summing them.

Mathematically, rounding is not associative,which means :
round(a) + round(b) ≠ round(a + b)

Each individual rounding introduces a small error of up to ±0.005.
When applied to a large number of salaries, these small errors accumulate into a measurable discrepancy.

No money was actually lost or created.
The discrepancy exists purely due to accumulated rounding errors caused by premature rounding.

The correct approach is to:
1. Compute the exact total revenue.
2. Determine the exact total deduction.
3. Distribute rounding differences explicitly.

Bob rounded first and reconciled later.
That is why the books did not balance.
