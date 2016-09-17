
assertTypes = require "assertTypes"
assertType = require "assertType"
isType = require "isType"
assert = require "assert"
exec = require "exec"
os = require "os"

getBranch = require "./getBranch"

optionTypes =
  upstream: Boolean.Maybe
  force: Boolean.Maybe

module.exports = (modulePath, remoteName, options = {}) ->

  if isType remoteName, Object
    options = remoteName
    remoteName = "origin"
  else remoteName ?= "origin"

  assertType modulePath, String
  assertType remoteName, String
  assertTypes options, optionTypes

  args = [ remoteName ]

  getBranch modulePath

  .then (currentBranch) ->

    if currentBranch is null
      throw Error "An initial commit must exist!"

    args.push "-u", currentBranch if options.upstream
    args.push "-f" if options.force

    exec.async "git push", args, cwd: modulePath

    .fail (error) ->

      if not options.force
        if /\(non-fast-forward\)/.test error.message
         throw Error "Must force push to overwrite remote commits!"

      # Detect "force updates" and normal pushes. 'git push' incorrectly prints to 'stderr'!
      regex = RegExp "(\\+|\\s)[\\s]+([a-z0-9]{7})[\\.]{2,3}([a-z0-9]{7})[\\s]+(HEAD|#{currentBranch})[\\s]+->[\\s]+#{currentBranch}"
      return if regex.test error.message

      # Detect new branch pushes. 'git push' incorrectly prints to 'stderr'!
      regex = RegExp "\\*[\\s]+\\[new branch\\][\\s]+#{currentBranch}[\\s]+->[\\s]+#{currentBranch}"
      return if regex.test error.message

      throw error
