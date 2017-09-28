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
git.resetBranch = (modulePath, commit, options) ->

  if isValid commit, "object"
    options = commit
    commit = "HEAD"
  else
    options ?= {}

  assertValid modulePath, "string"
  assertValid options, optionTypes

  if commit is null
    exec.async "git update-ref -d HEAD", {cwd: modulePath}
    .then -> options.hard and exec.async "git reset --hard", {cwd: modulePath}

  else
    commit ?= "HEAD"
    assertValid commit, "string|null"

    hardness =
      if options.hard then "--hard"
      else if options.soft then "--soft"
      else "--mixed"

    exec.async "git reset", [hardness, commit], {cwd: modulePath}
    # TODO: Resolve with the new HEAD commit
