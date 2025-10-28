#!/usr/bin/env tclsh
#
# Trade File Processor
# Complete example demonstrating TCL concepts for capital markets
#

# Global configuration
array set config {
    logFile "trade_processor.log"
    outputDir "output"
    dateFormat "%Y-%m-%d %H:%M:%S"
}

# Logging procedures
proc logMsg {level message} {
    global config
    set timestamp [clock format [clock seconds] -format $config(dateFormat)]
    set logEntry "\[$timestamp\] \[$level\] $message"
    
    puts $logEntry
    
    if {[catch {
        set fp [open $config(logFile) a]
        puts $fp $logEntry
        close $fp
    } err]} {
        puts stderr "Warning: Could not write to log: $err"
    }
}

proc logInfo {message} {
    logMsg "INFO" $message
}

proc logError {message} {
    logMsg "ERROR" $message
}

# File validation
proc validateTradeFile {filename} {
    logInfo "Validating file: $filename"
    
    if {![file exists $filename]} {
        logError "File not found: $filename"
        return 0
    }
    
    if {![file readable $filename]} {
        logError "File not readable: $filename"
        return 0
    }
    
    if {[file size $filename] == 0} {
        logError "File is empty: $filename"
        return 0
    }
    
    logInfo "File validation passed"
    return 1
}

# Parse trade record
proc parseTrade {line lineNum} {
    set fields [split $line ","]
    
    if {[llength $fields] != 5} {
        logError "Line $lineNum: Invalid number of fields"
        return {}
    }
    
    set tradeId [string trim [lindex $fields 0]]
    set symbol [string trim [lindex $fields 1]]
    set side [string trim [lindex $fields 2]]
    set quantity [string trim [lindex $fields 3]]
    set price [string trim [lindex $fields 4]]
    
    # Validate fields
    if {![regexp {^T[0-9]{4}$} $tradeId]} {
        logError "Line $lineNum: Invalid trade ID: $tradeId"
        return {}
    }
    
    if {![regexp {^[A-Z]{1,5}$} $symbol]} {
        logError "Line $lineNum: Invalid symbol: $symbol"
        return {}
    }
    
    if {$side ne "BUY" && $side ne "SELL"} {
        logError "Line $lineNum: Invalid side: $side"
        return {}
    }
    
    if {![string is integer -strict $quantity] || $quantity <= 0} {
        logError "Line $lineNum: Invalid quantity: $quantity"
        return {}
    }
    
    if {![string is double -strict $price] || $price <= 0} {
        logError "Line $lineNum: Invalid price: $price"
        return {}
    }
    
    return [list $tradeId $symbol $side $quantity $price]
}

# Calculate trade value
proc calculateValue {quantity price} {
    return [expr {$quantity * $price}]
}

# Classify trade by value
proc classifyTrade {value} {
    if {$value > 100000} {
        return "LARGE"
    } elseif {$value > 50000} {
        return "MEDIUM"
    } else {
        return "SMALL"
    }
}

# Process trade file
proc processTradeFile {inputFile outputFile} {
    logInfo "========================================="
    logInfo "Starting trade processing"
    logInfo "Input: $inputFile"
    logInfo "Output: $outputFile"
    logInfo "========================================="
    
    if {![validateTradeFile $inputFile]} {
        return 0
    }
    
    # Statistics
    array set stats {
        totalTrades 0
        validTrades 0
        invalidTrades 0
        totalValue 0
    }
    
    array set symbolCount {}
    array set valueBySymbol {}
    
    # Open files
    if {[catch {open $inputFile r} ifp]} {
        logError "Cannot open input file: $ifp"
        return 0
    }
    
    if {[catch {open $outputFile w} ofp]} {
        close $ifp
        logError "Cannot open output file: $ofp"
        return 0
    }
    
    # Write output header
    puts $ofp "TradeID,Symbol,Side,Quantity,Price,Value,Category"
    
    # Read and skip header
    gets $ifp header
    
    # Process each trade
    set lineNum 1
    while {[gets $ifp line] >= 0} {
        incr lineNum
        
        if {$line == ""} continue
        
        incr stats(totalTrades)
        
        set trade [parseTrade $line $lineNum]
        if {[llength $trade] == 0} {
            incr stats(invalidTrades)
            continue
        }
        
        lassign $trade tradeId symbol side quantity price
        set value [calculateValue $quantity $price]
        set category [classifyTrade $value]
        
        # Write to output
        puts $ofp "$tradeId,$symbol,$side,$quantity,$price,$value,$category"
        
        # Update statistics
        incr stats(validTrades)
        set stats(totalValue) [expr {$stats(totalValue) + $value}]
        
        if {![info exists symbolCount($symbol)]} {
            set symbolCount($symbol) 0
            set valueBySymbol($symbol) 0
        }
        incr symbolCount($symbol)
        set valueBySymbol($symbol) [expr {$valueBySymbol($symbol) + $value}]
    }
    
    close $ifp
    close $ofp
    
    # Log statistics
    logInfo "========================================="
    logInfo "Processing complete"
    logInfo "Total trades processed: $stats(totalTrades)"
    logInfo "Valid trades: $stats(validTrades)"
    logInfo "Invalid trades: $stats(invalidTrades)"
    logInfo [format "Total value: \$%.2f" $stats(totalValue)]
    logInfo "========================================="
    
    # Generate summary
    generateSummary stats symbolCount valueBySymbol
    
    return 1
}

# Generate summary report
proc generateSummary {statsArr symbolCountArr valueBySymbolArr} {
    upvar $statsArr stats
    upvar $symbolCountArr symbolCount
    upvar $valueBySymbolArr valueBySymbol
    
    set reportFile "summary_[clock format [clock seconds] -format %Y%m%d_%H%M%S].txt"
    
    if {[catch {open $reportFile w} fp]} {
        logError "Cannot create summary report: $fp"
        return
    }
    
    puts $fp "========================================="
    puts $fp "Trade Processing Summary Report"
    puts $fp "Date: [clock format [clock seconds]]"
    puts $fp "========================================="
    puts $fp ""
    
    puts $fp "SUMMARY:"
    puts $fp "--------"
    puts $fp "Total Trades: $stats(totalTrades)"
    puts $fp "Valid Trades: $stats(validTrades)"
    puts $fp "Invalid Trades: $stats(invalidTrades)"
    puts $fp [format "Total Value: \$%.2f" $stats(totalValue)]
    puts $fp ""
    
    puts $fp "TOP 5 SYMBOLS BY TRADE COUNT:"
    puts $fp "-----------------------------"
    
    # Sort symbols by count
    set sortedSymbols {}
    foreach {symbol count} [array get symbolCount] {
        lappend sortedSymbols [list $count $symbol]
    }
    set sortedSymbols [lsort -integer -decreasing -index 0 $sortedSymbols]
    
    set rank 1
    foreach item [lrange $sortedSymbols 0 4] {
        lassign $item count symbol
        puts $fp [format "%d. %-8s: %d trades" $rank $symbol $count]
        incr rank
    }
    puts $fp ""
    
    puts $fp "TOP 5 SYMBOLS BY VALUE:"
    puts $fp "-----------------------"
    
    # Sort symbols by value
    set sortedValues {}
    foreach {symbol value} [array get valueBySymbol] {
        lappend sortedValues [list $value $symbol]
    }
    set sortedValues [lsort -real -decreasing -index 0 $sortedValues]
    
    set rank 1
    foreach item [lrange $sortedValues 0 4] {
        lassign $item value symbol
        puts $fp [format "%d. %-8s: \$%.2f" $rank $symbol $value]
        incr rank
    }
    
    puts $fp ""
    puts $fp "========================================="
    puts $fp "End of Report"
    puts $fp "========================================="
    
    close $fp
    logInfo "Summary report generated: $reportFile"
}

# Main procedure
proc main {argv} {
    global config
    
    puts "========================================="
    puts "TCL Trade File Processor"
    puts "========================================="
    puts ""
    
    if {[llength $argv] < 1} {
        puts "Usage: tclsh [info script] <input_file> \[output_file\]"
        puts ""
        puts "Example:"
        puts "  tclsh [info script] trades.csv processed.csv"
        return 1
    }
    
    set inputFile [lindex $argv 0]
    
    if {[llength $argv] >= 2} {
        set outputFile [lindex $argv 1]
    } else {
        set outputFile "processed_[file tail $inputFile]"
    }
    
    # Process trades
    if {[processTradeFile $inputFile $outputFile]} {
        puts ""
        puts "✓ Processing completed successfully"
        puts "  Output file: $outputFile"
        puts "  Log file: $config(logFile)"
        return 0
    } else {
        puts ""
        puts "✗ Processing failed"
        puts "  Check log file: $config(logFile)"
        return 1
    }
}

# Run main if script is executed directly
if {[info script] eq $argv0} {
    exit [main $argv]
}

