
assertValid = require "assertValid"
exec = require "exec"

git = require "./core"

optionTypes =
  lines: "array?"

module.exports =
git.blame = (modulePath, filePath, options = {}) ->
  assertValid modulePath, "string"
  assertValid filePath, "string"
  assertValid options, optionTypes

  args = [ "--porcelain" ]

  { lines } = options
  if lines and lines.length >= 2
    args.push "-L" + lines[0] + "," + lines[1]

  args.push "--", filePath

  exec.async "git blame", args, cwd: modulePath

  # TODO: Parse the output
