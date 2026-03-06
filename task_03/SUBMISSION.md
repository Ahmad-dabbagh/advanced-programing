# Task 03: Submission

**Student Name**: [Ahmad Dabbagh]
**Date**: [03.02.2026]

Even though you work on tasks in groups, **all students submit individually**.

---

## What to Submit

1. **Implemented functions** in the `.lhs` files:
   - `a-tuples/src/Tuples.lhs`
   - `b-lists/src/Lists.lhs`
   - `c-map/src/Mapping.lhs`
   - `d-recursion-fold/src/Recursion.lhs`

2. **Written answers** in this file (below)

---

## Written Answers

### Question 1: When does foldr vs foldl matter?

When do `foldr` and `foldl` give different results?

**Your Answer:**

when the operation is not commutative <<==

[Write your explanation here. Consider:

- Which operations are affected?
(-) (/) 
- Give concrete examples with numbers  <<==
foldl(-) 1 [1,2,3] /= foldr (-) 1 [1,2,3]

-5 /= 1
- What property must the operation have for them to be equivalent?]
	it should be commutative (right -> left == left <-right)

---

### Question 2: Evaluation Difference

How do `foldr` and `foldl` evaluate differently?

**Your Answer:**

[Write your explanation here. Consider:
	foldr reduces  right , building a right -nested expression 
	foldl reducing a list from the left and building a nest expression from the left
- Draw out how each evaluates `foldr (-) 0 [1,2,3]` vs `foldl (-) 0 [1,2,3]`

foldl (-) 0 [1,2,3] <<==
= ((0-1)-2)-3) = (-1 -2 ) -3 = -3 -3 = -6
<<==//==>>
foldr (-) 0 [1,2,3] <<==
= (1- ( 2 - (3-0)) = 1 -(2 - 3) = 1 - (-1) = 2

- Which builds up from the right? Which from the left?

=>ldr : builds from the right , foldl : builds from the left 

- What are the implications for infinite lists?]
=>> the foldl is not suitable for infinte lists since it needs to process the whole list , which cant not happen in this case , on the other hand the foldr can work on infint lists specially if the function is lazy or (short- circuiting) which means it does not need to process the whole list
---

### Reflection

**Which approach do you prefer: recursion or folding?**
==>> for me both still a bit confusing , but as i learned from before recrusion can end up with an explotion of calls and it can be less efficient if it was not written carefully.

On the other hand , folding was less intuative at first , but i think i will get used to it more with more practicing 
  recrusion : when i need to clearly express the logic behind a problem or a reason step by step
  Folding : with standered list transformations (where patteren is already clear)

**What patterns did you notice?**

that many list processing functions are using the same structur and there are the repeated base values as well (0 , 1, [] ) , also both of recrusion and fold can often solv the same problem but, recrusion makes the flow more visible while fold hides the recrusion and focuse on what is being combined.
its impportant to have an idea about what to use (foldr , foldl) and pick the one which accheaves the wanted goal 
                      

---

### Bonus: Your Examples (Optional)

If you experimented with interesting fold expressions, paste them here:

```haskell
-- Your experiments
```

---

## Checklist

### Code and Answers

- []All functions in `a-tuples/src/Tuples.lhs` implemented
- []All functions in `b-lists/src/Lists.lhs` implemented
- [] All functions in `c-map/src/Mapping.lhs` implemented
- [] All functions in `d-recursion-fold/src/Recursion.lhs` implemented
- [] All projects build without errors (`stack build`)
- [ ]All tests pass (`stack test`)
- [ ] Question 1 answered (foldr vs foldl)
- [ ] Question 2 answered (evaluation difference)
- [ ] Reflection completed

### Submission

- [ ] Code pushed to personal Git repository
- [ ] This file filled in with answers

**Remember**: Do NOT use AI assistants for this task.
