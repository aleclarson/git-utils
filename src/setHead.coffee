
assertTypes = require "assertTypes"
isType = require "isType"
exec = require "exec"
fs = require "io/sync"

optionTypes =
  modulePath: String
  commit: String.Maybe

# TODO: Test with `commit` being a non-existing commit.
# TODO: Test with `commit` being a non-existing branch.
module.exports = (options) ->

  if isType options, String
    options =
      modulePath: arguments[0]
      commit: arguments[1]

  assertTypes options, optionTypes

  { modulePath, commit } = options

  commit ?= "HEAD"

  exec "git reset --hard " + commit, cwd: modulePath
