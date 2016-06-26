
assertTypes = require "assertTypes"
isType = require "isType"
exec = require "exec"
fs = require "io/sync"

optionTypes =
  modulePath: String
  file: String

# TODO: Test with `file` being a non-existing file.
module.exports = (options) ->

  if isType options, String
    options =
      modulePath: arguments[0]
      file: arguments[1]

  assertTypes options, optionTypes

  { modulePath, file } = options

  args = [ file ]
  args.unshift "-r" if fs.isDir file

  exec "git rm", args, cwd: modulePath
