
assertTypes = require "assertTypes"
isType = require "isType"
exec = require "exec"

optionTypes =
  modulePath: String
  branchName: String
  remoteName: String.Maybe

module.exports = (options) ->

  if isType options, String
    options =
      modulePath: arguments[0]
      branchName: arguments[1]
      remoteName: arguments[2]

  assertTypes options, optionTypes

  { modulePath, branchName, remoteName } = options

  exec "git branch -D #{branchName}", cwd: modulePath

  .then ->

    return if not remoteName

    exec "git push #{remoteName} --delete #{branchName}", cwd: modulePath

  .fail (error) ->

    expected = "error: branch '#{branchName}' not found."
    if error.message is expected
      throw Error "The given branch does not exist!"

    expected = "error: Cannot delete the branch '#{branchName}' which you are currently on."
    if error.message is expected
      throw Error "Cannot delete the current branch!"

    lines = error.message.split log.ln
    expected = "fatal: '#{branchName}' does not appear to be a git repository"
    if lines[0] is expected
      throw Error "The given remote repository does not exist!"

    throw error
