assertValid = require "assertValid"
exec = require "exec"
os = require "os"

git = require "./core"

optionTypes =
  remote: "string?"

module.exports =
git.deleteBranch = (repo, branch, opts = {}) ->
  assertValid repo, "string"
  assertValid branch, "string"
  assertValid opts, optionTypes

  try
    await exec "git branch -D #{branch}", {cwd: repo}
    if opts.remote
      await exec "git push #{opts.remote} --delete #{branch}", {cwd: repo}
    return

  catch err

    expected = "error: branch '#{branch}' not found."
    if err.message is expected
      throw Error "The given branch does not exist!"

    expected = "error: Cannot delete the branch '#{branch}' which you are currently on."
    if err.message is expected
      throw Error "Cannot delete the current branch!"

    lines = err.message.split os.EOL
    expected = "fatal: '#{branch}' does not appear to be a git repository"
    if lines[0] is expected
      throw Error "The given remote repository does not exist!"

    throw err
