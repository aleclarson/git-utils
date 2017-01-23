
assertType = require "assertType"
Promise = require "Promise"
semver = require "node-semver"

require "./getVersions"
git = require "./core"

module.exports =
git.findVersion = (modulePath, versionPattern) ->

  assertType modulePath, String
  assertType versionPattern, String

  git.getVersions modulePath

  .then (versions) ->
    version = semver.maxSatisfying versions, versionPattern
    Promise version, versions
