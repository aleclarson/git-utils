
isStaged = require "./isStaged"

module.exports = (modulePath) ->
  isStaged modulePath
  .then (staged) ->
    return if staged
    throw Error "No changes are staged!"
