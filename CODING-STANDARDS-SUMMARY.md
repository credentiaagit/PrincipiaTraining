# Coding Standards Summary

## Overview

This document provides a quick reference to all coding standards used in the capital markets training program. Detailed standards for each technology are available in their respective sections.

---

## Quick Reference by Technology

### 1. Shell Scripting
**File**: `02-Shell-Scripting/Theory/04-Coding-Standards.md`

**Key Conventions**:
- **Variables**: `lower_snake_case` for regular, `UPPER_SNAKE_CASE` for constants
- **Functions**: `lower_snake_case` with descriptive names
- **Files**: `kebab-case.sh` or `lowercase_with_underscores.sh`
- **Indentation**: 4 spaces (NO tabs)
- **Keywords**: N/A (bash syntax is fixed)

**Examples**:
```bash
# Constants
readonly MAX_RETRIES=3
readonly CONFIG_DIR="/opt/trading"

# Variables
trade_count=0
file_name="trades.csv"

# Functions
process_trades() {
    local input_file="$1"
    # ...
}

# Files
process-trades.sh
validate-market-data.sh
```

---

### 2. TCL Programming
**File**: `03-TCL-Programming/Theory/04-Coding-Standards.md`

**Key Conventions**:
- **Variables**: `camelCase` for regular, `UPPER_CASE` for constants
- **Procedures**: `camelCase` with descriptive names
- **Files**: `camelCase.tcl` or `kebab-case.tcl`
- **Indentation**: 4 spaces (NO tabs)
- **Braces**: Same line with spaces `{ }`

**Examples**:
```tcl
# Constants
set MAX_RETRIES 3
set CONFIG_DIR "/opt/trading"

# Variables
set tradeCount 0
set fileName "trades.csv"

# Procedures
proc processTrades {inputFile} {
    # ...
}

# Files
processTrades.tcl
validateMarketData.tcl
```

---

### 3. SQL Database
**File**: `04-SQL-Database/Theory/03-Coding-Standards.md`

**Key Conventions**:
- **Tables**: `snake_case`, plural nouns
- **Columns**: `snake_case`, descriptive
- **Keywords**: `UPPERCASE`
- **Identifiers**: `lowercase`
- **Indentation**: 4 spaces

**Examples**:
```sql
-- Tables (plural)
CREATE TABLE trades (
    trade_id VARCHAR(10) PRIMARY KEY,
    trader_id VARCHAR(10),
    symbol VARCHAR(10),
    quantity INT,
    trade_price DECIMAL(10,2),
    is_executed BOOLEAN,
    created_at TIMESTAMP
);

-- Queries (keywords UPPERCASE)
SELECT 
    t.trade_id,
    t.symbol,
    tr.trader_name
FROM trades t
INNER JOIN traders tr 
    ON t.trader_id = tr.trader_id
WHERE t.trade_date = '2024-10-28'
ORDER BY t.trade_id;

-- Procedures
CREATE PROCEDURE sp_process_daily_trades()
```

---

### 4. Unix Files and Directories
**File**: `01-Unix-System-and-Commands/Theory/06-File-and-Directory-Naming-Standards.md`

**Key Conventions**:
- **Files**: `lowercase-with-hyphens` or `lowercase_with_underscores`
- **Directories**: `lowercase-with-hyphens`
- **Dates**: `YYYY-MM-DD` format (ISO 8601)
- **No spaces**: Use hyphens or underscores
- **Extensions**: Always include appropriate extension

**Examples**:
```bash
# Script files
process-trades.sh
validate-market-data.sh

# Data files (with dates)
trades-2024-10-28.csv
market-data-2024-10-28-093000.csv
report-daily-2024-10-28.pdf

# Directories
/opt/trading/data/
/var/log/trading/
/opt/trading/archive/2024/10/
```

---

### 5. Tidal Scheduler
**File**: `05-Tidal-Scheduler/Theory/03-Naming-Standards.md`

**Key Conventions**:
- **Jobs**: `ENV_SYSTEM_FUNCTION_DESCRIPTION`
- **Job Groups**: `ENV_SYSTEM_CATEGORY`
- **Variables**: `SYSTEM_PURPOSE` or `VARIABLE_PURPOSE`
- **All UPPERCASE**: With underscores
- **Environment prefix**: Always include (DEV, TEST, UAT, PROD)

**Examples**:
```
# Jobs
PROD_TRADING_PROCESS_DAILY_TRADES
PROD_TRADING_GENERATE_EOD_REPORT
UAT_RISK_CALCULATE_VAR
DEV_TRADING_TEST_VALIDATION

# Job Groups
PROD_TRADING_SOD
PROD_TRADING_EOD
PROD_TRADING_INTRADAY

# Variables
TRADING_HOME_DIR=/opt/trading
TRADING_DATA_DIR=/opt/trading/data
INPUT_FILE=/opt/trading/data/trades-{TXDATE}.csv
```

---

## Comparison Table

| Aspect | Shell Script | TCL | SQL | Unix Files | Tidal |
|--------|-------------|-----|-----|------------|-------|
| **Variables** | `snake_case` | `camelCase` | `snake_case` | N/A | `UPPER_CASE` |
| **Constants** | `UPPER_SNAKE` | `UPPER_CASE` | N/A | N/A | `UPPER_CASE` |
| **Functions** | `snake_case` | `camelCase` | N/A | N/A | N/A |
| **Files** | `kebab-case.sh` | `camelCase.tcl` | N/A | `kebab-case` | N/A |
| **Keywords** | N/A | N/A | `UPPERCASE` | N/A | N/A |
| **Indentation** | 4 spaces | 4 spaces | 4 spaces | N/A | N/A |
| **Separators** | `_` underscore | None (camel) | `_` underscore | `-` or `_` | `_` underscore |

---

## Common Patterns Across Technologies

### Naming Principles

**1. Be Descriptive**
```bash
# Good - Clear purpose
process_trades()              # Shell
processTrades()               # TCL
PROD_TRADING_PROCESS_TRADES   # Tidal

# Bad - Unclear
pt()                          # What does this do?
proc1()                       # Meaningless
JOB1                          # Not descriptive
```

**2. Use Consistent Prefixes/Suffixes**
```bash
# Validation functions
validate_trade_file()         # Shell
validateTradeFile()           # TCL
PROD_TRADING_VALIDATE_FILES   # Tidal

# Boolean indicators
is_executed                   # SQL column
is_market_open()              # Shell function
isMarketOpen()                # TCL procedure
```

**3. Include Context**
```bash
# With context - Clear what system/domain
TRADING_DATA_DIR              # Shell/Tidal - Trading system
trade_date                    # SQL - Trade-related
processTrades()               # TCL - Processes trades

# Without context - Ambiguous
DATA_DIR                      # Which system?
date                          # What kind of date?
process()                     # Process what?
```

### Date Formatting

**All technologies use ISO 8601 format**:
```
YYYY-MM-DD        # 2024-10-28 (preferred)
YYYYMMDD          # 20241028 (compact, also acceptable)

# Examples
trades-2024-10-28.csv                    # Unix file
report-2024-10-28.pdf                    # Unix file
TRADES-NYSE-2024-10-28-001.csv          # Capital markets file
INPUT_FILE=/data/trades-{TXDATE}.csv    # Tidal variable
WHERE trade_date = '2024-10-28'          # SQL query
```

### File Extensions

| File Type | Extension | Example |
|-----------|-----------|---------|
| Shell script | `.sh` | `process-trades.sh` |
| TCL script | `.tcl` | `processTrades.tcl` |
| SQL script | `.sql` | `create-tables.sql` |
| Configuration | `.conf`, `.cfg`, `.config` | `database.conf` |
| Data (CSV) | `.csv` | `trades-2024-10-28.csv` |
| Log | `.log` | `trading-2024-10-28.log` |
| Archive | `.tar.gz`, `.zip` | `archive-2024-10.tar.gz` |

---

## Capital Markets Specific Conventions

### Common Naming Patterns

**Trade Files**:
```bash
# Format: TRADES-{EXCHANGE}-{DATE}-{SEQ}.csv
TRADES-NYSE-2024-10-28-001.csv
TRADES-NASDAQ-2024-10-28-001.csv
```

**Report Files**:
```bash
# Format: REPORT-{TYPE}-{DATE}.{ext}
REPORT-DAILY-PNL-2024-10-28.pdf
REPORT-POSITIONS-EOD-2024-10-28.xlsx
REPORT-RISK-VAR-2024-10-28.pdf
```

**Database Tables**:
```sql
-- Plural, snake_case
trades
trade_executions
trade_settlements
market_data
positions
portfolios
risk_limits
```

**Tidal Jobs**:
```
PROD_TRADING_SOD_VALIDATE_MARKET_DATA
PROD_TRADING_INTRADAY_PROCESS_TRADES
PROD_TRADING_EOD_GENERATE_PNL_REPORT
PROD_RISK_CALCULATE_VAR_DAILY
PROD_COMPLIANCE_CHECK_TRADE_LIMITS
```

### Domain-Specific Terms

**Standard abbreviations** (use consistently):
```
SOD   - Start of Day
EOD   - End of Day
PNL   - Profit and Loss
VAR   - Value at Risk
FX    - Foreign Exchange
OTC   - Over The Counter
RECON - Reconciliation
```

---

## Best Practices Summary

### Universal Principles

✅ **DO**:
1. **Be consistent** - Follow the same pattern throughout
2. **Be descriptive** - Name should indicate purpose
3. **Be specific** - Include context and details
4. **Document** - Add comments and documentation
5. **Follow conventions** - Use technology-specific standards
6. **Think about others** - Make code readable for team
7. **Include dates** - Use ISO 8601 format (YYYY-MM-DD)
8. **Use proper extensions** - Always include file extensions

❌ **DON'T**:
1. **Mix conventions** - Don't switch between styles
2. **Use cryptic names** - Avoid unclear abbreviations
3. **Use spaces** - Use hyphens or underscores instead
4. **Ignore context** - Always include system/domain info
5. **Use special chars** - Stick to alphanumeric and `_` or `-`
6. **Make names too long** - Keep under 64 characters
7. **Forget comments** - Document complex logic
8. **Use ambiguous dates** - Always use YYYY-MM-DD

### Code Review Checklist

**Before committing code, verify**:
- [ ] Variable names follow convention for this technology
- [ ] Function/procedure names are descriptive
- [ ] File names follow naming standards
- [ ] Indentation is consistent (4 spaces)
- [ ] Comments explain WHY, not WHAT
- [ ] No hard-coded values (use constants/variables)
- [ ] Date formats are ISO 8601 (YYYY-MM-DD)
- [ ] No spaces in filenames
- [ ] Proper file extensions used
- [ ] Documentation/header comments included

---

## Technology-Specific Quick Links

### Detailed Standards Documents

1. **Shell Scripting**: `02-Shell-Scripting/Theory/04-Coding-Standards.md`
   - Variable naming, function naming, file structure
   - Error handling, security practices
   - Shell-specific best practices

2. **TCL Programming**: `03-TCL-Programming/Theory/04-Coding-Standards.md`
   - Procedure naming, namespace usage
   - String and list handling
   - TCL-specific patterns

3. **SQL Database**: `04-SQL-Database/Theory/03-Coding-Standards.md`
   - Table and column naming
   - Query formatting, JOIN standards
   - Index and constraint naming

4. **Unix Files**: `01-Unix-System-and-Commands/Theory/06-File-and-Directory-Naming-Standards.md`
   - File and directory naming
   - Date formats, extensions
   - Directory structure

5. **Tidal Scheduler**: `05-Tidal-Scheduler/Theory/03-Naming-Standards.md`
   - Job naming, job groups
   - Variable and calendar naming
   - Alert and queue naming

---

## Examples by Use Case

### Use Case 1: Processing Daily Trade Files

**Shell Script**:
```bash
#!/bin/bash
# File: process-daily-trades.sh

readonly TRADING_HOME="/opt/trading"
readonly INPUT_DIR="${TRADING_HOME}/data"
readonly LOG_DIR="${TRADING_HOME}/logs"

process_trades() {
    local trade_date="$1"
    local input_file="${INPUT_DIR}/trades-${trade_date}.csv"
    
    if [ ! -f "$input_file" ]; then
        log_error "Trade file not found: $input_file"
        return 1
    fi
    
    # Process trades...
}

main() {
    local trade_date=$(date +%Y-%m-%d)
    process_trades "$trade_date"
}

main "$@"
```

**TCL Script**:
```tcl
#!/usr/bin/env tclsh
# File: processDailyTrades.tcl

set TRADING_HOME "/opt/trading"
set INPUT_DIR "$TRADING_HOME/data"

proc processTrades {tradeDate} {
    global INPUT_DIR
    
    set inputFile "$INPUT_DIR/trades-$tradeDate.csv"
    
    if {![file exists $inputFile]} {
        logError "Trade file not found: $inputFile"
        return 0
    }
    
    # Process trades...
    return 1
}

proc main {argv} {
    set tradeDate [clock format [clock seconds] -format "%Y-%m-%d"]
    processTrades $tradeDate
}

main $argv
```

**SQL Table**:
```sql
CREATE TABLE trades (
    trade_id VARCHAR(20) PRIMARY KEY,
    trade_date DATE NOT NULL,
    symbol VARCHAR(10) NOT NULL,
    quantity INT NOT NULL,
    trade_price DECIMAL(10,2) NOT NULL,
    is_executed BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_trades_trade_date ON trades(trade_date);
CREATE INDEX idx_trades_symbol ON trades(symbol);
```

**Tidal Job**:
```
Job Name: PROD_TRADING_PROCESS_DAILY_TRADES
Command: /opt/trading/bin/process-daily-trades.sh
Schedule: Daily at 06:00 AM
Calendar: TRADING_BUSINESS_DAYS
Variables: 
  - INPUT_FILE=/opt/trading/data/trades-{TXDATE}.csv
  - LOG_FILE=/opt/trading/logs/process-{TXDATE}.log
Dependencies: PROD_TRADING_SOD_VALIDATE_FILES
```

---

## Summary

This training program provides **comprehensive coding standards** for all technologies used in capital market support systems:

1. **Shell Scripting** - Unix automation and batch processing
2. **TCL Programming** - Application scripting and integration
3. **SQL Database** - Data storage and querying
4. **Unix Files** - File and directory organization
5. **Tidal Scheduler** - Job scheduling and automation

**Key Takeaway**: Consistent naming and coding conventions lead to:
- Maintainable code
- Easier collaboration
- Fewer errors
- Professional codebase
- Faster onboarding for new team members

---

*Last Updated: 2024-10-28*  
*Refer to individual standards documents for complete details*

