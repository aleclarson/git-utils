
assertValid = require "assertValid"
Promise = require "Promise"
exec = require "exec"

require "./getBranch"
require "./hasBranch"
require "./isClean"
git = require "./core"

optionTypes =
  force: "boolean?"

module.exports =
git.setBranch = (modulePath, branchName, options = {}) ->
  assertValid modulePath, "string"
  assertValid branchName, "string"
  assertValid options, optionTypes

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
        {message} = error

        # 'git checkout' incorrectly prints to 'stderr'
        return if message.startsWith "Switched to branch"
        return if message.startsWith "Switched to a new branch"

        throw error
