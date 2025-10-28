# Control Structures in Shell Scripting

## Table of Contents
1. [Conditional Statements](#conditional-statements)
2. [Test Operators](#test-operators)
3. [Case Statements](#case-statements)
4. [Loops](#loops)
5. [Loop Control](#loop-control)
6. [Practical Examples](#practical-examples)

---

## Conditional Statements

### if Statement

**Basic syntax:**
```bash
if [ condition ]; then
    # commands
fi
```

**Examples:**
```bash
#!/bin/bash

age=25

if [ $age -gt 18 ]; then
    echo "Adult"
fi
```

### if-else Statement
```bash
if [ condition ]; then
    # commands if true
else
    # commands if false
fi
```

**Example:**
```bash
#!/bin/bash

score=85

if [ $score -ge 60 ]; then
    echo "Pass"
else
    echo "Fail"
fi
```

### if-elif-else Statement
```bash
if [ condition1 ]; then
    # commands if condition1 is true
elif [ condition2 ]; then
    # commands if condition2 is true
else
    # commands if all conditions are false
fi
```

**Example:**
```bash
#!/bin/bash

score=85

if [ $score -ge 90 ]; then
    echo "Grade: A"
elif [ $score -ge 80 ]; then
    echo "Grade: B"
elif [ $score -ge 70 ]; then
    echo "Grade: C"
elif [ $score -ge 60 ]; then
    echo "Grade: D"
else
    echo "Grade: F"
fi
```

### Nested if Statements
```bash
if [ condition1 ]; then
    if [ condition2 ]; then
        # commands
    fi
fi
```

**Example:**
```bash
#!/bin/bash

age=25
has_license=true

if [ $age -ge 18 ]; then
    if [ "$has_license" = "true" ]; then
        echo "Can drive"
    else
        echo "Need license"
    fi
else
    echo "Too young to drive"
fi
```

---

## Test Operators

### File Test Operators
```bash
-e file     # File exists
-f file     # Regular file exists
-d file     # Directory exists
-s file     # File exists and not empty
-r file     # File is readable
-w file     # File is writable
-x file     # File is executable
-h file     # Symbolic link
-L file     # Symbolic link (same as -h)
-b file     # Block device
-c file     # Character device
-p file     # Named pipe
-S file     # Socket
```

**Examples:**
```bash
#!/bin/bash

file="data.txt"

if [ -f "$file" ]; then
    echo "File exists"
else
    echo "File does not exist"
fi

if [ -r "$file" ]; then
    echo "File is readable"
fi

if [ -w "$file" ]; then
    echo "File is writable"
fi

if [ -x "$file" ]; then
    echo "File is executable"
fi

if [ -s "$file" ]; then
    echo "File is not empty"
fi

# Check directory
dir="/opt/trading"
if [ -d "$dir" ]; then
    echo "Directory exists"
fi
```

### String Test Operators
```bash
-z string       # String is empty (zero length)
-n string       # String is not empty
string1 = string2    # Strings are equal
string1 != string2   # Strings are not equal
string1 < string2    # String1 is less than string2 (lexicographically)
string1 > string2    # String1 is greater than string2
```

**Examples:**
```bash
#!/bin/bash

name="John"
empty=""

# Check if empty
if [ -z "$empty" ]; then
    echo "String is empty"
fi

# Check if not empty
if [ -n "$name" ]; then
    echo "String is not empty"
fi

# String comparison
if [ "$name" = "John" ]; then
    echo "Name is John"
fi

if [ "$name" != "Mary" ]; then
    echo "Name is not Mary"
fi

# Lexicographic comparison
str1="apple"
str2="banana"
if [ "$str1" \< "$str2" ]; then  # Note: need to escape in []
    echo "$str1 comes before $str2"
fi
```

### Numeric Test Operators
```bash
-eq     # Equal to
-ne     # Not equal to
-gt     # Greater than
-ge     # Greater than or equal to
-lt     # Less than
-le     # Less than or equal to
```

**Examples:**
```bash
#!/bin/bash

num1=10
num2=20

if [ $num1 -eq $num2 ]; then
    echo "Equal"
fi

if [ $num1 -ne $num2 ]; then
    echo "Not equal"
fi

if [ $num1 -lt $num2 ]; then
    echo "$num1 is less than $num2"
fi

if [ $num1 -le $num2 ]; then
    echo "$num1 is less than or equal to $num2"
fi

if [ $num1 -gt 5 ]; then
    echo "$num1 is greater than 5"
fi
```

### Logical Operators
```bash
!           # NOT
-a          # AND (inside [ ])
-o          # OR (inside [ ])
&&          # AND (between [ ] tests)
||          # OR (between [ ] tests)
```

**Examples:**
```bash
#!/bin/bash

age=25
salary=50000

# NOT
if [ ! -f "file.txt" ]; then
    echo "File does not exist"
fi

# AND using -a
if [ $age -gt 18 -a $salary -gt 30000 ]; then
    echo "Eligible for loan"
fi

# AND using &&
if [ $age -gt 18 ] && [ $salary -gt 30000 ]; then
    echo "Eligible for loan"
fi

# OR using -o
if [ $age -lt 18 -o $age -gt 65 ]; then
    echo "Special category"
fi

# OR using ||
if [ $age -lt 18 ] || [ $age -gt 65 ]; then
    echo "Special category"
fi
```

### [[ ]] vs [ ]
```bash
# [ ] - POSIX compliant, works everywhere
# [[ ]] - Bash extended test, more features

# [[ ]] advantages:
# - Pattern matching
# - Regex matching
# - No need to quote variables
# - Logical operators: && and ||

if [[ $name == J* ]]; then        # Pattern matching
    echo "Name starts with J"
fi

if [[ $email =~ .*@.*\.com ]]; then   # Regex matching
    echo "Valid email pattern"
fi

if [[ $age -gt 18 && $age -lt 65 ]]; then   # && operator
    echo "Working age"
fi
```

---

## Case Statements

### Basic Syntax
```bash
case $variable in
    pattern1)
        # commands
        ;;
    pattern2)
        # commands
        ;;
    *)
        # default commands
        ;;
esac
```

### Simple Example
```bash
#!/bin/bash

read -p "Enter fruit name: " fruit

case $fruit in
    apple)
        echo "Red or green"
        ;;
    banana)
        echo "Yellow"
        ;;
    orange)
        echo "Orange color"
        ;;
    *)
        echo "Unknown fruit"
        ;;
esac
```

### Multiple Patterns
```bash
#!/bin/bash

read -p "Enter day: " day

case $day in
    Monday|monday|Mon|mon)
        echo "Start of week"
        ;;
    Friday|friday|Fri|fri)
        echo "End of work week"
        ;;
    Saturday|Sunday|saturday|sunday)
        echo "Weekend"
        ;;
    *)
        echo "Midweek"
        ;;
esac
```

### Pattern Matching
```bash
#!/bin/bash

file=$1

case $file in
    *.txt)
        echo "Text file"
        ;;
    *.pdf)
        echo "PDF file"
        ;;
    *.jpg|*.png|*.gif)
        echo "Image file"
        ;;
    [0-9]*)
        echo "Starts with number"
        ;;
    *)
        echo "Unknown type"
        ;;
esac
```

### Menu System
```bash
#!/bin/bash

while true; do
    echo ""
    echo "==== MENU ===="
    echo "1. List files"
    echo "2. Show date"
    echo "3. Show users"
    echo "4. Exit"
    echo "=============="
    read -p "Enter choice: " choice
    
    case $choice in
        1)
            ls -l
            ;;
        2)
            date
            ;;
        3)
            who
            ;;
        4)
            echo "Goodbye!"
            exit 0
            ;;
        *)
            echo "Invalid choice"
            ;;
    esac
done
```

---

## Loops

### for Loop

**Syntax 1: List of items**
```bash
for variable in list; do
    # commands
done
```

**Examples:**
```bash
#!/bin/bash

# Simple list
for fruit in apple banana orange; do
    echo "Fruit: $fruit"
done

# File names
for file in *.txt; do
    echo "Processing: $file"
done

# Command output
for user in $(cat users.txt); do
    echo "User: $user"
done

# Range
for i in {1..10}; do
    echo "Number: $i"
done

# Range with step
for i in {0..100..10}; do
    echo "$i"
done
```

**Syntax 2: C-style**
```bash
for ((initialization; condition; increment)); do
    # commands
done
```

**Examples:**
```bash
#!/bin/bash

# Simple counter
for ((i=1; i<=10; i++)); do
    echo "Count: $i"
done

# Reverse
for ((i=10; i>=1; i--)); do
    echo "Countdown: $i"
done

# Multiple variables
for ((i=1, j=10; i<=5; i++, j--)); do
    echo "i=$i, j=$j"
done
```

### while Loop
```bash
while [ condition ]; do
    # commands
done
```

**Examples:**
```bash
#!/bin/bash

# Counter
count=1
while [ $count -le 5 ]; do
    echo "Count: $count"
    ((count++))
done

# Reading file
while read line; do
    echo "Line: $line"
done < file.txt

# Infinite loop
while true; do
    echo "Press Ctrl+C to stop"
    sleep 1
done

# Until condition is true
count=1
while [ $count -le 5 ]; do
    echo $count
    ((count++))
done
```

### until Loop
```bash
until [ condition ]; do
    # commands (executed until condition becomes true)
done
```

**Examples:**
```bash
#!/bin/bash

# Counter (opposite of while)
count=1
until [ $count -gt 5 ]; do
    echo "Count: $count"
    ((count++))
done

# Wait for file
until [ -f "/tmp/done.txt" ]; do
    echo "Waiting for file..."
    sleep 5
done
echo "File found!"
```

### Reading Files with while
```bash
#!/bin/bash

# Method 1: Basic
while read line; do
    echo "Line: $line"
done < file.txt

# Method 2: With IFS
while IFS=: read -r user pass uid gid name home shell; do
    echo "User: $user, Home: $home"
done < /etc/passwd

# Method 3: With pipe
cat file.txt | while read line; do
    echo "Line: $line"
done
```

---

## Loop Control

### break Statement
```bash
#!/bin/bash

# Exit loop
for i in {1..10}; do
    if [ $i -eq 5 ]; then
        break  # Exit loop when i=5
    fi
    echo $i
done

# Break from nested loop
for i in {1..3}; do
    for j in {1..3}; do
        if [ $j -eq 2 ]; then
            break  # Break inner loop only
        fi
        echo "i=$i, j=$j"
    done
done
```

### continue Statement
```bash
#!/bin/bash

# Skip iteration
for i in {1..10}; do
    if [ $i -eq 5 ]; then
        continue  # Skip when i=5
    fi
    echo $i
done

# Skip even numbers
for i in {1..10}; do
    if [ $((i % 2)) -eq 0 ]; then
        continue
    fi
    echo "$i is odd"
done
```

---

## Practical Examples

### Example 1: File Processor
```bash
#!/bin/bash
# Process all CSV files in directory

DATA_DIR="/opt/trading/data"

for file in $DATA_DIR/*.csv; do
    if [ ! -f "$file" ]; then
        continue
    fi
    
    echo "Processing: $(basename $file)"
    
    line_count=$(wc -l < "$file")
    
    if [ $line_count -eq 0 ]; then
        echo "  WARNING: Empty file"
        continue
    fi
    
    echo "  Lines: $line_count"
    
    # Process file
    # ...
done
```

### Example 2: System Check
```bash
#!/bin/bash
# Check system resources

check_disk() {
    echo "Checking disk space..."
    for mount in / /opt /home; do
        usage=$(df -h $mount | tail -1 | awk '{print $5}' | sed 's/%//')
        
        if [ $usage -gt 90 ]; then
            echo "  CRITICAL: $mount is ${usage}% full"
        elif [ $usage -gt 80 ]; then
            echo "  WARNING: $mount is ${usage}% full"
        else
            echo "  OK: $mount is ${usage}% full"
        fi
    done
}

check_services() {
    echo ""
    echo "Checking services..."
    
    services=("sshd" "cron")
    
    for service in "${services[@]}"; do
        if pgrep -x "$service" > /dev/null; then
            echo "  ✓ $service is running"
        else
            echo "  ✗ $service is NOT running"
        fi
    done
}

check_disk
check_services
```

### Example 3: Trade Validator
```bash
#!/bin/bash
# Validate trade files

validate_trade_file() {
    local file=$1
    local errors=0
    
    # Check file exists
    if [ ! -f "$file" ]; then
        echo "ERROR: File not found"
        return 1
    fi
    
    # Check not empty
    if [ ! -s "$file" ]; then
        echo "ERROR: File is empty"
        return 1
    fi
    
    # Check header
    header=$(head -1 "$file")
    expected="TradeID,Symbol,Quantity,Price"
    
    if [ "$header" != "$expected" ]; then
        echo "ERROR: Invalid header"
        ((errors++))
    fi
    
    # Validate each line
    line_num=1
    while IFS=, read -r id symbol qty price; do
        ((line_num++))
        
        # Skip header
        if [ $line_num -eq 2 ]; then
            continue
        fi
        
        # Check quantity is number
        if ! [[ "$qty" =~ ^[0-9]+$ ]]; then
            echo "ERROR line $line_num: Invalid quantity"
            ((errors++))
        fi
        
        # Check price is number
        if ! [[ "$price" =~ ^[0-9]+\.?[0-9]*$ ]]; then
            echo "ERROR line $line_num: Invalid price"
            ((errors++))
        fi
    done < "$file"
    
    return $errors
}

# Usage
if validate_trade_file "trades.csv"; then
    echo "Validation PASSED"
else
    echo "Validation FAILED"
fi
```

### Example 4: Menu-Driven Application
```bash
#!/bin/bash
# Trading System Menu

while true; do
    clear
    echo "================================"
    echo "  TRADING SYSTEM"
    echo "================================"
    echo "1. Process Trades"
    echo "2. Generate Reports"
    echo "3. Archive Data"
    echo "4. System Status"
    echo "5. Exit"
    echo "================================"
    read -p "Enter choice [1-5]: " choice
    
    case $choice in
        1)
            echo "Processing trades..."
            # Process logic
            read -p "Press Enter to continue..."
            ;;
        2)
            echo "Generating reports..."
            # Report logic
            read -p "Press Enter to continue..."
            ;;
        3)
            echo "Archiving data..."
            # Archive logic
            read -p "Press Enter to continue..."
            ;;
        4)
            echo "System Status:"
            uptime
            df -h
            read -p "Press Enter to continue..."
            ;;
        5)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid choice!"
            read -p "Press Enter to continue..."
            ;;
    esac
done
```

---

## Best Practices

✅ Always quote variables in conditions: `[ "$var" = "value" ]`

✅ Use `[[ ]]` for complex conditions in Bash

✅ Check file existence before operations

✅ Use meaningful variable names in loops

✅ Add comments for complex logic

✅ Handle loop errors with continue/break

✅ Initialize counter variables

✅ Use appropriate loop type for the task

---

## Reference Links

1. **Bash Conditional Expressions**: https://www.gnu.org/software/bash/manual/html_node/Bash-Conditional-Expressions.html
2. **Bash Looping Constructs**: https://www.gnu.org/software/bash/manual/html_node/Looping-Constructs.html

---

**Next Document**: `03-Functions-and-Advanced-Topics.md`

