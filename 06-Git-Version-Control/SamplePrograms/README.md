# Git Version Control - Sample Programs

This directory contains practical Git workflow demonstrations for capital markets development.

## Files Overview

### 01-git-workflow-examples.sh
**Purpose**: Demonstrate common Git workflows through executable examples
**Topics Covered**:
- Basic Git workflow (init, add, commit)
- Feature branch workflow
- Merge conflict resolution
- Undoing changes
- Remote repository operations
- Working with tags
- Stashing changes

**Usage**:
```bash
chmod +x 01-git-workflow-examples.sh
./01-git-workflow-examples.sh
```

**What It Does**:
- Creates temporary demo repositories
- Demonstrates each workflow step-by-step
- Shows command output with color coding
- Automatically cleans up after completion

---

## Learning Path

### 1. First Run - Observe
```bash
./01-git-workflow-examples.sh
```
Watch the entire script run to see all workflows in action.

### 2. Study the Code
Open the script and read through each example:
- Notice how commands are structured
- Understand the sequence of operations
- See how conflicts are created and resolved

### 3. Practice Manually
Create your own test repository and replicate the workflows:
```bash
mkdir practice-git
cd practice-git
git init
# Follow along with each example manually
```

---

## Key Workflows Demonstrated

### Example 1: Basic Workflow
```bash
git init
git add filename
git commit -m "message"
git log
```

**When to use**: Every day, all the time

### Example 2: Feature Branch
```bash
git checkout -b feature/name
# Work on feature
git add .
git commit -m "feat: description"
git checkout main
git merge feature/name
```

**When to use**: Developing new features or fixes

### Example 3: Merge Conflicts
```bash
# When conflict occurs:
git status  # See conflicted files
# Edit files to resolve
git add resolved-files
git commit -m "Resolve conflict"
```

**When to use**: When two branches modify the same code

### Example 4: Undoing Changes
```bash
# Unstage
git reset HEAD file

# Discard changes
git checkout -- file

# Amend commit
git commit --amend
```

**When to use**: Fixing mistakes before pushing

### Example 5: Remote Operations
```bash
git clone url
git push origin main
git pull origin main
git fetch origin
```

**When to use**: Collaborating with team

### Example 6: Tags
```bash
git tag v1.0.0
git tag -a v1.0.1 -m "Release message"
git push --tags
```

**When to use**: Marking releases and important milestones

### Example 7: Stashing
```bash
git stash save "message"
git stash list
git stash pop
```

**When to use**: Temporarily saving work to switch context

---

## Capital Markets Scenarios

### Scenario 1: Daily Development
```bash
# Morning
git checkout develop
git pull origin develop
git checkout -b feature/add-eur-support

# Throughout day
git add changed-files
git commit -m "feat: implement EUR validation"

# End of day
git push -u origin feature/add-eur-support
```

### Scenario 2: Hotfix
```bash
# Critical bug found in production
git checkout main
git pull origin main
git checkout -b hotfix/price-calc-bug

# Fix the bug
git add fixed-files
git commit -m "hotfix: fix price calculation"

# Deploy
git checkout main
git merge hotfix/price-calc-bug
git tag -a v2.0.1 -m "Hotfix release"
git push origin main --tags

# Also update develop
git checkout develop
git merge hotfix/price-calc-bug
git push origin develop
```

### Scenario 3: Release Process
```bash
# Create release branch
git checkout develop
git checkout -b release/v2.1.0

# Prepare release
git commit -m "chore: bump version to 2.1.0"

# After UAT
git checkout main
git merge release/v2.1.0
git tag -a v2.1.0 -m "Production release 2.1.0"
git push origin main --tags

# Merge back to develop
git checkout develop
git merge release/v2.1.0
git push origin develop
```

### Scenario 4: Code Review
```bash
# Create feature
git checkout -b feature/logging
git commit -m "feat: add logging"
git push -u origin feature/logging

# Create Pull Request on GitHub/GitLab

# Address review comments
git commit -m "refactor: improve logging per review"
git push origin feature/logging

# After approval - merge via web interface or:
git checkout develop
git merge --no-ff feature/logging
git push origin develop
```

---

## Best Practices Demonstrated

### Commit Messages
```bash
# Good examples in script:
git commit -m "feat: add EUR currency validation"
git commit -m "fix: correct price calculation rounding"
git commit -m "docs: update API documentation"
git commit -m "refactor: improve code structure"
```

Format: `type: description`

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `style`: Formatting
- `refactor`: Code restructuring
- `test`: Tests
- `chore`: Maintenance

### Branch Naming
```bash
feature/description    # New features
bugfix/description     # Bug fixes
hotfix/description     # Production fixes
release/version        # Release branches
```

### Merge Strategies
```bash
# Fast-forward (clean history)
git merge feature-branch

# No fast-forward (preserve feature history)
git merge --no-ff feature-branch

# Rebase (linear history)
git rebase main
```

---

## Common Patterns

### Pattern 1: Start New Work
```bash
git checkout main
git pull origin main
git checkout -b feature/new-work
```

### Pattern 2: Save Work in Progress
```bash
git stash save "WIP: feature description"
# Do something urgent
git stash pop
```

### Pattern 3: Update Feature Branch
```bash
git checkout feature-branch
git fetch origin
git rebase origin/develop
# or
git merge origin/develop
```

### Pattern 4: Undo Last Commit (Not Pushed)
```bash
git reset --soft HEAD~1  # Keep changes
# or
git reset --hard HEAD~1  # Discard changes
```

### Pattern 5: View What Changed
```bash
git diff                  # Unstaged changes
git diff --staged         # Staged changes
git diff main..feature    # Between branches
```

---

## Troubleshooting Examples

### Problem: Committed to Wrong Branch
```bash
# Move commits to feature branch
git branch feature-branch
git reset --hard origin/main
git checkout feature-branch
```

### Problem: Need to Undo Push
```bash
# Create revert commit (safe)
git revert HEAD
git push origin main
```

### Problem: Merge Conflict
```bash
git status              # See conflicted files
# Edit files, remove conflict markers
git add resolved-files
git commit
```

### Problem: Lost Work
```bash
git reflog              # Find lost commits
git checkout -b recovery <commit-hash>
```

---

## Testing the Script

### Quick Test
```bash
./01-git-workflow-examples.sh
```

### Verbose Test (See All Output)
```bash
bash -x 01-git-workflow-examples.sh
```

### Test Individual Example
Edit the script to run only one example function.

---

## Extending the Examples

### Add Your Own Workflow
1. Open the script in an editor
2. Add a new function following the pattern
3. Call it from `main()`
4. Test it

Example template:
```bash
example_your_workflow() {
    print_header "Your Workflow Name"
    
    TEST_DIR="your-demo-$$"
    mkdir -p "$TEST_DIR"
    cd "$TEST_DIR"
    
    # Setup
    git init > /dev/null 2>&1
    
    # Your commands here
    print_command "git command"
    
    cd ..
    echo -e "${GREEN}✓ Your workflow completed${NC}"
}
```

---

## Additional Resources

### Practice Repositories
- Create a personal practice repository
- Use GitHub/GitLab for realistic remote practice
- Join open source projects to see Git in action

### Interactive Learning
- [Learn Git Branching](https://learngitbranching.js.org/) - Visual interactive tutorial
- [GitHub Learning Lab](https://lab.github.com/) - Hands-on courses
- [Git Immersion](https://gitimmersion.com/) - Step-by-step tutorial

### Visual Tools
- **GitKraken**: Visual Git client
- **SourceTree**: Free Git GUI
- **GitHub Desktop**: Simple Git interface
- **VS Code**: Built-in Git support

---

## Quick Command Reference

| Command | Purpose |
|---------|---------|
| `git init` | Initialize repository |
| `git clone <url>` | Clone repository |
| `git add <file>` | Stage changes |
| `git commit -m "msg"` | Commit changes |
| `git push` | Push to remote |
| `git pull` | Pull from remote |
| `git checkout -b <branch>` | Create branch |
| `git merge <branch>` | Merge branch |
| `git status` | Check status |
| `git log` | View history |

---

## Next Steps

1. ✅ Run the sample script
2. ✅ Read through the code
3. ✅ Practice commands manually
4. ✅ Complete the exercises
5. ✅ Apply to real projects

---

## Feedback and Improvements

This script is designed for learning. As you become comfortable with Git:
- Customize workflows for your team
- Add company-specific examples
- Integrate with your CI/CD pipeline
- Create Git hooks for automation

---

**Remember**: Git is a powerful tool. Practice regularly, and it will become second nature!

