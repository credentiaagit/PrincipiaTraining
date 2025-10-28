# TCL Control Structures and Lists

## Table of Contents
1. [Conditional Statements](#conditional-statements)
2. [Loops](#loops)
3. [List Operations](#list-operations)
4. [Procedures (Functions)](#procedures-functions)
5. [String Operations](#string-operations)

---

## Conditional Statements

### if Statement
```tcl
if {condition} {
    # code if true
}

# Example
set age 25
if {$age >= 18} {
    puts "Adult"
}
```

### if-else Statement
```tcl
if {condition} {
    # code if true
} else {
    # code if false
}

# Example
set score 85
if {$score >= 60} {
    puts "Pass"
} else {
    puts "Fail"
}
```

### if-elseif-else Statement
```tcl
if {condition1} {
    # code
} elseif {condition2} {
    # code
} else {
    # code
}

# Example: Grade calculator
set score 85
if {$score >= 90} {
    set grade "A"
} elseif {$score >= 80} {
    set grade "B"
} elseif {$score >= 70} {
    set grade "C"
} else {
    set grade "F"
}
puts "Grade: $grade"
```

### Comparison Operators
```tcl
==    # Equal
!=    # Not equal
>     # Greater than
<     # Less than
>=    # Greater than or equal
<=    # Less than or equal
```

### Logical Operators
```tcl
&&    # AND
||    # OR
!     # NOT

# Examples
if {$age > 18 && $salary > 30000} {
    puts "Eligible"
}

if {$age < 18 || $age > 65} {
    puts "Special category"
}

if {!$is_active} {
    puts "Inactive"
}
```

### switch Statement
```tcl
switch $variable {
    pattern1 {
        # code
    }
    pattern2 {
        # code
    }
    default {
        # default code
    }
}

# Example
set fruit "apple"
switch $fruit {
    apple {
        puts "Red or green"
    }
    banana {
        puts "Yellow"
    }
    default {
        puts "Unknown fruit"
    }
}

# Pattern matching
switch -glob $filename {
    *.txt {
        puts "Text file"
    }
    *.csv {
        puts "CSV file"
    }
}
```

---

## Loops

### for Loop
```tcl
for {initialization} {condition} {increment} {
    # code
}

# Example: Print 1 to 10
for {set i 1} {$i <= 10} {incr i} {
    puts $i
}

# Countdown
for {set i 10} {$i >= 1} {incr i -1} {
    puts "Countdown: $i"
}
```

### while Loop
```tcl
while {condition} {
    # code
}

# Example
set count 1
while {$count <= 5} {
    puts "Count: $count"
    incr count
}
```

### foreach Loop
```tcl
foreach var list {
    # code
}

# Example: Iterate over list
set fruits {apple banana orange}
foreach fruit $fruits {
    puts "Fruit: $fruit"
}

# Multiple variables
set pairs {name John age 25 city NYC}
foreach {key value} $pairs {
    puts "$key: $value"
}

# Nested foreach
foreach symbol {AAPL GOOGL MSFT} {
    foreach side {BUY SELL} {
        puts "$symbol $side"
    }
}
```

### break and continue
```tcl
# break: exit loop
for {set i 1} {$i <= 10} {incr i} {
    if {$i == 5} {
        break
    }
    puts $i
}

# continue: skip iteration
for {set i 1} {$i <= 10} {incr i} {
    if {$i % 2 == 0} {
        continue
    }
    puts "$i is odd"
}
```

---

## List Operations

### Creating Lists
```tcl
# Simple list
set fruits {apple banana orange}

# list command
set numbers [list 1 2 3 4 5]

# Empty list
set empty {}
```

### Accessing List Elements
```tcl
set fruits {apple banana orange grape}

# Get element by index (0-based)
set first [lindex $fruits 0]  ;# apple
set second [lindex $fruits 1] ;# banana

# Last element
set last [lindex $fruits end]   ;# grape
set second_last [lindex $fruits end-1]  ;# orange
```

### List Length
```tcl
set fruits {apple banana orange}
set count [llength $fruits]  ;# 3
puts "Count: $count"
```

### Appending to List
```tcl
set fruits {apple banana}

# lappend: append elements
lappend fruits orange grape
puts $fruits  ;# apple banana orange grape

# Multiple elements
lappend fruits kiwi mango
```

### List Insertion
```tcl
set fruits {apple orange}

# linsert: insert at position
set fruits [linsert $fruits 1 banana]
puts $fruits  ;# apple banana orange
```

### List Replacement
```tcl
set numbers {1 2 3 4 5}

# lreplace: replace elements
set numbers [lreplace $numbers 2 3 30 40]
puts $numbers  ;# 1 2 30 40 5
```

### List Search
```tcl
set fruits {apple banana orange}

# lsearch: find index
set index [lsearch $fruits banana]  ;# 1

# Return -1 if not found
set index [lsearch $fruits grape]   ;# -1

# Pattern matching
set index [lsearch -glob $fruits "a*"]  ;# 0 (apple)
```

### List Sorting
```tcl
set numbers {5 2 8 1 9}
set sorted [lsort $numbers]
puts $sorted  ;# 1 2 5 8 9

# Reverse order
set sorted [lsort -decreasing $numbers]  ;# 9 8 5 2 1

# String sort
set names {John Alice Bob}
set sorted [lsort $names]  ;# Alice Bob John
```

### List Range
```tcl
set numbers {1 2 3 4 5 6 7 8 9 10}

# lrange: get sublist
set sub [lrange $numbers 2 5]
puts $sub  ;# 3 4 5 6

# From start
set sub [lrange $numbers 0 2]  ;# 1 2 3

# To end
set sub [lrange $numbers 5 end]  ;# 6 7 8 9 10
```

### Joining Lists
```tcl
set list1 {1 2 3}
set list2 {4 5 6}

# concat: combine lists
set combined [concat $list1 $list2]
puts $combined  ;# 1 2 3 4 5 6

# join: join with delimiter
set csv [join $combined ","]
puts $csv  ;# 1,2,3,4,5,6
```

### Splitting Strings
```tcl
# split: string to list
set csv "apple,banana,orange"
set fruits [split $csv ","]
puts $fruits  ;# apple banana orange

# Split by whitespace
set text "Hello World TCL"
set words [split $text]
puts $words  ;# Hello World TCL
```

---

## Procedures (Functions)

### Defining Procedures
```tcl
proc procedureName {arguments} {
    # code
    return value
}

# Example
proc greet {name} {
    puts "Hello, $name!"
}

greet "John"  ;# Hello, John!
```

### Multiple Parameters
```tcl
proc add {a b} {
    return [expr {$a + $b}]
}

set result [add 5 3]
puts $result  ;# 8
```

### Default Parameters
```tcl
proc greet {name {greeting "Hello"}} {
    puts "$greeting, $name!"
}

greet "John"              ;# Hello, John!
greet "Mary" "Hi"         ;# Hi, Mary!
```

### Variable Number of Arguments
```tcl
proc sum {args} {
    set total 0
    foreach num $args {
        set total [expr {$total + $num}]
    }
    return $total
}

puts [sum 1 2 3]       ;# 6
puts [sum 10 20 30 40] ;# 100
```

### Local vs Global Variables
```tcl
# Global variable
set global_var "I am global"

proc myProc {} {
    # Local variable
    set local_var "I am local"
    
    # Access global
    global global_var
    puts $global_var
    
    # Modify global
    set global_var "Modified"
}

myProc
puts $global_var  ;# Modified
```

### Variable Scope with upvar
```tcl
proc increment {varName} {
    upvar $varName var
    incr var
}

set count 10
increment count
puts $count  ;# 11
```

---

## String Operations

### String Length
```tcl
set text "Hello, World!"
set len [string length $text]
puts $len  ;# 13
```

### Substring
```tcl
set text "Hello, World!"

# Get substring
set sub [string range $text 0 4]
puts $sub  ;# Hello

# From position to end
set sub [string range $text 7 end]
puts $sub  ;# World!
```

### String Search
```tcl
set text "Hello, World!"

# Find substring
set pos [string first "World" $text]
puts $pos  ;# 7

# Return -1 if not found
set pos [string first "TCL" $text]
puts $pos  ;# -1
```

### String Replacement
```tcl
set text "Hello, World!"

# Replace substring
set new [string map {"World" "TCL"} $text]
puts $new  ;# Hello, TCL!

# Multiple replacements
set text "apple banana apple"
set new [string map {"apple" "orange"} $text]
puts $new  ;# orange banana orange
```

### Case Conversion
```tcl
set text "Hello World"

# Uppercase
set upper [string toupper $text]
puts $upper  ;# HELLO WORLD

# Lowercase
set lower [string tolower $text]
puts $lower  ;# hello world
```

### String Comparison
```tcl
set str1 "hello"
set str2 "HELLO"

# Case-sensitive compare
if {$str1 == $str2} {
    puts "Equal"
} else {
    puts "Not equal"
}

# Case-insensitive compare
if {[string equal -nocase $str1 $str2]} {
    puts "Equal (ignoring case)"
}
```

### String Trimming
```tcl
set text "  Hello  "

# Trim whitespace
set trimmed [string trim $text]
puts "[$trimmed]"  ;# [Hello]

# Trim left
set left [string trimleft $text]

# Trim right
set right [string trimright $text]
```

---

## Capital Markets Examples

### Example 1: Trade Classifier
```tcl
proc classifyTrade {value} {
    if {$value > 100000} {
        return "LARGE"
    } elseif {$value > 50000} {
        return "MEDIUM"
    } else {
        return "SMALL"
    }
}

# Test
set trades {
    {T001 AAPL 100 175.50}
    {T002 GOOGL 500 140.25}
    {T003 MSFT 2000 380.75}
}

foreach trade $trades {
    set id [lindex $trade 0]
    set symbol [lindex $trade 1]
    set qty [lindex $trade 2]
    set price [lindex $trade 3]
    set value [expr {$qty * $price}]
    set category [classifyTrade $value]
    
    puts "$id: $symbol, Value: \$$value, Category: $category"
}
```

### Example 2: Symbol Validator
```tcl
proc isValidSymbol {symbol} {
    # Symbol must be 1-5 uppercase letters
    if {[string length $symbol] < 1 || [string length $symbol] > 5} {
        return 0
    }
    
    # Check all uppercase
    if {$symbol != [string toupper $symbol]} {
        return 0
    }
    
    return 1
}

# Test
set symbols {AAPL GOOGL INVALID123 abc TSLA}
foreach sym $symbols {
    if {[isValidSymbol $sym]} {
        puts "$sym: Valid"
    } else {
        puts "$sym: Invalid"
    }
}
```

### Example 3: Position Calculator
```tcl
proc calculatePosition {trades} {
    array set positions {}
    
    foreach trade $trades {
        set symbol [lindex $trade 0]
        set qty [lindex $trade 1]
        
        if {[info exists positions($symbol)]} {
            set positions($symbol) [expr {$positions($symbol) + $qty}]
        } else {
            set positions($symbol) $qty
        }
    }
    
    return [array get positions]
}

# Test
set trades {
    {AAPL 100}
    {GOOGL 50}
    {AAPL 200}
    {MSFT 150}
    {AAPL -50}
}

array set result [calculatePosition $trades]
foreach {symbol position} [array get result] {
    puts "$symbol: $position shares"
}
```

---

## Best Practices

✅ Use braces around expressions: `if {$x > 10}`

✅ Use list commands (lappend, etc.) instead of string concat

✅ Use procedures for reusable code

✅ Name procedures with descriptive names

✅ Add comments for complex logic

✅ Use `expr` for arithmetic operations

---

## Quick Reference

| Operation | Command | Example |
|-----------|---------|---------|
| If statement | `if {cond} {code}` | `if {$x > 10} {puts "yes"}` |
| For loop | `for {init} {cond} {incr}` | `for {set i 0} {$i<10} {incr i}` |
| Foreach | `foreach var list {code}` | `foreach x $list {puts $x}` |
| List length | `llength list` | `llength $fruits` |
| List append | `lappend list item` | `lappend items new` |
| Procedure | `proc name {args} {code}` | `proc add {a b} {expr {$a+$b}}` |
| String length | `string length str` | `string length $text` |

---

**Next Document**: `03-File-IO-and-Arrays.md`

