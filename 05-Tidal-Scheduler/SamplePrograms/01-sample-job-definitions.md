# Tidal Sample Job Definitions

## Capital Markets Job Examples

### 1. Daily Trade Processing Job

```
Job Name: Process_Daily_Trades
Job Type: Unix Shell
Description: Process all trades received during trading day

Agent: UNIX-PROD-01
Command: /opt/trading/scripts/process_trades.sh ${DATE}
Working Directory: /opt/trading
Runtime User: trading_app
Environment Variables:
  TRADING_DATE=${DATE}
  LOG_DIR=/opt/trading/logs

Schedule:
  Type: Daily
  Time: 17:00 ET
  Calendar: NYSE_Business_Days

Dependencies:
  Predecessors:
    - Market_Data_Collection (on success)
    - Trade_File_Validation (on success)

Success Criteria:
  Exit Code: 0
  Expected Duration: 10-15 minutes

Failure Handling:
  Max Retries: 2
  Retry Delay: 5 minutes
  On Failure: Execute Recovery_Process_Trades

Notifications:
  On Success: Email trading-ops@company.com
  On Failure: Email trading-ops@company.com
              SMS +1-555-0123 (Operations Manager)

Notes:
  - Processes all trades from current business day
  - Generates trade summary report
  - Updates position database
```

---

### 2. Market Data Collection Job Group

```
Job Group: Market_Data_Collection
Description: Collect market data from multiple exchanges
Schedule: Daily at 16:15 ET

Jobs in Group:

1. Collect_NYSE_Data
   Command: /scripts/collect_nyse.sh ${DATE}
   Agent: UNIX-PROD-01
   Duration: ~5 min

2. Collect_NASDAQ_Data
   Command: /scripts/collect_nasdaq.sh ${DATE}
   Agent: UNIX-PROD-02
   Duration: ~4 min

3. Collect_Options_Data
   Command: /scripts/collect_options.sh ${DATE}
   Agent: UNIX-PROD-03
   Duration: ~8 min

4. Validate_Market_Data
   Dependencies: 
     - Collect_NYSE_Data (success)
     - Collect_NASDAQ_Data (success)
     - Collect_Options_Data (success)
   Command: /scripts/validate_market_data.sh ${DATE}
   
5. Notify_Collection_Complete
   Dependency: Validate_Market_Data (success)
   Type: Email
   To: trading-team@company.com
   Subject: Market Data Collection Complete for ${DATE}
```

---

### 3. Position Reconciliation Job

```
Job Name: Reconcile_Positions
Job Type: SQL
Description: Reconcile calculated positions with broker positions

Database Connection: TRADING_DB_PROD
SQL Script: /sql/reconcile_positions.sql
Parameters:
  @trade_date = ${DATE}

Schedule:
  Type: Daily
  Time: 18:30 ET
  Calendar: Business_Days

Dependencies:
  - Calculate_Positions (success)
  - Receive_Broker_Positions (success)

Success Criteria:
  Exit Code: 0
  Output: "RECONCILIATION PASSED"

Failure Handling:
  On Failure: 
    - Generate Break Report
    - Email trading-managers@company.com
    - Put dependent jobs on hold
    
Timeout: 30 minutes
Priority: High

Audit: Yes (maintain 90-day history)
```

---

### 4. File Watcher Job

```
Job Name: Wait_for_Market_Data
Job Type: File Watcher
Description: Wait for market data file to arrive

File Watch Configuration:
  Path: /incoming/market_data/
  Pattern: market_data_${DATE}_*.csv
  Timeout: 60 minutes
  Check Interval: 30 seconds

Action on File Found:
  Trigger Job: Validate_and_Process_Market_Data

Action on Timeout:
  - Send Alert: "Market data file not received for ${DATE}"
  - Email: data-ops@company.com
  - Run Job: Investigate_Missing_Data

Additional Options:
  Wait for File Stability: Yes (2 minutes)
  Minimum File Size: 1 KB
  
Schedule:
  Type: Daily
  Start Time: 16:00 ET
  Calendar: Business_Days
```

---

### 5. Month-End Reporting Job

```
Job Name: Generate_Month_End_Reports
Job Type: Unix Shell
Description: Generate all month-end reports

Command: /opt/trading/scripts/month_end_reports.sh ${YEAR} ${MONTH}

Schedule:
  Type: Monthly
  Day: Last Business Day
  Time: 19:00 ET
  Calendar: Business_Days

Dependencies:
  - Month_End_Processing (success)
  - Position_Calculation_Complete (success)
  - PnL_Calculation_Complete (success)

Variables:
  YEAR=${YEAR}
  MONTH=${MONTH}
  REPORT_DIR=/reports/month_end/${YEAR}${MONTH}

Reports Generated:
  - Executive Summary
  - Detailed Position Report
  - PnL Analysis
  - Trader Performance
  - Risk Metrics
  - Regulatory Reports

Distribution:
  On Success: 
    - FTP reports to management portal
    - Email notification to executives
    - Archive to long-term storage

Expected Duration: 45-60 minutes
Priority: Critical
```

---

### 6. Backup Job with Recovery

```
Job Name: Daily_Database_Backup
Job Type: Unix Shell
Description: Full database backup

Command: /scripts/backup_trading_db.sh ${DATE}
Agent: BACKUP-SERVER-01

Schedule:
  Type: Daily
  Time: 01:00 ET
  Calendar: All_Days

Pre-Execution:
  - Check disk space (min 500GB free)
  - Verify backup location writable
  - Stop non-critical database connections

Execution:
  Command: /scripts/backup_trading_db.sh
  Timeout: 4 hours

Post-Execution:
  On Success:
    - Verify backup integrity
    - Copy to remote site
    - Delete backups older than 30 days
    - Send success notification
    
  On Failure:
    - Retry once (after 30 min)
    - If retry fails:
      - Alert DBA team (email + SMS)
      - Create incident ticket
      - Do NOT delete old backups

Notifications:
  Success: Email backup-team@company.com
  Failure: Email dba-team@company.com
           SMS +1-555-0199 (DBA Manager)
           Page +1-555-0200 (Backup Team)
```

---

### 7. Error Recovery Job

```
Job Name: Recovery_Process_Trades
Job Type: Unix Shell
Description: Recovery process when trade processing fails

Command: /opt/trading/scripts/recovery_process.sh ${FAILED_JOB} ${DATE}

Trigger:
  Type: On Failure
  Parent Job: Process_Daily_Trades

Actions:
  1. Analyze failure logs
  2. Identify problematic trades
  3. Move problem trades to holding area
  4. Reprocess good trades
  5. Generate failure report
  6. Notify trading operations

Parameters:
  FAILED_JOB=${PARENT_JOB_NAME}
  FAILURE_TIME=${PARENT_JOB_FAILURE_TIME}
  LOG_FILE=${PARENT_JOB_LOG}

Max Execution Time: 30 minutes

Notifications:
  On Start: "Recovery process initiated for ${FAILED_JOB}"
  On Success: "Recovery completed - ${RECOVERED_COUNT} trades processed"
  On Failure: "CRITICAL: Recovery failed for ${FAILED_JOB}"
```

---

### 8. Real-Time Monitoring Job

```
Job Name: Monitor_Trading_Activity
Job Type: Unix Shell
Description: Monitor trading activity every 5 minutes

Command: /scripts/monitor_activity.sh

Schedule:
  Type: Interval
  Frequency: Every 5 minutes
  Start Time: 09:00 ET
  End Time: 16:30 ET
  Days: Monday-Friday
  Calendar: Trading_Days

Monitoring Checks:
  - Trading system responsiveness
  - Database connection status
  - Disk space utilization
  - Active trade count
  - Error rate
  - System performance

Alert Thresholds:
  - Response time > 2 seconds: Warning
  - Error rate > 5%: Alert
  - Disk space < 10%: Critical Alert

Actions on Alert:
  Warning: Log to monitoring system
  Alert: Email trading-ops@company.com
  Critical: Email + SMS operations manager

Duration: < 1 minute
Priority: High
```

---

### 9. Data Archival Job

```
Job Name: Archive_Daily_Data
Job Type: Unix Shell
Description: Archive and compress daily trading data

Command: /scripts/archive_daily_data.sh ${DATE}

Schedule:
  Type: Daily
  Time: 23:00 ET
  Calendar: Business_Days

Dependencies:
  - EOD_Processing_Complete (success)
  - All_Reports_Generated (success)

Archive Configuration:
  Source: /opt/trading/data/${DATE}/
  Destination: /archive/${YEAR}/${MONTH}/
  Compression: gzip
  Verification: MD5 checksum

Retention Policy:
  Local (uncompressed): 7 days
  Local (compressed): 90 days
  Archive (compressed): 7 years

Actions:
  1. Create archive structure
  2. Compress daily files
  3. Verify integrity
  4. Copy to archive location
  5. Copy to offsite backup
  6. Delete local uncompressed files
  7. Update archive index

Notifications:
  Success: Update archive log
  Failure: Email storage-admin@company.com

Timeout: 2 hours
```

---

### 10. Workflow Coordinator

```
Job Name: EOD_Workflow_Coordinator
Job Type: Control Job
Description: Coordinates entire end-of-day workflow

Schedule:
  Type: Daily
  Time: 16:00 ET
  Calendar: Business_Days

Workflow Steps:

Phase 1: Data Collection (16:00-16:30)
  - Collect_Market_Data
  - Receive_Broker_Confirmations
  - Validate_Data_Files

Phase 2: Processing (16:30-17:30)
  - Process_Equity_Trades
  - Process_Options_Trades
  - Process_Futures_Trades
  - Reconcile_All_Trades

Phase 3: Calculations (17:30-18:30)
  - Calculate_Positions
  - Calculate_PnL
  - Calculate_Risk_Metrics
  - Update_Databases

Phase 4: Reporting (18:30-19:30)
  - Generate_Position_Reports
  - Generate_PnL_Reports
  - Generate_Risk_Reports
  - Generate_Regulatory_Reports

Phase 5: Distribution (19:30-20:00)
  - Distribute_Reports
  - Send_Notifications
  - Archive_Data

Phase 6: Cleanup (20:00-20:30)
  - Cleanup_Temp_Files
  - Backup_Critical_Data
  - Send_Completion_Summary

Monitoring:
  Track progress of each phase
  Alert if phase takes longer than expected
  Provide real-time status updates

Recovery:
  Automatic retry for transient failures
  Manual intervention required for critical failures
  Maintain audit trail of all actions
```

---

## Notes for Implementation

1. **Job Naming**: Use consistent naming conventions
2. **Documentation**: Keep descriptions up-to-date
3. **Testing**: Test in non-production first
4. **Monitoring**: Set up appropriate alerts
5. **Maintenance**: Regular review and optimization
6. **Backup**: Maintain configuration backups
7. **Audit**: Keep detailed logs
8. **Security**: Proper access controls

---

## Variable Reference

Common Tidal variables:
- `${DATE}` - YYYYMMDD
- `${TIME}` - HHMMSS
- `${YEAR}` - YYYY
- `${MONTH}` - MM
- `${DAY}` - DD
- `${JOBNAME}` - Current job name
- `${AGENT}` - Agent name
- `${USER}` - Runtime user

---

**Use these as templates for your own job definitions!**

