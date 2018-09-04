# TODO: Test against existing branch name.
assertValid = require "assertValid"
exec = require "exec"

git = require "./core"

module.exports =
git.addBranch = (repo, branch) ->
  assertValid repo, "string"
  assertValid branch, "string"

  try
    await exec "git checkout -b #{branch}", {cwd: repo}
    return branch

  catch err

    if /Switched to a new branch/.test err.message
      return # 'git checkout' incorrectly prints to stderr

    throw err
