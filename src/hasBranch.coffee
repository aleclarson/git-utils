assertValid = require "assertValid"

require "./getBranches"
git = require "./core"

optionTypes =
  remote: "string?"

module.exports =
git.hasBranch = (repo, branch, opts = {}) ->
  assertValid repo, "string"
  assertValid branch, "string"
  assertValid opts, optionTypes

  branches = await git.getBranches repo, opts.remote
  return branches.includes branch
