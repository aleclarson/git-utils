
assertValid = require "assertValid"

require "./getStatus"
git = require "./core"

module.exports =
git.isClean = (modulePath) ->
  assertValid modulePath, "string"
  git.getStatus modulePath, {raw: yes}

  .then (status) ->
    status.length is 0
