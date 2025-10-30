# TCL Coding Standards

## Table of Contents
1. [Naming Conventions](#naming-conventions)
2. [File Naming](#file-naming)
3. [Indentation and Formatting](#indentation-and-formatting)
4. [Comments and Documentation](#comments-and-documentation)
5. [Variable Declarations](#variable-declarations)
6. [Procedure Standards](#procedure-standards)
7. [Error Handling](#error-handling)
8. [String Handling](#string-handling)
9. [List and Array Standards](#list-and-array-standards)
10. [Capital Markets Specific Standards](#capital-markets-specific-standards)

---

## Naming Conventions

### Variable Naming

**Local Variables**
- **Convention**: `camelCase` (start with lowercase)
- **Why**: TCL community standard, readable
- **Examples**:
```tcl
# Good
set tradeCount 0
set fileName "trades.csv"
set currentDate [clock format [clock seconds] -format "%Y-%m-%d"]
set totalValue 0.0

# Bad
set trade_count 0       # Snake case (used in other languages)
set TradeCount 0        # PascalCase (looks like constant)
set FILENAME "..."      # All caps (looks like constant)
set tc 0                # Too cryptic
```

**Global Variables**
- **Convention**: `camelCase` with namespace prefix or `UPPER_CASE` for true constants
- **Examples**:
```tcl
# Good - Namespaced globals
namespace eval trading {
    variable configDir "/opt/trading/config"
    variable maxRetries 3
    variable dbConnection ""
}

# Good - Global constants
set MAX_TRADE_VALUE 1000000
set MARKET_OPEN_HOUR 9
set SETTLEMENT_DAYS 2

# Bad - Global without namespace
set configDir "/opt/trading"  # Can collide with other code
```

**Array Variables**
- **Convention**: `camelCase` with descriptive names
- **Examples**:
```tcl
# Good
array set tradeData {
    id "T001"
    symbol "AAPL"
    quantity 100
}

array set prices {}
set prices(AAPL) 175.50
set prices(GOOGL) 140.25

# Bad
array set td {}          # Not descriptive
array set TRADEDATA {}   # Wrong case
```

---

### Procedure Naming

**Procedure Names**
- **Convention**: `camelCase` for regular procedures, `PascalCase` for object-oriented style
- **Prefix conventions**:
  - `validate*` - Validation procedures
  - `process*` - Processing procedures
  - `get*` - Getter procedures
  - `set*` - Setter procedures
  - `is*` or `has*` - Boolean check procedures
  - `log*` - Logging procedures

**Examples**:
```tcl
# Good - camelCase procedures
proc validateTradeFile {fileName} {
    # Validation logic
}

proc processTrades {inputFile outputDir} {
    # Processing logic
}

proc getTradeCount {file} {
    # Return count
}

proc isMarketOpen {} {
    # Return true/false
}

proc logError {message} {
    # Log error
}

# Also acceptable - PascalCase for OO style
proc TradeProcessor::ProcessFile {fileName} {
    # Object-oriented style
}

# Bad - Poor naming
proc valtrdfile {file} {}      # Too cryptic
proc process_trades {file} {}  # Snake case
proc pt {file} {}              # Meaningless abbreviation
```

**Private/Internal Procedures**
- **Convention**: Prefix with underscore `_procedureName` or place in private namespace
```tcl
# Good - Private procedure
proc _cleanupTempFiles {} {
    file delete {*}[glob -nocomplain /tmp/trade_*]
}

# Good - Private namespace
namespace eval trading::private {
    proc cleanup {} {
        # Internal cleanup
    }
}
```

---

## File Naming

### TCL Script Files

**Extension**: `.tcl` (required)
**Convention**: `camelCase.tcl` or `kebab-case.tcl`

**Examples**:
```tcl
# Good - camelCase (preferred in TCL)
processTrades.tcl
validateMarketData.tcl
generateDailyReport.tcl

# Also acceptable - kebab-case
process-trades.tcl
validate-market-data.tcl

# Bad
ProcessTrades.tcl       # PascalCase
process_trades.tcl      # Snake case (not TCL convention)
pt.tcl                  # Not descriptive
processTrades           # Missing .tcl extension
```

### Package Files

**Convention**: Package name matches file name
```tcl
# File: trading.tcl
package provide Trading 1.0

namespace eval ::Trading {
    # Package code
}

# File: tradeValidator.tcl
package provide TradeValidator 1.0

namespace eval ::TradeValidator {
    # Package code
}
```

---

## Indentation and Formatting

### Indentation

**Standard**: 4 spaces (NOT tabs)
```tcl
# Good - 4 space indentation
proc processFile {fileName} {
    if {[file exists $fileName]} {
        set fp [open $fileName r]
        while {[gets $fp line] >= 0} {
            puts $line
        }
        close $fp
    }
}

# Bad - Inconsistent indentation
proc processFile {fileName} {
  if {[file exists $fileName]} {    # 2 spaces
      set fp [open $fileName r]      # 6 spaces
    while {[gets $fp line] >= 0} {  # 4 spaces
      puts $line                     # 6 spaces
    }
  }
}
```

### Brace Placement

**Standard**: Opening brace on same line, closing brace on new line
```tcl
# Good - TCL style
proc myProc {arg1 arg2} {
    # code here
}

if {$condition} {
    # true block
} else {
    # false block
}

# Bad - K&R style (not TCL convention)
proc myProc {arg1 arg2}
{
    # code here
}
```

### Spacing

**Inside braces**: Space after opening brace, space before closing brace
```tcl
# Good
if {$x > 10} {
    puts "Greater"
}

set result [expr {$a + $b}]

# Bad - No spaces
if {$x>10} {
    puts "Greater"
}

set result [expr {$a+$b}]
```

**Around operators**:
```tcl
# Good
set x [expr {$y + 5}]
if {$a == $b} {
    # code
}

# Bad
set x [expr {$y+5}]
if {$a==$b} {
```

### Line Length

**Maximum**: 80-100 characters
```tcl
# Good - Readable length
if {$tradeStatus eq "COMPLETED" && $settlementStatus eq "PENDING"} {
    processSettlement $tradeId
}

# Good - Long line broken
if {$tradeStatus eq "COMPLETED" && \
    $settlementStatus eq "PENDING" && \
    $approvalStatus eq "APPROVED"} {
    processSettlement $tradeId
}

# Bad - Too long
if {$tradeStatus eq "COMPLETED" && $settlementStatus eq "PENDING" && $approvalStatus eq "APPROVED" && $riskCheck eq "PASSED"} {
```

### Command Substitution

**Preferred**: Use square brackets `[command]`
```tcl
# Good
set currentDate [clock format [clock seconds]]
set fileSize [file size $fileName]
set result [calculateValue $a $b]

# Avoid - Using eval
eval set x $value  # Can be dangerous
```

---

## Comments and Documentation

### File Header

**Required** at the top of every script:
```tcl
#!/usr/bin/env tclsh
#################################################################
# File: processTrades.tcl
# Description: Process daily trading files and generate reports
# Author: Trading Systems Team
# Date: 2024-10-28
# Version: 1.0
#
# Usage: tclsh processTrades.tcl <inputFile> [outputDir]
#
# Arguments:
#   inputFile  - CSV file containing trade data
#   outputDir  - Directory for output (optional, default: ./output)
#
# Examples:
#   tclsh processTrades.tcl trades.csv
#   tclsh processTrades.tcl trades.csv /opt/reports
#
# Dependencies:
#   - TCL 8.6+
#   - csv package
#
# Exit Codes:
#   0 - Success
#   1 - Invalid arguments
#   2 - File not found
#   3 - Processing error
#################################################################
```

### Procedure Documentation

**Required** for all non-trivial procedures:
```tcl
#################################################################
# Procedure: validateTradeFile
# Description: Validates trade file format and content
# Arguments:
#   fileName - Path to trade file
# Returns:
#   1 if valid, 0 if invalid
# Example:
#   if {[validateTradeFile $file]} {
#       processFile $file
#   }
#################################################################
proc validateTradeFile {fileName} {
    # Check file exists
    if {![file exists $fileName]} {
        logError "File not found: $fileName"
        return 0
    }
    
    # Check file format
    # ... validation logic ...
    
    return 1
}
```

### Inline Comments

**Good comments** explain WHY, not WHAT:
```tcl
# Good - Explains reasoning
# Use background process to avoid blocking main thread
exec process_large_file $file &

# Trading hours are 9:30 AM to 4:00 PM EST
if {$hour >= 9 && $hour < 16} {
    # Process trade
}

# Good - Complex calculation
# Calculate P&L: (currentPrice - purchasePrice) * quantity - fees
set pnl [expr {($currentPrice - $purchasePrice) * $quantity - $fees}]

# Bad - States the obvious
# Increment counter by 1
incr count

# Bad - Redundant
# Loop through files
foreach file [glob *.csv] {
```

---

## Variable Declarations

### Variable Scope

```tcl
# Good - Explicit variable scope
proc myProc {arg1 arg2} {
    variable globalVar  ;# Access namespace variable
    upvar myArray arr   ;# Access caller's array
    
    # Local variables
    set localVar 10
    set result [expr {$arg1 + $arg2}]
    
    return $result
}

# Good - Namespace variables
namespace eval trading {
    variable configDir "/opt/trading"
    variable maxRetries 3
    
    proc getConfig {} {
        variable configDir
        return $configDir
    }
}
```

### Variable Initialization

```tcl
# Good - Initialize variables
set count 0
set fileName ""
set status "PENDING"
set values [list]

# Good - Check before use
if {[info exists myVar]} {
    # Use $myVar
} else {
    set myVar "default"
}

# Bad - Uninitialized
incr count  ;# Error if count doesn't exist
```

---

## Procedure Standards

### Procedure Structure

```tcl
# Standard procedure template
proc myProcedure {param1 param2 {optional ""}} {
    # 1. Input validation
    if {$param1 eq ""} {
        error "param1 is required"
    }
    
    # 2. Variable declarations
    set result ""
    set tempValue 0
    
    # 3. Main logic
    set result [processValue $param1 $param2]
    
    # 4. Return value
    return $result
}
```

### Argument Handling

**Default Arguments**:
```tcl
# Good - Default arguments
proc processFile {fileName {outputDir "./output"} {verbose 0}} {
    puts "Processing: $fileName"
    puts "Output dir: $outputDir"
    if {$verbose} {
        puts "Verbose mode enabled"
    }
}

# Call with defaults
processFile "trades.csv"
processFile "trades.csv" "/opt/output"
processFile "trades.csv" "/opt/output" 1
```

**Variable Arguments**:
```tcl
# Good - Using args
proc logMessage {level message args} {
    set timestamp [clock format [clock seconds]]
    puts "$timestamp [$level] $message"
    
    # Process additional arguments
    foreach arg $args {
        puts "  $arg"
    }
}

# Usage
logMessage "INFO" "Processing trade" "TradeID: T001" "Symbol: AAPL"
```

### Return Values

```tcl
# Good - Explicit returns
proc divide {a b} {
    if {$b == 0} {
        error "Division by zero"
    }
    return [expr {$a / $b}]
}

# Good - Return multiple values (list)
proc getTradeInfo {tradeId} {
    return [list $symbol $quantity $price]
}

# Usage
lassign [getTradeInfo "T001"] symbol qty price

# Good - Return status with result
proc validateTrade {trade} {
    # validation logic
    if {$valid} {
        return [list 1 "Valid"]
    } else {
        return [list 0 "Invalid: $reason"]
    }
}

# Usage
lassign [validateTrade $trade] status message
```

---

## Error Handling

### Error Command

```tcl
# Good - Descriptive errors
proc openFile {fileName} {
    if {![file exists $fileName]} {
        error "File not found: $fileName"
    }
    
    if {[catch {open $fileName r} fp]} {
        error "Cannot open file: $fileName - $fp"
    }
    
    return $fp
}
```

### Catch for Error Handling

```tcl
# Good - Catch errors
if {[catch {
    set fp [open $fileName r]
    set data [read $fp]
    close $fp
} result]} {
    puts "Error reading file: $result"
    return 0
}

# Good - Named error variable
if {[catch {divide $a $b} result errorInfo]} {
    puts "Error: $result"
    puts "Stack trace: $errorInfo"
}

# Good - Try-catch pattern (TCL 8.6+)
try {
    set fp [open $fileName r]
    set data [read $fp]
} trap {POSIX ENOENT} {msg} {
    puts "File not found: $msg"
} finally {
    if {[info exists fp]} {
        close $fp
    }
}
```

### Error Logging

```tcl
# Good - Consistent error logging
proc logError {message} {
    set timestamp [clock format [clock seconds] -format "%Y-%m-%d %H:%M:%S"]
    set logFile "/var/log/trading.log"
    
    if {[catch {
        set fp [open $logFile a]
        puts $fp "\[$timestamp\] ERROR: $message"
        close $fp
    }]} {
        puts stderr "ERROR: $message (failed to write to log)"
    }
}
```

---

## String Handling

### String Comparison

```tcl
# Good - Use eq for string comparison
if {$status eq "COMPLETED"} {
    # process
}

# Good - Use == for numeric
if {$count == 100} {
    # process
}

# Bad - Using == for strings (works but not best practice)
if {$status == "COMPLETED"} {
    # works but eq is preferred
}

# Good - Case-insensitive comparison
if {[string equal -nocase $input "yes"]} {
    # process
}
```

### String Building

```tcl
# Good - Use append for efficiency
set message ""
append message "Trade: " $tradeId "\n"
append message "Symbol: " $symbol "\n"
append message "Quantity: " $quantity

# Good - Use format
set message [format "Trade %s: %s x %d @ $%.2f" \
    $tradeId $symbol $quantity $price]

# Bad - Repeated concatenation (inefficient)
set message ""
set message "$message Trade: $tradeId\n"
set message "$message Symbol: $symbol\n"
```

### String Substitution

```tcl
# Good - Using subst for variable substitution
set template "Trade: $tradeId, Symbol: $symbol, Qty: $quantity"
set message [subst $template]

# Good - Braces to prevent substitution
set literal {$variable}  ;# Stores literal "$variable"
set value "$variable"    ;# Substitutes value of variable
```

---

## List and Array Standards

### List Operations

```tcl
# Good - List creation
set trades [list "T001" "T002" "T003"]
set symbols {AAPL GOOGL MSFT}  ;# Shorthand

# Good - List access
set firstTrade [lindex $trades 0]
set lastTrade [lindex $trades end]

# Good - List iteration
foreach trade $trades {
    puts "Processing: $trade"
}

# Good - List manipulation
lappend trades "T004"
set trades [linsert $trades 1 "T001.5"]
set trades [lreplace $trades 0 0]  ;# Remove first element
```

### Array Operations

```tcl
# Good - Array creation
array set tradeInfo {
    id "T001"
    symbol "AAPL"
    quantity 100
    price 175.50
}

# Good - Array access
if {[info exists tradeInfo(symbol)]} {
    set symbol $tradeInfo(symbol)
}

# Good - Array iteration
foreach {key value} [array get tradeInfo] {
    puts "$key: $value"
}

# Good - Dictionary (TCL 8.5+, preferred over arrays)
set trade [dict create \
    id "T001" \
    symbol "AAPL" \
    quantity 100 \
    price 175.50]

set symbol [dict get $trade symbol]
dict set trade status "COMPLETED"
```

---

## Capital Markets Specific Standards

### File Naming for Trading Systems

```tcl
# Trade files
set fileName "TRADES-${exchange}-${date}-${sequence}.csv"
# Example: TRADES-NYSE-20241028-001.csv

# Report files
set reportFile "REPORT-${reportType}-${date}.pdf"
# Example: REPORT-DAILY-SUMMARY-20241028.pdf
```

### Variable Naming for Trading

```tcl
# Good - Clear trading variables
set MARKET_OPEN_HOUR 9
set MARKET_CLOSE_HOUR 16
set MAX_TRADE_VALUE 1000000
set SETTLEMENT_DAYS 2

set tickerSymbol "AAPL"
set tradeQuantity 100
set tradePrice 175.50
set orderType "LIMIT"
set executionTime [clock format [clock seconds]]
```

### Procedure Naming for Trading

```tcl
# Good - Domain-specific procedure names
proc validateTradeLimits {trade} {}
proc checkMarketHours {} {}
proc calculateSettlementDate {tradeDate} {}
proc getCurrentPosition {symbol} {}
proc updateTradeStatus {tradeId status} {}
proc generateRiskReport {portfolio} {}
```

### Financial Calculations

```tcl
# Good - Explicit precision for money
package require math

proc calculatePnL {purchasePrice currentPrice quantity fees} {
    # Use expr with explicit decimal points
    set pnl [expr {($currentPrice - $purchasePrice) * $quantity - $fees}]
    
    # Round to 2 decimal places for currency
    return [format "%.2f" $pnl]
}

# Good - Handle currency
proc formatCurrency {amount} {
    return [format "$%.2f" $amount]
}
```

---

## Package and Namespace Standards

### Package Structure

```tcl
# Good - Well-structured package
package provide Trading 1.0

namespace eval ::Trading {
    # Public procedures
    namespace export processFile validateTrade
    
    # Private variables
    variable configDir "/opt/trading"
    variable logFile "/var/log/trading.log"
    
    # Public procedures
    proc processFile {fileName} {
        # Implementation
    }
    
    proc validateTrade {trade} {
        # Implementation
    }
    
    # Private procedures
    namespace eval private {
        proc cleanup {} {
            # Internal cleanup
        }
    }
}
```

---

## Code Organization

### Standard Script Structure

```tcl
#!/usr/bin/env tclsh
#################################################################
# Script documentation
#################################################################

# Package requirements
package require Tcl 8.6
package require csv

#================================================================
# CONSTANTS
#================================================================
set SCRIPT_NAME [file tail [info script]]
set SCRIPT_DIR [file dirname [info script]]
set LOG_FILE "/var/log/${SCRIPT_NAME}.log"

#================================================================
# GLOBAL VARIABLES
#================================================================
set verbose 0
set dryRun 0

#================================================================
# PROCEDURES
#================================================================

# Logging procedures
proc logInfo {message} {
    global LOG_FILE
    set timestamp [clock format [clock seconds] -format "%Y-%m-%d %H:%M:%S"]
    puts "\[$timestamp\] INFO: $message"
}

proc logError {message} {
    global LOG_FILE
    set timestamp [clock format [clock seconds] -format "%Y-%m-%d %H:%M:%S"]
    puts stderr "\[$timestamp\] ERROR: $message"
}

# Usage information
proc usage {} {
    global SCRIPT_NAME
    puts "Usage: $SCRIPT_NAME \[OPTIONS\] <arguments>"
    puts ""
    puts "Description:"
    puts "    Brief description"
    puts ""
    puts "Options:"
    puts "    -h, --help          Show this help"
    puts "    -v, --verbose       Verbose output"
    puts ""
    exit 0
}

# Main procedure
proc main {argv} {
    global verbose dryRun
    
    # Parse arguments
    foreach arg $argv {
        switch -exact -- $arg {
            -h - --help {
                usage
            }
            -v - --verbose {
                set verbose 1
            }
            default {
                lappend positionalArgs $arg
            }
        }
    }
    
    # Validate arguments
    if {![info exists positionalArgs] || [llength $positionalArgs] == 0} {
        logError "Missing required arguments"
        usage
    }
    
    # Main logic here
    logInfo "Processing started"
    
    # ...
    
    logInfo "Processing completed"
}

#================================================================
# MAIN EXECUTION
#================================================================
if {[info exists argv0] && $argv0 eq [info script]} {
    main $argv
}
```

---

## Quick Reference

### Naming Summary

| Element | Convention | Example |
|---------|-----------|---------|
| Variables | `camelCase` | `tradeCount` |
| Constants | `UPPER_CASE` | `MAX_RETRIES` |
| Procedures | `camelCase` | `processFile` |
| Private procedures | `_camelCase` | `_cleanup` |
| Namespaces | `PascalCase` | `Trading::Utils` |
| Files | `camelCase.tcl` | `processTrades.tcl` |
| Packages | `PascalCase` | `Trading` |

### Formatting Summary

- **Indentation**: 4 spaces
- **Braces**: Same line, with spaces inside `{ }`
- **Line length**: 80-100 characters
- **Comparison**: `eq` for strings, `==` for numbers

### Common Patterns

```tcl
# String comparison
if {$var eq "value"} {}

# Numeric comparison
if {$num == 10} {}

# List iteration
foreach item $list {}

# Array access
if {[info exists arr(key)]} {}

# Error handling
if {[catch {command} result]} {}

# File operations
if {[file exists $fileName]} {}
```

---

*Last Updated: 2024-10-28*  
*Follow these standards for consistent, maintainable TCL code*

