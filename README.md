
# git-utils v1.3.0 ![stable](https://img.shields.io/badge/stability-stable-4EBA0F.svg?style=flat)

- [addBranch](): Equivalent to `git checkout -b [branch-name]`.
- [addTag](): Equivalent to `git tag [tag-name]`.
- [assertClean](): Throws if the working tree has any changes.
- [assertRepo](): Throws if the given path is not a git repository.
- [assertStaged](): Throws if the staging area is empty.
- [changeBranch](): Equivalent to `git checkout [branch-name]`.
- [diff](): Equivalent to `git diff`.
- [findVersion](): Check if a version exists, and find its index in the array of versions.
- [getBranches](): Equivalent to `git branch`.
- [getCurrentBranch](): Get only the name of the current branch.
- [getHead](): Get the SHA of the HEAD.
- [getRemotes](): Equivalent to `git remote`.
- [getStatus](): Equivalent to `git status`.
- [getTags](): Equivalent to `git tag`.
- [getVersions](): Get a sorted array of valid versions.
- [hasBranch](): Returns true if the given branch name exists.
- [hasChanges](): Returns true if any uncommitted changes exist. Can be more specific.
- [isClean](): Returns true if the working tree has no changes.
- [isRepo](): Returns true if the given path is a git repository.
- [isStaged](): Returns true if the staging area is not empty.
- [mergeBranch](): Equivalent to `git merge`.
- [pick](): Equivalent to `git cherry-pick [commit-range]`.
- [popStash](): Equivalent to `git stash pop`.
- [pushCommit](): Equivalent to `git commit -m [message]`.
- [pushHead](): Equivalent to `git push`.
- [pushStash](): Equivalent to `git stash`.
- [pushTags](): Equivalent to `git push --tags`.
- [pushVersion](): Push a version to a remote repository.
- [removeBranch](): Equivalent to `git branch -D [branch-name]`.
- [removeTag](): Equivalent to `git tag -d [tag-name]`.
- [resetFile](): Equivalent to `git checkout [commit-ref] -- [file-path]`
- [setHead](): Equivalent to `git reset --hard [commit-ref]`.
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

### git.pushCommit(modulePath, message)

Create a new commit with the current branch's staged changes.

```coffee
git.addCommit modulePath, message
.then (commit) -> # Commit success! The SHA is returned.
.fail -> # Something went wrong?
```

### TODO

Write more documentation...
