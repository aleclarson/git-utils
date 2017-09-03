
assertValid = require "assertValid"
isValid = require "isValid"
exec = require "exec"

git = require "./core"

module.exports =
git.stageFiles = (modulePath, files) ->
  assertValid modulePath, "string"
  assertValid files, "string|array"

  if isValid files, "string"
    files = [files]

  exec.async "git add", files, cwd: modulePath

  .fail (error) ->

    if /The following paths are ignored/.test error.message
      return # 'git add' complains when ignored files are added (eg: 'git add *').

    throw error
