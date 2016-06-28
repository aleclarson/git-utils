
assertType = require "assertType"
exec = require "exec"
fs = require "io/sync"

# TODO: Test with `file` being a non-existing file.
module.exports = (modulePath, filePath) ->

  assertType modulePath, String
  assertType filePath, String

  if fs.isDir filePath
    args = [ "-r", filePath ]
  else args = [ filePath ]

  exec.async "git rm", args, cwd: modulePath
