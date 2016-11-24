
assertType = require "assertType"
path = require "path"
fs = require "io/sync"

isRepo = (modulePath) ->

  assertType modulePath, String

  if modulePath[0] is "."
    modulePath = path.resolve process.cwd(), modulePath

  else if not path.isAbsolute modulePath
    modulePath = path.resolve modulePath

  modulePath = path.join modulePath, ".git"

  return fs.isDir modulePath

module.exports = isRepo
