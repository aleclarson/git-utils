# TODO: Test with `oldName` not existing.
assertValid = require "assertValid"
path = require "path"
exec = require "exec"

git = require "./core"

module.exports =
git.renameFile = (repo, oldName, newName) ->
  assertValid repo, "string"
  assertValid oldName, "string"
  assertValid newName, "string"

  await exec "git mv",
    makeRelative(oldName),
    makeRelative(newName),
    {cwd: repo}
  return

makeRelative = (repo, file) ->
  return file if !path.isAbsolute file

  name = path.relative repo, file
  return name if name[0] != "."

  throw Error "Absolute path '#{file}' cannot be outside '#{repo}'"
