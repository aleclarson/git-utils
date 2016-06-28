
assertType = require "assertType"
exec = require "exec"

module.exports = (modulePath, files) ->

  assertType modulePath, String
  assertType files, [ String, Array ]

  if not Array.isArray files
    files = [ files ]

  exec.async "git add", files, cwd: modulePath
