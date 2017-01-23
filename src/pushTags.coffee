
assertTypes = require "assertTypes"
assertType = require "assertType"
exec = require "exec"
os = require "os"

git = require "./core"

optionTypes =
  force: Boolean.Maybe
  remote: String.Maybe

module.exports =
git.pushTags = (modulePath, options = {}) ->

  assertType modulePath, String
  assertTypes options, optionTypes

  args = [
    options.remote or "origin"
    "--tags"
  ]

  if options.force
    args.push "-f"

  exec.async "git push", args, cwd: modulePath

  .fail (error) ->

    lines = error.message.split os.EOL

    if /\(already exists\)$/.test lines[1]
      throw Error "Tag already exists!"

    if /\(forced update\)$/.test lines[1]
      return # 'git push' incorrectly prints using stderr

    if /\* \[new tag\]/.test lines[1]
      return # 'git push' incorrectly prints using stderr

    throw error
