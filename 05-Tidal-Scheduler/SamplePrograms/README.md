# Tidal Scheduler Sample Programs

This directory contains practical examples and documentation for working with Tidal job scheduler in capital markets environments.

## Files Overview

### 01-sample-job-definitions.md
**Purpose**: Example Tidal job definitions for trading operations
**Topics Covered**:
- Job definition structure
- Job dependencies
- Scheduling patterns
- Variable usage
- Error handling
- Notification setup
- Recovery procedures

---

## What is Tidal?

Tidal Enterprise Scheduler (formerly known as Tidal Workload Automation) is an enterprise job scheduling solution used for:
- Batch job scheduling
- Workflow automation
- Cross-platform job management
- Real-time event-driven processing
- Dependency management
- SLA monitoring

### Why Tidal in Capital Markets?

Capital markets rely on Tidal for:
- **End-of-Day Processing**: Coordinating complex batch jobs
- **Market Data Processing**: Scheduled data feeds and updates
- **Regulatory Reporting**: Timely submission of required reports
- **Backup and Maintenance**: Automated system maintenance
- **Cross-System Coordination**: Managing dependencies across platforms

---

## Key Concepts

### 1. Jobs
A job is a unit of work to be executed:
- **Command Job**: Executes a script or program
- **File Transfer Job**: Moves files between systems
- **SQL Job**: Runs database queries
- **FTP Job**: Transfers files via FTP/SFTP

### 2. Job Groups
Logical grouping of related jobs:
- Easier management
- Shared properties
- Organizational structure

### 3. Calendar
Defines when jobs should run:
- **Regular Calendar**: Standard days
- **Business Days**: Excludes weekends/holidays
- **Custom Calendar**: Specific dates

### 4. Dependencies
Jobs can depend on:
- **Predecessor Jobs**: Must complete successfully
- **File Dependencies**: File must exist
- **Time Dependencies**: Specific time constraints
- **Variable Dependencies**: Condition-based execution

### 5. Variables
Dynamic values used in jobs:
- **Global Variables**: Shared across all jobs
- **Job Variables**: Specific to a job
- **Runtime Variables**: Set during execution

---

## Common Job Patterns

### 1. Simple Scheduled Job
```
Job Name: Daily_Market_Data_Load
Schedule: Daily at 06:00 AM
Command: /opt/trading/scripts/load_market_data.sh
Calendar: Business Days
```

### 2. Job with Dependencies
```
Job Name: Generate_Trading_Report
Dependencies: 
  - Trade_Processing (Success)
  - Position_Calculation (Success)
Command: /opt/trading/scripts/generate_report.sh
```

### 3. File-Triggered Job
```
Job Name: Process_Incoming_File
Trigger: File Arrival
File Path: /data/incoming/*.csv
Action: /opt/trading/scripts/process_file.sh [FILE_PATH]
```

### 4. Job Chain
```
1. Extract_Data → 2. Transform_Data → 3. Load_Data → 4. Generate_Report
```

### 5. Parallel Processing
```
Main_Job
  ├─ Process_Region_1 ─┐
  ├─ Process_Region_2 ─┤→ Consolidate_Results
  └─ Process_Region_3 ─┘
```

---

## Tidal Job Definition Structure

### Basic Job Template
```xml
<Job>
    <Name>Daily_EOD_Processing</Name>
    <Description>End of day processing for trading system</Description>
    <JobType>Command</JobType>
    <Command>/opt/trading/scripts/eod_processing.sh</Command>
    <Agent>TRADING_SERVER_01</Agent>
    <Calendar>Business_Days</Calendar>
    <Schedule>
        <Time>18:00</Time>
        <Days>Mon,Tue,Wed,Thu,Fri</Days>
    </Schedule>
    <Dependencies>
        <Predecessor>Market_Close_Validation</Predecessor>
    </Dependencies>
    <Notifications>
        <OnSuccess>admin@company.com</OnSuccess>
        <OnFailure>support@company.com</OnFailure>
    </Notifications>
</Job>
```

---

## Variable Usage

### Global Variables
```
{TRADE_DATE}        = 2024-10-28
{ENVIRONMENT}       = PRODUCTION
{BACKUP_PATH}       = /backup/trading
{LOG_PATH}          = /var/log/trading
{DATA_PATH}         = /data/trading
```

### Using Variables in Jobs
```bash
# In job command
/opt/trading/scripts/process_trades.sh {TRADE_DATE} {ENVIRONMENT}

# In file paths
{DATA_PATH}/market_data_{TRADE_DATE}.csv
```

### Dynamic Variable Assignment
```bash
# Set variable based on job output
RECORD_COUNT=$(cat /tmp/record_count.txt)
# Use in subsequent jobs
```

---

## Scheduling Patterns

### 1. Time-Based Schedules
```
Daily:        Every day at 06:00 AM
Weekly:       Every Monday at 08:00 AM
Monthly:      First business day at 09:00 AM
Quarterly:    Last day of quarter at 18:00 PM
```

### 2. Event-Based Schedules
```
File Arrival:     When specific file appears
Job Completion:   After another job finishes
Variable Change:  When variable is set/changed
External Event:   API trigger or message queue
```

### 3. Complex Schedules
```
Multiple Times:   06:00, 12:00, 18:00
Date Range:       From 1st to 15th of month
Excluding Dates:  Skip holidays and weekends
```

---

## Error Handling and Recovery

### 1. Retry Logic
```
Max Retries: 3
Retry Interval: 5 minutes
Action on Final Failure: Send alert, mark job failed
```

### 2. Recovery Jobs
```
Primary Job: Daily_Trade_Processing
Recovery Job: Trade_Processing_Recovery
  - Runs if primary fails
  - Attempts alternative processing
  - Notifies support team
```

### 3. Notification Setup
```
On Success: INFO level - Send to log only
On Warning: Email to operations team
On Failure: Page on-call engineer, Email management
```

---

## Monitoring and Alerting

### Job Status Monitoring
- **Active**: Currently running
- **Success**: Completed successfully
- **Failed**: Ended with error
- **Waiting**: Waiting for dependencies
- **Held**: Manually held by operator
- **Skipped**: Skipped based on conditions

### SLA Monitoring
```
Job: Critical_Trade_Processing
SLA: Must complete within 2 hours
Start Time: 18:00
Latest Acceptable Finish: 20:00
Alert If: Exceeds 1 hour 45 minutes
```

---

## Best Practices

### 1. Naming Conventions
```
Format: [System]_[Function]_[Frequency]
Examples:
  - TRADING_EOD_PROCESSING_DAILY
  - MARKET_DATA_LOAD_HOURLY
  - REGULATORY_REPORT_MONTHLY
```

### 2. Documentation
- Clear job descriptions
- Contact information
- Business justification
- Dependency documentation
- Run time estimates

### 3. Testing
- Test in development environment first
- Verify dependencies
- Test failure scenarios
- Validate notifications
- Check resource usage

### 4. Resource Management
- Set appropriate timeouts
- Limit concurrent jobs
- Monitor system resources
- Schedule resource-intensive jobs during off-peak hours

### 5. Security
- Use service accounts (not personal accounts)
- Encrypt sensitive data
- Audit job access
- Restrict job modification permissions
- Secure variable values

---

## Troubleshooting Guide

### Job Not Starting
```
Check:
1. Job status (Active/Held?)
2. Dependencies met?
3. Calendar allows execution?
4. Agent available?
5. Sufficient resources?
```

### Job Fails Repeatedly
```
Actions:
1. Review job log files
2. Check script exit codes
3. Verify file permissions
4. Validate input data
5. Check system resources
6. Review recent changes
```

### Job Running Too Long
```
Investigate:
1. Check for data volume increase
2. Review query performance
3. Look for system bottlenecks
4. Check for locks/deadlocks
5. Review process priorities
```

### Missing Dependencies
```
Solutions:
1. Verify predecessor jobs ran
2. Check file existence
3. Validate variable values
4. Review dependency conditions
5. Check calendar alignment
```

---

## Capital Markets Job Examples

### 1. Morning Market Open
```
05:00 - Pre_Market_Validation
05:30 - Load_Overnight_Market_Data
06:00 - Calculate_Opening_Prices
06:30 - Update_Trading_System
07:00 - Generate_Morning_Report
07:30 - Notify_Traders
```

### 2. Intraday Processing
```
Every Hour:
  - Update_Market_Prices
  - Calculate_Portfolio_Values
  - Check_Risk_Limits
  - Update_Dashboards

Every 15 Minutes:
  - Process_Trade_Confirmations
  - Update_Position_Files
```

### 3. End of Day Processing
```
16:00 - Market_Close_Validation
16:30 - Final_Trade_Processing
17:00 - Position_Reconciliation
17:30 - Calculate_Daily_PnL
18:00 - Generate_EOD_Reports
18:30 - Backup_Critical_Data
19:00 - Archive_Transaction_Logs
19:30 - Send_EOD_Notifications
```

### 4. Month End Processing
```
Last Business Day:
  20:00 - Month_End_Trade_Cutoff
  20:30 - Calculate_Monthly_PnL
  21:00 - Generate_Regulatory_Reports
  21:30 - Portfolio_Rebalancing
  22:00 - Month_End_Backup
  23:00 - Archive_Monthly_Data
```

---

## Tidal CLI Commands

### Job Management
```bash
# Start a job
tidaljob -n JOB_NAME -a run

# Hold a job
tidaljob -n JOB_NAME -a hold

# Release a held job
tidaljob -n JOB_NAME -a release

# Skip a job
tidaljob -n JOB_NAME -a skip

# Check job status
tidaljob -n JOB_NAME -a status
```

### Dependency Management
```bash
# Add dependency
tidaljob -n JOB_NAME -a adddep -d PREDECESSOR_JOB

# Remove dependency
tidaljob -n JOB_NAME -a removedep -d PREDECESSOR_JOB

# List dependencies
tidaljob -n JOB_NAME -a listdeps
```

### Variable Management
```bash
# Set variable
tidalvar -n VAR_NAME -v "value"

# Get variable
tidalvar -n VAR_NAME -a get

# List variables
tidalvar -a list
```

---

## Integration with Other Systems

### 1. Database Integration
```sql
-- Job to execute SQL
Job Type: SQL
Connection: TRADING_DB
Query: CALL process_eod_trades()
```

### 2. File Transfer Integration
```
Job Type: FTP
Source: local:/data/reports/daily_*.pdf
Destination: remote:/incoming/
Protocol: SFTP
```

### 3. Email Notifications
```
On Completion:
  To: trading-team@company.com
  Subject: Daily Processing Complete - {TRADE_DATE}
  Body: All jobs completed successfully. Report attached.
  Attachment: {REPORT_PATH}/daily_summary.pdf
```

### 4. API Integration
```bash
# Call REST API from job
curl -X POST https://api.company.com/trading/notify \
  -H "Content-Type: application/json" \
  -d '{"status":"complete","date":"{TRADE_DATE}"}'
```

---

## Performance Optimization

### 1. Parallel Execution
- Run independent jobs in parallel
- Use job groups for logical grouping
- Monitor system resources

### 2. Resource Allocation
- Assign jobs to appropriate agents
- Balance load across servers
- Use dedicated agents for critical jobs

### 3. Scheduling Optimization
- Spread jobs across time windows
- Avoid peak hours for non-critical jobs
- Consider timezone differences

---

## Disaster Recovery

### 1. Job Backup
- Regular export of job definitions
- Version control for job configurations
- Document recovery procedures

### 2. Failover Procedures
- Secondary scheduler instance
- Automatic failover configuration
- Manual failover procedures

### 3. Recovery Testing
- Regular DR drills
- Test job recovery
- Validate backup procedures

---

## Reference Links

1. **Tidal Documentation**: Check with your Tidal vendor
2. **Tidal Community**: User forums and knowledge base
3. **Training Resources**: Vendor-provided training materials
4. **Best Practices**: Industry standards for job scheduling

---

## Learning Exercises

1. Create a simple job chain for daily processing
2. Set up file-triggered job execution
3. Implement error handling and recovery
4. Configure SLA monitoring
5. Create month-end processing workflow
6. Set up cross-system dependencies
7. Implement variable-driven job execution

---

**Note**: Tidal implementation varies by version and configuration. Consult your organization's Tidal administrators and documentation for specific details.

**Next Steps**: Review the sample job definitions and work with your Tidal team to implement real-world scenarios.

