
assertType = require "assertType"

require "./getStatus"
git = require "./core"

module.exports =
git.isClean = (modulePath) ->

  assertType modulePath, String

  git.getStatus modulePath, {raw: yes}

  .then (status) ->
    status.length is 0
