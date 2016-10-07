
assertTypes = require "assertTypes"
assertType = require "assertType"
Null = require "Null"
exec = require "exec"

optionTypes =
  clean: Boolean.Maybe

# TODO: Test with `commit` being a non-existing commit.
# TODO: Test with `commit` being a non-existing branch.
module.exports = (modulePath, commit, options) ->

  if arguments.length < 3
    options = commit or {}
    commit = undefined
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
    exec.async "git reset", [hardness, commit or "HEAD"], {cwd: modulePath}
    # TODO: Resolve with the new HEAD commit
