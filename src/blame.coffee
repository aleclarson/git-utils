
assertTypes = require "assertTypes"
assertType = require "assertType"
exec = require "exec"

git = require "./core"

optionTypes =
  lines: Array.Maybe

module.exports =
git.blame = (modulePath, filePath, options = {}) ->

  assertType modulePath, String, "modulePath"
  assertType filePath, String, "filePath"
  assertTypes options, optionTypes, "options"

  args = [ "--porcelain" ]

  { lines } = options
  if lines and lines.length >= 2
    args.push "-L" + lines[0] + "," + lines[1]

  args.push "--", filePath

  exec.async "git blame", args, cwd: modulePath

  # TODO: Parse the output
