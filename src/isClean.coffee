assertValid = require "assertValid"

require "./getStatus"
git = require "./core"

module.exports =
git.isClean = (repo) ->
  assertValid repo, "string"

  status = await git.getStatus repo, {raw: true}
  return status.length == 0
