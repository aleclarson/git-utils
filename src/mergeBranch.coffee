
assertTypes = require "assertTypes"
OneOf = require "OneOf"
Maybe = require "Maybe"
exec = require "exec"

MergeStrategy = require "./MergeStrategy"
setBranch = require "./setBranch"
assertClean = require "./assertClean"

optionTypes =
  modulePath: String
  ours: String.Maybe
  theirs: String
  strategy: Maybe MergeStrategy

module.exports = (options) ->

  assertTypes options, optionTypes

  { modulePath, ours, theirs, strategy } = options

  assertClean modulePath

  .then ->
    return if not ours
    setBranch modulePath, ours

  .then ->
    args = [ theirs, "--no-commit" ]
    args.push "-X", strategy if strategy
    exec "git merge", args, cwd: modulePath

  # TODO: Fail gracefully if the merge was empty.
  .fail (error) ->

    if /Automatic merge went well/.test error.message
      return # 'git merge' incorrectly prints to 'stderr'

    throw error
