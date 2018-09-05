assertValid = require "assertValid"
exec = require "exec"

git = require "./core"

module.exports =
git.unstageFiles = (repo, files) ->
  assertValid repo, "string"
  assertValid files, "string|array"

  if typeof files == "string"
    files = [files]

  else if !files.length
    return

  await exec "git reset --", files, {cwd: repo}
  return
