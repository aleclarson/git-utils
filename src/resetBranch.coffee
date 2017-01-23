
# TODO: Test with `commit` being a non-existing commit.
# TODO: Test with `commit` being a non-existing branch.

assertTypes = require "assertTypes"
assertType = require "assertType"
isType = require "isType"
Null = require "Null"
exec = require "exec"

git = require "./core"

optionTypes =
  clean: Boolean.Maybe

module.exports =
git.resetBranch = (modulePath, commit, options) ->

  if isType commit, Object
    options = commit
    commit = "HEAD"
  else
    options ?= {}

  assertType modulePath, String
  assertType commit, String.or Null
  assertTypes options, optionTypes

  if commit is null
    exec.async "git update-ref -d HEAD", {cwd: modulePath}
    .then -> options.clean and exec.async "git reset --hard", {cwd: modulePath}

  else
    hardness = if options.clean then "--hard" else "--soft"
    exec.async "git reset", [hardness, commit], {cwd: modulePath}
    # TODO: Resolve with the new HEAD commit
