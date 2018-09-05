# TODO: Test with `commit` being a non-existing commit.
# TODO: Test with `commit` being a non-existing branch.
assertValid = require "assertValid"
isValid = require "isValid"
valido = require "valido"
exec = require "exec"

git = require "./core"

ResetMode = valido do ->
  values = ["soft", "hard", "mixed", "merge"]
  test: (value) -> values.includes value
  error: -> Error "Invalid reset mode"

optionTypes =
  mode: [ResetMode, "?"]

module.exports =
git.resetBranch = (repo, commit, opts) ->
  assertValid repo, "string"

  if isValid commit, "object"
    opts = commit
    commit = undefined
  else
    opts or= {}

  assertValid commit, "string?"
  assertValid opts, optionTypes

  if commit == null
    await exec "git update-ref -d HEAD", {cwd: repo}
    if opts.mode == "hard"
      await exec "git reset --hard", {cwd: repo}
    return

  # TODO: Resolve with the new HEAD commit
  await exec "git reset",
    "--" + (opts.mode or "mixed"),
    commit or "HEAD",
    {cwd: repo}
  return
