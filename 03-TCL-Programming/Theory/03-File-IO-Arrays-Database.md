# TCL File I/O, Arrays, and Database

## Table of Contents
1. [File Operations](#file-operations)
2. [Arrays](#arrays)
3. [Error Handling](#error-handling)
4. [Database Operations](#database-operations)
5. [Regular Expressions](#regular-expressions)
6. [Capital Markets Examples](#capital-markets-examples)

---

## File Operations

### Opening Files
```tcl
# Open for reading
set fp [open "file.txt" r]

# Open for writing (creates/overwrites)
set fp [open "file.txt" w]

# Open for appending
set fp [open "file.txt" a]

# Open for read and write
set fp [open "file.txt" r+]
```

### Reading Files

**Read entire file:**
```tcl
set fp [open "data.txt" r]
set content [read $fp]
close $fp
puts $content
```

**Read line by line:**
```tcl
set fp [open "data.txt" r]
while {[gets $fp line] >= 0} {
    puts "Line: $line"
}
close $fp
```

**Read with foreach:**
```tcl
set fp [open "data.txt" r]
set lines [split [read $fp] "\n"]
close $fp

foreach line $lines {
    if {$line != ""} {
        puts $line
    }
}
```

### Writing Files

**Write string:**
```tcl
set fp [open "output.txt" w]
puts $fp "Line 1"
puts $fp "Line 2"
close $fp
```

**Write without newline:**
```tcl
set fp [open "output.txt" w]
puts -nonewline $fp "Text without newline"
close $fp
```

**Append to file:**
```tcl
set fp [open "log.txt" a]
puts $fp "[clock format [clock seconds]]: Log entry"
close $fp
```

### File Commands

**Check if file exists:**
```tcl
if {[file exists "file.txt"]} {
    puts "File exists"
}
```

**File information:**
```tcl
# File size
set size [file size "file.txt"]

# File type
set type [file type "file.txt"]  ;# file, directory, link

# Is directory?
if {[file isdirectory "dirname"]} {
    puts "Is a directory"
}

# Is file?
if {[file isfile "filename"]} {
    puts "Is a file"
}

# File modification time
set mtime [file mtime "file.txt"]
puts [clock format $mtime]
```

**File operations:**
```tcl
# Copy file
file copy source.txt dest.txt

# Move/rename file
file rename old.txt new.txt

# Delete file
file delete file.txt

# Create directory
file mkdir newdir

# Remove directory
file delete -force dirname
```

### Path Operations
```tcl
# Get filename
set name [file tail "/path/to/file.txt"]  ;# file.txt

# Get directory
set dir [file dirname "/path/to/file.txt"]  ;# /path/to

# Get extension
set ext [file extension "file.txt"]  ;# .txt

# Get root name (without extension)
set root [file rootname "file.txt"]  ;# file

# Join paths
set path [file join "/home" "user" "data.txt"]
;# /home/user/data.txt
```

---

## Arrays

### Creating Arrays
```tcl
# Setting array elements
set employee(name) "John Smith"
set employee(age) 25
set employee(dept) "IT"
set employee(salary) 75000

# Multiple elements
array set employee {
    name "John Smith"
    age 25
    dept "IT"
    salary 75000
}
```

### Accessing Array Elements
```tcl
# Get value
puts $employee(name)  ;# John Smith

# Check if element exists
if {[info exists employee(bonus)]} {
    puts $employee(bonus)
} else {
    puts "Bonus not set"
}
```

### Array Operations

**Get all keys:**
```tcl
set keys [array names employee]
puts $keys  ;# name age dept salary
```

**Get all values:**
```tcl
foreach key [array names employee] {
    puts "$key: $employee($key)"
}
```

**Array size:**
```tcl
set size [array size employee]
puts "Array has $size elements"
```

**Delete element:**
```tcl
unset employee(age)
```

**Delete entire array:**
```tcl
unset employee
# or
array unset employee
```

**Copy array:**
```tcl
array set backup [array get employee]
```

### Iterating Over Arrays
```tcl
array set prices {
    AAPL 175.50
    GOOGL 140.25
    MSFT 380.75
}

# Method 1: foreach with array names
foreach symbol [array names prices] {
    puts "$symbol: \$$prices($symbol)"
}

# Method 2: foreach with array get
foreach {symbol price} [array get prices] {
    puts "$symbol: \$$price"
}
```

---

## Error Handling

### catch Command
```tcl
# Basic syntax
if {[catch {command} result]} {
    # Error occurred
    puts "Error: $result"
} else {
    # Success
    puts "Result: $result"
}
```

**Examples:**
```tcl
# File operations with error handling
if {[catch {open "nonexistent.txt" r} fp]} {
    puts "Error opening file: $fp"
} else {
    set content [read $fp]
    close $fp
}

# Division with error handling
if {[catch {expr {10 / 0}} result]} {
    puts "Error: $result"
} else {
    puts "Result: $result"
}
```

### error Command
```tcl
# Raise an error
proc divide {a b} {
    if {$b == 0} {
        error "Division by zero"
    }
    return [expr {$a / $b}]
}

if {[catch {divide 10 0} result]} {
    puts "Error: $result"
}
```

### try-trap (TCL 8.6+)
```tcl
try {
    set fp [open "file.txt" r]
    set data [read $fp]
} trap {POSIX ENOENT} {msg} {
    puts "File not found: $msg"
} finally {
    if {[info exists fp]} {
        close $fp
    }
}
```

---

## Database Operations

### Using TDBC (TCL Database Connectivity)

**Connect to database:**
```tcl
package require tdbc::sqlite3

# Connect to SQLite database
set db [tdbc::sqlite3::connection create db1 "trades.db"]
```

**Execute SQL:**
```tcl
# Create table
$db allrows {
    CREATE TABLE IF NOT EXISTS trades (
        trade_id TEXT PRIMARY KEY,
        symbol TEXT,
        quantity INTEGER,
        price REAL
    )
}

# Insert data
$db allrows {
    INSERT INTO trades VALUES ('T001', 'AAPL', 100, 175.50)
}

# Query data
set result [$db allrows {SELECT * FROM trades}]
foreach row $result {
    dict with row {
        puts "$trade_id: $symbol $quantity @ $price"
    }
}

# Close connection
$db close
```

**Parameterized queries:**
```tcl
set stmt [$db prepare {
    INSERT INTO trades VALUES (:id, :symbol, :qty, :price)
}]

$stmt execute id T002 symbol GOOGL qty 50 price 140.25
$stmt close
```

---

## Regular Expressions

### regexp Command

**Match pattern:**
```tcl
set text "Trade ID: T001"

if {[regexp {T[0-9]+} $text]} {
    puts "Contains trade ID"
}

# Extract matches
if {[regexp {T([0-9]+)} $text match number]} {
    puts "Trade number: $number"
}
```

**Multiple captures:**
```tcl
set email "user@example.com"

if {[regexp {([^@]+)@([^.]+)\.(.+)} $email match user domain tld]} {
    puts "User: $user"
    puts "Domain: $domain"
    puts "TLD: $tld"
}
```

### regsub Command

**Replace pattern:**
```tcl
set text "Price: $100"

# Replace first occurrence
set result [regsub {\$([0-9]+)} $text {USD \1}]
puts $result  ;# Price: USD 100

# Replace all occurrences
set result [regsub -all {\$} $text {USD }]
```

**Common patterns:**
```tcl
# Email validation
set pattern {^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$}

# Phone number
set pattern {^\+?[0-9]{10,}$}

# Trade ID
set pattern {^T[0-9]{4}$}

# Symbol (1-5 uppercase letters)
set pattern {^[A-Z]{1,5}$}
```

---

## Capital Markets Examples

### Example 1: Trade File Processor
```tcl
proc processTradefile {filename} {
    if {![file exists $filename]} {
        error "File not found: $filename"
    }
    
    set fp [open $filename r]
    set header [gets $fp]  ;# Skip header
    
    set trades {}
    while {[gets $fp line] >= 0} {
        if {$line == ""} continue
        
        set fields [split $line ","]
        set tradeId [lindex $fields 0]
        set symbol [lindex $fields 1]
        set qty [lindex $fields 2]
        set price [lindex $fields 3]
        
        # Calculate value
        set value [expr {$qty * $price}]
        
        lappend trades [list $tradeId $symbol $qty $price $value]
    }
    close $fp
    
    return $trades
}

# Usage
if {[catch {processTradefile "trades.csv"} trades]} {
    puts "Error: $trades"
} else {
    foreach trade $trades {
        lassign $trade id symbol qty price value
        puts "$id: $symbol, Value: \$$value"
    }
}
```

### Example 2: Position Calculator
```tcl
proc calculatePositions {tradeFile} {
    array set positions {}
    
    set fp [open $tradeFile r]
    gets $fp  ;# Skip header
    
    while {[gets $fp line] >= 0} {
        if {$line == ""} continue
        
        set fields [split $line ","]
        set symbol [lindex $fields 1]
        set side [lindex $fields 2]
        set qty [lindex $fields 3]
        
        if {![info exists positions($symbol)]} {
            set positions($symbol) 0
        }
        
        if {$side eq "BUY"} {
            incr positions($symbol) $qty
        } else {
            incr positions($symbol) -$qty
        }
    }
    close $fp
    
    return [array get positions]
}

# Usage
array set pos [calculatePositions "trades.csv"]
puts "========================================="
puts "End of Day Positions"
puts "========================================="
foreach {symbol qty} [array get pos] {
    if {$qty != 0} {
        set direction [expr {$qty > 0 ? "LONG" : "SHORT"}]
        puts [format "%-8s: %6d shares (%s)" $symbol $qty $direction]
    }
}
```

### Example 3: Report Generator
```tcl
proc generateDailyReport {tradeFile reportFile} {
    set fp [open $reportFile w]
    
    # Header
    puts $fp "========================================="
    puts $fp "Daily Trading Report"
    puts $fp "Date: [clock format [clock seconds] -format "%Y-%m-%d"]"
    puts $fp "========================================="
    puts $fp ""
    
    # Process trades
    array set stats {}
    set stats(totalTrades) 0
    set stats(totalValue) 0
    array set symbolCount {}
    
    set tfp [open $tradeFile r]
    gets $tfp  ;# Skip header
    
    while {[gets $tfp line] >= 0} {
        if {$line == ""} continue
        
        set fields [split $line ","]
        set symbol [lindex $fields 1]
        set qty [lindex $fields 2]
        set price [lindex $fields 3]
        set value [expr {$qty * $price}]
        
        incr stats(totalTrades)
        set stats(totalValue) [expr {$stats(totalValue) + $value}]
        
        if {![info exists symbolCount($symbol)]} {
            set symbolCount($symbol) 0
        }
        incr symbolCount($symbol)
    }
    close $tfp
    
    # Write summary
    puts $fp "SUMMARY:"
    puts $fp "--------"
    puts $fp "Total Trades: $stats(totalTrades)"
    puts $fp [format "Total Value: \$%.2f" $stats(totalValue)]
    puts $fp ""
    
    # Top symbols
    puts $fp "TOP SYMBOLS:"
    puts $fp "------------"
    set sorted [lsort -integer -decreasing -stride 2 -index 1 [array get symbolCount]]
    foreach {symbol count} [lrange $sorted 0 9] {
        puts $fp [format "%-8s: %d trades" $symbol $count]
    }
    
    close $fp
    puts "Report generated: $reportFile"
}

# Usage
generateDailyReport "trades.csv" "daily_report.txt"
```

### Example 4: Data Validator
```tcl
proc validateTradeData {filename} {
    set errors 0
    set lineNum 0
    
    set fp [open $filename r]
    gets $fp header
    
    # Validate header
    set expectedHeader "TradeID,Symbol,Quantity,Price"
    if {$header ne $expectedHeader} {
        puts "ERROR: Invalid header"
        puts "Expected: $expectedHeader"
        puts "Got: $header"
        incr errors
    }
    
    # Validate data
    while {[gets $fp line] >= 0} {
        incr lineNum
        if {$line == ""} continue
        
        set fields [split $line ","]
        if {[llength $fields] != 4} {
            puts "ERROR line $lineNum: Wrong number of fields"
            incr errors
            continue
        }
        
        lassign $fields id symbol qty price
        
        # Validate trade ID
        if {![regexp {^T[0-9]{4}$} $id]} {
            puts "ERROR line $lineNum: Invalid trade ID: $id"
            incr errors
        }
        
        # Validate symbol
        if {![regexp {^[A-Z]{1,5}$} $symbol]} {
            puts "ERROR line $lineNum: Invalid symbol: $symbol"
            incr errors
        }
        
        # Validate quantity
        if {![string is integer -strict $qty] || $qty <= 0} {
            puts "ERROR line $lineNum: Invalid quantity: $qty"
            incr errors
        }
        
        # Validate price
        if {![string is double -strict $price] || $price <= 0} {
            puts "ERROR line $lineNum: Invalid price: $price"
            incr errors
        }
    }
    close $fp
    
    if {$errors == 0} {
        puts "✓ Validation PASSED"
        return 0
    } else {
        puts "✗ Validation FAILED: $errors errors"
        return 1
    }
}

# Usage
if {[catch {validateTradeData "trades.csv"} result]} {
    puts "Error: $result"
} else {
    if {$result == 0} {
        puts "File is valid"
    }
}
```

---

## Best Practices

✅ Always close files after use

✅ Use `catch` for error handling

✅ Validate input data

✅ Use arrays for key-value data

✅ Use regular expressions for pattern matching

✅ Add logging for production scripts

✅ Handle edge cases (empty files, missing data)

---

## Quick Reference

| Operation | Command | Example |
|-----------|---------|---------|
| Open file | `open file mode` | `set fp [open "f.txt" r]` |
| Read file | `read $fp` | `set data [read $fp]` |
| Read line | `gets $fp line` | `gets $fp line` |
| Write file | `puts $fp text` | `puts $fp "data"` |
| Close file | `close $fp` | `close $fp` |
| File exists | `file exists file` | `file exists "f.txt"` |
| Array set | `set arr(key) val` | `set emp(name) "John"` |
| Array names | `array names arr` | `array names employee` |
| Error handling | `catch {cmd} result` | `catch {expr 1/0} err` |
| Regex match | `regexp pattern str` | `regexp {[0-9]+} $text` |

---

**This completes TCL Theory!**

Next: Sample programs and exercises in the respective directories.

