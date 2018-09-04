assertValid = require "assertValid"
hasKeys = require "hasKeys"

require "./getStatus"
git = require "./core"

module.exports =
git.isStaged = (repo) ->
  assertValid repo, "string"
  hasKeys (await git.getStatus repo).staged
