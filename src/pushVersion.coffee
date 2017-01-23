
assertTypes = require "assertTypes"
assertType = require "assertType"
semver = require "node-semver"
exec = require "exec"
os = require "os"

require "./addTag"
require "./commit"
require "./deleteTag"
require "./findVersion"
require "./isStaged"
require "./pushBranch"
require "./pushTags"
require "./revert"
git = require "./core"

optionTypes =
  force: Boolean.Maybe
  remote: String.Maybe
  message: String.Maybe

module.exports =
git.pushVersion = (modulePath, version, options = {}) ->

  assertType modulePath, String
  assertType version, String
  assertTypes options, optionTypes

  unless semver.valid version
    throw Error "Invalid version formatting!"

  options.remote ?= "origin"

  git.isStaged modulePath
  .assert "No changes were staged!"

  # Check if the given version already exists.
  .then -> git.findVersion modulePath, version
  .then (version, versions) ->
    return if version is null

    # Only the most recent version can be overwritten.
    index = versions.indexOf version
    if index isnt versions.length - 1
      throw Error "Can only overwrite the most recent version!"

    unless options.force
      throw Error "Version already exists!"

    git.revert modulePath

  .then ->
    message = version
    if options.message
      message += os.EOL + options.message
    git.commit modulePath, message

  .then ->
    git.addTag modulePath, version,
      force: options.force

  .then ->
    git.pushBranch modulePath, options.remote,
      force: options.force

  .then ->
    git.pushTags modulePath,
      force: options.force
      remote: options.remote

  .fail (error) ->

    # Force an upstream branch to exist. Is this possibly dangerous?
    if /^fatal: The current branch [^\s]+ has no upstream branch/.test error.message

      return git.pushBranch modulePath, options.remote,
        force: options.force
        upstream: yes

      .then ->
        git.pushTags modulePath,
          force: options.force
          remote: options.remote

    throw error

  # In case 'pushBranch' fails again, we need a separate 'onRejected' handler.
  .fail (error) ->
    git.revertCommit modulePath
    .then -> git.deleteTag modulePath, version
    .always -> throw error
