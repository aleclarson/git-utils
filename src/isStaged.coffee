
assertType = require "assertType"
hasKeys = require "hasKeys"

getStatus = require "./getStatus"

module.exports = (modulePath) ->
  assertType modulePath, String
  getStatus { modulePath }
  .then (status) -> not hasKeys status.staged
