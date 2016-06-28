
assertTypes = require "assertTypes"
assertType = require "assertType"
Null = require "Null"
exec = require "exec"

optionTypes =
  clean: Boolean.Maybe

# TODO: Test with `commit` being a non-existing commit.
# TODO: Test with `commit` being a non-existing branch.
module.exports = (modulePath, commit, options = {}) ->

  commit = "HEAD" if commit is undefined

  assertType modulePath, String
  assertType commit, [ String, Null ]
  assertTypes options, optionTypes

  if commit is null
    return exec.async "git update-ref -d HEAD", cwd: modulePath
    .then ->
      return if not options.clean
      exec.async "git reset --hard", cwd: modulePath

  args = [
    if options.clean then "--hard" else "--soft"
    commit or HEAD
  ]

  exec.async "git reset", args, cwd: modulePath
