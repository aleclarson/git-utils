
SortedArray = require "SortedArray"
assertValid = require "assertValid"
semver = require "node-semver"

require "./getTags"
git = require "./core"

module.exports =
git.getVersions = (modulePath) ->
  assertValid modulePath, "string"

  git.getTags modulePath

  .then (tagNames) ->

    versions = SortedArray [], semver.compare

    for tagName in tagNames
      continue if not semver.valid tagName
      versions.insert tagName

    return versions.array
