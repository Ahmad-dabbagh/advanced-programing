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
```

**Your answer:**
- Males: 497
- Females:503

---

## Task 1.2: The Tallest and Shortest

**Goal**: Find the tallest and shortest person in the dataset. Print their id, name, surname, and height.

**Your command for tallest:**
```bash
tail -n +2 test_1m.csv | sort -t',' -k6,6n |
tail -n 1 | awk -F',' '{print "ID:",$1,"\nName:",$2,$3,"\nHeig
ht:",$6}'

```

**Tallest person:**
- ID: f452b01e
- Name: Zoe Salazar
- Height: 205

**Your command for shortest:**
```bash
tail -n +2 test_1m.csv | sort -t',' -k6,6n | head -n 1 | awk -F',' '{print "ID:",$1,"\nName:",$2,$3,"\nHeight:",$6}'


```

**Shortest person:**
- ID: 01e7cda3
- Name: Aaron Brooks
- Height: 155

---

## Task 1.3: The Missing Salaries Mystery

**Goal**: How many people in `test.csv` don't have a salary listed? What percentage is that?

**Your command:**
```bash
awk -F',' 'NR>1 {total++; if($7=="") missing++} END {printf "Missing: %d\nTotal: %d\nPercentage: %.2f%%\n", missing, total, (missing/total)*100}' test.csv

```

**Your answer:**
- Count without salary: 94
- Total people: 1000
- Percentage: 9.40%

---

## Task 1.4: Salary Analysis by Gender

**Goal**: Calculate the average salary for males and females separately in `test.csv`

**Your AWK script or command for females:**
```bash
awk -F',' 'NR>1 && $4=="f" && $7!="" {sum+=$7; count++} END {if(count>0) print sum/count; else print 0}' test.csv

```

**Female average salary:** 28958.2

**Your AWK script or command for males:**
```bash
awk -F',' 'NR>1 && $4=="m" && $7!="" {sum+=$7; count++} END {if(count>0) print sum/count; else print 0}' test.csv


```

**Male average salary:** 27391.8

**Observation**: Who earns more on average? females

---

## Task 1.5: Age Groups (5 points)

**Goal**: Count how many people fall into these age groups in `test.csv`:
- 18-22 years
- 23-27 years
- 28-32 years

**Your command(s):**
```bash

awk -F',' '
NR>1 {
  age=$5
  if(age>=18 && age<=22) g1++
  else if(age>=23 && age<=27) g2++
  else if(age>=28 && age<=32) g3++
}
END {
  print "18-22:", g1
  print "23-27:", g2
  print "28-32:", g3
}' test.csv



```

**Your answer:**
- 18-22: 351
- 23-27: 329
- 28-32: 320

---

## Task 1.6: Height Frequency Plot 

**Goal**: Create a frequency distribution of heights and generate a plot using gnuplot.

**Your command to create frequency data:**
```bash
tail -n +2 test.csv | cut -d',' -f6 | sort -n | uniq -c > height_freq.dat
vim height_plot.gp

gnuplot height_plot.gp
height_distribution.png


```

**Your gnuplot commands (save as `height_plot.gp`):**
```gnuplot

git add height_freq.dat height_plot.gp height_distribution.png
git commit -m "Add height frequency plot"
git push



```

**Upload your plot**: Save as `height_distribution.png` and commit it to the repo.

**Observation**: What height appears most frequently? 
181



## Task 1.7: The Richest Top 10

**Goal**: Find the 10 people with the highest salaries from `test.csv`. Show id, name, and salary.

**Your command:**
```bash
awk -F',' 'NR>1 && $7!="" {print $1","$2","$7}' test.csv | sort -t',' -k3,3nr | head -n 10


```

**Your answer (list top 3):**
1. a3896f45,Erling,49878
2. 7cda3896,Ingebjorg,49864
3. a3896f45,Mathias,49844

---

## Task 1.8: Performance Challenge (5 points)

**Goal**: Compare the execution time of calculating the average salary in both `test.csv` and `test_1m.csv`

**Your command for test.csv with timing:**
```bash
/usr/bin/time -f "%e" awk -F',' 'NR>1 && $7!="" {sum+=$7; c++} END {if(c) print sum/c; else print 0}' test.csv


```

**Time taken:** 0.02 seconds

**Your command for test_1m.csv with timing:**
```bash
/usr/bin/time -f "%e" awk -F',' 'NR>1 && $7!="" {sum+=$7; c++} END {if(c) print sum/c; else print 0}' test_1m.csv


```

**Time taken:**  0.53 seconds

**Observation**: How much slower is processing 1 million rows vs 1000 rows? 26.5 times slower

 
---

# Part 2: Git Repository Exploration

We will use CSAMS codebase for this. 

Navigate to the repository directory for all tasks below.

---

## Task 2.1: File Count

**Goal**: How many files are in the repository (excluding directories)?

**Your command:**
```bash
find . -type f -not -path "./.git/*" | wc -l


```

**Your answer:** 3026 files

---

## Task 2.2: The Biggest File

**Goal**: Find the largest file in the repository. Show its size and path.

**Your command:**
```bash
find . -type f -not -path "./.git/*" -printf "%s\t%p\n" | sort -nr | head -n 1


```

**Your answer:**
- Path: ./dbservice/data/mysql.ibd
- Size: 32505856 

---

## Task 2.3: Lines of Code (5 points)

**Goal**: Count the total number of lines in all `.go` files 

**Your command:**
```bash
find . -name "*.go" -type f -print0 | xargs -0 wc -l | tail -n 1


```

**Your answer:** 23900  lines

---

## Task 2.4: File Extensions Census

**Goal**: Count files by extension and show the top 5 most common extensions.

**Your command:**
```bash
find . -type f \
| sed 's/.*\.//' \
| sort \
| uniq -c \
| sort -nr \
| head -n 5



```

**Your answer (top 5):**
1. 1620: svg files
2. 474: js files
3. 234: sdi files
4. 144: go files
5. 124: ts files

---

## Task 2.5: TODO Hunter

**Goal**: How many TODO or FIXME comments are in the codebase?

**Your command:**
```bash
grep -RIn --exclude-dir=.git "TODO" . | wc -l
grep -RIn --exclude-dir=.git "FIXME" . | wc -l

echo "Total: $(( $(grep -RIn --exclude-dir=.git "TODO" . | wc -l) + $(grep -RIn --exclude-dir=.git "FIXME" . | wc -l) ))"

```

**Your answer:**
- TODO: 151
- FIXME: 2
- Total: 153

---

## Task 2.6: The Longest Filename

**Goal**: Find the file with the longest filename (basename, not full path).

**Your command:**
```bash
find . -type f -not -path "./.git/*" -printf "%f\n" | awk '{print length, $0}' | sort -nr | head -n 1


```

**Your answer:**
- Filename: american-sign-language-interpreting.svg
- Length: ___39___ characters

---

## Task 2.7: Empty Files

**Goal**: How many empty files (0 bytes) are in the repository?

**Your command:**
```bash
find . -type f -size 0 -not -path "./.git/*" | wc -l

```

**Your answer:**  3 empty files

---

## Task 2.8: Directory Depth

**Goal**: What is the maximum directory depth in the repository? Find the deepest path.

**Your command:**
```bash
find . -type d -not -path "./.git/*" | awk -F'/' '{print NF-1, $0}' | sort -nr | head -n 1


```

**Your answer:**
- Maximum depth: 7
- Example deepest path: ./e2e/node_modules/playwright/lib/mcp/browser/tools

---

## Task 2.9: Code vs Comments

**Goal**: In `.go` files, estimate the ratio of comment lines to code lines.
Count lines starting with `//` or `/*` or `*` as comments.

**Your command:**
```bash

total=$(find . -name "*.go" -type f -not -path "./.git/*" -exec cat {} + | wc -l)
comments=$(find . -name "*.go" -type f -not -path "./.git/*" -exec cat {} + | grep -E '^[[:space:]]*(//|/\*|\*)' | wc -l)
echo "Comment lines: $comments"
echo "Total lines: $total"
echo "Ratio: $comments/$total"


```

**Your answer:**
- Comment lines: 2622
- Total lines: 23900
- Ratio: 

---

## Task 2.10: The Most Common Word

**Goal**: Find the 10 most common words in `.md` and `.txt` files

**Your command:**
```bash
find . -type f \( -name "*.md" -o -name "*.txt" \) -not -path "./.git/*" \
-exec cat {} + \
| tr '[:upper:]' '[:lower:]' \
| tr -c '[:alnum:]' '\n' \
| grep -v '^$' \
| sort \
| uniq -c \
| sort -nr \
| head -n 10




```

**Your answer (top 5 words):**
1. the
2. of
3. to
4. or
5. and
---

## Task 2.11: Recent Changes

**Goal**: Using git log, find how many commits were made in the last 30 days.

**Your command:**
```bash
git log --since="30 days ago" --oneline | wc -l


```

**Your answer:** 0 commits

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
find . -type f -not -path "./.git/*" -printf "%s\n" | awk '
{
  if ($1 <= 1024) tiny++
  else if ($1 <= 10240) small++
  else if ($1 <= 102400) medium++
  else if ($1 <= 1048576) large++
  else huge++
}
END {
  print "Tiny:", tiny
  print "Small:", small
  print "Medium:", medium
  print "Large:", large
  print "Huge:", huge
}'
```

**Your answer:**
- Tiny: 1594
- Small: 1041
- Medium: 261
- Large: 85
- Huge: 45

---

## Task 2.13: Function Counter

**Goal**: Count how many function definitions are in `.go` files (look for pattern: `func function_name(`)

**Your command:**
```bash
find . -name "*.go" -type f -not -path "./.git/*" -exec grep -hE '^[[:space:]]*func[[:space:]]+[A-Za-z0-9_]+' {} + | wc -l


```

**Your answer:** 336 functions found

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
# Repo name (folder name)
repo_name=$(basename "$(pwd)")

# Total files (exclude .git)
total_files=$(find . -type f -not -path "./.git/*" | wc -l)

# Total directories (exclude .git)
total_dirs=$(find . -type d -not -path "./.git/*" | wc -l)

# Total lines of code in .go files
total_go_lines=$(find . -name "*.go" -type f -not -path "./.git/*" -exec cat {} + | wc -l)

# Largest file (size in bytes + path)
largest_file=$(find . -type f -not -path "./.git/*" -printf "%s\t%p\n" | sort -nr | head -n 1)

# Most common file extension
most_common_ext=$(find . -type f -not -path "./.git/*" \
  | awk -F. 'NF>1 {print $NF}' \
  | sort | uniq -c | sort -nr | head -n 1)

echo "Repository name: $repo_name"
echo "Total files: $total_files"
echo "Total directories: $total_dirs"
echo "Total lines of code (.go): $total_go_lines"
echo "Largest file (bytes + path): $largest_file"
echo "Most common extension: $most_common_ext"

```

**Run your script and paste the output here:**
```Repository name: csams.git
Total files: 3027
Total directories: 156
Total lines of code (.go): 23900
Largest file (bytes + path): 32505856   ./dbservice/data/mysql.ibd
Most common extension:    1620 svg
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
