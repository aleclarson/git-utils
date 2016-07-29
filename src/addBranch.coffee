
assertType = require "assertType"
exec = require "exec"

# TODO: Test against existing branch name.
module.exports = (modulePath, branchName) ->

  assertType modulePath, String
  assertType branchName, String

  exec.async "git checkout -b " + branchName, { cwd: modulePath }

  .then -> branchName

  .fail (error) ->

    if /Switched to a new branch/.test error.message
      return # 'git checkout' incorrectly prints to stderr

    throw error
