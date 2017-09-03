
assertValid = require "assertValid"
Promise = require "Promise"
semver = require "node-semver"

require "./getVersions"
git = require "./core"

module.exports =
git.findVersion = (modulePath, versionPattern) ->
  assertValid modulePath, "string"
  assertValid versionPattern, "string"

  git.getVersions modulePath
  .then (versions) ->
    version = semver.maxSatisfying versions, versionPattern
    Promise.resolve version, versions
