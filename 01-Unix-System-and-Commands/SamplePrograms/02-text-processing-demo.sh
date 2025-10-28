#!/bin/bash
# 02-text-processing-demo.sh
# Demonstration of text processing commands: grep, sed, awk, sort, etc.

echo "=================================================="
echo "TEXT PROCESSING COMMANDS DEMONSTRATION"
echo "=================================================="
echo ""

# Create demo directory
DEMO_DIR="text_demo_$$"
mkdir -p $DEMO_DIR
cd $DEMO_DIR

# Create sample data files
echo "Creating sample data files..."
echo ""

# Create employee data file
cat > employees.csv << 'EOF'
ID,Name,Department,Salary,JoinDate
101,John Smith,IT,75000,2020-01-15
102,Mary Johnson,Finance,65000,2019-03-22
103,Bob Williams,IT,82000,2018-06-10
104,Alice Brown,HR,58000,2021-02-01
105,Charlie Davis,Finance,71000,2019-11-30
106,Diana Wilson,IT,79000,2020-08-15
107,Eve Martinez,HR,62000,2021-05-20
108,Frank Taylor,Finance,88000,2017-09-05
109,Grace Lee,IT,73000,2020-12-10
110,Henry Chen,HR,66000,2019-07-18
EOF

# Create transaction log
cat > transactions.log << 'EOF'
2024-10-28 09:15:23 INFO Transaction T001 completed successfully
2024-10-28 09:16:45 ERROR Transaction T002 failed - Connection timeout
2024-10-28 09:17:12 INFO Transaction T003 completed successfully
2024-10-28 09:18:33 WARN Transaction T004 delayed - High load
2024-10-28 09:19:01 INFO Transaction T005 completed successfully
2024-10-28 09:20:15 ERROR Transaction T006 failed - Invalid data
2024-10-28 09:21:47 INFO Transaction T007 completed successfully
2024-10-28 09:22:55 INFO Transaction T008 completed successfully
2024-10-28 09:23:18 WARN Transaction T009 delayed - Retry attempt
2024-10-28 09:24:02 ERROR Transaction T010 failed - Database error
EOF

echo "Sample files created:"
ls -l
echo ""

# ===================================
# 1. GREP DEMONSTRATIONS
# ===================================
echo "1. GREP - PATTERN SEARCHING"
echo "============================="
echo ""

echo "a) Find all IT employees:"
grep "IT" employees.csv
echo ""

echo "b) Case-insensitive search for 'finance':"
grep -i "finance" employees.csv
echo ""

echo "c) Count IT employees:"
grep -c "IT" employees.csv
echo ""

echo "d) Show line numbers:"
grep -n "Finance" employees.csv
echo ""

echo "e) Find all ERROR entries in log:"
grep "ERROR" transactions.log
echo ""

echo "f) Find ERROR or WARN:"
grep -E "ERROR|WARN" transactions.log
echo ""

echo "g) Show context (2 lines before and after):"
grep -C 2 "T006" transactions.log
echo ""

echo "h) Invert match (all non-INFO lines):"
grep -v "INFO" transactions.log
echo ""

# ===================================
# 2. SED DEMONSTRATIONS
# ===================================
echo "2. SED - STREAM EDITOR"
echo "======================="
echo ""

echo "a) Replace 'IT' with 'Technology':"
sed 's/IT/Technology/' employees.csv | head -5
echo ""

echo "b) Replace all commas with pipes:"
sed 's/,/|/g' employees.csv | head -5
echo ""

echo "c) Delete lines containing 'ERROR':"
sed '/ERROR/d' transactions.log
echo ""

echo "d) Print only lines 3-5:"
sed -n '3,5p' employees.csv
echo ""

echo "e) Add line numbers:"
sed = employees.csv | sed 'N;s/\n/ /'
echo ""

echo "f) Remove empty lines (if any):"
sed '/^$/d' employees.csv | head -3
echo ""

echo "g) Change date format:"
echo "2024-10-28" | sed 's/\([0-9]*\)-\([0-9]*\)-\([0-9]*\)/\3\/\2\/\1/'
echo ""

# ===================================
# 3. AWK DEMONSTRATIONS
# ===================================
echo "3. AWK - TEXT PROCESSING"
echo "========================="
echo ""

echo "a) Print names and salaries:"
awk -F',' 'NR>1 {print $2, $4}' employees.csv
echo ""

echo "b) Employees with salary > 70000:"
awk -F',' 'NR>1 && $4 > 70000 {print $2, $4}' employees.csv
echo ""

echo "c) Calculate average salary:"
awk -F',' 'NR>1 {sum+=$4; count++} END {print "Average:", sum/count}' employees.csv
echo ""

echo "d) Count employees by department:"
awk -F',' 'NR>1 {dept[$3]++} END {for(d in dept) print d":", dept[d]}' employees.csv
echo ""

echo "e) Total salary by department:"
awk -F',' 'NR>1 {dept[$3]+=$4} END {for(d in dept) print d":", dept[d]}' employees.csv
echo ""

echo "f) Format output:"
awk -F',' 'NR>1 {printf "%-15s %-10s $%d\n", $2, $3, $4}' employees.csv
echo ""

echo "g) Extract transaction IDs from log:"
awk '{print $5}' transactions.log
echo ""

echo "h) Count log entries by level:"
awk '{count[$3]++} END {for(level in count) print level":", count[level]}' transactions.log
echo ""

# ===================================
# 4. SORT DEMONSTRATIONS
# ===================================
echo "4. SORT - SORTING DATA"
echo "======================"
echo ""

echo "a) Sort employees by name (column 2):"
tail -n +2 employees.csv | sort -t',' -k2
echo ""

echo "b) Sort by salary (numeric, column 4):"
tail -n +2 employees.csv | sort -t',' -k4 -n
echo ""

echo "c) Sort by salary (reverse):"
tail -n +2 employees.csv | sort -t',' -k4 -nr
echo ""

echo "d) Sort by department, then salary:"
tail -n +2 employees.csv | sort -t',' -k3,3 -k4,4n
echo ""

# ===================================
# 5. UNIQ DEMONSTRATIONS
# ===================================
echo "5. UNIQ - FINDING UNIQUE VALUES"
echo "================================"
echo ""

echo "a) Unique departments:"
tail -n +2 employees.csv | cut -d',' -f3 | sort | uniq
echo ""

echo "b) Count employees per department:"
tail -n +2 employees.csv | cut -d',' -f3 | sort | uniq -c
echo ""

echo "c) Unique log levels:"
awk '{print $3}' transactions.log | sort | uniq
echo ""

# ===================================
# 6. CUT AND PASTE DEMONSTRATIONS
# ===================================
echo "6. CUT & PASTE - COLUMN EXTRACTION"
echo "===================================="
echo ""

echo "a) Extract names (column 2):"
cut -d',' -f2 employees.csv | head -5
echo ""

echo "b) Extract name and department:"
cut -d',' -f2,3 employees.csv | head -5
echo ""

echo "c) Extract characters 1-10 of each line:"
cut -c1-10 employees.csv | head -5
echo ""

# Create two files for paste demo
cut -d',' -f2 employees.csv > names.txt
cut -d',' -f4 employees.csv > salaries.txt

echo "d) Combine names and salaries with paste:"
paste -d':' names.txt salaries.txt | head -5
echo ""

# ===================================
# 7. TR DEMONSTRATIONS
# ===================================
echo "7. TR - CHARACTER TRANSLATION"
echo "=============================="
echo ""

echo "a) Convert to uppercase:"
echo "hello world" | tr 'a-z' 'A-Z'
echo ""

echo "b) Replace spaces with underscores:"
echo "Hello World From Unix" | tr ' ' '_'
echo ""

echo "c) Delete digits:"
echo "Employee123 has salary $75000" | tr -d '0-9'
echo ""

echo "d) Squeeze spaces:"
echo "Too     many    spaces" | tr -s ' '
echo ""

# ===================================
# 8. WC DEMONSTRATIONS
# ===================================
echo "8. WC - WORD COUNT"
echo "=================="
echo ""

echo "a) Count lines, words, characters:"
wc employees.csv
echo ""

echo "b) Count lines only:"
wc -l employees.csv
echo ""

echo "c) Count words only:"
wc -w employees.csv
echo ""

# ===================================
# 9. COMPLEX PIPELINES
# ===================================
echo "9. COMPLEX COMMAND PIPELINES"
echo "============================="
echo ""

echo "a) Top 3 earners:"
tail -n +2 employees.csv | sort -t',' -k4 -nr | head -3 | \
    awk -F',' '{printf "%-15s $%d\n", $2, $4}'
echo ""

echo "b) Average salary by department:"
tail -n +2 employees.csv | \
    awk -F',' '{sum[$3]+=$4; count[$3]++} 
    END {for(d in sum) printf "%-10s: $%.2f\n", d, sum[d]/count[d]}' | sort
echo ""

echo "c) Error summary from log:"
grep "ERROR" transactions.log | \
    awk '{for(i=6;i<=NF;i++) printf "%s ", $i; print ""}' | \
    sort | uniq -c | sort -rn
echo ""

echo "d) Transaction success rate:"
total=$(wc -l < transactions.log)
success=$(grep -c "INFO" transactions.log)
echo "Total: $total, Success: $success, Rate: $(awk "BEGIN {printf \"%.1f\", ($success/$total)*100}")%"
echo ""

# ===================================
# 10. PRACTICAL EXAMPLES
# ===================================
echo "10. PRACTICAL EXAMPLES"
echo "======================"
echo ""

# Generate sample trade data
cat > trades.csv << 'EOF'
TradeID,Symbol,Quantity,Price,Trader
T001,AAPL,100,175.50,John
T002,GOOGL,50,140.25,Mary
T003,AAPL,200,176.00,Bob
T004,MSFT,150,380.75,John
T005,GOOGL,75,141.00,Alice
T006,AAPL,120,175.75,Mary
T007,MSFT,100,381.25,Bob
T008,GOOGL,200,140.50,John
T009,AAPL,150,176.25,Alice
T010,MSFT,80,380.50,Mary
EOF

echo "Sample trades data:"
head -3 trades.csv
echo "..."
echo ""

echo "a) Total quantity by symbol:"
awk -F',' 'NR>1 {sym[$2]+=$3} END {for(s in sym) printf "%-6s: %d\n", s, sym[s]}' trades.csv | sort
echo ""

echo "b) Total value by trader:"
awk -F',' 'NR>1 {value=$3*$4; trader[$5]+=value} 
    END {for(t in trader) printf "%-8s: $%.2f\n", t, trader[t]}' trades.csv | sort
echo ""

echo "c) Trades above $20,000:"
awk -F',' 'NR>1 {value=$3*$4; if(value>20000) 
    printf "%-6s %-6s %d @ $%.2f = $%.2f\n", $1, $2, $3, $4, value}' trades.csv
echo ""

echo "d) Average price by symbol:"
awk -F',' 'NR>1 {sum[$2]+=$4; count[$2]++} 
    END {for(s in sum) printf "%-6s: $%.2f\n", s, sum[s]/count[s]}' trades.csv | sort
echo ""

# Cleanup note
echo ""
echo "=================================================="
echo "TEXT PROCESSING DEMONSTRATION COMPLETE"
echo "=================================================="
echo ""
echo "Demo directory: $(pwd)"
echo "To clean up: cd .. && rm -rf $DEMO_DIR"
echo ""
echo "Key Commands Demonstrated:"
echo "  - grep: Pattern searching"
echo "  - sed: Stream editing"
echo "  - awk: Text processing and calculations"
echo "  - sort/uniq: Sorting and uniqueness"
echo "  - cut/paste: Column operations"
echo "  - tr: Character translation"
echo "  - wc: Counting"
echo "  - Pipelines: Combining commands"

