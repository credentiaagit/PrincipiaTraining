# Functions and Advanced Shell Scripting

## Table of Contents
1. [Functions](#functions)
2. [Error Handling](#error-handling)
3. [Debugging](#debugging)
4. [Arrays](#arrays)
5. [String Manipulation](#string-manipulation)
6. [Regular Expressions](#regular-expressions)
7. [Advanced I/O](#advanced-io)
8. [Best Practices](#best-practices)

---

## Functions

### Defining Functions

**Method 1:**
```bash
function_name() {
    # commands
}
```

**Method 2:**
```bash
function function_name {
    # commands
}
```

**Examples:**
```bash
#!/bin/bash

# Simple function
greet() {
    echo "Hello, World!"
}

# Call function
greet
```

### Function Parameters
```bash
#!/bin/bash

greet_user() {
    local name=$1
    local age=$2
    echo "Hello, $name! You are $age years old."
}

# Call with arguments
greet_user "John" 25
```

### Return Values
```bash
#!/bin/bash

# Return exit status (0-255)
is_even() {
    local num=$1
    if [ $((num % 2)) -eq 0 ]; then
        return 0  # true
    else
        return 1  # false
    fi
}

# Check return value
if is_even 4; then
    echo "Even number"
else
    echo "Odd number"
fi

# Return string via echo
get_timestamp() {
    echo $(date +%Y%m%d_%H%M%S)
}

# Capture output
timestamp=$(get_timestamp)
echo "Timestamp: $timestamp"
```

### Local vs Global Variables
```bash
#!/bin/bash

global_var="I am global"

my_function() {
    local local_var="I am local"
    global_var="Modified global"  # Modifies global
    
    echo "Inside: $local_var"
    echo "Inside: $global_var"
}

my_function

echo "Outside: $global_var"       # Modified
# echo "Outside: $local_var"      # Error: not defined
```

### Function Libraries
```bash
# lib/common.sh
log_info() {
    echo "[INFO] $(date): $1"
}

log_error() {
    echo "[ERROR] $(date): $1" >&2
}

# main.sh
#!/bin/bash
source ./lib/common.sh

log_info "Starting process"
log_error "An error occurred"
```

---

## Error Handling

### Exit Status
```bash
# Check exit status
command
if [ $? -eq 0 ]; then
    echo "Success"
else
    echo "Failed"
fi

# Or directly
if command; then
    echo "Success"
else
    echo "Failed"
fi
```

### Exit Command
```bash
#!/bin/bash

# Exit with status code
if [ ! -f "required.txt" ]; then
    echo "ERROR: Required file not found"
    exit 1
fi

# Exit codes:
# 0 = Success
# 1-255 = Error codes
```

### trap Command
```bash
#!/bin/bash

# Cleanup on exit
cleanup() {
    echo "Cleaning up..."
    rm -f /tmp/tempfile_$$
}

trap cleanup EXIT

# Create temp file
echo "data" > /tmp/tempfile_$$

# Script continues...
# cleanup() will run on exit
```

**Common Signals:**
```bash
trap 'cleanup' EXIT       # On script exit
trap 'cleanup' INT        # On Ctrl+C
trap 'cleanup' TERM       # On terminate signal
trap 'cleanup' ERR        # On error
```

### set Options
```bash
#!/bin/bash

set -e  # Exit on error
set -u  # Exit on undefined variable
set -o pipefail  # Exit on pipe failure
set -x  # Debug mode (print commands)

# Combined
set -euo pipefail

# Example
command1 || { echo "Command1 failed"; exit 1; }
command2 || { echo "Command2 failed"; exit 1; }
```

### Error Logging
```bash
#!/bin/bash

LOGFILE="/var/log/script.log"

log_error() {
    echo "[ERROR] $(date '+%Y-%m-%d %H:%M:%S'): $1" >> "$LOGFILE"
    echo "[ERROR] $1" >&2
}

if [ ! -f "data.txt" ]; then
    log_error "Data file not found"
    exit 1
fi
```

---

## Debugging

### Debug Mode
```bash
#!/bin/bash -x
# Prints each command before executing

# Or enable in script
set -x  # Enable debug
# commands here
set +x  # Disable debug
```

### Verbose Mode
```bash
#!/bin/bash -v
# Prints commands as read (before substitution)
```

### PS4 Variable
```bash
#!/bin/bash
export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
set -x

# Shows file, line, and function name
```

### Debugging Functions
```bash
#!/bin/bash

debug() {
    if [ "$DEBUG" = "true" ]; then
        echo "[DEBUG] $1" >&2
    fi
}

DEBUG=true
debug "Starting process"
```

---

## Arrays

### Indexed Arrays
```bash
#!/bin/bash

# Create array
fruits=("apple" "banana" "orange")

# Access elements
echo ${fruits[0]}       # apple
echo ${fruits[1]}       # banana

# All elements
echo ${fruits[@]}       # All elements
echo ${fruits[*]}       # All elements

# Array length
echo ${#fruits[@]}      # 3

# Indices
echo ${!fruits[@]}      # 0 1 2

# Add element
fruits+=("grape")

# Iterate
for fruit in "${fruits[@]}"; do
    echo $fruit
done

# With indices
for i in "${!fruits[@]}"; do
    echo "$i: ${fruits[$i]}"
done
```

### Associative Arrays
```bash
#!/bin/bash

# Declare associative array
declare -A prices

# Add elements
prices[apple]=1.50
prices[banana]=0.80
prices[orange]=1.20

# Access
echo ${prices[apple]}

# All keys
echo ${!prices[@]}

# All values
echo ${prices[@]}

# Iterate
for fruit in "${!prices[@]}"; do
    echo "$fruit: \$${prices[$fruit]}"
done

# Check if key exists
if [ -n "${prices[grape]}" ]; then
    echo "Grape price: ${prices[grape]}"
else
    echo "Grape not found"
fi
```

### Array Operations
```bash
#!/bin/bash

# Create array
numbers=(1 2 3 4 5)

# Slice array
echo ${numbers[@]:1:3}     # 2 3 4 (start:length)

# Replace elements
numbers[2]=10
echo ${numbers[@]}         # 1 2 10 4 5

# Append
numbers+=(6 7)
echo ${numbers[@]}         # 1 2 10 4 5 6 7

# Delete element
unset numbers[2]

# Copy array
new_numbers=("${numbers[@]}")

# Sort array
sorted=($(printf '%s\n' "${numbers[@]}" | sort -n))
```

---

## String Manipulation

### String Length
```bash
string="Hello, World!"
echo ${#string}           # 13
```

### Substrings
```bash
string="Hello, World!"
echo ${string:0:5}        # Hello (start:length)
echo ${string:7}          # World! (from position 7)
echo ${string:(-6)}       # World! (last 6 chars)
```

### String Replacement
```bash
string="Hello, World!"
echo ${string/World/Universe}    # Replace first
echo ${string//l/L}              # Replace all

# Remove patterns
filename="report.txt"
echo ${filename%.txt}             # report (remove suffix)
echo ${filename#report.}          # txt (remove prefix)
```

### Case Conversion
```bash
string="Hello World"
echo ${string^^}          # HELLO WORLD (uppercase)
echo ${string,,}          # hello world (lowercase)
echo ${string^}           # Hello World (first char uppercase)
```

### String Concatenation
```bash
first="Hello"
last="World"
full="$first $last"      # Hello World
full="${first}, ${last}" # Hello, World
```

---

## Regular Expressions

### Pattern Matching with =~
```bash
#!/bin/bash

email="user@example.com"

if [[ $email =~ ^[a-zA-Z0-9.]+@[a-zA-Z0-9.]+\.[a-zA-Z]{2,}$ ]]; then
    echo "Valid email"
else
    echo "Invalid email"
fi

# Extract matches
string="Price: $100.50"
if [[ $string =~ \$([0-9]+\.[0-9]{2}) ]]; then
    echo "Amount: ${BASH_REMATCH[1]}"  # 100.50
fi
```

### Pattern Matching in Case
```bash
#!/bin/bash

case $filename in
    *.txt)
        echo "Text file"
        ;;
    [0-9]*.log)
        echo "Log file starting with number"
        ;;
    *report*)
        echo "Report file"
        ;;
esac
```

---

## Advanced I/O

### Here Documents
```bash
#!/bin/bash

# Basic here document
cat << EOF
Line 1
Line 2
Variables: $HOME
EOF

# Suppress variable expansion
cat << 'EOF'
Variable: $HOME  (not expanded)
EOF

# Redirect to file
cat > file.txt << EOF
Line 1
Line 2
EOF

# Indent with <<-
cat <<- EOF
    This text
    is indented
EOF
```

### Here Strings
```bash
#!/bin/bash

# Pass string to command
grep "pattern" <<< "string to search"

# Multiple lines
cat <<< "
Line 1
Line 2
"
```

### Process Substitution
```bash
#!/bin/bash

# Compare output of two commands
diff <(ls dir1) <(ls dir2)

# Read multiple files
while read line; do
    echo $line
done < <(cat file1.txt file2.txt)

# Use command output as file
cat <(echo "Header") file.txt <(echo "Footer")
```

### File Descriptors
```bash
#!/bin/bash

# Redirect stderr to stdout
command 2>&1

# Redirect both to file
command &> output.txt

# Redirect stdout and stderr separately
command > stdout.txt 2> stderr.txt

# Append
command >> output.txt 2>&1

# Redirect to /dev/null (discard)
command > /dev/null 2>&1

# Custom file descriptor
exec 3> custom.log
echo "Message" >&3
exec 3>&-  # Close
```

---

## Best Practices

### Script Template
```bash
#!/bin/bash
#
# Script: script_name.sh
# Description: Purpose of script
# Author: Your Name
# Date: YYYY-MM-DD
# Version: 1.0
#
# Usage: ./script_name.sh [options] <arguments>
#

set -euo pipefail  # Exit on error, undefined var, pipe failure

# Constants
readonly SCRIPT_NAME=$(basename "$0")
readonly SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
readonly LOG_FILE="/var/log/${SCRIPT_NAME%.sh}.log"

# Global variables
VERBOSE=false
DRY_RUN=false

# Functions
usage() {
    cat << EOF
Usage: $SCRIPT_NAME [OPTIONS] <arguments>

Options:
    -h, --help      Show this help message
    -v, --verbose   Enable verbose output
    -n, --dry-run   Dry run mode
    
Examples:
    $SCRIPT_NAME file.txt
    $SCRIPT_NAME -v file.txt
EOF
}

log_info() {
    echo "[INFO] $(date '+%Y-%m-%d %H:%M:%S'): $1" | tee -a "$LOG_FILE"
}

log_error() {
    echo "[ERROR] $(date '+%Y-%m-%d %H:%M:%S'): $1" | tee -a "$LOG_FILE" >&2
}

cleanup() {
    # Cleanup code
    log_info "Cleanup completed"
}

trap cleanup EXIT

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            usage
            exit 0
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -n|--dry-run)
            DRY_RUN=true
            shift
            ;;
        *)
            FILENAME="$1"
            shift
            ;;
    esac
done

# Validate arguments
if [ -z "${FILENAME:-}" ]; then
    log_error "Missing required argument"
    usage
    exit 1
fi

# Main logic
main() {
    log_info "Starting $SCRIPT_NAME"
    
    # Your code here
    
    log_info "Completed successfully"
}

# Run main function
main "$@"
```

### Code Style
```bash
# Use meaningful names
TRADE_DATE=$(date +%Y%m%d)  # Not: d=$(date +%Y%m%d)

# Quote variables
rm "$file"  # Not: rm $file

# Use [[ ]] instead of [ ]
if [[ $var == "value" ]]; then  # Preferred

# Use functions for reusable code
process_file() {
    local file=$1
    # Process logic
}

# Check exit status
if ! command; then
    echo "Command failed"
    exit 1
fi

# Use || and && for simple conditions
command || { echo "Failed"; exit 1; }
command && echo "Success"
```

---

## Capital Markets Examples

### Example 1: Trade File Processor
```bash
#!/bin/bash

process_trade_file() {
    local input_file=$1
    local output_file=$2
    local errors=0
    
    log_info "Processing: $input_file"
    
    # Validate
    if [ ! -f "$input_file" ]; then
        log_error "File not found: $input_file"
        return 1
    fi
    
    # Process
    awk -F',' 'NR>1 {
        # Calculate value
        value = $3 * $4
        print $0 "," value
    }' "$input_file" > "$output_file"
    
    log_info "Processed $(wc -l < "$output_file") records"
    return 0
}

# Main
log_info "Starting trade processing"
if process_trade_file "trades.csv" "processed.csv"; then
    log_info "Success"
else
    log_error "Processing failed"
    exit 1
fi
```

### Example 2: End-of-Day Automation
```bash
#!/bin/bash

EOD_TASKS=(
    "collect_data"
    "reconcile_trades"
    "calculate_positions"
    "generate_reports"
    "archive_data"
    "send_notifications"
)

execute_task() {
    local task=$1
    log_info "Executing: $task"
    
    case $task in
        collect_data)
            # Collection logic
            ;;
        reconcile_trades)
            # Reconciliation logic
            ;;
        *)
            log_error "Unknown task: $task"
            return 1
            ;;
    esac
    
    return 0
}

# Execute all tasks
for task in "${EOD_TASKS[@]}"; do
    if ! execute_task "$task"; then
        log_error "Task failed: $task"
        exit 1
    fi
done

log_info "All EOD tasks completed"
```

---

## Reference Links

1. **Advanced Bash-Scripting Guide**: https://tldp.org/LDP/abs/html/
2. **Bash Hackers Wiki**: https://wiki.bash-hackers.org/
3. **ShellCheck**: https://www.shellcheck.net/ - Script analyzer
4. **Google Shell Style Guide**: https://google.github.io/styleguide/shellguide.html

---

**This completes Shell Scripting Theory!**

Next: Review sample programs and complete exercises.

