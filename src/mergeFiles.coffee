
assertTypes = require "assertTypes"
assertType = require "assertType"
ArrayOf = require "ArrayOf"
Promise = require "Promise"
Random = require "random"
isType = require "isType"
assert = require "assert"
Shape = require "Shape"
exec = require "exec"
path = require "path"
sync = require "sync"
log = require "log"
fs = require "io/sync"

MergeStrategy = require "./MergeStrategy"
git =
  getBranch: require "./getBranch"
  setBranch: require "./setBranch"
  removeBranch: require "./removeBranch"
  assertClean: require "./assertClean"
  mergeBranch: require "./mergeBranch"
  removeFile: require "./removeFile"
  renameFile: require "./renameFile"
  addBranch: require "./addBranch"
  pushCommit: require "./pushCommit"
  stageAll: require "./stageAll"

optionTypes =
  modulePath: String # Which repository are we using?
  ours: String.Maybe # Used to get an absolute path from each `MergedFile`. Defaults to `options.modulePath`.
  theirs: String # Used to get a relative path for each `MergedFile`.
  files: Array # Which files do we merge, and how?
  strategy: MergeStrategy.Maybe # The default merging strategy for each changed file. Defaults to none.
  verbose: Boolean.Maybe # Should events be logged to stdout?

module.exports = (options) ->

  assertTypes options, optionTypes

  { modulePath, ours, theirs, files, strategy, verbose } = options

  if not files.length
    return Promise()

  ours ?= modulePath

  # Make sure we don't fuck anything up.
  git.assertClean modulePath

  # Get the current branch so we can switch back at the end.
  .then -> git.getBranch modulePath
  .then (currentBranch) ->

    # Create a temporary branch for merging.
    tmpBranch = Random.id()
    git.addBranch modulePath, tmpBranch
    .then ->

      if verbose
        log.moat 1
        log.cyan "Merging files..."
        log.moat 1

      # Apply each of the merged files in order.
      Promise.chain files, (file, index) ->

        if isType file, String
          file = { merge: file }

        else if file.unlink
          ourFile = path.resolve ours, file.unlink
          assert fs.isFile(ourFile), "Cannot unlink a file that does not exist: '#{ourFile}'"
          if verbose
            log.moat 1
            log.red "unlink "
            log.white ourFile
            log.moat 1
          return git.removeFile modulePath, ourFile

        if file.rename
          ourFile = path.resolve ours, file.to
          assert not fs.isFile(ourFile), "Cannot rename because another file is already named: '#{ourFile}'"
          renamedFile = path.resolve ours, file.rename
          if verbose
            log.moat 1
            log.green "rename "
            log.white renamedFile
            log.moat 0
            log.green "    to "
            log.white ourFile
            log.moat 1
          return git.renameFile modulePath, renamedFile, ourFile

        if file.merge
          theirFile = path.resolve theirs, file.merge
          assert fs.isFile(theirFile), "Cannot merge a file that does not exist: '#{theirFile}'"
          ourFile = path.resolve ours, file.merge
          if verbose
            log.moat 1
            log.yellow "merge "
            log.white theirFile
            log.moat 0
            log.yellow " into "
            log.white ourFile
            log.moat 1
          fs.copy theirFile, ourFile
          return

    # Commit all of the changes.
    .then ->
      if verbose
        log.moat 1
        log.cyan "Staging changes..."
        log.moat 1
      git.stageAll modulePath
      .then -> git.pushCommit modulePath, Random.id()

    # Always switch back to the `currentBranch`.
    .always ->
      git.setBranch modulePath, currentBranch

    # Merge the temporary branch into the current branch.
    .then ->
      git.mergeBranch { modulePath, theirs: tmpBranch, strategy }
      .then ->
        return if not verbose
        log.moat 1
        log.cyan "Files merged successfully!"
        log.moat 1

    # Always delete the temporary branch.
    .always ->
      git.removeBranch modulePath, tmpBranch
