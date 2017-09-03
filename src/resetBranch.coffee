# TODO: Test with `commit` being a non-existing commit.
# TODO: Test with `commit` being a non-existing branch.

assertValid = require "assertValid"
isValid = require "isValid"
exec = require "exec"

git = require "./core"

optionTypes =
  clean: "boolean?"

module.exports =
git.resetBranch = (modulePath, commit, options) ->

  if isValid commit, "object"
    options = commit
    commit = "HEAD"
  else
    options ?= {}

  assertValid modulePath, "string"
  assertValid commit, "string|null"
  assertValid options, optionTypes

  if commit is null
    exec.async "git update-ref -d HEAD", {cwd: modulePath}
    .then -> options.clean and exec.async "git reset --hard", {cwd: modulePath}

  else
    hardness = if options.clean then "--hard" else "--soft"
    exec.async "git reset", [hardness, commit], {cwd: modulePath}
    # TODO: Resolve with the new HEAD commit
