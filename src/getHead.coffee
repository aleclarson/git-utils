
assertValid = require "assertValid"
Promise = require "Promise"
exec = require "exec"

require "./getBranch"
require "./hasBranch"
git = require "./core"

optionTypes =
  remote: "string?"
  message: "boolean?"

module.exports =
git.getHead = (modulePath, branchName, options = {}) ->
  assertValid modulePath, "string"
  assertValid branchName, "string?"
  assertValid options, optionTypes

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
      if options.remote
      then options.remote + "/" + branchName
      else branchName
    ]

    exec.async "git log", args, cwd: modulePath

    .then (stdout) ->

      separator = stdout.indexOf " "

      id = stdout.slice 0, separator

      if options.message
        return { id, message: stdout.slice separator + 1 }

      return id
