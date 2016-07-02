
assertTypes = require "assertTypes"
assertType = require "assertType"
semver = require "node-semver"
assert = require "assert"
exec = require "exec"
os = require "os"

git =
  addTag: require "./addTag"
  commit: require "./commit"
  deleteTag: require "./deleteTag"
  findVersion: require "./findVersion"
  isStaged: require "./isStaged"
  pushBranch: require "./pushBranch"
  pushTags: require "./pushTags"
  resetBranch: require "./resetBranch"

optionTypes =
  force: Boolean.Maybe
  remote: String.Maybe
  message: String.Maybe

module.exports = (modulePath, version, options) ->

  assertType modulePath, String
  assertType version, String
  assertTypes options, optionTypes

  assert semver.valid(version), "Invalid version formatting!"

  options.remote ?= "origin"

  git.isStaged modulePath
  .assert "No changes were staged!"

  .then ->
    git.findVersion modulePath, version

  .then ({ index, versions }) ->

    return if index < 0

    if not options.force
      throw Error "Version already exists!"

    if index isnt versions.length - 1
      throw Error "Can only overwrite the most recent version!"

    git.resetBranch modulePath, "HEAD^"

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
    git.pushTags modulePath, options.remote,
      force: options.force

  .fail (error) ->

    # Force an upstream branch to exist. Is this possibly dangerous?
    if /^fatal: The current branch [^\s]+ has no upstream branch/.test error.message

      return git.pushBranch modulePath, options.remote,
        force: options.force
        upstream: yes

      .then ->
        git.pushTags modulePath, options.remote,
          force: options.force

    throw error

  # In case 'pushBranch' fails again, we need a separate 'onRejected' handler.
  .fail (error) ->

    git.resetBranch modulePath, "HEAD^"

    .then ->
      git.deleteTag modulePath, version

    .then ->
      throw error
