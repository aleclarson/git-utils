
assertTypes = require "assertTypes"
assertType = require "assertType"
isType = require "isType"
exec = require "exec"

MergeStrategy = require "./MergeStrategy"
CommitRange = require "./CommitRange"

require "./isClean"
git = require "./core"

optionTypes =
  strategy: MergeStrategy.Maybe

module.exports =
git.pick = (modulePath, commit, options = {}) ->

  assertType modulePath, String
  assertType commit, String.or CommitRange
  assertTypes options, optionTypes

  args =
    if isType commit, Object
    then [ commit.from + ".." + commit.to ]
    else [ commit ]

  if options.strategy
    args.push "-X", options.strategy

  exec.async "git cherry-pick", args, cwd: modulePath

  .then -> git.isClean modulePath

  # `cherry-pick` prints to stderr for merge conflicts
  .fail (error) ->
    return yes if /error: could not apply/.test error.message
    throw error

  .then (clean) ->
    return if clean
    exec.async "git cherry-pick --continue", cwd: modulePath
