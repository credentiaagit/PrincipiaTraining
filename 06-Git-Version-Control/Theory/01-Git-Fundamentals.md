# Git Fundamentals and Version Control

## Table of Contents
1. [Introduction to Version Control](#introduction-to-version-control)
2. [What is Git?](#what-is-git)
3. [Git Basics](#git-basics)
4. [Git Workflow](#git-workflow)
5. [Working with Repositories](#working-with-repositories)
6. [Git in Capital Markets](#git-in-capital-markets)

---

## Introduction to Version Control

### What is Version Control?

Version Control Systems (VCS) track changes to files over time, allowing you to:
- Recall specific versions of files
- See who modified what and when
- Revert files or entire projects to previous states
- Compare changes over time
- Recover from mistakes

### Why Version Control?

**For Individual Developers:**
- Track your own changes
- Experiment safely with branches
- Revert mistakes easily
- Document your work history

**For Teams:**
- Collaborate without conflicts
- Review code before merging
- Maintain project history
- Work on features in parallel
- Deploy with confidence

### Types of Version Control

1. **Local VCS**: Changes stored on local machine (simple, not collaborative)
2. **Centralized VCS** (CVS, SVN): Single server, all clients check out from there
3. **Distributed VCS** (Git, Mercurial): Every client has full repository history

---

## What is Git?

### Overview

Git is a **distributed version control system** created by Linus Torvalds in 2005 for Linux kernel development.

### Key Characteristics

**Distributed:**
- Every developer has complete repository copy
- Work offline, sync later
- Multiple backup points
- No single point of failure

**Fast:**
- Most operations are local
- Branching and merging are quick
- Optimized for performance

**Data Integrity:**
- Everything is checksummed (SHA-1 hash)
- Impossible to change history without detection
- Data corruption is detected immediately

**Branching Model:**
- Lightweight branches
- Easy to create, merge, and delete
- Encourages experimentation

---

## Git Basics

### The Three States

Git has three main states for your files:

1. **Modified**: Changed but not committed to database
2. **Staged**: Marked modified file to go into next commit
3. **Committed**: Data safely stored in local database

```
Working Directory  →  Staging Area  →  Git Repository
     (Modified)         (Staged)        (Committed)
```

### The Basic Workflow

```
1. Modify files in working directory
2. Stage files (git add)
3. Commit changes (git commit)
4. Push to remote (git push)
```

### Git Areas

```
┌─────────────────┐
│ Remote Repo     │ ← Push/Pull
│ (GitHub/GitLab) │
└────────┬────────┘
         │
┌────────▼────────┐
│ Local Repo      │ ← Commit
│ (.git directory)│
└────────┬────────┘
         │
┌────────▼────────┐
│ Staging Area    │ ← Add
│ (Index)         │
└────────┬────────┘
         │
┌────────▼────────┐
│ Working Dir     │ ← Edit
│ (Your files)    │
└─────────────────┘
```

---

## Initial Setup

### Installing Git

```bash
# Check if Git is installed
git --version

# Install on Ubuntu/Debian
sudo apt-get install git

# Install on macOS (with Homebrew)
brew install git

# Install on Windows
# Download from git-scm.com
```

### First-Time Configuration

```bash
# Set your identity (REQUIRED)
git config --global user.name "Your Name"
git config --global user.email "your.email@company.com"

# Set default editor
git config --global core.editor "vim"
git config --global core.editor "code --wait"  # VS Code

# Set default branch name
git config --global init.defaultBranch main

# View all settings
git config --list

# View specific setting
git config user.name
```

### Configuration Levels

```bash
# System level (all users)
git config --system

# Global level (your user)
git config --global

# Local level (current repository)
git config --local
```

---

## Creating Repositories

### Initialize New Repository

```bash
# Create new directory and initialize
mkdir my-project
cd my-project
git init

# Initialize with specific branch name
git init --initial-branch=main
```

### Clone Existing Repository

```bash
# Clone from URL
git clone https://github.com/user/repo.git

# Clone to specific directory
git clone https://github.com/user/repo.git my-folder

# Clone specific branch
git clone -b develop https://github.com/user/repo.git

# Clone with depth (shallow clone)
git clone --depth 1 https://github.com/user/repo.git
```

---

## Basic Commands

### Checking Status

```bash
# See status of working directory
git status

# Short status
git status -s
# Output:
#  M modified.txt    (modified, not staged)
# M  staged.txt      (staged)
# ?? new.txt         (untracked)
```

### Adding Files

```bash
# Add specific file
git add filename.txt

# Add multiple files
git add file1.txt file2.txt

# Add all files in directory
git add .

# Add all modified and new files
git add -A

# Add with pattern
git add *.txt

# Interactive staging
git add -i

# Add parts of files
git add -p
```

### Committing Changes

```bash
# Commit with message
git commit -m "Add feature X"

# Commit with multi-line message
git commit -m "Title" -m "Description"

# Commit and add modified files
git commit -am "Update existing files"

# Open editor for commit message
git commit

# Amend last commit
git commit --amend

# Amend without changing message
git commit --amend --no-edit
```

### Viewing History

```bash
# View commit history
git log

# One line per commit
git log --oneline

# Show last N commits
git log -5

# Show commits with diff
git log -p

# Show statistics
git log --stat

# Graphical representation
git log --graph --oneline --all

# Pretty format
git log --pretty=format:"%h - %an, %ar : %s"

# Filter by author
git log --author="John"

# Filter by date
git log --since="2 weeks ago"
git log --after="2024-01-01"

# Filter by commit message
git log --grep="bug fix"
```

### Viewing Changes

```bash
# Show unstaged changes
git diff

# Show staged changes
git diff --staged
git diff --cached

# Compare with specific commit
git diff HEAD~1

# Compare two commits
git diff commit1 commit2

# Show changes in specific file
git diff filename.txt

# Word-level diff
git diff --word-diff
```

---

## Undoing Changes

### Unstaging Files

```bash
# Unstage file (keep changes)
git reset HEAD filename.txt

# Unstage all files
git reset HEAD

# Git 2.23+: use restore
git restore --staged filename.txt
```

### Discarding Changes

```bash
# Discard changes in working directory
git checkout -- filename.txt

# Git 2.23+: use restore
git restore filename.txt

# Discard all changes
git checkout -- .
git restore .
```

### Reverting Commits

```bash
# Create new commit that undoes changes
git revert HEAD

# Revert specific commit
git revert commit-hash

# Revert without committing
git revert --no-commit HEAD
```

### Resetting Commits

```bash
# Soft reset (keep changes staged)
git reset --soft HEAD~1

# Mixed reset (keep changes unstaged) - DEFAULT
git reset HEAD~1

# Hard reset (discard all changes) - DANGEROUS
git reset --hard HEAD~1

# Reset to specific commit
git reset --hard commit-hash
```

**⚠️ Warning**: `git reset --hard` permanently discards changes!

---

## Working with Remotes

### Viewing Remotes

```bash
# List remote repositories
git remote

# Show remote URLs
git remote -v

# Show detailed info
git remote show origin
```

### Adding Remotes

```bash
# Add remote repository
git remote add origin https://github.com/user/repo.git

# Add with SSH
git remote add origin git@github.com:user/repo.git
```

### Fetching and Pulling

```bash
# Fetch changes (don't merge)
git fetch origin

# Fetch all remotes
git fetch --all

# Pull changes (fetch + merge)
git pull origin main

# Pull with rebase
git pull --rebase origin main
```

### Pushing Changes

```bash
# Push to remote
git push origin main

# Push all branches
git push --all origin

# Push with tags
git push --tags

# Force push (use carefully!)
git push --force origin main

# Set upstream branch
git push -u origin main
```

---

## Ignoring Files

### .gitignore File

Create `.gitignore` in repository root:

```gitignore
# Comments start with #

# Ignore specific file
secret.txt

# Ignore all files with extension
*.log
*.tmp

# Ignore directory
temp/
build/

# Ignore in subdirectories
**/logs/

# Negate pattern (track this file)
!important.log

# Ignore files in root only
/TODO.txt

# Ignore all files in any directory named temp
temp/
```

### Common Patterns

```gitignore
# Compiled source
*.class
*.dll
*.exe
*.o
*.so

# Packages
*.jar
*.war
*.tar.gz
*.zip

# Logs and databases
*.log
*.sql
*.sqlite

# OS generated files
.DS_Store
Thumbs.db

# IDE files
.vscode/
.idea/
*.swp

# Dependencies
node_modules/
vendor/

# Build outputs
build/
dist/
out/
```

### Checking Ignored Files

```bash
# Check if file is ignored
git check-ignore filename.txt

# Show which rule ignores file
git check-ignore -v filename.txt

# List all ignored files
git status --ignored
```

---

## Git Workflow

### Feature Branch Workflow

```bash
# 1. Update main branch
git checkout main
git pull origin main

# 2. Create feature branch
git checkout -b feature/new-feature

# 3. Work on feature
git add .
git commit -m "Implement feature"

# 4. Push feature branch
git push -u origin feature/new-feature

# 5. Create Pull Request (on GitHub/GitLab)

# 6. After merge, cleanup
git checkout main
git pull origin main
git branch -d feature/new-feature
```

### Gitflow Workflow

```
main (production)
  │
  ├── develop (integration)
  │     │
  │     ├── feature/feature-1
  │     ├── feature/feature-2
  │     └── feature/feature-3
  │
  ├── release/v1.0
  │
  └── hotfix/critical-bug
```

---

## Capital Markets Use Case

### Scenario: Trading System Development

**Repository Structure:**
```
trading-system/
├── .git/
├── .gitignore
├── README.md
├── src/
│   ├── tcl/          # TCL scripts
│   ├── shell/        # Shell scripts
│   └── sql/          # SQL queries
├── config/
│   ├── dev/          # Development configs
│   ├── uat/          # UAT configs
│   └── prod/         # Production configs (separate repo)
├── docs/
└── tests/
```

**Typical Workflow:**

```bash
# 1. Developer starts new feature
git checkout develop
git pull origin develop
git checkout -b feature/add-risk-validation

# 2. Develop the feature
# Edit src/tcl/risk_validator.tcl
git add src/tcl/risk_validator.tcl
git commit -m "Add risk validation for trade processing"

# 3. Push for code review
git push -u origin feature/add-risk-validation

# 4. After code review and approval
git checkout develop
git pull origin develop
git merge feature/add-risk-validation

# 5. Deploy to UAT
git checkout release/v2.1
git merge develop
git push origin release/v2.1

# 6. After UAT approval, deploy to production
git checkout main
git merge release/v2.1
git tag -a v2.1.0 -m "Release version 2.1.0"
git push origin main --tags
```

**Hotfix Example:**

```bash
# Critical bug in production
git checkout main
git checkout -b hotfix/fix-price-calculation

# Fix the bug
git add src/tcl/price_calculator.tcl
git commit -m "Fix price calculation rounding error"

# Merge to main
git checkout main
git merge hotfix/fix-price-calculation
git tag -a v2.1.1 -m "Hotfix: price calculation"

# Also merge to develop
git checkout develop
git merge hotfix/fix-price-calculation

# Push everything
git push origin main develop --tags
```

---

## Best Practices

### Commit Messages

**Good commit messages:**
```
Add trade validation for EUR currency

- Implement EUR-specific validation rules
- Add unit tests for EUR trades
- Update documentation
```

**Format:**
- First line: Short summary (50 chars or less)
- Blank line
- Detailed explanation (wrap at 72 chars)

**Conventional Commits:**
```
feat: add new feature
fix: bug fix
docs: documentation changes
style: formatting changes
refactor: code refactoring
test: adding tests
chore: maintenance tasks
```

### What to Commit

**✅ DO Commit:**
- Source code
- Configuration templates
- Documentation
- Build scripts
- Tests

**❌ DON'T Commit:**
- Passwords or secrets
- Generated files (binaries, builds)
- Large binary files
- IDE-specific settings
- Temporary files
- Log files

### When to Commit

✅ Commit often with logical changes
✅ One feature/fix per commit
✅ Test before committing
✅ Write meaningful commit messages

❌ Don't commit broken code
❌ Don't commit work-in-progress to main
❌ Don't commit sensitive data

---

## Quick Command Reference

| Command | Purpose |
|---------|---------|
| `git init` | Create new repository |
| `git clone <url>` | Clone repository |
| `git status` | Check status |
| `git add <file>` | Stage changes |
| `git commit -m "msg"` | Commit changes |
| `git push` | Push to remote |
| `git pull` | Pull from remote |
| `git log` | View history |
| `git diff` | Show changes |
| `git branch` | List branches |
| `git checkout <branch>` | Switch branch |
| `git merge <branch>` | Merge branch |

---

## Reference Links

### 📚 Theory & Learning Resources

1. **Official Documentation**:
   - [Git Official Website](https://git-scm.com/) - Main resource hub ⭐
   - [Git Documentation](https://git-scm.com/doc) - Complete reference
   - [Pro Git Book](https://git-scm.com/book/en/v2) - FREE comprehensive book ⭐⭐⭐
   - [Git Reference Manual](https://git-scm.com/docs) - Command reference

2. **Interactive Tutorials**:
   - [Learn Git Branching](https://learngitbranching.js.org/) - Visual interactive tutorial ⭐⭐⭐
   - [GitHub Skills](https://skills.github.com/) - Hands-on GitHub learning
   - [Git Immersion](https://gitimmersion.com/) - Step-by-step lab tutorial
   - [Visualizing Git](https://git-school.github.io/visualizing-git/) - See Git in action

3. **Video Learning**:
   - [Git Tutorial - freeCodeCamp](https://www.youtube.com/watch?v=RGOj5yH7evk) - 1-hour course
   - [Git & GitHub Crash Course](https://www.youtube.com/watch?v=SWYqp7iY_Tc) - Traversy Media
   - [LinkedIn Learning - Git Essential Training](https://www.linkedin.com/learning/git-essential-training-the-basics)

4. **Best Practices & Guides**:
   - [Git Best Practices](https://git-scm.com/book/en/v2/Distributed-Git-Contributing-to-a-Project)
   - [Conventional Commits](https://www.conventionalcommits.org/) - Commit message standard
   - [Git Flow](https://nvie.com/posts/a-successful-git-branching-model/) - Branching model
   - [GitHub Flow](https://githubflow.github.io/) - Simplified workflow

### 🎮 Hands-On Practice Resources

1. **Interactive Practice**:
   - [Learn Git Branching](https://learngitbranching.js.org/) - THE BEST interactive tutorial ⭐⭐⭐
   - [Katacoda Git Scenarios](https://www.katacoda.com/courses/git) - Hands-on scenarios
   - [Git Exercises](https://gitexercises.fracz.com/) - Practice Git commands
   - [Oh My Git!](https://ohmygit.org/) - Learn Git through a game

2. **Challenge Sites**:
   - [GitHub Learning Lab](https://lab.github.com/) - Interactive courses
   - [Git Gud](https://nic-hartley.github.io/git-gud/) - Git learning game
   - [Githug](https://github.com/Gazler/githug) - Command-line game to learn Git

3. **Online Git Environments**:
   - [GitHub Codespaces](https://github.com/features/codespaces) - Cloud development
   - [GitPod](https://www.gitpod.io/) - Cloud-based Git environment
   - [Replit](https://replit.com/) - Online IDE with Git support

4. **Visualization Tools**:
   - [Git Graph](https://marketplace.visualstudio.com/items?itemName=mhutchie.git-graph) - VS Code extension
   - [GitKraken](https://www.gitkraken.com/) - Git GUI client
   - [SourceTree](https://www.sourcetreeapp.com/) - Free Git GUI

### 📖 Quick References & Cheat Sheets

1. **Cheat Sheets**:
   - [GitHub Git Cheat Sheet](https://education.github.com/git-cheat-sheet-education.pdf) - Official
   - [Git Cheat Sheet - Atlassian](https://www.atlassian.com/git/tutorials/atlassian-git-cheatsheet)
   - [Git Commands - Tower](https://www.git-tower.com/learn/git/commands/)

2. **Visual Guides**:
   - [Visual Git Guide](https://marklodato.github.io/visual-git-guide/index-en.html) - Excellent visuals ⭐
   - [Git Branching Strategy](https://www.atlassian.com/git/tutorials/comparing-workflows)

### 📚 Books & Comprehensive Resources

1. **Free Books**:
   - [Pro Git](https://git-scm.com/book/en/v2) - Scott Chacon (FREE, comprehensive) ⭐⭐⭐
   - [Git Notes for Professionals](https://goalkicker.com/GitBook/) - FREE
   - [Learn Version Control with Git](https://www.git-tower.com/learn/git/ebook/)

2. **Recommended Books**:
   - "Version Control with Git" - Jon Loeliger & Matthew McCullough
   - "Git Pocket Guide" - Richard E. Silverman
   - "Git for Teams" - Emma Jane Hogbin Westby

### 🎓 Courses & Tutorials

1. **Free Courses**:
   - [Codecademy - Learn Git](https://www.codecademy.com/learn/learn-git)
   - [Udacity - Version Control with Git](https://www.udacity.com/course/version-control-with-git--ud123)
   - [Coursera - Git and GitHub](https://www.coursera.org/learn/version-control-with-git)

2. **Platform-Specific**:
   - [GitHub Docs](https://docs.github.com/) - GitHub-specific features
   - [GitLab Docs](https://docs.gitlab.com/) - GitLab features
   - [Bitbucket Tutorials](https://www.atlassian.com/git/tutorials) - Excellent tutorials

### 💡 Community & Support

1. **Forums & Q&A**:
   - [Stack Overflow - Git Tag](https://stackoverflow.com/questions/tagged/git)
   - [GitHub Community](https://github.community/)
   - [Reddit r/git](https://www.reddit.com/r/git/)

2. **Blogs & Resources**:
   - [GitHub Blog](https://github.blog/)
   - [Atlassian Git Tutorials](https://www.atlassian.com/git/tutorials)
   - [Git Tower Blog](https://www.git-tower.com/blog/)

### 🔧 Tools & Extensions

1. **GUI Clients**:
   - [GitKraken](https://www.gitkraken.com/) - Cross-platform
   - [SourceTree](https://www.sourcetreeapp.com/) - Free for Mac/Windows
   - [GitHub Desktop](https://desktop.github.com/) - Simple and free
   - [Git Extensions](https://gitextensions.github.io/) - Windows

2. **Command Line Tools**:
   - [tig](https://jonas.github.io/tig/) - Text-mode interface for Git
   - [lazygit](https://github.com/jesseduffield/lazygit) - Terminal UI
   - [gh](https://cli.github.com/) - GitHub CLI

3. **IDE Integration**:
   - VS Code - Built-in Git support
   - IntelliJ IDEA - Excellent Git integration
   - Eclipse - EGit plugin

---

## Common Issues

### Problem: Merge Conflicts
```bash
# See conflicted files
git status

# Open file, resolve conflicts
# Look for <<<<<<, =======, >>>>>> markers

# After resolving
git add resolved_file.txt
git commit -m "Resolve merge conflict"
```

### Problem: Accidentally Committed
```bash
# Undo last commit, keep changes
git reset --soft HEAD~1

# Undo last commit, discard changes
git reset --hard HEAD~1
```

### Problem: Need to Change Last Commit
```bash
# Modify files and amend
git add modified_file.txt
git commit --amend --no-edit
```

---

## What's Next?

In the next document, you'll learn:
- Advanced Git branching strategies
- Collaborating with teams
- Pull requests and code reviews
- Git hooks and automation
- Troubleshooting complex scenarios

---

**Next Document**: `02-Git-Branching-and-Collaboration.md`

