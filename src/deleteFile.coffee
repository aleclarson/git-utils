
# TODO: Test with `file` being a non-existing file.

assertType = require "assertType"
exec = require "exec"
fs = require "io/sync"

git = require "./core"

module.exports =
git.deleteFile = (modulePath, filePath) ->

  assertType modulePath, String
  assertType filePath, String

  if fs.isDir filePath
    args = [ "-r", filePath ]
  else args = [ filePath ]

  exec.async "git rm", args, cwd: modulePath
