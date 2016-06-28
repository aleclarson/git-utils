
assertTypes = require "assertTypes"
assertType = require "assertType"
Promise = require "Promise"
exec = require "exec"

git =
  getBranch: require "./getBranch"
  hasBranch: require "./hasBranch"

optionTypes =
  remote: String.Maybe
  message: Boolean.Maybe

module.exports = (modulePath, branchName, options = {}) ->

  assertType modulePath, String
  assertType branchName, String.Maybe
  assertTypes options, optionTypes

  return Promise.try ->

    if branchName
      return git.hasBranch modulePath, branchName
      .then (hasBranch) ->
        return if hasBranch
        branchName = null

    git.getBranch modulePath
    .then (currentBranch) ->
      branchName = currentBranch

  .then ->

    if branchName is null
      return null

    args = [
      "-1"
      "--pretty=oneline"
      (options.remote or "origin") + "/" + branchName
    ]

    exec.async "git log", args, cwd: modulePath

    .then (stdout) ->

      separator = stdout.indexOf " "

      id = stdout.slice 0, separator

      if options.message
        return { id, message: stdout.slice separator + 1 }

      return id
