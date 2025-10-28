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

### 📚 Theory & Learning Resources

1. **Official Documentation**:
   - [Tidal Enterprise Scheduler](https://www.cisco.com/c/en/us/products/cloud-systems-management/tidal-enterprise-scheduler/index.html) - Official Cisco Tidal page
   - Tidal Administrator Guide - Contact your Tidal vendor/administrator
   - Tidal User Guide - Internal company documentation
   - Tidal API Documentation - For automation and integration

2. **Enterprise Scheduling Concepts**:
   - [Job Scheduling Best Practices](https://www.bmc.com/blogs/job-scheduling/) - General concepts
   - [Workload Automation Guide](https://www.stonebranch.com/resources/workload-automation-guide/) - Industry standards
   - [IT Process Automation](https://www.gartner.com/en/information-technology/glossary/workload-automation) - Gartner insights

3. **Video Learning**:
   - YouTube - Search "Tidal Enterprise Scheduler Tutorial"
   - Vendor Training Videos - Available through Cisco/Tidal support
   - Company Internal Training - Check your LMS (Learning Management System)

4. **Related Technologies**:
   - [Cron Job Tutorial](https://www.tutorialspoint.com/unix_commands/cron.htm) - Basic scheduling
   - [Control-M Documentation](https://documents.bmc.com/supportu/controlm) - Similar tool (for comparison)
   - [AutoSys Documentation](https://www.broadcom.com/products/software/automation/autosys) - Enterprise scheduling

### 🎮 Hands-On Practice Resources

1. **Tidal Training Environments**:
   - **Company Training Instance** - Contact your Tidal administrator
   - **Sandbox Environment** - Request access for practice
   - **Development Tidal Server** - Non-production environment
   - **Tidal Simulator** - Check with vendor for availability

2. **Practice Activities**:
   - Create simple scheduled jobs
   - Build job dependency chains
   - Configure alerts and notifications
   - Test job recovery scenarios
   - Practice with variables and parameters
   - Set up calendars for business days

3. **Hands-On Labs** (Create Your Own):
   - Lab 1: Schedule a simple backup job
   - Lab 2: Create a 3-job dependency chain
   - Lab 3: Implement error handling and recovery
   - Lab 4: Configure SLA monitoring
   - Lab 5: Build end-of-day processing workflow

### 📖 Quick References & Guides

1. **Cheat Sheets**:
   - Tidal Command Reference - From official docs
   - Job Definition Template - Internal company template
   - Calendar Setup Guide - Business days configuration
   - Variable Usage Guide - Parameter passing examples

2. **Common Patterns**:
   - End-of-Day Processing Workflows
   - File-Triggered Job Patterns
   - Error Recovery Patterns
   - Cross-Platform Job Coordination

### 📚 Documentation & Knowledge Base

1. **Internal Resources**:
   - **Company Wiki** - Check for Tidal documentation pages
   - **Runbook Documentation** - Operational procedures
   - **Production Job Catalog** - Existing job examples
   - **Team SharePoint/Confluence** - Knowledge articles

2. **External Resources**:
   - [Tidal Enterprise Scheduler Community](https://community.cisco.com/) - User discussions
   - [BMC Communities](https://communities.bmc.com/) - Related scheduling topics
   - [IT Automation Blogs](https://www.redwood.com/blog/) - Industry insights

### 🎓 Training & Certification

1. **Official Training**:
   - **Tidal Administrator Training** - Contact Cisco/vendor
   - **Tidal Advanced Features** - Vendor-led course
   - **Tidal API and Integration** - For developers
   - **Company Internal Training** - Check HR/Training portal

2. **Self-Paced Learning**:
   - Work with senior team members
   - Shadow production support team
   - Review existing job definitions
   - Attend Tidal user group meetings

3. **Related Certifications**:
   - ITIL Foundation - IT Service Management
   - DevOps Certifications - Automation focus
   - Unix/Linux System Administration

### 💡 Community & Support

1. **Internal Support**:
   - **Tidal Administrator** - Your primary contact
   - **Production Support Team** - Operational issues
   - **Development Team** - Job design questions
   - **Team Chat Channel** - Quick questions

2. **External Support**:
   - Cisco TAC (Technical Assistance Center)
   - Tidal User Community Forums
   - LinkedIn Tidal User Groups
   - Stack Overflow - General scheduling questions

3. **Escalation Paths**:
   - Level 1: Team lead/Senior developer
   - Level 2: Tidal Administrator
   - Level 3: Vendor support (Cisco TAC)

### 🔧 Tools & Utilities

1. **Tidal Client Tools**:
   - Tidal Web Client - Browser-based interface
   - Tidal Desktop Client - Windows application
   - Tidal Command Line Interface (CLI)
   - Tidal API - For programmatic access

2. **Monitoring Tools**:
   - Tidal Dashboard - Job monitoring
   - Alert Management - Notification setup
   - Job History Reports - Analysis tools
   - Performance Metrics - System monitoring

3. **Integration Tools**:
   - REST API Client (Postman) - For API testing
   - SQL Client - Database integration
   - Script Editors - For job commands
   - Version Control (Git) - For job definitions

### 🔥 Learning Path

1. **Week 1-2: Basics**:
   - Understand Tidal architecture
   - Learn navigation and interface
   - View existing jobs and schedules
   - Understand job status and monitoring

2. **Week 3-4: Job Management**:
   - Create simple jobs
   - Set up schedules and calendars
   - Configure basic dependencies
   - Test job execution

3. **Week 5-6: Advanced Features**:
   - Complex dependencies
   - Error handling and recovery
   - Variables and parameters
   - SLA monitoring

4. **Week 7-8: Production Support**:
   - Troubleshooting techniques
   - Production job monitoring
   - Incident response
   - Change management

### 📋 Practice Scenarios

1. **Beginner Projects**:
   - Schedule a daily backup job
   - Create a job that runs every hour
   - Set up a job with email notification
   - Configure a business days calendar

2. **Intermediate Projects**:
   - Build a 5-job workflow with dependencies
   - Implement file-triggered job
   - Set up conditional execution based on variables
   - Create job recovery procedures

3. **Advanced Projects**:
   - Design complete EOD processing workflow
   - Implement cross-system job coordination
   - Set up comprehensive error handling
   - Build SLA monitoring framework

### 🏢 Capital Markets Specific

1. **Industry Resources**:
   - Financial Services Automation Best Practices
   - Regulatory Compliance and Audit Trails
   - Market Data Processing Patterns
   - Trading System Workflow Examples

2. **Use Cases**:
   - End-of-Day Processing
   - Market Data Distribution
   - Regulatory Reporting Schedules
   - Backup and Recovery Procedures
   - Cross-Region Coordination

---

**Note**: Tidal is a commercial product. Most advanced documentation requires licensed access. Contact your company's Tidal administrator for:
- Official documentation
- Training environment access
- Hands-on lab setup
- Internal runbooks and procedures

---

**Next Document**: `02-Tidal-Practical-Guide.md`

