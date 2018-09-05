assertValid = require "assertValid"
exec = require "exec"

git = require "./core"

optionTypes =
  dest: "string?"
  depth: "number?"
  branch: "string?"

module.exports =
git.clone = (repo, src, opts = {}) ->
  assertValid repo, "string"
  assertValid src, "string"
  assertValid opts, optionTypes

  args = [ src ]
  args.push opts.dest if opts.dest
  args.push "--branch", opts.branch if opts.branch
  args.push "--depth", opts.depth if opts.depth
  args.push "--quiet"

  await exec "git clone", args, {cwd: repo}
  return
