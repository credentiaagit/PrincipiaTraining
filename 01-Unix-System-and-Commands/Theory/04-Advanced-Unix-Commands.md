# Advanced Unix Commands

## Table of Contents
1. [File Permissions and Ownership](#file-permissions-and-ownership)
2. [Process Management](#process-management)
3. [Archiving and Compression](#archiving-and-compression)
4. [Network Commands](#network-commands)
5. [System Monitoring](#system-monitoring)
6. [Disk Management](#disk-management)

---

## File Permissions and Ownership

### Understanding Permissions

**Notation**: `rwxrwxrwx` = Owner, Group, Others

**Permission Values**:
- `r (read)` = 4
- `w (write)` = 2
- `x (execute)` = 1
- `-` = 0

**Examples**:
- `rwx` = 7 (4+2+1)
- `rw-` = 6 (4+2)
- `r-x` = 5 (4+1)
- `r--` = 4

### chmod - Change Mode

```bash
# Numeric mode
chmod 755 script.sh         # rwxr-xr-x
chmod 644 file.txt          # rw-r--r--
chmod 600 private.txt       # rw-------
chmod 777 shared.sh         # rwxrwxrwx (avoid this!)

# Symbolic mode
chmod u+x script.sh         # Add execute for owner
chmod g-w file.txt          # Remove write for group
chmod o+r file.txt          # Add read for others
chmod a+x script.sh         # Add execute for all

# Multiple changes
chmod u+x,g+x script.sh
chmod u=rwx,g=rx,o=r file.txt

# Recursive
chmod -R 755 directory/

# Reference another file's permissions
chmod --reference=file1.txt file2.txt
```

### chown - Change Owner

```bash
# Change owner only
chown john file.txt

# Change owner and group
chown john:staff file.txt

# Change group only
chown :staff file.txt

# Recursive
chown -R john:staff /opt/trading/

# Verbose output
chown -v john file.txt
```

### chgrp - Change Group

```bash
# Change group
chgrp staff file.txt

# Recursive
chgrp -R developers /opt/project/

# Verbose
chgrp -v staff file.txt
```

### Special Permissions

```bash
# SUID (Set User ID) - Run as file owner
chmod u+s program          # 4755

# SGID (Set Group ID) - Run as group owner
chmod g+s program          # 2755

# Sticky Bit - Only owner can delete (useful for /tmp)
chmod +t directory         # 1777

# Remove special permissions
chmod u-s program
chmod g-s program
chmod -t directory
```

### umask - Default Permissions

```bash
# View current umask
umask

# Set umask
umask 022                  # New files: 644, directories: 755
umask 077                  # New files: 600, directories: 700

# How umask works:
# Files: 666 - umask = permission
# Dirs:  777 - umask = permission
```

---

## Process Management

### Viewing Processes

**ps - Process Status**

```bash
# Show your processes
ps

# All processes with details
ps aux

# All processes in tree format
ps auxf

# Processes for specific user
ps -u john

# Show process hierarchy
ps -ejH

# Custom format
ps -eo pid,user,cmd,%cpu,%mem

# Show threads
ps -eLf
```

**top - Dynamic Process Viewer**

```bash
# Start top
top

# Top commands (while running):
# h - Help
# q - Quit
# k - Kill process
# r - Renice process
# P - Sort by CPU
# M - Sort by Memory
# 1 - Show individual CPUs
# u - Filter by user
```

**htop - Better top** (if available)

```bash
htop
# Use arrow keys, F1-F10 for actions
```

### Process Control

```bash
# Run command in background
command &

# Run command and disconnect from terminal
nohup command &

# List background jobs
jobs

# Bring job to foreground
fg %1

# Send job to background
bg %1

# Suspend current process
Ctrl+Z

# Run command with lower priority
nice -n 10 command

# Change priority of running process
renice -n 5 -p PID
```

### Killing Processes

```bash
# Kill by PID
kill PID
kill 12345

# Force kill
kill -9 PID
kill -KILL PID

# Kill all processes by name
killall process_name

# Kill processes by pattern
pkill pattern

# Interactive kill
top  # then press 'k' and enter PID

# Kill all processes of a user
pkill -u username

# Send specific signal
kill -TERM PID          # Graceful termination
kill -HUP PID           # Hangup (reload config)
kill -STOP PID          # Pause process
kill -CONT PID          # Continue process
```

### Process Information

```bash
# Process tree
pstree

# Process tree for specific user
pstree john

# Detailed process info
ps -p PID -f

# Open files by process
lsof -p PID

# Processes using a file
lsof /path/to/file

# Network connections
lsof -i
lsof -i :8080           # Specific port

# Find process by port
lsof -i :8080
netstat -tulpn | grep :8080
```

---

## Archiving and Compression

### tar - Tape Archive

```bash
# Create archive
tar -cvf archive.tar files/

# Create compressed archive (gzip)
tar -czvf archive.tar.gz files/

# Create compressed archive (bzip2)
tar -cjvf archive.tar.bz2 files/

# Extract archive
tar -xvf archive.tar

# Extract compressed archive
tar -xzvf archive.tar.gz

# Extract to specific directory
tar -xzvf archive.tar.gz -C /destination/

# List contents without extracting
tar -tvf archive.tar.gz

# Extract specific file
tar -xzvf archive.tar.gz path/to/file

# Add files to existing archive
tar -rvf archive.tar newfile.txt

# Exclude files
tar -czvf archive.tar.gz --exclude='*.log' directory/
```

**Common tar options**:
- `c` - Create
- `x` - Extract
- `t` - List
- `v` - Verbose
- `f` - File
- `z` - Gzip compression
- `j` - Bzip2 compression
- `J` - XZ compression

### gzip/gunzip - Compression

```bash
# Compress file (replaces original)
gzip file.txt           # Creates file.txt.gz

# Decompress
gunzip file.txt.gz

# Keep original
gzip -k file.txt

# Compress with best compression
gzip -9 file.txt

# View compressed file
zcat file.txt.gz
zless file.txt.gz
zgrep pattern file.txt.gz
```

### bzip2/bunzip2 - Better Compression

```bash
# Compress
bzip2 file.txt

# Decompress
bunzip2 file.txt.bz2

# Keep original
bzip2 -k file.txt

# View compressed file
bzcat file.txt.bz2
bzless file.txt.bz2
bzgrep pattern file.txt.bz2
```

### zip/unzip - ZIP Archives

```bash
# Create zip archive
zip archive.zip file1.txt file2.txt

# Create zip recursively
zip -r archive.zip directory/

# Extract zip
unzip archive.zip

# Extract to specific directory
unzip archive.zip -d /destination/

# List contents
unzip -l archive.zip

# Test archive
unzip -t archive.zip

# Update existing archive
zip -u archive.zip newfile.txt

# Exclude files
zip -r archive.zip directory/ -x '*.log'
```

---

## Network Commands

### Connectivity Testing

```bash
# Test connectivity
ping hostname
ping -c 4 google.com    # Send 4 packets

# Trace route
traceroute hostname
traceroute google.com

# DNS lookup
nslookup hostname
nslookup google.com

# DNS query
dig hostname
dig google.com

# Reverse DNS
dig -x IP_ADDRESS

# Show all DNS records
dig google.com ANY
```

### Network Information

```bash
# Show network interfaces
ifconfig
ip addr show

# Show routing table
netstat -rn
route -n
ip route show

# Show network statistics
netstat -s

# Show listening ports
netstat -tuln
ss -tuln

# Show active connections
netstat -tupn
ss -tupn

# Show network traffic
netstat -i
```

### File Transfer

```bash
# Secure copy
scp file.txt user@host:/path/
scp user@host:/path/file.txt .
scp -r directory/ user@host:/path/

# Secure copy with specific port
scp -P 2222 file.txt user@host:/path/

# Rsync (incremental sync)
rsync -avz source/ user@host:/destination/

# Rsync with progress
rsync -avz --progress source/ destination/

# Rsync with delete
rsync -avz --delete source/ destination/

# Download file
wget http://example.com/file.txt
curl -O http://example.com/file.txt

# Download with custom name
curl -o custom.txt http://example.com/file.txt

# Resume download
wget -c http://example.com/largefile.iso
```

### SSH - Secure Shell

```bash
# Connect to host
ssh user@hostname

# Connect with specific port
ssh -p 2222 user@hostname

# Execute command remotely
ssh user@hostname 'ls -la'

# Copy SSH key to remote host
ssh-copy-id user@hostname

# Generate SSH key pair
ssh-keygen -t rsa -b 4096

# SSH tunnel (port forwarding)
ssh -L 8080:localhost:80 user@hostname
```

---

## System Monitoring

### Disk Usage

```bash
# Disk space usage
df -h

# Show specific filesystem
df -h /opt

# Show inode usage
df -i

# Directory size
du -sh directory/

# Show size of all subdirectories
du -h --max-depth=1

# Largest files/directories
du -h | sort -h | tail -10

# Disk usage summary
du -sh *

# Show total only
du -sc directory/
```

### Memory Usage

```bash
# Show memory usage
free -h

# Show memory in MB
free -m

# Continuous monitoring
free -h -s 5        # Update every 5 seconds

# Detailed memory info
cat /proc/meminfo

# Virtual memory statistics
vmstat

# vmstat with intervals
vmstat 5 10         # Every 5 seconds, 10 times
```

### System Information

```bash
# System uptime
uptime

# Who is logged in
who
w

# Last logins
last
last -10            # Last 10 logins

# System hostname
hostname

# OS information
uname -a
cat /etc/os-release

# CPU information
cat /proc/cpuinfo
lscpu

# Hardware information
lshw                # Detailed hardware
lsblk               # Block devices
lsusb               # USB devices
lspci               # PCI devices
```

### System Logs

```bash
# View system log
tail -f /var/log/syslog         # Ubuntu/Debian
tail -f /var/log/messages       # RHEL/CentOS

# View authentication log
tail -f /var/log/auth.log

# Journal logs (systemd)
journalctl

# Recent logs
journalctl -n 50

# Follow logs
journalctl -f

# Logs for specific service
journalctl -u service_name

# Logs since boot
journalctl -b

# Logs for specific date
journalctl --since "2024-10-28"
journalctl --since "1 hour ago"
```

---

## Disk Management

### Mounting File Systems

```bash
# List mounted filesystems
mount

# Mount filesystem
mount /dev/sdb1 /mnt/usb

# Mount with options
mount -o ro /dev/sdb1 /mnt/usb  # Read-only

# Unmount
umount /mnt/usb

# Remount with different options
mount -o remount,rw /mnt/usb

# Show mount points
df -h
findmnt
```

### Disk Operations

```bash
# List block devices
lsblk

# Show disk partitions
fdisk -l

# Partition disk (interactive)
fdisk /dev/sdb

# Create filesystem
mkfs.ext4 /dev/sdb1

# Check filesystem
fsck /dev/sdb1

# Check and repair ext4
e2fsck -p /dev/sdb1

# Show filesystem type
file -s /dev/sdb1
blkid /dev/sdb1
```

---

## Capital Markets Use Case

### Daily Operations Scripts

**1. System Health Check**
```bash
#!/bin/bash
echo "=== System Health Report ==="
echo "Date: $(date)"
echo ""

echo "Disk Usage:"
df -h | grep -E '^/dev|Filesystem'
echo ""

echo "Memory Usage:"
free -h
echo ""

echo "Top CPU Processes:"
ps aux --sort=-%cpu | head -10
echo ""

echo "Trading Application Status:"
ps aux | grep trading_app | grep -v grep
```

**2. Archive Old Logs**
```bash
#!/bin/bash
# Archive logs older than 7 days
find /opt/trading/logs -name "*.log" -mtime +7 -exec gzip {} \;

# Move archived logs to archive directory
find /opt/trading/logs -name "*.log.gz" -mtime +7 -exec mv {} /opt/trading/archive/ \;
```

**3. Monitor Trading Process**
```bash
#!/bin/bash
PROCESS="trading_app"

if pgrep -x "$PROCESS" > /dev/null
then
    echo "$PROCESS is running"
    ps aux | grep $PROCESS | grep -v grep
else
    echo "$PROCESS is not running - ALERT!"
    # Restart process
    /opt/trading/bin/start_trading.sh
fi
```

**4. Cleanup Temp Files**
```bash
#!/bin/bash
# Remove temporary files older than 1 day
find /opt/trading/temp -type f -mtime +1 -delete

# Clean log files older than 90 days
find /opt/trading/logs -name "*.log.gz" -mtime +90 -delete

# Report disk space saved
echo "Cleanup completed at $(date)"
df -h /opt/trading
```

**5. Network Connectivity Check**
```bash
#!/bin/bash
HOSTS="db-server market-feed exchange-gateway"

for host in $HOSTS; do
    if ping -c 1 $host &> /dev/null; then
        echo "✓ $host is reachable"
    else
        echo "✗ $host is UNREACHABLE - ALERT!"
    fi
done
```

**6. Backup Critical Data**
```bash
#!/bin/bash
DATE=$(date +%Y%m%d)
BACKUP_DIR="/backup/trading_$DATE"

mkdir -p $BACKUP_DIR

# Backup configuration files
tar -czvf $BACKUP_DIR/config_$DATE.tar.gz /opt/trading/config/

# Backup recent transaction logs
tar -czvf $BACKUP_DIR/logs_$DATE.tar.gz /opt/trading/logs/*.log

# Set permissions
chmod 600 $BACKUP_DIR/*.tar.gz

echo "Backup completed: $BACKUP_DIR"
```

---

## Best Practices

✅ **Permissions**: Use least privilege principle - don't use 777

✅ **Process Management**: Use proper signals (TERM before KILL)

✅ **Backups**: Always backup before making system changes

✅ **Monitoring**: Set up regular monitoring scripts

✅ **Logs**: Rotate and archive logs regularly

✅ **Security**: Use SSH keys instead of passwords

✅ **Documentation**: Document all custom scripts and cron jobs

---

## Common Issues and Solutions

### Issue: Cannot Delete File
```bash
# Check permissions
ls -l file.txt

# Check if file is in use
lsof file.txt

# Check parent directory permissions
ls -ld directory/
```

### Issue: Disk Full
```bash
# Find large files
find / -type f -size +100M 2>/dev/null

# Find what's using space
du -sh /* | sort -h

# Clean package cache (Debian/Ubuntu)
sudo apt-get clean

# Check for deleted but open files
lsof | grep deleted
```

### Issue: Process Not Responding
```bash
# Try graceful termination first
kill -TERM PID

# Wait a few seconds, then force kill if needed
kill -9 PID

# Check process status
ps -p PID -o stat,pid,cmd
```

---

## Quick Reference

| Command | Purpose | Example |
|---------|---------|---------|
| `chmod` | Change permissions | `chmod 755 script.sh` |
| `chown` | Change owner | `chown user:group file` |
| `ps` | Process status | `ps aux` |
| `top` | Process monitor | `top` |
| `kill` | Terminate process | `kill -9 PID` |
| `tar` | Archive files | `tar -czvf archive.tar.gz dir/` |
| `gzip` | Compress | `gzip file.txt` |
| `scp` | Secure copy | `scp file user@host:` |
| `df` | Disk space | `df -h` |
| `du` | Directory size | `du -sh directory/` |
| `free` | Memory usage | `free -h` |

---

## Reference Links

1. **Linux Commands**: https://www.linux.com/training-tutorials/
2. **Process Management**: https://www.redhat.com/sysadmin/
3. **Tar Manual**: https://www.gnu.org/software/tar/manual/
4. **SSH Tutorial**: https://www.ssh.com/academy/ssh
5. **System Monitoring**: https://www.brendangregg.com/linuxperf.html

---

**Next Document**: `05-Industry-Use-Cases.md`

