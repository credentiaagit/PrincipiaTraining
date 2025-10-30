# Tidal Scheduler Naming Standards

## Table of Contents
1. [Job Naming Conventions](#job-naming-conventions)
2. [Job Group Naming](#job-group-naming)
3. [Variable Naming](#variable-naming)
4. [Calendar Naming](#calendar-naming)
5. [Queue Naming](#queue-naming)
6. [Alert Naming](#alert-naming)
7. [Capital Markets Specific Standards](#capital-markets-specific-standards)
8. [Best Practices](#best-practices)

---

## Job Naming Conventions

**What is Job Naming Convention?**
A consistent approach to naming Tidal jobs that makes them easy to identify, search, and manage in the scheduler.

**Why Follow Naming Conventions?**
- Easy to identify job purpose
- Searchable and filterable
- Understand dependencies quickly
- Professional organization
- Easier troubleshooting

### General Job Naming Structure

**Format**: `{ENVIRONMENT}_{SYSTEM}_{FUNCTION}_{DESCRIPTION}`

**Components**:
- **ENVIRONMENT**: DEV, TEST, UAT, PROD
- **SYSTEM**: Trading, Risk, Compliance, etc.
- **FUNCTION**: Process, Report, Extract, Load, etc.
- **DESCRIPTION**: Specific task description

**Examples**:
```
PROD_TRADING_PROCESS_DAILY_TRADES
PROD_TRADING_GENERATE_EOD_REPORT
PROD_RISK_CALCULATE_VAR
PROD_COMPLIANCE_CHECK_LIMITS
UAT_TRADING_VALIDATE_MARKET_DATA
DEV_TRADING_TEST_FILE_PROCESSOR
```

### Standard Job Naming Patterns

**1. Data Processing Jobs**
```
Format: {ENV}_{SYSTEM}_PROCESS_{DATA_TYPE}_{FREQUENCY}

Examples:
PROD_TRADING_PROCESS_TRADES_DAILY
PROD_TRADING_PROCESS_MARKET_DATA_INTRADAY
PROD_TRADING_PROCESS_SETTLEMENTS_DAILY
PROD_TRADING_PROCESS_POSITIONS_EOD
```

**2. Report Generation Jobs**
```
Format: {ENV}_{SYSTEM}_GENERATE_{REPORT_TYPE}_{FREQUENCY}

Examples:
PROD_TRADING_GENERATE_PNL_DAILY
PROD_TRADING_GENERATE_POSITION_REPORT_EOD
PROD_RISK_GENERATE_VAR_DAILY
PROD_COMPLIANCE_GENERATE_TRADE_REVIEW_WEEKLY
```

**3. File Transfer Jobs**
```
Format: {ENV}_{SYSTEM}_{DIRECTION}_{FILE_TYPE}_{DESTINATION}

Examples:
PROD_TRADING_SEND_TRADES_TO_CLEARINGHOUSE
PROD_TRADING_RECEIVE_MARKET_DATA_FROM_EXCHANGE
PROD_TRADING_SEND_REPORTS_TO_SFTP
PROD_TRADING_FETCH_REFERENCE_DATA_FROM_VENDOR
```

**4. Data Load Jobs**
```
Format: {ENV}_{SYSTEM}_LOAD_{SOURCE}_{DESTINATION}

Examples:
PROD_TRADING_LOAD_TRADES_TO_DB
PROD_TRADING_LOAD_MARKET_DATA_TO_WAREHOUSE
PROD_TRADING_LOAD_POSITIONS_TO_REPORTING_DB
```

**5. Validation/Check Jobs**
```
Format: {ENV}_{SYSTEM}_VALIDATE_{WHAT}

Examples:
PROD_TRADING_VALIDATE_TRADE_FILES
PROD_TRADING_VALIDATE_MARKET_DATA_QUALITY
PROD_RISK_VALIDATE_POSITION_LIMITS
PROD_COMPLIANCE_CHECK_REGULATORY_LIMITS
```

**6. Cleanup/Maintenance Jobs**
```
Format: {ENV}_{SYSTEM}_CLEANUP_{WHAT}_{FREQUENCY}

Examples:
PROD_TRADING_CLEANUP_TEMP_FILES_DAILY
PROD_TRADING_ARCHIVE_OLD_LOGS_WEEKLY
PROD_TRADING_PURGE_PROCESSED_FILES_DAILY
PROD_TRADING_CLEANUP_ERROR_LOGS_WEEKLY
```

**7. Monitoring/Alert Jobs**
```
Format: {ENV}_{SYSTEM}_MONITOR_{WHAT}

Examples:
PROD_TRADING_MONITOR_FILE_ARRIVAL
PROD_TRADING_MONITOR_DISK_SPACE
PROD_TRADING_MONITOR_PROCESS_STATUS
PROD_TRADING_ALERT_ON_FAILURES
```

---

## Job Group Naming

**What is a Job Group?**
A collection of related jobs organized together for easier management.

**Format**: `{ENVIRONMENT}_{SYSTEM}_{CATEGORY}`

**Examples**:
```
PROD_TRADING_SOD              # Start of Day jobs
PROD_TRADING_EOD              # End of Day jobs
PROD_TRADING_INTRADAY         # Intraday jobs
PROD_TRADING_REPORTS          # Report jobs
PROD_TRADING_FILE_TRANSFERS   # File transfer jobs
PROD_TRADING_MAINTENANCE      # Maintenance jobs
PROD_RISK_CALCULATIONS        # Risk calculation jobs
PROD_COMPLIANCE_CHECKS        # Compliance check jobs
```

### Hierarchical Group Structure

```
PROD_TRADING/
├── SOD/                              # Start of Day
│   ├── PROD_TRADING_VALIDATE_FILES
│   ├── PROD_TRADING_LOAD_REFERENCE_DATA
│   └── PROD_TRADING_INITIALIZE_POSITIONS
├── INTRADAY/                         # Intraday Processing
│   ├── PROD_TRADING_PROCESS_TRADES
│   ├── PROD_TRADING_PROCESS_MARKET_DATA
│   └── PROD_TRADING_UPDATE_POSITIONS
├── EOD/                              # End of Day
│   ├── PROD_TRADING_RECONCILE_TRADES
│   ├── PROD_TRADING_CALCULATE_PNL
│   ├── PROD_TRADING_GENERATE_REPORTS
│   └── PROD_TRADING_ARCHIVE_DATA
└── MAINTENANCE/                      # Maintenance
    ├── PROD_TRADING_CLEANUP_TEMP_FILES
    └── PROD_TRADING_ARCHIVE_LOGS
```

---

## Variable Naming

**What are Tidal Variables?**
Variables used within Tidal jobs to store values like dates, file paths, parameters, etc.

### Global Variables

**Format**: `{SYSTEM}_{PURPOSE}`

**Examples**:
```
TRADING_HOME_DIR=/opt/trading
TRADING_DATA_DIR=/opt/trading/data
TRADING_LOG_DIR=/opt/trading/logs
TRADING_ARCHIVE_DIR=/opt/trading/archive
TRADING_TEMP_DIR=/opt/trading/temp

TRADING_DB_HOST=db-prod-01
TRADING_DB_PORT=5432
TRADING_DB_NAME=trading_prod

TRADING_EMAIL_ALERTS=trading-ops@company.com
TRADING_EMAIL_ERRORS=trading-errors@company.com
```

### Job-Specific Variables

**Format**: `{VARIABLE_PURPOSE}`

**Examples**:
```
INPUT_FILE=/opt/trading/data/trades-{TXDATE}.csv
OUTPUT_FILE=/opt/trading/reports/report-{TXDATE}.pdf
LOG_FILE=/opt/trading/logs/process-{TXDATE}.log

BATCH_DATE={TXDATE}
PROCESS_DATE={ODATE}
TRADE_DATE={TXDATE}
SETTLEMENT_DATE={TXDATE+2}

RETRY_COUNT=3
TIMEOUT_MINUTES=30
MAX_RECORDS=100000
```

### Date Variables

**Common date variables in Tidal**:
```
{TXDATE}          # Transaction date (YYYYMMDD)
{ODATE}           # Original date
{TXDATE-1}        # Previous day
{TXDATE+1}        # Next day
{TXDATE+2}        # Two days ahead (settlement date)

{MM}              # Month (01-12)
{DD}              # Day (01-31)
{YYYY}            # Year (2024)
{YY}              # Year (24)
```

---

## Calendar Naming

**What is a Tidal Calendar?**
Defines when jobs should run (business days, holidays, etc.).

**Format**: `{SYSTEM}_{CALENDAR_TYPE}`

**Examples**:
```
TRADING_BUSINESS_DAYS         # Standard business days
TRADING_NYSE_CALENDAR         # NYSE trading days
TRADING_NASDAQ_CALENDAR       # NASDAQ trading days
TRADING_FOREX_CALENDAR        # Forex trading days
TRADING_MONTH_END             # Month-end days
TRADING_QUARTER_END           # Quarter-end days
TRADING_YEAR_END              # Year-end days
TRADING_SETTLEMENT_DAYS       # Settlement days (T+2)

MAINTENANCE_WEEKEND           # Weekend maintenance window
MAINTENANCE_MONTH_END         # Month-end maintenance
```

---

## Queue Naming

**What is a Tidal Queue?**
Controls job execution order and resource allocation.

**Format**: `{SYSTEM}_{PURPOSE}_QUEUE`

**Examples**:
```
TRADING_HIGH_PRIORITY_QUEUE    # Critical jobs
TRADING_NORMAL_QUEUE           # Regular jobs
TRADING_LOW_PRIORITY_QUEUE     # Non-urgent jobs
TRADING_FILE_TRANSFER_QUEUE    # File transfers
TRADING_REPORT_QUEUE           # Report generation
TRADING_BATCH_QUEUE            # Batch processing
TRADING_REALTIME_QUEUE         # Real-time processing
```

---

## Alert Naming

**What is a Tidal Alert?**
Notifications sent when jobs fail, complete, or require attention.

**Format**: `{SYSTEM}_{SEVERITY}_{EVENT_TYPE}_ALERT`

**Examples**:
```
TRADING_CRITICAL_FAILURE_ALERT       # Critical failures
TRADING_ERROR_NOTIFICATION_ALERT     # Error notifications
TRADING_WARNING_ALERT                # Warnings
TRADING_SUCCESS_COMPLETION_ALERT     # Success notifications
TRADING_LONG_RUNNING_JOB_ALERT      # Long-running jobs
TRADING_FILE_NOT_FOUND_ALERT        # Missing file alerts
TRADING_LIMIT_BREACH_ALERT          # Limit breaches
```

---

## Capital Markets Specific Standards

### Trading System Jobs

**Start of Day (SOD) Jobs**
```
PROD_TRADING_SOD_VALIDATE_MARKET_DATA
PROD_TRADING_SOD_LOAD_REFERENCE_DATA
PROD_TRADING_SOD_INITIALIZE_POSITIONS
PROD_TRADING_SOD_CHECK_SETTLEMENT_STATUS
PROD_TRADING_SOD_SEND_STATUS_EMAIL
```

**Intraday Jobs**
```
PROD_TRADING_INTRADAY_PROCESS_TRADES
PROD_TRADING_INTRADAY_UPDATE_POSITIONS
PROD_TRADING_INTRADAY_CALCULATE_PNL
PROD_TRADING_INTRADAY_CHECK_LIMITS
PROD_TRADING_INTRADAY_PROCESS_MARKET_DATA
```

**End of Day (EOD) Jobs**
```
PROD_TRADING_EOD_RECONCILE_TRADES
PROD_TRADING_EOD_SETTLE_TRADES
PROD_TRADING_EOD_CALCULATE_FINAL_PNL
PROD_TRADING_EOD_GENERATE_POSITIONS_REPORT
PROD_TRADING_EOD_GENERATE_PNL_REPORT
PROD_TRADING_EOD_ARCHIVE_DATA
PROD_TRADING_EOD_CLEANUP_TEMP_FILES
```

### Risk Management Jobs

```
PROD_RISK_CALCULATE_VAR_DAILY
PROD_RISK_CALCULATE_EXPOSURE_EOD
PROD_RISK_GENERATE_RISK_REPORT_DAILY
PROD_RISK_CHECK_POSITION_LIMITS
PROD_RISK_STRESS_TEST_PORTFOLIO_WEEKLY
```

### Compliance Jobs

```
PROD_COMPLIANCE_CHECK_TRADE_LIMITS
PROD_COMPLIANCE_VALIDATE_TRADES
PROD_COMPLIANCE_GENERATE_REGULATORY_REPORT
PROD_COMPLIANCE_CHECK_MARGIN_REQUIREMENTS
PROD_COMPLIANCE_AUDIT_TRAIL_DAILY
```

### Settlement Jobs

```
PROD_SETTLEMENT_PROCESS_SETTLEMENTS
PROD_SETTLEMENT_SEND_TO_CLEARINGHOUSE
PROD_SETTLEMENT_RECEIVE_CONFIRMATIONS
PROD_SETTLEMENT_RECONCILE_BREAKS
PROD_SETTLEMENT_GENERATE_SETTLEMENT_REPORT
```

---

## Job Dependencies and Naming

### Parent-Child Job Naming

**Parent Job**:
```
PROD_TRADING_EOD_MASTER
```

**Child Jobs**:
```
PROD_TRADING_EOD_MASTER_STEP01_RECONCILE
PROD_TRADING_EOD_MASTER_STEP02_CALCULATE
PROD_TRADING_EOD_MASTER_STEP03_REPORT
PROD_TRADING_EOD_MASTER_STEP04_ARCHIVE
```

### Conditional Job Naming

```
PROD_TRADING_PROCESS_TRADES_IF_FILE_EXISTS
PROD_TRADING_SEND_ALERT_IF_FAILURE
PROD_TRADING_RETRY_IF_ERROR
```

---

## Documentation in Job Description

**Always include** in Tidal job description:
```
Job: PROD_TRADING_PROCESS_DAILY_TRADES

Description:
Processes daily trade files from all exchanges and loads into database

Input: /opt/trading/data/TRADES-{TXDATE}.csv
Output: Database table: trades
Log: /opt/trading/logs/process-trades-{TXDATE}.log

Schedule: Daily at 6:00 AM (after market close)
Calendar: TRADING_BUSINESS_DAYS
Duration: ~15 minutes
Owner: Trading Operations Team
Contact: trading-ops@company.com

Dependencies:
- Requires: PROD_TRADING_SOD_VALIDATE_FILES
- Triggers: PROD_TRADING_CALCULATE_PNL

Error Handling:
- Retry 3 times with 5-minute delay
- Alert trading-errors@company.com on failure
- Page on-call if critical
```

---

## Best Practices

### Naming Checklist

✅ **DO**:
- Use consistent naming pattern across all jobs
- Include environment prefix (DEV, TEST, PROD)
- Use descriptive names that indicate purpose
- Use underscores to separate components
- Keep names under 64 characters (most systems limit)
- Document naming conventions
- Use standard abbreviations consistently
- Group related jobs logically

❌ **DON'T**:
- Use spaces in job names
- Use special characters except underscore
- Create cryptic abbreviations
- Mix naming conventions
- Duplicate job names across environments
- Use generic names like JOB1, TEST, TEMP
- Forget environment prefix
- Make names too long (over 64 chars)

### Standard Abbreviations

**Approved abbreviations**:
```
SOD   - Start of Day
EOD   - End of Day
PNL   - Profit and Loss
VAR   - Value at Risk
FX    - Foreign Exchange
OTC   - Over The Counter
PROD  - Production
UAT   - User Acceptance Testing
DEV   - Development
DB    - Database
RPT   - Report
TXN   - Transaction
RECON - Reconciliation
```

### Search and Filter Friendly

**Make jobs easy to find**:
```
# Search all trading jobs
*TRADING*

# Search all EOD jobs
*EOD*

# Search all production jobs
PROD_*

# Search specific system reports
PROD_TRADING_GENERATE_*

# Search all validation jobs
*VALIDATE*
```

---

## Example Job List

### Well-Named Job Schedule

```
# Start of Day
06:00 - PROD_TRADING_SOD_VALIDATE_MARKET_DATA
06:15 - PROD_TRADING_SOD_LOAD_REFERENCE_DATA
06:30 - PROD_TRADING_SOD_INITIALIZE_POSITIONS
06:45 - PROD_TRADING_SOD_CHECK_SETTLEMENT_STATUS

# Intraday (Runs every hour 9 AM - 4 PM)
09:00 - PROD_TRADING_INTRADAY_PROCESS_TRADES
09:15 - PROD_TRADING_INTRADAY_UPDATE_POSITIONS
09:30 - PROD_TRADING_INTRADAY_CALCULATE_PNL

# End of Day
16:30 - PROD_TRADING_EOD_RECONCILE_TRADES
17:00 - PROD_TRADING_EOD_SETTLE_TRADES
17:30 - PROD_TRADING_EOD_CALCULATE_FINAL_PNL
18:00 - PROD_TRADING_EOD_GENERATE_POSITIONS_REPORT
18:30 - PROD_TRADING_EOD_GENERATE_PNL_REPORT
19:00 - PROD_TRADING_EOD_ARCHIVE_DATA
19:30 - PROD_TRADING_EOD_CLEANUP_TEMP_FILES

# Overnight
02:00 - PROD_TRADING_MAINTENANCE_BACKUP_DATABASE
03:00 - PROD_TRADING_MAINTENANCE_ARCHIVE_OLD_LOGS
```

---

## Quick Reference

### Job Naming Components

| Component | Purpose | Example |
|-----------|---------|---------|
| Environment | DEV/TEST/UAT/PROD | `PROD` |
| System | Trading/Risk/Compliance | `TRADING` |
| Function | Process/Generate/Send | `PROCESS` |
| Description | What it does | `DAILY_TRADES` |
| **Full Name** | Complete job name | `PROD_TRADING_PROCESS_DAILY_TRADES` |

### Common Patterns

| Job Type | Pattern | Example |
|----------|---------|---------|
| Processing | `{ENV}_{SYS}_PROCESS_{WHAT}_{WHEN}` | `PROD_TRADING_PROCESS_TRADES_DAILY` |
| Reporting | `{ENV}_{SYS}_GENERATE_{REPORT}_{WHEN}` | `PROD_TRADING_GENERATE_PNL_DAILY` |
| Transfer | `{ENV}_{SYS}_{DIR}_{WHAT}_{WHERE}` | `PROD_TRADING_SEND_TRADES_TO_CLEARING` |
| Validation | `{ENV}_{SYS}_VALIDATE_{WHAT}` | `PROD_TRADING_VALIDATE_MARKET_DATA` |
| Cleanup | `{ENV}_{SYS}_CLEANUP_{WHAT}_{WHEN}` | `PROD_TRADING_CLEANUP_TEMP_DAILY` |

---

*Last Updated: 2024-10-28*  
*Follow these standards for organized, maintainable Tidal job schedules*

