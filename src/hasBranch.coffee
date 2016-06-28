
assertTypes = require "assertTypes"
assertType = require "assertType"
inArray = require "in-array"

getBranches = require "./getBranches"

optionTypes =
  remote: String.Maybe

module.exports = (modulePath, branchName, options = {}) ->

  assertType modulePath, String
  assertType branchName, String
  assertTypes options, optionTypes

  getBranches modulePath, options.remote

  .then (branchNames) ->
    inArray branchNames, branchName
