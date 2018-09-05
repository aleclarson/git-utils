# TODO: Test with `file` being a non-existing file.
assertValid = require "assertValid"
exec = require "exec"

git = require "./core"

optionTypes =
  cached: "boolean?"
  recursive: "boolean?"

module.exports =
git.removeFiles = (repo, files, opts = {}) ->
  assertValid repo, "string"
  assertValid files, "string|array"
  assertValid opts, optionTypes

  args = []
  args.push "-r" if opts.recursive
  args.push "--cached" if opts.cached

  await exec "git rm", args, "--", files, {cwd: repo}
  return
