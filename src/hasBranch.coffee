
assertValid = require "assertValid"
inArray = require "in-array"

require "./getBranches"
git = require "./core"

optionTypes =
  remote: "string?"

module.exports =
git.hasBranch = (modulePath, branchName, options = {}) ->
  assertValid modulePath, "string"
  assertValid branchName, "string"
  assertValid options, optionTypes

  git.getBranches modulePath, options.remote
  .then (branchNames) ->
    inArray branchNames, branchName
