
assertValid = require "assertValid"
exec = require "exec"
os = require "os"

git = require "./core"

module.exports =
git.getTags = (modulePath) ->
  assertValid modulePath, "string"

  exec.async "git tag", cwd: modulePath
  .then (stdout) ->

    if stdout.length is 0
      return []

    return stdout.split os.EOL
