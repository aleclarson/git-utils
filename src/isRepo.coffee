
assertValid = require "assertValid"
path = require "path"
fs = require "fsx"

git = require "./core"

module.exports =
git.isRepo = (modulePath) ->
  assertValid modulePath, "string"

  if modulePath[0] is "."
    modulePath = path.resolve process.cwd(), modulePath

  else if not path.isAbsolute modulePath
    modulePath = path.resolve modulePath

  modulePath = path.join modulePath, ".git"

  return fs.isDir modulePath
