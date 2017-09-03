
assertValid = require "assertValid"
exec = require "exec"

git = require "./core"

module.exports =
git.getBranch = (modulePath) ->
  assertValid modulePath, "string"
  exec.async "git rev-parse --abbrev-ref HEAD", cwd: modulePath

  .fail (error) ->

    if /ambiguous argument 'HEAD'/.test error.message
      return null

    throw error
