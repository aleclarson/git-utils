
assertType = require "assertType"
exec = require "exec"

git = require "./core"

module.exports =
git.popStash = (modulePath) ->

  assertType modulePath, String

  exec.async "git stash pop", cwd: modulePath
