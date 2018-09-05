SortedArray = require "SortedArray"
assertValid = require "assertValid"
semver = require "semver"

require "./getTags"
git = require "./core"

optionTypes =
  remote: "string?"

module.exports =
git.getVersions = (repo, opts = {}) ->
  assertValid repo, "string"
  assertValid opts, optionTypes

  versions = new SortedArray semver.compare
  for tag in await git.getTags repo, opts
    if semver.valid tag
      versions.insert tag

  return versions.array
