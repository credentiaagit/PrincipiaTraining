# TCL Programming Sample Programs

This directory contains practical TCL programming examples for capital markets applications.

## Files Overview

### 01-trade-processor.tcl
**Purpose**: Process trading data using TCL
**Topics Covered**:
- TCL basics and syntax
- Variables and data types
- Control structures
- Lists and arrays
- String operations
- Basic file I/O

**Usage**:
```bash
tclsh 01-trade-processor.tcl
```

---

### 02-file-operations.tcl
**Purpose**: Comprehensive file I/O operations
**Topics Covered**:
- Reading files (whole file, line by line)
- Writing and appending to files
- File information and attributes
- CSV file processing
- Error handling with files
- Directory operations
- Log file processing
- Binary file operations

**Usage**:
```bash
tclsh 02-file-operations.tcl
```

**Key Functions**:
- `read_file_example`: Different methods to read files
- `write_file_example`: Writing formatted output
- `process_csv_file`: Parse and analyze CSV data
- `process_log_file`: Log analysis and statistics
- `directory_operations`: Working with directories

---

### 03-database-operations.tcl
**Purpose**: Database operations and SQL integration
**Topics Covered**:
- Database connections
- Simple and parameterized queries
- Insert, Update, Delete operations
- Transactions
- Aggregate functions
- Join operations
- Stored procedures
- Batch operations
- Error handling
- Connection pooling

**Usage**:
```bash
tclsh 03-database-operations.tcl
```

**Note**: This is a conceptual example. For real database operations:
```tcl
# Install TDBC package
package require tdbc::sqlite3
# or
package require tdbc::mysql
package require tdbc::postgres

# Create connection
set db [tdbc::sqlite3::connection new database.db]
```

---

## TCL Basics Quick Reference

### Variables
```tcl
set name "John"
set age 30
set price 150.25
```

### Lists
```tcl
set trades {T001 T002 T003}
lappend trades T004
set first [lindex $trades 0]
set length [llength $trades]
```

### Arrays
```tcl
array set prices {AAPL 150.25 GOOGL 2800.50}
set apple_price $prices(AAPL)
```

### Control Structures
```tcl
# If statement
if {$price > 100} {
    puts "High price"
} else {
    puts "Low price"
}

# For loop
for {set i 0} {$i < 10} {incr i} {
    puts $i
}

# Foreach loop
foreach trade $trades {
    puts $trade
}

# While loop
while {$count < 10} {
    incr count
}
```

### Procedures
```tcl
proc calculate_value {price quantity} {
    return [expr {$price * $quantity}]
}

set value [calculate_value 150.25 100]
```

### String Operations
```tcl
set str "Hello World"
set length [string length $str]
set upper [string toupper $str]
set lower [string tolower $str]
set substr [string range $str 0 4]
```

### File Operations
```tcl
# Open file
set fp [open "file.txt" r]  ;# r, w, a, r+, w+, a+

# Read file
set content [read $fp]

# Read line
gets $fp line

# Write to file
puts $fp "text"

# Close file
close $fp
```

---

## Running the Programs

### Make Scripts Executable
```bash
chmod +x *.tcl
```

### Run with tclsh
```bash
tclsh script.tcl
```

### Run as executable (if shebang is present)
```bash
./script.tcl
```

---

## Learning Path

1. **Start with**: `01-trade-processor.tcl`
   - Understand TCL syntax
   - Learn basic data structures
   - Practice control flow

2. **Progress to**: `02-file-operations.tcl`
   - Master file I/O
   - Learn CSV processing
   - Practice error handling

3. **Advanced**: `03-database-operations.tcl`
   - Database integration
   - Transaction management
   - Complex queries

---

## Capital Markets Use Cases

### 1. Trade Processing
```tcl
proc process_trade {trade_data} {
    lassign $trade_data trade_id symbol price qty
    
    # Validate trade
    if {$price <= 0 || $qty <= 0} {
        error "Invalid trade data"
    }
    
    # Calculate value
    set value [expr {$price * $qty}]
    
    # Log trade
    puts "Processed: $trade_id, Value: \$[format %.2f $value]"
}
```

### 2. Market Data Parser
```tcl
proc parse_market_data {filename} {
    set fp [open $filename r]
    
    while {[gets $fp line] >= 0} {
        set fields [split $line ","]
        lassign $fields symbol price volume
        
        # Process market data
        update_price $symbol $price
    }
    
    close $fp
}
```

### 3. Report Generator
```tcl
proc generate_report {data output_file} {
    set fp [open $output_file w]
    
    puts $fp "Daily Trading Report"
    puts $fp [string repeat "=" 50]
    
    foreach item $data {
        puts $fp [format "%-10s %10.2f" \
            [lindex $item 0] [lindex $item 1]]
    }
    
    close $fp
}
```

---

## Common Patterns

### Error Handling
```tcl
if {[catch {
    # Code that might fail
    set fp [open $filename r]
    set data [read $fp]
    close $fp
} error_msg]} {
    puts "Error: $error_msg"
    # Handle error
}
```

### Configuration File Reading
```tcl
proc read_config {config_file} {
    array set config {}
    
    set fp [open $config_file r]
    while {[gets $fp line] >= 0} {
        if {[regexp {^([^=]+)=(.+)$} $line -> key value]} {
            set config($key) [string trim $value]
        }
    }
    close $fp
    
    return [array get config]
}
```

### Logging Function
```tcl
proc log_message {level message} {
    set timestamp [clock format [clock seconds]]
    set log_entry "$timestamp \[$level\] $message"
    
    puts $log_entry
    
    set fp [open "application.log" a]
    puts $fp $log_entry
    close $fp
}
```

---

## TCL Packages for Capital Markets

### Database Access
```tcl
package require tdbc::sqlite3
package require tdbc::mysql
package require tdbc::postgres
```

### HTTP/REST APIs
```tcl
package require http
package require json
```

### XML Processing
```tcl
package require tdom
```

### Email
```tcl
package require mime
package require smtp
```

---

## Best Practices

✅ **Use `catch` for error handling**
```tcl
if {[catch {risky_operation} result]} {
    # Handle error
}
```

✅ **Always close file handles**
```tcl
set fp [open $file r]
# ... use file ...
close $fp
```

✅ **Use `lassign` for list unpacking**
```tcl
lassign $trade trade_id symbol price qty
```

✅ **Use `format` for formatted output**
```tcl
set output [format "%-10s %10.2f" $symbol $price]
```

✅ **Use procedures for reusable code**
```tcl
proc validate_trade {trade} {
    # validation logic
}
```

---

## Debugging TCL Scripts

### Print Variables
```tcl
puts "Debug: value = $value"
```

### Trace Variables
```tcl
trace add variable myvar write {puts "myvar changed"}
```

### Error Information
```tcl
catch {command} error_msg error_options
puts $error_msg
puts [dict get $error_options -errorinfo]
```

### Interactive Debugging
```bash
tclsh
% source script.tcl
% # Execute commands interactively
```

---

## Performance Tips

1. **Use `append` instead of `set` for string concatenation**
```tcl
append result $newdata
# vs
set result "$result$newdata"
```

2. **Use `lappend` for lists**
```tcl
lappend mylist $item
# vs
set mylist [concat $mylist $item]
```

3. **Cache frequently used values**
```tcl
set length [llength $list]
for {set i 0} {$i < $length} {incr i} {...}
```

---

## Testing Your TCL Code

### Simple Test Framework
```tcl
proc test {name code expected} {
    if {[catch {uplevel 1 $code} result]} {
        puts "✗ $name - Error: $result"
    } elseif {$result == $expected} {
        puts "✓ $name"
    } else {
        puts "✗ $name - Expected: $expected, Got: $result"
    }
}

# Usage
test "Add numbers" {expr {2 + 2}} 4
test "String length" {string length "hello"} 5
```

---

## References

1. **TCL Tutorial**: https://www.tcl.tk/man/tcl8.6/tutorial/tcltutorial.html
2. **TCL Commands**: https://www.tcl.tk/man/tcl8.6/TclCmd/contents.htm
3. **TDBC Documentation**: https://www.tcl.tk/man/tcl8.6/TdbcCmd/tdbc.htm
4. **TCL Wiki**: https://wiki.tcl-lang.org/
5. **Expect (TCL extension)**: https://core.tcl-lang.org/expect/index

---

## Exercises

After studying these programs, try to:

1. Create a TCL script to validate and filter trade data
2. Build a log analyzer that identifies patterns
3. Implement a configuration file parser
4. Create a report generator with multiple output formats
5. Build a simple ETL (Extract, Transform, Load) pipeline

---

**Next Steps**: Complete the exercises in the `Exercises` directory to master TCL programming.

