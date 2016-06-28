
assertType = require "assertType"

getStatus = require "./getStatus"

module.exports = (modulePath) ->

  assertType modulePath, String

  getStatus modulePath,
    raw: yes

  .then (status) ->
    status.length is 0
