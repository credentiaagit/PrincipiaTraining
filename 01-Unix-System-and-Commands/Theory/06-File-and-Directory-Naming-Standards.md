# Unix File and Directory Naming Standards

## Table of Contents
1. [File Naming Conventions](#file-naming-conventions)
2. [Directory Naming Conventions](#directory-naming-conventions)
3. [Script File Standards](#script-file-standards)
4. [Configuration File Standards](#configuration-file-standards)
5. [Data File Standards](#data-file-standards)
6. [Log File Standards](#log-file-standards)
7. [Backup File Standards](#backup-file-standards)
8. [Capital Markets Specific Standards](#capital-markets-specific-standards)
9. [General Best Practices](#general-best-practices)

---

## File Naming Conventions

### General Rules

**What is File Naming Convention?**
A consistent approach to naming files that makes them easy to identify, search, and manage.

**Why Follow Naming Conventions?**
- Easy to find files
- Scripts can process files predictably
- Reduces errors and confusion
- Professional organization

### Core Principles

**1. Use Lowercase**
- **Convention**: Prefer lowercase letters
- **Why**: Avoids case-sensitivity issues, easier to type
```bash
# Good
trades.csv
market-data.txt
process-trades.sh

# Avoid - Mixed case can cause issues
Trades.csv
Market-Data.txt
ProcessTrades.sh
```

**2. Use Hyphens or Underscores (Not Spaces)**
- **Convention**: `kebab-case` or `snake_case`
- **Why**: Spaces require escaping, cause problems in scripts
```bash
# Good - Hyphens (preferred)
trade-report.csv
daily-summary.txt
market-data-archive.tar.gz

# Good - Underscores (also acceptable)
trade_report.csv
daily_summary.txt
market_data_archive.tar.gz

# Bad - Spaces
trade report.csv        # Requires quotes: "trade report.csv"
daily summary.txt       # Problems in scripts
market data.csv         # Hard to work with
```

**3. Be Descriptive**
- **Convention**: Names should clearly indicate content
```bash
# Good - Descriptive
equity-trades-2024-10-28.csv
daily-pnl-report.pdf
trader-positions-snapshot.csv

# Bad - Unclear
file1.csv
data.txt
output.csv
temp.tmp
```

**4. Include Dates in Appropriate Format**
- **Convention**: `YYYY-MM-DD` or `YYYYMMDD`
- **Why**: Sortable chronologically, international standard
```bash
# Good - ISO 8601 format
trades-2024-10-28.csv
report-2024-10-28-093000.pdf
backup-2024-10-28.tar.gz

# Also acceptable - Compact format
trades-20241028.csv
report-20241028-093000.pdf

# Bad - Non-sortable formats
trades-10-28-2024.csv     # Month/Day/Year (not sortable)
trades-28-10-2024.csv     # Day/Month/Year (not sortable)
trades-oct-28-2024.csv    # Month name (not sortable)
```

**5. Use Standard Extensions**
- **Convention**: Always use appropriate file extensions
- **Why**: Identifies file type at a glance
```bash
# Good - Clear extensions
script.sh               # Shell script
config.conf             # Configuration
data.csv                # CSV data
report.pdf              # PDF report
archive.tar.gz          # Compressed archive
notes.txt               # Text file
image.jpg               # JPEG image

# Bad - Missing or wrong extensions
script                  # What type of file?
data                    # What format?
report.doc              # If it's actually PDF
```

**6. Avoid Special Characters**
- **Avoid**: `&`, `$`, `*`, `?`, `|`, `<`, `>`, `\`, `;`, `'`, `"`
- **Why**: These have special meaning in shell, cause problems
```bash
# Good
report-final.pdf
trades-and-settlements.csv
price-greater-than-100.txt

# Bad
report&final.pdf        # & runs command in background
trades$settlements.csv  # $ is variable prefix
price>100.txt          # > is redirection operator
file?.csv              # ? is wildcard
```

---

## Directory Naming Conventions

### Directory Structure Standards

**1. Lowercase with Hyphens/Underscores**
```bash
# Good
/opt/trading/
/var/log/trading/
/home/user/market-data/
/backup/daily-trades/

# Avoid
/opt/Trading/          # Mixed case
/var/log/Trading Data/ # Spaces
```

**2. Hierarchical Organization**
```bash
# Good - Clear hierarchy
/opt/trading/
├── bin/              # Executable scripts
├── config/           # Configuration files
├── data/             # Data files
│   ├── input/
│   ├── output/
│   └── archive/
├── logs/             # Log files
├── scripts/          # Source scripts
└── temp/             # Temporary files

# Good - By date
/opt/trading/data/2024/10/28/
/opt/trading/logs/2024/10/

# Good - By function
/opt/trading/
├── equity/
├── fixed-income/
└── derivatives/
```

---

## Script File Standards

### Shell Scripts

**Naming**: `verb-noun.sh` or `verb_noun.sh`
```bash
# Good - Descriptive action + object
process-trades.sh
validate-market-data.sh
generate-daily-report.sh
backup-database.sh
archive-old-files.sh
send-email-alerts.sh
calculate-positions.sh

# Bad
pt.sh                  # Too cryptic
trades.sh              # Not clear what it does
script1.sh             # Meaningless
daily.sh               # What does it do daily?
```

**Location**:
```bash
# System scripts
/usr/local/bin/process-trades.sh

# Application scripts
/opt/trading/bin/process-trades.sh
/opt/trading/scripts/process-trades.sh

# User scripts
~/bin/process-trades.sh
~/scripts/process-trades.sh
```

---

## Configuration File Standards

### Configuration Files

**Extensions**: `.conf`, `.cfg`, `.config`, `.ini`
```bash
# Good
database.conf
application.config
trading-system.cfg
server.ini

# Bad
database              # No extension
config.txt           # Wrong extension
```

**Location**:
```bash
# System configuration
/etc/trading/
/etc/trading/database.conf
/etc/trading/application.conf

# Application configuration
/opt/trading/config/
/opt/trading/config/database.conf
/opt/trading/config/app.conf

# User configuration
~/.config/trading/
~/.tradingrc
```

---

## Data File Standards

### Input Data Files

**Format**: `type-description-YYYY-MM-DD.ext`
```bash
# Good
trades-nyse-2024-10-28.csv
market-data-equity-2024-10-28.csv
orders-pending-2024-10-28-093000.csv
positions-eod-2024-10-28.csv

# Also acceptable
trades-nyse-20241028.csv
market-data-equity-20241028.csv
```

### Output/Report Files

**Format**: `report-type-YYYY-MM-DD-HHMMSS.ext`
```bash
# Good
report-daily-summary-2024-10-28.pdf
report-pnl-2024-10-28-160000.pdf
report-risk-analysis-2024-10-28.xlsx
summary-trades-2024-10-28.csv

# Bad
report.pdf                    # Not specific
daily.pdf                     # Missing date
summary-10-28.pdf            # Ambiguous date format
```

### Archive Files

**Format**: `archive-type-YYYY-MM-DD.tar.gz`
```bash
# Good
archive-trades-2024-10.tar.gz
archive-logs-2024-10-28.tar.gz
backup-database-2024-10-28-020000.tar.gz

# Bad
archive.tar.gz               # Not specific
backup.tar.gz                # Missing date and type
old-files.tar.gz            # Not descriptive
```

---

## Log File Standards

### Log Files

**Format**: `application-YYYY-MM-DD.log` or `application.log`
```bash
# Good - Dated logs
trading-system-2024-10-28.log
error-2024-10-28.log
access-2024-10-28.log
process-trades-2024-10-28.log

# Good - Rotating logs (automatically renamed by system)
application.log
application.log.1
application.log.2.gz

# Bad
log.txt                      # Not specific
output.log                   # Not descriptive
trading.txt                  # Wrong extension
```

**Location**:
```bash
# System logs
/var/log/trading/
/var/log/trading/trading-system-2024-10-28.log
/var/log/trading/error-2024-10-28.log

# Application logs
/opt/trading/logs/
/opt/trading/logs/process-2024-10-28.log
```

---

## Backup File Standards

### Backup Naming

**Format**: `original-name.backup.YYYY-MM-DD` or `original-name.YYYY-MM-DD.bak`
```bash
# Good
database.conf.backup.2024-10-28
trades.csv.2024-10-28.bak
application.log.backup.2024-10-28-020000

# Also acceptable
database.conf.bak
database.conf.old
database.conf.20241028

# Bad
database.bak                 # Missing date
backup                       # What was backed up?
old-config                   # Not clear what config
```

### Versioned Files

```bash
# Good - Version numbers
script-v1.0.sh
script-v1.1.sh
script-v2.0.sh

# Good - Date-based
script-2024-10-28.sh
script-2024-10-29.sh

# Bad
script-old.sh
script-new.sh
script-latest.sh
```

---

## Capital Markets Specific Standards

### Trading Data Files

```bash
# Trade files
TRADES-{EXCHANGE}-{DATE}-{SEQUENCE}.csv
TRADES-NYSE-2024-10-28-001.csv
TRADES-NASDAQ-2024-10-28-001.csv

# Market data files
MARKET-DATA-{TYPE}-{DATE}-{TIME}.csv
MARKET-DATA-EQUITY-2024-10-28-093000.csv
MARKET-DATA-OPTIONS-2024-10-28-093000.csv

# Position files
POSITIONS-{TYPE}-{DATE}.csv
POSITIONS-EOD-2024-10-28.csv
POSITIONS-INTRADAY-2024-10-28-120000.csv

# Order files
ORDERS-{STATUS}-{DATE}-{TIME}.csv
ORDERS-PENDING-2024-10-28-093000.csv
ORDERS-EXECUTED-2024-10-28-160000.csv
```

### Report Files

```bash
# Daily reports
REPORT-DAILY-PNL-2024-10-28.pdf
REPORT-DAILY-POSITIONS-2024-10-28.xlsx
REPORT-DAILY-TRADES-SUMMARY-2024-10-28.csv

# Risk reports
REPORT-RISK-VAR-2024-10-28.pdf
REPORT-RISK-EXPOSURE-2024-10-28.xlsx

# Compliance reports
REPORT-COMPLIANCE-TRADE-REVIEW-2024-10-28.pdf
REPORT-COMPLIANCE-LIMIT-BREACHES-2024-10-28.csv
```

### Archive Structure

```bash
/opt/trading/archive/
├── 2024/
│   ├── 01/          # January
│   │   ├── trades/
│   │   ├── reports/
│   │   └── logs/
│   ├── 02/          # February
│   └── 10/          # October
│       ├── trades/
│       │   ├── TRADES-NYSE-2024-10-28-001.csv
│       │   └── TRADES-NASDAQ-2024-10-28-001.csv
│       ├── reports/
│       │   └── REPORT-DAILY-PNL-2024-10-28.pdf
│       └── logs/
│           └── trading-system-2024-10-28.log
└── 2023/
```

---

## General Best Practices

### File Naming Checklist

✅ **DO**:
- Use lowercase letters
- Use hyphens or underscores (no spaces)
- Be descriptive and specific
- Include dates in ISO format (YYYY-MM-DD)
- Use appropriate file extensions
- Keep names under 255 characters
- Make names searchable

❌ **DON'T**:
- Use spaces in filenames
- Use special characters (&, $, *, ?, |, <, >, etc.)
- Start with hyphen or dot (hidden file)
- Use ambiguous abbreviations
- Mix naming conventions
- Use dates in non-sortable format

### Searchability

**Make files easy to find**:
```bash
# Good - Easy to search
find /opt/trading/data -name "trades-2024-10-*.csv"
find /opt/trading/logs -name "*-2024-10-28.log"
ls -l TRADES-NYSE-2024-*

# Works because of consistent naming
grep "ERROR" *-error-2024-10-28.log
```

### Scriptability

**Make files easy to process**:
```bash
# Good - Script can process files predictably
for file in trades-*-2024-10-*.csv; do
    process_file "$file"
done

# Good - Extract date from filename
filename="trades-2024-10-28.csv"
date=$(echo "$filename" | grep -oP '\d{4}-\d{2}-\d{2}')
# date = 2024-10-28
```

### Documentation

**Document naming conventions**:
```bash
# Create README in each directory
/opt/trading/data/README.md

## File Naming Convention

### Trade Files
Format: TRADES-{EXCHANGE}-{DATE}-{SEQ}.csv
Example: TRADES-NYSE-2024-10-28-001.csv

### Market Data Files
Format: MARKET-DATA-{TYPE}-{DATE}-{TIME}.csv
Example: MARKET-DATA-EQUITY-2024-10-28-093000.csv
```

---

## Common Patterns

### Date Stamps

```bash
# Current date in filename
trades-$(date +%Y-%m-%d).csv         # trades-2024-10-28.csv
trades-$(date +%Y%m%d).csv           # trades-20241028.csv

# Date and time
report-$(date +%Y-%m-%d-%H%M%S).pdf  # report-2024-10-28-153045.pdf
```

### Sequence Numbers

```bash
# With leading zeros (sorts correctly)
trade-001.csv
trade-002.csv
trade-010.csv

# Bad - No leading zeros (sorts incorrectly)
trade-1.csv
trade-2.csv
trade-10.csv     # Sorts before trade-2.csv!
```

### Version Strings

```bash
# Semantic versioning
script-v1.0.0.sh
script-v1.1.0.sh
script-v2.0.0.sh

# Date-based versioning
script-2024-10-28.sh
script-2024-10-29.sh
```

---

## Example Directory Structure

### Well-Organized Trading System

```bash
/opt/trading/
├── bin/                          # Executable scripts
│   ├── process-trades.sh
│   ├── generate-reports.sh
│   └── backup-data.sh
├── config/                       # Configuration files
│   ├── database.conf
│   ├── application.conf
│   └── credentials.enc
├── data/                         # Data files
│   ├── input/                    # Incoming data
│   │   ├── trades-2024-10-28.csv
│   │   └── market-data-2024-10-28.csv
│   ├── output/                   # Processed data
│   │   └── report-2024-10-28.pdf
│   ├── archive/                  # Historical data
│   │   └── 2024/
│   │       └── 10/
│   │           └── trades-2024-10-28.csv
│   └── temp/                     # Temporary files
├── logs/                         # Log files
│   ├── trading-system-2024-10-28.log
│   ├── error-2024-10-28.log
│   └── access-2024-10-28.log
├── scripts/                      # Source scripts (non-executable)
│   ├── lib/
│   │   ├── common-functions.sh
│   │   └── validation-utils.sh
│   └── tests/
│       └── test-validation.sh
└── docs/                         # Documentation
    ├── README.md
    ├── NAMING-CONVENTIONS.md
    └── USER-GUIDE.md
```

---

## Quick Reference

### Naming Patterns

| File Type | Pattern | Example |
|-----------|---------|---------|
| Shell script | `verb-noun.sh` | `process-trades.sh` |
| Config file | `name.conf` | `database.conf` |
| Data file | `type-date.csv` | `trades-2024-10-28.csv` |
| Log file | `app-date.log` | `trading-2024-10-28.log` |
| Report | `report-type-date.pdf` | `report-daily-2024-10-28.pdf` |
| Backup | `name.backup.date` | `db.backup.2024-10-28` |
| Archive | `archive-type-date.tar.gz` | `archive-logs-2024-10.tar.gz` |

### Best Practices Summary

1. **Lowercase** - Avoid case issues
2. **No spaces** - Use hyphens or underscores
3. **Descriptive** - Name should indicate content
4. **Dates** - Use YYYY-MM-DD format
5. **Extensions** - Always use appropriate extension
6. **Consistent** - Follow same pattern throughout
7. **Searchable** - Make files easy to find
8. **Scriptable** - Make processing predictable

---

*Last Updated: 2024-10-28*  
*Follow these standards for organized, maintainable file systems*

