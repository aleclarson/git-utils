
assertValid = require "assertValid"
isValid = require "isValid"
exec = require "exec"

git = require "./core"

module.exports =
git.unstageFiles = (modulePath, files) ->
  assertValid modulePath, "string"
  assertValid files, "string|array"

  if isValid files, "string"
    files = [files]

  exec.async "git reset --", files, cwd: modulePath
