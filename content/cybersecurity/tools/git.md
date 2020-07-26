---
title: 'Git'
---


```bash
# log
git log
git reflog

# diff
git diff <hash1/tag1> <hash2/tag2>

# reset
git reset HEAD~1 # go back 1 commits
git reset --soft <hash> # keep recent changes in staging
git reset --mixed <hash> # keep recent changes not staged
git reset --hard <hash> # lose all changes, keep new files
git clean -df # delete untracked

# checkout
git checkout <hash> -- <file> # set working file to old file
git checkout <file>

# change last message, note hash also changes so issues with online sync
git commit --amend -m "<msg>"

# add file to previous commit
git add <file>
git commit --amend # and save

# move commits from one branch to another
git checkout <target_branch>
git cherry-pick <hash>
git checkout <first_branch>

# tags
git tag <tag> <hash> # use instead of hash, <hash> optional
git tag -a <tag> -m "<msg>" # add
git tag -d <tag> # delete
git show <tag>
git push tag <tag> # releases on github
git push --tags
git push origin -d <tag> # delete remote
git checkout -b <brance_name> <tag> # branch from tag

# get back in sync with online
git pull
git revert <erroneous commit hash> # creates new commit with undo, stays in log
git push # now back to original

# merging
git merge <branch> # from master, keeps all <branch> commits
git merge --squash <branch> # only final version of <branch>
git commit -m "<msg>"

# rebase -> only for local
git rebase <master> # from branch; pulls all new commits from master into branch

# ftp
git ftp init “URL”
git config git-ftp.url “url"
```

[Colt Steele Introduction to Git](Git%20dbbf6b1b2c9049668e5d244b5b63da4c/Colt%20Steele%20Introduction%20to%20Git%2040ce4b6f93a54efa97615194069dcc5a.md)