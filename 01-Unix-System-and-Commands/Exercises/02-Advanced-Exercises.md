# Unix Advanced Exercises

## Instructions
These exercises cover advanced topics and real-world scenarios.
- Attempt without looking at answers first
- Test your solutions
- Understand the logic, don't just memorize

---

## Section 1: Advanced Text Processing

### Exercise 1: Complex Log Parsing
**Task**: Given this log format:
```
[2024-10-28 09:15:23] [INFO] [TradeService] Order T001 executed: AAPL 100@175.50
[2024-10-28 09:16:45] [ERROR] [DBConnection] Connection timeout after 30s
[2024-10-28 09:17:12] [INFO] [TradeService] Order T002 executed: GOOGL 50@140.25
[2024-10-28 09:18:33] [WARN] [RiskEngine] Margin utilization at 85%
[2024-10-28 09:19:01] [ERROR] [TradeService] Order T003 rejected: Insufficient funds
```

Write commands to:
1. Extract just the timestamp and message (no brackets or level)
2. Count occurrences of each service component
3. Calculate average trades per minute
4. Find all rejected orders with reasons

**Answer**:
```bash
# Create log file
cat > complex.log << 'EOF'
[2024-10-28 09:15:23] [INFO] [TradeService] Order T001 executed: AAPL 100@175.50
[2024-10-28 09:16:45] [ERROR] [DBConnection] Connection timeout after 30s
[2024-10-28 09:17:12] [INFO] [TradeService] Order T002 executed: GOOGL 50@140.25
[2024-10-28 09:18:33] [WARN] [RiskEngine] Margin utilization at 85%
[2024-10-28 09:19:01] [ERROR] [TradeService] Order T003 rejected: Insufficient funds
EOF

# 1. Extract timestamp and message
sed 's/\[//g; s/\]//g' complex.log | awk '{$3=""; $4=""; print $1, $2, substr($0, index($0,$5))}'

# 2. Count service occurrences
grep -oP '\[\K[A-Z][a-z]+[A-Z][a-z]+' complex.log | sort | uniq -c

# 3. Average trades per minute
awk -F'[][]' '{split($2,t," "); split(t[2],tm,":"); minute=tm[1]":"tm[2]; count[minute]++} 
    END {for(m in count) total++; print "Minutes:", total, "Total entries:", length(count)*5/total}' complex.log

# 4. Rejected orders with reasons
grep "rejected" complex.log | sed 's/.*Order \([^ ]*\) rejected: \(.*\)/Order: \1, Reason: \2/'
```

---

### Exercise 2: CSV Data Transformation
**Task**: Transform this CSV:
```
Date,Open,High,Low,Close,Volume
2024-10-28,175.50,176.25,175.00,176.10,50000000
2024-10-27,174.80,175.60,174.50,175.50,45000000
```

To this format:
```
2024-10-28|OHLC:175.50/176.25/175.00/176.10|Vol:50M
2024-10-27|OHLC:174.80/175.60/174.50/175.50|Vol:45M
```

**Answer**:
```bash
# Create source file
cat > market.csv << 'EOF'
Date,Open,High,Low,Close,Volume
2024-10-28,175.50,176.25,175.00,176.10,50000000
2024-10-27,174.80,175.60,174.50,175.50,45000000
EOF

# Transform
awk -F',' 'NR>1 {
    vol_m = $6/1000000
    printf "%s|OHLC:%s/%s/%s/%s|Vol:%dM\n", $1, $2, $3, $4, $5, vol_m
}' market.csv
```

---

### Exercise 3: Multi-File Data Merge
**Task**: You have three files:
- `trades.csv`: TradeID,Symbol,Quantity,Price
- `traders.csv`: TraderID,TradeID,TraderName
- `symbols.csv`: Symbol,CompanyName

Write commands to create a report showing:
TradeID, CompanyName, Quantity, Price, TraderName

**Answer**:
```bash
# Create sample files
cat > trades.csv << 'EOF'
TradeID,Symbol,Quantity,Price
T001,AAPL,100,175.50
T002,GOOGL,50,140.25
T003,MSFT,75,380.75
EOF

cat > traders.csv << 'EOF'
TraderID,TradeID,TraderName
TR01,T001,John Smith
TR02,T002,Mary Jones
TR03,T003,Bob Williams
EOF

cat > symbols.csv << 'EOF'
Symbol,CompanyName
AAPL,Apple Inc
GOOGL,Google LLC
MSFT,Microsoft Corp
EOF

# Merge data using awk
awk -F',' '
NR==FNR && FNR>1 {symbol[$1]=$2; next}
NR!=FNR && FNR==1 {getline; next}
FNR>1 {
    tid=$1; sym=$2; qty=$3; price=$4
    while (getline < "traders.csv") {
        split($0, t, ",")
        if (t[2] == tid) {
            trader = t[3]
            break
        }
    }
    close("traders.csv")
    print tid, symbol[sym], qty, price, trader
}' symbols.csv trades.csv | column -t
```

---

## Section 2: System Administration

### Exercise 4: Disk Space Monitor
**Task**: Write a script that:
1. Checks disk usage of /opt directory
2. Alerts if usage > 80%
3. Shows top 10 largest files
4. Suggests cleanup actions

**Answer**:
```bash
#!/bin/bash
DIR="/opt"
THRESHOLD=80

echo "Disk Space Monitor for $DIR"
echo "=============================="
echo ""

# Get usage percentage
USAGE=$(df -h $DIR | tail -1 | awk '{print $5}' | sed 's/%//')

echo "Current usage: ${USAGE}%"
echo ""

if [ $USAGE -gt $THRESHOLD ]; then
    echo "⚠️  ALERT: Disk usage exceeds ${THRESHOLD}%!"
    echo ""
    
    echo "Top 10 largest files:"
    find $DIR -type f -exec du -h {} \; 2>/dev/null | sort -rh | head -10
    echo ""
    
    echo "Cleanup suggestions:"
    echo "1. Old log files:"
    find $DIR -name "*.log" -mtime +30 -exec ls -lh {} \; 2>/dev/null | head -5
    
    echo ""
    echo "2. Temporary files:"
    find $DIR -name "*.tmp" -o -name "*.temp" 2>/dev/null | head -5
    
    echo ""
    echo "3. Files older than 90 days:"
    find $DIR -type f -mtime +90 2>/dev/null | head -5
else
    echo "✓ Disk usage is within acceptable limits"
fi
```

---

### Exercise 5: Process Health Check
**Task**: Create a process monitoring script that:
1. Checks if specified processes are running
2. Shows CPU and memory usage
3. Restarts process if not running (simulated)
4. Logs all activities

**Answer**:
```bash
#!/bin/bash
PROCESSES=("sshd" "cron")
LOGFILE="/tmp/process_monitor_$$.log"

echo "Process Health Check - $(date)" | tee -a $LOGFILE
echo "======================================" | tee -a $LOGFILE

for proc in "${PROCESSES[@]}"; do
    echo "" | tee -a $LOGFILE
    echo "Checking: $proc" | tee -a $LOGFILE
    
    if pgrep -x "$proc" > /dev/null; then
        PID=$(pgrep -x "$proc" | head -1)
        CPU=$(ps -p $PID -o %cpu= | tr -d ' ')
        MEM=$(ps -p $PID -o %mem= | tr -d ' ')
        
        echo "  ✓ Running (PID: $PID)" | tee -a $LOGFILE
        echo "  CPU: ${CPU}%" | tee -a $LOGFILE
        echo "  MEM: ${MEM}%" | tee -a $LOGFILE
        
        # Alert if high resource usage
        if (( $(echo "$CPU > 80" | bc -l) )); then
            echo "  ⚠️  WARNING: High CPU usage!" | tee -a $LOGFILE
        fi
    else
        echo "  ✗ NOT RUNNING!" | tee -a $LOGFILE
        echo "  Would restart: /etc/init.d/$proc start" | tee -a $LOGFILE
    fi
done

echo "" | tee -a $LOGFILE
echo "Monitor log saved: $LOGFILE"
```

---

## Section 3: Real-World Capital Markets Scenarios

### Exercise 6: Trade Validation Pipeline
**Task**: Create a validation pipeline that:
1. Checks file exists and is not empty
2. Validates CSV format
3. Checks for required fields
4. Validates data types (numeric prices, quantities)
5. Checks for duplicates
6. Generates validation report

**Answer**:
```bash
#!/bin/bash
FILE="$1"
ERRORS=0

if [ -z "$FILE" ]; then
    echo "Usage: $0 <trade_file.csv>"
    exit 1
fi

echo "Trade File Validation Report"
echo "============================"
echo "File: $FILE"
echo "Time: $(date)"
echo ""

# 1. File exists and not empty
if [ ! -f "$FILE" ]; then
    echo "✗ CRITICAL: File does not exist"
    exit 1
fi

if [ ! -s "$FILE" ]; then
    echo "✗ CRITICAL: File is empty"
    exit 1
fi
echo "✓ File exists and has content"

# 2. Check line count
LINE_COUNT=$(wc -l < "$FILE")
echo "✓ Total lines: $LINE_COUNT"

# 3. Validate header
EXPECTED="TradeID,Symbol,Quantity,Price,Trader"
ACTUAL=$(head -1 "$FILE")
if [ "$ACTUAL" = "$EXPECTED" ]; then
    echo "✓ Header format valid"
else
    echo "✗ Invalid header"
    echo "  Expected: $EXPECTED"
    echo "  Got: $ACTUAL"
    ((ERRORS++))
fi

# 4. Check column count consistency
echo ""
echo "Column Count Validation:"
awk -F',' 'NR==1 {cols=NF} NR>1 && NF!=cols {print "  ✗ Line", NR, "has", NF, "columns (expected", cols")"}' "$FILE"

# 5. Validate data types
echo ""
echo "Data Type Validation:"
awk -F',' 'NR>1 {
    # Check quantity is positive integer
    if ($3 !~ /^[0-9]+$/ || $3 <= 0) {
        print "  ✗ Line", NR, ": Invalid quantity -", $3
        errors++
    }
    # Check price is valid number
    if ($4 !~ /^[0-9]+\.?[0-9]*$/ || $4 <= 0) {
        print "  ✗ Line", NR, ": Invalid price -", $4
        errors++
    }
}
END {
    if (errors == 0) print "  ✓ All data types valid"
    exit errors
}' "$FILE"
VALIDATION_ERRORS=$?
ERRORS=$((ERRORS + VALIDATION_ERRORS))

# 6. Check for duplicates
echo ""
echo "Duplicate Check:"
DUPES=$(tail -n +2 "$FILE" | cut -d',' -f1 | sort | uniq -d)
if [ -z "$DUPES" ]; then
    echo "  ✓ No duplicate trade IDs"
else
    echo "  ✗ Duplicate trade IDs found:"
    echo "$DUPES" | sed 's/^/    /'
    ((ERRORS++))
fi

# 7. Business rules validation
echo ""
echo "Business Rules Validation:"
awk -F',' 'NR>1 {
    value = $3 * $4
    if (value > 1000000) {
        print "  ⚠️  Line", NR, ": Large trade >$1M -", $1, value
        warnings++
    }
}
END {
    if (warnings > 0) print "  Total warnings:", warnings
    else print "  ✓ All trades within normal limits"
}' "$FILE"

# Summary
echo ""
echo "============================"
if [ $ERRORS -eq 0 ]; then
    echo "✓ VALIDATION PASSED"
    exit 0
else
    echo "✗ VALIDATION FAILED ($ERRORS errors)"
    exit 1
fi
```

---

### Exercise 7: End-of-Day Reconciliation
**Task**: Create a reconciliation script that compares internal trades with exchange confirmations and reports breaks.

**Answer**:
```bash
#!/bin/bash
INTERNAL="internal_trades.csv"
EXCHANGE="exchange_confirms.csv"
REPORT="reconciliation_$(date +%Y%m%d).txt"

exec > >(tee $REPORT)

echo "========================================="
echo "TRADE RECONCILIATION REPORT"
echo "Date: $(date)"
echo "========================================="
echo ""

# Count trades
INT_COUNT=$(tail -n +2 $INTERNAL | wc -l)
EXC_COUNT=$(tail -n +2 $EXCHANGE | wc -l)

echo "Trade Counts:"
echo "  Internal: $INT_COUNT"
echo "  Exchange: $EXC_COUNT"
echo ""

# Find unmatched trades
echo "Unmatched Analysis:"
echo "-------------------"

# Extract and sort trade IDs
tail -n +2 $INTERNAL | cut -d',' -f1 | sort > /tmp/internal_ids.txt
tail -n +2 $EXCHANGE | cut -d',' -f1 | sort > /tmp/exchange_ids.txt

# Internal trades not confirmed
UNMATCHED_INT=$(comm -23 /tmp/internal_ids.txt /tmp/exchange_ids.txt)
INT_BREAK_COUNT=$(echo "$UNMATCHED_INT" | grep -c "T")

if [ $INT_BREAK_COUNT -gt 0 ]; then
    echo "Internal trades NOT confirmed by exchange:"
    echo "$UNMATCHED_INT" | while read tid; do
        grep "$tid" $INTERNAL
    done
    echo ""
fi

# Exchange confirms not in internal
UNMATCHED_EXC=$(comm -13 /tmp/internal_ids.txt /tmp/exchange_ids.txt)
EXC_BREAK_COUNT=$(echo "$UNMATCHED_EXC" | grep -c "T")

if [ $EXC_BREAK_COUNT -gt 0 ]; then
    echo "Exchange confirmations NOT in internal system:"
    echo "$UNMATCHED_EXC" | while read tid; do
        grep "$tid" $EXCHANGE
    done
    echo ""
fi

# Value comparison for matched trades
echo "Value Comparison:"
echo "-----------------"
comm -12 /tmp/internal_ids.txt /tmp/exchange_ids.txt | while read tid; do
    INT_LINE=$(grep "$tid" $INTERNAL)
    EXC_LINE=$(grep "$tid" $EXCHANGE)
    
    INT_QTY=$(echo "$INT_LINE" | cut -d',' -f3)
    EXC_QTY=$(echo "$EXC_LINE" | cut -d',' -f3)
    
    INT_PRICE=$(echo "$INT_LINE" | cut -d',' -f4)
    EXC_PRICE=$(echo "$EXC_LINE" | cut -d',' -f4)
    
    if [ "$INT_QTY" != "$EXC_QTY" ] || [ "$INT_PRICE" != "$EXC_PRICE" ]; then
        echo "  ✗ Mismatch for $tid:"
        echo "    Internal: Qty=$INT_QTY, Price=$INT_PRICE"
        echo "    Exchange: Qty=$EXC_QTY, Price=$EXC_PRICE"
    fi
done

# Summary
echo ""
echo "========================================="
echo "SUMMARY"
echo "========================================="
TOTAL_BREAKS=$((INT_BREAK_COUNT + EXC_BREAK_COUNT))
if [ $TOTAL_BREAKS -eq 0 ]; then
    echo "✓ RECONCILIATION PASSED"
    echo "  All trades matched successfully"
else
    echo "✗ RECONCILIATION BREAKS FOUND"
    echo "  Internal breaks: $INT_BREAK_COUNT"
    echo "  Exchange breaks: $EXC_BREAK_COUNT"
    echo "  Total breaks: $TOTAL_BREAKS"
fi

# Cleanup
rm -f /tmp/internal_ids.txt /tmp/exchange_ids.txt

echo ""
echo "Report saved: $REPORT"
```

---

### Exercise 8: Performance Monitoring Script
**Task**: Create a real-time performance monitoring dashboard for trading system.

**Answer**:
```bash
#!/bin/bash

# Colors for terminal output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

monitor_system() {
    while true; do
        clear
        echo "========================================="
        echo " TRADING SYSTEM PERFORMANCE MONITOR"
        echo " $(date)"
        echo "========================================="
        echo ""
        
        # System Load
        echo "SYSTEM LOAD:"
        LOAD=$(uptime | awk -F'load average:' '{print $2}')
        echo "  Load Average: $LOAD"
        
        # CPU Usage
        CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
        echo -n "  CPU Usage: "
        if (( $(echo "$CPU_USAGE > 80" | bc -l) )); then
            echo -e "${RED}${CPU_USAGE}% (HIGH)${NC}"
        elif (( $(echo "$CPU_USAGE > 50" | bc -l) )); then
            echo -e "${YELLOW}${CPU_USAGE}% (MEDIUM)${NC}"
        else
            echo -e "${GREEN}${CPU_USAGE}% (OK)${NC}"
        fi
        
        # Memory Usage
        MEM_INFO=$(free | grep Mem)
        MEM_TOTAL=$(echo $MEM_INFO | awk '{print $2}')
        MEM_USED=$(echo $MEM_INFO | awk '{print $3}')
        MEM_PERCENT=$(echo "scale=1; $MEM_USED * 100 / $MEM_TOTAL" | bc)
        echo -n "  Memory Usage: "
        if (( $(echo "$MEM_PERCENT > 80" | bc -l) )); then
            echo -e "${RED}${MEM_PERCENT}% (HIGH)${NC}"
        else
            echo -e "${GREEN}${MEM_PERCENT}% (OK)${NC}"
        fi
        echo ""
        
        # Disk Usage
        echo "DISK USAGE (/opt):"
        df -h /opt 2>/dev/null | tail -1 | awk '{
            printf "  Space: %s / %s (%s used)\n", $3, $2, $5
        }'
        echo ""
        
        # Critical Processes
        echo "CRITICAL PROCESSES:"
        PROCESSES="bash"  # Replace with actual process names
        for proc in $PROCESSES; do
            if pgrep -x "$proc" > /dev/null; then
                PID=$(pgrep -x "$proc" | head -1)
                PS_INFO=$(ps -p $PID -o %cpu,%mem,etime)
                echo -e "  ${GREEN}✓${NC} $proc: $(echo $PS_INFO | tail -1)"
            else
                echo -e "  ${RED}✗${NC} $proc: NOT RUNNING"
            fi
        done
        echo ""
        
        # Recent Errors (if log file exists)
        if [ -f "/var/log/trading.log" ]; then
            echo "RECENT ERRORS (last 5 min):"
            ERROR_COUNT=$(find /var/log/trading.log -mmin -5 -exec grep -c "ERROR" {} \; 2>/dev/null)
            if [ "$ERROR_COUNT" -gt 0 ]; then
                echo -e "  ${RED}⚠️  $ERROR_COUNT errors${NC}"
            else
                echo -e "  ${GREEN}✓ No recent errors${NC}"
            fi
        fi
        
        echo ""
        echo "========================================="
        echo "Refreshing in 5 seconds... (Ctrl+C to exit)"
        
        sleep 5
    done
}

monitor_system
```

---

## Section 4: Challenge Problems

### Exercise 9: Advanced Pipeline Challenge
**Task**: Given multiple log files, create a one-liner that:
- Finds all ERROR entries across all files
- Extracts error codes (format: ERR-XXXX)
- Counts occurrences of each error code
- Sorts by frequency
- Shows top 5

**Answer**:
```bash
find . -name "*.log" -exec grep "ERROR" {} \; | grep -oP 'ERR-\d{4}' | sort | uniq -c | sort -rn | head -5
```

---

### Exercise 10: Data Transformation Challenge
**Task**: Convert this input:
```
AAPL:100:175.50,200:176.00
GOOGL:50:140.25,75:141.00
```

To this output:
```
Symbol,TotalQty,AvgPrice
AAPL,300,175.83
GOOGL,125,140.70
```

**Answer**:
```bash
cat input.txt | awk -F'[:|,]' '{
    symbol = $1
    total_qty = 0
    total_value = 0
    for (i = 2; i <= NF; i += 2) {
        qty = $i
        price = $(i+1)
        total_qty += qty
        total_value += qty * price
    }
    printf "%s,%d,%.2f\n", symbol, total_qty, total_value/total_qty
}' > output.csv
```

---

## Tips for Success

1. **Test Incrementally**: Build complex commands step by step
2. **Use Variables**: Make scripts maintainable
3. **Error Handling**: Always check for edge cases
4. **Performance**: Consider efficiency for large files
5. **Documentation**: Comment your complex logic
6. **Validation**: Always validate input data
7. **Logging**: Log important operations

---

## Next Steps

1. Practice these scenarios with real project data
2. Create your own variations
3. Time your solutions for performance analysis
4. Move to Shell Scripting advanced topics
5. Study error handling and debugging techniques

---

## Additional Challenges

Try creating scripts for:
- Automated backup with rotation
- Log rotation and compression
- System health alerts via email
- Database connection pool monitoring
- Network latency tracking
- File integrity checking (checksums)

---

**Congratulations on completing the advanced exercises!** 🎉

These skills will serve you well in production support and operations.

