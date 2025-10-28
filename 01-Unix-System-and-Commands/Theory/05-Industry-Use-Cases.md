# Industry Use Cases - Capital Markets

## Table of Contents
1. [Overview](#overview)
2. [End-of-Day Processing](#end-of-day-processing)
3. [Real-time Trade Monitoring](#real-time-trade-monitoring)
4. [Data File Management](#data-file-management)
5. [System Health Monitoring](#system-health-monitoring)
6. [Audit and Compliance](#audit-and-compliance)
7. [Disaster Recovery](#disaster-recovery)

---

## Overview

In capital markets, Unix systems are the backbone of:
- **Trading platforms**: High-frequency and algorithmic trading
- **Risk management systems**: Real-time risk calculations
- **Market data processing**: Processing millions of market updates
- **Settlement systems**: Trade settlement and reconciliation
- **Reporting systems**: Regulatory and internal reporting

---

## End-of-Day Processing

### Scenario
Every trading day ends with critical processing tasks that must complete before next day's trading begins.

### Workflow

```
Market Close (4:00 PM)
    ↓
Data Collection (4:00-4:30 PM)
    ↓
Trade Reconciliation (4:30-5:30 PM)
    ↓
Position Calculation (5:30-6:30 PM)
    ↓
Risk Reports (6:30-7:30 PM)
    ↓
Regulatory Reports (7:30-8:30 PM)
    ↓
Archive & Backup (8:30-9:00 PM)
    ↓
System Ready for Next Day
```

### Key Unix Operations

**1. Data Collection Script**
```bash
#!/bin/bash
# collect_eod_data.sh
# Collects data from multiple sources

DATE=$(date +%Y%m%d)
DATA_DIR="/opt/trading/data"
INCOMING="$DATA_DIR/incoming"
PROCESSED="$DATA_DIR/processed/$DATE"

echo "Starting EOD data collection - $DATE"

# Create directories
mkdir -p $PROCESSED

# Collect from FTP server
cd $INCOMING
lftp -c "open ftp.exchange.com; mget trades_$DATE*.csv"

# Validate file counts
EXPECTED=5
RECEIVED=$(ls -1 trades_$DATE*.csv 2>/dev/null | wc -l)

if [ $RECEIVED -eq $EXPECTED ]; then
    echo "✓ All files received ($RECEIVED/$EXPECTED)"
    # Move to processing
    mv trades_$DATE*.csv $PROCESSED/
else
    echo "✗ Missing files! ($RECEIVED/$EXPECTED)"
    exit 1
fi
```

**2. Trade Reconciliation**
```bash
#!/bin/bash
# reconcile_trades.sh
# Compare internal trades with exchange confirmations

DATE=$(date +%Y%m%d)
INTERNAL="/opt/trading/data/internal/trades_$DATE.csv"
EXCHANGE="/opt/trading/data/exchange/confirms_$DATE.csv"
REPORT="/opt/trading/reports/recon_$DATE.txt"

echo "Trade Reconciliation Report - $DATE" > $REPORT
echo "=================================" >> $REPORT
echo "" >> $REPORT

# Count trades
INTERNAL_COUNT=$(wc -l < $INTERNAL)
EXCHANGE_COUNT=$(wc -l < $EXCHANGE)

echo "Internal Trades: $INTERNAL_COUNT" >> $REPORT
echo "Exchange Confirms: $EXCHANGE_COUNT" >> $REPORT
echo "" >> $REPORT

# Find unmatched trades (simple example)
echo "Unmatched Internal Trades:" >> $REPORT
comm -23 <(sort $INTERNAL) <(sort $EXCHANGE) >> $REPORT

echo "Unmatched Exchange Confirms:" >> $REPORT
comm -13 <(sort $INTERNAL) <(sort $EXCHANGE) >> $REPORT

# Check if reconciled
if [ $INTERNAL_COUNT -eq $EXCHANGE_COUNT ]; then
    echo "Status: RECONCILED ✓" >> $REPORT
else
    echo "Status: BREAKS FOUND ✗" >> $REPORT
fi
```

**3. Position Calculation**
```bash
#!/bin/bash
# calculate_positions.sh
# Calculate end-of-day positions

DATE=$(date +%Y%m%d)
TRADES="/opt/trading/data/processed/$DATE/trades_$DATE.csv"
POSITIONS="/opt/trading/data/positions/positions_$DATE.csv"

echo "Calculating positions for $DATE..."

# Use awk to aggregate positions by security
awk -F',' '
BEGIN {
    print "Security,Quantity,AvgPrice,MarketValue"
}
NR > 1 {
    security = $1
    qty = $3
    price = $4
    
    pos[security] += qty
    total_cost[security] += qty * price
    count[security]++
}
END {
    for (sec in pos) {
        if (pos[sec] != 0) {
            avg_price = total_cost[sec] / pos[sec]
            market_value = pos[sec] * avg_price
            printf "%s,%d,%.2f,%.2f\n", sec, pos[sec], avg_price, market_value
        }
    }
}' $TRADES | sort > $POSITIONS

echo "Positions calculated: $(wc -l < $POSITIONS) securities"
```

---

## Real-time Trade Monitoring

### Scenario
Monitor trading activity in real-time, detect anomalies, and alert on issues.

### Monitoring Scripts

**1. Real-time Log Monitor**
```bash
#!/bin/bash
# monitor_trades.sh
# Monitor trading log for errors and anomalies

LOG="/opt/trading/logs/trading_$(date +%Y%m%d).log"
ALERT_EMAIL="operations@trading.com"

echo "Monitoring trades log: $LOG"

tail -f $LOG | while read line; do
    # Check for errors
    if echo "$line" | grep -qi "ERROR"; then
        echo "ERROR DETECTED: $line"
        echo "$line" | mail -s "Trading Error Alert" $ALERT_EMAIL
    fi
    
    # Check for large trades (>$1M)
    if echo "$line" | grep -q "TRADE"; then
        amount=$(echo "$line" | awk '{print $8}')
        if [ ${amount%.*} -gt 1000000 ]; then
            echo "LARGE TRADE: $line"
            echo "$line" | mail -s "Large Trade Alert" $ALERT_EMAIL
        fi
    fi
    
    # Check for high frequency from single trader
    trader=$(echo "$line" | awk '{print $5}')
    # Count trades in last minute (simplified)
    count=$(grep "$trader" $LOG | tail -100 | wc -l)
    if [ $count -gt 50 ]; then
        echo "HIGH FREQUENCY DETECTED: Trader $trader"
    fi
done
```

**2. System Health Monitor**
```bash
#!/bin/bash
# health_check.sh
# Continuous system health monitoring

while true; do
    clear
    echo "=== Trading System Health Monitor ==="
    echo "Time: $(date)"
    echo ""
    
    # Check disk space
    echo "Disk Usage:"
    df -h /opt/trading | tail -1 | awk '{
        if ($5 > 80) 
            print "  WARNING: "$5" used"
        else 
            print "  OK: "$5" used"
    }'
    echo ""
    
    # Check memory
    echo "Memory Usage:"
    free -h | grep Mem | awk '{
        used = $3
        total = $2
        print "  Used: "used" / "total
    }'
    echo ""
    
    # Check trading process
    echo "Trading Application:"
    if pgrep -x "trading_app" > /dev/null; then
        echo "  ✓ Running"
        echo "  PID: $(pgrep -x trading_app)"
        echo "  CPU: $(ps -p $(pgrep -x trading_app) -o %cpu | tail -1)%"
        echo "  MEM: $(ps -p $(pgrep -x trading_app) -o %mem | tail -1)%"
    else
        echo "  ✗ NOT RUNNING - CRITICAL!"
    fi
    echo ""
    
    # Check database connection
    echo "Database Connection:"
    if nc -z -w5 db-server 5432 2>/dev/null; then
        echo "  ✓ Connected"
    else
        echo "  ✗ Cannot connect - CRITICAL!"
    fi
    echo ""
    
    # Recent errors
    echo "Recent Errors (last 5 min):"
    ERROR_COUNT=$(find /opt/trading/logs -name "*.log" -mmin -5 -exec grep -c "ERROR" {} \; | awk '{sum+=$1} END {print sum}')
    echo "  Count: $ERROR_COUNT"
    
    sleep 30
done
```

---

## Data File Management

### Scenario
Manage incoming market data files, validate, process, and archive.

### File Management Scripts

**1. Automated File Ingestion**
```bash
#!/bin/bash
# ingest_market_data.sh
# Watch directory for incoming files and process them

WATCH_DIR="/opt/trading/data/incoming"
PROCESS_DIR="/opt/trading/data/processing"
ARCHIVE_DIR="/opt/trading/data/archive/$(date +%Y%m%d)"

mkdir -p $ARCHIVE_DIR

# Use inotifywait to watch for new files (if available)
# Otherwise, simple polling

while true; do
    for file in $WATCH_DIR/*.csv; do
        [ -f "$file" ] || continue
        
        filename=$(basename "$file")
        echo "Processing: $filename"
        
        # Validate file
        if [ -s "$file" ]; then
            # Check if file is complete (not being written)
            size1=$(wc -c < "$file")
            sleep 2
            size2=$(wc -c < "$file")
            
            if [ $size1 -eq $size2 ]; then
                # File is complete, process it
                echo "  Validating..."
                
                # Check header
                header=$(head -1 "$file")
                if echo "$header" | grep -q "Symbol,Price,Volume"; then
                    echo "  ✓ Valid format"
                    
                    # Move to processing
                    mv "$file" "$PROCESS_DIR/"
                    
                    # Process the file (call your TCL script)
                    /opt/trading/bin/process_market_data.tcl "$PROCESS_DIR/$filename"
                    
                    # Archive
                    gzip "$PROCESS_DIR/$filename"
                    mv "$PROCESS_DIR/$filename.gz" "$ARCHIVE_DIR/"
                    
                    echo "  ✓ Processed and archived"
                else
                    echo "  ✗ Invalid format"
                    mv "$file" "$WATCH_DIR/error/"
                fi
            fi
        fi
    done
    
    sleep 10
done
```

**2. File Validation**
```bash
#!/bin/bash
# validate_data_file.sh
# Comprehensive data file validation

FILE=$1
ERRORS=0

echo "Validating: $FILE"

# Check if file exists and is readable
if [ ! -r "$FILE" ]; then
    echo "✗ File not readable"
    exit 1
fi

# Check if file is not empty
if [ ! -s "$FILE" ]; then
    echo "✗ File is empty"
    exit 1
fi

# Check header
EXPECTED_HEADER="TradeID,Symbol,Quantity,Price,Timestamp"
ACTUAL_HEADER=$(head -1 "$FILE")

if [ "$ACTUAL_HEADER" != "$EXPECTED_HEADER" ]; then
    echo "✗ Invalid header"
    echo "  Expected: $EXPECTED_HEADER"
    echo "  Got: $ACTUAL_HEADER"
    ((ERRORS++))
fi

# Check line count
LINE_COUNT=$(wc -l < "$FILE")
echo "✓ Lines: $LINE_COUNT"

# Check for duplicate IDs
DUPLICATE_COUNT=$(tail -n +2 "$FILE" | cut -d',' -f1 | sort | uniq -d | wc -l)
if [ $DUPLICATE_COUNT -gt 0 ]; then
    echo "✗ Found $DUPLICATE_COUNT duplicate trade IDs"
    ((ERRORS++))
else
    echo "✓ No duplicate IDs"
fi

# Validate data formats
echo "Checking data formats..."
awk -F',' 'NR>1 {
    # Check quantity is numeric
    if ($3 !~ /^[0-9]+$/) {
        print "✗ Line "NR": Invalid quantity - "$3
        errors++
    }
    # Check price is numeric with decimals
    if ($4 !~ /^[0-9]+\.[0-9]+$/) {
        print "✗ Line "NR": Invalid price - "$4
        errors++
    }
    # Check timestamp format
    if ($5 !~ /^[0-9]{4}-[0-9]{2}-[0-9]{2}/) {
        print "✗ Line "NR": Invalid timestamp - "$5
        errors++
    }
}
END {
    if (errors == 0) {
        print "✓ All data formats valid"
    }
    exit errors
}' "$FILE"

if [ $? -eq 0 ] && [ $ERRORS -eq 0 ]; then
    echo ""
    echo "✓ File validation PASSED"
    exit 0
else
    echo ""
    echo "✗ File validation FAILED"
    exit 1
fi
```

**3. Archive Management**
```bash
#!/bin/bash
# manage_archives.sh
# Compress old files and manage archive retention

ARCHIVE_ROOT="/opt/trading/data/archive"
RETENTION_DAYS=90

echo "Archive Management - $(date)"

# Compress files older than 7 days
echo "Compressing files older than 7 days..."
find $ARCHIVE_ROOT -type f -name "*.csv" -mtime +7 -exec gzip {} \;

# Delete files older than retention period
echo "Removing files older than $RETENTION_DAYS days..."
find $ARCHIVE_ROOT -type f -name "*.gz" -mtime +$RETENTION_DAYS -delete

# Generate archive report
echo ""
echo "Archive Summary:"
echo "  Total files: $(find $ARCHIVE_ROOT -type f | wc -l)"
echo "  Compressed: $(find $ARCHIVE_ROOT -name "*.gz" | wc -l)"
echo "  Disk usage: $(du -sh $ARCHIVE_ROOT | cut -f1)"

# List largest archives
echo ""
echo "Top 10 largest archives:"
find $ARCHIVE_ROOT -type f -exec du -h {} \; | sort -rh | head -10
```

---

## System Health Monitoring

### Daily Health Check Script

```bash
#!/bin/bash
# daily_health_check.sh
# Comprehensive daily system health check

DATE=$(date +%Y%m%d)
REPORT="/opt/trading/reports/health_$DATE.txt"
THRESHOLD_DISK=80
THRESHOLD_CPU=70
THRESHOLD_MEM=80

exec > >(tee $REPORT)
exec 2>&1

echo "========================================="
echo "Daily System Health Check"
echo "Date: $(date)"
echo "Host: $(hostname)"
echo "========================================="
echo ""

# 1. Disk Space Check
echo "1. DISK SPACE CHECK"
echo "-------------------"
df -h | grep -E '^/dev' | awk -v threshold=$THRESHOLD_DISK '
{
    use = $5
    gsub(/%/, "", use)
    status = (use >= threshold) ? "WARNING" : "OK"
    printf "%-20s %-10s %-10s %s\n", $6, $5, $4, status
}'
echo ""

# 2. Memory Check
echo "2. MEMORY CHECK"
echo "---------------"
free -h | grep Mem | awk '{
    printf "Total: %s, Used: %s, Free: %s\n", $2, $3, $4
}'
MEM_PERCENT=$(free | grep Mem | awk '{printf "%.0f", $3/$2 * 100}')
if [ $MEM_PERCENT -ge $THRESHOLD_MEM ]; then
    echo "Status: WARNING - ${MEM_PERCENT}% used"
else
    echo "Status: OK - ${MEM_PERCENT}% used"
fi
echo ""

# 3. CPU Load
echo "3. CPU LOAD"
echo "-----------"
uptime
LOAD=$(uptime | awk -F'load average:' '{print $2}' | awk '{print $1}' | cut -d'.' -f1)
echo "Current load: $LOAD"
echo ""

# 4. Critical Processes
echo "4. CRITICAL PROCESSES"
echo "---------------------"
PROCESSES="trading_app market_feed_handler risk_engine"
for proc in $PROCESSES; do
    if pgrep -x "$proc" > /dev/null; then
        PID=$(pgrep -x "$proc")
        CPU=$(ps -p $PID -o %cpu | tail -1)
        MEM=$(ps -p $PID -o %mem | tail -1)
        echo "✓ $proc running (PID: $PID, CPU: ${CPU}%, MEM: ${MEM}%)"
    else
        echo "✗ $proc NOT RUNNING - CRITICAL!"
    fi
done
echo ""

# 5. Network Connectivity
echo "5. NETWORK CONNECTIVITY"
echo "-----------------------"
HOSTS="db-server:5432 market-feed:8080 backup-server:22"
for host_port in $HOSTS; do
    host=$(echo $host_port | cut -d':' -f1)
    port=$(echo $host_port | cut -d':' -f2)
    
    if nc -z -w5 $host $port 2>/dev/null; then
        echo "✓ $host:$port reachable"
    else
        echo "✗ $host:$port UNREACHABLE - CRITICAL!"
    fi
done
echo ""

# 6. Log Errors
echo "6. ERROR ANALYSIS (last 24 hours)"
echo "----------------------------------"
find /opt/trading/logs -name "*.log" -mtime -1 | while read log; do
    error_count=$(grep -c "ERROR" "$log" 2>/dev/null)
    if [ $error_count -gt 0 ]; then
        echo "$(basename $log): $error_count errors"
    fi
done
echo ""

# 7. Recent Trades
echo "7. TRADING ACTIVITY (last hour)"
echo "-------------------------------"
if [ -f "/opt/trading/logs/trading_$DATE.log" ]; then
    TRADES=$(grep -c "TRADE_COMPLETE" /opt/trading/logs/trading_$DATE.log)
    echo "Completed trades: $TRADES"
else
    echo "No trading log found"
fi
echo ""

# 8. Backup Status
echo "8. BACKUP STATUS"
echo "----------------"
BACKUP_FILE="/backup/trading_$(date +%Y%m%d).tar.gz"
if [ -f "$BACKUP_FILE" ]; then
    echo "✓ Today's backup exists"
    echo "  Size: $(du -h $BACKUP_FILE | cut -f1)"
    echo "  Time: $(stat -c %y $BACKUP_FILE 2>/dev/null || stat -f %Sm $BACKUP_FILE)"
else
    echo "✗ Today's backup NOT FOUND - WARNING!"
fi
echo ""

echo "========================================="
echo "Health check completed at $(date)"
echo "========================================="

# Email report
mail -s "Daily Health Check - $(hostname)" operations@trading.com < $REPORT
```

---

## Audit and Compliance

### Trade Audit Trail Script

```bash
#!/bin/bash
# generate_audit_trail.sh
# Generate audit trail for regulatory compliance

START_DATE=$1
END_DATE=$2
OUTPUT_FILE="/opt/trading/reports/audit_${START_DATE}_${END_DATE}.csv"

echo "Generating audit trail: $START_DATE to $END_DATE"

# Header
echo "Timestamp,TradeID,Trader,Action,Symbol,Quantity,Price,Status,Notes" > $OUTPUT_FILE

# Collect from multiple sources
for date in $(seq $(date -d $START_DATE +%s) 86400 $(date -d $END_DATE +%s)); do
    DATE_STR=$(date -d @$date +%Y%m%d)
    LOG_FILE="/opt/trading/logs/trading_$DATE_STR.log"
    
    if [ -f "$LOG_FILE" ]; then
        # Extract trade records
        grep "TRADE" "$LOG_FILE" | \
        awk -F'|' '{
            printf "%s,%s,%s,%s,%s,%s,%s,%s,%s\n",
            $1, $2, $3, $4, $5, $6, $7, $8, $9
        }' >> $OUTPUT_FILE
    fi
done

# Validation
TRADE_COUNT=$(wc -l < $OUTPUT_FILE)
echo "Audit trail generated: $TRADE_COUNT records"

# Check for anomalies
echo ""
echo "Audit Analysis:"
echo "---------------"

# Large trades
echo "Trades over $1M:"
awk -F',' 'NR>1 && $7 > 1000000 {print}' $OUTPUT_FILE | wc -l

# Failed trades
echo "Failed trades:"
awk -F',' 'NR>1 && $8 == "FAILED" {print}' $OUTPUT_FILE | wc -l

# Top traders by volume
echo ""
echo "Top 10 traders by volume:"
awk -F',' 'NR>1 {trader[$3] += $6} END {
    for (t in trader) print t, trader[t]
}' $OUTPUT_FILE | sort -k2 -rn | head -10

# Create digital signature
sha256sum $OUTPUT_FILE > ${OUTPUT_FILE}.sha256
echo ""
echo "Audit file: $OUTPUT_FILE"
echo "Checksum: ${OUTPUT_FILE}.sha256"
```

---

## Disaster Recovery

### Backup and Recovery Scripts

**1. Full System Backup**
```bash
#!/bin/bash
# full_backup.sh
# Complete system backup

DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_ROOT="/backup"
BACKUP_DIR="$BACKUP_ROOT/full_$DATE"
LOG="$BACKUP_ROOT/backup_$DATE.log"

exec > >(tee $LOG)
exec 2>&1

echo "Starting full backup: $DATE"
mkdir -p $BACKUP_DIR

# 1. Application binaries
echo "Backing up application..."
tar -czf $BACKUP_DIR/application.tar.gz /opt/trading/bin/ 2>/dev/null

# 2. Configuration files
echo "Backing up configuration..."
tar -czf $BACKUP_DIR/config.tar.gz /opt/trading/config/ 2>/dev/null

# 3. Data files (last 30 days)
echo "Backing up recent data..."
find /opt/trading/data -mtime -30 -type f | \
tar -czf $BACKUP_DIR/data.tar.gz -T - 2>/dev/null

# 4. Database dump
echo "Backing up database..."
pg_dump trading_db > $BACKUP_DIR/database.sql
gzip $BACKUP_DIR/database.sql

# 5. Scripts
echo "Backing up scripts..."
tar -czf $BACKUP_DIR/scripts.tar.gz /opt/trading/scripts/ 2>/dev/null

# Create manifest
echo "Creating manifest..."
cat > $BACKUP_DIR/MANIFEST.txt << EOF
Backup Date: $DATE
Hostname: $(hostname)
Backup Location: $BACKUP_DIR

Contents:
$(ls -lh $BACKUP_DIR)

Total Size: $(du -sh $BACKUP_DIR | cut -f1)

Checksums:
$(cd $BACKUP_DIR && sha256sum *.tar.gz *.sql.gz)
EOF

# Verify backup
echo ""
echo "Verifying backup integrity..."
cd $BACKUP_DIR
sha256sum -c <(sha256sum *.tar.gz *.sql.gz) && echo "✓ Backup verified" || echo "✗ Backup verification failed"

echo ""
echo "Backup completed: $BACKUP_DIR"
echo "Log file: $LOG"

# Copy to remote backup server
echo "Copying to remote backup..."
rsync -avz $BACKUP_DIR backupuser@backup-server:/backups/trading/
```

**2. Recovery Script**
```bash
#!/bin/bash
# recover_system.sh
# Disaster recovery - restore from backup

BACKUP_DIR=$1

if [ -z "$BACKUP_DIR" ] || [ ! -d "$BACKUP_DIR" ]; then
    echo "Usage: $0 <backup_directory>"
    exit 1
fi

echo "========================================="
echo "DISASTER RECOVERY"
echo "========================================="
echo "Backup source: $BACKUP_DIR"
echo ""
read -p "This will overwrite existing files. Continue? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
    echo "Recovery cancelled"
    exit 0
fi

# Stop applications
echo "Stopping applications..."
systemctl stop trading_app
systemctl stop market_feed

# Restore application
echo "Restoring application..."
tar -xzf $BACKUP_DIR/application.tar.gz -C /

# Restore configuration
echo "Restoring configuration..."
tar -xzf $BACKUP_DIR/config.tar.gz -C /

# Restore data
echo "Restoring data..."
tar -xzf $BACKUP_DIR/data.tar.gz -C /

# Restore database
echo "Restoring database..."
gunzip < $BACKUP_DIR/database.sql.gz | psql trading_db

# Restore scripts
echo "Restoring scripts..."
tar -xzf $BACKUP_DIR/scripts.tar.gz -C /

# Set permissions
echo "Setting permissions..."
chown -R trading:trading /opt/trading
chmod -R 755 /opt/trading/bin
chmod -R 755 /opt/trading/scripts

# Start applications
echo "Starting applications..."
systemctl start trading_app
systemctl start market_feed

echo ""
echo "========================================="
echo "Recovery completed!"
echo "========================================="
echo "Please verify system functionality"
```

---

## Best Practices Summary

### Production Environment

✅ **Automation**: Automate repetitive tasks with cron jobs

✅ **Monitoring**: Continuous monitoring of critical processes

✅ **Logging**: Comprehensive logging for audit trails

✅ **Validation**: Always validate data before processing

✅ **Error Handling**: Proper error handling and alerts

✅ **Backups**: Regular backups with verification

✅ **Documentation**: Document all scripts and processes

✅ **Testing**: Test in non-production before deploying

✅ **Security**: Implement proper permissions and access controls

✅ **Recovery**: Have disaster recovery plan and test it

---

## Key Takeaways

1. **Unix is critical** for capital market operations
2. **Automation reduces errors** in repetitive tasks
3. **Monitoring enables** quick problem detection
4. **Data validation prevents** downstream issues
5. **Audit trails ensure** regulatory compliance
6. **Disaster recovery** is essential for business continuity

---

**This completes the Unix System & Commands theory section!**

