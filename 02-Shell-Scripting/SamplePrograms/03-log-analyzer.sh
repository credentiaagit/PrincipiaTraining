#!/bin/bash
################################################################################
# Script: 03-log-analyzer.sh
# Purpose: Analyze trading application logs and generate reports
# Author: Training Team
# Usage: ./03-log-analyzer.sh <log_file>
################################################################################

# Script configuration
REPORT_DIR="./reports"
TIMESTAMP=$(date '+%Y%m%d_%H%M%S')

################################################################################
# Function: setup_environment
# Purpose: Create necessary directories
################################################################################
setup_environment() {
    mkdir -p "$REPORT_DIR"
    echo "Log Analysis Report - $(date)" > "$REPORT_DIR/analysis_$TIMESTAMP.txt"
}

################################################################################
# Function: analyze_error_patterns
# Purpose: Find and count error patterns
################################################################################
analyze_error_patterns() {
    local log_file=$1
    local output_file="$REPORT_DIR/analysis_$TIMESTAMP.txt"
    
    echo "" >> "$output_file"
    echo "=========================================" >> "$output_file"
    echo "ERROR ANALYSIS" >> "$output_file"
    echo "=========================================" >> "$output_file"
    
    # Count total errors
    local error_count=$(grep -c "ERROR" "$log_file" 2>/dev/null || echo "0")
    echo "Total ERROR entries: $error_count" >> "$output_file"
    
    # Count fatal errors
    local fatal_count=$(grep -c "FATAL" "$log_file" 2>/dev/null || echo "0")
    echo "Total FATAL entries: $fatal_count" >> "$output_file"
    
    # Count warnings
    local warning_count=$(grep -c "WARNING\|WARN" "$log_file" 2>/dev/null || echo "0")
    echo "Total WARNING entries: $warning_count" >> "$output_file"
    
    echo "" >> "$output_file"
    echo "Top 5 Error Messages:" >> "$output_file"
    grep "ERROR" "$log_file" 2>/dev/null | \
        awk -F'ERROR' '{print $2}' | \
        sed 's/^[[:space:]]*//' | \
        sort | uniq -c | sort -rn | head -5 >> "$output_file"
}

################################################################################
# Function: analyze_performance
# Purpose: Analyze performance metrics from logs
################################################################################
analyze_performance() {
    local log_file=$1
    local output_file="$REPORT_DIR/analysis_$TIMESTAMP.txt"
    
    echo "" >> "$output_file"
    echo "=========================================" >> "$output_file"
    echo "PERFORMANCE ANALYSIS" >> "$output_file"
    echo "=========================================" >> "$output_file"
    
    # Find slow transactions (assuming format: "Transaction completed in Xms")
    echo "Transactions taking > 1000ms:" >> "$output_file"
    grep "completed in" "$log_file" 2>/dev/null | \
        awk '{for(i=1;i<=NF;i++) if($i~/[0-9]+ms/) print $(i-3), $(i-2), $(i-1), $i}' | \
        awk '{gsub(/ms/,"",$NF); if($NF>1000) print}' | \
        head -10 >> "$output_file"
}

################################################################################
# Function: analyze_trading_activity
# Purpose: Analyze trading patterns
################################################################################
analyze_trading_activity() {
    local log_file=$1
    local output_file="$REPORT_DIR/analysis_$TIMESTAMP.txt"
    
    echo "" >> "$output_file"
    echo "=========================================" >> "$output_file"
    echo "TRADING ACTIVITY ANALYSIS" >> "$output_file"
    echo "=========================================" >> "$output_file"
    
    # Count successful trades
    local success_count=$(grep -c "Trade.*SUCCESS\|Trade.*COMPLETED" "$log_file" 2>/dev/null || echo "0")
    echo "Successful trades: $success_count" >> "$output_file"
    
    # Count failed trades
    local failed_count=$(grep -c "Trade.*FAILED\|Trade.*REJECTED" "$log_file" 2>/dev/null || echo "0")
    echo "Failed trades: $failed_count" >> "$output_file"
    
    # Calculate success rate
    if [ $((success_count + failed_count)) -gt 0 ]; then
        local success_rate=$((success_count * 100 / (success_count + failed_count)))
        echo "Success rate: $success_rate%" >> "$output_file"
    fi
    
    echo "" >> "$output_file"
    echo "Most active symbols:" >> "$output_file"
    grep -oE "Symbol:[A-Z]+" "$log_file" 2>/dev/null | \
        cut -d: -f2 | sort | uniq -c | sort -rn | head -10 >> "$output_file"
}

################################################################################
# Function: analyze_time_distribution
# Purpose: Analyze activity by time of day
################################################################################
analyze_time_distribution() {
    local log_file=$1
    local output_file="$REPORT_DIR/analysis_$TIMESTAMP.txt"
    
    echo "" >> "$output_file"
    echo "=========================================" >> "$output_file"
    echo "TIME DISTRIBUTION ANALYSIS" >> "$output_file"
    echo "=========================================" >> "$output_file"
    
    echo "Activity by hour:" >> "$output_file"
    # Assuming log format includes timestamp like: 2024-10-28 14:30:15
    grep -oE "[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}" "$log_file" 2>/dev/null | \
        awk '{print $2}' | sort | uniq -c | \
        awk '{printf "Hour %s: %d entries\n", $2, $1}' >> "$output_file"
}

################################################################################
# Function: find_critical_events
# Purpose: Extract critical events that need attention
################################################################################
find_critical_events() {
    local log_file=$1
    local output_file="$REPORT_DIR/analysis_$TIMESTAMP.txt"
    
    echo "" >> "$output_file"
    echo "=========================================" >> "$output_file"
    echo "CRITICAL EVENTS" >> "$output_file"
    echo "=========================================" >> "$output_file"
    
    # Connection failures
    echo "Database connection issues:" >> "$output_file"
    grep -i "connection.*fail\|connection.*timeout\|database.*error" "$log_file" 2>/dev/null | \
        head -5 >> "$output_file"
    
    echo "" >> "$output_file"
    
    # Market data issues
    echo "Market data feed issues:" >> "$output_file"
    grep -i "market data.*error\|feed.*disconnect\|price.*unavailable" "$log_file" 2>/dev/null | \
        head -5 >> "$output_file"
}

################################################################################
# Function: generate_summary
# Purpose: Generate executive summary
################################################################################
generate_summary() {
    local log_file=$1
    local output_file="$REPORT_DIR/analysis_$TIMESTAMP.txt"
    
    echo "" >> "$output_file"
    echo "=========================================" >> "$output_file"
    echo "EXECUTIVE SUMMARY" >> "$output_file"
    echo "=========================================" >> "$output_file"
    
    local total_lines=$(wc -l < "$log_file")
    echo "Total log entries: $total_lines" >> "$output_file"
    
    local date_range=$(awk 'NR==1{first=$1" "$2} END{print first " to " $1" "$2}' "$log_file")
    echo "Date range: $date_range" >> "$output_file"
    
    echo "Report generated: $(date)" >> "$output_file"
    echo "=========================================" >> "$output_file"
}

################################################################################
# Function: create_csv_report
# Purpose: Create CSV file with error details for further analysis
################################################################################
create_csv_report() {
    local log_file=$1
    local csv_file="$REPORT_DIR/errors_$TIMESTAMP.csv"
    
    echo "Timestamp,Level,Message" > "$csv_file"
    
    grep -E "ERROR|FATAL|CRITICAL" "$log_file" 2>/dev/null | \
        awk -F' ' '{
            timestamp=$1" "$2;
            level=$3;
            message="";
            for(i=4;i<=NF;i++) message=message" "$i;
            gsub(/,/," ",message);
            print timestamp","level","message
        }' >> "$csv_file"
    
    echo "CSV report created: $csv_file"
}

################################################################################
# Function: send_alert
# Purpose: Check if alerts should be sent based on thresholds
################################################################################
send_alert() {
    local log_file=$1
    local error_count=$(grep -c "ERROR" "$log_file" 2>/dev/null || echo "0")
    local fatal_count=$(grep -c "FATAL" "$log_file" 2>/dev/null || echo "0")
    
    # Alert thresholds
    local ERROR_THRESHOLD=100
    local FATAL_THRESHOLD=1
    
    if [ $fatal_count -gt $FATAL_THRESHOLD ]; then
        echo ""
        echo "⚠️  ALERT: FATAL errors detected ($fatal_count found)"
        echo "    Immediate attention required!"
    fi
    
    if [ $error_count -gt $ERROR_THRESHOLD ]; then
        echo ""
        echo "⚠️  ALERT: High error count ($error_count errors)"
        echo "    Threshold: $ERROR_THRESHOLD"
    fi
}

################################################################################
# Main Script
################################################################################
main() {
    # Check arguments
    if [ $# -ne 1 ]; then
        echo "Usage: $0 <log_file>"
        echo "Example: $0 trading_app.log"
        exit 1
    fi
    
    local log_file=$1
    
    # Validate log file exists
    if [ ! -f "$log_file" ]; then
        echo "ERROR: Log file '$log_file' not found"
        exit 1
    fi
    
    echo "========================================="
    echo "Starting Log Analysis"
    echo "========================================="
    echo "Log file: $log_file"
    echo "Report directory: $REPORT_DIR"
    echo ""
    
    # Setup and run analysis
    setup_environment
    
    echo "Analyzing error patterns..."
    analyze_error_patterns "$log_file"
    
    echo "Analyzing performance metrics..."
    analyze_performance "$log_file"
    
    echo "Analyzing trading activity..."
    analyze_trading_activity "$log_file"
    
    echo "Analyzing time distribution..."
    analyze_time_distribution "$log_file"
    
    echo "Finding critical events..."
    find_critical_events "$log_file"
    
    echo "Generating summary..."
    generate_summary "$log_file"
    
    echo "Creating CSV report..."
    create_csv_report "$log_file"
    
    # Check for alerts
    send_alert "$log_file"
    
    echo ""
    echo "========================================="
    echo "Analysis Complete!"
    echo "========================================="
    echo "Text report: $REPORT_DIR/analysis_$TIMESTAMP.txt"
    echo "CSV report: $REPORT_DIR/errors_$TIMESTAMP.csv"
    echo ""
    
    # Display summary on screen
    echo "Quick Summary:"
    grep -A 10 "EXECUTIVE SUMMARY" "$REPORT_DIR/analysis_$TIMESTAMP.txt"
}

# Run main function
main "$@"

