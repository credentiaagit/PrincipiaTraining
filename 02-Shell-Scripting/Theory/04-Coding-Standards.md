# Shell Scripting Coding Standards

## Table of Contents
1. [Naming Conventions](#naming-conventions)
2. [File Naming](#file-naming)
3. [Indentation and Formatting](#indentation-and-formatting)
4. [Comments and Documentation](#comments-and-documentation)
5. [Variable Declarations](#variable-declarations)
6. [Function Standards](#function-standards)
7. [Error Handling](#error-handling)
8. [Script Structure](#script-structure)
9. [Security Best Practices](#security-best-practices)
10. [Capital Markets Specific Standards](#capital-markets-specific-standards)

---

## Naming Conventions

### Variable Naming

**Constants (Environment/Global Variables)**
- **Convention**: `UPPER_CASE_WITH_UNDERSCORES`
- **Why**: Easy to identify as constants that shouldn't change
- **Examples**:
```bash
# Good
readonly CONFIG_DIR="/opt/trading/config"
readonly MAX_RETRIES=3
readonly DB_CONNECTION_STRING="host=localhost;port=5432"
readonly TRADE_FILE_PREFIX="TRADE"

# Bad
configdir="/opt/trading/config"     # Looks like regular variable
MaxRetries=3                         # Mixed case confusing
db-connection-string="..."          # Hyphens not allowed
```

**Local Variables**
- **Convention**: `lowercase_with_underscores` (snake_case)
- **Why**: Distinguishes from constants, readable
- **Examples**:
```bash
# Good
trade_count=0
file_name="trades.csv"
current_date=$(date +%Y%m%d)
total_value=0

# Bad
TradeCount=0        # Looks like constant
fileName="..."      # camelCase not standard in bash
trade-count=0       # Hyphens not allowed
tc=0                # Too cryptic
```

**Temporary/Loop Variables**
- **Convention**: Short lowercase names (i, j, k for loops) or descriptive names
- **Examples**:
```bash
# Good - Loop counters
for i in {1..10}; do
    echo "$i"
done

# Good - Descriptive temporary variables
for trade_file in *.csv; do
    process_file "$trade_file"
done

# Bad - Unclear what x represents
for x in *.csv; do
    process_file "$x"
done
```

**Array Variables**
- **Convention**: `lowercase_plural` or `lowercase_array`
- **Examples**:
```bash
# Good
declare -a trade_ids=("T001" "T002" "T003")
declare -a symbols=("AAPL" "GOOGL" "MSFT")
declare -A prices  # Associative array

# Bad
declare -a TRADEIDS=()     # Looks like constant
declare -a tid=()          # Not descriptive
```

---

### Function Naming

**Function Names**
- **Convention**: `lowercase_with_underscores` (snake_case)
- **Why**: Consistent with variables, easy to read
- **Prefix conventions**:
  - `validate_*` - Validation functions
  - `process_*` - Processing functions
  - `get_*` - Getter functions
  - `set_*` - Setter functions
  - `is_*` or `has_*` - Boolean check functions
  - `log_*` - Logging functions

**Examples**:
```bash
# Good - Descriptive function names
validate_trade_file() {
    local file="$1"
    [[ -f "$file" ]] && [[ -r "$file" ]]
}

process_trades() {
    local input_file="$1"
    # Processing logic
}

get_trade_count() {
    wc -l < "$1"
}

is_market_open() {
    local current_hour=$(date +%H)
    [[ $current_hour -ge 9 && $current_hour -lt 16 ]]
}

log_error() {
    echo "[ERROR] $(date '+%Y-%m-%d %H:%M:%S'): $*" >&2
}

# Bad - Poor naming
valtrdfile() { }        # Too cryptic
ProcessTrades() { }     # Wrong case
process-trades() { }    # Hyphens not allowed
pt() { }                # Meaningless abbreviation
```

**Private/Internal Functions**
- **Convention**: Prefix with underscore `_function_name`
- **Why**: Indicates internal use only
```bash
# Good - Private helper function
_cleanup_temp_files() {
    rm -f /tmp/trade_$$_*
}

# Public function
process_all_trades() {
    # ... processing ...
    _cleanup_temp_files  # Call private function
}
```

---

## File Naming

### Script Files

**Shell Scripts**
- **Extension**: `.sh` (required)
- **Convention**: `lowercase-with-hyphens.sh` (kebab-case) or `lowercase_with_underscores.sh`
- **Why**: Hyphens easier to read in file listings, common Unix convention

**Examples**:
```bash
# Good - Descriptive with hyphens (preferred)
process-trades.sh
validate-market-data.sh
generate-daily-report.sh
backup-database.sh

# Also acceptable - Underscores
process_trades.sh
validate_market_data.sh

# Bad
ProcessTrades.sh        # PascalCase not standard
processTrades.sh        # camelCase not standard
pt.sh                   # Not descriptive
process_trades          # Missing .sh extension
```

### Configuration Files

**Convention**: `lowercase-with-hyphens.conf` or `.config`
```bash
# Good
trading-config.conf
database-connection.conf
app-settings.config

# Also used
.bashrc
.profile
```

### Data Files (Scripts Generate/Process)

**Convention**: Descriptive with date/time stamps
```bash
# Good
trades-2024-10-28.csv
market-data-20241028-093000.csv
report-daily-2024-10-28.txt

# Bad
data.csv                # Not descriptive
file1.csv              # Meaningless name
trades.csv             # No timestamp
```

---

## Indentation and Formatting

### Indentation

**Standard**: 4 spaces (NOT tabs)
- **Why**: Consistent across all editors, no tab vs space issues

```bash
# Good - 4 space indentation
if [ -f "$file" ]; then
    echo "File exists"
    if [ -r "$file" ]; then
        echo "File is readable"
    fi
fi

# Bad - Inconsistent indentation
if [ -f "$file" ]; then
  echo "File exists"    # 2 spaces
    if [ -r "$file" ]; then   # 4 spaces
      echo "File is readable"  # 2 spaces
    fi
fi

# Bad - Tabs (shows differently in different editors)
if [ -f "$file" ]; then
→   echo "File exists"    # Tab character
fi
```

### Line Length

**Maximum**: 80-100 characters per line
**Why**: Easier to read, fits in side-by-side diffs, terminal windows

```bash
# Good - Readable length
if [ "$trade_status" = "COMPLETED" ] && [ "$settlement_status" = "PENDING" ]; then
    process_settlement "$trade_id"
fi

# Good - Long line broken up
if [ "$trade_status" = "COMPLETED" ] && \
   [ "$settlement_status" = "PENDING" ] && \
   [ "$approval_status" = "APPROVED" ]; then
    process_settlement "$trade_id"
fi

# Bad - Too long
if [ "$trade_status" = "COMPLETED" ] && [ "$settlement_status" = "PENDING" ] && [ "$approval_status" = "APPROVED" ] && [ "$risk_check" = "PASSED" ]; then
```

### Spacing

**Around operators**:
```bash
# Good - Spaces around operators
x=$((y + 5))
if [ "$a" = "$b" ]; then
count=$((count + 1))

# Bad - No spaces
x=$((y+5))
if [ "$a"="$b" ]; then
count=$((count+1))
```

**Function definitions**:
```bash
# Good - Space before {
function_name() {
    # code
}

# Also acceptable
function function_name() {
    # code
}

# Bad - No space before {
function_name(){
    # code
}
```

### Blank Lines

Use blank lines to separate logical sections:
```bash
# Good - Logical separation
#!/bin/bash

# Constants
readonly CONFIG_FILE="/etc/app.conf"
readonly LOG_FILE="/var/log/app.log"

# Functions
validate_input() {
    # validation logic
}

process_data() {
    # processing logic
}

# Main execution
main() {
    validate_input "$@"
    process_data
}

main "$@"
```

---

## Comments and Documentation

### Script Header

**Required** at the top of every script:
```bash
#!/bin/bash
#################################################################
# Script Name: process-trades.sh
# Description: Process daily trading files and generate reports
# Author: Trading Systems Team
# Date: 2024-10-28
# Version: 1.0
#
# Usage: ./process-trades.sh <input_file> [output_dir]
#
# Arguments:
#   input_file  - CSV file containing trade data
#   output_dir  - Directory for output (optional, default: ./output)
#
# Examples:
#   ./process-trades.sh trades.csv
#   ./process-trades.sh trades.csv /opt/reports
#
# Exit Codes:
#   0 - Success
#   1 - Invalid arguments
#   2 - File not found
#   3 - Processing error
#################################################################
```

### Function Documentation

**Required** for all non-trivial functions:
```bash
#################################################################
# Function: validate_trade_file
# Description: Validates trade file format and content
# Arguments:
#   $1 - Path to trade file
# Returns:
#   0 if valid, 1 if invalid
# Example:
#   if validate_trade_file "$file"; then
#       process_file "$file"
#   fi
#################################################################
validate_trade_file() {
    local file="$1"
    
    # Check file exists
    if [ ! -f "$file" ]; then
        log_error "File not found: $file"
        return 1
    fi
    
    # Check file format
    # ... validation logic ...
    
    return 0
}
```

### Inline Comments

**Good inline comments** explain WHY, not WHAT:
```bash
# Good - Explains reasoning
# Use background process to avoid blocking main thread
process_large_file "$file" &

# Trading hours are 9:30 AM to 4:00 PM EST
if [ "$hour" -ge 9 ] && [ "$hour" -lt 16 ]; then

# Good - Complex logic explanation
# Calculate P&L: (current_price - purchase_price) * quantity - fees
pnl=$(( (current_price - purchase_price) * quantity - fees ))

# Bad - States the obvious
# Increment counter by 1
count=$((count + 1))

# Bad - Redundant
# Loop through files
for file in *.csv; do
```

### TODO and FIXME Comments

```bash
# TODO: Add error handling for network failures
# FIXME: This fails when file size exceeds 1GB
# NOTE: This workaround needed until database upgrade
# HACK: Temporary fix for date parsing issue
# XXX: This should be refactored
```

---

## Variable Declarations

### Variable Declaration Style

```bash
# Good - Declare variables at top of function/script
process_trades() {
    local input_file="$1"
    local output_dir="$2"
    local trade_count=0
    local error_count=0
    
    # Processing logic here
}

# Good - Use readonly for constants
readonly MAX_RETRIES=3
readonly CONFIG_DIR="/etc/trading"

# Good - Use declare for arrays
declare -a trade_ids=()
declare -A trade_details=()

# Good - Local variables in functions
validate_data() {
    local data="$1"
    local result
    
    result=$(some_command "$data")
    echo "$result"
}
```

### Variable Initialization

```bash
# Good - Always initialize variables
count=0
file_name=""
status="PENDING"

# Bad - Uninitialized variables
count=$((count + 1))  # count is empty on first run
echo "$file_name"     # Might be set from environment
```

### Quoting Variables

**Always quote variables** to prevent word splitting:
```bash
# Good - Variables quoted
file_name="trade data.csv"
if [ -f "$file_name" ]; then
    cat "$file_name"
fi

# Bad - Unquoted (breaks with spaces)
file_name="trade data.csv"
if [ -f $file_name ]; then    # Expands to: [ -f trade data.csv ]
    cat $file_name              # Tries to cat "trade" and "data.csv"
fi

# Good - Array expansion quoted
files=("file 1.txt" "file 2.txt")
process_files "${files[@]}"

# Bad - Unquoted array
process_files ${files[@]}  # Breaks with spaces in filenames
```

---

## Function Standards

### Function Structure

```bash
# Standard function template
function_name() {
    # 1. Local variable declarations
    local param1="$1"
    local param2="$2"
    local result
    
    # 2. Input validation
    if [ -z "$param1" ]; then
        log_error "Missing required parameter"
        return 1
    fi
    
    # 3. Main logic
    result=$(do_something "$param1")
    
    # 4. Return/output
    echo "$result"
    return 0
}
```

### Return Codes

**Standard exit/return codes**:
```bash
# Success
return 0

# General errors
return 1

# Specific errors (optional)
return 2  # Invalid arguments
return 3  # File not found
return 4  # Permission denied
return 5  # Processing error
```

### Function Size

**Guideline**: Keep functions under 50 lines
- If longer, break into smaller functions
- Each function should do ONE thing

```bash
# Good - Single responsibility
validate_trade_format() {
    # Only validates format
}

validate_trade_values() {
    # Only validates values
}

validate_trade() {
    validate_trade_format "$1" || return 1
    validate_trade_values "$1" || return 1
    return 0
}

# Bad - Does too much
validate_trade() {
    # 100 lines of validation, parsing, logging, etc.
}
```

---

## Error Handling

### Check All Command Results

```bash
# Good - Check critical commands
if ! cp "$source" "$dest"; then
    log_error "Failed to copy file"
    exit 1
fi

# Good - Use set -e for exit on error
set -e  # Exit on any error
set -u  # Exit on undefined variable
set -o pipefail  # Exit on pipe failure

# Or combined
set -euo pipefail

# Good - Trap errors
trap 'handle_error $? $LINENO' ERR

handle_error() {
    local exit_code=$1
    local line_number=$2
    log_error "Error occurred at line $line_number with exit code $exit_code"
    cleanup
    exit "$exit_code"
}
```

### Error Messages

```bash
# Good - Descriptive error messages
log_error "Failed to process trade file: $file (line $line_num)"
log_error "Database connection failed: host=$DB_HOST port=$DB_PORT"

# Bad - Generic errors
log_error "Error"
log_error "Failed"
```

---

## Script Structure

### Standard Script Template

```bash
#!/bin/bash
#################################################################
# Script documentation here
#################################################################

# Exit on error, undefined variables, pipe failures
set -euo pipefail

#================================================================
# CONSTANTS
#================================================================
readonly SCRIPT_NAME=$(basename "$0")
readonly SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
readonly LOG_FILE="/var/log/${SCRIPT_NAME%.sh}.log"
readonly CONFIG_FILE="${SCRIPT_DIR}/config.conf"

#================================================================
# GLOBAL VARIABLES
#================================================================
VERBOSE=false
DRY_RUN=false

#================================================================
# FUNCTIONS
#================================================================

# Logging functions
log_info() {
    echo "[INFO] $(date '+%Y-%m-%d %H:%M:%S'): $*" | tee -a "$LOG_FILE"
}

log_error() {
    echo "[ERROR] $(date '+%Y-%m-%d %H:%M:%S'): $*" | tee -a "$LOG_FILE" >&2
}

# Show usage
usage() {
    cat << EOF
Usage: $SCRIPT_NAME [OPTIONS] <arguments>

Description:
    Brief description of what the script does

Options:
    -h, --help          Show this help message
    -v, --verbose       Enable verbose output
    -n, --dry-run       Dry run mode (no changes)
    
Arguments:
    arg1                Description of arg1
    arg2                Description of arg2

Examples:
    $SCRIPT_NAME file.csv
    $SCRIPT_NAME -v file.csv /output

Exit Codes:
    0   Success
    1   General error
    2   Invalid arguments
EOF
    exit 0
}

# Cleanup function
cleanup() {
    log_info "Cleaning up temporary files..."
    rm -f /tmp/${SCRIPT_NAME%.sh}_$$_*
}

# Trap cleanup on exit
trap cleanup EXIT

# Parse command line arguments
parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -h|--help)
                usage
                ;;
            -v|--verbose)
                VERBOSE=true
                shift
                ;;
            -n|--dry-run)
                DRY_RUN=true
                shift
                ;;
            -*)
                log_error "Unknown option: $1"
                usage
                ;;
            *)
                POSITIONAL_ARGS+=("$1")
                shift
                ;;
        esac
    done
}

# Main function
main() {
    log_info "Starting $SCRIPT_NAME"
    
    # Parse arguments
    declare -a POSITIONAL_ARGS=()
    parse_arguments "$@"
    
    # Validate arguments
    if [ ${#POSITIONAL_ARGS[@]} -eq 0 ]; then
        log_error "Missing required arguments"
        usage
    fi
    
    # Main logic here
    # ...
    
    log_info "Completed successfully"
}

#================================================================
# MAIN EXECUTION
#================================================================
main "$@"
```

---

## Security Best Practices

### Secure Coding

```bash
# Good - Validate and sanitize input
validate_filename() {
    local filename="$1"
    
    # Check for path traversal
    if [[ "$filename" =~ \.\. ]]; then
        log_error "Invalid filename: contains .."
        return 1
    fi
    
    # Check for special characters
    if [[ ! "$filename" =~ ^[a-zA-Z0-9._-]+$ ]]; then
        log_error "Invalid filename: contains special characters"
        return 1
    fi
    
    return 0
}

# Good - Use secure temporary files
temp_file=$(mktemp) || exit 1
trap 'rm -f "$temp_file"' EXIT

# Good - Avoid eval
# Bad
eval "$user_input"

# Good - Use arrays or proper parsing
IFS=',' read -ra fields <<< "$csv_line"

# Good - Set secure permissions
umask 077  # Files created with 600 permissions
touch sensitive_file.txt

# Good - Don't log sensitive data
log_info "Processing trade for user: ${username:0:1}***"  # Partially mask
# Bad: log_info "Password: $password"
```

---

## Capital Markets Specific Standards

### File Naming for Trading Systems

```bash
# Trade files
TRADES-${EXCHANGE}-${DATE}-${SEQUENCE}.csv
# Example: TRADES-NYSE-20241028-001.csv

# Report files
REPORT-${REPORT_TYPE}-${DATE}.pdf
# Example: REPORT-DAILY-SUMMARY-20241028.pdf

# Position files
POSITIONS-${TRADER_ID}-${DATE}.csv
# Example: POSITIONS-TR001-20241028.csv
```

### Variable Naming for Trading

```bash
# Good - Clear trading variables
readonly MARKET_OPEN_HOUR=9
readonly MARKET_CLOSE_HOUR=16
readonly MAX_TRADE_VALUE=1000000
readonly SETTLEMENT_DAYS=2

ticker_symbol="AAPL"
trade_quantity=100
trade_price=175.50
order_type="LIMIT"
execution_time=$(date '+%Y-%m-%d %H:%M:%S')
```

### Function Naming for Trading

```bash
# Good - Domain-specific function names
validate_trade_limits()
check_market_hours()
calculate_settlement_date()
get_current_position()
update_trade_status()
generate_risk_report()
```

---

## Style Checker Tools

### ShellCheck

**Always run** ShellCheck on your scripts:
```bash
# Install
apt-get install shellcheck  # Debian/Ubuntu
brew install shellcheck     # macOS

# Run
shellcheck script.sh

# In script, disable specific warnings if needed
# shellcheck disable=SC2034  # Unused variable
SOME_VAR="value"
```

### Auto-formatting

Use `shfmt` for consistent formatting:
```bash
# Install
go install mvdan.cc/sh/v3/cmd/shfmt@latest

# Format file
shfmt -i 4 -w script.sh  # 4 space indentation

# Check formatting
shfmt -d script.sh
```

---

## Quick Reference

### Naming Summary

| Element | Convention | Example |
|---------|-----------|---------|
| Constants | `UPPER_SNAKE_CASE` | `MAX_RETRIES=3` |
| Variables | `lower_snake_case` | `trade_count=0` |
| Functions | `lower_snake_case` | `process_trades()` |
| Private functions | `_lower_snake_case` | `_cleanup()` |
| Script files | `kebab-case.sh` | `process-trades.sh` |
| Config files | `kebab-case.conf` | `database-config.conf` |

### Formatting Summary

- **Indentation**: 4 spaces
- **Line length**: 80-100 characters
- **Quotes**: Always quote variables
- **Braces**: Always use `${var}` in complex cases

### Common Patterns

```bash
# Error handling
command || { log_error "Command failed"; exit 1; }

# Default values
output_dir="${2:-./output}"

# String comparison
if [ "$status" = "COMPLETED" ]; then

# Numeric comparison
if [ "$count" -gt 100 ]; then

# File checks
if [ -f "$file" ] && [ -r "$file" ]; then

# Array iteration
for item in "${array[@]}"; do
```

---

*Last Updated: 2024-10-28*  
*Follow these standards for consistent, maintainable shell scripts*

