
assertValid = require "assertValid"
hasKeys = require "hasKeys"

require "./getStatus"
git = require "./core"

module.exports =
git.isStaged = (modulePath) ->
  assertValid modulePath, "string"
  git.getStatus modulePath

  .then (status) ->
    hasKeys status.staged
