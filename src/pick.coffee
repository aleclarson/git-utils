
assertValid = require "assertValid"
isValid = require "isValid"
exec = require "exec"

MergeStrategy = require "./MergeStrategy"

require "./isClean"
git = require "./core"

optionTypes =
  strategy: [MergeStrategy, "?"]

module.exports =
git.pick = (modulePath, commit, options = {}) ->
  assertValid modulePath, "string"
  assertValid commit, {from: "string", to: "string"}
  assertValid options, optionTypes

  args =
    if isValid commit, "object"
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
