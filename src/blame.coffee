
assertTypes = require "assertTypes"
isType = require "isType"
exec = require "exec"

optionTypes =
  modulePath: String
  filePath: String
  lines: Array.Maybe

module.exports = (options) ->

  if isType options, String
    options =
      modulePath: arguments[0]
      filePath: arguments[1]
      lines: arguments[2]

  assertTypes options, optionTypes

  { modulePath, filePath, lines } = options

  args = [ "--porcelain" ]
  args.push "-L" + lines[0] + "," + lines[1] if lines.length >= 2
  args.push "--", filePath

  exec "git blame", args, cwd: modulePath

  # TODO: Parse the output
