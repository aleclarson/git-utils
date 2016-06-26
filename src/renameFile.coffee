
assertTypes = require "assertTypes"
isType = require "isType"
exec = require "exec"
path = require "path"

optionTypes =
  modulePath: String
  oldName: String
  newName: String

# TODO: Test with `oldName` not existing.
module.exports = (options) ->

  if isType options, String
    options =
      modulePath: arguments[0]
      oldName: arguments[1]
      newName: arguments[2]

  assertTypes options, optionTypes

  { modulePath, oldName, newName } = options

  rootLength = modulePath.length

  if oldName[0] is "/"
    assert oldName.slice(0, rootLength) is modulePath, "'oldName' must be a descendant of 'modulePath'!"
    oldName = oldName.slice rootLength + 1

  if newName[0] is "/"
    assert newName.slice(0, rootLength) is modulePath, "'newName' must be a descendant of 'modulePath'!"
    newName = newName.slice rootLength + 1

  exec "git mv", [ oldName, newName ], cwd: modulePath
