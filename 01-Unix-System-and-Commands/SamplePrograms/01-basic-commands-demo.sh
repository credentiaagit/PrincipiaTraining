#!/bin/bash
# 01-basic-commands-demo.sh
# Demonstration of basic Unix commands
# This script demonstrates navigation, file operations, and basic commands

echo "=================================================="
echo "UNIX BASIC COMMANDS DEMONSTRATION"
echo "=================================================="
echo ""

# 1. NAVIGATION COMMANDS
echo "1. NAVIGATION COMMANDS"
echo "----------------------"
echo "Current directory:"
pwd
echo ""

echo "Home directory:"
echo $HOME
echo ""

echo "Listing files in current directory:"
ls
echo ""

echo "Detailed listing:"
ls -l
echo ""

echo "Listing with human-readable sizes:"
ls -lh
echo ""

# 2. FILE OPERATIONS
echo "2. FILE OPERATIONS"
echo "------------------"

# Create directory for demo
DEMO_DIR="unix_demo_$$"
mkdir -p $DEMO_DIR
cd $DEMO_DIR

echo "Created demo directory: $DEMO_DIR"
pwd
echo ""

# Create files
echo "Creating sample files..."
touch file1.txt file2.txt file3.txt
echo "Files created:"
ls -l
echo ""

# Add content to files
echo "Adding content to files..."
echo "This is file 1" > file1.txt
echo "This is file 2" > file2.txt
echo "This is file 3" > file3.txt

echo "Displaying file1.txt:"
cat file1.txt
echo ""

# Copy files
echo "Copying file1.txt to file1_backup.txt:"
cp file1.txt file1_backup.txt
ls -l file1*
echo ""

# Move/rename files
echo "Renaming file2.txt to file2_renamed.txt:"
mv file2.txt file2_renamed.txt
ls -l file2*
echo ""

# Create subdirectory
echo "Creating subdirectory:"
mkdir -p subdir/nested
ls -lR
echo ""

# 3. VIEWING FILE CONTENTS
echo "3. VIEWING FILE CONTENTS"
echo "------------------------"

# Create a larger file for demonstration
echo "Creating a multi-line file..."
cat > sample.txt << 'EOF'
Line 1: Unix is powerful
Line 2: Commands are essential
Line 3: Practice makes perfect
Line 4: Keep learning
Line 5: Master the basics
Line 6: Advanced topics await
Line 7: Shell scripting is fun
Line 8: Automation saves time
Line 9: Never stop exploring
Line 10: You can do this!
EOF

echo "File created. First 3 lines:"
head -3 sample.txt
echo ""

echo "Last 3 lines:"
tail -3 sample.txt
echo ""

echo "Lines 2-4:"
sed -n '2,4p' sample.txt
echo ""

# 4. FILE INFORMATION
echo "4. FILE INFORMATION"
echo "-------------------"
echo "File statistics:"
wc sample.txt
echo "  Lines | Words | Characters"
echo ""

echo "Line count only:"
wc -l sample.txt
echo ""

echo "File type:"
file sample.txt
echo ""

# 5. SEARCHING
echo "5. SEARCHING"
echo "------------"
echo "Search for 'Unix' in sample.txt:"
grep "Unix" sample.txt
echo ""

echo "Case-insensitive search for 'FUN':"
grep -i "fun" sample.txt
echo ""

echo "Lines containing 'learning' or 'exploring':"
grep -E "learning|exploring" sample.txt
echo ""

# 6. PERMISSIONS
echo "6. PERMISSIONS"
echo "--------------"
echo "Current permissions:"
ls -l sample.txt
echo ""

echo "Changing permissions to rw-r--r-- (644):"
chmod 644 sample.txt
ls -l sample.txt
echo ""

echo "Making file executable:"
chmod +x sample.txt
ls -l sample.txt
echo ""

# 7. FINDING FILES
echo "7. FINDING FILES"
echo "----------------"
echo "Finding all .txt files:"
find . -name "*.txt"
echo ""

echo "Finding files modified in last 5 minutes:"
find . -mmin -5 -type f
echo ""

# 8. COMPRESSION
echo "8. COMPRESSION"
echo "--------------"
echo "Creating tar archive:"
tar -czf demo_archive.tar.gz *.txt
ls -lh demo_archive.tar.gz
echo ""

# Cleanup note
echo ""
echo "=================================================="
echo "DEMONSTRATION COMPLETE"
echo "=================================================="
echo ""
echo "Demo directory created: $(pwd)"
echo "To clean up, run: cd .. && rm -rf $DEMO_DIR"
echo ""
echo "Key Commands Demonstrated:"
echo "  - pwd, ls, cd"
echo "  - mkdir, touch, cat, echo"
echo "  - cp, mv, rm"
echo "  - head, tail, wc"
echo "  - grep, find"
echo "  - chmod, tar"

