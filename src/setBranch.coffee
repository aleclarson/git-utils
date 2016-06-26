
assertTypes = require "assertTypes"
isType = require "isType"
exec = require "exec"

git =
  getBranch: require "./getBranch"
  hasBranch: require "./hasBranch"
  isClean: require "./isClean"

optionTypes =
  modulePath: String
  branchName: String
  force: Boolean.Maybe

module.exports = (options) ->

  if isType options, String
    options =
      modulePath: arguments[0]
      branchName: arguments[1]

  assertTypes options, optionTypes

  { modulePath, branchName, force } = options

  git.getBranch modulePath

  .then (currentBranch) ->

    if currentBranch is branchName
      return currentBranch

    git.isClean modulePath

    .then (clean) ->

      if not clean
        throw Error "The current branch has uncommitted changes!"

      git.hasBranch { modulePath, branchName }

    .then (branchExists) ->

      args = [ branchName ]

      if not branchExists

        if not force
          throw Error "Invalid branch name!"

        args.unshift "-b"

      exec "git checkout", args, cwd: modulePath

      .fail (error) ->

        if /Switched to branch/.test error.message
          return # 'git checkout' incorrectly prints to 'stderr'

        throw error
