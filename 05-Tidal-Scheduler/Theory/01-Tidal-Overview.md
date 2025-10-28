# Tidal Scheduler - Overview

## Table of Contents
1. [What is Tidal?](#what-is-tidal)
2. [Why Tidal in Capital Markets?](#why-tidal-in-capital-markets)
3. [Tidal Architecture](#tidal-architecture)
4. [Key Concepts](#key-concepts)
5. [Job Types](#job-types)
6. [Dependencies](#dependencies)
7. [Monitoring](#monitoring)

---

## What is Tidal?

**Tidal Enterprise Scheduler** (formerly known as Cisco Tidal Enterprise Scheduler) is an enterprise-level workload automation and job scheduling solution.

### Key Features
- **Cross-platform**: Supports Unix, Linux, Windows
- **Centralized**: Single point of control
- **Scalable**: Handles thousands of jobs
- **Reliable**: High availability and failover
- **Flexible**: Complex dependency management
- **Auditable**: Complete audit trail
- **Alerting**: Comprehensive notification system

### Common Use Cases
```
Enterprise Job Scheduling:
├── Batch Processing
├── ETL Operations
├── Report Generation
├── File Transfers
├── Database Maintenance
├── Backup Operations
└── Business Process Automation
```

---

## Why Tidal in Capital Markets?

### Critical for Financial Operations

1. **End-of-Day Processing**
   - Trade settlement
   - Position calculations
   - Risk reports
   - Regulatory reports

2. **Data Management**
   - Market data ingestion
   - File processing
   - Data reconciliation
   - Archive management

3. **Reporting**
   - Daily summaries
   - Management reports
   - Regulatory filings
   - Audit reports

4. **System Maintenance**
   - Backup jobs
   - Log rotation
   - Database maintenance
   - System health checks

### Advantages
- **Reliability**: Mission-critical job execution
- **Scheduling**: Complex time-based scheduling
- **Dependencies**: Manage job interdependencies
- **Monitoring**: Real-time job status
- **Alerts**: Immediate notification of failures
- **Audit**: Complete job execution history
- **Recovery**: Automatic restart capabilities

---

## Tidal Architecture

### Components

```
┌─────────────────────────────────────────┐
│         Tidal Master                    │
│  (Central scheduling engine)            │
└──────────────┬──────────────────────────┘
               │
    ┌──────────┴──────────┐
    │                     │
┌───▼──────────┐    ┌────▼────────────┐
│   Tidal      │    │   Tidal         │
│   Agent      │    │   Agent         │
│  (Unix)      │    │  (Windows)      │
└──────────────┘    └─────────────────┘
```

**1. Tidal Master**
- Central scheduling engine
- Manages job definitions
- Processes dependencies
- Stores configuration and history
- Handles user interface

**2. Tidal Agents**
- Installed on target systems
- Execute jobs locally
- Report status back to master
- Handle local resources

**3. Tidal Client Manager**
- Web-based interface
- Job definition and management
- Monitoring and reporting
- User administration

---

## Key Concepts

### Jobs
A **job** is a unit of work to be executed.

**Job Definition includes:**
- Job name
- Job type (Unix, Windows, FTP, etc.)
- Command/script to execute
- Agent/machine to run on
- Schedule information
- Dependencies
- Notification settings

### Job Groups
**Job Groups** organize related jobs.

Example:
```
EOD_Processing (Group)
├── Collect_Market_Data
├── Process_Trades
├── Calculate_Positions
├── Generate_Reports
└── Archive_Data
```

### Calendars
**Calendars** define when jobs should run.

Types:
- **Business Days**: Mon-Fri excluding holidays
- **Weekends**: Sat-Sun
- **Month-End**: Last business day of month
- **Custom**: User-defined dates

### Time Zones
Tidal supports multiple time zones for global operations.

---

## Job Types

### 1. Unix/Linux Jobs
Execute shell scripts or commands on Unix/Linux systems.

```
Job Type: Unix
Command: /opt/trading/scripts/process_trades.sh
Agent: unix-server-01
```

### 2. Windows Jobs
Execute batch files or commands on Windows.

```
Job Type: Windows
Command: C:\Scripts\generate_report.bat
Agent: win-server-01
```

### 3. FTP Jobs
Transfer files between systems.

```
Job Type: FTP
Source: /local/data/trades.csv
Destination: remote-server:/incoming/
```

### 4. SQL Jobs
Execute SQL scripts or stored procedures.

```
Job Type: SQL
Database: TRADING_DB
Script: exec sp_eod_processing
```

### 5. Web Services Jobs
Call REST or SOAP web services.

```
Job Type: Web Service
URL: http://api.example.com/process
Method: POST
```

### 6. File Watcher Jobs
Wait for file to appear before proceeding.

```
Job Type: File Watcher
File: /incoming/market_data_*.csv
Timeout: 30 minutes
```

---

## Dependencies

### Types of Dependencies

**1. Predecessor Dependency**
Job B waits for Job A to complete.

```
Job A (Collect Data) → Job B (Process Data)
```

**2. Time Dependency**
Job runs at specific time.

```
Job: Generate Report
Schedule: Daily at 18:00
```

**3. File Dependency**
Job waits for file to exist.

```
Job: Process File
Dependency: /data/input.csv exists
```

**4. Conditional Dependency**
Job runs based on condition.

```
If (Job A status = Success) then run Job B
If (Job A status = Failure) then run Job C (recovery)
```

### Dependency Examples

**Example 1: Sequential Processing**
```
1. Collect_Data
   └→ 2. Validate_Data
       └→ 3. Process_Data
           └→ 4. Generate_Report
               └→ 5. Archive_Data
```

**Example 2: Parallel with Merge**
```
1. Start
   ├→ 2a. Process_Equities
   ├→ 2b. Process_Fixed_Income
   └→ 2c. Process_Derivatives
       └→ 3. Consolidate_Results (waits for all)
           └→ 4. Final_Report
```

**Example 3: Conditional Flow**
```
1. Validate_File
   ├→ Success → 2. Process_File
   └→ Failure → 3. Send_Alert
```

---

## Scheduling

### Schedule Types

**1. Daily**
```
Schedule: Daily
Time: 09:00
Calendar: Business Days
```

**2. Weekly**
```
Schedule: Weekly
Days: Monday, Wednesday, Friday
Time: 18:00
```

**3. Monthly**
```
Schedule: Monthly
Day: Last business day
Time: 20:00
```

**4. Interval**
```
Schedule: Every 15 minutes
Start: 08:00
End: 18:00
```

**5. On Demand**
```
Schedule: Manual trigger only
```

### Schedule Examples

**End-of-Day Processing:**
```
Job: EOD_Processing
Schedule: Daily at 16:30
Calendar: Business Days
Time Zone: Eastern Time
```

**Weekly Backup:**
```
Job: Weekly_Backup
Schedule: Sunday at 02:00
Calendar: All Days
```

**Month-End Report:**
```
Job: Month_End_Report
Schedule: Last business day at 18:00
Calendar: Business Days
```

---

## Monitoring

### Job Status

**Common Statuses:**
- **Scheduled**: Waiting for scheduled time
- **Running**: Currently executing
- **Success**: Completed successfully
- **Failed**: Completed with errors
- **Aborted**: Manually stopped
- **Waiting**: Waiting for dependencies
- **On Hold**: Temporarily disabled

### Monitoring Dashboard

```
Job Name              Status    Start Time    Duration    Agent
─────────────────────────────────────────────────────────────────
Collect_Market_Data   Success   09:00:15      00:05:23   unix-01
Process_Trades        Running   09:05:45      00:02:11   unix-02
Calculate_Positions   Waiting   -             -          -
Generate_Reports      Scheduled 18:00:00      -          -
```

### Alerts and Notifications

**Alert Types:**
- Job failure
- Job duration exceeds threshold
- Dependency failure
- Agent unavailable
- Resource limit exceeded

**Notification Methods:**
- Email
- SMS
- SNMP traps
- Syslog
- Custom scripts

---

## Capital Markets Example

### Daily EOD Processing Flow

```
16:00 - Market Close
  │
16:05 - Start_EOD_Process
  │
16:10 - Collect_Exchange_Data
  │     ├→ NYSE_Data
  │     ├→ NASDAQ_Data
  │     └→ Options_Data
  │
16:30 - Validate_Files (waits for all collection jobs)
  │
16:40 - Process_Trades
  │     ├→ Equity_Trades
  │     ├→ Options_Trades
  │     └→ Futures_Trades
  │
17:00 - Reconcile_Trades (waits for all processing)
  │
17:30 - Calculate_Positions
  │
18:00 - Generate_Reports
  │     ├→ Position_Report
  │     ├→ PnL_Report
  │     ├→ Risk_Report
  │     └→ Regulatory_Report
  │
19:00 - Archive_Data
  │
19:30 - Send_Notifications
  │
20:00 - EOD_Complete
```

---

## Best Practices

✅ **Use meaningful job names** (descriptive, consistent naming)

✅ **Document dependencies** clearly

✅ **Set appropriate timeouts**

✅ **Configure alerts** for critical jobs

✅ **Test in non-production** before deploying

✅ **Use job groups** for organization

✅ **Implement error handling** and recovery jobs

✅ **Monitor performance** and adjust schedules

✅ **Regular maintenance** of job definitions

✅ **Audit and review** job history

---

## Common Issues and Solutions

### Issue: Job Doesn't Start
**Check:**
- Dependencies met?
- Scheduled correctly?
- Agent available?
- Job on hold?

### Issue: Job Fails
**Check:**
- Job logs
- Agent logs
- Script errors
- Resource availability
- Permissions

### Issue: Job Runs Too Long
**Solutions:**
- Optimize script
- Increase timeout
- Check resource contention
- Split into smaller jobs

---

## Quick Reference

| Concept | Description | Example |
|---------|-------------|---------|
| Job | Unit of work | `Process_Trades` |
| Job Group | Collection of related jobs | `EOD_Processing` |
| Dependency | Relationship between jobs | Job B after Job A |
| Calendar | Defines run days | Business Days |
| Schedule | When to run | Daily at 18:00 |
| Agent | Execution environment | unix-server-01 |
| Status | Job state | Running, Success, Failed |

---

## Reference Links

1. **Tidal Documentation**: Official vendor documentation
2. **User Forums**: Community support
3. **Training Resources**: Vendor training materials
4. **Best Practices**: Enterprise scheduling guidelines

---

**Next Document**: `02-Tidal-Practical-Guide.md`

