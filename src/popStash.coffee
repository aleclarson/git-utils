
assertType = require "assertType"
exec = require "exec"

module.exports = (modulePath) ->

  assertType modulePath, String

  exec.async "git stash pop", cwd: modulePath
