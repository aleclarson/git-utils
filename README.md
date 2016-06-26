
# git-utils 1.0.0 ![stable](https://img.shields.io/badge/stability-stable-4EBA0F.svg?style=flat)

- [addBranch](): Equivalent to `git checkout -b [branch-name]`.
- [addCommit](): Equivalent to `git commit -m [message]`.
- [addTag](): Equivalent to `git tag [tag-name]`.
- [assertClean](): Fails if the current branch has any uncommitted changes.
- [assertRepo](): Fails if the given path is not a git repository.
- [assertStaged](): Fails if the current branch has no staged changes.
- [changeBranch](): Equivalent to `git checkout [branch-name]`.
- [diff](): Equivalent to `git diff`.
- [findVersion](): Check if a version exists, and find its index in the array of versions.
- [getBranches](): Equivalent to `git branch`.
- [getCurrentBranch](): Get only the name of the current branch.
- [getLatestCommit](): Get the SHA of the HEAD.
- [getRemotes](): Equivalent to `git remote`.
- [getStatus](): Equivalent to `git status`.
- [getTags](): Equivalent to `git tag`.
- [getVersions](): Get a sorted array of valid versions.
- [hasBranch](): Returns true if the given branch name exists.
- [hasChanges](): Returns true if any uncommitted changes exist. Can be more specific.
- [isRepo](): Returns true if the given path is a git repository.
- [mergeBranch](): Equivalent to `git merge`.
- [pick](): Equivalent to `git cherry-pick`.
- [popStash](): Equivalent to `git stash pop`.
- [pushChanges](): Equivalent to `git push`.
- [pushStash](): Equivalent to `git stash`.
- [pushTags](): Equivalent to `git push --tags`.
- [pushVersion](): Push a version to a remote repository.
- [removeBranch](): Equivalent to `git branch -D`.
- [removeTag](): Equivalent to `git tag -d`.
- [stageAll](): Add all changes to the staging area.
- [undoLatestCommit](): Equivalent to `git reset`.
- [unstageAll](): Remove all changes from the staging area.

```coffee
git = require "git-utils"
```

### git.addBranch(modulePath, branchName)

Create a new branch based off the current branch.

```coffee
git.addBranch modulePath, branchName
.then -> # Branch created and active.
.fail -> # Branch might already exist; or something else...
```

### git.addCommit(modulePath, message)

Create a new commit with the current branch's staged changes.

```coffee
git.addCommit modulePath, message
.then (commit) -> # Commit success! The SHA is returned.
.fail -> # Something went wrong?
```

### TODO

Write more documentation...
