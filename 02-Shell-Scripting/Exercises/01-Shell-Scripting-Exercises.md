# Shell Scripting Exercises

## Level 1: Basic Scripts

### Exercise 1: Hello Script
**Task**: Create a script that:
1. Displays "Hello, World!"
2. Shows current date and time
3. Displays current user and home directory

**Answer**:
```bash
#!/bin/bash

echo "Hello, World!"
echo "Current date/time: $(date)"
echo "Current user: $USER"
echo "Home directory: $HOME"
```

---

### Exercise 2: Calculator Script
**Task**: Create a calculator script that:
1. Takes two numbers as command-line arguments
2. Performs addition, subtraction, multiplication, division
3. Displays all results

**Answer**:
```bash
#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Usage: $0 <num1> <num2>"
    exit 1
fi

num1=$1
num2=$2

echo "Number 1: $num1"
echo "Number 2: $num2"
echo "Addition: $((num1 + num2))"
echo "Subtraction: $((num1 - num2))"
echo "Multiplication: $((num1 * num2))"

if [ $num2 -ne 0 ]; then
    echo "Division: $(echo "scale=2; $num1 / $num2" | bc)"
else
    echo "Division: Cannot divide by zero"
fi
```

---

## Level 2: Control Structures

### Exercise 3: Grade Calculator
**Task**: Create a script that:
1. Reads a score (0-100)
2. Assigns grade: A(90+), B(80-89), C(70-79), D(60-69), F(<60)
3. Displays the grade

**Answer**:
```bash
#!/bin/bash

read -p "Enter score (0-100): " score

if [ $score -ge 90 ]; then
    grade="A"
elif [ $score -ge 80 ]; then
    grade="B"
elif [ $score -ge 70 ]; then
    grade="C"
elif [ $score -ge 60 ]; then
    grade="D"
else
    grade="F"
fi

echo "Score: $score, Grade: $grade"
```

---

### Exercise 4: Menu System
**Task**: Create a menu-driven script with options:
1. Show current directory
2. List files
3. Show disk usage
4. Exit

**Answer**:
```bash
#!/bin/bash

while true; do
    echo ""
    echo "=== MENU ==="
    echo "1. Show current directory"
    echo "2. List files"
    echo "3. Show disk usage"
    echo "4. Exit"
    echo "============"
    read -p "Enter choice: " choice
    
    case $choice in
        1)
            pwd
            ;;
        2)
            ls -l
            ;;
        3)
            df -h
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

## Level 3: Functions

### Exercise 5: File Utilities
**Task**: Create a script with functions to:
1. Check if file exists
2. Count lines in file
3. Display file size
4. Show file permissions

**Answer**:
```bash
#!/bin/bash

file_exists() {
    local file=$1
    if [ -f "$file" ]; then
        echo "✓ File exists: $file"
        return 0
    else
        echo "✗ File not found: $file"
        return 1
    fi
}

count_lines() {
    local file=$1
    if [ -f "$file" ]; then
        echo "Lines: $(wc -l < "$file")"
    fi
}

show_size() {
    local file=$1
    if [ -f "$file" ]; then
        echo "Size: $(du -h "$file" | cut -f1)"
    fi
}

show_permissions() {
    local file=$1
    if [ -f "$file" ]; then
        echo "Permissions: $(ls -l "$file" | awk '{print $1}')"
    fi
}

# Main
if [ $# -eq 0 ]; then
    echo "Usage: $0 <filename>"
    exit 1
fi

file=$1

if file_exists "$file"; then
    count_lines "$file"
    show_size "$file"
    show_permissions "$file"
fi
```

---

## Level 4: Loops

### Exercise 6: Batch File Processor
**Task**: Create a script that:
1. Loops through all .txt files in current directory
2. Counts lines in each file
3. Displays total line count for all files

**Answer**:
```bash
#!/bin/bash

total_lines=0
file_count=0

for file in *.txt; do
    if [ ! -f "$file" ]; then
        echo "No .txt files found"
        exit 0
    fi
    
    lines=$(wc -l < "$file")
    echo "$file: $lines lines"
    
    ((total_lines += lines))
    ((file_count++))
done

echo ""
echo "Total files: $file_count"
echo "Total lines: $total_lines"
```

---

## Level 5: Capital Markets Scenarios

### Exercise 7: Trade Validator
**Task**: Create a script that validates a trade CSV file:
1. Check file exists
2. Verify header format
3. Count valid/invalid lines
4. Report errors

**Answer**:
```bash
#!/bin/bash

validate_trade_file() {
    local file=$1
    local errors=0
    
    # Check file exists
    if [ ! -f "$file" ]; then
        echo "ERROR: File not found"
        return 1
    fi
    
    # Check header
    local expected="TradeID,Symbol,Quantity,Price"
    local actual=$(head -1 "$file")
    
    if [ "$actual" != "$expected" ]; then
        echo "ERROR: Invalid header"
        echo "Expected: $expected"
        echo "Got: $actual"
        ((errors++))
    fi
    
    # Validate data
    local line_num=1
    while IFS=, read -r id symbol qty price; do
        ((line_num++))
        
        # Skip header
        if [ $line_num -eq 2 ]; then
            continue
        fi
        
        # Validate quantity
        if ! [[ "$qty" =~ ^[0-9]+$ ]]; then
            echo "ERROR line $line_num: Invalid quantity: $qty"
            ((errors++))
        fi
        
        # Validate price
        if ! [[ "$price" =~ ^[0-9]+\.?[0-9]*$ ]]; then
            echo "ERROR line $line_num: Invalid price: $price"
            ((errors++))
        fi
    done < "$file"
    
    if [ $errors -eq 0 ]; then
        echo "✓ Validation PASSED"
        return 0
    else
        echo "✗ Validation FAILED: $errors errors"
        return 1
    fi
}

# Main
if [ $# -eq 0 ]; then
    echo "Usage: $0 <trade_file.csv>"
    exit 1
fi

validate_trade_file "$1"
```

---

### Exercise 8: System Health Check
**Task**: Create a monitoring script that:
1. Checks disk usage (alert if >80%)
2. Checks if critical processes are running
3. Displays system uptime
4. Generates a report

**Answer**:
```bash
#!/bin/bash

REPORT_FILE="health_report_$(date +%Y%m%d_%H%M%S).txt"

{
    echo "========================================="
    echo "System Health Check Report"
    echo "Date: $(date)"
    echo "========================================="
    echo ""
    
    # Disk Usage
    echo "DISK USAGE:"
    df -h | grep -E '^/dev' | while read line; do
        usage=$(echo $line | awk '{print $5}' | sed 's/%//')
        mount=$(echo $line | awk '{print $6}')
        
        if [ $usage -gt 80 ]; then
            echo "  ⚠️  $mount: ${usage}% (WARNING)"
        else
            echo "  ✓ $mount: ${usage}%"
        fi
    done
    echo ""
    
    # System Uptime
    echo "SYSTEM UPTIME:"
    uptime
    echo ""
    
    # Critical Processes
    echo "CRITICAL PROCESSES:"
    processes=("sshd" "cron")
    
    for proc in "${processes[@]}"; do
        if pgrep -x "$proc" > /dev/null; then
            echo "  ✓ $proc is running"
        else
            echo "  ✗ $proc is NOT running (CRITICAL)"
        fi
    done
    echo ""
    
    # Memory Usage
    echo "MEMORY USAGE:"
    free -h | grep Mem
    echo ""
    
    echo "========================================="
    echo "End of Report"
    echo "========================================="
    
} | tee "$REPORT_FILE"

echo ""
echo "Report saved: $REPORT_FILE"
```

---

## Advanced Challenges

### Exercise 9: Backup Script
**Task**: Create a comprehensive backup script that:
1. Takes source directory as argument
2. Creates dated backup archive
3. Verifies backup integrity
4. Removes backups older than 7 days
5. Logs all operations

**Answer** (Partial - complete it yourself):
```bash
#!/bin/bash

BACKUP_DIR="/backup"
LOG_FILE="/var/log/backup.log"

log_msg() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

create_backup() {
    local source=$1
    local backup_name="backup_$(date +%Y%m%d_%H%M%S).tar.gz"
    local backup_path="$BACKUP_DIR/$backup_name"
    
    log_msg "Creating backup of $source"
    
    # Your code here
    
    log_msg "Backup created: $backup_path"
}

# Complete the script...
```

---

## Practice Tips

1. Start simple, add features gradually
2. Test with sample data first
3. Add error handling
4. Use meaningful variable names
5. Comment complex logic
6. Test edge cases

---

## Next Steps

1. Complete all exercises
2. Modify scripts for your specific needs
3. Study the comprehensive sample programs
4. Create scripts for real project scenarios
5. Move to TCL programming

**Keep practicing!** 🚀

