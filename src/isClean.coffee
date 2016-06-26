
assertType = require "assertType"

getStatus = require "./getStatus"

module.exports = (modulePath) ->
  assertType modulePath, String
  getStatus { modulePath, parseOutput: no }
  .then (status) -> status.length is 0
