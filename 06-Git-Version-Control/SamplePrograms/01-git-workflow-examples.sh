#!/bin/bash
################################################################################
# Script: 01-git-workflow-examples.sh
# Purpose: Demonstrate common Git workflows and scenarios
# Author: Training Team
# Usage: bash 01-git-workflow-examples.sh
################################################################################

# Note: This script demonstrates Git commands.
# It creates a test repository to show workflows.

set -e  # Exit on error

################################################################################
# Colors for output
################################################################################
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

################################################################################
# Function: print_header
################################################################################
print_header() {
    echo -e "\n${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}\n"
}

################################################################################
# Function: print_command
################################################################################
print_command() {
    echo -e "${YELLOW}$ $1${NC}"
    eval "$1"
    echo ""
}

################################################################################
# Example 1: Basic Git Workflow
################################################################################
example_basic_workflow() {
    print_header "Example 1: Basic Git Workflow"
    
    # Create test directory
    TEST_DIR="git-demo-$$"
    mkdir -p "$TEST_DIR"
    cd "$TEST_DIR"
    
    echo "Creating a new project..."
    
    # Initialize repository
    print_command "git init"
    
    # Configure (local to this repo)
    print_command "git config user.name 'Demo User'"
    print_command "git config user.email 'demo@example.com'"
    
    # Create first file
    echo "# Trading System" > README.md
    echo "Created README.md"
    echo ""
    
    # Check status
    print_command "git status"
    
    # Add file
    print_command "git add README.md"
    
    # Check status again
    print_command "git status"
    
    # Commit
    print_command "git commit -m 'Initial commit: Add README'"
    
    # View history
    print_command "git log --oneline"
    
    cd ..
    echo -e "${GREEN}✓ Basic workflow completed${NC}"
}

################################################################################
# Example 2: Feature Branch Workflow
################################################################################
example_feature_branch() {
    print_header "Example 2: Feature Branch Workflow"
    
    TEST_DIR="feature-demo-$$"
    mkdir -p "$TEST_DIR"
    cd "$TEST_DIR"
    
    # Setup
    git init > /dev/null 2>&1
    git config user.name "Demo User"
    git config user.email "demo@example.com"
    echo "# Main" > main.txt
    git add . > /dev/null 2>&1
    git commit -m "Initial commit" > /dev/null 2>&1
    
    echo "Starting with main branch..."
    print_command "git branch"
    
    # Create feature branch
    print_command "git checkout -b feature/add-validation"
    
    # Work on feature
    echo "def validate_trade(trade):" > validation.py
    echo "    return True" >> validation.py
    echo "Created validation.py"
    echo ""
    
    print_command "git add validation.py"
    print_command "git commit -m 'feat: add trade validation'"
    
    # View branches
    print_command "git branch -v"
    
    # Switch back to main
    print_command "git checkout main"
    
    # Merge feature
    print_command "git merge feature/add-validation"
    
    # View log
    print_command "git log --oneline --graph --all"
    
    # Cleanup
    print_command "git branch -d feature/add-validation"
    
    cd ..
    echo -e "${GREEN}✓ Feature branch workflow completed${NC}"
}

################################################################################
# Example 3: Handling Merge Conflicts
################################################################################
example_merge_conflict() {
    print_header "Example 3: Handling Merge Conflicts"
    
    TEST_DIR="conflict-demo-$$"
    mkdir -p "$TEST_DIR"
    cd "$TEST_DIR"
    
    # Setup
    git init > /dev/null 2>&1
    git config user.name "Demo User"
    git config user.email "demo@example.com"
    
    # Create initial file
    echo "version = 1.0" > config.txt
    git add . > /dev/null 2>&1
    git commit -m "Initial config" > /dev/null 2>&1
    
    # Create branch 1
    git checkout -b feature-A > /dev/null 2>&1
    echo "version = 2.0" > config.txt
    echo "author = Developer A" >> config.txt
    git add . > /dev/null 2>&1
    git commit -m "Update to v2.0" > /dev/null 2>&1
    
    # Create branch 2 from main
    git checkout main > /dev/null 2>&1
    git checkout -b feature-B > /dev/null 2>&1
    echo "version = 1.5" > config.txt
    echo "author = Developer B" >> config.txt
    git add . > /dev/null 2>&1
    git commit -m "Update to v1.5" > /dev/null 2>&1
    
    # Try to merge (will conflict)
    git checkout main > /dev/null 2>&1
    echo "Merging feature-A..."
    git merge feature-A > /dev/null 2>&1
    
    echo "Attempting to merge feature-B (this will conflict)..."
    if ! git merge feature-B > /dev/null 2>&1; then
        echo -e "${RED}✗ Merge conflict detected!${NC}\n"
        
        echo "Conflict in: config.txt"
        print_command "git status"
        
        echo "File content with conflict markers:"
        cat config.txt
        echo ""
        
        # Resolve conflict (keep version 2.0)
        echo "Resolving conflict (choosing version 2.0)..."
        echo "version = 2.0" > config.txt
        echo "author = Developer A" >> config.txt
        
        print_command "git add config.txt"
        print_command "git commit -m 'Merge feature-B: resolve conflict'"
        
        echo -e "${GREEN}✓ Conflict resolved${NC}"
    fi
    
    print_command "git log --oneline --graph --all"
    
    cd ..
}

################################################################################
# Example 4: Undoing Changes
################################################################################
example_undoing_changes() {
    print_header "Example 4: Undoing Changes"
    
    TEST_DIR="undo-demo-$$"
    mkdir -p "$TEST_DIR"
    cd "$TEST_DIR"
    
    # Setup
    git init > /dev/null 2>&1
    git config user.name "Demo User"
    git config user.email "demo@example.com"
    
    # Scenario 1: Unstage file
    echo "Scenario 1: Unstage a file"
    echo "Important data" > important.txt
    print_command "git add important.txt"
    print_command "git status"
    echo "Oops, let's unstage it:"
    print_command "git reset HEAD important.txt"
    print_command "git status"
    
    # Scenario 2: Discard changes in working directory
    echo "Scenario 2: Discard working directory changes"
    echo "Modified" > important.txt
    print_command "git status"
    echo "Let's discard the changes:"
    print_command "git checkout -- important.txt"
    print_command "git status"
    
    # Scenario 3: Amend last commit
    echo "Scenario 3: Amend last commit"
    echo "First version" > file.txt
    git add . > /dev/null 2>&1
    git commit -m "Add fiel" > /dev/null 2>&1  # Typo in message
    
    echo "Oops, typo in commit message. Let's amend:"
    print_command "git commit --amend -m 'Add file'"
    print_command "git log --oneline"
    
    cd ..
    echo -e "${GREEN}✓ Undo examples completed${NC}"
}

################################################################################
# Example 5: Working with Remote (Simulated)
################################################################################
example_remote_workflow() {
    print_header "Example 5: Remote Workflow (Simulated)"
    
    # Create "remote" repository
    REMOTE_DIR="remote-repo-$$"
    LOCAL_DIR="local-repo-$$"
    
    mkdir -p "$REMOTE_DIR"
    cd "$REMOTE_DIR"
    git init --bare > /dev/null 2>&1
    cd ..
    
    echo "Created bare repository (simulating remote)"
    echo ""
    
    # Clone repository
    echo "Cloning repository..."
    print_command "git clone $REMOTE_DIR $LOCAL_DIR"
    
    cd "$LOCAL_DIR"
    git config user.name "Demo User"
    git config user.email "demo@example.com"
    
    # Create content
    echo "# Trading System" > README.md
    print_command "git add README.md"
    print_command "git commit -m 'Initial commit'"
    
    # Push to remote
    print_command "git push origin main"
    
    # Show remote
    print_command "git remote -v"
    
    # Create branch and push
    print_command "git checkout -b feature/new-feature"
    echo "New feature code" > feature.txt
    print_command "git add feature.txt"
    print_command "git commit -m 'Add new feature'"
    print_command "git push -u origin feature/new-feature"
    
    # Show branches
    print_command "git branch -a"
    
    cd ../..
    echo -e "${GREEN}✓ Remote workflow completed${NC}"
}

################################################################################
# Example 6: Git Tags
################################################################################
example_tags() {
    print_header "Example 6: Working with Tags"
    
    TEST_DIR="tags-demo-$$"
    mkdir -p "$TEST_DIR"
    cd "$TEST_DIR"
    
    # Setup
    git init > /dev/null 2>&1
    git config user.name "Demo User"
    git config user.email "demo@example.com"
    
    # Create some commits
    echo "v1.0 release" > release.txt
    git add . > /dev/null 2>&1
    git commit -m "Prepare v1.0 release" > /dev/null 2>&1
    
    # Create lightweight tag
    print_command "git tag v1.0"
    
    # Create annotated tag
    print_command "git tag -a v1.0.1 -m 'Release version 1.0.1'"
    
    # List tags
    print_command "git tag"
    
    # Show tag info
    print_command "git show v1.0.1"
    
    # Create more commits
    echo "New feature" > feature.txt
    git add . > /dev/null 2>&1
    git commit -m "Add feature for v1.1" > /dev/null 2>&1
    
    # Tag new version
    print_command "git tag -a v1.1.0 -m 'Release version 1.1.0'"
    
    # Show all tags
    print_command "git tag -l"
    
    # View log with tags
    print_command "git log --oneline --decorate"
    
    cd ..
    echo -e "${GREEN}✓ Tags example completed${NC}"
}

################################################################################
# Example 7: Stashing Changes
################################################################################
example_stash() {
    print_header "Example 7: Stashing Changes"
    
    TEST_DIR="stash-demo-$$"
    mkdir -p "$TEST_DIR"
    cd "$TEST_DIR"
    
    # Setup
    git init > /dev/null 2>&1
    git config user.name "Demo User"
    git config user.email "demo@example.com"
    
    echo "main code" > main.txt
    git add . > /dev/null 2>&1
    git commit -m "Initial commit" > /dev/null 2>&1
    
    # Make changes
    echo "Working on feature..." > feature.txt
    echo "Modified main" > main.txt
    
    print_command "git status"
    
    # Stash changes
    print_command "git stash save 'WIP: feature development'"
    
    print_command "git status"
    
    # List stashes
    print_command "git stash list"
    
    # Do something else (create hotfix)
    echo "Hotfix" > hotfix.txt
    git add . > /dev/null 2>&1
    git commit -m "Critical hotfix" > /dev/null 2>&1
    
    # Apply stash
    print_command "git stash pop"
    
    print_command "git status"
    
    cd ..
    echo -e "${GREEN}✓ Stash example completed${NC}"
}

################################################################################
# Cleanup Function
################################################################################
cleanup() {
    echo ""
    print_header "Cleanup"
    echo "Removing demo directories..."
    rm -rf git-demo-* feature-demo-* conflict-demo-* undo-demo-* remote-repo-* local-repo-* tags-demo-* stash-demo-*
    echo -e "${GREEN}✓ Cleanup completed${NC}"
}

################################################################################
# Main Function
################################################################################
main() {
    echo "========================================="
    echo "Git Workflow Examples"
    echo "========================================="
    echo ""
    echo "This script demonstrates common Git workflows."
    echo "Demo directories will be created and cleaned up."
    echo ""
    
    # Run examples
    example_basic_workflow
    example_feature_branch
    example_merge_conflict
    example_undoing_changes
    example_remote_workflow
    example_tags
    example_stash
    
    # Cleanup
    cleanup
    
    echo ""
    echo -e "${GREEN}=========================================${NC}"
    echo -e "${GREEN}All examples completed successfully!${NC}"
    echo -e "${GREEN}=========================================${NC}"
    echo ""
    echo "Next steps:"
    echo "1. Practice these workflows in your own repository"
    echo "2. Review the Git theory documents"
    echo "3. Complete the exercises"
}

# Run main function
main

