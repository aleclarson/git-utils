
SortedArray = require "sorted-array"
assertType = require "assertType"
semver = require "node-semver"

require "./getTags"
git = require "./core"

module.exports =
git.getVersions = (modulePath) ->

  assertType modulePath, String

  git.getTags modulePath

  .then (tagNames) ->

    versions = SortedArray [], semver.compare

    for tagName in tagNames
      continue if not semver.valid tagName
      versions.insert tagName

    return versions.array
