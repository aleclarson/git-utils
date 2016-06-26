
assertTypes = require "assertTypes"
semver = require "node-semver"
assert = require "assert"
Path = require "path"
exec = require "exec"
log = require "log"

assertStaged = require "./assertStaged"
findVersion = require "./findVersion"
removeTag = require "./removeTag"
addCommit = require "./addCommit"
popCommit = require "./popCommit"
stageAll = require "./stageAll"
pushHead = require "./pushHead"
pushTags = require "./pushTags"
addTag = require "./addTag"

optionTypes =
  modulePath: String
  remoteName: String
  version: String
  message: String.Maybe
  force: Boolean.Maybe

module.exports = (options) ->

  assertTypes options, optionTypes

  { modulePath, remoteName, version, message, force } = options

  assert semver.valid(version), "Invalid version formatting!"

  assertStaged modulePath

  .then ->
    findVersion modulePath, version

  .then ({ index, versions }) ->

    return if index < 0

    if not force
      throw Error "Version already exists!"

    if index isnt versions.length - 1
      throw Error "Can only overwrite the most recent version!"

    popCommit modulePath

  .then ->

    message = version +
      if message then log.ln + message
      else ""

    addCommit modulePath, message

  .then ->
    addTag { modulePath, tagName: version, force }

  .then ->
    pushHead { modulePath, remoteName, force }

  .then ->
    pushTags { modulePath, remoteName, force }

  .fail (error) ->

    # Force an upstream branch to exist. Is this possibly dangerous?
    if /^fatal: The current branch [^\s]+ has no upstream branch/.test error.message
      return pushHead { modulePath, remoteName, force, upstream: yes }
      .then -> pushTags { modulePath, remoteName, force }

    throw error

  # In case 'pushHead' fails again, we need a separate 'onRejected' handler.
  .fail (error) ->

    popCommit modulePath

    .then ->
      removeTag modulePath, version

    .then ->
      throw error
