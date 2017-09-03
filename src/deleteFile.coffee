# TODO: Test with `file` being a non-existing file.

assertValid = require "assertValid"
exec = require "exec"
fs = require "io/sync"

git = require "./core"

module.exports =
git.deleteFile = (modulePath, filePath) ->
  assertValid modulePath, "string"
  assertValid filePath, "string"

  if fs.isDir filePath
    args = [ "-r", filePath ]
  else args = [ filePath ]

  exec.async "git rm", args, cwd: modulePath
