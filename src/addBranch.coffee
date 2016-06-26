
assertTypes = require "assertTypes"
isType = require "isType"
exec = require "exec"
log = require "log"

optionTypes =
  modulePath: String
  branchName: String

# TODO: Test against existing branch name.
module.exports = (options) ->

  if isType options, String
    options =
      modulePath: arguments[0]
      branchName: arguments[1]

  assertTypes options, optionTypes

  { modulePath, branchName } = options

  exec "git checkout -b " + branchName, { cwd: modulePath }

  .fail (error) ->

    if /Switched to a new branch/.test error.message
      return # 'git checkout' incorrectly prints to stderr

    throw error
