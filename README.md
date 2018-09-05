# git-utils v1.4.0

Lightweight `git` automation for Javascript

All methods return a promise.

You can use `git-utils/lib/commit`-style imports to avoid loading the entire library.

### Commits
- [commit](): Equivalent to `git commit -m <message>`
- [getHead](): Get the SHA of the HEAD commit
- [pick](): Equivalent to `git cherry-pick <commitish>`
- [revertHead](): Undo the HEAD commit but keep its changes

### Branches
- [addBranch](): Equivalent to `git checkout -b <branch>`
- [deleteBranch](): Equivalent to `git branch -D <branch>`
- [getBranch](): Get the current branch name
- [getBranches](): Get the list of branch names (local or remote)
- [hasBranch](): Returns true if the given branch name exists
- [mergeBranch](): Equivalent to `git merge`
- [pushBranch](): Equivalent to `git push`
- [resetBranch](): Equivalent to `git reset <commitish>`
- [setBranch](): Change the current branch

### Tags
- [addTag](): Equivalent to `git tag <tag>`
- [deleteTag](): Equivalent to `git tag -d <tag>`
- [getTags](): Equivalent to `git tag`
- [pushTag](): Equivalent to `git push <remote> <tag>`
- [pushTags](): Equivalent to `git push --tags`

### Files
- [diff](): Equivalent to `git diff`
- [popStash](): Equivalent to `git stash pop`
- [pushStash](): Equivalent to `git stash`
- [removeFiles](): Equivalent to `git rm`
- [renameFile](): Equivalent to `git mv`
- [resetFiles](): Equivalent to `git checkout <commitish> -- <paths>`
- [stageFiles](): Equivalent to `git add`
- [unstageFiles](): Equivalent to `git reset -- <paths>`

### Status
- [getStatus](): Equivalent to `git status`
- [isClean](): Returns true if the working tree has no changes
- [isStaged](): Returns true if staged changes exist

### Remotes
- [getRemotes](): Equivalent to `git remote`

### Versions
- [getVersions](): Get a sorted array of valid versions

&nbsp;

## API Reference

#### `commit(repo: string, message: string): Promise<string>`

Create a commit from the staged changes.

The `message` can have any number of lines.

Resolves with the commit SHA.

&nbsp;

#### `getHead(repo: string, branch?: string, opts?: Object): Promise<mixed>`

Resolves with the SHA of the HEAD commit.

If no `branch` is given, use the current branch.

**Options:**
- `remote?: string`
- `message?: boolean`

The `remote` option lets you inspect a remote repository.
When undefined, the local repository is used.

The `message` option causes the resolved value to become
`{id, message}` where `id` is the SHA and `message` is the commit message.

&nbsp;

#### `pick(repo: string, commit: mixed, opts?: Object): Promise<void>`

Perform a cherry-pick.

The `commit` argument can be a SHA string or a `{from, to}` object
where both `from` and `to` are SHA strings.

**Options:**
- `strategy: string`

The `strategy` option must be either `"ours"` or `"theirs"`. This option
is used to auto-resolve merge conflicts.

&nbsp;

#### `revertHead(repo: string): Promise<void>`

Undo the last commit, but keep the changes in the staging area.

&nbsp;

#### `addBranch(repo: string, branch: string): Promise<void>`

Create a new branch based off the current branch.

&nbsp;

#### `deleteBranch(repo: string, branch: string, opts?: Object): Promise<void>`

Delete the given branch.

**Options:**
- `remote?: string`
- `remoteOnly?: boolean`

The `remote` option lets you delete both the local and remote branches of the same name.

The `remoteOnly` option lets you delete the remote branch only. By default, both the local and remote tags are deleted.

&nbsp;

#### `getBranch(repo: string)`

Get the current branch name.

&nbsp;

#### `getBranches(repo: string, remote?: string, opts?: Object): Promise<string[]>`

Get the local/remote array of branch names.

**Options:**
- `raw?: boolean`

The `raw` option skips the stdout parsing phase.

&nbsp;

#### `hasBranch(repo: string, branch: string, opts?: Object): Promise<boolean>`

Check if a local/remote branch name exists.

**Options:**
- `remote?: boolean`

The `remote` option lets you check a remote repository for a specific branch name.

&nbsp;

#### `mergeBranch(repo: string, opts: Object): Promise<void>`

Merge a branch into another.

**Options:**
- `ours?: string`
- `theirs: string`
- `strategy?: string`

The `ours` option lets you choose the local destination branch. Defaults to the current branch.

The `theirs` option lets you choose the local branch being merged. This is *required*.

The `strategy` option lets you auto-resolve any merge conflicts. If defined, it must be `"ours"` or `"theirs"`.

&nbsp;

#### `pushBranch(repo: string, opts?: Object): Promise<void>`

Push the current branch to a remote repository.

**Options:**
- `force?: boolean`
- `remote?: string`
- `branch?: string`
- `keyPath?: string`
- `upstream?: boolean`
- `listener?: (stderr?: string, stdout?: string) => void`

The `force` option overwrites the remote branch instead of trying to cleanly append to its commit history.

The `remote` option lets you choose which remote repository is pushed to. Defaults to `origin`.

The `branch` option lets you choose which remote branch is pushed to. Defaults to the name of the current local branch.

The `keyPath` option is the file path to an SSH key. This is used to define the `GIT_SSH_COMMAND` environment variable.

The `upstream` option sets the upstream branch of the current local branch to the `branch` option.

The `listener` option is called as output is piped from the `git push` command.

&nbsp;

#### `resetBranch(repo: string, commit?: string, opts?: Object): Promise<void>`

Set the HEAD commit of the current branch.

The `commit` argument defaults to `"HEAD"`. If null, the entire commit history is thrown out for the current branch.

**Options:**
- `mode?: string`

The `mode` option must be `"soft"`, `"hard"`, `"mixed"`, `"merge"`, or `"keep"`. Defaults to `"mixed"`.

The `"soft"` mode preserves the changes between the given `commit` and the previous HEAD commit. Any staged changes are kept staged.

The `"hard"` mode erases all changes between the given `commit` and the previous HEAD commit.

The `"mixed"` mode preserves the changes between the given `commit` and the previous HEAD commit. Any staged changes are unstaged.

The other modes are described in the `git` manual. Run `man git-reset` in the terminal.

&nbsp;

#### `setBranch(repo: string, branch: string, opts?: Object): Promise<string>`

Checkout the given `branch` name.

Resolves with the current branch name. May not be the given `branch` name depending on which options are used.

If the given `branch` exists, the current branch must have no changes.

If the given `branch` does *not* exist, it's created with the commit history (and any uncommitted changes) of the current branch.

**Options:**
- `force?: boolean`
- `ifExists?: boolean`
- `mustExist?: boolean`

The `force` option lets you erase any uncommitted changes before switching branches.

The `ifExists` option avoids creating a new branch if the given `branch` does *not* exist.

The `mustExist` option will throw an error if the given `branch` does *not* exist.

&nbsp;

#### `addTag(repo: string, tag: string, opts?: Object): Promise<void>`

Create a tag for the current HEAD commit.

**Options:**
- `force?: boolean`

The `force` option lets you overwrite an existing tag with the same name.

&nbsp;

#### `deleteTag(repo: string, tag: string, opts?: Object): Promise<void>`

Delete a local/remote tag.

**Options:**
- `remote?: string`
- `remoteOnly?: boolean`

The `remote` option lets you delete the given `tag` from a remote repository.

The `remoteOnly` option lets you delete the remote tag only. By default, both the local and remote tags are deleted.

&nbsp;

#### `getTags(repo: string)`

Get the array of local tags.

&nbsp;

#### `pushTag(repo: string, tag: string, opts?: Object): Promise<void>`

Push a local tag to a remote repository.

**Options:**
- `force?: boolean`
- `remote?: string`

The `force` option lets you overwrite an existing remote tag of the same name.

The `remote` option lets you choose the remote repository to push to. Defaults to `"origin"`.

&nbsp;

#### `pushTags(repo: string, opts?: Object): Promise<void>`

Push all local tags to a remote repository.

**Options:**
- `force?: boolean`
- `remote?: string`

The `force` option lets you overwrite any existing remote tags that clash with one of the local tags.

The `remote` option lets you choose the remote repository to push to. Defaults to `"origin"`.

&nbsp;

#### `diff(repo: string, fromCommit: string, toCommit?: string): Promise<Array>`

Get an array of `{status: string, path: string}` objects for each file modified, added, or deleted by the inclusive range of given commits.

The `toCommit` argument defaults to `"HEAD"`.

&nbsp;

#### `popStash(repo: string): Promise<void>`

Equivalent to `git stash pop`.

&nbsp;

#### `pushStash(repo: string, opts?: Object): Promise<void>`

Equivalent to `git stash`.

**Options:**
- `keepStaged?: boolean`
- `keepUntracked?: boolean`

The `keepStaged` option avoids stashing any staged changes.

The `keepUntracked` option avoids stashing any untracked files.

&nbsp;

#### `removeFiles(repo: string, files: mixed, opts?: Object): Promise<void>`

Remove files and stage them.

The `files` argument must be a file path or an array of file paths.

**Options:**
- `cached?: boolean`
- `recursive?: boolean`

The `cached` option lets you remove only the paths that have staged changes.

The `recursive` option lets you remove directories.

&nbsp;

#### `renameFile(repo: string, oldName: string, newName: string): Promise<void>`

Rename a file and stage it.

The given filenames can be relative or absolute, but cannot exist outside the repository.

&nbsp;

#### `revertFiles(repo: string, files: mixed, opts?: Object): Promise<string>`

Revert files to a specific commit.

Resolves with the stdout of the `git checkout` command.

The `files` argument must be a file path or an array of file paths.

**Options:**
- `commit?: string`
- `dryRun?: boolean`

The `commit` option lets you choose which commit to revert to. Defaults to `"HEAD"`.

The `dryRun` option avoids actually changing any files.

&nbsp;

#### `stageFiles(repo: string, files: mixed): Promise<void>`

Stage the given file paths.

The `files` argument must be a file path or an array of file paths.

&nbsp;

#### `unstageFiles(repo: string, files: mixed): Promise<void>`

Unstage the given file paths.

The `files` argument must be a file path or an array of file paths.

&nbsp;

#### `getStatus(repo: string, opts?: Object): Promise<mixed>`

Get the status of the current branch.

By default, the return value is an object like the following:
- `staged: Object`
- `tracked: Object`
- `untracked: Array`
- `unmerged: Array`

The `staged` object has an array for every status (eg: `"M"` for modified, `"A"` for added, etc). These arrays contain an object for every staged file with that status.

The `tracked` object has identical structure to the `staged` object, except it contains objects for tracked files (excluding staged files).

The `untracked` and `unmerged` arrays also contain file objects.

**Options:**
- `raw?: boolean`
- `remote?: boolean`

The `raw` option changes the return value to the stdout of the `git status` command. It does nothing when the `remote` option is true.

The `remote` option changes the return value to `{branch: string, ahead: number, behind: number}` based on the upstream branch.

&nbsp;

#### `isClean(repo: string): Promise<boolean>`

Resolves to true if the repository has no uncommitted changes.

&nbsp;

#### `isStaged(repo: string)`

Resolves to true if the repository has staged changes.

&nbsp;

#### `getRemotes(repo: string)`

Get the array of remote repositories, where each repository is an object like `{push: string, fetch: string}`.

&nbsp;

#### `getVersions(repo: string)`

Get the *sorted* array of tags that use semantic versioning.
