#!/bin/bash
################################################################################
# Script: 04-backup-automation.sh
# Purpose: Automated backup system for trading application data
# Author: Training Team
# Usage: ./04-backup-automation.sh [options]
################################################################################

# Configuration
BACKUP_ROOT="/backup"
SOURCE_DIRS=(
    "/opt/trading/config"
    "/opt/trading/scripts"
    "/opt/trading/data/reports"
)
RETENTION_DAYS=30
TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
DATE=$(date '+%Y%m%d')
LOG_FILE="/var/log/backup_${DATE}.log"

# Email configuration (if needed)
ADMIN_EMAIL="admin@example.com"
SEND_EMAIL=false

################################################################################
# Function: log_message
# Purpose: Log messages to file and console
################################################################################
log_message() {
    local level=$1
    shift
    local message="$@"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    echo "[$timestamp] [$level] $message" | tee -a "$LOG_FILE"
}

################################################################################
# Function: check_prerequisites
# Purpose: Verify all requirements are met
################################################################################
check_prerequisites() {
    log_message "INFO" "Checking prerequisites..."
    
    # Check if running as root or with sudo
    if [ "$EUID" -ne 0 ] && [ -z "$SUDO_USER" ]; then
        log_message "WARN" "Not running as root. Some backups may fail due to permissions."
    fi
    
    # Check if backup directory exists
    if [ ! -d "$BACKUP_ROOT" ]; then
        log_message "INFO" "Creating backup directory: $BACKUP_ROOT"
        mkdir -p "$BACKUP_ROOT" || {
            log_message "ERROR" "Failed to create backup directory"
            return 1
        }
    fi
    
    # Check disk space (require at least 5GB free)
    local free_space=$(df -k "$BACKUP_ROOT" | awk 'NR==2 {print $4}')
    local required_space=$((5 * 1024 * 1024))  # 5GB in KB
    
    if [ $free_space -lt $required_space ]; then
        log_message "ERROR" "Insufficient disk space. Required: 5GB, Available: $((free_space/1024/1024))GB"
        return 1
    fi
    
    # Check if tar and gzip are available
    command -v tar >/dev/null 2>&1 || {
        log_message "ERROR" "tar command not found"
        return 1
    }
    
    command -v gzip >/dev/null 2>&1 || {
        log_message "ERROR" "gzip command not found"
        return 1
    }
    
    log_message "INFO" "Prerequisites check passed"
    return 0
}

################################################################################
# Function: backup_directory
# Purpose: Backup a single directory
################################################################################
backup_directory() {
    local source_dir=$1
    local backup_name=$(basename "$source_dir")
    local backup_path="$BACKUP_ROOT/${DATE}/${backup_name}_${TIMESTAMP}.tar.gz"
    
    log_message "INFO" "Starting backup of: $source_dir"
    
    # Check if source directory exists
    if [ ! -d "$source_dir" ]; then
        log_message "WARN" "Source directory does not exist: $source_dir"
        return 1
    fi
    
    # Create backup directory for today
    mkdir -p "$BACKUP_ROOT/$DATE"
    
    # Create backup with progress
    tar -czf "$backup_path" -C "$(dirname "$source_dir")" "$(basename "$source_dir")" 2>&1 | \
        tee -a "$LOG_FILE"
    
    # Check if backup was successful
    if [ ${PIPESTATUS[0]} -eq 0 ] && [ -f "$backup_path" ]; then
        local backup_size=$(du -h "$backup_path" | cut -f1)
        log_message "INFO" "Backup completed: $backup_path (Size: $backup_size)"
        
        # Verify backup integrity
        if tar -tzf "$backup_path" >/dev/null 2>&1; then
            log_message "INFO" "Backup integrity verified"
            return 0
        else
            log_message "ERROR" "Backup integrity check failed"
            return 1
        fi
    else
        log_message "ERROR" "Backup failed for: $source_dir"
        return 1
    fi
}

################################################################################
# Function: backup_database
# Purpose: Backup database (example with mysqldump)
################################################################################
backup_database() {
    local db_name="trading_db"
    local db_user="backup_user"
    local db_password="backup_pass"
    local backup_path="$BACKUP_ROOT/${DATE}/database_${TIMESTAMP}.sql.gz"
    
    log_message "INFO" "Starting database backup: $db_name"
    
    # Check if mysqldump is available
    if ! command -v mysqldump >/dev/null 2>&1; then
        log_message "WARN" "mysqldump not found, skipping database backup"
        return 1
    fi
    
    # Create backup directory
    mkdir -p "$BACKUP_ROOT/$DATE"
    
    # Perform database dump
    mysqldump -u"$db_user" -p"$db_password" "$db_name" 2>>"$LOG_FILE" | \
        gzip > "$backup_path"
    
    if [ ${PIPESTATUS[0]} -eq 0 ] && [ -f "$backup_path" ]; then
        local backup_size=$(du -h "$backup_path" | cut -f1)
        log_message "INFO" "Database backup completed: $backup_path (Size: $backup_size)"
        return 0
    else
        log_message "ERROR" "Database backup failed"
        return 1
    fi
}

################################################################################
# Function: clean_old_backups
# Purpose: Remove backups older than retention period
################################################################################
clean_old_backups() {
    log_message "INFO" "Cleaning old backups (retention: $RETENTION_DAYS days)..."
    
    local deleted_count=0
    local freed_space=0
    
    # Find and delete old backup directories
    find "$BACKUP_ROOT" -maxdepth 1 -type d -name "[0-9]*" -mtime +$RETENTION_DAYS | \
    while read -r old_backup; do
        local size=$(du -sk "$old_backup" | cut -f1)
        log_message "INFO" "Removing old backup: $old_backup"
        rm -rf "$old_backup"
        ((deleted_count++))
        ((freed_space+=size))
    done
    
    if [ $deleted_count -gt 0 ]; then
        log_message "INFO" "Cleaned $deleted_count old backups, freed $((freed_space/1024))MB"
    else
        log_message "INFO" "No old backups to clean"
    fi
}

################################################################################
# Function: generate_backup_report
# Purpose: Generate summary report of backup operations
################################################################################
generate_backup_report() {
    local success_count=$1
    local fail_count=$2
    local report_file="$BACKUP_ROOT/${DATE}/backup_report_${TIMESTAMP}.txt"
    
    cat > "$report_file" << EOF
========================================
Backup Report
========================================
Date: $(date '+%Y-%m-%d %H:%M:%S')
Hostname: $(hostname)

Summary:
--------
Successful backups: $success_count
Failed backups: $fail_count
Total backups: $((success_count + fail_count))

Backup Location: $BACKUP_ROOT/$DATE
Retention Policy: $RETENTION_DAYS days

Disk Usage:
-----------
$(df -h "$BACKUP_ROOT")

Backup Directory Contents:
--------------------------
$(du -sh "$BACKUP_ROOT/$DATE"/* 2>/dev/null | column -t)

Recent Backup Sizes:
--------------------
$(find "$BACKUP_ROOT" -maxdepth 2 -name "*.tar.gz" -o -name "*.sql.gz" | \
  xargs du -sh 2>/dev/null | sort -h | tail -10)

========================================
EOF
    
    log_message "INFO" "Report generated: $report_file"
    
    # Display report
    cat "$report_file"
}

################################################################################
# Function: send_notification
# Purpose: Send email notification with backup status
################################################################################
send_notification() {
    local subject=$1
    local success_count=$2
    local fail_count=$3
    
    if [ "$SEND_EMAIL" = true ]; then
        local body="Backup completed at $(date)\n"
        body+="Successful: $success_count\n"
        body+="Failed: $fail_count\n"
        body+="\nCheck log: $LOG_FILE"
        
        echo -e "$body" | mail -s "$subject" "$ADMIN_EMAIL"
        log_message "INFO" "Notification sent to $ADMIN_EMAIL"
    fi
}

################################################################################
# Function: create_incremental_backup
# Purpose: Create incremental backup using rsync
################################################################################
create_incremental_backup() {
    local source_dir=$1
    local backup_name=$(basename "$source_dir")
    local backup_dest="$BACKUP_ROOT/incremental/$backup_name"
    local latest_link="$BACKUP_ROOT/incremental/latest_$backup_name"
    local current_backup="$backup_dest/$TIMESTAMP"
    
    log_message "INFO" "Creating incremental backup: $source_dir"
    
    # Create backup directory
    mkdir -p "$current_backup"
    
    # Rsync with hard links to previous backup
    if [ -d "$latest_link" ]; then
        rsync -av --link-dest="$latest_link" "$source_dir/" "$current_backup/" 2>&1 | \
            tee -a "$LOG_FILE"
    else
        rsync -av "$source_dir/" "$current_backup/" 2>&1 | \
            tee -a "$LOG_FILE"
    fi
    
    if [ ${PIPESTATUS[0]} -eq 0 ]; then
        # Update latest link
        rm -f "$latest_link"
        ln -s "$current_backup" "$latest_link"
        log_message "INFO" "Incremental backup completed"
        return 0
    else
        log_message "ERROR" "Incremental backup failed"
        return 1
    fi
}

################################################################################
# Function: usage
# Purpose: Display usage information
################################################################################
usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Automated backup system for trading application

OPTIONS:
    -h, --help              Display this help message
    -i, --incremental       Create incremental backups
    -d, --database          Include database backup
    -e, --email             Send email notification
    -r, --retention DAYS    Set retention period (default: 30)
    -v, --verbose           Verbose output

EXAMPLES:
    $0                      # Standard backup
    $0 -i                   # Incremental backup
    $0 -d -e                # Include DB and send email
    $0 -r 60                # 60 days retention

EOF
}

################################################################################
# Main Script
################################################################################
main() {
    local incremental=false
    local include_database=false
    local success_count=0
    local fail_count=0
    
    # Parse command line arguments
    while [ $# -gt 0 ]; do
        case $1 in
            -h|--help)
                usage
                exit 0
                ;;
            -i|--incremental)
                incremental=true
                shift
                ;;
            -d|--database)
                include_database=true
                shift
                ;;
            -e|--email)
                SEND_EMAIL=true
                shift
                ;;
            -r|--retention)
                RETENTION_DAYS=$2
                shift 2
                ;;
            -v|--verbose)
                set -x
                shift
                ;;
            *)
                echo "Unknown option: $1"
                usage
                exit 1
                ;;
        esac
    done
    
    # Start backup process
    log_message "INFO" "========================================="
    log_message "INFO" "Starting Backup Process"
    log_message "INFO" "========================================="
    
    # Check prerequisites
    if ! check_prerequisites; then
        log_message "ERROR" "Prerequisites check failed. Aborting."
        exit 1
    fi
    
    # Perform backups
    for source_dir in "${SOURCE_DIRS[@]}"; do
        if [ "$incremental" = true ]; then
            if create_incremental_backup "$source_dir"; then
                ((success_count++))
            else
                ((fail_count++))
            fi
        else
            if backup_directory "$source_dir"; then
                ((success_count++))
            else
                ((fail_count++))
            fi
        fi
    done
    
    # Database backup
    if [ "$include_database" = true ]; then
        if backup_database; then
            ((success_count++))
        else
            ((fail_count++))
        fi
    fi
    
    # Clean old backups
    clean_old_backups
    
    # Generate report
    generate_backup_report "$success_count" "$fail_count"
    
    # Send notification
    if [ $fail_count -eq 0 ]; then
        send_notification "Backup Success" "$success_count" "$fail_count"
        log_message "INFO" "All backups completed successfully"
        exit 0
    else
        send_notification "Backup Failed" "$success_count" "$fail_count"
        log_message "ERROR" "Some backups failed. Check log for details."
        exit 1
    fi
}

# Run main function
main "$@"

