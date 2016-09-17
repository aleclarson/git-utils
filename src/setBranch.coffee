
assertTypes = require "assertTypes"
assertType = require "assertType"
Promise = require "Promise"
exec = require "exec"

git =
  getBranch: require "./getBranch"
  hasBranch: require "./hasBranch"
  isClean: require "./isClean"

optionTypes =
  force: Boolean.Maybe

module.exports = (modulePath, branchName, options = {}) ->

  assertType modulePath, String
  assertType branchName, String
  assertTypes options, optionTypes

  git.getBranch modulePath

  .then (currentBranch) ->

    if currentBranch is branchName
      return currentBranch

    # Unless force is applied, throw if the branch isnt clean.
    Promise.try ->
      return if options.force
      git.isClean modulePath
      .then (clean) ->
        clean or throw Error "The current branch has uncommitted changes!"

    .then -> git.hasBranch modulePath, branchName
    .then (branchExists) ->

      args = [ branchName ]

      # Create a new branch, if one doesnt exist.
      # Throw an error unless `options.force` is true.
      if not branchExists
        options.force or throw Error "Invalid branch name!"
        args.unshift "-b"

      exec.async "git checkout", args, cwd: modulePath

      .fail (error) ->

        # 'git checkout' incorrectly prints to 'stderr'
        return if /Switched to branch/.test error.message

        throw error
