# TODO: Test with `commit` being a non-existing commit.
# TODO: Test with `commit` being a non-existing branch.
assertValid = require "assertValid"
isValid = require "isValid"
exec = require "exec"

git = require "./core"

optionTypes =
  soft: "boolean?"
  hard: "boolean?"

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
    if opts.hard
      await exec "git reset --hard", {cwd: repo}

  else
    commit or= "HEAD"
    hardness =
      if opts.hard then "--hard"
      else if opts.soft then "--soft"
      else "--mixed"

    await exec "git reset", hardness, commit, {cwd: repo}
    # TODO: Resolve with the new HEAD commit
