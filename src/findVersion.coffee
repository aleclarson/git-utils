
assertType = require "assertType"
Promise = require "Promise"
semver = require "node-semver"

getVersions = require "./getVersions"

module.exports = (modulePath, versionPattern) ->

  assertType modulePath, String
  assertType versionPattern, String

  getVersions modulePath

  .then (versions) ->
    version = semver.maxSatisfying versions, versionPattern
    Promise version, versions
