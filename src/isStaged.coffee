
assertType = require "assertType"
hasKeys = require "hasKeys"

require "./getStatus"
git = require "./core"

module.exports =
git.isStaged = (modulePath) ->

  assertType modulePath, String

  git.getStatus modulePath

  .then (status) ->
    hasKeys status.staged
