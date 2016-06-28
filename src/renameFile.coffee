
assertType = require "assertType"
assert = require "assert"
exec = require "exec"

# TODO: Test with `oldName` not existing.
module.exports = (modulePath, oldName, newName) ->

  assertType modulePath, String
  assertType oldName, String
  assertType newName, String

  rootLength = modulePath.length

  if oldName[0] is "/"
    assert oldName.slice(0, rootLength) is modulePath, "'oldName' must be a descendant of 'modulePath'!"
    oldName = oldName.slice rootLength + 1

  if newName[0] is "/"
    assert newName.slice(0, rootLength) is modulePath, "'newName' must be a descendant of 'modulePath'!"
    newName = newName.slice rootLength + 1

  exec.async "git mv", [ oldName, newName ], cwd: modulePath
