# git-utils v2.2.0

Lightweight `git` automation for Javascript

All methods return a promise.

You can use `git-utils/lib/commit`-style imports to avoid loading the entire library.

### Branches
- [addBranch][b1]: Equivalent to `git checkout -b <branch>`
- [deleteBranch][b2]: Equivalent to `git branch -D <branch>`
- [getBranch][b3]: Get the current branch name
- [getBranches][b4]: Get the list of branch names (local or remote)
- [hasBranch][b5]: Returns true if the given branch name exists
- [mergeBranch][b6]: Equivalent to `git merge`
- [pushBranch][b7]: Equivalent to `git push`
- [resetBranch][b8]: Equivalent to `git reset <commitish>`
- [setBranch][b9]: Change the current branch

[b1]: #addbranchrepo-string-branch-string-promisevoid
[b2]: #deletebranchrepo-string-branch-string-opts-object-promisevoid
[b3]: #getbranchrepo-string
[b4]: #getbranchesrepo-string-opts-object-promisemixed
[b5]: #hasbranchrepo-string-branch-string-opts-object-promiseboolean
[b6]: #mergebranchrepo-string-opts-object-promisevoid
[b7]: #pushbranchrepo-string-opts-object-promisevoid
[b8]: #resetbranchrepo-string-commit-string-opts-object-promisevoid
[b9]: #setbranchrepo-string-branch-string-opts-object-promisestring

### Commits
- [clone][c5]: Equivalent to `git clone`
- [commit][c1]: Equivalent to `git commit -m <message>`
- [getHead][c2]: Get the SHA of the HEAD commit
- [pick][c3]: Equivalent to `git cherry-pick <commitish>`
- [revertHead][c4]: Undo the HEAD commit but keep its changes

[c1]: #commitrepo-string-message-string-promisestring
[c2]: #getheadrepo-string-branch-string-opts-object-promisemixed
[c3]: #pickrepo-string-commit-mixed-opts-object-promisevoid
[c4]: #revertheadrepo-string-promisevoid
[c5]: #clonerepo-string-src-string-opts-object-promise-void

### Files
- [diff][f1]: Equivalent to `git diff`
- [popStash][f2]: Equivalent to `git stash pop`
- [pushStash][f3]: Equivalent to `git stash`
- [removeFiles][f4]: Equivalent to `git rm`
- [renameFile][f5]: Equivalent to `git mv`
- [resetFiles][f6]: Equivalent to `git checkout <commitish> -- <paths>`
- [stageFiles][f7]: Equivalent to `git add`
- [unstageFiles][f8]: Equivalent to `git reset -- <paths>`

[f1]: #diffrepo-string-fromcommit-string-tocommit-string-promisearray
[f2]: #popstashrepo-string-promisevoid
[f3]: #pushstashrepo-string-opts-object-promisevoid
[f4]: #removefilesrepo-string-files-mixed-opts-object-promisevoid
[f5]: #renamefilerepo-string-oldname-string-newname-string-promisevoid
[f6]: #revertfilesrepo-string-files-mixed-opts-object-promisestring
[f7]: #stagefilesrepo-string-files-mixed-promisevoid
[f8]: #unstagefilesrepo-string-files-mixed-promisevoid

### Remotes
- [getRemotes][r1]: Equivalent to `git remote`

[r1]: #getremotesrepo-string

### Status
- [getStatus][s1]: Equivalent to `git status`
- [isClean][s2]: Returns true if the working tree has no changes
- [isStaged][s3]: Returns true if staged changes exist

[s1]: #getstatusrepo-string-opts-object-promisemixed
[s2]: #iscleanrepo-string-promiseboolean
[s3]: #isstagedrepo-string

### Tags
- [addTag][t1]: Equivalent to `git tag <tag>`
- [deleteTag][t2]: Equivalent to `git tag -d <tag>`
- [getTags][t3]: Equivalent to `git tag`
- [pushTag][t4]: Equivalent to `git push <remote> <tag>`
- [pushTags][t5]: Equivalent to `git push --tags`

[t1]: #addtagrepo-string-tag-string-opts-object-promisevoid
[t2]: #deletetagrepo-string-tag-string-opts-object-promisevoid
[t3]: #gettagsrepo-string-opts-object-promisearray
[t4]: #pushtagrepo-string-tag-string-opts-object-promisevoid
[t5]: #pushtagsrepo-string-opts-object-promisevoid

### Versions
- [getVersions][v1]: Get a sorted array of valid versions

[v1]: #getversionsrepo-string-opts-object-promisearray

&nbsp;

## API Reference

#### `addBranch(repo: string, branch: string): Promise<void>`

Create a new branch based off the current branch.

[Back to top](#readme)

&nbsp;

#### `deleteBranch(repo: string, branch: string, opts?: Object): Promise<void>`

Delete the given branch.

**Options:**
- `remote?: string`
- `remoteOnly?: boolean`

The `remote` option lets you delete both the local and remote branches of the same name.

The `remoteOnly` option lets you delete the remote branch only. By default, both the local and remote tags are deleted.

[Back to top](#readme)

&nbsp;

#### `getBranch(repo: string)`

Get the current branch name.

[Back to top](#readme)

&nbsp;

#### `getBranches(repo: string, opts?: Object): Promise<mixed>`

Get an array of local/remote branch names.

**Options:**
- `raw?: boolean`
- `remote?: string`

The `raw` option changes the return value to the stdout of the `git branch` command.

The `remote` option lets you inspect the branches of a remote repository.

[Back to top](#readme)

&nbsp;

#### `hasBranch(repo: string, branch: string, opts?: Object): Promise<boolean>`

Check if a local/remote branch name exists.

**Options:**
- `remote?: boolean`

The `remote` option lets you check a remote repository for a specific branch name.

[Back to top](#readme)

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

[Back to top](#readme)

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

[Back to top](#readme)

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

[Back to top](#readme)

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

[Back to top](#readme)

&nbsp;
---

#### `clone(repo: string, src: string, opts?: Object): Promise<void>`

Clone a local/remote repository.

The `src` argument can be a URL or an absolute path to a local directory.

**Options:**
- `dest?: string`
- `depth?: number`
- `branch?: string`

The `dest` option lets you choose the local path to the cloned repository.

The `depth` option lets you create a shallow clone.

The `branch` option lets you choose which branch to checkout.

&nbsp;

#### `commit(repo: string, message: string): Promise<string>`

Create a commit from the staged changes.

The `message` can have any number of lines.

Resolves with the commit SHA.

[Back to top](#readme)

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

[Back to top](#readme)

[Back to top](#readme)

&nbsp;

#### `pick(repo: string, commit: mixed, opts?: Object): Promise<void>`

Perform a cherry-pick.

The `commit` argument can be a SHA string or a `{from, to}` object
where both `from` and `to` are SHA strings.

**Options:**
- `strategy: string`

The `strategy` option must be either `"ours"` or `"theirs"`. This option
is used to auto-resolve merge conflicts.

[Back to top](#readme)

&nbsp;

#### `revertHead(repo: string): Promise<void>`

Undo the last commit, but keep the changes in the staging area.

[Back to top](#readme)

&nbsp;
---

#### `diff(repo: string, fromCommit: string, toCommit?: string): Promise<Array>`

Get an array of `{status: string, path: string}` objects for each file modified, added, or deleted by the inclusive range of given commits.

The `toCommit` argument defaults to `"HEAD"`.

[Back to top](#readme)

&nbsp;

#### `popStash(repo: string): Promise<void>`

Equivalent to `git stash pop`.

[Back to top](#readme)

&nbsp;

#### `pushStash(repo: string, opts?: Object): Promise<void>`

Equivalent to `git stash`.

**Options:**
- `keepStaged?: boolean`
- `keepUntracked?: boolean`

The `keepStaged` option avoids stashing any staged changes.

The `keepUntracked` option avoids stashing any untracked files.

[Back to top](#readme)

&nbsp;

#### `removeFiles(repo: string, files: mixed, opts?: Object): Promise<void>`

Remove files and stage them.

The `files` argument must be a file path or an array of file paths.

**Options:**
- `cached?: boolean`
- `recursive?: boolean`

The `cached` option lets you remove only the paths that have staged changes.

The `recursive` option lets you remove directories.

[Back to top](#readme)

&nbsp;

#### `renameFile(repo: string, oldName: string, newName: string): Promise<void>`

Rename a file and stage it.

The given filenames can be relative or absolute, but cannot exist outside the repository.

[Back to top](#readme)

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

[Back to top](#readme)

&nbsp;

#### `stageFiles(repo: string, files: mixed): Promise<void>`

Stage the given file paths.

The `files` argument must be a file path or an array of file paths.

[Back to top](#readme)

&nbsp;

#### `unstageFiles(repo: string, files: mixed): Promise<void>`

Unstage the given file paths.

The `files` argument must be a file path or an array of file paths.

[Back to top](#readme)

&nbsp;
---

#### `getRemotes(repo: string): Promise<Array>`

Get the array of remote repositories, where each repository is an object like `{push: string, fetch: string}`.

[Back to top](#readme)

&nbsp;
---

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

[Back to top](#readme)

&nbsp;

#### `isClean(repo: string): Promise<boolean>`

Resolves to true if the repository has no uncommitted changes.

[Back to top](#readme)

&nbsp;

#### `isStaged(repo: string): Promise<boolean>`

Resolves to true if the repository has staged changes.

[Back to top](#readme)

&nbsp;
---

#### `addTag(repo: string, tag: string, opts?: Object): Promise<void>`

Create a tag for the current HEAD commit.

**Options:**
- `force?: boolean`

The `force` option lets you overwrite an existing tag with the same name.

[Back to top](#readme)

&nbsp;

#### `deleteTag(repo: string, tag: string, opts?: Object): Promise<void>`

Delete a local/remote tag.

**Options:**
- `remote?: string`
- `remoteOnly?: boolean`

The `remote` option lets you delete the given `tag` from a remote repository.

The `remoteOnly` option lets you delete the remote tag only. By default, both the local and remote tags are deleted.

[Back to top](#readme)

&nbsp;

#### `getTags(repo: string, opts?: Object): Promise<Array>`

Get an array of local/remote tag names.

**Options:**
- `remote?: string`
- `commits?: boolean`

The `remote` option lets you fetch tags from a remote repository.

The `commits` option changes the return value to an array of `{tag: string, commit: string}` objects.

[Back to top](#readme)

&nbsp;

#### `pushTag(repo: string, tag: string, opts?: Object): Promise<void>`

Push a local tag to a remote repository.

**Options:**
- `force?: boolean`
- `remote?: string`

The `force` option lets you overwrite an existing remote tag of the same name.

The `remote` option lets you choose the remote repository to push to. Defaults to `"origin"`.

[Back to top](#readme)

&nbsp;

#### `pushTags(repo: string, opts?: Object): Promise<void>`

Push all local tags to a remote repository.

**Options:**
- `force?: boolean`
- `remote?: string`

The `force` option lets you overwrite any existing remote tags that clash with one of the local tags.

The `remote` option lets you choose the remote repository to push to. Defaults to `"origin"`.

[Back to top](#readme)

&nbsp;
---

#### `getVersions(repo: string, opts?: Object): Promise<Array>`

Get the *sorted* array of tags that use semantic versioning.

**Options:**
- `remote?: string`

The `remote` option lets you fetch tags that use semantic versioning from a remote repository.

[Back to top](#readme)
