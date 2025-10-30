# Git Version Control - Exercises

## Overview
These exercises will help you master Git commands and workflows for version control in a capital markets environment.

---

## Section 1: Git Basics (20 exercises)

### Exercise 1: Initial Setup
**Task**: Configure Git with your name and email.
```bash
# Your commands here
```

**Solution**:
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@company.com"
git config --list
```

---

### Exercise 2: Create Repository
**Task**: Create a new directory called `trading-project` and initialize it as a Git repository.

**Solution**:
```bash
mkdir trading-project
cd trading-project
git init
git status
```

---

### Exercise 3: First Commit
**Task**: Create a README.md file with content "# Trading System" and commit it.

**Solution**:
```bash
echo "# Trading System" > README.md
git add README.md
git commit -m "Initial commit: Add README"
git log
```

---

### Exercise 4: Multiple Files
**Task**: Create three files (`trade.py`, `validator.py`, `config.txt`), add them all, and commit.

**Solution**:
```bash
touch trade.py validator.py config.txt
git add .
git commit -m "Add initial project files"
git log --oneline
```

---

### Exercise 5: Check Status
**Task**: Modify `trade.py`, check status without staging, then stage and check status again.

**Solution**:
```bash
echo "# Trade processing" >> trade.py
git status
git add trade.py
git status
```

---

### Exercise 6: View Differences
**Task**: Make changes to `validator.py` and view the differences before staging.

**Solution**:
```bash
echo "def validate():" >> validator.py
git diff validator.py
git add validator.py
git diff --staged validator.py
```

---

### Exercise 7: Commit with Message
**Task**: Commit the staged changes with a descriptive message following conventional commits format.

**Solution**:
```bash
git commit -m "feat: add validation function"
```

---

### Exercise 8: View History
**Task**: View the commit history in different formats.

**Solution**:
```bash
git log
git log --oneline
git log --oneline --graph
git log -p -2  # Last 2 commits with diffs
```

---

### Exercise 9: Amend Commit
**Task**: Make a typo in a commit message, then amend it.

**Solution**:
```bash
echo "# New feature" > feature.txt
git add feature.txt
git commit -m "Add feture"  # Typo!
git commit --amend -m "Add feature"
git log --oneline
```

---

### Exercise 10: Unstage File
**Task**: Stage a file, then unstage it without losing changes.

**Solution**:
```bash
echo "temp content" > temp.txt
git add temp.txt
git status
git reset HEAD temp.txt
git status
```

---

### Exercise 11: Discard Changes
**Task**: Make changes to a file and discard them completely.

**Solution**:
```bash
echo "unwanted changes" >> trade.py
git status
git checkout -- trade.py
# or
git restore trade.py
git status
```

---

### Exercise 12: Create .gitignore
**Task**: Create a `.gitignore` file to ignore `*.log` and `temp/` directory.

**Solution**:
```bash
cat > .gitignore << EOF
*.log
temp/
__pycache__/
*.pyc
EOF
git add .gitignore
git commit -m "Add .gitignore"
```

---

### Exercise 13: Check Ignored Files
**Task**: Create a `.log` file and verify it's ignored.

**Solution**:
```bash
echo "log data" > app.log
git status  # Should not show app.log
git check-ignore -v app.log
```

---

### Exercise 14: Remove File
**Task**: Remove a file from both working directory and Git.

**Solution**:
```bash
git rm temp.txt
git commit -m "Remove temp file"
```

---

### Exercise 15: Rename File
**Task**: Rename a file using Git.

**Solution**:
```bash
git mv validator.py trade_validator.py
git commit -m "Rename validator file"
```

---

### Exercise 16: View Specific Commit
**Task**: View the details of a specific commit.

**Solution**:
```bash
git log --oneline
git show <commit-hash>
```

---

### Exercise 17: Compare Commits
**Task**: Compare the current state with 2 commits ago.

**Solution**:
```bash
git diff HEAD~2
git diff HEAD~2 HEAD~1
```

---

### Exercise 18: Search History
**Task**: Find all commits that contain "feature" in the message.

**Solution**:
```bash
git log --grep="feature"
git log --oneline --grep="feature"
```

---

### Exercise 19: Blame Command
**Task**: See who last modified each line of a file.

**Solution**:
```bash
git blame trade.py
git blame -L 1,10 trade.py  # Lines 1-10 only
```

---

### Exercise 20: Git Aliases
**Task**: Create useful Git aliases for common commands.

**Solution**:
```bash
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.unstage 'reset HEAD --'
git config --global alias.last 'log -1 HEAD'
git config --global alias.lg 'log --oneline --graph --all'

# Now you can use:
git st
git lg
```

---

## Section 2: Branching (15 exercises)

### Exercise 21: Create Branch
**Task**: Create a new branch called `feature/add-validation`.

**Solution**:
```bash
git branch feature/add-validation
git branch  # List branches
```

---

### Exercise 22: Switch Branch
**Task**: Switch to the feature branch and create a file.

**Solution**:
```bash
git checkout feature/add-validation
# or
git switch feature/add-validation

echo "validation logic" > validation.py
git add validation.py
git commit -m "feat: add validation logic"
```

---

### Exercise 23: Create and Switch
**Task**: Create and switch to a branch in one command.

**Solution**:
```bash
git checkout -b feature/new-feature
# or
git switch -c feature/new-feature
```

---

### Exercise 24: List Branches
**Task**: List all branches with their last commits.

**Solution**:
```bash
git branch -v
git branch -vv  # With upstream info
git branch -a   # Include remote branches
```

---

### Exercise 25: Merge Branch
**Task**: Merge feature/add-validation into main.

**Solution**:
```bash
git checkout main
git merge feature/add-validation
git log --oneline --graph
```

---

### Exercise 26: Delete Branch
**Task**: Delete the merged feature branch.

**Solution**:
```bash
git branch -d feature/add-validation
git branch  # Verify deletion
```

---

### Exercise 27: Resolve Merge Conflict
**Task**: Create two branches that modify the same file and resolve the conflict.

**Solution**:
```bash
# Create branch A
git checkout -b feature-A
echo "version = 2.0" > config.txt
git add config.txt
git commit -m "Update to v2.0"

# Create branch B from main
git checkout main
git checkout -b feature-B
echo "version = 1.5" > config.txt
git add config.txt
git commit -m "Update to v1.5"

# Merge into main (will conflict)
git checkout main
git merge feature-A  # OK
git merge feature-B  # Conflict!

# Resolve conflict
# Edit config.txt, remove markers, choose version
git add config.txt
git commit -m "Resolve version conflict"
```

---

### Exercise 28: Fast-Forward Merge
**Task**: Create a branch, make commits, and perform a fast-forward merge.

**Solution**:
```bash
git checkout -b feature/quick-fix
echo "fix" > fix.txt
git add fix.txt
git commit -m "Quick fix"

git checkout main
git merge --ff-only feature/quick-fix  # Fast-forward only
```

---

### Exercise 29: No Fast-Forward Merge
**Task**: Merge with a merge commit even if fast-forward is possible.

**Solution**:
```bash
git checkout -b feature/preserve-history
echo "feature" > feature.txt
git add feature.txt
git commit -m "Add feature"

git checkout main
git merge --no-ff feature/preserve-history
git log --oneline --graph
```

---

### Exercise 30: Rebase Branch
**Task**: Create a feature branch, make changes in main, then rebase feature.

**Solution**:
```bash
# Create feature
git checkout -b feature/rebase-demo
echo "feature work" > feature.txt
git add feature.txt
git commit -m "Feature work"

# Update main
git checkout main
echo "main update" > main.txt
git add main.txt
git commit -m "Main update"

# Rebase feature onto main
git checkout feature/rebase-demo
git rebase main
git log --oneline --graph --all
```

---

### Exercise 31: Interactive Rebase
**Task**: Create 3 commits and use interactive rebase to squash them.

**Solution**:
```bash
echo "v1" > file.txt && git add . && git commit -m "Version 1"
echo "v2" > file.txt && git add . && git commit -m "Version 2"
echo "v3" > file.txt && git add . && git commit -m "Version 3"

git rebase -i HEAD~3
# In editor, change 'pick' to 'squash' for last 2 commits
# Save and edit the combined commit message
git log --oneline
```

---

### Exercise 32: Cherry-Pick
**Task**: Pick a specific commit from another branch.

**Solution**:
```bash
# On feature branch
git checkout feature/new-feature
echo "important fix" > fix.txt
git add fix.txt
git commit -m "Important fix"

# Note the commit hash
COMMIT_HASH=$(git log -1 --format=%H)

# Apply to main
git checkout main
git cherry-pick $COMMIT_HASH
git log --oneline
```

---

### Exercise 33: Branch from Commit
**Task**: Create a branch from a specific commit.

**Solution**:
```bash
git log --oneline
git branch hotfix/<commit-hash>
# or
git checkout -b hotfix <commit-hash>
```

---

### Exercise 34: Compare Branches
**Task**: See differences between two branches.

**Solution**:
```bash
git diff main..feature/new-feature
git diff --stat main feature/new-feature
git log main..feature/new-feature
```

---

### Exercise 35: Stash Changes
**Task**: Stash your work, switch branches, then reapply.

**Solution**:
```bash
echo "WIP" >> work.txt
git stash save "Work in progress"
git stash list

git checkout other-branch
# Do something...

git checkout original-branch
git stash pop
# or
git stash apply
```

---

## Section 3: Remote Repositories (10 exercises)

### Exercise 36: Clone Repository
**Task**: Clone a repository from GitHub.

**Solution**:
```bash
git clone https://github.com/username/repository.git
cd repository
git remote -v
```

---

### Exercise 37: Add Remote
**Task**: Add a remote repository to an existing project.

**Solution**:
```bash
git remote add origin https://github.com/username/repo.git
git remote -v
```

---

### Exercise 38: Push to Remote
**Task**: Push your main branch to remote.

**Solution**:
```bash
git push origin main
# or set upstream
git push -u origin main
```

---

### Exercise 39: Fetch Changes
**Task**: Fetch changes from remote without merging.

**Solution**:
```bash
git fetch origin
git log origin/main
git diff main origin/main
```

---

### Exercise 40: Pull Changes
**Task**: Pull changes from remote and merge.

**Solution**:
```bash
git pull origin main
# or with rebase
git pull --rebase origin main
```

---

### Exercise 41: Push New Branch
**Task**: Create a local branch and push it to remote.

**Solution**:
```bash
git checkout -b feature/remote-feature
echo "feature" > feature.txt
git add feature.txt
git commit -m "Add feature"
git push -u origin feature/remote-feature
```

---

### Exercise 42: Track Remote Branch
**Task**: Create a local branch that tracks a remote branch.

**Solution**:
```bash
git fetch origin
git checkout -b local-branch origin/remote-branch
# or
git checkout --track origin/remote-branch
```

---

### Exercise 43: Delete Remote Branch
**Task**: Delete a branch from the remote repository.

**Solution**:
```bash
git push origin --delete feature/old-feature
# or
git push origin :feature/old-feature
```

---

### Exercise 44: View Remote Info
**Task**: Get detailed information about a remote.

**Solution**:
```bash
git remote show origin
git ls-remote origin
```

---

### Exercise 45: Multiple Remotes
**Task**: Add a second remote (like upstream for forks).

**Solution**:
```bash
git remote add upstream https://github.com/original/repo.git
git remote -v
git fetch upstream
git merge upstream/main
```

---

## Section 4: Tags (5 exercises)

### Exercise 46: Create Lightweight Tag
**Task**: Create a lightweight tag for current commit.

**Solution**:
```bash
git tag v1.0.0
git tag
```

---

### Exercise 47: Create Annotated Tag
**Task**: Create an annotated tag with message.

**Solution**:
```bash
git tag -a v1.0.1 -m "Release version 1.0.1"
git show v1.0.1
```

---

### Exercise 48: Tag Specific Commit
**Task**: Tag an older commit.

**Solution**:
```bash
git log --oneline
git tag -a v0.9.0 <commit-hash> -m "Beta release"
```

---

### Exercise 49: Push Tags
**Task**: Push tags to remote repository.

**Solution**:
```bash
git push origin v1.0.1
# or push all tags
git push --tags
```

---

### Exercise 50: Delete Tag
**Task**: Delete a tag locally and remotely.

**Solution**:
```bash
# Delete locally
git tag -d v1.0.0

# Delete remotely
git push origin --delete v1.0.0
```

---

## Section 5: Capital Markets Scenarios (10 exercises)

### Exercise 51: Hotfix Workflow
**Task**: Simulate a production hotfix workflow.

**Solution**:
```bash
# Production issue found
git checkout main
git checkout -b hotfix/critical-bug

# Fix the bug
echo "fixed critical bug" > fix.txt
git add fix.txt
git commit -m "hotfix: fix critical price calculation bug"

# Merge to main
git checkout main
git merge --no-ff hotfix/critical-bug
git tag -a v2.0.1 -m "Hotfix release"

# Also merge to develop
git checkout develop
git merge --no-ff hotfix/critical-bug

# Push everything
git push origin main develop --tags
git branch -d hotfix/critical-bug
```

---

### Exercise 52: Release Branch
**Task**: Create a release branch for UAT.

**Solution**:
```bash
git checkout develop
git checkout -b release/v2.1.0

# Make release-specific changes
echo "version = 2.1.0" > version.txt
git add version.txt
git commit -m "chore: bump version to 2.1.0"

# After UAT approval
git checkout main
git merge --no-ff release/v2.1.0
git tag -a v2.1.0 -m "Release 2.1.0"

git checkout develop
git merge --no-ff release/v2.1.0
git branch -d release/v2.1.0
```

---

### Exercise 53: Feature Development
**Task**: Develop a feature following proper workflow.

**Solution**:
```bash
# Start feature
git checkout develop
git pull origin develop
git checkout -b feature/eur-support

# Develop
echo "EUR validation" > eur_validator.py
git add eur_validator.py
git commit -m "feat: add EUR currency support"

# Keep updated with develop
git fetch origin
git rebase origin/develop

# Push for review
git push -u origin feature/eur-support

# After code review and approval
git checkout develop
git pull origin develop
git merge --no-ff feature/eur-support
git push origin develop
git branch -d feature/eur-support
```

---

### Exercise 54: Code Review Workflow
**Task**: Simulate a code review workflow with changes.

**Solution**:
```bash
# Create PR branch
git checkout -b feature/add-logging
echo "logging code" > logger.py
git add logger.py
git commit -m "feat: add logging module"
git push -u origin feature/add-logging

# Reviewer requests changes
echo "improved logging" > logger.py
git add logger.py
git commit -m "refactor: improve logging based on review"
git push origin feature/add-logging

# After approval
git checkout main
git merge --no-ff feature/add-logging
git push origin main
```

---

### Exercise 55: Rollback Release
**Task**: Rollback a problematic release.

**Solution**:
```bash
# View tags
git tag

# Revert to previous version
git checkout main
git revert HEAD~1..HEAD  # Revert last commits

# Or create hotfix from previous tag
git checkout -b hotfix/rollback v2.0.0
git push origin hotfix/rollback
```

---

### Exercise 56: Audit Trail
**Task**: Generate an audit trail of changes.

**Solution**:
```bash
# View all changes by author
git log --author="John Doe" --since="1 week ago" --pretty=format:"%h %ad | %s" --date=short

# Generate change log between releases
git log v1.0.0..v2.0.0 --pretty=format:"- %s" --no-merges

# Find who changed specific line
git blame trade_processor.py
```

---

### Exercise 57: Environment-Specific Configs
**Task**: Manage configurations for different environments.

**Solution**:
```bash
# Create branches for environments
git checkout -b config/dev
echo "dev config" > config.ini
git add config.ini
git commit -m "Add dev config"

git checkout main
git checkout -b config/uat
echo "uat config" > config.ini
git add config.ini
git commit -m "Add UAT config"

git checkout main
git checkout -b config/prod
echo "prod config" > config.ini
git add config.ini
git commit -m "Add prod config"

# Never merge these branches, deploy separately
```

---

### Exercise 58: Bisect to Find Bug
**Task**: Use git bisect to find when a bug was introduced.

**Solution**:
```bash
# Start bisect
git bisect start

# Mark current as bad
git bisect bad

# Mark known good commit
git bisect good v1.0.0

# Test each commit Git checks out
# Mark as good or bad
git bisect good  # or git bisect bad

# When found
git bisect reset
```

---

### Exercise 59: Backup Before Deployment
**Task**: Create a backup tag before deployment.

**Solution**:
```bash
# Before deploying to production
git tag -a backup/pre-deploy-$(date +%Y%m%d-%H%M) -m "Backup before deployment"
git push --tags

# Deploy...

# If rollback needed
git checkout backup/pre-deploy-20241028-1400
```

---

### Exercise 60: Team Collaboration
**Task**: Simulate a team collaboration scenario.

**Solution**:
```bash
# Developer A
git checkout -b feature/risk-engine
echo "risk code" > risk_engine.py
git add risk_engine.py
git commit -m "feat: add risk engine"
git push -u origin feature/risk-engine

# Developer B (different feature)
git checkout -b feature/reporting
echo "report code" > reports.py
git add reports.py
git commit -m "feat: add reporting module"
git push -u origin feature/reporting

# Both get merged to develop
git checkout develop
git merge --no-ff feature/risk-engine
git merge --no-ff feature/reporting
git push origin develop

# Both features tested together in develop
```

---

## Bonus: Advanced Scenarios

### Exercise 61: Reflog Recovery
**Task**: Recover a deleted branch using reflog.

**Solution**:
```bash
# Accidentally delete branch
git branch -D important-feature

# Find it in reflog
git reflog

# Recover
git checkout -b important-feature <commit-hash-from-reflog>
```

---

### Exercise 62: Subtree for Dependencies
**Task**: Add another repository as a subtree.

**Solution**:
```bash
git subtree add --prefix=lib/shared https://github.com/company/shared-lib.git main --squash
```

---

## Summary

After completing these exercises, you should be able to:
- ✅ Perform all basic Git operations
- ✅ Manage branches effectively
- ✅ Work with remote repositories
- ✅ Handle merge conflicts
- ✅ Use Git in team workflows
- ✅ Apply Git in capital markets scenarios
- ✅ Troubleshoot common issues

---

## Next Steps

1. Practice these exercises multiple times
2. Apply them to real projects
3. Explore advanced Git features
4. Learn platform-specific features (GitHub/GitLab)
5. Set up Git hooks for automation

---

**Completed**: 62 exercises covering Git fundamentals through advanced scenarios

