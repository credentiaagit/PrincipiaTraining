# Tidal Scheduler - Practical Guide

## Table of Contents
1. [Creating Jobs](#creating-jobs)
2. [Setting Dependencies](#setting-dependencies)
3. [Configuring Schedules](#configuring-schedules)
4. [Error Handling](#error-handling)
5. [Troubleshooting](#troubleshooting)
6. [Real-World Examples](#real-world-examples)

---

## Creating Jobs

### Job Creation Steps

**1. Access Tidal Client Manager**
- Login to web interface
- Navigate to Job Definitions

**2. Create New Job**
- Click "New Job"
- Select job type

**3. Configure Job Properties**
- Name
- Description
- Agent
- Command/Script

**4. Set Schedule**
- Time
- Calendar
- Recurrence

**5. Configure Dependencies**
- Predecessors
- Conditions

**6. Set Notifications**
- Success alerts
- Failure alerts

### Example: Unix Script Job

```
Job Name: Process_Daily_Trades
Description: Process all trades for current business day
Job Type: Unix
Agent: unix-trading-01
Command: /opt/trading/scripts/process_trades.sh ${DATE}
Working Directory: /opt/trading
Runtime User: trading_user
Schedule: Daily at 17:00
Calendar: Business Days
On Success: Email operations@company.com
On Failure: Email operations@company.com, sms: +1234567890
```

### Variable Substitution

Tidal supports runtime variables:

```
${DATE}           # Current date (YYYYMMDD)
${TIME}           # Current time (HHMMSS)
${JOBNAME}        # Current job name
${AGENT}          # Agent name
${USER}           # Runtime user
```

**Example:**
```
Command: /scripts/process_file.sh /data/trades_${DATE}.csv
```

---

## Setting Dependencies

### Creating Predecessor Dependencies

**Method 1: Job Definition**
1. Open job properties
2. Navigate to "Dependencies" tab
3. Click "Add Predecessor"
4. Select predecessor job
5. Choose success/failure condition

**Example:**
```
Job: Calculate_Positions
Predecessor: Process_Trades (on success)
Condition: Wait for successful completion
```

### Dependency Conditions

**Success Dependency:**
```
Job B runs only if Job A completes successfully
Process_Trades → Calculate_Positions
```

**Completion Dependency:**
```
Job B runs when Job A completes (success or failure)
Daily_Process → Send_Status_Email
```

**Failure Dependency:**
```
Job B runs only if Job A fails
Process_Data (fail) → Send_Alert_to_Support
```

### Complex Dependencies

**AND Dependency:**
```
Job D waits for Job A AND Job B AND Job C
├─ Job A (Collect Data A) ──┐
├─ Job B (Collect Data B) ──┼──> Job D (Consolidate)
└─ Job C (Collect Data C) ──┘
```

**OR Dependency:**
```
Job C runs if Job A OR Job B completes
├─ Job A (Primary Source) ──┐
└─ Job B (Backup Source) ────┴──> Job C (Process)
```

### File Dependencies

**Wait for File:**
```
Job: Process_Market_Data
File Watch: /incoming/market_data_${DATE}.csv
Timeout: 30 minutes
Action on Timeout: Run recovery job
```

---

## Configuring Schedules

### Basic Schedule Patterns

**1. Fixed Time Daily:**
```
Schedule Type: Daily
Run Time: 18:00
Time Zone: Eastern
Calendar: Business Days
```

**2. Multiple Times per Day:**
```
Schedule Type: Daily
Run Times: 09:00, 12:00, 15:00, 18:00
Calendar: Business Days
```

**3. Weekly Schedule:**
```
Schedule Type: Weekly
Days: Monday, Wednesday, Friday
Run Time: 20:00
Calendar: All Days
```

**4. Monthly Schedule:**
```
Schedule Type: Monthly
Day of Month: Last Business Day
Run Time: 19:00
Calendar: Business Days
```

**5. Interval Schedule:**
```
Schedule Type: Interval
Every: 15 minutes
Start Time: 08:00
End Time: 16:00
Days: Monday-Friday
```

### Calendar Management

**Creating Custom Calendar:**
```
Calendar Name: US_Business_Days
Type: Business Calendar
Working Days: Monday - Friday
Holidays:
  - 2024-01-01 (New Year's Day)
  - 2024-07-04 (Independence Day)
  - 2024-12-25 (Christmas Day)
```

---

## Error Handling

### Recovery Jobs

**Pattern 1: Retry on Failure**
```
Job: Process_Trades
On Failure: Restart_Process_Trades (max 3 retries)
Delay: 5 minutes between retries
```

**Pattern 2: Alternative Processing**
```
Primary_Job (fail) → Backup_Job
Backup_Job (success/fail) → Notification_Job
```

**Pattern 3: Manual Intervention**
```
Critical_Job (fail) → 
  1. Send alert to operations
  2. Put dependent jobs on hold
  3. Wait for manual restart
```

### Exit Code Handling

```
Exit Code 0: Success → Continue workflow
Exit Code 1: Failure → Run recovery job
Exit Code 2: Warning → Continue but send alert
Exit Code 99: Fatal → Stop all dependent jobs
```

### Notification Configuration

**Email Notification:**
```
Trigger: On Failure
To: operations@company.com, trading-support@company.com
Subject: [ALERT] Job ${JOBNAME} Failed
Body:
  Job: ${JOBNAME}
  Status: Failed
  Start Time: ${STARTTIME}
  Agent: ${AGENT}
  Log: ${LOGFILE}
```

**SMS Notification:**
```
Trigger: On Failure for Critical Jobs
To: +1-555-0100 (Operations Manager)
Message: CRITICAL: ${JOBNAME} failed at ${TIME}
```

---

## Troubleshooting

### Common Issues

**1. Job Stuck in "Waiting" Status**

**Diagnosis:**
```
- Check dependency status
- Verify predecessor jobs completed
- Check file dependencies
- Review calendar settings
```

**Resolution:**
```
- Complete/skip blocking jobs
- Verify file exists
- Adjust dependencies
- Check if date is in calendar
```

**2. Job Failed**

**Diagnosis:**
```
- Review job log
- Check agent log
- Verify script exists
- Check permissions
- Verify resources available
```

**Resolution:**
```
- Fix script errors
- Correct permissions
- Free up resources
- Restart job manually
```

**3. Job Takes Too Long**

**Diagnosis:**
```
- Check system resources
- Review script performance
- Check database connections
- Look for contention
```

**Resolution:**
```
- Optimize script
- Increase resources
- Adjust scheduling
- Split into smaller jobs
```

### Debugging Steps

**Step 1: Review Job Definition**
```
- Verify command path
- Check working directory
- Confirm runtime user
- Review variables
```

**Step 2: Check Agent Status**
```
- Is agent online?
- Check agent resources (CPU, Memory, Disk)
- Review agent logs
```

**Step 3: Test Manually**
```
- Login to agent server
- Run command manually as runtime user
- Verify output
- Check exit code
```

**Step 4: Review Dependencies**
```
- Are predecessors complete?
- Check dependency conditions
- Verify timing
```

---

## Real-World Examples

### Example 1: End-of-Day Trading System

```
Job Group: EOD_Processing
Trigger: Market close (16:00)

Jobs:
1. Wait_for_Market_Close (16:00)
   └→ 2. Collect_Exchange_Files
       ├→ 2a. Get_NYSE_Data
       ├→ 2b. Get_NASDAQ_Data
       └→ 2c. Get_Options_Data
          └→ 3. Validate_Files
              Success → 4. Process_Trades
              Failure → 5. Alert_Operations
              
4. Process_Trades
   └→ 6. Reconcile_Trades
       Success → 7. Calculate_Positions
       Failure → 8. Run_Reconciliation_Report
       
7. Calculate_Positions
   └→ 9. Generate_Reports
       ├→ 9a. Position_Report
       ├→ 9b. PnL_Report
       └→ 9c. Risk_Report
           └→ 10. Distribute_Reports
               └→ 11. Archive_Data
                   └→ 12. Cleanup_Temp_Files
                       └→ 13. EOD_Complete_Notification
```

### Example 2: Data Pipeline

```
Job Group: Hourly_Data_Pipeline
Schedule: Every hour, 24x7

Jobs:
1. Check_Incoming_Files (every hour)
   File Watch: /incoming/*.csv
   Timeout: 65 minutes
   
2. Validate_Data_Format (after file appears)
   Success → 3. Load_to_Database
   Failure → 4. Move_to_Error_Folder
   
3. Load_to_Database
   Success → 5. Update_Statistics
   Failure → 6. Send_Alert_to_DBA
   
5. Update_Statistics
   └→ 7. Archive_Processed_File
       └→ 8. Send_Success_Notification
```

### Example 3: Month-End Processing

```
Job Group: Month_End_Processing
Schedule: Last business day of month, 18:00

Jobs:
1. Month_End_Start
   └→ 2. Extract_Monthly_Trades
       └→ 3. Calculate_Monthly_PnL
           ├→ 4. Generate_Month_End_Reports
           │   ├→ 4a. Executive_Summary
           │   ├→ 4b. Detailed_PnL
           │   ├→ 4c. Trader_Performance
           │   └→ 4d. Risk_Analysis
           ├→ 5. Generate_Regulatory_Reports
           │   ├→ 5a. SEC_Form_X
           │   ├→ 5b. CFTC_Report
           │   └→ 5c. Internal_Audit
           └→ 6. Archive_Month_Data
               └→ 7. Send_Month_End_Summary
```

### Example 4: Disaster Recovery

```
Job Group: Daily_Backup
Schedule: Daily at 02:00

Jobs:
1. Backup_Start
   └→ 2. Stop_Non_Critical_Services
       └→ 3. Backup_Database
           Success → 4. Backup_File_Systems
           Failure → 10. Alert_Critical_Failure
           
4. Backup_File_Systems
   ├→ 4a. Backup_Application_Files
   ├→ 4b. Backup_Configuration_Files
   └→ 4c. Backup_Log_Files
       └→ 5. Verify_Backups
           Success → 6. Copy_to_Remote_Site
           Failure → 11. Alert_Backup_Verification_Failed
           
6. Copy_to_Remote_Site
   └→ 7. Verify_Remote_Copy
       └→ 8. Start_Non_Critical_Services
           └→ 9. Send_Backup_Success_Report
```

---

## Best Practices Summary

### Job Design
✅ One job, one purpose
✅ Meaningful, consistent naming
✅ Clear documentation
✅ Appropriate timeouts
✅ Proper error handling

### Scheduling
✅ Use calendars effectively
✅ Avoid resource contention
✅ Consider time zones
✅ Build in buffer time
✅ Test schedules thoroughly

### Dependencies
✅ Keep dependencies simple
✅ Document complex flows
✅ Use job groups
✅ Implement fallbacks
✅ Plan for failures

### Monitoring
✅ Set up appropriate alerts
✅ Monitor critical paths
✅ Track job duration trends
✅ Review failures regularly
✅ Maintain audit trail

### Maintenance
✅ Regular review of job definitions
✅ Archive old jobs
✅ Update documentation
✅ Test changes in non-production
✅ Keep Tidal version current

---

## Quick Reference Card

### Job Status Codes
```
S = Success
F = Failed
R = Running
W = Waiting
A = Aborted
H = On Hold
X = Scheduled
```

### Common Commands (if CLI available)
```
tadmin -c status <jobname>     # Check job status
tadmin -c run <jobname>        # Run job manually
tadmin -c hold <jobname>       # Put job on hold
tadmin -c release <jobname>    # Release hold
tadmin -c abort <jobname>      # Abort running job
```

### Key Shortcuts (Web UI)
```
Ctrl+N: New job
Ctrl+E: Edit job
Ctrl+R: Run job
F5: Refresh
```

---

## Certification Path

1. **Basic**: Job creation and scheduling
2. **Intermediate**: Dependencies and error handling
3. **Advanced**: Complex workflows and optimization
4. **Expert**: Architecture and troubleshooting

---

**This completes Tidal Theory!**

Next: Sample configurations and exercises.

