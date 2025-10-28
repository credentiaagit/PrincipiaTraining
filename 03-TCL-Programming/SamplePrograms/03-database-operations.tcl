#!/usr/bin/env tclsh
################################################################################
# Script: 03-database-operations.tcl
# Purpose: Demonstrate database operations with TCL (using tdbc or direct SQL)
# Author: Training Team
# Note: This is a conceptual example. Actual DB operations require tdbc package
# Usage: tclsh 03-database-operations.tcl
################################################################################

################################################################################
# Example 1: Simulated Database Connection
################################################################################
proc simulate_db_connection {} {
    puts "\n========== Example 1: Database Connection =========="
    
    # In real scenarios, you would use:
    # package require tdbc::sqlite3
    # set db [tdbc::sqlite3::connection new database.db]
    
    puts "Simulating database connection..."
    puts "Connection string: host=localhost dbname=trading_db user=admin"
    puts "Status: Connected ✓"
    
    # Connection would return a handle
    return "db_handle_123"
}

################################################################################
# Example 2: Execute Simple Query
################################################################################
proc execute_simple_query {db} {
    puts "\n========== Example 2: Simple Query =========="
    
    # SQL query
    set sql "SELECT trade_id, symbol, price, quantity FROM trades WHERE status = 'COMPLETED'"
    
    puts "Executing query:"
    puts $sql
    puts ""
    
    # Simulate query results
    set results {
        {T001 AAPL 150.25 100}
        {T002 GOOGL 2800.50 50}
        {T003 MSFT 350.75 200}
        {T005 AMZN 3200.00 75}
    }
    
    puts [format "%-8s %-8s %12s %10s" "TradeID" "Symbol" "Price" "Quantity"]
    puts [string repeat "-" 45]
    
    foreach row $results {
        lassign $row trade_id symbol price qty
        puts [format "%-8s %-8s %12.2f %10d" $trade_id $symbol $price $qty]
    }
    
    puts "\nRows returned: [llength $results]"
}

################################################################################
# Example 3: Parameterized Query (Prepared Statement)
################################################################################
proc parameterized_query {db symbol} {
    puts "\n========== Example 3: Parameterized Query =========="
    
    # Using parameterized query prevents SQL injection
    set sql "SELECT * FROM trades WHERE symbol = :symbol AND status = :status"
    
    puts "Query template: $sql"
    puts "Parameters: symbol=$symbol, status=COMPLETED"
    puts ""
    
    # In real TDBC:
    # set stmt [$db prepare $sql]
    # set results [$stmt execute -params [list symbol $symbol status "COMPLETED"]]
    
    # Simulate results
    if {$symbol eq "AAPL"} {
        set results {
            {T001 AAPL 150.25 100 COMPLETED "2024-10-28 09:30:00"}
            {T006 AAPL 151.00 150 COMPLETED "2024-10-28 10:15:00"}
        }
    } else {
        set results {}
    }
    
    puts "Results for symbol: $symbol"
    foreach row $results {
        lassign $row trade_id sym price qty status ts
        puts "  Trade: $trade_id, Price: $price, Qty: $qty, Time: $ts"
    }
}

################################################################################
# Example 4: Insert Data
################################################################################
proc insert_trade {db trade_data} {
    puts "\n========== Example 4: Insert Data =========="
    
    lassign $trade_data trade_id symbol price qty status
    
    set sql "INSERT INTO trades (trade_id, symbol, price, quantity, status, timestamp) \
             VALUES (:trade_id, :symbol, :price, :qty, :status, :timestamp)"
    
    set timestamp [clock format [clock seconds] -format "%Y-%m-%d %H:%M:%S"]
    
    puts "Inserting trade:"
    puts "  Trade ID: $trade_id"
    puts "  Symbol: $symbol"
    puts "  Price: $price"
    puts "  Quantity: $qty"
    puts "  Status: $status"
    puts "  Timestamp: $timestamp"
    
    # In real TDBC:
    # set stmt [$db prepare $sql]
    # $stmt execute -params [list trade_id $trade_id symbol $symbol ...]
    
    puts "Status: Insert successful ✓"
    puts "Rows affected: 1"
}

################################################################################
# Example 5: Update Data
################################################################################
proc update_trade_status {db trade_id new_status} {
    puts "\n========== Example 5: Update Data =========="
    
    set sql "UPDATE trades SET status = :status WHERE trade_id = :trade_id"
    
    puts "Updating trade: $trade_id"
    puts "New status: $new_status"
    puts "SQL: $sql"
    
    # In real TDBC:
    # set stmt [$db prepare $sql]
    # $stmt execute -params [list status $new_status trade_id $trade_id]
    
    puts "Status: Update successful ✓"
    puts "Rows affected: 1"
}

################################################################################
# Example 6: Delete Data
################################################################################
proc delete_old_trades {db days} {
    puts "\n========== Example 6: Delete Data =========="
    
    set sql "DELETE FROM trades WHERE timestamp < datetime('now', '-$days days')"
    
    puts "Deleting trades older than $days days"
    puts "SQL: $sql"
    
    # In real TDBC:
    # set result [$db execute $sql]
    
    set rows_deleted 15
    puts "Status: Delete successful ✓"
    puts "Rows deleted: $rows_deleted"
}

################################################################################
# Example 7: Transaction Management
################################################################################
proc execute_transaction {db} {
    puts "\n========== Example 7: Transaction Management =========="
    
    puts "Starting transaction..."
    
    # In real TDBC:
    # $db begintransaction
    
    if {[catch {
        # Multiple operations within transaction
        puts "  1. Debit account A: \$1000"
        puts "  2. Credit account B: \$1000"
        puts "  3. Log transaction"
        
        # Simulate an error condition
        set error_condition 0
        
        if {$error_condition} {
            error "Insufficient funds"
        }
        
        # In real TDBC:
        # $db commit
        puts "Transaction committed ✓"
        
    } error_msg]} {
        # In real TDBC:
        # $db rollback
        puts "Error occurred: $error_msg"
        puts "Transaction rolled back ✗"
    }
}

################################################################################
# Example 8: Aggregate Functions
################################################################################
proc calculate_statistics {db} {
    puts "\n========== Example 8: Aggregate Functions =========="
    
    set sql "
        SELECT 
            symbol,
            COUNT(*) as trade_count,
            SUM(quantity) as total_quantity,
            AVG(price) as avg_price,
            MIN(price) as min_price,
            MAX(price) as max_price
        FROM trades
        WHERE status = 'COMPLETED'
        GROUP BY symbol
        ORDER BY trade_count DESC
    "
    
    puts "Executing aggregate query..."
    puts ""
    
    # Simulate results
    set results {
        {AAPL 125 15000 150.50 148.00 155.00}
        {GOOGL 98 4900 2805.25 2795.00 2815.00}
        {MSFT 87 17400 351.00 348.50 353.75}
    }
    
    puts [format "%-8s %10s %12s %12s %12s %12s" \
        "Symbol" "Trades" "Total Qty" "Avg Price" "Min Price" "Max Price"]
    puts [string repeat "-" 75]
    
    foreach row $results {
        lassign $row symbol count qty avg_price min_price max_price
        puts [format "%-8s %10d %12d %12.2f %12.2f %12.2f" \
            $symbol $count $qty $avg_price $min_price $max_price]
    }
}

################################################################################
# Example 9: Join Operations
################################################################################
proc execute_join_query {db} {
    puts "\n========== Example 9: Join Operations =========="
    
    set sql "
        SELECT 
            t.trade_id,
            t.symbol,
            t.price,
            t.quantity,
            c.client_name,
            c.account_id
        FROM trades t
        INNER JOIN clients c ON t.client_id = c.client_id
        WHERE t.status = 'COMPLETED'
        ORDER BY t.timestamp DESC
        LIMIT 5
    "
    
    puts "Executing JOIN query..."
    puts ""
    
    # Simulate results
    set results {
        {T105 AAPL 150.25 100 "John Smith" ACC001}
        {T104 GOOGL 2800.50 50 "Mary Johnson" ACC002}
        {T103 MSFT 350.75 200 "Bob Wilson" ACC003}
    }
    
    puts [format "%-8s %-8s %10s %8s %-20s %-10s" \
        "TradeID" "Symbol" "Price" "Qty" "Client" "Account"]
    puts [string repeat "-" 75]
    
    foreach row $results {
        lassign $row trade_id symbol price qty client account
        puts [format "%-8s %-8s %10.2f %8d %-20s %-10s" \
            $trade_id $symbol $price $qty $client $account]
    }
}

################################################################################
# Example 10: Stored Procedure Simulation
################################################################################
proc call_stored_procedure {db proc_name params} {
    puts "\n========== Example 10: Stored Procedure =========="
    
    puts "Calling stored procedure: $proc_name"
    puts "Parameters: $params"
    puts ""
    
    # Simulate calling a stored procedure
    # In real TDBC with some databases:
    # set result [$db execute "CALL $proc_name($params)"]
    
    switch $proc_name {
        "process_end_of_day" {
            puts "Executing end of day processing..."
            puts "  - Calculating daily totals"
            puts "  - Updating account balances"
            puts "  - Generating reports"
            puts "  - Archiving old data"
            puts "Status: Completed ✓"
        }
        "calculate_portfolio_value" {
            lassign $params account_id
            puts "Calculating portfolio value for: $account_id"
            set value 1250000.50
            puts "Portfolio value: \$[format %.2f $value]"
            return $value
        }
        default {
            puts "Unknown procedure: $proc_name"
        }
    }
}

################################################################################
# Example 11: Batch Insert Operations
################################################################################
proc batch_insert_trades {db trade_list} {
    puts "\n========== Example 11: Batch Insert =========="
    
    puts "Inserting [llength $trade_list] trades..."
    
    set sql "INSERT INTO trades (trade_id, symbol, price, quantity, status) \
             VALUES (:trade_id, :symbol, :price, :qty, :status)"
    
    # In real TDBC:
    # $db begintransaction
    # set stmt [$db prepare $sql]
    
    set count 0
    foreach trade $trade_list {
        lassign $trade trade_id symbol price qty status
        
        # $stmt execute -params [list ...]
        incr count
        
        if {$count % 100 == 0} {
            puts "  Inserted $count records..."
        }
    }
    
    # $db commit
    
    puts "Batch insert completed ✓"
    puts "Total records inserted: $count"
}

################################################################################
# Example 12: Error Handling
################################################################################
proc safe_query_execution {db sql} {
    puts "\n========== Example 12: Error Handling =========="
    
    puts "Executing query with error handling..."
    
    if {[catch {
        # Simulate query execution
        # set result [$db execute $sql]
        
        # Simulate an error
        if {[string match "*invalid_table*" $sql]} {
            error "Table does not exist"
        }
        
        puts "Query executed successfully ✓"
        
    } error_msg options]} {
        puts "Error occurred: $error_msg"
        puts "Error code: [dict get $options -errorcode]"
        puts "Handling error gracefully..."
        return -1
    }
    
    return 0
}

################################################################################
# Example 13: Connection Pooling Simulation
################################################################################
proc connection_pool_example {} {
    puts "\n========== Example 13: Connection Pooling =========="
    
    # Simulated connection pool
    set pool_size 5
    array set pool {}
    
    puts "Creating connection pool (size: $pool_size)..."
    
    for {set i 0} {$i < $pool_size} {incr i} {
        set pool($i) [list available "conn_$i"]
        puts "  Connection $i created"
    }
    
    # Get connection from pool
    puts "\nAcquiring connection from pool..."
    set conn_id ""
    for {set i 0} {$i < $pool_size} {incr i} {
        if {[lindex $pool($i) 0] eq "available"} {
            set conn_id [lindex $pool($i) 1]
            set pool($i) [list in_use $conn_id]
            break
        }
    }
    
    if {$conn_id ne ""} {
        puts "Acquired connection: $conn_id ✓"
        puts "Executing queries..."
        
        # Use connection...
        
        # Return to pool
        for {set i 0} {$i < $pool_size} {incr i} {
            if {[lindex $pool($i) 1] eq $conn_id} {
                set pool($i) [list available $conn_id]
                puts "Connection returned to pool ✓"
                break
            }
        }
    }
}

################################################################################
# Main Program
################################################################################
proc main {} {
    puts "=========================================="
    puts "TCL Database Operations Examples"
    puts "=========================================="
    puts ""
    puts "Note: These are conceptual examples."
    puts "Real database operations require:"
    puts "  - package require tdbc::sqlite3  (or tdbc::mysql, tdbc::postgres)"
    puts "  - Actual database connection"
    puts "=========================================="
    
    # Simulate database operations
    set db [simulate_db_connection]
    
    execute_simple_query $db
    parameterized_query $db "AAPL"
    insert_trade $db {T999 TSLA 250.50 100 PENDING}
    update_trade_status $db "T999" "COMPLETED"
    delete_old_trades $db 90
    execute_transaction $db
    calculate_statistics $db
    execute_join_query $db
    call_stored_procedure $db "process_end_of_day" {}
    
    # Batch operations
    set trade_batch {
        {T1001 AAPL 150.25 100 COMPLETED}
        {T1002 GOOGL 2800.50 50 COMPLETED}
        {T1003 MSFT 350.75 200 PENDING}
    }
    batch_insert_trades $db $trade_batch
    
    safe_query_execution $db "SELECT * FROM trades"
    connection_pool_example
    
    puts "\n=========================================="
    puts "All examples completed!"
    puts "=========================================="
    puts ""
    puts "To use real database operations:"
    puts "1. Install TDBC package: tcl-tdbc"
    puts "2. Install database driver (sqlite3, mysql, postgres)"
    puts "3. Modify connection string for your database"
    puts "=========================================="
}

# Execute main program
main

