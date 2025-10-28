# Navigation and File Operations

## Table of Contents
1. [Directory Navigation](#directory-navigation)
2. [Listing Files and Directories](#listing-files-and-directories)
3. [Creating and Removing Directories](#creating-and-removing-directories)
4. [File Operations](#file-operations)
5. [Viewing File Contents](#viewing-file-contents)
6. [File Searching](#file-searching)

---

## Directory Navigation

### Current Working Directory

**pwd** (Print Working Directory)
```bash
pwd
# Output: /home/john/projects
```

### Changing Directories

**cd** (Change Directory)

```bash
# Go to home directory
cd
cd ~
cd $HOME

# Go to specific directory
cd /opt/trading/scripts

# Go to parent directory
cd ..

# Go to previous directory
cd -

# Go to subdirectory
cd data/reports

# Relative vs Absolute paths
cd /home/john/data          # Absolute path (starts with /)
cd ../data                  # Relative path (relative to current)
```

**Path Shortcuts:**
- `.` : Current directory
- `..` : Parent directory
- `~` : Home directory
- `-` : Previous directory
- `/` : Root directory

**Examples:**
```bash
pwd                         # /home/john
cd /opt/trading            # Go to /opt/trading
pwd                        # /opt/trading
cd ..                      # Go up one level
pwd                        # /opt
cd -                       # Go back to previous
pwd                        # /opt/trading
cd ~/documents             # Go to /home/john/documents
```

---

## Listing Files and Directories

### Basic ls Command

```bash
ls                          # List files in current directory
ls /opt/trading            # List files in specific directory
ls file1.txt file2.txt     # List specific files
```

### Common ls Options

```bash
ls -l                       # Long format (detailed)
ls -a                       # Show all files (including hidden)
ls -la                      # Long format + all files
ls -lh                      # Human-readable file sizes
ls -lt                      # Sort by modification time
ls -ltr                     # Sort by time (reverse, oldest first)
ls -lS                      # Sort by file size
ls -R                       # Recursive listing
ls -ld directory            # List directory itself, not contents
ls -i                       # Show inode numbers
```

### Understanding ls -l Output

```bash
$ ls -l report.txt
-rw-r--r--  1 john  staff  2048 Oct 28 10:30 report.txt
```

**Breakdown:**
```
-rw-r--r--    1      john    staff     2048    Oct 28 10:30    report.txt
    |         |        |       |         |          |              |
File Type  Links    Owner   Group     Size      Date Time      Filename
& Perms
```

**File Type & Permissions:**
- Position 1: File type (`-` regular, `d` directory, `l` link)
- Positions 2-4: Owner permissions (rwx)
- Positions 5-7: Group permissions (rwx)
- Positions 8-10: Other permissions (rwx)

### Practical Examples

```bash
# List all .txt files
ls *.txt

# List all files starting with 'report'
ls report*

# List files modified today
ls -lt | head

# List largest files
ls -lS | head

# List only directories
ls -d */

# Show hidden files only
ls -d .*

# Long listing with human-readable sizes
ls -lh
# Output: -rw-r--r--  1 john  staff  2.0M Oct 28 10:30 data.csv
```

---

## Creating and Removing Directories

### Creating Directories

**mkdir** (Make Directory)

```bash
# Create single directory
mkdir reports

# Create multiple directories
mkdir reports data logs

# Create nested directories (parent directories too)
mkdir -p projects/2024/october/reports

# Create with specific permissions
mkdir -m 755 shared_folder

# Verbose output
mkdir -v new_folder
```

### Removing Directories

**rmdir** (Remove Directory) - Only empty directories

```bash
rmdir empty_folder
rmdir folder1 folder2 folder3
```

**rm -r** - Remove directory and contents

```bash
# Remove directory and all contents
rm -r old_project

# Remove with confirmation
rm -ri old_project

# Force remove (no confirmation)
rm -rf old_project

# Remove multiple directories
rm -r dir1 dir2 dir3
```

⚠️ **WARNING**: `rm -rf` is dangerous! It removes everything without confirmation.

---

## File Operations

### Creating Files

```bash
# Create empty file
touch newfile.txt

# Create multiple files
touch file1.txt file2.txt file3.txt

# Update timestamp of existing file
touch existing_file.txt

# Create file with content
echo "Hello World" > greeting.txt
cat > file.txt << EOF
Line 1
Line 2
Line 3
EOF
```

### Copying Files

**cp** (Copy)

```bash
# Copy file
cp source.txt destination.txt

# Copy to directory
cp file.txt /home/john/backup/

# Copy multiple files to directory
cp file1.txt file2.txt file3.txt /backup/

# Copy directory recursively
cp -r source_dir destination_dir

# Copy with preservation of attributes
cp -p file.txt backup.txt    # Preserve timestamp, ownership

# Interactive copy (confirm overwrite)
cp -i file.txt existing.txt

# Verbose output
cp -v file.txt backup/

# Copy only if source is newer
cp -u source.txt destination.txt
```

**Practical Examples:**
```bash
# Backup a file
cp report.txt report.txt.bak

# Copy entire directory structure
cp -r /opt/trading/data /backup/data_$(date +%Y%m%d)

# Copy preserving all attributes
cp -a source destination
```

### Moving/Renaming Files

**mv** (Move)

```bash
# Rename file
mv oldname.txt newname.txt

# Move file to directory
mv file.txt /home/john/documents/

# Move multiple files
mv file1.txt file2.txt file3.txt /backup/

# Move directory
mv old_folder new_folder

# Interactive move
mv -i file.txt existing.txt

# No overwrite
mv -n file.txt existing.txt

# Backup before overwrite
mv -b file.txt existing.txt
```

### Removing Files

**rm** (Remove)

```bash
# Remove file
rm file.txt

# Remove multiple files
rm file1.txt file2.txt file3.txt

# Interactive removal (confirm each)
rm -i *.txt

# Force removal
rm -f protected_file.txt

# Remove all .log files
rm *.log

# Remove files older than 7 days
find . -name "*.log" -mtime +7 -exec rm {} \;
```

---

## Viewing File Contents

### cat - Concatenate and Display

```bash
# Display file contents
cat file.txt

# Display multiple files
cat file1.txt file2.txt

# Number all lines
cat -n file.txt

# Number non-empty lines only
cat -b file.txt

# Show end of line markers
cat -e file.txt

# Create new file
cat > newfile.txt
Type content here
Press Ctrl+D to save

# Append to file
cat >> existing.txt

# Combine files
cat file1.txt file2.txt > combined.txt
```

### less - Page Through Text

```bash
less largefile.txt
```

**Navigation in less:**
- `Space` or `f`: Forward one page
- `b`: Backward one page
- `↓` or `j`: Forward one line
- `↑` or `k`: Backward one line
- `/pattern`: Search forward
- `?pattern`: Search backward
- `n`: Next search result
- `N`: Previous search result
- `g`: Go to beginning
- `G`: Go to end
- `q`: Quit

```bash
# Show line numbers
less -N file.txt

# Search highlighting
less -i file.txt      # Case-insensitive search
```

### more - Simple Pager

```bash
more file.txt
# Space: Next page
# Enter: Next line
# q: Quit
```

### head - View Beginning of File

```bash
# First 10 lines (default)
head file.txt

# First 20 lines
head -n 20 file.txt
head -20 file.txt

# First 100 bytes
head -c 100 file.txt

# Multiple files
head file1.txt file2.txt
```

### tail - View End of File

```bash
# Last 10 lines (default)
tail file.txt

# Last 20 lines
tail -n 20 file.txt
tail -20 file.txt

# Monitor file in real-time (useful for logs)
tail -f application.log

# Start from line 100
tail -n +100 file.txt

# Last 100 bytes
tail -c 100 file.txt
```

**Real-time Log Monitoring:**
```bash
# Follow log file
tail -f /var/log/system.log

# Follow with line numbers
tail -fn 50 app.log

# Follow multiple files
tail -f log1.txt log2.txt
```

---

## File Searching

### find - Search for Files

**Basic Syntax:**
```bash
find [path] [options] [expression]
```

**Search by Name:**
```bash
# Find by exact name
find /home -name "report.txt"

# Case-insensitive search
find /home -iname "REPORT.TXT"

# Find by pattern
find . -name "*.txt"
find . -name "report*"

# Find in current directory only (no subdirectories)
find . -maxdepth 1 -name "*.sh"
```

**Search by Type:**
```bash
# Find directories only
find /opt -type d -name "data"

# Find files only
find /opt -type f -name "*.log"

# Find symbolic links
find /usr -type l
```

**Search by Size:**
```bash
# Files larger than 100MB
find / -size +100M

# Files smaller than 1KB
find . -size -1k

# Files exactly 50MB
find . -size 50M

# Find empty files
find . -type f -empty
```

**Search by Time:**
```bash
# Modified in last 7 days
find . -mtime -7

# Modified more than 30 days ago
find . -mtime +30

# Modified exactly 7 days ago
find . -mtime 7

# Accessed in last 24 hours
find . -atime -1

# Changed in last hour
find . -cmin -60
```

**Search by Permissions:**
```bash
# Find files with permission 777
find . -perm 777

# Find files with SUID bit
find / -perm -4000

# Find writable files
find . -perm /222
```

**Search by Owner:**
```bash
# Find files owned by john
find /home -user john

# Find files owned by group staff
find /opt -group staff
```

**Execute Actions on Found Files:**
```bash
# Delete found files
find . -name "*.tmp" -delete

# Execute command on found files
find . -name "*.txt" -exec cat {} \;

# Confirm before execution
find . -name "*.log" -ok rm {} \;

# Find and copy
find . -name "*.conf" -exec cp {} /backup/ \;
```

**Practical Examples:**
```bash
# Find large log files older than 7 days
find /var/log -name "*.log" -size +100M -mtime +7

# Find and compress old files
find /data -name "*.txt" -mtime +30 -exec gzip {} \;

# Find files modified today
find . -type f -mtime 0

# Find and list with details
find . -name "*.sh" -exec ls -lh {} \;

# Count files in directory tree
find . -type f | wc -l
```

### locate - Fast File Search

```bash
# Update locate database (run as root)
updatedb

# Find files quickly
locate report.txt

# Case-insensitive
locate -i REPORT.txt

# Limit results
locate -n 10 *.txt

# Count matches
locate -c "*.log"
```

### which - Locate Command

```bash
# Find location of command
which ls
# Output: /bin/ls

which python
# Output: /usr/bin/python
```

### whereis - Locate Binary, Source, and Manual

```bash
whereis ls
# Output: ls: /bin/ls /usr/share/man/man1/ls.1

whereis python
```

---

## Capital Markets Use Case

### Daily Operations Scenario

**1. Morning Check - Navigate to trading directory:**
```bash
cd /opt/trading
pwd
ls -ltr data/incoming/     # Check recent files
```

**2. Process Market Data Files:**
```bash
# Check for today's files
ls -lh data/incoming/market_data_$(date +%Y%m%d)*

# Copy to processing area
cp data/incoming/*.csv data/processing/

# Move processed files to archive
mv data/processing/*.csv data/archive/$(date +%Y%m%d)/
```

**3. Monitor Logs:**
```bash
# View latest errors
tail -100 logs/application.log | grep ERROR

# Real-time monitoring
tail -f logs/trading_$(date +%Y%m%d).log
```

**4. Find and Clean Old Files:**
```bash
# Find files older than 90 days
find /opt/trading/archive -name "*.csv" -mtime +90

# Compress old files
find /opt/trading/archive -name "*.csv" -mtime +90 -exec gzip {} \;

# Remove temporary files
find /opt/trading/temp -name "*.tmp" -mtime +7 -delete
```

**5. Backup Configuration:**
```bash
# Create dated backup
cp -p config/trading.conf config/backups/trading.conf.$(date +%Y%m%d)

# Verify backup
ls -lh config/backups/
```

---

## Best Practices

✅ **Always verify before destructive operations**: Use `ls` before `rm`

✅ **Use tab completion**: Type partial filename and press Tab

✅ **Be careful with wildcards**: Test with `ls` first, then use in commands

✅ **Use relative paths when possible**: Easier to move scripts

✅ **Create backups**: Before modifying important files

✅ **Name files meaningfully**: Use descriptive names with dates

✅ **Use directories to organize**: Don't dump everything in one place

---

## Common Mistakes to Avoid

❌ `rm -rf /` - NEVER run this! It deletes everything

❌ `rm *.txt` in wrong directory - Always check `pwd` first

❌ Overwriting files without backup

❌ Using spaces in filenames - Use underscores or hyphens

❌ Not checking disk space before large copies

---

## Quick Reference

| Command | Purpose | Example |
|---------|---------|---------|
| `pwd` | Print working directory | `pwd` |
| `cd` | Change directory | `cd /opt` |
| `ls` | List files | `ls -ltr` |
| `mkdir` | Make directory | `mkdir new_dir` |
| `rmdir` | Remove empty directory | `rmdir old_dir` |
| `touch` | Create file | `touch file.txt` |
| `cp` | Copy | `cp file.txt backup/` |
| `mv` | Move/rename | `mv old.txt new.txt` |
| `rm` | Remove | `rm file.txt` |
| `cat` | Display file | `cat file.txt` |
| `less` | Page through file | `less large.txt` |
| `head` | First lines | `head -20 file.txt` |
| `tail` | Last lines | `tail -f log.txt` |
| `find` | Search files | `find . -name "*.txt"` |

---

## Reference Links

1. **GNU Coreutils Documentation**: https://www.gnu.org/software/coreutils/
2. **Linux Commands Cheat Sheet**: https://www.linuxtrainingacademy.com/linux-commands-cheat-sheet/
3. **ExplainShell**: https://explainshell.com/ - Paste any command to understand it
4. **Tecmint - 15 Basic ls Commands**: https://www.tecmint.com/15-basic-ls-command-examples-in-linux/

---

**Next Document**: `03-Text-Processing-and-Filters.md`

