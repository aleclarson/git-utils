# TODO: Test with `oldName` not existing.

assertValid = require "assertValid"
exec = require "exec"

git = require "./core"

module.exports =
git.renameFile = (modulePath, oldName, newName) ->
  assertValid modulePath, "string"
  assertValid oldName, "string"
  assertValid newName, "string"

  rootLength = modulePath.length

  if oldName[0] is "/"
    unless modulePath is oldName.slice 0, rootLength
      throw Error "'oldName' must be a descendant of 'modulePath'!"
    oldName = oldName.slice rootLength + 1

  if newName[0] is "/"
    unless modulePath is newName.slice 0, rootLength
      throw Error "'newName' must be a descendant of 'modulePath'!"
    newName = newName.slice rootLength + 1

  exec.async "git mv", [ oldName, newName ], cwd: modulePath