
assertType = require "assertType"
exec = require "exec"

git = require "./core"

module.exports =
git.unstageFiles = (modulePath, files) ->

  assertType modulePath, String
  assertType files, String.or Array

  if not Array.isArray files
    files = [ files ]

  exec.async "git reset --", files, cwd: modulePath
