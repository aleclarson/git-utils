# TODO: Add `tags` option or argument
assertValid = require "assertValid"
exec = require "exec"
os = require "os"

git = require "./core"

optionTypes =
  force: "boolean?"
  remote: "string?"

module.exports =
git.pushTags = (repo, opts = {}) ->
  assertValid repo, "string"
  assertValid opts, optionTypes

  args = [ opts.remote or "origin", "--tags" ]
  args.push "-f" if opts.force

  try
    await exec "git push", args, {cwd: repo}
    return

  catch err
    lines = err.message.split os.EOL

    if /\(already exists\)$/.test lines[1]
      throw Error "Tag already exists!"

    if /\(forced update\)$/.test lines[1]
      return # 'git push' incorrectly prints using stderr

    if /\* \[new tag\]/.test lines[1]
      return # 'git push' incorrectly prints using stderr

    throw err
