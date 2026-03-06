# Command-Line Tools: Task 00

**DATE: 14 January** 
**Deadline: 14 January** 
**Format: group activity done in class. NO AI**

---

## Instructions

1. Clone and then copy this file from the repository into your own repo
2. Complete all tasks below
3. Fill in your commands and answers in the designated spaces
4. Test your commands to ensure they work correctly
5. Commit and push your completed file back to the repository



---

# Part 1: CSV Data Analysis

Use the provided CSV files: `test.csv` (1,000 entries) and `test_1m.csv` (1,000,000 entries)

CSV structure: `id,name,surname,sex,age,height,[salary]`

## Task 1.1: Gender Distribution

**Goal**: Count the number of males and females in `test.csv`

**Your command:**
```bash
awk -F',' 'NR>1 {count[$4]++} END {print count["m"], count["f"]}' test.csv

awk -F',' 'NR>1 {count[$4]++} END {print count["m"], count["f"]}' test_1m.
csv
```

**Your answer:**
- Males: 497 ,500076 
- Females:503 ,499924

---

## Task 1.2: The Tallest and Shortest

**Goal**: Find the tallest and shortest person in the dataset. Print their id, name, surname, and height.

**Your command for tallest:**
```bash
awk -F',' '
NR>1 {
    if (NR==2 || $6 < min) {
        min=$6
        id=$1
        name=$2
        surname=$3
        height=$6
    }
}
END {
    print id, name, surname, height
}' test.csv



```

**Tallest person:**
- ID: e7cda389 
- Name: Ulaf Aas
- Height: 205
**Your command for shortest:**
```bash
awk -F',' '
NR>1 {
    if (NR==2 || $6 < min) {
        min=$6
        id=$1
        name=$2
        surname=$3
        height=$6
    }
}
END {
    print id, name, surname, height
}' test.csv

```

**Shortest person:**
- ID: 1e7cda38
- Name: Ragnhild Nystrom 
- Height: 155

---

## Task 1.3: The Missing Salaries Mystery

**Goal**: How many people in `test.csv` don't have a salary listed? What percentage is that?

**Your command:**
```bash


```

**Your answer:**
- Count without salary: ___________
- Total people: ___________
- Percentage: ___________

---

## Task 1.4: Salary Analysis by Gender

**Goal**: Calculate the average salary for males and females separately in `test.csv`

**Your AWK script or command for females:**
```bash


```

**Female average salary:** ___________

**Your AWK script or command for males:**
```bash


```

**Male average salary:** ___________

**Observation**: Who earns more on average? ___________

---

## Task 1.5: Age Groups (5 points)

**Goal**: Count how many people fall into these age groups in `test.csv`:
- 18-22 years
- 23-27 years
- 28-32 years

**Your command(s):**
```bash




```

**Your answer:**
- 18-22: ___________
- 23-27: ___________
- 28-32: ___________

---

## Task 1.6: Height Frequency Plot 

**Goal**: Create a frequency distribution of heights and generate a plot using gnuplot.

**Your command to create frequency data:**
```bash


```

**Your gnuplot commands (save as `height_plot.gp`):**
```gnuplot




```

**Upload your plot**: Save as `height_distribution.png` and commit it to the repo.

**Observation**: What height appears most frequently? ___________

---

## Task 1.7: The Richest Top 10

**Goal**: Find the 10 people with the highest salaries from `test.csv`. Show id, name, and salary.

**Your command:**
```bash


```

**Your answer (list top 3):**
1. ___________
2. ___________
3. ___________

---

## Task 1.8: Performance Challenge (5 points)

**Goal**: Compare the execution time of calculating the average salary in both `test.csv` and `test_1m.csv`

**Your command for test.csv with timing:**
```bash


```

**Time taken:** ___________ seconds

**Your command for test_1m.csv with timing:**
```bash


```

**Time taken:** ___________ seconds

**Observation**: How much slower is processing 1 million rows vs 1000 rows? ___________


---

# Part 2: Git Repository Exploration

We will use CSAMS codebase for this. 

Navigate to the repository directory for all tasks below.

---

## Task 2.1: File Count

**Goal**: How many files are in the repository (excluding directories)?

**Your command:**
```bash


```

**Your answer:** ___________ files

---

## Task 2.2: The Biggest File

**Goal**: Find the largest file in the repository. Show its size and path.

**Your command:**
```bash


```

**Your answer:**
- Path: ___________
- Size: ___________

---

## Task 2.3: Lines of Code (5 points)

**Goal**: Count the total number of lines in all `.go` files 

**Your command:**
```bash


```

**Your answer:** ___________ lines

---

## Task 2.4: File Extensions Census

**Goal**: Count files by extension and show the top 5 most common extensions.

**Your command:**
```bash



```

**Your answer (top 5):**
1. ___________: ___________ files
2. ___________: ___________ files
3. ___________: ___________ files
4. ___________: ___________ files
5. ___________: ___________ files

---

## Task 2.5: TODO Hunter

**Goal**: How many TODO or FIXME comments are in the codebase?

**Your command:**
```bash


```

**Your answer:**
- TODO: ___________
- FIXME: ___________
- Total: ___________

---

## Task 2.6: The Longest Filename

**Goal**: Find the file with the longest filename (basename, not full path).

**Your command:**
```bash


```

**Your answer:**
- Filename: ___________
- Length: ___________ characters

---

## Task 2.7: Empty Files

**Goal**: How many empty files (0 bytes) are in the repository?

**Your command:**
```bash


```

**Your answer:** ___________ empty files

---

## Task 2.8: Directory Depth

**Goal**: What is the maximum directory depth in the repository? Find the deepest path.

**Your command:**
```bash


```

**Your answer:**
- Maximum depth: ___________
- Example deepest path: ___________

---

## Task 2.9: Code vs Comments

**Goal**: In `.go` files, estimate the ratio of comment lines to code lines.
Count lines starting with `//` or `/*` or `*` as comments.

**Your command:**
```bash



```

**Your answer:**
- Comment lines: ___________
- Total lines: ___________
- Ratio: ___________

---

## Task 2.10: The Most Common Word

**Goal**: Find the 10 most common words in `.md` and `.txt` files

**Your command:**
```bash




```

**Your answer (top 5 words):**
1. ___________
2. ___________
3. ___________
4. ___________
5. ___________

---

## Task 2.11: Recent Changes

**Goal**: Using git log, find how many commits were made in the last 30 days.

**Your command:**
```bash


```

**Your answer:** ___________ commits

---

## Task 2.12: File Size Distribution (5 points)

**Goal**: Categorize files by size ranges:
- Tiny: 0-1KB
- Small: 1-10KB
- Medium: 10-100KB
- Large: 100KB-1MB
- Huge: >1MB

**Your commands:**
```bash






```

**Your answer:**
- Tiny: ___________
- Small: ___________
- Medium: ___________
- Large: ___________
- Huge: ___________

---

## Task 2.13: Function Counter

**Goal**: Count how many function definitions are in `.go` files (look for pattern: `func function_name(`)

**Your command:**
```bash


```

**Your answer:** ___________ functions found

---


## Task 2.14: Create a Report

**Goal**: Create a bash script called `repo_stats.sh` that outputs a summary report with:
- Repository name
- Total files
- Total directories
- Total lines of code
- Largest file
- Most common file extension

**Your script (save as `repo_stats.sh`):**
```bash
#!/bin/bash








```

**Run your script and paste the output here:**
```


```

**Commit your script:** Make sure to commit `repo_stats.sh` to the repository!

---

# Part 3: Bonus Challenges

## Bonus 1: Salary Visualization (10 points)

**Goal**: Create a salary distribution histogram using gnuplot with bins of 5000 (0-5000, 5000-10000, etc.)

**Your AWK script to prepare data:**
```bash



```

**Your gnuplot script:**
```gnuplot




```

**Upload:** Save as `salary_histogram.png` and commit it.

---

## Bonus 2: Duplicate Finder

**Goal**: Find files with duplicate names (same basename) but in different directories in the git repository.

**Your command:**
```bash




```

**How many duplicate filenames did you find?** ___________

**Example (list 3):**
1. ___________
2. ___________
3. ___________

---

# Reflection Questions

## Question 1: Command-Line vs GUI Tools

In your experience completing these tasks, what are the advantages of command-line tools over GUI applications (like Excel) for data analysis?

**Your answer (3-5 sentences):**




---

## Question 2: Pipeline Composition

Which task did you find most challenging, and how did you use pipes to solve it?

**Your answer (3-5 sentences):**




---

## Question 3: AWK Learning

What was the most useful AWK feature you learned, and how might you use it in future projects?

**Your answer (3-5 sentences):**




---

# Submission Checklist

Before submitting, ensure you have:

- [ ] Filled in all commands and answers
- [ ] Tested all commands to verify they work
- [ ] Generated and committed `height_distribution.png`
- [ ] Created and committed `repo_stats.sh`
- [ ] Completed weblog analysis tasks
- [ ] Committed any bonus task outputs (salary histogram, peak activity chart, etc.)
- [ ] Answered reflection questions
- [ ] Pushed this completed file to the repository

- [ ] I have Haskell environment setup and I have generated and run `Hello World` in Haskell
- [ ] I have Rust environment setup and I have generated and run `Hello World` in rust

---

# Part 4: Web Server Log Analysis

Use the provided `weblog.log` file for these tasks.

**Log format:**
```
YYYY/MM/DD HH:MM:SS | STATUS | RESPONSE_TIME | IP_ADDRESS | HTTP_METHOD | ENDPOINT
```

**Example line:**
```
2025/10/22 18:32:25 | 200 |          2ms |           [::1] | GET       | /login
```

---

## Task 4.1: Request Statistics

**Goal**: Analyze the basic statistics of the web server log.

**a) Total number of HTTP requests (lines with `|` status codes):**
```bash


```
**Answer:** ___________ requests

**b) Count by HTTP status code (200, 302, 307, 500, etc.):**
```bash


```

**Your answer:**
- 200 (OK): ___________
- 302 (Redirect): ___________
- 307 (Temporary Redirect): ___________
- 500 (Server Error): ___________
- Other codes: ___________

---

## Task 4.2: Endpoint Popularity Contest

**Goal**: Find the 10 most frequently accessed endpoints (URLs/paths).

**Your command:**
```bash




```

**Your answer (top 5):**
1. ___________: ___________ requests
2. ___________: ___________ requests
3. ___________: ___________ requests
4. ___________: ___________ requests
5. ___________: ___________ requests

**Observation**: Which endpoint is accessed most? ___________

---

## Task 4.3: GET vs POST Analysis

**Goal**: Compare GET and POST requests.

**a) Count GET vs POST requests:**
```bash


```

**Your answer:**
- GET requests: ___________
- POST requests: ___________
- Ratio (GET/POST): ___________

**b) Calculate average response time for GET vs POST:**
```bash




```

**Your answer:**
- Average GET response time: ___________ ms
- Average POST response time: ___________ ms

**Observation**: Which method is faster on average? ___________


---

**End of Task Sheet**

**Notes for students:**
- Work through tasks sequentially
- Use `man` pages when stuck
- Test your commands on small datasets first
- Ask for help if you're stuck for more than 20 minutes
- Remember: there are often multiple correct solutions!

**Good luck and have fun exploring the command line!**
