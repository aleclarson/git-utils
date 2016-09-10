
assertType = require "assertType"
path = require "path"
fs = require "io/sync"

isRepo = (modulePath) ->

  assertType modulePath, String

  if modulePath[0] is "."
    modulePath = path.resolve process.cwd(), modulePath

  else if modulePath[0] isnt "/"
    modulePath = lotus.path + "/" + modulePath

  modulePath = path.join modulePath, ".git"

  return fs.isDir modulePath

module.exports = isRepo
