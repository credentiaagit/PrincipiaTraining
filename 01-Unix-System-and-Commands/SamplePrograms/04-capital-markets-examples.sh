#!/bin/bash
# 04-capital-markets-examples.sh
# Real-world examples for capital markets operations

echo "=================================================="
echo "CAPITAL MARKETS - UNIX OPERATIONS EXAMPLES"
echo "=================================================="
echo ""

# Create demo environment
DEMO_DIR="trading_demo_$$"
mkdir -p $DEMO_DIR/{data,logs,reports,archive,config}
cd $DEMO_DIR

echo "Created demo trading environment:"
ls -l
echo ""

# ===================================
# 1. MARKET DATA FILE PROCESSING
# ===================================
echo "1. MARKET DATA FILE PROCESSING"
echo "=============================="
echo ""

# Create sample market data
cat > data/market_data_20241028.csv << 'EOF'
Symbol,Open,High,Low,Close,Volume,Timestamp
AAPL,175.50,176.25,175.00,176.10,50000000,2024-10-28 16:00:00
GOOGL,140.25,141.50,140.00,141.30,30000000,2024-10-28 16:00:00
MSFT,380.75,382.00,380.50,381.90,40000000,2024-10-28 16:00:00
AMZN,145.60,146.80,145.30,146.50,35000000,2024-10-28 16:00:00
TSLA,265.40,268.50,264.80,267.90,60000000,2024-10-28 16:00:00
META,525.30,528.50,524.80,527.60,25000000,2024-10-28 16:00:00
NFLX,445.20,447.80,444.50,446.90,15000000,2024-10-28 16:00:00
EOF

echo "Sample market data file:"
head -3 data/market_data_20241028.csv
echo "..."
echo ""

echo "a) Validate file format:"
EXPECTED_COLS=7
ACTUAL_COLS=$(head -1 data/market_data_20241028.csv | awk -F',' '{print NF}')
if [ $ACTUAL_COLS -eq $EXPECTED_COLS ]; then
    echo "✓ File format valid ($ACTUAL_COLS columns)"
else
    echo "✗ File format invalid (expected $EXPECTED_COLS, got $ACTUAL_COLS)"
fi
echo ""

echo "b) Extract high-volume stocks (>40M):"
awk -F',' 'NR>1 && $6 > 40000000 {printf "%-6s Volume: %d\n", $1, $6}' data/market_data_20241028.csv
echo ""

echo "c) Calculate average closing price:"
awk -F',' 'NR>1 {sum+=$5; count++} END {printf "Average Close: $%.2f\n", sum/count}' data/market_data_20241028.csv
echo ""

echo "d) Find stocks with >2% daily gain:"
awk -F',' 'NR>1 {
    gain = (($5 - $2) / $2) * 100
    if (gain > 2) printf "%-6s: +%.2f%%\n", $1, gain
}' data/market_data_20241028.csv
echo ""

# ===================================
# 2. TRADE PROCESSING
# ===================================
echo "2. TRADE PROCESSING"
echo "==================="
echo ""

# Create sample trades
cat > data/trades_20241028.csv << 'EOF'
TradeID,Timestamp,Trader,Symbol,Side,Quantity,Price,Value,Status
T0001,2024-10-28 09:30:15,JOHN_DOE,AAPL,BUY,1000,175.50,175500,FILLED
T0002,2024-10-28 09:31:22,MARY_SMITH,GOOGL,SELL,500,140.25,70125,FILLED
T0003,2024-10-28 09:32:45,BOB_JONES,MSFT,BUY,750,380.75,285562.50,FILLED
T0004,2024-10-28 09:33:18,JOHN_DOE,AMZN,BUY,600,145.60,87360,FILLED
T0005,2024-10-28 09:34:52,ALICE_BROWN,TSLA,SELL,800,265.40,212320,FILLED
T0006,2024-10-28 09:35:33,MARY_SMITH,META,BUY,400,525.30,210120,FILLED
T0007,2024-10-28 09:36:41,BOB_JONES,AAPL,SELL,500,176.00,88000,FILLED
T0008,2024-10-28 09:37:25,JOHN_DOE,GOOGL,BUY,300,140.50,42150,FILLED
T0009,2024-10-28 09:38:09,ALICE_BROWN,MSFT,BUY,450,381.25,171562.50,FILLED
T0010,2024-10-28 09:39:47,MARY_SMITH,TSLA,BUY,1000,266.80,266800,FILLED
EOF

echo "a) Trade summary:"
TOTAL_TRADES=$(tail -n +2 data/trades_20241028.csv | wc -l)
TOTAL_VALUE=$(awk -F',' 'NR>1 {sum+=$8} END {print sum}' data/trades_20241028.csv)
echo "Total Trades: $TOTAL_TRADES"
printf "Total Value: \$%.2f\n" $TOTAL_VALUE
echo ""

echo "b) Trades by trader:"
awk -F',' 'NR>1 {trader[$3]++; value[$3]+=$8} 
    END {for(t in trader) printf "%-15s: %d trades, $%.2f\n", t, trader[t], value[t]}' \
    data/trades_20241028.csv | sort
echo ""

echo "c) Buy vs Sell analysis:"
awk -F',' 'NR>1 {
    side[$5]++
    value[$5]+=$8
}
END {
    for(s in side) printf "%-4s: %d trades, $%.2f\n", s, side[s], value[s]
}' data/trades_20241028.csv
echo ""

echo "d) Top 3 most traded symbols:"
awk -F',' 'NR>1 {symbol[$4]++} 
    END {for(s in symbol) print symbol[s], s}' data/trades_20241028.csv | \
    sort -rn | head -3 | awk '{printf "%-6s: %d trades\n", $2, $1}'
echo ""

echo "e) Large trades (>$200K):"
awk -F',' 'NR>1 && $8 > 200000 {
    printf "%-6s %-4s %d @ $%.2f = $%.2f by %s\n", $4, $5, $6, $7, $8, $3
}' data/trades_20241028.csv
echo ""

# ===================================
# 3. POSITION CALCULATION
# ===================================
echo "3. POSITION CALCULATION"
echo "======================="
echo ""

echo "Calculating end-of-day positions..."
awk -F',' 'NR>1 {
    symbol = $4
    qty = $6
    price = $7
    
    if ($5 == "BUY") {
        pos[symbol] += qty
        cost[symbol] += qty * price
    } else {
        pos[symbol] -= qty
        cost[symbol] -= qty * price
    }
}
END {
    printf "%-8s %10s %12s %15s\n", "Symbol", "Position", "Avg Price", "Market Value"
    printf "%-8s %10s %12s %15s\n", "------", "--------", "---------", "------------"
    for (sym in pos) {
        if (pos[sym] != 0) {
            avg = cost[sym] / pos[sym]
            value = pos[sym] * avg
            printf "%-8s %10d $%11.2f $%14.2f\n", sym, pos[sym], avg, value
        }
    }
}' data/trades_20241028.csv > reports/positions_20241028.txt

cat reports/positions_20241028.txt
echo ""

# ===================================
# 4. LOG FILE ANALYSIS
# ===================================
echo "4. LOG FILE ANALYSIS"
echo "===================="
echo ""

# Create sample log file
cat > logs/trading_20241028.log << 'EOF'
2024-10-28 09:30:15 INFO Trading session started
2024-10-28 09:30:20 INFO Connected to exchange gateway
2024-10-28 09:30:25 INFO Market data feed active
2024-10-28 09:31:10 INFO Order T0001 submitted
2024-10-28 09:31:15 INFO Order T0001 filled - AAPL 1000@175.50
2024-10-28 09:32:05 WARN Order T0002 delayed - High market volatility
2024-10-28 09:32:22 INFO Order T0002 filled - GOOGL 500@140.25
2024-10-28 09:33:40 ERROR Order T0003 rejected - Insufficient margin
2024-10-28 09:33:55 INFO Margin increased for account TRADER_001
2024-10-28 09:34:02 INFO Order T0003 resubmitted
2024-10-28 09:34:08 INFO Order T0003 filled - MSFT 750@380.75
2024-10-28 09:35:30 WARN Connection timeout to backup feed
2024-10-28 09:35:35 INFO Reconnected to backup feed
2024-10-28 09:40:12 ERROR Order T0011 rejected - Invalid symbol
2024-10-28 16:00:00 INFO Market close - Processing final trades
2024-10-28 16:05:30 INFO All trades settled successfully
2024-10-28 16:10:00 INFO EOD reports generated
2024-10-28 16:15:00 INFO Trading session closed
EOF

echo "a) Error count:"
ERROR_COUNT=$(grep -c "ERROR" logs/trading_20241028.log)
WARN_COUNT=$(grep -c "WARN" logs/trading_20241028.log)
echo "Errors: $ERROR_COUNT"
echo "Warnings: $WARN_COUNT"
echo ""

echo "b) All errors and warnings:"
grep -E "ERROR|WARN" logs/trading_20241028.log
echo ""

echo "c) Critical events timeline:"
grep -E "started|closed|ERROR" logs/trading_20241028.log | \
    awk '{print $1, $2, $3, ":", substr($0, index($0,$4))}'
echo ""

echo "d) Filled orders:"
grep "filled" logs/trading_20241028.log | wc -l
echo ""

# ===================================
# 5. RECONCILIATION
# ===================================
echo "5. TRADE RECONCILIATION"
echo "======================="
echo ""

# Create exchange confirmation file
cat > data/exchange_confirms_20241028.csv << 'EOF'
TradeID,Symbol,Quantity,Price,Timestamp
T0001,AAPL,1000,175.50,2024-10-28 09:31:15
T0002,GOOGL,500,140.25,2024-10-28 09:32:22
T0003,MSFT,750,380.75,2024-10-28 09:34:08
T0004,AMZN,600,145.60,2024-10-28 09:33:18
T0005,TSLA,800,265.40,2024-10-28 09:34:52
T0006,META,400,525.30,2024-10-28 09:35:33
T0007,AAPL,500,176.00,2024-10-28 09:36:41
T0008,GOOGL,300,140.50,2024-10-28 09:37:25
T0009,MSFT,450,381.25,2024-10-28 09:38:09
T0010,TSLA,1000,266.80,2024-10-28 09:39:47
EOF

echo "Reconciling internal trades with exchange confirmations..."
echo ""

# Extract trade IDs
tail -n +2 data/trades_20241028.csv | cut -d',' -f1 | sort > /tmp/internal_ids.txt
tail -n +2 data/exchange_confirms_20241028.csv | cut -d',' -f1 | sort > /tmp/exchange_ids.txt

# Find differences
UNMATCHED_INTERNAL=$(comm -23 /tmp/internal_ids.txt /tmp/exchange_ids.txt)
UNMATCHED_EXCHANGE=$(comm -13 /tmp/internal_ids.txt /tmp/exchange_ids.txt)

if [ -z "$UNMATCHED_INTERNAL" ] && [ -z "$UNMATCHED_EXCHANGE" ]; then
    echo "✓ RECONCILIATION SUCCESSFUL"
    echo "  All trades matched between internal and exchange"
else
    echo "✗ RECONCILIATION BREAKS FOUND"
    if [ ! -z "$UNMATCHED_INTERNAL" ]; then
        echo "  Internal trades not confirmed: $UNMATCHED_INTERNAL"
    fi
    if [ ! -z "$UNMATCHED_EXCHANGE" ]; then
        echo "  Exchange confirms not in internal: $UNMATCHED_EXCHANGE"
    fi
fi
echo ""

rm -f /tmp/internal_ids.txt /tmp/exchange_ids.txt

# ===================================
# 6. REPORT GENERATION
# ===================================
echo "6. DAILY REPORT GENERATION"
echo "=========================="
echo ""

# Generate daily summary report
cat > reports/daily_summary_20241028.txt << REPORT
========================================
DAILY TRADING SUMMARY
Date: 2024-10-28
========================================

TRADING ACTIVITY:
Total Trades: $TOTAL_TRADES
$(printf "Total Value: \$%.2f\n" $TOTAL_VALUE)

TRADER ACTIVITY:
$(awk -F',' 'NR>1 {trader[$3]++} END {for(t in trader) print "  "t": "trader[t]" trades"}' data/trades_20241028.csv | sort)

SYSTEM STATUS:
Errors: $ERROR_COUNT
Warnings: $WARN_COUNT
Reconciliation: PASSED

POSITIONS:
$(cat reports/positions_20241028.txt)

Report generated: $(date)
========================================
REPORT

echo "Daily report generated:"
cat reports/daily_summary_20241028.txt
echo ""

# ===================================
# 7. DATA ARCHIVAL
# ===================================
echo "7. DATA ARCHIVAL"
echo "================"
echo ""

echo "Archiving today's data..."

# Create archive
tar -czf archive/trading_data_20241028.tar.gz data/*.csv reports/*.txt logs/*.log

echo "Archive created:"
ls -lh archive/trading_data_20241028.tar.gz
echo ""

echo "Archive contents:"
tar -tzf archive/trading_data_20241028.tar.gz
echo ""

# ===================================
# 8. CLEANUP OLD FILES
# ===================================
echo "8. CLEANUP OLD FILES"
echo "===================="
echo ""

# Create some old files for demo
touch -t 202409010000 archive/old_file_1.tar.gz
touch -t 202408010000 archive/old_file_2.tar.gz

echo "Files before cleanup:"
ls -lh archive/
echo ""

echo "Removing files older than 60 days..."
find archive/ -name "*.tar.gz" -mtime +60 -exec ls -lh {} \;
find archive/ -name "*.tar.gz" -mtime +60 -delete

echo ""
echo "Files after cleanup:"
ls -lh archive/
echo ""

# ===================================
# SUMMARY
# ===================================
echo "=================================================="
echo "DEMONSTRATION COMPLETE"
echo "=================================================="
echo ""
echo "Demo directory created: $(pwd)"
echo ""
echo "Directory structure:"
tree -L 2 2>/dev/null || find . -type d -maxdepth 2 | sed 's|^\./||'
echo ""
echo "To clean up: cd .. && rm -rf $DEMO_DIR"
echo ""
echo "Real-world operations demonstrated:"
echo "  ✓ Market data file processing"
echo "  ✓ Trade execution and tracking"
echo "  ✓ Position calculation"
echo "  ✓ Log file analysis"
echo "  ✓ Trade reconciliation"
echo "  ✓ Report generation"
echo "  ✓ Data archival"
echo "  ✓ File cleanup and maintenance"
echo ""

