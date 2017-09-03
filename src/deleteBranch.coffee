
assertValid = require "assertValid"
exec = require "exec"
os = require "os"

git = require "./core"

optionTypes =
  remote: "string?"

module.exports =
git.deleteBranch = (modulePath, branchName, options = {}) ->
  assertValid modulePath, "string"
  assertValid branchName, "string"
  assertValid options, optionTypes

  exec.async "git branch -D #{branchName}", cwd: modulePath

  .then ->

    return if not options.remote

    exec.async "git push #{options.remote} --delete #{branchName}", cwd: modulePath

  .fail (error) ->

    expected = "error: branch '#{branchName}' not found."
    if error.message is expected
      throw Error "The given branch does not exist!"

    expected = "error: Cannot delete the branch '#{branchName}' which you are currently on."
    if error.message is expected
      throw Error "Cannot delete the current branch!"

    lines = error.message.split os.EOL
    expected = "fatal: '#{branchName}' does not appear to be a git repository"
    if lines[0] is expected
      throw Error "The given remote repository does not exist!"

    throw error
