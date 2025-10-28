# 🚀 Quick Start Guide

## Welcome, New Graduate!

This guide will get you started with the training in the next 5 minutes.

---

## ✅ Day 1 Checklist

### 1. Read These Files (30 minutes)
```
□ README.md                          (Project overview)
□ 00-LEARNING-PATH-GUIDE.md          (16-week roadmap)
□ This file (QUICK-START.md)
```

### 2. Set Up Your Workspace (15 minutes)
```bash
# Open terminal and navigate to training directory
cd ~/Documents/PrincipiaTraining

# Create practice directory
mkdir -p ~/practice/week1

# Set up alias for quick access
echo "alias training='cd ~/Documents/PrincipiaTraining'" >> ~/.bashrc
source ~/.bashrc
```

### 3. Test Your Environment (10 minutes)
```bash
# Test Unix commands
whoami
pwd
ls -la
date

# Test if TCL is installed
tclsh
# Type: puts "Hello TCL"
# Type: exit

# Test if you have a database client
mysql --version
# or
psql --version
```

### 4. Run Your First Example (15 minutes)
```bash
# Go to Unix samples
cd 01-Unix-System-and-Commands/SamplePrograms

# Make script executable
chmod +x 01-basic-commands-demo.sh

# Run it
./01-basic-commands-demo.sh
```

---

## 📅 Week 1 Plan

### Monday
- **Morning**: Read `01-Basic-Unix-Concepts.md`
- **Afternoon**: Practice basic commands (pwd, ls, cd, cat)
- **Exercise**: First 10 exercises from `01-Basic-Commands-Exercises.md`

### Tuesday
- **Morning**: Read `02-Navigation-and-File-Operations.md`
- **Afternoon**: Run `01-basic-commands-demo.sh`, modify it
- **Exercise**: Exercises 11-20

### Wednesday
- **Morning**: Review Monday & Tuesday topics
- **Afternoon**: Create your own scripts
- **Exercise**: Exercises 21-30

### Thursday
- **Morning**: Read `03-Text-Processing-and-Filters.md`
- **Afternoon**: Learn grep, sed, awk
- **Exercise**: Practice text processing exercises

### Friday
- **Morning**: Review entire week
- **Afternoon**: Run all sample programs
- **Exercise**: Weekly assessment quiz

---

## 🎯 First Hour Goals

### Learn These Commands
```bash
pwd              # Where am I?
ls               # What's here?
ls -la           # Detailed listing
cd directory     # Go somewhere
cd ..            # Go up one level
cat file.txt     # View file
less file.txt    # Page through file
grep "text" file # Search in file
man command      # Get help
```

### Create Your First Script
```bash
# Create file
nano myscript.sh

# Add these lines:
#!/bin/bash
echo "Hello, I'm learning Unix!"
echo "Current directory: $(pwd)"
echo "Today is: $(date)"
ls -lh

# Save (Ctrl+O, Enter, Ctrl+X)

# Make executable
chmod +x myscript.sh

# Run it
./myscript.sh
```

---

## 📖 Recommended Reading Order

### Week 1-2: Unix Foundation
1. `01-Unix-System-and-Commands/Theory/01-Basic-Unix-Concepts.md`
2. `01-Unix-System-and-Commands/Theory/02-Navigation-and-File-Operations.md`
3. `01-Unix-System-and-Commands/SamplePrograms/README.md`
4. Run all sample programs
5. Complete exercises 1-30

### Week 3-4: Text Processing
1. `01-Unix-System-and-Commands/Theory/03-Text-Processing-and-Filters.md`
2. `01-Unix-System-and-Commands/Theory/04-Advanced-Unix-Commands.md`
3. Practice with sample data
4. Complete remaining exercises

---

## 💡 Tips for Success

### DO ✅
- Type every command yourself (no copy-paste)
- Make mistakes and learn from errors
- Ask questions immediately when stuck
- Create personal notes and cheat sheets
- Practice daily, even for 30 minutes
- Relate concepts to real project work

### DON'T ❌
- Skip the basics to jump ahead
- Just read without practicing
- Memorize without understanding
- Wait too long to ask questions
- Compare your pace with others
- Give up when things get hard

---

## 🆘 Getting Help

### When Stuck on a Concept
1. Re-read the theory document
2. Look at the sample program
3. Check the exercise solution
4. Search online: "Unix [your question]"
5. Ask your mentor with specific question

### When Stuck on an Error
1. Read the error message carefully
2. Check your syntax
3. Look for typos
4. Compare with working example
5. Ask mentor with: error message + what you tried

### Good Question Format
```
I'm trying to: [what you want to do]
I ran this command: [your command]
I expected: [expected result]
But I got: [actual result/error]
I already tried: [what you attempted]
```

---

## 📝 Daily Learning Template

Create a file: `~/learning_log.md`

```markdown
# My Learning Log

## Week 1, Day 1 - Oct 28, 2024

### What I Learned
- Basic Unix commands (pwd, ls, cd)
- File system hierarchy
- How to read man pages

### Commands I Practiced
- pwd
- ls -la
- cd /etc
- man ls
- grep "text" file.txt

### Exercises Completed
- Exercises 1-10 from Basic Commands

### Questions/Doubts
- What's the difference between relative and absolute paths?
- When should I use cat vs less?

### Tomorrow's Goal
- Learn file operations (cp, mv, rm)
- Complete exercises 11-20
- Practice text editing with vi
```

---

## 🎓 Week 1 Cheat Sheet

### Essential Commands
```bash
# Navigation
pwd                     # Print working directory
cd /path/to/dir        # Change directory
cd ~                    # Go home
cd ..                   # Go up one level
cd -                    # Go to previous directory

# Listing Files
ls                      # List files
ls -l                   # Long format
ls -la                  # Include hidden files
ls -lh                  # Human readable sizes
ls -ltr                 # Sort by time, reverse

# File Operations
cp source dest          # Copy file
mv source dest          # Move/rename file
rm file                 # Remove file
mkdir dirname           # Make directory
rmdir dirname           # Remove empty directory
rm -r dirname           # Remove directory and contents

# Viewing Files
cat file                # Display file
less file               # Page through file
head file               # First 10 lines
tail file               # Last 10 lines
tail -f file            # Follow file (logs)

# Searching
grep "text" file        # Search in file
grep -r "text" dir/     # Search recursively
find . -name "*.txt"    # Find files

# Help
man command             # Manual page
command --help          # Quick help
```

---

## 🏆 Success Metrics

### End of Week 1, You Should Be Able To:
□ Navigate the file system confidently  
□ Create, move, copy, and delete files  
□ View and search file contents  
□ Understand file permissions basics  
□ Read and understand simple shell scripts  
□ Complete 30+ Unix exercises  
□ Feel comfortable with the command line  

### Red Flags (Talk to Mentor If...)
- Spending > 2 hours stuck on one concept
- Not understanding basics after practice
- Feeling completely lost
- Not making progress on exercises
- Afraid to ask questions

---

## 📞 Your Support Network

### Daily Support
- **Mentor**: [Name] - Schedule: [Time]
- **Buddy**: [Fellow trainee] - Peer learning
- **Team Chat**: [Channel name] - Quick questions

### Weekly Checkpoint
- **Training Coordinator**: [Name]
- **1:1 Review**: Every Friday
- **Group Session**: [Day and time]

### Resources
- **Documentation**: This repository
- **Online Help**: Man pages, Stack Overflow
- **Reference Books**: Listed in README.md

---

## 🎯 This Week's Goal

**By Friday, you will:**
- Be comfortable with basic Unix commands
- Understand the file system
- Create simple shell scripts
- Complete 40+ exercises
- Run and modify sample programs
- Feel confident navigating the terminal

**Your Assignment:**
1. Complete Week 1 readings
2. Run all Unix sample programs
3. Solve exercises 1-40
4. Create your learning log
5. Schedule Week 2 planning with mentor

---

## 🚀 Ready to Begin?

### Right Now:
1. Open `README.md` - Get the big picture
2. Open `00-LEARNING-PATH-GUIDE.md` - See your 16-week journey
3. Open `01-Unix-System-and-Commands/Theory/01-Basic-Unix-Concepts.md`
4. Start learning!

### Remember:
> "The expert in anything was once a beginner."  
> "Every professional was once an amateur."  
> "You don't have to be great to start, but you have to start to be great."

---

## 📊 Track Your Progress

```markdown
# Week 1 Progress Tracker

Day 1: □□□□□ (5 hours)
Day 2: □□□□□
Day 3: □□□□□
Day 4: □□□□□
Day 5: □□□□□

Total: 0/25 hours completed
Exercises: 0/40 completed
Confidence: ⭐☆☆☆☆
```

---

**You've got this! Welcome to the team, and happy learning!** 🎉

**Next Step**: Open `README.md` and start your journey!

---

*Last Updated: October 28, 2024*  
*Questions? Check README.md for contact information*

