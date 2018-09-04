assertValid = require "assertValid"
exec = require "exec"

git = require "./core"

optionTypes =
  lines: "array?"

module.exports =
git.blame = (repo, file, opts = {}) ->
  assertValid repo, "string"
  assertValid file, "string"
  assertValid opts, optionTypes

  args = [ "--porcelain" ]

  { lines } = opts
  if lines and lines.length >= 2
    args.push "-L" + lines[0] + "," + lines[1]

  args.push "--", file
  await exec "git blame", args, {cwd: repo}
  # TODO: Parse the output
