
assertTypes = require "assertTypes"
assertType = require "assertType"
Promise = require "Promise"
Random = require "random"
isType = require "isType"
assert = require "assert"
path = require "path"
sync = require "sync"
log = require "log"
fs = require "io/sync"

MergeStrategy = require "./MergeStrategy"
git =
  addBranch: require "./addBranch"
  commit: require "./commit"
  deleteBranch: require "./deleteBranch"
  deleteFile: require "./deleteFile"
  getBranch: require "./getBranch"
  isClean: require "./isClean"
  pick: require "./pick"
  mergeBranch: require "./mergeBranch"
  renameFile: require "./renameFile"
  resetBranch: require "./resetBranch"
  setBranch: require "./setBranch"
  stageFiles: require "./stageFiles"

optionTypes =
  ours: String.Maybe # Used to get an absolute path from each `MergedFile`. Defaults to `options.modulePath`.
  theirs: String # Used to get a relative path for each `MergedFile`.
  rename: Object # Which files (or directories) should be renamed?
  unlink: Array # Which files (or directories) should be deleted?
  merge: Object # Which files (or directories) should be merged in?
  strategy: MergeStrategy.Maybe # The default merging strategy for each changed file. Defaults to none.
  verbose: Boolean.Maybe # Should events be logged to stdout?

module.exports = (modulePath, options) ->

  assertType modulePath, String
  assertTypes options, optionTypes

  options.ours ?= modulePath

  renamedPaths = options.rename
  renamedCount = Object.keys(renamedPaths).length

  unlinkedPaths = options.unlink
  unlinkedCount = unlinkedPaths.length

  mergedPaths = options.merge
  mergedCount = Object.keys(mergedPaths).length

  if not (renamedCount + unlinkedCount + mergedCount)
    return Promise()

  state =
    startBranch: null
    tmpBranch: Random.id()
    renameCommit: null
    mergeCommit: null

  Promise.assert "The current branch cannot have any uncommitted changes!", ->
    git.isClean modulePath

  # Remember the starting branch.
  .then ->
    git.getBranch modulePath
    .then (currentBranch) ->
      state.startBranch = currentBranch

  # Create a temporary branch.
  .then ->
    git.addBranch modulePath, state.tmpBranch

  # Squash the commit history.
  .then ->
    git.resetBranch modulePath, null
    .then -> git.stageFiles modulePath, "*"
    .then -> git.commit modulePath, "squash commit"

  # Perform renames and unlinks.
  .then ->
    Promise.chain renamedPaths, (newPath, oldPath) ->
      assertType newPath, String
      newFile = path.resolve options.ours, newPath
      assert not fs.exists(newFile), "Cannot rename because another file is already named: '#{newFile}'"
      oldFile = path.resolve options.ours, oldPath
      if options.verbose
        log.moat 1
        log.green "rename "
        log.white oldFile
        log.moat 0
        log.green "    to "
        log.white newFile
        log.moat 1
      git.renameFile modulePath, oldFile, newFile

    .then ->
      Promise.chain unlinkedPaths, (filePath) ->
        assertType filePath, String
        ourFile = path.resolve options.ours, filePath
        assert fs.exists(ourFile), "Cannot unlink a file that does not exist: '#{ourFile}'"
        if options.verbose
          log.moat 1
          log.red "unlink "
          log.white ourFile
          log.moat 1
        git.deleteFile modulePath, ourFile

    .then -> git.commit modulePath, "rename commit"
    .then (commit) -> state.renameCommit = commit

  # Clear each file that will be modified by the merge.
  .then ->
    sync.each mergedPaths, (ourPath, theirPath) ->

      ourPath = theirPath if ourPath is yes
      ourFile = path.resolve options.ours, ourPath
      return if not fs.exists ourFile
      theirFile = path.resolve options.theirs, theirPath

      if fs.isFile ourFile
        assert fs.isFile(theirFile), "Expected a file: '#{theirFile}'"
        return fs.write ourFile, ""

      assert fs.isDir(theirFile), "Expected a directory: '#{theirFile}'"
      for theirChild in fs.match path.join theirFile, "**/*"
        continue if fs.isDir theirChild
        ourChild = path.resolve ourFile, path.relative theirFile, theirChild
        continue if not fs.exists ourChild
        assert not fs.isDir(ourChild), "Cannot use file to overwrite directory: '#{ourChild}'"
        fs.write ourChild, ""
      return

    git.stageFiles modulePath, "*"
    .then -> git.commit modulePath, "clear files that will be merged into"

  # Overwrite each cleared file with the merged file.
  .then ->
    sync.each mergedPaths, (ourPath, theirPath) ->

      ourPath = theirPath if ourPath is yes

      theirFile = path.resolve options.theirs, theirPath
      assert fs.exists(theirFile), "Cannot merge a file that does not exist: '#{theirFile}'"

      ourFile = path.resolve options.ours, ourPath

      if options.verbose
        log.moat 1
        log.yellow "merge "
        log.white theirFile
        log.moat 0
        log.yellow " into "
        log.white ourFile
        log.moat 1

      fs.copy theirFile, ourFile,
        recursive: yes
        force: yes

    git.stageFiles modulePath, "*"
    .then -> git.commit modulePath, "merge commit"
    .then (commit) -> state.mergeCommit = commit

  # Always end up back on the starting branch.
  .always ->
    git.setBranch modulePath, state.startBranch,
      force: yes

  # Apply the rename commit to the starting branch.
  .then ->
    git.pick modulePath, state.renameCommit

  # Merge the changes into the starting branch.
  .then ->
    git.pick modulePath,
      from: state.mergeCommit + "^"
      to: state.mergeCommit

  # Always delete the temporary branch.
  .always ->
    git.deleteBranch modulePath, state.tmpBranch
