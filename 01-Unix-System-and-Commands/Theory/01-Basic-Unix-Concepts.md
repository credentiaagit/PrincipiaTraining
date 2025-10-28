# Basic Unix Concepts and Architecture

## Table of Contents
1. [Introduction to Unix](#introduction-to-unix)
2. [Unix Architecture](#unix-architecture)
3. [File System Hierarchy](#file-system-hierarchy)
4. [Basic Concepts](#basic-concepts)
5. [Getting Started](#getting-started)

---

## Introduction to Unix

### What is Unix?
Unix is a powerful, multi-user, multitasking operating system originally developed in the 1970s at AT&T Bell Labs. It has influenced many modern operating systems including Linux, macOS, and BSD.

### Key Characteristics
- **Multi-user**: Multiple users can access the system simultaneously
- **Multitasking**: Can run multiple processes at the same time
- **Portability**: Written in C, making it portable across hardware
- **Security**: Strong permission and security model
- **Hierarchical File System**: Everything is organized in a tree structure
- **Command-line Interface**: Powerful shell for system interaction

### Why Unix for Capital Markets?
- **Stability**: Proven reliability for mission-critical applications
- **Performance**: Efficient resource management for high-volume transactions
- **Security**: Robust security features for sensitive financial data
- **Automation**: Powerful scripting capabilities
- **Scalability**: Handles large-scale enterprise applications

---

## Unix Architecture

Unix architecture consists of four main layers:

```
+----------------------------------+
|         Users/Applications       |
+----------------------------------+
|         Shell (CLI)              |
+----------------------------------+
|   System Calls & Libraries       |
+----------------------------------+
|      Kernel (Core OS)            |
+----------------------------------+
|         Hardware                 |
+----------------------------------+
```

### 1. Kernel
- Core of the operating system
- Manages hardware resources
- Handles:
  - Process management
  - Memory management
  - Device management
  - File system management

### 2. Shell
- Command-line interpreter
- Interface between user and kernel
- Common shells:
  - **bash** (Bourne Again Shell) - Most common
  - **sh** (Bourne Shell) - Original shell
  - **ksh** (Korn Shell) - Popular in enterprises
  - **csh/tcsh** (C Shell) - C-like syntax
  - **zsh** (Z Shell) - Extended features

### 3. System Utilities
- Standard programs and commands
- Categories:
  - File management (ls, cp, mv, rm)
  - Text processing (grep, sed, awk)
  - Process management (ps, top, kill)
  - Network utilities (ping, ssh, scp)

### 4. Applications
- User programs
- Custom scripts
- Database systems
- Web servers

---

## File System Hierarchy

Unix uses a hierarchical file system structure starting from root (/).

```
/                          (Root - top of file system)
├── bin/                   (Essential command binaries)
├── boot/                  (Boot loader files)
├── dev/                   (Device files)
├── etc/                   (System configuration files)
├── home/                  (User home directories)
│   ├── user1/
│   └── user2/
├── lib/                   (System libraries)
├── opt/                   (Optional application software)
├── tmp/                   (Temporary files)
├── usr/                   (User programs and data)
│   ├── bin/               (User commands)
│   ├── lib/               (Libraries)
│   ├── local/             (Local programs)
│   └── share/             (Shared data)
└── var/                   (Variable data)
    ├── log/               (Log files)
    ├── tmp/               (Temporary files)
    └── spool/             (Spool directories)
```

### Important Directories

| Directory | Purpose | Example Contents |
|-----------|---------|------------------|
| `/bin` | Essential commands | ls, cp, mv, rm, cat |
| `/etc` | Configuration files | passwd, hosts, fstab |
| `/home` | User home directories | /home/john, /home/mary |
| `/tmp` | Temporary files | Session files, temp data |
| `/usr/bin` | User commands | Additional utilities |
| `/var/log` | Log files | syslog, application logs |
| `/opt` | Optional software | Third-party applications |

---

## Basic Concepts

### 1. Everything is a File
In Unix, almost everything is treated as a file:
- Regular files (documents, programs)
- Directories (folders)
- Devices (hard drives, terminals)
- Pipes and sockets

### 2. File Types

```bash
# View file types with ls -l
-rw-r--r--   # Regular file
drwxr-xr-x   # Directory
lrwxrwxrwx   # Symbolic link
crw-rw-rw-   # Character device
brw-rw----   # Block device
```

**First character indicates type:**
- `-` : Regular file
- `d` : Directory
- `l` : Symbolic link
- `c` : Character device
- `b` : Block device
- `p` : Named pipe
- `s` : Socket

### 3. Users and Groups

**Users:**
- Every user has a unique username and User ID (UID)
- Root user (UID 0) has complete system access
- Regular users have limited permissions

**Groups:**
- Users belong to one or more groups
- Each group has a Group ID (GID)
- Used for shared resource access

**View current user information:**
```bash
whoami          # Current username
id              # User and group IDs
groups          # Groups you belong to
```

### 4. File Permissions

Every file has three permission sets:
- **Owner (User)**: The file creator
- **Group**: Users in the file's group
- **Others**: Everyone else

Three types of permissions:
- **r (read)**: View file contents (4)
- **w (write)**: Modify file (2)
- **x (execute)**: Run as program (1)

**Example:**
```
-rw-r--r--  1 john  staff  1024 Oct 28 10:30 report.txt
```
- `-`: Regular file
- `rw-`: Owner can read and write
- `r--`: Group can only read
- `r--`: Others can only read

### 5. Processes

- A process is a running instance of a program
- Each process has:
  - **PID (Process ID)**: Unique identifier
  - **PPID (Parent Process ID)**: Parent process
  - **Owner**: User who started it
  - **Priority**: CPU scheduling priority

### 6. Standard Streams

Every process has three standard streams:
- **stdin (0)**: Standard input (keyboard)
- **stdout (1)**: Standard output (screen)
- **stderr (2)**: Standard error (screen)

These can be redirected:
```bash
command > output.txt       # Redirect stdout to file
command 2> error.txt       # Redirect stderr to file
command < input.txt        # Read stdin from file
command >> output.txt      # Append stdout to file
```

---

## Getting Started

### Logging In

**Local Login:**
1. Enter username at login prompt
2. Enter password (characters won't display)
3. Shell prompt appears

**Remote Login (SSH):**
```bash
ssh username@hostname
# Example: ssh john@server.company.com
```

### The Shell Prompt

Common prompt formats:
```bash
$                          # Regular user (sh, bash)
%                          # Regular user (csh, tcsh)
#                          # Root user
[user@host ~]$             # User@hostname with current directory
```

### Basic Command Structure

```bash
command [options] [arguments]
```

**Examples:**
```bash
ls                         # Command only
ls -l                      # Command with option
ls -l /home                # Command with option and argument
ls -la /home /tmp          # Multiple arguments
```

### Getting Help

```bash
man command                # Manual page for command
man ls                     # Manual for ls command
info command               # Info documentation
command --help             # Quick help
whatis command             # Brief description
```

**Navigating man pages:**
- `Space`: Next page
- `b`: Previous page
- `/text`: Search for text
- `n`: Next search result
- `q`: Quit

### Your First Commands

```bash
# Who am I?
whoami

# Current date and time
date

# Calendar
cal

# Current directory
pwd

# List files
ls

# Clear screen
clear

# Exit/logout
exit
```

---

## Capital Markets Use Case

### Scenario: End-of-Day Processing System

In our capital market system:

1. **User Environment**: 
   - Traders and analysts login to Unix servers
   - Each has their own home directory with configurations

2. **File Organization**:
   ```
   /opt/trading/
   ├── bin/           (Trading applications)
   ├── config/        (Configuration files)
   ├── data/          (Market data)
   ├── logs/          (Application logs)
   └── scripts/       (TCL and shell scripts)
   ```

3. **Process Flow**:
   - Market data arrives in `/opt/trading/data/`
   - TCL scripts process transactions
   - Results stored in database
   - Log files track all operations
   - Shell scripts manage file movements

4. **Security**:
   - Different users have different access levels
   - Production files are read-only for analysts
   - Only operators can execute certain scripts

5. **Automation**:
   - Cron jobs schedule nightly processes
   - Scripts validate and move files
   - Email alerts on errors

---

## Key Takeaways

✅ Unix is a multi-user, multitasking operating system with a hierarchical file system

✅ Everything in Unix is treated as a file

✅ The shell is your primary interface to the system

✅ Understanding file permissions is crucial for security

✅ Processes are managed through PIDs and system calls

✅ Manual pages (`man`) are your best friend for learning commands

---

## Practice Exercise

Before moving to the next topic, ensure you can:
1. Login to a Unix system
2. Identify your username and groups
3. Navigate to your home directory
4. View the current date and calendar
5. Access the manual page for any command
6. Understand the basic file system structure

---

## What's Next?

In the next section, we'll cover:
- **Navigation and File Operations**: Moving around the file system and managing files
- Essential commands: `cd`, `ls`, `pwd`, `cp`, `mv`, `rm`, `mkdir`
- File viewing: `cat`, `less`, `more`, `head`, `tail`

---

## Reference Links

1. **Official Documentation**:
   - [The Open Group - Unix Standards](https://unix.org/)
   - [Linux Documentation Project](https://tldp.org/)

2. **Interactive Learning**:
   - [Linux Journey](https://linuxjourney.com/)
   - [OverTheWire - Bandit](https://overthewire.org/wargames/bandit/)

3. **Quick References**:
   - [Unix Commands Cheat Sheet](https://cheatography.com/davechild/cheat-sheets/linux-command-line/)
   - [ExplainShell](https://explainshell.com/) - Break down command syntax

4. **Books (Free Online)**:
   - "The Unix Programming Environment" concepts
   - "Introduction to Unix" tutorials

5. **Video Resources**:
   - Search for "Unix basics tutorial" on YouTube
   - LinkedIn Learning - Unix Essential Training

---

**Next Document**: `02-Navigation-and-File-Operations.md`

