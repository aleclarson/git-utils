
assertTypes = require "assertTypes"
assertType = require "assertType"
isType = require "isType"
exec = require "exec"

MergeStrategy = require "./MergeStrategy"
CommitRange = require "./CommitRange"
isClean = require "./isClean"

optionTypes =
  strategy: MergeStrategy.Maybe

module.exports = (modulePath, commit, options = {}) ->

  assertType modulePath, String
  assertType commit, [ String, CommitRange ]
  assertTypes options, optionTypes

  if isType commit, Object
    args = [ commit.from + ".." + commit.to ]
  else args = [ commit ]

  if options.strategy
    args.push "-X", options.strategy

  exec.async "git cherry-pick", args, cwd: modulePath

  .then -> isClean modulePath

  .fail (error) ->

    if /error: could not apply/.test error.message
      return no # 'git cherry-pick' throws when there are merge conflicts

    throw error

  .then (clean) ->
    return if not clean
    exec.async "git cherry-pick --continue", cwd: modulePath
