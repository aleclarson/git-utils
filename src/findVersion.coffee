
assertType = require "assertType"
semver = require "node-semver"

getVersions = require "./getVersions"

module.exports = (modulePath, version) ->

  assertType modulePath, String
  assertType version, String

  getVersions modulePath

  .then (versions) ->

    for existingVersion, index in versions
      if semver.eq version, existingVersion
        return { index, versions }

    return { index: -1, versions }
