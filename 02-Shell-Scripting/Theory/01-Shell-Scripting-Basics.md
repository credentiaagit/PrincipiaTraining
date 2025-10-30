# Shell Scripting Basics

## Table of Contents
1. [Introduction to Shell Scripting](#introduction-to-shell-scripting)
2. [First Shell Script](#first-shell-script)
3. [Variables](#variables)
4. [User Input](#user-input)
5. [Command-Line Arguments](#command-line-arguments)
6. [Arithmetic Operations](#arithmetic-operations)
7. [Quotes and Special Characters](#quotes-and-special-characters)

---

## Introduction to Shell Scripting

### What is a Shell Script?
A shell script is a text file containing a series of commands that the shell can execute. It automates repetitive tasks and combines multiple commands into a single program.

### Why Shell Scripting?
- **Automation**: Automate repetitive tasks
- **System Administration**: Manage systems efficiently
- **Integration**: Combine multiple tools and commands
- **Rapid Development**: Quick to write and test
- **Portability**: Runs on any Unix/Linux system
- **No Compilation**: Interpreted, not compiled

### Common Shells
- **bash** (Bourne Again Shell) - Most popular, default on Linux
- **sh** (Bourne Shell) - Original Unix shell
- **ksh** (Korn Shell) - Popular in enterprises
- **zsh** (Z Shell) - Advanced features, macOS default
- **csh/tcsh** (C Shell) - C-like syntax

### When to Use Shell Scripts
✅ System administration tasks
✅ File manipulation and processing
✅ Batch processing
✅ Simple automation
✅ Wrapper scripts
✅ System monitoring

❌ Complex data structures (use Python/Perl)
❌ Heavy computation (use compiled languages)
❌ GUI applications
❌ Complex algorithms

---

## First Shell Script

### Creating a Script

**1. Create the file:**
```bash
vi hello.sh
# or
nano hello.sh
```

**2. Add shebang and content:**
```bash
#!/bin/bash
# My first shell script

echo "Hello, World!"
echo "Today is $(date)"
echo "Current user: $USER"
```

**3. Make executable:**
```bash
chmod +x hello.sh
```

**4. Run the script:**
```bash
./hello.sh
# or
bash hello.sh
```

### Understanding Shebang (#!)
The shebang (`#!`) tells the system which interpreter to use:

```bash
#!/bin/bash          # Use bash shell
#!/bin/sh            # Use sh shell
#!/usr/bin/env bash  # Find bash in PATH (more portable)
#!/usr/bin/python3   # Use Python 3
```

### Comments
```bash
# This is a single-line comment

# Multiple line comments:
# Line 1
# Line 2
# Line 3

: '
This is a multi-line comment
using a here document
'
```

### Basic Script Structure
```bash
#!/bin/bash
#
# Script: script_name.sh
# Description: What this script does
# Author: Your Name
# Date: 2024-10-28
#
# Usage: ./script_name.sh [arguments]
#

# Global variables
VARIABLE_NAME="value"

# Functions
function_name() {
    # Function code
}

# Main script logic
main() {
    # Main code here
}

# Call main function
main "$@"
```

---

## Variables

### Defining Variables
```bash
# No spaces around =
name="John"
age=25
salary=50000.50

# Using command output
current_date=$(date +%Y%m%d)
file_count=$(ls | wc -l)

# Using backticks (old style, avoid)
current_dir=`pwd`
```

### Using Variables
```bash
name="Alice"

# Basic usage
echo $name

# Recommended: use braces
echo ${name}

# Concatenation
full_name="${name} Smith"
echo $full_name

# In strings
echo "Hello, $name!"
echo "Hello, ${name}!"
```

### Variable Types

**1. String Variables:**
```bash
first_name="John"
last_name="Doe"
full_name="$first_name $last_name"
```

**2. Numeric Variables:**
```bash
count=10
price=99.99
```

**3. Array Variables:**
```bash
# Indexed arrays
fruits=("apple" "banana" "orange")
echo ${fruits[0]}        # apple
echo ${fruits[@]}        # All elements
echo ${#fruits[@]}       # Array length

# Associative arrays (bash 4+)
declare -A prices
prices[apple]=1.50
prices[banana]=0.80
echo ${prices[apple]}
```

### Special Variables

Shell scripting has several special variables (also called positional parameters and special parameters) that provide important information about the script and its execution.

#### Positional Parameters

**What are Positional Parameters?**
Variables that hold the arguments passed to the script or function.

```bash
$0      # Script name (the command used to invoke the script)
$1      # First argument
$2      # Second argument
$3      # Third argument
...     # And so on
$9      # Ninth argument
${10}   # Tenth argument (use braces for numbers > 9)
${11}   # Eleventh argument
```

**Example:**
```bash
#!/bin/bash
# Script: process_trade.sh

echo "Script name: $0"
echo "Trade ID: $1"
echo "Symbol: $2"
echo "Quantity: $3"

# Usage: ./process_trade.sh T001 AAPL 100
# Output:
# Script name: ./process_trade.sh
# Trade ID: T001
# Symbol: AAPL
# Quantity: 100
```

#### $# - Argument Count

**What is $#?**
Contains the number of arguments passed to the script (excluding $0).

**Why use it?**
- Validate required arguments
- Check if script called correctly
- Loop through all arguments

```bash
#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Error: No arguments provided"
    echo "Usage: $0 <file1> <file2> ..."
    exit 1
fi

echo "Number of files to process: $#"
```

**Example:**
```bash
$ ./script.sh file1.txt file2.txt file3.txt
Number of files to process: 3
```

#### $@ and $* - All Arguments

**What are $@ and $*?**
Both represent all positional parameters, but they behave differently when quoted.

**$@ (Recommended)**
- When quoted ("$@"), expands to separate words
- Preserves arguments as individual entities
- Better for passing arguments to other commands

**$***
- When quoted ("$*"), expands to single word with arguments joined
- All arguments become one string
- Uses IFS (Internal Field Separator) to join

```bash
#!/bin/bash
# Demonstrating $@ vs $*

function show_args_at() {
    echo "Using \$@:"
    for arg in "$@"; do
        echo "  Argument: [$arg]"
    done
}

function show_args_star() {
    echo "Using \$*:"
    for arg in "$*"; do
        echo "  Argument: [$arg]"
    done
}

show_args_at "arg 1" "arg 2" "arg 3"
echo ""
show_args_star "arg 1" "arg 2" "arg 3"

# Output:
# Using $@:
#   Argument: [arg 1]
#   Argument: [arg 2]
#   Argument: [arg 3]
#
# Using $*:
#   Argument: [arg 1 arg 2 arg 3]  # All joined together!
```

**Best Practice**: Use "$@" (with quotes) when passing arguments to other commands.

```bash
# Good - preserves individual arguments
process_files "$@"

# Avoid - treats all arguments as one
process_files "$*"
```

#### $? - Exit Status

**What is $??**
Contains the exit status (return code) of the last executed command.

**Exit Status Values:**
- `0` = Success
- `1-255` = Failure (specific error codes)

**Why use it?**
- Check if command succeeded
- Error handling
- Conditional execution

```bash
#!/bin/bash

# Execute command
grep "ERROR" logfile.txt

# Check if it succeeded
if [ $? -eq 0 ]; then
    echo "Errors found in log file"
else
    echo "No errors found"
fi

# Alternative: directly in if statement (preferred)
if grep "ERROR" logfile.txt; then
    echo "Errors found"
fi
```

**Setting Exit Status:**
```bash
#!/bin/bash

function validate_file() {
    if [ ! -f "$1" ]; then
        echo "Error: File not found"
        return 1    # Return error code
    fi
    return 0        # Return success
}

validate_file "data.txt"
if [ $? -eq 0 ]; then
    echo "File validation passed"
fi

# Exit script with specific code
exit 0  # Success
# or
exit 1  # Failure
```

#### $$ - Process ID

**What is $$?**
Contains the Process ID (PID) of the current shell script.

**Why use it?**
- Create unique temporary files
- Create lock files
- Logging and debugging
- Process identification

```bash
#!/bin/bash

# Create unique temporary file
TEMP_FILE="/tmp/process_$$_data.tmp"
echo "data" > "$TEMP_FILE"

echo "My Process ID: $$"
echo "Temp file: $TEMP_FILE"

# Cleanup
rm -f "$TEMP_FILE"

# Example output:
# My Process ID: 12345
# Temp file: /tmp/process_12345_data.tmp
```

**Capital Markets Use Case:**
```bash
#!/bin/bash
# Trading data processor

# Create unique log file for this run
LOG_FILE="/var/log/trading/trade_processor_$$.log"

echo "$(date): Starting trade processing" >> "$LOG_FILE"
echo "Process ID: $$" >> "$LOG_FILE"

# Process trades...

echo "$(date): Completed" >> "$LOG_FILE"
```

#### $! - Background Process ID

**What is $!?**
Contains the Process ID of the last command executed in the background.

**Why use it?**
- Monitor background jobs
- Kill specific background process
- Wait for background process
- Process management

```bash
#!/bin/bash

# Start background process
long_running_task &

# Save its PID
BACKGROUND_PID=$!

echo "Background process started with PID: $BACKGROUND_PID"

# Do other work...
echo "Doing other work..."
sleep 2

# Check if background process still running
if kill -0 $BACKGROUND_PID 2>/dev/null; then
    echo "Background process still running"
else
    echo "Background process completed"
fi

# Wait for background process to finish
wait $BACKGROUND_PID
echo "Background process exit status: $?"
```

**Example with Multiple Background Jobs:**
```bash
#!/bin/bash

# Start multiple processes
process_region_A &
PID_A=$!

process_region_B &
PID_B=$!

process_region_C &
PID_C=$!

echo "Started processes: $PID_A, $PID_B, $PID_C"

# Wait for all to complete
wait $PID_A $PID_B $PID_C
echo "All processes completed"
```

#### $_ - Last Argument

**What is $_?**
Contains the last argument of the previous command.

**Why use it?**
- Avoid retyping arguments
- Quick reference to last parameter
- Command-line productivity

```bash
# Create directory and immediately cd into it
mkdir /opt/trading/new_project
cd $_  # cd /opt/trading/new_project

# Copy file and then edit it
cp template.txt newfile.txt
vim $_  # vim newfile.txt
```

**In Scripts:**
```bash
#!/bin/bash

function process_file() {
    echo "Processing: $1"
    # After function, $_ contains $1
}

process_file "data.txt"
echo "Last argument was: $_"  # Prints: data.txt
```

#### Special Variables Summary Table

| Variable | Name | Meaning | Example Usage |
|----------|------|---------|---------------|
| `$0` | Script Name | Name of the script | `echo "Running: $0"` |
| `$1-$9` | Positional Args | Arguments 1-9 | `file=$1` |
| `${10+}` | Higher Args | Arguments 10+ | `value=${10}` |
| `$#` | Arg Count | Number of arguments | `if [ $# -eq 0 ]` |
| `$@` | All Args (separate) | All arguments as separate words | `process "$@"` |
| `$*` | All Args (single) | All arguments as one word | Rarely used |
| `$?` | Exit Status | Return code of last command | `if [ $? -eq 0 ]` |
| `$$` | Process ID | PID of current script | `tempfile=/tmp/data_$$` |
| `$!` | Background PID | PID of last background job | `kill $!` |
| `$_` | Last Argument | Last arg of previous command | `cd $_` |

#### Complete Example: Using Special Variables

```bash
#!/bin/bash
#################################################################
# Script: process_trades.sh
# Purpose: Demonstrate all special variables
# Usage: ./process_trades.sh trade1.csv trade2.csv
#################################################################

# Script name
echo "Script: $0"
echo "Process ID: $$"
echo ""

# Check arguments
if [ $# -eq 0 ]; then
    echo "Error: No input files provided"
    echo "Usage: $0 <file1> <file2> ..."
    exit 1
fi

echo "Number of files to process: $#"
echo "Files: $@"
echo ""

# Create temporary directory with unique name
TEMP_DIR="/tmp/trading_$$"
mkdir -p "$TEMP_DIR"
echo "Created temp directory: $TEMP_DIR"

# Process each file
for file in "$@"; do
    echo "Processing: $file"
    
    if [ ! -f "$file" ]; then
        echo "  Warning: File not found"
        continue
    fi
    
    # Simulate processing in background
    (sleep 2 && echo "  Completed: $file") &
    
    # Store background PID
    LAST_PID=$!
    echo "  Started background process: $LAST_PID"
done

# Wait for all background processes
wait
echo ""
echo "All background processes completed (exit status: $?)"

# Cleanup
rm -rf "$TEMP_DIR"
echo "Cleaned up temp directory"

# Exit successfully
exit 0
```

**Running the example:**
```bash
$ ./process_trades.sh trade1.csv trade2.csv
Script: ./process_trades.sh
Process ID: 54321

Number of files to process: 2
Files: trade1.csv trade2.csv

Created temp directory: /tmp/trading_54321
Processing: trade1.csv
  Started background process: 54322
Processing: trade2.csv
  Started background process: 54323
  Completed: trade1.csv
  Completed: trade2.csv

All background processes completed (exit status: 0)
Cleaned up temp directory
```

#### Best Practices with Special Variables

✅ **DO**:
- Always quote "$@" when passing arguments
- Check $# before accessing positional parameters
- Use $$ for unique temporary filenames
- Save $! immediately after starting background job
- Check $? after critical commands

❌ **DON'T**:
- Don't use $* unless specifically needed
- Don't assume $1, $2 exist without checking $#
- Don't forget to quote variables: use "$1" not $1
- Don't use $_ in scripts (it's mainly for interactive shells)

### Environment Variables
```bash
# Common environment variables
echo $HOME          # Home directory
echo $USER          # Current username
echo $PATH          # Executable search path
echo $PWD           # Present working directory
echo $SHELL         # Current shell
echo $HOSTNAME      # Machine hostname

# Setting environment variables
export VAR_NAME="value"

# Checking if variable exists
if [ -z "$VAR" ]; then
    echo "Variable not set"
fi
```

### Variable Scope
```bash
#!/bin/bash

# Global variable
global_var="I am global"

my_function() {
    # Local variable
    local local_var="I am local"
    echo "Inside function: $local_var"
    echo "Inside function: $global_var"
}

my_function
echo "Outside function: $global_var"
# echo "Outside function: $local_var"  # Error: not defined
```

---

## User Input

### Reading Input

**Basic input:**
```bash
#!/bin/bash

echo "Enter your name:"
read name
echo "Hello, $name!"
```

**Prompt on same line:**
```bash
read -p "Enter your age: " age
echo "You are $age years old"
```

**Silent input (for passwords):**
```bash
read -sp "Enter password: " password
echo ""
echo "Password received"
```

**Multiple inputs:**
```bash
read -p "Enter first and last name: " first last
echo "First: $first, Last: $last"
```

**With timeout:**
```bash
if read -t 5 -p "Enter name (5 sec timeout): " name; then
    echo "Hello, $name"
else
    echo "Timeout!"
fi
```

**Reading into array:**
```bash
echo "Enter three numbers:"
read -a numbers
echo "First: ${numbers[0]}"
echo "Second: ${numbers[1]}"
echo "Third: ${numbers[2]}"
```

### Reading from File
```bash
# Read line by line
while read line; do
    echo "Line: $line"
done < file.txt

# Read with IFS (Internal Field Separator)
while IFS=: read -r user password uid gid name home shell; do
    echo "User: $user, Home: $home"
done < /etc/passwd
```

---

## Command-Line Arguments

### Basic Arguments
```bash
#!/bin/bash

echo "Script name: $0"
echo "First argument: $1"
echo "Second argument: $2"
echo "Number of arguments: $#"
echo "All arguments: $@"
```

**Usage:**
```bash
./script.sh arg1 arg2 arg3
```

### Processing Arguments
```bash
#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Usage: $0 <file1> <file2>"
    exit 1
fi

file1=$1
file2=$2

echo "Processing: $file1 and $file2"
```

### Shift Command
```bash
#!/bin/bash

while [ $# -gt 0 ]; do
    echo "Argument: $1"
    shift  # Move arguments left
done
```

### Processing Options
```bash
#!/bin/bash

while [ $# -gt 0 ]; do
    case "$1" in
        -h|--help)
            echo "Help message"
            exit 0
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -f|--file)
            FILE="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done
```

### Using getopts
```bash
#!/bin/bash

while getopts "hvf:" opt; do
    case $opt in
        h)
            echo "Help message"
            ;;
        v)
            VERBOSE=true
            ;;
        f)
            FILE="$OPTARG"
            ;;
        \?)
            echo "Invalid option: -$OPTARG"
            exit 1
            ;;
    esac
done
```

---

## Arithmetic Operations

### Using expr
```bash
sum=$(expr 10 + 5)
diff=$(expr 10 - 5)
prod=$(expr 10 \* 5)    # Note: escape *
quot=$(expr 10 / 5)
rem=$(expr 10 % 3)

echo "Sum: $sum"
```

### Using let
```bash
let sum=10+5
let "sum = 10 + 5"      # With spaces

let count++             # Increment
let count--             # Decrement
let count+=5            # Add 5
```

### Using (( ))
```bash
((sum = 10 + 5))
echo $sum

((count++))
((count += 5))

# Multiple operations
((a = 10, b = 20, c = a + b))

# Comparison
if ((count > 10)); then
    echo "Count is greater than 10"
fi
```

### Using $[ ]
```bash
sum=$[10 + 5]
diff=$[10 - 5]
echo "Sum: $sum, Diff: $diff"
```

### Using bc for Floating Point
```bash
# Basic calculation
result=$(echo "10.5 + 5.3" | bc)
echo $result

# With scale (decimal places)
result=$(echo "scale=2; 10 / 3" | bc)
echo $result

# Multiple operations
result=$(echo "
scale=2
a = 10.5
b = 3.2
a + b
" | bc)
echo $result

# Functions
result=$(echo "scale=2; sqrt(16)" | bc)
echo $result
```

### Arithmetic Operators
```bash
+    # Addition
-    # Subtraction
*    # Multiplication
/    # Division
%    # Modulo (remainder)
**   # Exponentiation (bash 4+)
++   # Increment
--   # Decrement
```

---

## Quotes and Special Characters

### Single Quotes ('')
```bash
# Literal string, no substitution
name="John"
echo 'Hello, $name'    # Output: Hello, $name
```

### Double Quotes ("")
```bash
# Variable substitution occurs
name="John"
echo "Hello, $name"    # Output: Hello, John
```

### No Quotes
```bash
# Word splitting and globbing occur
echo Hello    World    # Output: Hello World
echo *.txt            # Expands to matching files
```

### Escape Character (\)
```bash
echo "Price: \$100"                 # Output: Price: $100
echo "Path: C:\\Users\\John"        # Output: Path: C:\Users\John
echo "Line 1\nLine 2"               # Output: Line 1\nLine 2 (literal \n)
```

### Special Characters
```bash
*       # Wildcard (all files)
?       # Single character wildcard
[ ]     # Character class
;       # Command separator
&       # Background process
|       # Pipe
>       # Redirect output
<       # Redirect input
>>      # Append output
&&      # Logical AND
||      # Logical OR
!       # Logical NOT
~       # Home directory
#       # Comment
$       # Variable prefix
\       # Escape character
```

### Command Substitution
```bash
# Modern syntax (preferred)
current_date=$(date +%Y%m%d)
file_count=$(ls | wc -l)
content=$(cat file.txt)

# Old syntax (avoid)
current_date=`date +%Y%m%d`
```

---

## Capital Markets Use Case

### Trade Processing Script
```bash
#!/bin/bash
#
# Trade Processing Script
# Processes daily trade files
#

# Variables
TRADE_DATE=$(date +%Y%m%d)
DATA_DIR="/opt/trading/data"
INPUT_FILE="${DATA_DIR}/trades_${TRADE_DATE}.csv"
OUTPUT_FILE="${DATA_DIR}/processed_${TRADE_DATE}.csv"

# Display processing information
echo "=================================================="
echo "Trade Processing - $TRADE_DATE"
echo "=================================================="
echo "Input File: $INPUT_FILE"
echo "Output File: $OUTPUT_FILE"
echo ""

# Check if input file exists
if [ ! -f "$INPUT_FILE" ]; then
    echo "ERROR: Input file not found!"
    exit 1
fi

# Count trades
TRADE_COUNT=$(wc -l < "$INPUT_FILE")
echo "Total Trades: $TRADE_COUNT"

# Calculate total value
TOTAL_VALUE=$(awk -F',' 'NR>1 {sum+=$4*$5} END {print sum}' "$INPUT_FILE")
echo "Total Value: \$$TOTAL_VALUE"

# Process trades
echo ""
echo "Processing trades..."
# Processing logic here

echo "Complete!"
```

---

## Best Practices

✅ Always use shebang (`#!/bin/bash`)

✅ Add comments and documentation

✅ Use meaningful variable names

✅ Quote variables to handle spaces: `"$var"`

✅ Check command exit status

✅ Validate user input

✅ Use `local` for function variables

✅ Indent code for readability

✅ Use functions for reusable code

✅ Handle errors gracefully

---

## Common Pitfalls

❌ Spaces around `=` in variable assignment
```bash
# Wrong
name = "John"

# Correct
name="John"
```

❌ Not quoting variables
```bash
# Wrong (fails with spaces)
rm $file

# Correct
rm "$file"
```

❌ Forgetting to make script executable
```bash
chmod +x script.sh
```

❌ Not checking if file exists before operations

❌ Not validating user input

---

## Quick Reference

| Concept | Syntax | Example |
|---------|--------|---------|
| Variable | `var=value` | `name="John"` |
| Use variable | `$var` or `${var}` | `echo $name` |
| Command substitution | `$(command)` | `date=$(date)` |
| Read input | `read var` | `read name` |
| Arguments | `$1, $2, ...` | `file=$1` |
| All arguments | `$@` or `$*` | `echo $@` |
| Argument count | `$#` | `if [ $# -eq 0 ]` |
| Arithmetic | `$((expr))` | `sum=$((5+3))` |

---

## Practice Exercises

1. Create a script that asks for your name and age, then displays a greeting
2. Write a script that calculates the sum of two numbers provided as arguments
3. Create a script that backs up a file (provided as argument) with a timestamp
4. Write a script that counts files in current directory

---

## Reference Links

### 📚 Theory & Learning Resources

1. **Comprehensive Tutorials**:
   - [Shell Scripting Tutorial](https://www.shellscript.sh/) - Complete beginner to advanced guide
   - [Bash Guide for Beginners](https://tldp.org/LDP/Bash-Beginners-Guide/html/) - Structured learning path
   - [Advanced Bash-Scripting Guide](https://tldp.org/LDP/abs/html/) - In-depth reference (FREE)
   - [Bash Hackers Wiki](https://wiki.bash-hackers.org/) - Comprehensive wiki

2. **Official Documentation**:
   - [GNU Bash Reference Manual](https://www.gnu.org/software/bash/manual/) - Official manual
   - [Bash Man Page](https://man7.org/linux/man-pages/man1/bash.1.html) - Complete reference
   - [POSIX Shell Specification](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html)

3. **Best Practices**:
   - [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html) - Industry standards
   - [Bash Pitfalls](https://mywiki.wooledge.org/BashPitfalls) - Common mistakes to avoid

### 🎮 Hands-On Practice Resources

1. **Interactive Practice**:
   - [HackerRank - Bash Challenges](https://www.hackerrank.com/domains/shell) - Practice with instant feedback (FREE)
   - [Exercism - Bash Track](https://exercism.org/tracks/bash) - Mentored exercises (FREE)
   - [Command Challenge](https://cmdchallenge.com/) - Bash one-liner puzzles
   - [OverTheWire - Bandit](https://overthewire.org/wargames/bandit/) - Security challenges

2. **Online Environments**:
   - [Replit - Bash](https://replit.com/languages/bash) - Write and run scripts online
   - [JSLinux](https://bellard.org/jslinux/) - Full Linux in browser
   - [Tutorialspoint - Bash Terminal](https://www.tutorialspoint.com/execute_bash_online.php) - Quick testing

3. **Tools**:
   - [ShellCheck](https://www.shellcheck.net/) - Script analyzer (ESSENTIAL)
   - [ExplainShell](https://explainshell.com/) - Command explanation
   - [Bash Debugger](http://bashdb.sourceforge.net/) - Step-through debugger

---

**Next Document**: `02-Control-Structures.md`

