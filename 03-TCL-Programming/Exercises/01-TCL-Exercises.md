# TCL Programming Exercises

## Level 1: Basics

### Exercise 1: Hello TCL
**Task**: Create a TCL script that displays your name, age, and current date.

**Answer**:
```tcl
#!/usr/bin/env tclsh

set name "John Smith"
set age 25

puts "Name: $name"
puts "Age: $age"
puts "Date: [clock format [clock seconds]]"
```

---

### Exercise 2: Calculator
**Task**: Create a calculator that adds, subtracts, multiplies, and divides two numbers.

**Answer**:
```tcl
#!/usr/bin/env tclsh

set num1 10
set num2 5

puts "Number 1: $num1"
puts "Number 2: $num2"
puts "Addition: [expr {$num1 + $num2}]"
puts "Subtraction: [expr {$num1 - $num2}]"
puts "Multiplication: [expr {$num1 * $num2}]"
puts "Division: [expr {$num1 / $num2}]"
```

---

## Level 2: Control Structures

### Exercise 3: Trade Classifier
**Task**: Write a procedure that classifies trades as SMALL (<$50K), MEDIUM ($50K-$100K), or LARGE (>$100K).

**Answer**:
```tcl
proc classifyTrade {value} {
    if {$value > 100000} {
        return "LARGE"
    } elseif {$value >= 50000} {
        return "MEDIUM"
    } else {
        return "SMALL"
    }
}

# Test
set tradeValue 75000
set category [classifyTrade $tradeValue]
puts "Trade value: \$$tradeValue - Category: $category"
```

---

### Exercise 4: Loop Practice
**Task**: Print numbers 1-10, skip multiples of 3.

**Answer**:
```tcl
for {set i 1} {$i <= 10} {incr i} {
    if {$i % 3 == 0} {
        continue
    }
    puts $i
}
```

---

## Level 3: Lists and Arrays

### Exercise 5: Symbol List
**Task**: Create a list of stock symbols, add a symbol, remove a symbol, and display all.

**Answer**:
```tcl
# Create list
set symbols {AAPL GOOGL MSFT}

# Display
puts "Original: $symbols"

# Add symbol
lappend symbols TSLA
puts "After adding TSLA: $symbols"

# Remove GOOGL (find and replace)
set index [lsearch $symbols GOOGL]
set symbols [lreplace $symbols $index $index]
puts "After removing GOOGL: $symbols"

# Display all
puts "Final list:"
foreach sym $symbols {
    puts "  - $sym"
}
```

---

### Exercise 6: Trade Statistics
**Task**: Create an array to store trade counts by symbol, then display statistics.

**Answer**:
```tcl
# Initialize
array set tradeCount {}

# Process trades
set trades {
    {T001 AAPL}
    {T002 GOOGL}
    {T003 AAPL}
    {T004 MSFT}
    {T005 AAPL}
}

foreach trade $trades {
    set symbol [lindex $trade 1]
    if {![info exists tradeCount($symbol)]} {
        set tradeCount($symbol) 0
    }
    incr tradeCount($symbol)
}

# Display
puts "Trade Count by Symbol:"
foreach symbol [lsort [array names tradeCount]] {
    puts "  $symbol: $tradeCount($symbol) trades"
}
```

---

## Level 4: File Operations

### Exercise 7: File Reader
**Task**: Read a file and display line count and content.

**Answer**:
```tcl
proc readAndDisplay {filename} {
    if {![file exists $filename]} {
        puts "Error: File not found"
        return
    }
    
    set fp [open $filename r]
    set lineCount 0
    
    puts "File contents:"
    while {[gets $fp line] >= 0} {
        incr lineCount
        puts "$lineCount: $line"
    }
    
    close $fp
    puts "\nTotal lines: $lineCount"
}

# Usage
readAndDisplay "data.txt"
```

---

### Exercise 8: CSV Parser
**Task**: Parse a CSV file with trade data and display formatted output.

**Answer**:
```tcl
proc parseTradeCSV {filename} {
    set fp [open $filename r]
    
    # Skip header
    gets $fp
    
    puts [format "%-8s %-8s %8s %10s" "TradeID" "Symbol" "Quantity" "Price"]
    puts [string repeat "-" 40]
    
    while {[gets $fp line] >= 0} {
        if {$line == ""} continue
        
        set fields [split $line ","]
        set id [lindex $fields 0]
        set symbol [lindex $fields 1]
        set qty [lindex $fields 2]
        set price [lindex $fields 3]
        
        puts [format "%-8s %-8s %8d %10.2f" $id $symbol $qty $price]
    }
    
    close $fp
}

# Usage
parseTradeCSV "trades.csv"
```

---

## Level 5: Advanced

### Exercise 9: Position Calculator
**Task**: Calculate positions from BUY/SELL trades.

**Answer**:
```tcl
proc calculatePositions {trades} {
    array set positions {}
    
    foreach trade $trades {
        lassign $trade symbol side qty
        
        if {![info exists positions($symbol)]} {
            set positions($symbol) 0
        }
        
        if {$side eq "BUY"} {
            incr positions($symbol) $qty
        } else {
            incr positions($symbol) [expr {-$qty}]
        }
    }
    
    return [array get positions]
}

# Test
set trades {
    {AAPL BUY 100}
    {GOOGL BUY 50}
    {AAPL SELL 30}
    {MSFT BUY 75}
    {AAPL BUY 50}
}

array set pos [calculatePositions $trades]

puts "Positions:"
foreach symbol [lsort [array names pos]] {
    set qty $pos($symbol)
    if {$qty != 0} {
        puts [format "  %-8s: %6d shares" $symbol $qty]
    }
}
```

---

### Exercise 10: Report Generator
**Task**: Generate a formatted report from trade data.

**Answer**:
```tcl
proc generateReport {inputFile outputFile} {
    set ifp [open $inputFile r]
    set ofp [open $outputFile w]
    
    # Header
    puts $ofp "==========================================="
    puts $ofp "           TRADE REPORT"
    puts $ofp "Date: [clock format [clock seconds]]"
    puts $ofp "==========================================="
    puts $ofp ""
    
    # Process trades
    gets $ifp  ;# Skip header
    
    set totalValue 0
    set tradeCount 0
    
    puts $ofp [format "%-8s %-8s %8s %10s %12s" \
        "TradeID" "Symbol" "Quantity" "Price" "Value"]
    puts $ofp [string repeat "-" 50]
    
    while {[gets $ifp line] >= 0} {
        if {$line == ""} continue
        
        set fields [split $line ","]
        lassign $fields id symbol qty price
        set value [expr {$qty * $price}]
        
        puts $ofp [format "%-8s %-8s %8d %10.2f %12.2f" \
            $id $symbol $qty $price $value]
        
        set totalValue [expr {$totalValue + $value}]
        incr tradeCount
    }
    
    puts $ofp [string repeat "-" 50]
    puts $ofp [format "Total: %d trades, Value: \$%.2f" \
        $tradeCount $totalValue]
    
    close $ifp
    close $ofp
    
    puts "Report generated: $outputFile"
}

# Usage
generateReport "trades.csv" "report.txt"
```

---

## Challenge Problems

### Challenge 1: Data Validator
Create a comprehensive trade data validator that checks:
- File exists and readable
- Header format
- Trade ID format (T####)
- Symbol format (1-5 uppercase letters)
- Quantity is positive integer
- Price is positive number

### Challenge 2: Trade Reconciliation
Write a script that compares two files (internal trades vs exchange confirmations) and reports breaks.

### Challenge 3: Performance Monitor
Create a script that monitors trade processing performance and generates statistics.

---

## Practice Tips

1. Type code, don't copy-paste
2. Test with sample data
3. Add error handling
4. Use meaningful variable names
5. Comment complex logic
6. Test edge cases

---

## Next Steps

1. Complete all exercises
2. Create variations
3. Apply to real project scenarios
4. Move to SQL documentation
5. Integrate TCL with database operations

**Keep practicing TCL!** 🚀

