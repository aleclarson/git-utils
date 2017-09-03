
assertValid = require "assertValid"
exec = require "exec"

git = require "./core"

module.exports =
git.popStash = (modulePath) ->
  assertValid modulePath, "string"
  exec.async "git stash pop", cwd: modulePath
