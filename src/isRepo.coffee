
path = require "path"
fs = require "io/sync"

module.exports = (modulePath) ->

  if modulePath[0] is "."
    modulePath = path.resolve process.cwd(), modulePath

  else if modulePath[0] isnt "/"
    modulePath = lotus.path + "/" + modulePath

  modulePath = path.join modulePath, ".git"

  return fs.isDir modulePath
