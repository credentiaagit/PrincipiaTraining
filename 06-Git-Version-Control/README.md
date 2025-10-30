# Git Version Control Training

## 📚 Welcome to Git Training

This module provides comprehensive training on Git version control, essential for modern software development in capital markets.

---

## 🎯 Learning Objectives

After completing this module, you will be able to:
- ✅ Understand version control concepts
- ✅ Use Git for daily development tasks
- ✅ Manage branches effectively
- ✅ Collaborate with team members
- ✅ Resolve merge conflicts
- ✅ Apply Git workflows in capital markets
- ✅ Use Git best practices

---

## 📁 Module Structure

### Theory Documents (2 files)
1. **01-Git-Fundamentals.md** - Git basics, commands, workflows
2. **02-Git-Branching-and-Collaboration.md** - Advanced branching, team workflows

### Sample Programs (1 file)
1. **01-git-workflow-examples.sh** - Executable demonstrations of Git workflows

### Exercises (1 file)
1. **01-Git-Exercises.md** - 62 hands-on exercises with solutions

---

## 🚀 Quick Start

### Day 1: Git Basics (2-3 hours)
1. Read: `Theory/01-Git-Fundamentals.md`
2. Practice: Basic commands (init, add, commit, log)
3. Complete: Exercises 1-20

### Day 2: Branching (2-3 hours)
1. Read: `Theory/02-Git-Branching-and-Collaboration.md`
2. Run: `SamplePrograms/01-git-workflow-examples.sh`
3. Complete: Exercises 21-35

### Day 3: Collaboration (2-3 hours)
1. Study: Remote operations and workflows
2. Practice: Clone, push, pull, fetch
3. Complete: Exercises 36-50

### Day 4-5: Capital Markets Scenarios (3-4 hours)
1. Apply: Real-world workflows
2. Practice: Hotfix, release, feature workflows
3. Complete: Exercises 51-62

---

## 📖 Learning Path

### Beginner Level (Week 1)
**Focus**: Git fundamentals
- Understanding version control
- Basic Git commands
- Working directory, staging, commits
- Viewing history and changes
- Undoing mistakes

**Practice**:
```bash
git init
git add .
git commit -m "message"
git log
git diff
git status
```

### Intermediate Level (Week 2)
**Focus**: Branching and merging
- Creating and managing branches
- Merging strategies
- Resolving conflicts
- Rebasing
- Stashing

**Practice**:
```bash
git branch feature-name
git checkout -b feature-name
git merge feature-name
git rebase main
git stash
```

### Advanced Level (Week 3)
**Focus**: Team collaboration
- Remote repositories
- Pull requests
- Code reviews
- Git workflows (GitFlow, Feature Branch)
- Tags and releases

**Practice**:
```bash
git clone url
git push origin main
git pull --rebase
git tag -a v1.0.0
```

### Expert Level (Ongoing)
**Focus**: Production workflows
- Hotfix procedures
- Release management
- Conflict resolution strategies
- Git hooks
- Advanced troubleshooting

---

## 💼 Capital Markets Context

### Why Git in Trading Systems?

**Code Management**:
- Track changes to TCL scripts
- Version control for configurations
- Manage SQL queries and procedures
- Document system changes

**Collaboration**:
- Multiple developers working simultaneously
- Code review before production
- Audit trail for compliance
- Rollback capabilities

**Deployment**:
- Tag releases for production
- Maintain separate environments (dev, UAT, prod)
- Quick hotfix deployment
- Version tracking for regulatory requirements

---

## 🔧 Prerequisites

### Software Required
```bash
# Check Git installation
git --version

# Install if needed (Ubuntu/Debian)
sudo apt-get install git

# Install (macOS with Homebrew)
brew install git

# Install (Windows)
# Download from git-scm.com
```

### Initial Configuration
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@company.com"
git config --global core.editor "vim"
git config --global init.defaultBranch main
```

---

## 📊 Module Content Summary

### Theory Coverage
- **Git Fundamentals** (60+ topics)
  - Version control basics
  - Git architecture
  - Basic commands
  - File lifecycle
  - History and diffs
  - Undoing changes
  - Ignoring files
  - Remote operations

- **Branching & Collaboration** (40+ topics)
  - Branch operations
  - Merge strategies
  - Conflict resolution
  - Rebasing
  - Collaboration workflows
  - Pull requests
  - Tags
  - Best practices

### Sample Programs
- **7 Complete Workflows**
  1. Basic Git workflow
  2. Feature branch workflow
  3. Merge conflict handling
  4. Undoing changes
  5. Remote operations
  6. Tags management
  7. Stashing changes

### Exercises
- **62 Hands-On Exercises**
  - Section 1: Basics (20 exercises)
  - Section 2: Branching (15 exercises)
  - Section 3: Remotes (10 exercises)
  - Section 4: Tags (5 exercises)
  - Section 5: Capital Markets (10 exercises)
  - Bonus: Advanced (2 exercises)

---

## 🎓 Assessment Checkpoints

### Week 1 Assessment
- [ ] Can initialize and configure Git
- [ ] Understand basic workflow
- [ ] Can commit changes with good messages
- [ ] Can view and navigate history
- [ ] Can undo changes safely

### Week 2 Assessment
- [ ] Can create and manage branches
- [ ] Can merge branches
- [ ] Can resolve merge conflicts
- [ ] Understand rebasing
- [ ] Can use stash effectively

### Week 3 Assessment
- [ ] Can work with remote repositories
- [ ] Can push and pull changes
- [ ] Understand collaboration workflows
- [ ] Can create and manage tags
- [ ] Can perform code reviews

### Final Assessment
- [ ] Can handle hotfix scenarios
- [ ] Can manage release branches
- [ ] Can troubleshoot Git issues
- [ ] Can apply Git in team environment
- [ ] Ready for production work

---

## 💡 Best Practices Taught

### Commit Messages
✅ Use conventional commits format
✅ Write clear, descriptive messages
✅ Separate subject from body
✅ Use imperative mood

### Branching
✅ Use descriptive branch names
✅ Keep branches focused and small
✅ Delete merged branches
✅ Rebase feature branches regularly

### Collaboration
✅ Pull before starting new work
✅ Push at end of day
✅ Create pull requests for review
✅ Respond to review comments promptly

### Safety
✅ Never force push to shared branches
✅ Test before committing
✅ Don't commit sensitive data
✅ Keep commits atomic

---

## 🔗 Reference Links

### 📚 Theory Resources
- [Pro Git Book](https://git-scm.com/book/en/v2) - FREE comprehensive guide ⭐⭐⭐
- [Git Official Docs](https://git-scm.com/doc) - Official documentation
- [GitHub Docs](https://docs.github.com/) - GitHub-specific features
- [Atlassian Git Tutorials](https://www.atlassian.com/git/tutorials) - Excellent tutorials

### 🎮 Hands-On Practice
- [Learn Git Branching](https://learngitbranching.js.org/) - THE BEST interactive tutorial ⭐⭐⭐
- [GitHub Skills](https://skills.github.com/) - Interactive GitHub learning
- [Git Exercises](https://gitexercises.fracz.com/) - Practice Git commands
- [Oh My Git!](https://ohmygit.org/) - Learn Git through a game

### 🔧 Tools
- [GitKraken](https://www.gitkraken.com/) - Visual Git client
- [GitHub Desktop](https://desktop.github.com/) - Simple Git interface
- [SourceTree](https://www.sourcetreeapp.com/) - Free Git GUI
- [VS Code](https://code.visualstudio.com/) - Built-in Git support

---

## 🆘 Getting Help

### When Stuck
1. **Check status**: `git status`
2. **View help**: `git help command`
3. **Check documentation**: Theory files in this directory
4. **Search online**: [Stack Overflow Git Tag](https://stackoverflow.com/questions/tagged/git)
5. **Ask team**: Senior developers or mentor

### Common Issues
- **Merge conflict**: See Theory/02-Git-Branching-and-Collaboration.md
- **Undo changes**: See Exercises 9-11
- **Lost commits**: Use `git reflog`
- **Wrong branch**: See Exercises troubleshooting section

---

## 📈 Progress Tracking

### Self-Assessment Checklist

**Week 1**:
- [ ] Completed all basic exercises (1-20)
- [ ] Can use Git for personal projects
- [ ] Understand staging and committing
- [ ] Can view history effectively

**Week 2**:
- [ ] Completed branching exercises (21-35)
- [ ] Comfortable with branches
- [ ] Can resolve simple conflicts
- [ ] Understand merge vs rebase

**Week 3**:
- [ ] Completed collaboration exercises (36-50)
- [ ] Can work with remotes
- [ ] Understand team workflows
- [ ] Can participate in code reviews

**Production Ready**:
- [ ] Completed capital markets exercises (51-62)
- [ ] Can handle hotfixes
- [ ] Can manage releases
- [ ] Ready for team development

---

## 🎯 Next Steps After This Module

1. **Apply to Real Projects**
   - Use Git for all development work
   - Participate in code reviews
   - Follow team workflows

2. **Explore Advanced Topics**
   - Git hooks for automation
   - Git submodules
   - Git LFS for large files
   - CI/CD integration

3. **Platform-Specific Features**
   - GitHub Actions
   - GitLab CI/CD
   - Bitbucket Pipelines

4. **Continuous Improvement**
   - Stay updated with Git features
   - Learn from team practices
   - Share knowledge with juniors

---

## 📞 Support

### Resources Within This Module
- Theory documents for concepts
- Sample programs for examples
- Exercises for practice
- README files for guidance

### External Support
- Your team's Git standards
- Company Git administrator
- Online Git community
- Git documentation

---

## ✅ Completion Criteria

You've completed this module when you can:
1. ✅ Use Git daily without referring to notes
2. ✅ Create and manage branches confidently
3. ✅ Resolve merge conflicts independently
4. ✅ Collaborate effectively with the team
5. ✅ Follow company Git workflows
6. ✅ Troubleshoot common Git issues
7. ✅ Help junior developers with Git

---

## 🎊 Success Tips

**DO**:
✅ Practice daily with real projects
✅ Make small, frequent commits
✅ Write good commit messages
✅ Ask questions when unsure
✅ Learn from code reviews

**DON'T**:
❌ Wait until perfect to commit
❌ Commit broken code
❌ Force push to shared branches
❌ Ignore merge conflicts
❌ Skip code reviews

---

**Ready to Start?**

Begin with `Theory/01-Git-Fundamentals.md` and work through the module systematically!

**Good luck with your Git journey!** 🚀

---

*Last Updated: October 28, 2024*  
*Part of Capital Market Support System Training Program*

