# Tidal Scheduler Exercises

## Level 1: Basic Concepts

### Exercise 1: Job Terminology
**Task**: Define the following Tidal terms:
1. Job
2. Job Group
3. Agent
4. Calendar
5. Predecessor

**Answer**:
1. **Job**: A unit of work to be executed (script, command, or program)
2. **Job Group**: Collection of related jobs organized together
3. **Agent**: Software component that executes jobs on target systems
4. **Calendar**: Defines which days jobs should run (business days, weekends, etc.)
5. **Predecessor**: A job that must complete before another job can run

---

### Exercise 2: Job Status
**Task**: What do these job statuses mean?
1. Scheduled
2. Running
3. Success
4. Failed
5. Waiting

**Answer**:
1. **Scheduled**: Job is queued and waiting for scheduled time
2. **Running**: Job is currently executing
3. **Success**: Job completed successfully (exit code 0)
4. **Failed**: Job completed with errors (non-zero exit code)
5. **Waiting**: Job is waiting for dependencies to complete

---

## Level 2: Job Creation

### Exercise 3: Simple Job Definition
**Task**: Create a job definition for a Unix script that runs daily at 6 PM.

**Answer**:
```
Job Name: Daily_Backup
Job Type: Unix Shell
Command: /scripts/backup.sh
Agent: UNIX-PROD-01
Schedule: Daily at 18:00
Calendar: All_Days
Runtime User: backup_user
Working Directory: /backup
```

---

### Exercise 4: Job with Variables
**Task**: Create a job that processes files with current date in filename.

**Answer**:
```
Job Name: Process_Daily_File
Job Type: Unix Shell
Command: /scripts/process_file.sh /data/trades_${DATE}.csv
Agent: UNIX-PROD-01
Schedule: Daily at 17:30
Calendar: Business_Days
Variables:
  DATE=${DATE}
  OUTPUT_DIR=/processed/${DATE}
```

---

## Level 3: Dependencies

### Exercise 5: Sequential Jobs
**Task**: Design a dependency chain for:
1. Collect Data
2. Validate Data
3. Process Data
4. Generate Report

**Answer**:
```
Collect_Data (17:00)
    └→ Validate_Data (on success)
        └→ Process_Data (on success)
            └→ Generate_Report (on success)

Dependencies:
- Validate_Data: Predecessor = Collect_Data (success)
- Process_Data: Predecessor = Validate_Data (success)
- Generate_Report: Predecessor = Process_Data (success)
```

---

### Exercise 6: Parallel Jobs
**Task**: Design jobs that run in parallel then merge:
1. Process Equities
2. Process Options
3. Process Futures
4. Consolidate Results (waits for all)

**Answer**:
```
Start_Processing (17:00)
    ├→ Process_Equities
    ├→ Process_Options
    └→ Process_Futures
        └→ Consolidate_Results (waits for all 3)

Consolidate_Results Dependencies:
- Process_Equities (success)
- Process_Options (success)
- Process_Futures (success)
```

---

## Level 4: Error Handling

### Exercise 7: Failure Handling
**Task**: Design error handling for a critical job:
- Primary job: Process_Trades
- On failure: What should happen?

**Answer**:
```
Process_Trades
    ├→ On Success: Calculate_Positions
    └→ On Failure:
        1. Send_Alert_to_Operations (immediate)
        2. Retry_Process_Trades (after 5 min, max 2 retries)
        3. If all retries fail: Run_Recovery_Process
        4. Put dependent jobs on hold
        5. Create incident ticket

Notifications:
  Success: Email ops@company.com
  Failure: Email + SMS operations manager
```

---

### Exercise 8: Recovery Job
**Task**: Design a recovery job for failed trade processing.

**Answer**:
```
Job Name: Recovery_Process_Trades
Job Type: Unix Shell
Trigger: On Failure of Process_Trades
Command: /scripts/recovery_process.sh ${FAILED_DATE}

Actions:
  1. Analyze failure logs
  2. Identify problem records
  3. Move problem records to holding area
  4. Reprocess good records
  5. Generate failure report
  6. Email report to trading team

Timeout: 30 minutes
Priority: High
```

---

## Level 5: Real-World Scenarios

### Exercise 9: EOD Processing Workflow
**Task**: Design complete end-of-day workflow with:
- Market data collection
- Trade processing
- Position calculation
- Report generation
- Archival

**Answer**:
```
EOD Workflow (starts 16:00)

Phase 1: Data Collection (16:00-16:30)
  Market_Close_Wait (16:00)
      └→ Collect_Market_Data (16:05)
          ├→ Get_NYSE_Data
          ├→ Get_NASDAQ_Data
          └→ Get_Options_Data
              └→ Validate_All_Data

Phase 2: Trade Processing (16:30-17:30)
  Validate_All_Data (success)
      └→ Process_Trades
          ├→ Process_Equity_Trades
          ├→ Process_Options_Trades
          └→ Process_Futures_Trades
              └→ Reconcile_All_Trades

Phase 3: Calculations (17:30-18:00)
  Reconcile_All_Trades (success)
      └→ Calculate_Positions
          └→ Calculate_PnL
              └→ Calculate_Risk

Phase 4: Reporting (18:00-19:00)
  Calculate_Risk (success)
      └→ Generate_Reports
          ├→ Position_Report
          ├→ PnL_Report
          ├→ Risk_Report
          └→ Regulatory_Report
              └→ Distribute_Reports

Phase 5: Archival (19:00-20:00)
  Distribute_Reports (success)
      └→ Archive_Daily_Data
          └→ Cleanup_Temp_Files
              └→ EOD_Complete_Notification
```

---

### Exercise 10: File Watcher Implementation
**Task**: Design a file watcher job that waits for daily market data file.

**Answer**:
```
Job Name: Wait_for_Market_Data_File
Job Type: File Watcher
Description: Wait for daily market data CSV file

Configuration:
  Watch Directory: /incoming/market_data/
  File Pattern: market_data_${DATE}.csv
  Check Interval: 30 seconds
  Timeout: 60 minutes

Schedule:
  Type: Daily
  Start Time: 15:30 (before market close)
  Calendar: Trading_Days

On File Found:
  1. Verify file size > 1KB
  2. Wait for file stability (2 minutes)
  3. Trigger: Validate_and_Process_Data

On Timeout:
  1. Send Alert: "Market data not received"
  2. Email: data-ops@company.com
  3. Run: Investigate_Missing_Data
  4. Put dependent jobs on hold

Priority: Critical
```

---

## Challenge Problems

### Challenge 1: Month-End Processing
Design complete month-end processing workflow including:
- Data collection for entire month
- Monthly reconciliation
- Report generation
- Regulatory filing
- Data archival

### Challenge 2: Disaster Recovery
Design backup and recovery workflow:
- Daily database backups
- File system backups
- Offsite replication
- Backup verification
- Recovery procedures

### Challenge 3: Real-Time Monitoring
Design monitoring system using Tidal:
- Every 5 minutes during trading hours
- Check system health
- Monitor trade volumes
- Alert on anomalies
- Generate status dashboard

---

## Practice Scenarios

### Scenario 1: Job Failure Investigation
**Given**: Job "Process_Trades" failed at 17:30

**Tasks**:
1. What logs would you check?
2. What are possible causes?
3. How would you recover?
4. How would you prevent recurrence?

**Answer**:
1. **Logs to Check**:
   - Tidal job log
   - Agent log on execution server
   - Application log (/opt/trading/logs/)
   - System logs (/var/log/)

2. **Possible Causes**:
   - Script error
   - Missing input files
   - Database connection failure
   - Insufficient disk space
   - Permission issues
   - Timeout

3. **Recovery Steps**:
   - Review error logs
   - Fix underlying issue
   - Restart job manually
   - Verify output
   - Resume dependent jobs

4. **Prevention**:
   - Add input file validation
   - Implement better error handling
   - Add disk space checks
   - Increase timeout if needed
   - Improve logging

---

### Scenario 2: Performance Optimization
**Given**: EOD processing takes 4 hours (target: 2 hours)

**Tasks**: How would you optimize?

**Answer**:
1. **Analyze Current Workflow**:
   - Identify longest-running jobs
   - Check for unnecessary sequential processing
   - Review resource utilization

2. **Optimization Strategies**:
   - Parallelize independent jobs
   - Optimize slow scripts
   - Add more resources (CPU, Memory)
   - Use better algorithms
   - Split large jobs into smaller ones
   - Schedule non-critical jobs later

3. **Implementation**:
   - Test changes in non-production
   - Monitor performance improvements
   - Adjust timeouts and resources
   - Document changes

---

## Study Tips

1. **Understand Dependencies**: Practice drawing dependency graphs
2. **Error Handling**: Think about failure scenarios
3. **Timing**: Consider time zones and calendars
4. **Documentation**: Always document job purposes
5. **Testing**: Test in non-production first
6. **Monitoring**: Set up appropriate alerts
7. **Maintenance**: Regular review and optimization

---

## Assessment Checklist

Can you:
- [ ] Create basic job definitions
- [ ] Set up simple schedules
- [ ] Configure predecessor dependencies
- [ ] Design error handling
- [ ] Create file watcher jobs
- [ ] Design complex workflows
- [ ] Troubleshoot failed jobs
- [ ] Optimize job performance
- [ ] Implement monitoring
- [ ] Handle recovery scenarios

---

## Next Steps

1. Practice with Tidal test environment
2. Study your organization's existing jobs
3. Design workflows for new requirements
4. Learn from experienced operators
5. Stay updated on Tidal best practices

---

## Additional Resources

1. Tidal official documentation
2. Internal knowledge base
3. Operations runbooks
4. Vendor training materials
5. Community forums

---

**Congratulations on completing the Tidal exercises!** 🎉

You now have knowledge of all five critical technologies for capital markets support systems:
1. ✅ Unix System & Commands
2. ✅ Shell Scripting
3. ✅ TCL Programming
4. ✅ SQL Database
5. ✅ Tidal Scheduler

**Keep learning and practicing!** 🚀

