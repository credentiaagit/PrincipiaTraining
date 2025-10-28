# Shell Scripting Sample Programs

This directory contains practical shell scripting examples commonly used in capital markets operations.

## Files Overview

### 01-trading-file-processor.sh
**Purpose**: Process incoming trading data files
**Topics Covered**:
- File validation
- CSV parsing
- Data transformation
- Error handling
- Logging

**Usage**:
```bash
./01-trading-file-processor.sh input_file.csv output_file.csv
```

---

### 02-data-validation.sh
**Purpose**: Validate market data files before processing
**Topics Covered**:
- Input validation
- Data type checking
- Duplicate detection
- Report generation
- Color-coded output

**Usage**:
```bash
./02-data-validation.sh market_data.csv
```

**Sample Test Data**:
```bash
# Create test file
cat > test_data.csv << EOF
T001,AAPL,150.25,100,2024-10-28 09:30:00
T002,GOOGL,2800.50,50,2024-10-28 09:31:00
T003,MSFT,350.75,200,2024-10-28 09:32:00
T004,AMZN,3200.00,75,2024-10-28 09:33:00
T005,TSLA,250.50,150,2024-10-28 09:34:00
EOF

./02-data-validation.sh test_data.csv
```

---

### 03-log-analyzer.sh
**Purpose**: Analyze application logs and generate reports
**Topics Covered**:
- Log parsing with grep/awk
- Pattern matching
- Statistical analysis
- Report generation
- Alert triggering

**Usage**:
```bash
./03-log-analyzer.sh application.log
```

**Sample Test Log**:
```bash
# Create test log
cat > test_app.log << EOF
2024-10-28 09:00:00 INFO Application started
2024-10-28 09:01:15 INFO Trade T001 COMPLETED Symbol:AAPL
2024-10-28 09:02:30 ERROR Database connection timeout
2024-10-28 09:03:45 INFO Trade T002 COMPLETED Symbol:GOOGL
2024-10-28 09:04:00 FATAL System crash - out of memory
2024-10-28 09:05:15 WARNING Market data feed delayed
2024-10-28 09:06:30 INFO Trade T003 FAILED Symbol:MSFT
2024-10-28 09:07:45 ERROR Invalid price data received
EOF

./03-log-analyzer.sh test_app.log
```

---

### 04-backup-automation.sh
**Purpose**: Automated backup system for critical data
**Topics Covered**:
- Command-line argument parsing
- Directory operations
- Archive creation (tar)
- Compression (gzip)
- Disk space management
- Retention policies
- Logging

**Usage**:
```bash
# Standard backup
./04-backup-automation.sh

# With options
./04-backup-automation.sh -d -e -r 60

# Incremental backup
./04-backup-automation.sh -i
```

**Options**:
- `-h, --help`: Display help
- `-i, --incremental`: Create incremental backups
- `-d, --database`: Include database backup
- `-e, --email`: Send email notification
- `-r, --retention DAYS`: Set retention period

---

## Running the Scripts

### Make Scripts Executable
```bash
chmod +x *.sh
```

### Test Individual Scripts
```bash
# Run with test data
./01-trading-file-processor.sh
./02-data-validation.sh test_data.csv
./03-log-analyzer.sh test_app.log
./04-backup-automation.sh --help
```

---

## Learning Path

1. **Start with**: `01-trading-file-processor.sh`
   - Understand basic script structure
   - Learn file operations
   - Practice variables and loops

2. **Then study**: `02-data-validation.sh`
   - Functions and modular code
   - Input validation techniques
   - Error handling

3. **Progress to**: `03-log-analyzer.sh`
   - Advanced text processing
   - grep/awk/sed usage
   - Report generation

4. **Master**: `04-backup-automation.sh`
   - Complex script structure
   - Command-line arguments
   - System administration tasks

---

## Key Concepts Demonstrated

### Variables and Parameters
```bash
VARIABLE="value"
$1, $2, $@  # Command-line arguments
```

### Functions
```bash
function_name() {
    local variable=$1
    # function code
    return 0
}
```

### Conditional Statements
```bash
if [ condition ]; then
    # commands
elif [ condition ]; then
    # commands
else
    # commands
fi
```

### Loops
```bash
# For loop
for item in list; do
    # commands
done

# While loop
while [ condition ]; do
    # commands
done
```

### File Operations
```bash
[ -f file ]    # Check if file exists
[ -d dir ]     # Check if directory exists
[ -r file ]    # Check if readable
[ -w file ]    # Check if writable
```

### Text Processing
```bash
grep "pattern" file
sed 's/old/new/g' file
awk '{print $1}' file
cut -d',' -f1 file
```

---

## Common Patterns Used

### Error Handling
```bash
command || {
    echo "Error occurred"
    exit 1
}

if ! command; then
    echo "Command failed"
    exit 1
fi
```

### Logging
```bash
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $@" | tee -a logfile.log
}
```

### Input Validation
```bash
if [ $# -ne 2 ]; then
    echo "Usage: $0 arg1 arg2"
    exit 1
fi
```

---

## Capital Markets Context

These scripts demonstrate real-world scenarios in capital markets:

1. **File Processing**: Daily market data ingestion
2. **Validation**: Ensure data quality before trading
3. **Log Analysis**: Monitor system health and performance
4. **Backup**: Protect critical trading data

---

## Best Practices Demonstrated

✅ **Use functions** for modular code
✅ **Validate inputs** before processing
✅ **Handle errors** gracefully
✅ **Log operations** for audit trail
✅ **Comment code** for maintainability
✅ **Use meaningful variable names**
✅ **Check exit codes** of commands
✅ **Quote variables** to handle spaces

---

## Exercises

After studying these scripts, try:

1. Modify `01-trading-file-processor.sh` to handle JSON files
2. Add email alerts to `02-data-validation.sh`
3. Create a dashboard from `03-log-analyzer.sh` output
4. Add remote backup support to `04-backup-automation.sh`

---

## Reference Materials

- Shell Scripting Tutorial: https://www.shellscript.sh/
- Advanced Bash Guide: https://tldp.org/LDP/abs/html/
- ShellCheck (syntax checker): https://www.shellcheck.net/

---

## Troubleshooting

### Script won't run
```bash
chmod +x script.sh
bash script.sh  # Alternative way to run
```

### Permission denied
```bash
sudo ./script.sh  # Run with elevated privileges
```

### Syntax errors
```bash
bash -n script.sh  # Check syntax without running
shellcheck script.sh  # Use ShellCheck for detailed analysis
```

---

**Next Steps**: Complete the exercises in the `Exercises` directory to practice these concepts.

