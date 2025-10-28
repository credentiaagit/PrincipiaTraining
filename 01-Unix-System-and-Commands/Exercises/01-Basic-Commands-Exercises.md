# Unix Basic Commands - Exercises

## Instructions
- Try to solve each exercise before looking at the answer
- Practice on a Unix/Linux system
- Verify your results
- Understanding is more important than memorization

---

## Level 1: Basic Navigation and File Operations

### Exercise 1: Directory Navigation
**Task**: Write commands to:
1. Display your current directory
2. Go to your home directory
3. Create a directory called `practice`
4. Go into the `practice` directory
5. Go back to the parent directory
6. Remove the `practice` directory

**Answer**:
```bash
# 1. Display current directory
pwd

# 2. Go to home directory
cd ~
# or
cd

# 3. Create directory
mkdir practice

# 4. Go into practice directory
cd practice

# 5. Go back to parent
cd ..

# 6. Remove directory
rmdir practice
# or
rm -r practice
```

---

### Exercise 2: File Creation and Viewing
**Task**: 
1. Create three empty files: `file1.txt`, `file2.txt`, `file3.txt`
2. Add the text "Hello Unix" to `file1.txt`
3. Display the contents of `file1.txt`
4. Copy `file1.txt` to `file1_backup.txt`
5. List all files with details

**Answer**:
```bash
# 1. Create files
touch file1.txt file2.txt file3.txt

# 2. Add text to file1.txt
echo "Hello Unix" > file1.txt

# 3. Display contents
cat file1.txt

# 4. Copy file
cp file1.txt file1_backup.txt

# 5. List all files with details
ls -l
```

---

### Exercise 3: File Operations
**Task**:
1. Create a file called `original.txt` with the content "Original content"
2. Rename `original.txt` to `renamed.txt`
3. Create a directory called `backup`
4. Copy `renamed.txt` into the `backup` directory
5. Remove `renamed.txt` from current directory

**Answer**:
```bash
# 1. Create file with content
echo "Original content" > original.txt

# 2. Rename file
mv original.txt renamed.txt

# 3. Create directory
mkdir backup

# 4. Copy file to backup
cp renamed.txt backup/

# 5. Remove file from current directory
rm renamed.txt
```

---

## Level 2: Text Processing

### Exercise 4: Using grep
**Task**: Given a file `employees.txt`:
```
John:IT:50000
Mary:Finance:55000
Bob:IT:48000
Alice:HR:45000
Charlie:IT:52000
```

Write commands to:
1. Find all employees in IT department
2. Count how many employees are in IT
3. Find employees with salary > 50000 (assuming you can identify by line)
4. Find employees whose names start with 'A' or 'M'

**Answer**:
```bash
# Create the file first
cat > employees.txt << 'EOF'
John:IT:50000
Mary:Finance:55000
Bob:IT:48000
Alice:HR:45000
Charlie:IT:52000
EOF

# 1. Find all IT employees
grep "IT" employees.txt

# 2. Count IT employees
grep -c "IT" employees.txt

# 3. Find employees with salary > 50000
grep -E ":[0-9]{5}$" employees.txt | awk -F':' '$3 > 50000 {print}'

# 4. Names starting with A or M
grep -E "^(A|M)" employees.txt
```

---

### Exercise 5: Using awk
**Task**: Using the same `employees.txt` file:
1. Print only the names (first column)
2. Print name and salary
3. Calculate the average salary
4. Count employees per department

**Answer**:
```bash
# 1. Print only names
awk -F':' '{print $1}' employees.txt

# 2. Print name and salary
awk -F':' '{print $1, $3}' employees.txt

# 3. Average salary
awk -F':' '{sum+=$3; count++} END {print "Average:", sum/count}' employees.txt

# 4. Count per department
awk -F':' '{dept[$2]++} END {for(d in dept) print d":", dept[d]}' employees.txt
```

---

### Exercise 6: Using sed
**Task**: Given a file `data.txt` with content:
```
Hello World
Unix is powerful
Learn Linux commands
Practice makes perfect
```

Write commands to:
1. Replace "Unix" with "Linux"
2. Delete the line containing "Practice"
3. Print only lines 2 and 3
4. Add "Modified: " at the beginning of each line

**Answer**:
```bash
# Create the file
cat > data.txt << 'EOF'
Hello World
Unix is powerful
Learn Linux commands
Practice makes perfect
EOF

# 1. Replace Unix with Linux
sed 's/Unix/Linux/' data.txt

# 2. Delete line with Practice
sed '/Practice/d' data.txt

# 3. Print lines 2-3
sed -n '2,3p' data.txt

# 4. Add Modified: at beginning
sed 's/^/Modified: /' data.txt
```

---

## Level 3: Combining Commands

### Exercise 7: Pipes and Redirection
**Task**: Create a file `numbers.txt` with numbers 1-100 (one per line), then:
1. Count the lines
2. Display the first 10 numbers
3. Display the last 10 numbers
4. Find all numbers containing '5'
5. Sort numbers in reverse order and save to `sorted.txt`

**Answer**:
```bash
# Create numbers file
seq 1 100 > numbers.txt

# 1. Count lines
wc -l numbers.txt
# or
cat numbers.txt | wc -l

# 2. First 10 numbers
head -10 numbers.txt

# 3. Last 10 numbers
tail -10 numbers.txt

# 4. Numbers containing 5
grep "5" numbers.txt

# 5. Sort in reverse
sort -rn numbers.txt > sorted.txt
```

---

### Exercise 8: Complex Pipeline
**Task**: Given a log file with format `DATE TIME LEVEL MESSAGE`:
```
2024-10-28 09:15:23 INFO User logged in
2024-10-28 09:16:45 ERROR Connection failed
2024-10-28 09:17:12 INFO Data processed
2024-10-28 09:18:33 WARN Low memory
2024-10-28 09:19:01 ERROR Database timeout
```

Write a command to:
1. Count ERROR entries
2. Extract only ERROR messages
3. Count each log level
4. Find entries from 09:16 to 09:18

**Answer**:
```bash
# Create log file
cat > app.log << 'EOF'
2024-10-28 09:15:23 INFO User logged in
2024-10-28 09:16:45 ERROR Connection failed
2024-10-28 09:17:12 INFO Data processed
2024-10-28 09:18:33 WARN Low memory
2024-10-28 09:19:01 ERROR Database timeout
EOF

# 1. Count ERROR entries
grep -c "ERROR" app.log

# 2. Extract ERROR messages
grep "ERROR" app.log | awk '{for(i=4;i<=NF;i++) printf "%s ", $i; print ""}'

# 3. Count each log level
awk '{print $3}' app.log | sort | uniq -c

# 4. Entries from 09:16 to 09:18
awk '$2 >= "09:16:00" && $2 <= "09:18:59" {print}' app.log
```

---

## Level 4: File Permissions

### Exercise 9: Permission Management
**Task**:
1. Create a file `script.sh`
2. Check its current permissions
3. Make it executable by owner only
4. Change permissions to rwxr-xr-x (755)
5. Verify the changes

**Answer**:
```bash
# 1. Create file
touch script.sh

# 2. Check permissions
ls -l script.sh

# 3. Make executable by owner only
chmod u+x script.sh
# or
chmod 744 script.sh

# 4. Change to 755
chmod 755 script.sh
# or
chmod u=rwx,g=rx,o=rx script.sh

# 5. Verify
ls -l script.sh
```

---

### Exercise 10: Understanding Permissions
**Task**: What do these permission strings mean?
1. `-rw-r--r--`
2. `drwxr-xr-x`
3. `-rwxrwxrwx`
4. `-r--------`

**Answer**:
```
1. -rw-r--r--
   - Regular file
   - Owner: read, write
   - Group: read only
   - Others: read only
   - Numeric: 644

2. drwxr-xr-x
   - Directory
   - Owner: read, write, execute (enter directory)
   - Group: read, execute
   - Others: read, execute
   - Numeric: 755

3. -rwxrwxrwx
   - Regular file
   - Everyone: full permissions (read, write, execute)
   - Numeric: 777
   - WARNING: Security risk!

4. -r--------
   - Regular file
   - Owner: read only
   - Group: no permissions
   - Others: no permissions
   - Numeric: 400
```

---

## Level 5: Process Management

### Exercise 11: Process Commands
**Task**:
1. List all processes for your user
2. Find the process ID of your shell
3. Start a background process (sleep 100)
4. List background jobs
5. Kill the background process

**Answer**:
```bash
# 1. List user processes
ps -u $USER
# or
ps aux | grep $USER

# 2. Find shell PID
echo $$
# or
ps -p $$

# 3. Start background process
sleep 100 &

# 4. List jobs
jobs

# 5. Kill the process
# Method 1: Using job number
kill %1

# Method 2: Using PID
kill $(jobs -p)

# Method 3: Force kill
pkill -f "sleep 100"
```

---

### Exercise 12: Process Monitoring
**Task**: Write commands to:
1. Show top 5 CPU-consuming processes
2. Show top 5 memory-consuming processes
3. Count total processes running
4. Find all bash processes

**Answer**:
```bash
# 1. Top 5 CPU-consuming
ps aux --sort=-%cpu | head -6

# 2. Top 5 memory-consuming
ps aux --sort=-%mem | head -6

# 3. Count total processes
ps aux | wc -l
# or
ps -e | wc -l

# 4. Find bash processes
ps aux | grep bash | grep -v grep
# or
pgrep -a bash
```

---

## Level 6: Capital Markets Scenarios

### Exercise 13: Trade Data Analysis
**Task**: Given this trade file `trades.csv`:
```
TradeID,Symbol,Quantity,Price
T001,AAPL,100,175.50
T002,GOOGL,50,140.25
T003,AAPL,200,176.00
T004,MSFT,150,380.75
T005,GOOGL,75,141.00
```

Write commands to:
1. Calculate total value of all trades
2. Find total quantity for each symbol
3. Calculate average price for AAPL
4. Find the highest value trade

**Answer**:
```bash
# Create file
cat > trades.csv << 'EOF'
TradeID,Symbol,Quantity,Price
T001,AAPL,100,175.50
T002,GOOGL,50,140.25
T003,AAPL,200,176.00
T004,MSFT,150,380.75
T005,GOOGL,75,141.00
EOF

# 1. Total value of all trades
awk -F',' 'NR>1 {sum+=$3*$4} END {printf "Total Value: $%.2f\n", sum}' trades.csv

# 2. Total quantity per symbol
awk -F',' 'NR>1 {qty[$2]+=$3} END {for(s in qty) print s":", qty[s]}' trades.csv

# 3. Average price for AAPL
awk -F',' 'NR>1 && $2=="AAPL" {sum+=$4; count++} END {print "AAPL Avg:", sum/count}' trades.csv

# 4. Highest value trade
awk -F',' 'NR>1 {value=$3*$4; if(value>max) {max=value; line=$0}} 
    END {print "Highest:", line, "Value:", max}' trades.csv
```

---

### Exercise 14: Log Analysis
**Task**: Given a trading log file, write commands to:
1. Count total ERROR entries
2. Extract all unique error types
3. Find errors between 09:00 and 12:00
4. Generate error summary by hour

**Answer**:
```bash
# Create sample log
cat > trading.log << 'EOF'
2024-10-28 09:15:23 ERROR ConnectionTimeout Database unreachable
2024-10-28 10:16:45 ERROR InvalidData Invalid price format
2024-10-28 11:17:12 ERROR ConnectionTimeout Database unreachable
2024-10-28 13:18:33 ERROR MarginExceeded Insufficient margin
2024-10-28 14:19:01 ERROR ConnectionTimeout Database unreachable
EOF

# 1. Count ERROR entries
grep -c "ERROR" trading.log

# 2. Unique error types
awk '$3=="ERROR" {print $4}' trading.log | sort | uniq

# 3. Errors between 09:00 and 12:00
awk '$2 >= "09:00:00" && $2 < "12:00:00" && $3=="ERROR" {print}' trading.log

# 4. Error summary by hour
awk '$3=="ERROR" {hour=substr($2,1,2); count[hour]++} 
    END {for(h in count) print h":00 -", count[h], "errors"}' trading.log | sort
```

---

### Exercise 15: End-of-Day Processing
**Task**: Write a series of commands that:
1. Find all data files from today (*.csv)
2. Count lines in each file
3. Archive them into dated tar.gz file
4. Verify the archive was created
5. List archive contents

**Answer**:
```bash
# Create sample files
echo "data1" > data_$(date +%Y%m%d)_1.csv
echo -e "data2\nline2" > data_$(date +%Y%m%d)_2.csv
echo -e "data3\nline2\nline3" > data_$(date +%Y%m%d)_3.csv

# 1. Find today's data files
find . -name "*$(date +%Y%m%d)*.csv"

# 2. Count lines in each
for file in *$(date +%Y%m%d)*.csv; do
    echo "$file: $(wc -l < $file) lines"
done

# 3. Archive files
tar -czf data_$(date +%Y%m%d).tar.gz *$(date +%Y%m%d)*.csv

# 4. Verify archive exists
ls -lh data_$(date +%Y%m%d).tar.gz

# 5. List contents
tar -tzf data_$(date +%Y%m%d).tar.gz
```

---

## Bonus Challenges

### Exercise 16: One-Liner Challenge
**Task**: Write ONE command that:
- Finds all .log files in current directory
- Counts ERROR occurrences in each
- Sorts by error count (highest first)
- Shows top 3 files

**Answer**:
```bash
find . -name "*.log" -exec sh -c 'echo "$(grep -c ERROR "$1") $1"' _ {} \; | sort -rn | head -3
```

---

### Exercise 17: Data Validation
**Task**: Write commands to validate a CSV file:
1. Check if file has expected header
2. Count number of columns
3. Check for empty lines
4. Verify all prices are numeric

**Answer**:
```bash
FILE="data.csv"

# 1. Check header
EXPECTED="TradeID,Symbol,Quantity,Price"
ACTUAL=$(head -1 $FILE)
if [ "$ACTUAL" = "$EXPECTED" ]; then
    echo "✓ Header valid"
else
    echo "✗ Header invalid"
fi

# 2. Count columns
head -1 $FILE | awk -F',' '{print "Columns:", NF}'

# 3. Check for empty lines
if grep -q "^$" $FILE; then
    echo "✗ Empty lines found"
else
    echo "✓ No empty lines"
fi

# 4. Verify prices are numeric
awk -F',' 'NR>1 && $4 !~ /^[0-9]+\.?[0-9]*$/ {print "Invalid price at line", NR}' $FILE
```

---

## Practice Tips

1. **Type, Don't Copy**: Type each command to build muscle memory
2. **Experiment**: Modify commands to see what happens
3. **Use man pages**: `man command` for detailed information
4. **Practice Daily**: 30 minutes daily is better than 3 hours once a week
5. **Learn from Errors**: Error messages teach you a lot
6. **Build Gradually**: Master basics before moving to advanced
7. **Create Scenarios**: Practice with realistic data

---

## Next Steps

After completing these exercises:
1. ✓ Review any commands you struggled with
2. ✓ Practice combinations of commands (pipes)
3. ✓ Create your own scenarios based on work requirements
4. ✓ Move to Shell Scripting exercises
5. ✓ Study the sample programs in SamplePrograms directory

---

## Additional Resources

- Practice environment: Try https://www.webminal.org/
- Command reference: https://explainshell.com/
- Interactive learning: https://linuxjourney.com/

Good luck with your practice! 🚀

