# Unix Sample Programs

## Overview
This directory contains executable shell scripts demonstrating various Unix commands and concepts covered in the Theory section.

---

## Available Sample Programs

### 1. Basic Commands Demo (`01-basic-commands-demo.sh`)
**Topics Covered:**
- Navigation (pwd, cd)
- File operations (mkdir, touch, cp, mv, rm)
- Viewing files (cat, head, tail)
- File information (wc, file)
- Searching (grep, find)
- Permissions (chmod)
- Compression (tar)

**How to Run:**
```bash
bash 01-basic-commands-demo.sh
```

---

### 2. Text Processing Demo (`02-text-processing-demo.sh`)
**Topics Covered:**
- grep - Pattern searching
- sed - Stream editing
- awk - Text processing and calculations
- sort/uniq - Sorting and finding unique values
- cut/paste - Column operations
- tr - Character translation
- wc - Word/line counting
- Complex pipelines

**How to Run:**
```bash
bash 02-text-processing-demo.sh
```

---

### 3. Process Management Demo (`03-process-management-demo.sh`)
**Topics Covered:**
- Viewing processes (ps, top)
- Background processes
- Process control (kill, jobs, bg, fg)
- Process monitoring
- Signals
- Practical scenarios

**How to Run:**
```bash
bash 03-process-management-demo.sh
```

---

### 4. Capital Markets Examples (`04-capital-markets-examples.sh`)
**Topics Covered:**
- Market data file processing
- Trade processing and analysis
- Position calculation
- Log file analysis
- Trade reconciliation
- Report generation
- Data archival
- File cleanup

**How to Run:**
```bash
bash 04-capital-markets-examples.sh
```

---

## Making Scripts Executable

If you want to run scripts directly without `bash` prefix:

```bash
# Make executable
chmod +x *.sh

# Run directly
./01-basic-commands-demo.sh
```

---

## Learning Approach

1. **Read First**: Read the corresponding Theory document
2. **Study Code**: Open and read the script before running
3. **Run Script**: Execute and observe the output
4. **Experiment**: Modify the script to try variations
5. **Practice**: Try to recreate sections from memory

---

## Script Structure

Each script follows this structure:
```bash
#!/bin/bash
# Script name and description
# Comments explaining each section

# Section 1: Topic Name
# Demonstration code with explanations

# Section 2: Next Topic
# More demonstrations

# Summary at the end
```

---

## Cleanup

Some scripts create temporary directories. Look for cleanup instructions at the end of each script output.

Example:
```bash
cd .. && rm -rf demo_directory_name
```

---

## Troubleshooting

**Issue: Permission denied**
```bash
chmod +x script-name.sh
```

**Issue: Command not found**
```bash
bash script-name.sh
```

**Issue: Script modifies system**
- These scripts create temporary demo directories
- They don't modify system files
- Always read scripts before running in production

---

## Next Steps

After running all sample programs:
1. Work through the exercises in the Exercises directory
2. Try to modify scripts for different scenarios
3. Create your own scripts based on project requirements
4. Move to Shell Scripting section

---

## Quick Reference

| Script | Focus Area | Time to Run |
|--------|-----------|-------------|
| 01-basic-commands-demo.sh | File operations | 2-3 min |
| 02-text-processing-demo.sh | Text processing | 3-4 min |
| 03-process-management-demo.sh | Processes | 2-3 min |
| 04-capital-markets-examples.sh | Real scenarios | 3-5 min |

---

**Happy Learning!** 🚀

