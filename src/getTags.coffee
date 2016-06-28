
assertType = require "assertType"
exec = require "exec"
os = require "os"

module.exports = (modulePath) ->

  assertType modulePath, String

  exec.async "git tag", cwd: modulePath

  .then (stdout) ->

    if stdout.length is 0
      return []

    return stdout.split os.EOL
