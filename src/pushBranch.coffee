
assertValid = require "assertValid"
isValid = require "isValid"
exec = require "exec"
os = require "os"

require "./getBranch"
git = require "./core"

optionTypes =
  remote: "string?"
  branch: "string?"
  upstream: "boolean?"
  force: "boolean?"

module.exports =
git.pushBranch = (modulePath, options = {}) ->
  assertValid modulePath, "string"
  assertValid options, optionTypes

  git.getBranch modulePath
  .then (branch) ->

    if branch is null
      throw Error "An initial commit must exist!"

    args = []
    args.push "-f" if options.force
    args.push "-u" if options.upstream
    args.push options.remote or "origin"
    if options.branch and branch isnt options.branch
    then args.push branch + ":" + options.branch
    else args.push branch

    exec.async "git push", args, cwd: modulePath

    .fail (error) ->

      if not options.force
        if /\(non-fast-forward\)/.test error.message
         throw Error "Must force push to overwrite remote commits!"

      # Detect "force updates" and normal pushes. 'git push' incorrectly prints to 'stderr'!
      regex = RegExp "(\\+|\\s)[\\s]+([a-z0-9]{7})[\\.]{2,3}([a-z0-9]{7})[\\s]+(HEAD|#{branch})[\\s]+->[\\s]+#{branch}"
      return if regex.test error.message

      # Detect new branch pushes. 'git push' incorrectly prints to 'stderr'!
      regex = RegExp "\\*[\\s]+\\[new branch\\][\\s]+#{branch}[\\s]+->[\\s]+#{branch}"
      return if regex.test error.message

      throw error
