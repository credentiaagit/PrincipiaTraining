#!/bin/bash
# 03-process-management-demo.sh
# Demonstration of process management commands

echo "=================================================="
echo "PROCESS MANAGEMENT DEMONSTRATION"
echo "=================================================="
echo ""

# ===================================
# 1. VIEWING PROCESSES
# ===================================
echo "1. VIEWING PROCESSES"
echo "===================="
echo ""

echo "a) Current shell processes:"
ps
echo ""

echo "b) All processes for current user:"
ps -u $USER | head -10
echo "... (showing first 10 only)"
echo ""

echo "c) Detailed process information:"
ps -f | head -5
echo "... (showing first 5 only)"
echo ""

echo "d) All processes with full details:"
ps aux | head -10
echo "... (showing first 10 only)"
echo ""

echo "e) Process tree:"
ps auxf | head -15
echo "... (showing first 15 only)"
echo ""

echo "f) Specific processes (bash shells):"
ps aux | grep bash | grep -v grep
echo ""

echo "g) Custom format output:"
ps -eo pid,user,cmd,%cpu,%mem --sort=-%mem | head -10
echo ""

# ===================================
# 2. BACKGROUND PROCESSES
# ===================================
echo "2. BACKGROUND PROCESSES"
echo "======================="
echo ""

echo "a) Starting background job..."
sleep 30 &
BG_PID=$!
echo "Background process started with PID: $BG_PID"
echo ""

echo "b) Listing jobs:"
jobs
echo ""

echo "c) Process information for background job:"
ps -p $BG_PID -o pid,state,cmd
echo ""

echo "d) Killing background job..."
kill $BG_PID
sleep 1
echo "Process killed"
jobs
echo ""

# ===================================
# 3. PROCESS INFORMATION
# ===================================
echo "3. DETAILED PROCESS INFORMATION"
echo "==============================="
echo ""

# Start a demo process
sleep 100 &
DEMO_PID=$!

echo "Started demo process with PID: $DEMO_PID"
echo ""

echo "a) Process details:"
ps -p $DEMO_PID -f
echo ""

echo "b) Process state:"
ps -p $DEMO_PID -o pid,state,cmd
echo ""
echo "Process states:"
echo "  R = Running"
echo "  S = Sleeping (interruptible)"
echo "  D = Sleeping (uninterruptible)"
echo "  Z = Zombie"
echo "  T = Stopped"
echo ""

echo "c) Process priority:"
ps -p $DEMO_PID -o pid,ni,cmd
echo "(NI = Nice value, -20 to 19, lower = higher priority)"
echo ""

# Clean up
kill $DEMO_PID
echo "Demo process killed"
echo ""

# ===================================
# 4. PROCESS MONITORING
# ===================================
echo "4. PROCESS MONITORING"
echo "====================="
echo ""

echo "a) Top CPU consuming processes:"
ps aux --sort=-%cpu | head -6
echo ""

echo "b) Top memory consuming processes:"
ps aux --sort=-%mem | head -6
echo ""

echo "c) Number of processes by user:"
ps aux | awk 'NR>1 {count[$1]++} END {for(user in count) print user":", count[user]}' | sort
echo ""

echo "d) Total number of processes:"
ps aux | wc -l
echo ""

# ===================================
# 5. PROCESS CONTROL DEMO
# ===================================
echo "5. PROCESS CONTROL DEMONSTRATION"
echo "================================="
echo ""

# Create a simple script to control
cat > demo_process.sh << 'SCRIPT'
#!/bin/bash
echo "Demo process started - PID: $$"
for i in {1..60}; do
    echo "Running... iteration $i"
    sleep 1
done
echo "Demo process finished"
SCRIPT

chmod +x demo_process.sh

echo "a) Starting process in background..."
./demo_process.sh > /tmp/demo_$$.log 2>&1 &
PROC_PID=$!
echo "Process started with PID: $PROC_PID"
sleep 2
echo ""

echo "b) Checking if process is running:"
if ps -p $PROC_PID > /dev/null; then
    echo "✓ Process $PROC_PID is running"
fi
echo ""

echo "c) Process details:"
ps -p $PROC_PID -o pid,ppid,%cpu,%mem,state,cmd
echo ""

echo "d) Sending SIGTERM (graceful termination):"
kill -TERM $PROC_PID
sleep 2
if ps -p $PROC_PID > /dev/null 2>&1; then
    echo "Process still running"
    echo "e) Force killing with SIGKILL:"
    kill -9 $PROC_PID
    sleep 1
fi
echo "Process terminated"
echo ""

# Clean up
rm -f demo_process.sh /tmp/demo_$$.log

# ===================================
# 6. SYSTEM LOAD AND UPTIME
# ===================================
echo "6. SYSTEM LOAD INFORMATION"
echo "=========================="
echo ""

echo "a) System uptime:"
uptime
echo ""

echo "b) Load average explanation:"
echo "   Load average shows average number of processes:"
echo "   - Waiting to run (runnable)"
echo "   - Currently running"
echo "   Displayed as: 1min, 5min, 15min averages"
echo ""

# ===================================
# 7. FINDING PROCESSES
# ===================================
echo "7. FINDING PROCESSES"
echo "===================="
echo ""

echo "a) Find process by name (bash):"
pgrep -l bash
echo ""

echo "b) Find process and show full command:"
pgrep -a bash | head -3
echo ""

echo "c) Count processes for current user:"
pgrep -u $USER | wc -l
echo ""

# ===================================
# 8. PRACTICAL SCENARIOS
# ===================================
echo "8. PRACTICAL SCENARIOS"
echo "======================"
echo ""

echo "SCENARIO 1: Check if specific application is running"
echo "-----------------------------------------------------"
cat << 'EXAMPLE'
#!/bin/bash
APP_NAME="trading_app"
if pgrep -x "$APP_NAME" > /dev/null; then
    echo "✓ $APP_NAME is running"
    PID=$(pgrep -x "$APP_NAME")
    echo "  PID: $PID"
    ps -p $PID -o %cpu,%mem,etime,cmd
else
    echo "✗ $APP_NAME is NOT running"
    # Auto-restart logic could go here
fi
EXAMPLE
echo ""

echo "SCENARIO 2: Kill all processes by pattern"
echo "------------------------------------------"
cat << 'EXAMPLE'
#!/bin/bash
PATTERN="test_process"
echo "Killing all processes matching: $PATTERN"
pkill -f "$PATTERN"
# Or with confirmation:
# ps aux | grep "$PATTERN" | grep -v grep
# read -p "Kill these processes? (y/n): " confirm
# if [ "$confirm" = "y" ]; then
#     pkill -f "$PATTERN"
# fi
EXAMPLE
echo ""

echo "SCENARIO 3: Monitor process resource usage"
echo "-------------------------------------------"
cat << 'EXAMPLE'
#!/bin/bash
PID=$1
while ps -p $PID > /dev/null; do
    clear
    echo "Monitoring Process: $PID"
    echo "Time: $(date)"
    echo ""
    ps -p $PID -o pid,user,%cpu,%mem,vsz,rss,etime,cmd
    echo ""
    echo "Press Ctrl+C to stop"
    sleep 5
done
echo "Process $PID has terminated"
EXAMPLE
echo ""

echo "SCENARIO 4: Find and kill zombie processes"
echo "-------------------------------------------"
cat << 'EXAMPLE'
#!/bin/bash
echo "Searching for zombie processes..."
ZOMBIES=$(ps aux | awk '$8=="Z" {print $2}')
if [ -z "$ZOMBIES" ]; then
    echo "No zombie processes found"
else
    echo "Zombie processes found:"
    ps aux | awk '$8=="Z" {print}'
    echo ""
    echo "Killing parent processes..."
    for zombie in $ZOMBIES; do
        PPID=$(ps -p $zombie -o ppid=)
        echo "Killing parent $PPID of zombie $zombie"
        kill -9 $PPID 2>/dev/null
    done
fi
EXAMPLE
echo ""

echo "SCENARIO 5: Limit CPU usage of a process"
echo "-----------------------------------------"
cat << 'EXAMPLE'
#!/bin/bash
# Using nice to start process with lower priority
nice -n 10 ./cpu_intensive_task.sh &

# Or renice an existing process
PID=$1
renice -n 10 -p $PID
echo "Process $PID nice value set to 10"
EXAMPLE
echo ""

# ===================================
# 9. PROCESS SIGNALS
# ===================================
echo "9. COMMON PROCESS SIGNALS"
echo "========================="
echo ""
echo "Signal  Number  Description"
echo "------  ------  -----------"
echo "SIGHUP    1     Hangup (reload configuration)"
echo "SIGINT    2     Interrupt (Ctrl+C)"
echo "SIGQUIT   3     Quit (Ctrl+\)"
echo "SIGKILL   9     Kill (cannot be caught)"
echo "SIGTERM  15     Terminate (graceful, default)"
echo "SIGSTOP  19     Stop process"
echo "SIGCONT  18     Continue stopped process"
echo ""
echo "Usage examples:"
echo "  kill -HUP <pid>   # Reload config"
echo "  kill -TERM <pid>  # Graceful shutdown"
echo "  kill -9 <pid>     # Force kill"
echo ""

# ===================================
# 10. SUMMARY
# ===================================
echo "=================================================="
echo "PROCESS MANAGEMENT SUMMARY"
echo "=================================================="
echo ""
echo "Key Commands:"
echo "  ps        - Display processes"
echo "  top/htop  - Interactive process viewer"
echo "  pgrep     - Find processes by name"
echo "  pkill     - Kill processes by name"
echo "  kill      - Send signal to process"
echo "  jobs      - List background jobs"
echo "  bg/fg     - Background/Foreground jobs"
echo "  nice      - Start process with priority"
echo "  renice    - Change priority of running process"
echo ""
echo "Best Practices:"
echo "  ✓ Use SIGTERM before SIGKILL"
echo "  ✓ Monitor resource usage regularly"
echo "  ✓ Clean up zombie processes"
echo "  ✓ Use appropriate priorities"
echo "  ✓ Document process dependencies"
echo ""

