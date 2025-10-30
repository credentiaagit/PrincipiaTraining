# Git Branching and Collaboration

## Table of Contents
1. [Understanding Branches](#understanding-branches)
2. [Branch Operations](#branch-operations)
3. [Merging Strategies](#merging-strategies)
4. [Collaboration Workflows](#collaboration-workflows)
5. [Pull Requests](#pull-requests)
6. [Team Best Practices](#team-best-practices)

---

## Understanding Branches

### What is a Branch?

A branch is a lightweight movable pointer to a commit. It allows you to:
- Work on features independently
- Experiment without affecting main code
- Maintain multiple versions simultaneously
- Collaborate without conflicts

### Why Use Branches?

**Benefits:**
- ✅ Isolate feature development
- ✅ Test before merging to main
- ✅ Enable parallel development
- ✅ Easy to create and delete
- ✅ Fast switching between contexts

---

## Branch Operations

### Creating Branches

```bash
# Create new branch
git branch feature-branch

# Create and switch to branch
git checkout -b feature-branch

# Git 2.23+: use switch
git switch -c feature-branch

# Create branch from specific commit
git branch feature-branch commit-hash

# Create branch from remote
git checkout -b local-branch origin/remote-branch
```

### Switching Branches

```bash
# Switch to existing branch
git checkout main
git switch main  # Git 2.23+

# Switch to previous branch
git checkout -
git switch -

# Force switch (discard changes)
git checkout -f branch-name
```

### Listing Branches

```bash
# List local branches
git branch

# List with last commit
git branch -v

# List remote branches
git branch -r

# List all branches (local + remote)
git branch -a

# List merged branches
git branch --merged

# List unmerged branches
git branch --no-merged
```

### Deleting Branches

```bash
# Delete merged branch
git branch -d feature-branch

# Force delete unmerged branch
git branch -D feature-branch

# Delete remote branch
git push origin --delete feature-branch
git push origin :feature-branch  # Older syntax
```

### Renaming Branches

```bash
# Rename current branch
git branch -m new-name

# Rename specific branch
git branch -m old-name new-name

# Update remote
git push origin :old-name new-name
git push origin -u new-name
```

---

## Merging Strategies

### Fast-Forward Merge

When target branch hasn't diverged:

```bash
# Before: main --- A --- B
#                   feature

git checkout main
git merge feature

# After:  main/feature --- A --- B
```

```bash
# Perform fast-forward merge
git merge feature-branch

# Prevent fast-forward (create merge commit)
git merge --no-ff feature-branch
```

### Three-Way Merge

When branches have diverged:

```bash
# Before:
# main    --- A --- C --- D
#              \
# feature       --- B --- E

git checkout main
git merge feature

# After:
# main    --- A --- C --- D --- M
#              \               /
# feature       --- B --- E--/
```

### Merge Conflicts

**When conflicts occur:**

```bash
# Attempt merge
git merge feature-branch
# CONFLICT (content): Merge conflict in file.txt

# See conflicted files
git status

# Open file and resolve
# Look for conflict markers:
<<<<<<< HEAD
main branch code
=======
feature branch code
>>>>>>> feature-branch

# After resolving
git add resolved-file.txt
git commit -m "Resolve merge conflict"
```

**Conflict Resolution Tools:**

```bash
# Use merge tool
git mergetool

# Abort merge
git merge --abort

# Accept all changes from branch
git merge -X theirs feature-branch

# Accept all changes from current
git merge -X ours feature-branch
```

---

## Rebasing

### What is Rebasing?

Rebasing replays commits from one branch onto another, creating a linear history.

```bash
# Before:
# main    --- A --- C --- D
#              \
# feature       --- B --- E

git checkout feature
git rebase main

# After:
# main    --- A --- C --- D
#                          \
# feature                   --- B' --- E'
```

### Basic Rebase

```bash
# Rebase current branch onto main
git checkout feature-branch
git rebase main

# Or in one command
git rebase main feature-branch

# Continue after resolving conflicts
git rebase --continue

# Skip problematic commit
git rebase --skip

# Abort rebase
git rebase --abort
```

### Interactive Rebase

```bash
# Rebase last 3 commits interactively
git rebase -i HEAD~3

# Options:
# pick    = use commit
# reword  = edit commit message
# edit    = edit commit
# squash  = combine with previous
# fixup   = like squash, discard message
# drop    = remove commit
```

**Example Interactive Rebase:**

```bash
git rebase -i HEAD~3

# Editor opens:
pick abc1234 Add feature A
pick def5678 Fix typo
pick ghi9012 Add feature B

# Change to:
pick abc1234 Add feature A
squash def5678 Fix typo
pick ghi9012 Add feature B

# Save and close - commits will be combined
```

### Merge vs Rebase

**Use Merge when:**
- ✅ Working on public/shared branches
- ✅ Want to preserve complete history
- ✅ Following specific workflow (e.g., GitFlow)

**Use Rebase when:**
- ✅ Cleaning up local commits
- ✅ Keeping linear history
- ✅ Before pushing feature branch

**⚠️ Golden Rule**: Never rebase public/shared branches!

---

## Collaboration Workflows

### Centralized Workflow

```bash
# 1. Clone repository
git clone https://github.com/company/trading-system.git

# 2. Make changes
git add .
git commit -m "Update trade processor"

# 3. Push to remote
git push origin main
```

### Feature Branch Workflow

```bash
# 1. Start from main
git checkout main
git pull origin main

# 2. Create feature branch
git checkout -b feature/add-validation

# 3. Work on feature
git add .
git commit -m "Add trade validation"

# 4. Push feature branch
git push -u origin feature/add-validation

# 5. Create Pull Request

# 6. After merge, update main
git checkout main
git pull origin main
git branch -d feature/add-validation
```

### Gitflow Workflow

```
main (production)
  │
  ├── develop (integration)
  │     │
  │     ├── feature/feature-1
  │     ├── feature/feature-2
  │     │
  │     └── release/v1.0
  │
  └── hotfix/critical-bug
```

**Commands:**

```bash
# Start new feature
git checkout develop
git checkout -b feature/new-feature

# Finish feature
git checkout develop
git merge --no-ff feature/new-feature
git branch -d feature/new-feature

# Start release
git checkout develop
git checkout -b release/v1.0

# Finish release
git checkout main
git merge --no-ff release/v1.0
git tag -a v1.0 -m "Release 1.0"
git checkout develop
git merge --no-ff release/v1.0

# Hotfix
git checkout main
git checkout -b hotfix/critical-fix
# ... make fix ...
git checkout main
git merge --no-ff hotfix/critical-fix
git checkout develop
git merge --no-ff hotfix/critical-fix
```

### Forking Workflow

```bash
# 1. Fork repository on GitHub

# 2. Clone your fork
git clone https://github.com/yourname/trading-system.git

# 3. Add upstream remote
git remote add upstream https://github.com/company/trading-system.git

# 4. Create feature branch
git checkout -b feature/my-feature

# 5. Push to your fork
git push origin feature/my-feature

# 6. Create Pull Request to upstream

# 7. Sync with upstream
git fetch upstream
git checkout main
git merge upstream/main
git push origin main
```

---

## Pull Requests

### Creating Pull Requests

**On GitHub:**

1. Push feature branch to remote
2. Navigate to repository on GitHub
3. Click "New Pull Request"
4. Select base and compare branches
5. Add title and description
6. Request reviewers
7. Submit pull request

**Good PR Description:**

```markdown
## What does this PR do?
Adds validation for EUR currency trades

## Why is this change needed?
EUR trades were processing without proper validation

## Changes made:
- Added EUR validation rules
- Updated test cases
- Updated documentation

## How to test:
1. Run test suite: `npm test`
2. Test with sample EUR trade
3. Verify validation triggers correctly

## Screenshots (if applicable):
[Add screenshots]

## Checklist:
- [x] Code follows style guidelines
- [x] Tests added/updated
- [x] Documentation updated
- [x] No breaking changes
```

### Code Review Best Practices

**For Authors:**
- ✅ Keep PRs small and focused
- ✅ Write clear descriptions
- ✅ Test before submitting
- ✅ Respond to comments promptly
- ✅ Update based on feedback

**For Reviewers:**
- ✅ Be constructive and respectful
- ✅ Focus on logic and correctness
- ✅ Check for edge cases
- ✅ Suggest improvements
- ✅ Approve when satisfied

### PR Commands

```bash
# Check out PR locally
git fetch origin pull/123/head:pr-123
git checkout pr-123

# Update PR branch
git checkout feature-branch
git push origin feature-branch  # Updates PR automatically

# Merge PR (from main)
git checkout main
git merge --no-ff feature-branch
git push origin main
```

---

## Remote Repository Management

### Working with Remotes

```bash
# List remotes
git remote -v

# Add remote
git remote add origin https://github.com/user/repo.git

# Change remote URL
git remote set-url origin new-url

# Remove remote
git remote remove origin

# Rename remote
git remote rename origin upstream

# Get remote info
git remote show origin
```

### Fetching and Pulling

```bash
# Fetch from remote (no merge)
git fetch origin

# Fetch all remotes
git fetch --all

# Fetch and prune deleted branches
git fetch --prune

# Pull (fetch + merge)
git pull origin main

# Pull with rebase
git pull --rebase origin main

# Pull specific branch
git pull origin feature-branch
```

### Pushing Changes

```bash
# Push to remote branch
git push origin main

# Push and set upstream
git push -u origin feature-branch

# Push all branches
git push --all origin

# Push tags
git push --tags

# Force push (use carefully!)
git push --force origin main
git push --force-with-lease origin main  # Safer

# Delete remote branch
git push origin --delete feature-branch
```

---

## Tags

### Creating Tags

```bash
# Lightweight tag
git tag v1.0.0

# Annotated tag (recommended)
git tag -a v1.0.0 -m "Release version 1.0.0"

# Tag specific commit
git tag -a v1.0.0 commit-hash -m "Release 1.0.0"

# Sign tag with GPG
git tag -s v1.0.0 -m "Signed release 1.0.0"
```

### Managing Tags

```bash
# List tags
git tag
git tag -l "v1.*"  # List with pattern

# Show tag info
git show v1.0.0

# Push tag to remote
git push origin v1.0.0

# Push all tags
git push --tags

# Delete local tag
git tag -d v1.0.0

# Delete remote tag
git push origin --delete v1.0.0

# Checkout tag
git checkout v1.0.0  # Detached HEAD state
git checkout -b branch-from-tag v1.0.0  # Create branch
```

---

## Capital Markets Collaboration

### Team Structure Example

```
Trading System Team
├── main (production)
├── develop (integration)
├── features
│   ├── feature/risk-engine (Developer A)
│   ├── feature/price-validator (Developer B)
│   └── feature/reporting (Developer C)
└── releases
    └── release/v2.1 (Release Manager)
```

### Daily Workflow

**Morning:**
```bash
# Update your branch
git checkout feature/my-feature
git fetch origin
git rebase origin/develop

# Or if you prefer merge
git merge origin/develop
```

**During Development:**
```bash
# Commit frequently with good messages
git add changed-files
git commit -m "feat: add EUR validation"

# Push at end of day
git push origin feature/my-feature
```

**End of Feature:**
```bash
# Update with latest develop
git fetch origin
git rebase origin/develop

# Push and create PR
git push origin feature/my-feature
# Create PR on GitHub/GitLab
```

### Code Review Process

1. **Create PR** with clear description
2. **Automated checks** run (tests, linting)
3. **Peer review** (at least 2 reviewers)
4. **Address feedback** and push updates
5. **Approval** from reviewers
6. **Merge** to develop
7. **Delete** feature branch

---

## Best Practices

### Branch Naming

```
feature/description       - New features
bugfix/description        - Bug fixes
hotfix/description        - Production fixes
release/version           - Release branches
experimental/description  - Experiments
```

**Examples:**
```
feature/add-eur-support
bugfix/fix-price-rounding
hotfix/critical-memory-leak
release/v2.1.0
```

### Commit Guidelines

**Use Conventional Commits:**
```
feat: add new feature
fix: bug fix
docs: documentation update
style: formatting
refactor: code restructuring
test: add/update tests
chore: maintenance
```

**Good commits:**
```bash
git commit -m "feat: add EUR currency validation"
git commit -m "fix: correct price calculation rounding"
git commit -m "docs: update API documentation"
```

### Team Policies

✅ Always create feature branches
✅ Never commit directly to main
✅ Require PR reviews
✅ Run tests before pushing
✅ Keep commits atomic and logical
✅ Write meaningful commit messages
✅ Rebase feature branches regularly
✅ Delete merged branches

---

## Troubleshooting

### Common Scenarios

**Accidentally committed to main:**
```bash
# Move commits to feature branch
git branch feature-branch
git reset --hard origin/main
git checkout feature-branch
```

**Need to undo pushed commit:**
```bash
# Create revert commit
git revert HEAD
git push origin main
```

**Merge conflict help:**
```bash
# See conflicted files
git status

# See both versions
git show :1:file  # Common ancestor
git show :2:file  # Current branch
git show :3:file  # Merging branch

# Accept one version
git checkout --ours file    # Keep current
git checkout --theirs file  # Take incoming
```

---

## Quick Reference

| Command | Purpose |
|---------|---------|
| `git branch name` | Create branch |
| `git checkout -b name` | Create and switch |
| `git branch -d name` | Delete branch |
| `git merge branch` | Merge branch |
| `git rebase branch` | Rebase onto branch |
| `git push -u origin branch` | Push new branch |
| `git pull --rebase` | Pull with rebase |
| `git tag v1.0` | Create tag |

---

**Next Document**: `03-Git-Advanced-Topics.md` (to be created as needed)

**Back to**: `01-Git-Fundamentals.md`

