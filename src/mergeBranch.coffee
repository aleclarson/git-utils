
assertValid = require "assertValid"
Promise = require "Promise"
exec = require "exec"

MergeStrategy = require "./MergeStrategy"

require "./isClean"
require "./getBranch"
require "./setBranch"
git = require "./core"

optionTypes =
  ours: "string?"
  theirs: "string"
  strategy: [MergeStrategy, "?"]

module.exports =
git.mergeBranch = (modulePath, options) ->
  assertValid modulePath, "string"
  assertValid options, optionTypes

  startBranch = null

  git.isClean modulePath
  .assert "The current branch cannot have any uncommitted changes!"

  .then ->
    git.getBranch modulePath
    .then (currentBranch) ->
      startBranch = currentBranch

  .then ->
    return if not options.ours
    git.setBranch modulePath, options.ours

  .then ->

    args = [
      options.theirs
      "--no-commit"
      "--no-ff"
    ]

    if options.strategy
      args.push "-X", options.strategy

    exec.async "git merge", args, cwd: modulePath

    # TODO: Fail gracefully if the merge was empty.
    .fail (error) ->

      if /Automatic merge went well/.test error.message
        return # 'git merge' incorrectly prints to 'stderr'

      throw error

  .always ->
    return if not options.ours
    git.setBranch modulePath, startBranch
