#!/usr/bin/env tclsh
################################################################################
# Script: 02-file-operations.tcl
# Purpose: Demonstrate file I/O operations in TCL
# Author: Training Team
# Usage: tclsh 02-file-operations.tcl
################################################################################

################################################################################
# Example 1: Reading Files
################################################################################
proc read_file_example {} {
    puts "\n========== Example 1: Reading Files =========="
    
    # Create a sample file
    set filename "sample_trades.txt"
    set fp [open $filename w]
    puts $fp "TRADE001,AAPL,150.25,100"
    puts $fp "TRADE002,GOOGL,2800.50,50"
    puts $fp "TRADE003,MSFT,350.75,200"
    close $fp
    
    # Method 1: Read entire file at once
    puts "\nMethod 1: Read entire file"
    set fp [open $filename r]
    set content [read $fp]
    close $fp
    puts "File content:\n$content"
    
    # Method 2: Read line by line
    puts "\nMethod 2: Read line by line"
    set fp [open $filename r]
    set line_num 0
    while {[gets $fp line] >= 0} {
        incr line_num
        puts "Line $line_num: $line"
    }
    close $fp
    
    # Clean up
    file delete $filename
}

################################################################################
# Example 2: Writing Files
################################################################################
proc write_file_example {} {
    puts "\n========== Example 2: Writing Files =========="
    
    set filename "trading_report.txt"
    
    # Open file for writing
    set fp [open $filename w]
    
    # Write header
    puts $fp "Trading Report - [clock format [clock seconds]]"
    puts $fp [string repeat "=" 50]
    
    # Write trade data
    set trades {
        {T001 AAPL 150.25 100 SUCCESS}
        {T002 GOOGL 2800.50 50 SUCCESS}
        {T003 MSFT 350.75 200 FAILED}
    }
    
    foreach trade $trades {
        lassign $trade trade_id symbol price qty status
        puts $fp [format "%-8s %-8s %10.2f %8d %s" \
            $trade_id $symbol $price $qty $status]
    }
    
    close $fp
    puts "Report written to: $filename"
    
    # Display the file content
    set fp [open $filename r]
    puts "\nFile content:"
    puts [read $fp]
    close $fp
}

################################################################################
# Example 3: Appending to Files
################################################################################
proc append_file_example {} {
    puts "\n========== Example 3: Appending to Files =========="
    
    set logfile "trading.log"
    
    # Create initial log
    set fp [open $logfile w]
    puts $fp "[clock format [clock seconds]] - System started"
    close $fp
    
    # Append new entries
    set fp [open $logfile a]
    puts $fp "[clock format [clock seconds]] - Trade T001 executed"
    puts $fp "[clock format [clock seconds]] - Trade T002 executed"
    puts $fp "[clock format [clock seconds]] - Trade T003 failed"
    close $fp
    
    # Display log
    set fp [open $logfile r]
    puts "Log file content:"
    puts [read $fp]
    close $fp
    
    file delete $logfile
}

################################################################################
# Example 4: File Information
################################################################################
proc file_info_example {} {
    puts "\n========== Example 4: File Information =========="
    
    # Create a test file
    set filename "test_data.txt"
    set fp [open $filename w]
    puts $fp "Sample data for testing file operations"
    close $fp
    
    # Check file existence
    if {[file exists $filename]} {
        puts "File exists: $filename"
    }
    
    # Check if it's a file or directory
    if {[file isfile $filename]} {
        puts "Type: Regular file"
    }
    
    # Get file size
    puts "Size: [file size $filename] bytes"
    
    # Get file modification time
    set mtime [file mtime $filename]
    puts "Last modified: [clock format $mtime]"
    
    # Check if readable/writable
    puts "Readable: [file readable $filename]"
    puts "Writable: [file writable $filename]"
    
    # Get file extension
    puts "Extension: [file extension $filename]"
    
    # Get directory and filename
    puts "Directory: [file dirname $filename]"
    puts "Filename: [file tail $filename]"
    puts "Root name: [file rootname $filename]"
    
    file delete $filename
}

################################################################################
# Example 5: CSV File Processing
################################################################################
proc process_csv_file {} {
    puts "\n========== Example 5: CSV File Processing =========="
    
    # Create sample CSV file
    set csvfile "market_data.csv"
    set fp [open $csvfile w]
    puts $fp "TradeID,Symbol,Price,Quantity,Timestamp"
    puts $fp "T001,AAPL,150.25,100,2024-10-28 09:30:00"
    puts $fp "T002,GOOGL,2800.50,50,2024-10-28 09:31:00"
    puts $fp "T003,MSFT,350.75,200,2024-10-28 09:32:00"
    puts $fp "T004,AMZN,3200.00,75,2024-10-28 09:33:00"
    puts $fp "T005,TSLA,250.50,150,2024-10-28 09:34:00"
    close $fp
    
    puts "Processing CSV file: $csvfile"
    puts ""
    
    # Read and parse CSV
    set fp [open $csvfile r]
    set header [gets $fp]
    puts "Header: $header"
    puts [string repeat "-" 60]
    
    set total_value 0.0
    set trade_count 0
    
    while {[gets $fp line] >= 0} {
        # Split CSV line
        set fields [split $line ","]
        lassign $fields trade_id symbol price qty timestamp
        
        # Calculate trade value
        set value [expr {$price * $qty}]
        set total_value [expr {$total_value + $value}]
        incr trade_count
        
        # Display trade info
        puts [format "%-6s %-8s %10.2f x %4d = %12.2f" \
            $trade_id $symbol $price $qty $value]
    }
    close $fp
    
    puts [string repeat "-" 60]
    puts [format "Total trades: %d" $trade_count]
    puts [format "Total value: \$%.2f" $total_value]
    puts [format "Average value: \$%.2f" [expr {$total_value / $trade_count}]]
    
    file delete $csvfile
}

################################################################################
# Example 6: Error Handling with Files
################################################################################
proc error_handling_example {} {
    puts "\n========== Example 6: Error Handling =========="
    
    # Try to open non-existent file
    set filename "nonexistent.txt"
    
    # Without error handling
    puts "\nAttempting to open file without error handling:"
    if {[catch {open $filename r} result]} {
        puts "Error caught: $result"
    }
    
    # With proper error handling
    puts "\nWith proper error handling:"
    if {[catch {
        set fp [open $filename r]
        set content [read $fp]
        close $fp
    } error_msg]} {
        puts "Failed to read file: $error_msg"
        puts "Taking corrective action..."
    } else {
        puts "File read successfully"
    }
}

################################################################################
# Example 7: Directory Operations
################################################################################
proc directory_operations {} {
    puts "\n========== Example 7: Directory Operations =========="
    
    # Create directory
    set dirname "test_dir"
    file mkdir $dirname
    puts "Created directory: $dirname"
    
    # Create files in directory
    for {set i 1} {$i <= 3} {incr i} {
        set fp [open "$dirname/file$i.txt" w]
        puts $fp "Content of file $i"
        close $fp
    }
    
    # List files in directory
    puts "\nFiles in $dirname:"
    foreach file [glob -directory $dirname *] {
        puts "  - [file tail $file]"
    }
    
    # Get current directory
    puts "\nCurrent directory: [pwd]"
    
    # Change directory
    cd $dirname
    puts "Changed to: [pwd]"
    
    # Go back
    cd ..
    puts "Back to: [pwd]"
    
    # Clean up
    file delete -force $dirname
    puts "\nCleaned up test directory"
}

################################################################################
# Example 8: Processing Log Files
################################################################################
proc process_log_file {} {
    puts "\n========== Example 8: Processing Log Files =========="
    
    # Create sample log file
    set logfile "application.log"
    set fp [open $logfile w]
    puts $fp "2024-10-28 09:00:00 INFO Application started"
    puts $fp "2024-10-28 09:01:15 INFO Trade executed successfully"
    puts $fp "2024-10-28 09:02:30 ERROR Database connection failed"
    puts $fp "2024-10-28 09:03:45 INFO Market data received"
    puts $fp "2024-10-28 09:04:00 FATAL System crash"
    puts $fp "2024-10-28 09:05:15 WARNING High memory usage"
    puts $fp "2024-10-28 09:06:30 ERROR Invalid trade data"
    puts $fp "2024-10-28 09:07:45 INFO Trade executed successfully"
    close $fp
    
    # Analyze log file
    set fp [open $logfile r]
    
    # Initialize counters
    array set counts {INFO 0 ERROR 0 WARNING 0 FATAL 0}
    
    while {[gets $fp line] >= 0} {
        # Extract log level
        if {[regexp {(INFO|ERROR|WARNING|FATAL)} $line match level]} {
            incr counts($level)
        }
    }
    close $fp
    
    # Display statistics
    puts "Log Statistics:"
    puts [string repeat "-" 30]
    foreach level {INFO WARNING ERROR FATAL} {
        puts [format "%-10s: %d" $level $counts($level)]
    }
    
    # Extract errors only
    puts "\nErrors found:"
    set fp [open $logfile r]
    while {[gets $fp line] >= 0} {
        if {[string match "*ERROR*" $line] || [string match "*FATAL*" $line]} {
            puts "  $line"
        }
    }
    close $fp
    
    file delete $logfile
}

################################################################################
# Example 9: File Copy and Move
################################################################################
proc file_copy_move {} {
    puts "\n========== Example 9: File Copy and Move =========="
    
    # Create source file
    set source "source.txt"
    set fp [open $source w]
    puts $fp "This is the source file content"
    close $fp
    puts "Created: $source"
    
    # Copy file
    set copy "copy.txt"
    file copy $source $copy
    puts "Copied to: $copy"
    
    # Rename/Move file
    set newname "renamed.txt"
    file rename $copy $newname
    puts "Renamed to: $newname"
    
    # Verify
    puts "\nVerifying files:"
    foreach f [list $source $newname] {
        if {[file exists $f]} {
            puts "  ✓ $f exists"
        }
    }
    
    # Clean up
    file delete $source $newname
}

################################################################################
# Example 10: Binary File Operations
################################################################################
proc binary_file_example {} {
    puts "\n========== Example 10: Binary File Operations =========="
    
    set binfile "data.bin"
    
    # Write binary data
    set fp [open $binfile w]
    fconfigure $fp -translation binary
    
    # Write some integers as binary
    for {set i 0} {$i < 10} {incr i} {
        puts -nonewline $fp [binary format i $i]
    }
    close $fp
    
    puts "Written binary file: $binfile"
    puts "File size: [file size $binfile] bytes"
    
    # Read binary data
    set fp [open $binfile r]
    fconfigure $fp -translation binary
    set data [read $fp]
    close $fp
    
    # Parse binary data
    puts "\nReading binary integers:"
    binary scan $data i10 numbers
    puts "Numbers: $numbers"
    
    file delete $binfile
}

################################################################################
# Main Program
################################################################################
proc main {} {
    puts "=========================================="
    puts "TCL File Operations Examples"
    puts "=========================================="
    
    # Run all examples
    read_file_example
    write_file_example
    append_file_example
    file_info_example
    process_csv_file
    error_handling_example
    directory_operations
    process_log_file
    file_copy_move
    binary_file_example
    
    puts "\n=========================================="
    puts "All examples completed!"
    puts "=========================================="
}

# Execute main program
main

