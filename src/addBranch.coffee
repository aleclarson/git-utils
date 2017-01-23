
# TODO: Test against existing branch name.

assertType = require "assertType"
exec = require "exec"

git = require "./core"

module.exports =
git.addBranch = (modulePath, branchName) ->

  assertType modulePath, String
  assertType branchName, String

  exec.async "git checkout -b " + branchName, {cwd: modulePath}

  .then -> branchName

  .fail (error) ->

    if /Switched to a new branch/.test error.message
      return # 'git checkout' incorrectly prints to stderr

    throw error
