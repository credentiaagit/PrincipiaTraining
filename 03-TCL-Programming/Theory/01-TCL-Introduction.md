# TCL Programming - Introduction

## Table of Contents
1. [What is TCL?](#what-is-tcl)
2. [Why TCL in Capital Markets?](#why-tcl-in-capital-markets)
3. [TCL Basics](#tcl-basics)
4. [Variables](#variables)
5. [Data Types](#data-types)
6. [Commands and Syntax](#commands-and-syntax)
7. [Comments](#comments)

---

## What is TCL?

**TCL** (Tool Command Language) is a powerful, easy-to-learn scripting language with simple syntax.

### Key Characteristics
- **Everything is a command**: Even control structures are commands
- **Everything is a string**: All data internally represented as strings
- **Simple syntax**: Easy to learn and read
- **Extensible**: Can be extended with C/C++
- **Embeddable**: Can be embedded in applications
- **Cross-platform**: Runs on Unix, Windows, Mac

### History
- Created by John Ousterhout in 1988
- Originally developed at UC Berkeley
- Now maintained by the TCL Core Team
- Latest version: TCL 8.6+

---

## Why TCL in Capital Markets?

### Advantages in Financial Systems

1. **Rapid Development**: Quick to write and modify
2. **String Processing**: Excellent for parsing data files
3. **Integration**: Easy to integrate with C/C++ systems
4. **Stability**: Mature, stable language
5. **Performance**: Good enough for most tasks
6. **Maintainability**: Easy to understand and maintain

### Common Use Cases

```
Capital Markets TCL Usage:
├── Trade Processing Scripts
├── Data File Parsing
├── Report Generation
├── System Integration
├── Batch Processing
├── Configuration Management
└── Automation Tasks
```

### Industry Adoption
- **Investment Banks**: Back-office processing
- **Trading Firms**: Order management systems
- **Hedge Funds**: Risk calculations
- **Exchanges**: Market data processing
- **Clearinghouses**: Settlement systems

---

## TCL Basics

### Running TCL

**Interactive Mode (tclsh):**
```tcl
$ tclsh
% puts "Hello, World!"
Hello, World!
% expr 5 + 3
8
% exit
```

**Script Mode:**
```tcl
# hello.tcl
puts "Hello, World!"

# Run:
$ tclsh hello.tcl
```

**Shebang for executable scripts:**
```tcl
#!/usr/bin/env tclsh

puts "This script can run directly"

# Make executable:
# chmod +x script.tcl
# ./script.tcl
```

---

## Variables

### Setting Variables
```tcl
# Using set command
set name "John"
set age 25
set salary 50000.50

# Multiple words need quotes
set full_name "John Smith"
```

### Getting Variable Values
```tcl
set name "John"

# Using set (returns value)
puts [set name]

# Using $ substitution (preferred)
puts $name

# With braces (when needed)
puts ${name}
```

### Variable Substitution
```tcl
set first "John"
set last "Smith"

# Concatenation
set full "$first $last"
puts $full  ;# John Smith

# In commands
puts "Hello, $first!"  ;# Hello, John!
```

### Unset Variables
```tcl
set name "John"
unset name  ;# Delete variable

# Check if exists
if {[info exists name]} {
    puts "Variable exists"
} else {
    puts "Variable does not exist"
}
```

---

## Data Types

### Everything is a String
```tcl
# All of these are strings internally
set num 42
set text "hello"
set float 3.14
set bool true

# TCL converts as needed
puts [expr $num + 10]  ;# 52
```

### Numbers
```tcl
# Integers
set count 42
set negative -10

# Floating point
set price 99.99
set scientific 1.5e10

# Hexadecimal
set hex 0xFF  ;# 255

# Octal
set oct 0777  ;# 511
```

### Strings
```tcl
# Simple strings
set name "John"

# Strings with spaces
set sentence "Hello, World!"

# Empty string
set empty ""

# Multi-line strings
set text "Line 1
Line 2
Line 3"
```

### Booleans
```tcl
# Boolean values (treated as numbers)
set is_active true   ;# or 1
set is_done false    ;# or 0
set yes_value yes    ;# or 1
set no_value no      ;# or 0

# In conditions, 0 is false, non-zero is true
if {$is_active} {
    puts "Active!"
}
```

### Lists
```tcl
# Creating lists
set fruits {apple banana orange}
set numbers {1 2 3 4 5}
set mixed {John 25 "New York"}

# Empty list
set empty_list {}

# List with single element
set single {element}
```

### Arrays (Associative Arrays)
```tcl
# Setting array elements
set employee(name) "John Smith"
set employee(age) 25
set employee(department) "IT"

# Getting values
puts $employee(name)  ;# John Smith

# Check if element exists
if {[info exists employee(salary)]} {
    puts $employee(salary)
}
```

---

## Commands and Syntax

### Command Structure
```tcl
command arg1 arg2 arg3 ...
```

**Example:**
```tcl
puts "Hello, World!"
set name "John"
expr 5 + 3
```

### Special Characters

```tcl
$       # Variable substitution
[]      # Command substitution
{}      # No substitution (literal)
""      # Some substitution
\       # Escape character
;       # Command separator
#       # Comment
```

### Substitution Examples
```tcl
set x 10

# Variable substitution
puts "x is $x"  ;# x is 10

# Command substitution
puts "Sum is [expr $x + 5]"  ;# Sum is 15

# No substitution with braces
puts {x is $x}  ;# x is $x

# Escape character
puts "Price: \$100"  ;# Price: $100
```

### Quoting

**Double Quotes (""):**
```tcl
set name "John"
puts "Hello, $name"  ;# Substitution occurs
puts "Result: [expr 5 + 3]"  ;# Command substitution
```

**Braces ({}):**
```tcl
set name "John"
puts {Hello, $name}  ;# No substitution: Hello, $name
puts {Result: [expr 5 + 3]}  ;# No substitution
```

### Command Separator
```tcl
# Multiple commands on one line with ;
set x 10; set y 20; puts [expr $x + $y]

# Or on separate lines (preferred)
set x 10
set y 20
puts [expr $x + $y]
```

### Line Continuation
```tcl
# Use backslash for continuation
set long_text "This is a very long \
string that continues \
on multiple lines"

# Or use quotes
set long_text "This is a very long
string on multiple
lines"
```

---

## Comments

### Single Line Comments
```tcl
# This is a comment
puts "Hello"  ;# Inline comment

# Comments must start at beginning or after separator
set x 10      # This is WRONG - will cause error
set x 10 ;# This is correct
```

### Multi-line Comments
```tcl
# Comment line 1
# Comment line 2
# Comment line 3

# There's no built-in multi-line comment
# Use # at start of each line
```

### Block Comments (Workaround)
```tcl
if {0} {
    This is a block comment
    These lines won't execute
    Useful for commenting out code blocks
}
```

---

## TCL Script Structure

### Basic Script Template
```tcl
#!/usr/bin/env tclsh
#
# Script: script_name.tcl
# Description: What this script does
# Author: Your Name
# Date: 2024-10-28
#
# Usage: tclsh script_name.tcl [arguments]
#

# Global variables
set scriptName [file tail [info script]]

# Main procedures
proc main {} {
    # Main script logic here
    puts "Script started"
    
    # Your code
    
    puts "Script completed"
}

# Run main procedure
if {[info script] eq $argv0} {
    main
}
```

---

## Capital Markets Example

### Trade Processing Script
```tcl
#!/usr/bin/env tclsh
#
# Simple Trade Processor
#

# Set trade data
set tradeId "T001"
set symbol "AAPL"
set quantity 100
set price 175.50

# Calculate trade value
set tradeValue [expr $quantity * $price]

# Display trade information
puts "========================================="
puts "Trade Information"
puts "========================================="
puts "Trade ID:  $tradeId"
puts "Symbol:    $symbol"
puts "Quantity:  $quantity"
puts "Price:     \$[format "%.2f" $price]"
puts "Value:     \$[format "%.2f" $tradeValue]"
puts "========================================="

# Determine trade size category
if {$tradeValue > 100000} {
    set category "LARGE"
} elseif {$tradeValue > 50000} {
    set category "MEDIUM"
} else {
    set category "SMALL"
}

puts "Category:  $category"
```

---

## Best Practices

✅ **Use meaningful variable names**
```tcl
set tradeId "T001"  # Good
set t "T001"        # Bad
```

✅ **Quote strings properly**
```tcl
set name "John Smith"  # Good for strings with spaces
set count 42           # Fine for simple values
```

✅ **Use braces for command arguments**
```tcl
if {$x > 10} {         # Good
    puts "Greater"
}
```

✅ **Add comments for complex logic**
```tcl
# Calculate commission (0.1% of trade value)
set commission [expr $tradeValue * 0.001]
```

✅ **Consistent indentation**
```tcl
if {$condition} {
    # 4 spaces indent
    puts "True"
}
```

---

## Common Mistakes

❌ **Forgetting $ for variable substitution**
```tcl
set name "John"
puts name  # Wrong: prints "name"
puts $name # Correct: prints "John"
```

❌ **Incorrect quoting**
```tcl
puts Hello, $name      # Wrong if name has spaces
puts "Hello, $name"    # Correct
```

❌ **Inline comments without ;**
```tcl
set x 10 # comment     # Wrong
set x 10 ;# comment    # Correct
```

---

## Quick Reference

| Operation | Syntax | Example |
|-----------|--------|---------|
| Set variable | `set var value` | `set name "John"` |
| Get variable | `$var` | `puts $name` |
| Command substitution | `[command]` | `set x [expr 5 + 3]` |
| Comment | `#` or `;#` | `# Comment` |
| String concatenation | `"$var1 $var2"` | `"$first $last"` |
| No substitution | `{text}` | `{$x}` prints "$x" |

---

## Practice Exercises

1. Create a TCL script that displays your name, age, and city
2. Write a script that calculates and displays the area of a rectangle
3. Create a script that takes a trade ID and price, calculates 1% commission
4. Write a script that displays a formatted trade report

---

## Reference Links

### 📚 Theory & Learning Resources

1. **Official Documentation**:
   - [TCL Official Website](https://www.tcl.tk/) - Main resource hub
   - [TCL Tutorial](https://www.tcl.tk/man/tcl8.6/tutorial/tcltutorial.html) - Official tutorial
   - [TCL Command Reference](https://www.tcl.tk/man/tcl8.6/TclCmd/contents.htm) - All commands
   - [TCL Manual](https://www.tcl.tk/man/tcl8.6/) - Complete documentation

2. **Comprehensive Tutorials**:
   - [TutorialsPoint - TCL Tutorial](https://www.tutorialspoint.com/tcl-tk/index.htm) - Beginner-friendly
   - [Learn TCL in Y Minutes](https://learnxinyminutes.com/docs/tcl/) - Quick overview
   - [TCL Wiki](https://wiki.tcl-lang.org/) - 10,000+ pages of community knowledge
   - [Wikibooks - Programming TCL](https://en.wikibooks.org/wiki/Programming:Tcl) - Free book

3. **Best Practices**:
   - [TCL Style Guide](https://www.tcl.tk/doc/styleGuide.pdf) - Official coding standards
   - [TCL Idioms](https://wiki.tcl-lang.org/page/Tcl+idioms) - Common patterns
   - [TCL Performance Tips](https://wiki.tcl-lang.org/page/performance)

### 🎮 Hands-On Practice Resources

1. **Online TCL Interpreters**:
   - [TutorialsPoint - TCL Compiler](https://www.tutorialspoint.com/execute_tcl_online.php) - Run instantly (FREE)
   - [Replit - TCL](https://replit.com/languages/tcl) - Online IDE with sharing
   - [JDoodle - TCL Compiler](https://www.jdoodle.com/execute-tcl-online/) - Quick testing

2. **Practice Exercises**:
   - [Exercism - TCL Track](https://exercism.org/tracks/tcl) - Mentored practice (FREE)
   - [Rosetta Code - TCL](https://rosettacode.org/wiki/Category:Tcl) - Example problems
   - [Project Euler](https://projecteuler.net/) - Solve using TCL

3. **Tools & Development**:
   - [ActiveState TCL](https://www.activestate.com/products/tcl/) - Complete toolkit
   - [Visual Studio Code - TCL Extension](https://marketplace.visualstudio.com/items?itemName=tclexec.tcl)
   - [TCL Cookbook](https://wiki.tcl-lang.org/page/Tcl+Cookbook) - Solutions repository

---

**Next Document**: `02-Control-Structures-and-Procedures.md`

