# Text Processing and Filters

## Table of Contents
1. [Introduction to Text Processing](#introduction-to-text-processing)
2. [grep - Pattern Searching](#grep---pattern-searching)
3. [sed - Stream Editor](#sed---stream-editor)
4. [awk - Text Processing Language](#awk---text-processing-language)
5. [sort and uniq](#sort-and-uniq)
6. [cut and paste](#cut-and-paste)
7. [tr - Translate Characters](#tr---translate-characters)
8. [wc - Word Count](#wc---word-count)

---

## Introduction to Text Processing

In Unix, text processing is fundamental for:
- Log file analysis
- Data extraction and transformation
- Report generation
- Configuration file manipulation
- Data validation

**Key Concept**: Unix philosophy - "Do one thing and do it well" combined with pipes.

### Pipes and Redirection

**Pipe (|)** - Send output of one command to input of another:
```bash
command1 | command2 | command3
```

**Redirection**:
```bash
command > file          # Redirect stdout to file (overwrite)
command >> file         # Append stdout to file
command < file          # Read stdin from file
command 2> file         # Redirect stderr to file
command &> file         # Redirect both stdout and stderr
command 2>&1            # Redirect stderr to stdout
```

---

## grep - Pattern Searching

**Global Regular Expression Print** - Search for patterns in files.

### Basic Usage

```bash
# Search for pattern in file
grep "pattern" file.txt

# Search multiple files
grep "error" *.log

# Search recursively in directories
grep -r "ERROR" /var/log/

# Case-insensitive search
grep -i "error" file.txt
```

### Common Options

```bash
# Show line numbers
grep -n "error" file.txt

# Show only count of matches
grep -c "error" file.txt

# Invert match (show lines NOT matching)
grep -v "success" file.txt

# Show only filenames with matches
grep -l "error" *.log

# Show filenames without matches
grep -L "error" *.log

# Show N lines after match
grep -A 3 "error" file.txt

# Show N lines before match
grep -B 3 "error" file.txt

# Show N lines before and after
grep -C 3 "error" file.txt

# Match whole word only
grep -w "error" file.txt

# Show matching part only
grep -o "error" file.txt

# Recursive with line numbers
grep -rn "ERROR" /var/log/
```

### Regular Expressions with grep

```bash
# Match beginning of line
grep "^Start" file.txt

# Match end of line
grep "End$" file.txt

# Match any character
grep "a.c" file.txt          # Matches: abc, adc, a1c

# Match zero or more
grep "ab*c" file.txt         # Matches: ac, abc, abbc

# Match one or more
grep "ab\+c" file.txt        # Matches: abc, abbc

# Match specific characters
grep "[aeiou]" file.txt      # Any vowel

# Match range
grep "[0-9]" file.txt        # Any digit
grep "[a-z]" file.txt        # Any lowercase letter

# Match multiple patterns
grep -E "error|warning|fatal" file.txt

# Extended regex (use -E or egrep)
grep -E "[0-9]{3}-[0-9]{4}" file.txt   # Pattern like 123-4567
```

### Practical Examples

```bash
# Find all errors in today's logs
grep "ERROR" /var/log/app_$(date +%Y%m%d).log

# Find specific error code with context
grep -C 5 "ERROR-1234" application.log

# Count errors per log file
grep -c "ERROR" *.log

# Find IP addresses
grep -E "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" access.log

# Find lines with email addresses
grep -E "[a-zA-Z0-9._]+@[a-zA-Z0-9.]+\.[a-zA-Z]{2,}" contacts.txt

# Multiple pattern search
grep -E "ERROR|FATAL|CRITICAL" application.log

# Find non-empty lines
grep -v "^$" file.txt

# Find lines starting with specific word
grep "^Transaction" data.txt

# Case-insensitive with line numbers
grep -in "exception" application.log
```

---

## sed - Stream Editor

**sed** - Non-interactive text editor for filtering and transforming text.

### Basic Substitution

```bash
# Replace first occurrence in each line
sed 's/old/new/' file.txt

# Replace all occurrences in each line
sed 's/old/new/g' file.txt

# Replace only on specific line
sed '5s/old/new/' file.txt

# Replace in range of lines
sed '10,20s/old/new/g' file.txt

# Case-insensitive replace
sed 's/old/new/gi' file.txt

# Replace and save to same file
sed -i 's/old/new/g' file.txt

# Create backup before editing
sed -i.bak 's/old/new/g' file.txt
```

### Deletion Operations

```bash
# Delete specific line
sed '5d' file.txt

# Delete range of lines
sed '10,20d' file.txt

# Delete last line
sed '$d' file.txt

# Delete lines matching pattern
sed '/pattern/d' file.txt

# Delete empty lines
sed '/^$/d' file.txt

# Delete lines starting with #
sed '/^#/d' file.txt
```

### Insertion and Append

```bash
# Insert line before line 5
sed '5i\New line here' file.txt

# Append line after line 5
sed '5a\New line here' file.txt

# Insert before pattern match
sed '/pattern/i\New line' file.txt

# Append after pattern match
sed '/pattern/a\New line' file.txt
```

### Advanced sed

```bash
# Multiple commands
sed -e 's/old/new/g' -e 's/foo/bar/g' file.txt

# Use sed script file
sed -f script.sed file.txt

# Print only matching lines
sed -n '/pattern/p' file.txt

# Print line numbers
sed -n '10,20p' file.txt

# Replace with captured groups
sed 's/\([0-9]*\)/Number: \1/' file.txt

# Remove leading whitespace
sed 's/^[ \t]*//' file.txt

# Remove trailing whitespace
sed 's/[ \t]*$//' file.txt

# Double space a file
sed 'G' file.txt

# Replace newlines with comma
sed ':a;N;$!ba;s/\n/,/g' file.txt
```

### Practical Examples

```bash
# Remove comments from config file
sed '/^#/d; /^$/d' config.conf

# Change date format (MM/DD/YYYY to YYYY-MM-DD)
sed 's|\([0-9]\{2\}\)/\([0-9]\{2\}\)/\([0-9]\{4\}\)|\3-\1-\2|' dates.txt

# Add line numbers
sed = file.txt | sed 'N;s/\n/\t/'

# Extract specific columns from CSV
sed 's/,/ /g' data.csv

# Mask sensitive data
sed 's/\([0-9]\{4\}\)[0-9]\{8\}\([0-9]\{4\}\)/\1********\2/' accounts.txt

# Remove HTML tags
sed 's/<[^>]*>//g' page.html

# Convert DOS to Unix line endings
sed 's/\r$//' dosfile.txt > unixfile.txt
```

---

## awk - Text Processing Language

**awk** - Powerful text processing language for pattern scanning and processing.

### Basic Syntax

```bash
awk 'pattern { action }' file.txt
```

### Built-in Variables

- `$0` - Entire line
- `$1, $2, ..., $NF` - Fields (columns)
- `NR` - Current line number
- `NF` - Number of fields in current line
- `FS` - Field separator (default: whitespace)
- `OFS` - Output field separator
- `RS` - Record separator (default: newline)
- `ORS` - Output record separator

### Basic Operations

```bash
# Print entire file
awk '{print}' file.txt

# Print specific columns
awk '{print $1}' file.txt           # First column
awk '{print $1, $3}' file.txt       # First and third columns
awk '{print $NF}' file.txt          # Last column

# Print with custom separator
awk '{print $1 ":" $2}' file.txt

# Print line numbers
awk '{print NR, $0}' file.txt

# Print number of fields
awk '{print NF}' file.txt
```

### Pattern Matching

```bash
# Print lines matching pattern
awk '/pattern/ {print}' file.txt

# Print if column matches
awk '$3 == "ERROR" {print}' file.txt

# Numeric comparisons
awk '$2 > 100 {print}' file.txt

# Multiple conditions
awk '$2 > 100 && $3 == "ERROR" {print}' file.txt

# OR condition
awk '$3 == "ERROR" || $3 == "FATAL" {print}' file.txt

# Range patterns
awk '/START/,/END/ {print}' file.txt
```

### Field Separators

```bash
# Custom field separator
awk -F: '{print $1}' /etc/passwd

# Multiple separators
awk -F'[:,]' '{print $1}' file.txt

# Set output field separator
awk -F: -v OFS='|' '{print $1,$3}' /etc/passwd
```

### Calculations and Aggregations

```bash
# Sum of column
awk '{sum += $2} END {print sum}' file.txt

# Average
awk '{sum += $2; count++} END {print sum/count}' file.txt

# Count lines
awk 'END {print NR}' file.txt

# Count matches
awk '/pattern/ {count++} END {print count}' file.txt

# Min and Max
awk 'NR==1 {max=$1; min=$1} $1>max {max=$1} $1<min {min=$1} END {print "Min:", min, "Max:", max}' file.txt
```

### Advanced awk

```bash
# BEGIN and END blocks
awk 'BEGIN {print "Report"} {print} END {print "Total:", NR}' file.txt

# Multiple actions
awk '{total += $2; count++} END {print "Total:", total, "Average:", total/count}' file.txt

# Arrays
awk '{count[$1]++} END {for (item in count) print item, count[item]}' file.txt

# Conditional printing
awk '{if ($2 > 100) print $1, "High"; else print $1, "Normal"}' file.txt

# Format output
awk '{printf "%-10s %5d\n", $1, $2}' file.txt

# String functions
awk '{print toupper($1)}' file.txt
awk '{print length($1)}' file.txt
awk '{print substr($1, 1, 3)}' file.txt
```

### Practical Examples

```bash
# Extract usernames from /etc/passwd
awk -F: '{print $1}' /etc/passwd

# Sum of file sizes
ls -l | awk '{total += $5} END {print "Total:", total}'

# Average of numbers in column
awk '{sum += $1; n++} END {print sum/n}' numbers.txt

# CSV processing
awk -F, '{print $1, $3}' data.csv

# Count unique values
awk '{count[$1]++} END {for (i in count) print i, count[i]}' data.txt

# Filter and format
awk '$3 > 100 {printf "%s\t%d\n", $1, $3}' data.txt

# Print specific lines
awk 'NR==5,NR==10 {print}' file.txt

# Multiple field separators
awk -F'[,:]' '{print $1, $2}' mixed.txt

# Group by and sum
awk '{sum[$1] += $2} END {for (key in sum) print key, sum[key]}' data.txt
```

---

## sort and uniq

### sort - Sort Lines

```bash
# Sort alphabetically
sort file.txt

# Sort numerically
sort -n numbers.txt

# Reverse sort
sort -r file.txt

# Sort by specific column
sort -k2 file.txt           # Sort by 2nd column

# Sort numerically by column
sort -k2 -n file.txt

# Sort with custom delimiter
sort -t: -k3 -n /etc/passwd

# Remove duplicates while sorting
sort -u file.txt

# Case-insensitive sort
sort -f file.txt

# Sort by multiple columns
sort -k1,1 -k2,2n file.txt

# Sort by month
sort -M months.txt
```

### uniq - Report or Filter Duplicate Lines

**Note**: Input must be sorted first!

```bash
# Remove duplicate adjacent lines
sort file.txt | uniq

# Count occurrences
sort file.txt | uniq -c

# Show only duplicates
sort file.txt | uniq -d

# Show only unique lines
sort file.txt | uniq -u

# Ignore first N fields
sort file.txt | uniq -f 1

# Case-insensitive
sort file.txt | uniq -i
```

### Practical Examples

```bash
# Count unique IPs in log
awk '{print $1}' access.log | sort | uniq -c | sort -rn

# Top 10 most common entries
sort file.txt | uniq -c | sort -rn | head -10

# Find duplicates
sort file.txt | uniq -d

# Remove duplicates
sort -u file.txt

# Sort CSV by column
sort -t, -k3 -n data.csv
```

---

## cut and paste

### cut - Extract Sections from Lines

```bash
# Extract specific columns (delimiter: tab)
cut -f1,3 file.txt

# Extract columns with custom delimiter
cut -d: -f1,3 /etc/passwd

# Extract character positions
cut -c1-5 file.txt         # Characters 1-5
cut -c1,5,10 file.txt      # Characters 1, 5, and 10

# Extract from position to end
cut -c5- file.txt

# Multiple delimiters (with tr)
tr ',' '\t' < file.csv | cut -f1,2
```

### paste - Merge Lines

```bash
# Merge files side by side
paste file1.txt file2.txt

# Custom delimiter
paste -d: file1.txt file2.txt

# Serial mode (one file after another)
paste -s file.txt

# Combine with custom delimiter
paste -d, file1.txt file2.txt
```

### Practical Examples

```bash
# Extract first column from CSV
cut -d, -f1 data.csv

# Extract username and shell
cut -d: -f1,7 /etc/passwd

# First 20 characters of each line
cut -c1-20 file.txt

# Combine two columns
paste -d, names.txt ages.txt

# Create CSV from separate files
paste -d, col1.txt col2.txt col3.txt > output.csv
```

---

## tr - Translate Characters

```bash
# Convert lowercase to uppercase
tr 'a-z' 'A-Z' < file.txt

# Delete specific characters
tr -d '0-9' < file.txt

# Squeeze repeating characters
tr -s ' ' < file.txt        # Multiple spaces to single space

# Replace characters
tr ':' ',' < file.txt

# Delete all but specific characters
tr -cd '0-9\n' < file.txt   # Keep only digits and newlines

# Convert DOS to Unix line endings
tr -d '\r' < dosfile.txt > unixfile.txt

# ROT13 encoding
tr 'A-Za-z' 'N-ZA-Mn-za-m' < file.txt
```

### Practical Examples

```bash
# Remove all spaces
tr -d ' ' < file.txt

# Convert spaces to underscores
tr ' ' '_' < file.txt

# Remove non-printable characters
tr -cd '[:print:]\n' < file.txt

# Count words (convert spaces to newlines)
tr -s ' ' '\n' < file.txt | wc -l

# Create comma-separated from space-separated
tr -s ' ' ',' < file.txt
```

---

## wc - Word Count

```bash
# Count lines, words, and characters
wc file.txt

# Count lines only
wc -l file.txt

# Count words only
wc -w file.txt

# Count characters only
wc -c file.txt

# Count bytes
wc -c file.txt

# Multiple files
wc file1.txt file2.txt

# Count from pipe
ls | wc -l
```

---

## Capital Markets Use Case

### Scenario: Trading Log Analysis

```bash
# 1. Find all failed transactions
grep "FAILED" trading.log | wc -l

# 2. Extract unique error codes
grep "ERROR" trading.log | awk '{print $5}' | sort | uniq -c

# 3. Top 10 most active traders
awk '{print $3}' transactions.log | sort | uniq -c | sort -rn | head -10

# 4. Calculate total transaction amount
awk -F, '/SUCCESS/ {sum += $4} END {print "Total:", sum}' transactions.csv

# 5. Extract trades above threshold
awk -F, '$4 > 100000 {print $1, $2, $4}' trades.csv | sort -k3 -rn

# 6. Daily transaction summary
awk '{date=$1; count[date]++; sum[date]+=$4} END {for (d in count) print d, count[d], sum[d]}' | sort

# 7. Find duplicate transactions
cut -d, -f1,2,3 transactions.csv | sort | uniq -d

# 8. Convert CSV to pipe-delimited
tr ',' '|' < input.csv > output.txt

# 9. Extract failed trades with context
grep -A 3 -B 3 "FAILED" trading.log

# 10. Clean and format report
sed '/^#/d; /^$/d' raw_report.txt | awk '{print $1 "\t" $2}' | sort

# 11. Monitor real-time errors
tail -f trading.log | grep --line-buffered "ERROR"

# 12. Summarize by trader and status
awk -F, '{key=$2" "$3; count[key]++} END {for (k in count) print k, count[k]}' trades.csv | sort
```

---

## Best Practices

✅ Test patterns on small datasets first

✅ Use `grep -n` to see line numbers for debugging

✅ Chain simple commands with pipes rather than complex one-liners

✅ Save complex awk/sed scripts to files for reusability

✅ Use comments in awk scripts for maintainability

✅ Always sort before using uniq

✅ Use meaningful variable names in awk

---

## Quick Reference

| Command | Purpose | Example |
|---------|---------|---------|
| `grep` | Search patterns | `grep "error" file.txt` |
| `sed` | Stream editor | `sed 's/old/new/g' file.txt` |
| `awk` | Text processing | `awk '{print $1}' file.txt` |
| `sort` | Sort lines | `sort -n numbers.txt` |
| `uniq` | Filter duplicates | `sort file.txt \| uniq` |
| `cut` | Extract columns | `cut -d: -f1 /etc/passwd` |
| `paste` | Merge files | `paste file1 file2` |
| `tr` | Translate chars | `tr 'a-z' 'A-Z'` |
| `wc` | Count lines/words | `wc -l file.txt` |

---

## Reference Links

1. **GNU Grep Manual**: https://www.gnu.org/software/grep/manual/
2. **Sed Tutorial**: https://www.grymoire.com/Unix/Sed.html
3. **Awk Tutorial**: https://www.grymoire.com/Unix/Awk.html
4. **Regex101**: https://regex101.com/ - Test regular expressions
5. **RegexOne**: https://regexone.com/ - Learn regex interactively

---

**Next Document**: `04-Advanced-Unix-Commands.md`

