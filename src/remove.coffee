# TODO: Test with `file` being a non-existing file.

assertValid = require "assertValid"
exec = require "exec"

git = require "./core"

optionTypes =
  cached: "boolean?"
  recursive: "boolean?"

module.exports =
git.remove = (modulePath, files, options = {}) ->
  assertValid modulePath, "string"
  assertValid files, "string|array"
  assertValid options, optionTypes

  args = []
  args.push "-r" if options.recursive
  args.push "--cached" if options.cached

  exec.async "git rm", args.concat(files), cwd: modulePath
