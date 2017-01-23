
assertTypes = require "assertTypes"
assertType = require "assertType"
inArray = require "in-array"

require "./getBranches"
git = require "./core"

optionTypes =
  remote: String.Maybe

module.exports =
git.hasBranch = (modulePath, branchName, options = {}) ->

  assertType modulePath, String
  assertType branchName, String
  assertTypes options, optionTypes

  git.getBranches modulePath, options.remote

  .then (branchNames) ->
    inArray branchNames, branchName
