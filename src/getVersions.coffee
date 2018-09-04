SortedArray = require "SortedArray"
assertValid = require "assertValid"
semver = require "semver"

require "./getTags"
git = require "./core"

module.exports =
git.getVersions = (repo) ->
  assertValid repo, "string"

  versions = new SortedArray semver.compare
  for tag in await git.getTags repo
    if semver.valid tag
      versions.insert tag

  return versions.array
