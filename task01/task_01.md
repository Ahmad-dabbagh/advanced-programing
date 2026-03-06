# Task 01: The Accountant

**DATE: 14 January** 
**Deadline: 21 January** 
**Format: group activity done at home. AI usage for helping with the task**

---

## The Situation

You receive an encrypted message at 3 AM. The burner phone displays a single line:

> *"We need someone who can count. Be at the warehouse. 6 AM. Come alone."*

---

## The Meeting

The warehouse is cold. A woman in an expensive suit sits across from you. She doesn't introduce herself. She doesn't need to.

*"You come highly recommended,"* she says, sliding a USB drive across the table. *"We have an... accounting problem."*

She lights a cigarette. The smoke drifts up toward the fluorescent lights.

*"Our organization operates globally. One million independent contractors. They move product. We pay them a salary. Every month, we collect 33% for operational expenses—protection, logistics, distribution networks. The usual overhead."*

She taps ash into a crystal tray.

*"Last month, our previous accountant, Bob, submitted his calculations. Mario ran the numbers. They came up short. Seventy-four thousand missing. Money disappeared into thin air."*

She pauses.

*"Bob insisted it was 'rounding errors.' The Mariu didn't find that explanation... satisfactory."*

You notice she uses past tense when referring to Bob. You assumed, Bob is gone.

*"You have 48 hours. The data is on that drive. One million salary records. Calculate the 33% operational fee for each contractor. Generate the deduction file. Then check that the sum of all individual deductions equals exactly 33% of total revenue."*

She stubs out the cigarette.

*"If there's a single cent unaccounted for—if money appears from nowhere or vanishes into the ether, Mario will assume you're either incompetent or skimming."*

She stands up. Two men in dark suits appear from the shadows.

*"They don't tolerate either."*

The door closes behind her. You're alone with the USB drive and the sound of your heartbeat.

---

## The Data

**File**: `test_1m.csv` (encrypted, password: provided separately)

**Structure**: `id,name,surname,sex,age,height,salary`

One million contractors. Some entries have no salary listed—those are specialists on different payment schedules. Ignore them.

Your job: Calculate 33% operational deduction on each listed salary. This is what they must pay us. Round to two decimal places (dollars and cents). No exceptions.

---

## The Deliverables

### Primary Output: Deduction File

**File**: `deductions_33_percent.txt`

Format: One amount per line, two decimal places, no currency symbols.

```
16500.00
19800.00
18150.00
...
```

This file must contain exactly as many lines as there are contractors with salaries.

### Verification Report

Print to stdout in this exact format:

```
=== RECONCILIATION REPORT ===
Contractors processed: XXXXXX
Total revenue: XXXXXXXXX.XX
Sum of deductions: XXXXXXXXX.XX
Expected (33% of total): XXXXXXXXX.XX
Discrepancy: X.XX
Status: [RECONCILED / DISCREPANCY]
=============================
```

**Critical**: The "Discrepancy" line MUST read `0.00` or `0.01` you don't leave this warehouse alive.

---

### Requirement: Performance Analysis

Create C++ and AWK based implementations. 

Run each implementation three times. Record only the fastest execution time for each.

**C++ best time**: ___________ milliseconds

**AWK best time**: ___________ milliseconds

---

### Requirement: The Bob Test (Optional but Recommended)

Create a deliberately broken version that is called `bob_version.cpp` and `bob_version.awk`.

Run it. Document the discrepancy.

This proves you understand what killed Bob. Understanding what went wrong is the first step to not repeating his mistakes.

**Bob's discrepancy**: ___________ 

---

## Documentation Requirements

### README.md

Brief explanation of your approach:
- Any optimization techniques used
- Edge cases you handled
- Performance considerations
- Build and run instructions

Keep it concise. These people don't read long reports.

---

### REFLECTION.md

Answer these questions. Your life might depend on understanding this deeply.

#### Question 1: The Mechanism of Failure

Explain why Bob's naive rounding created  discrepancy. Where did the money go? Or where did it come from? Be specific about the mathematics.

**Your answer**:

---

#### Question 2: Explain your technique

Describe your algorithm in your own words. Why does it guarantee perfect reconciliation? 

**Your answer**:

---

#### Question: Performance Analysis

Which implementation was faster—C++ or AWK? By how much? Explain the factors that might have contributed to the performance difference.

How can we make the implementation for this task more performant?

**Your answer**:


---

## Final Notes

The woman's last words echo in your mind:

*"Bob was good with computers. Great with math. But he didn't understand that in our business, precision isn't optional. Every cent matters. Every transaction is sacred. The books must balance."*

She paused at the door.

*"Bob forgot that. You saw where that got him."*

*"Don't be like Bob."*

---

The USB drive sits on your desk. The clock shows 6:47 AM. You have 41 hours and 13 minutes.

The code won't write itself.

---

**[END OF BRIEFING]**

---

## Emergency Contact

If you encounter technical issues (not accounting discrepancies—those are your problem), contact course staff through normal channels.

If you encounter actual criminal organizations, contact local authorities immediately. This is a programming exercise, not a career opportunity.

Stay safe. Code carefully. Balance your books.

**The difference between Bob and you is attention to detail.**

Don't end up like Bob.
