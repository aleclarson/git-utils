
assertTypes = require "assertTypes"
exec = require "exec"

optionTypes =
  modulePath: String
  commit: String
  theirs: Boolean.Maybe
  ours: Boolean.Maybe

module.exports = (options) ->

  assertTypes options, optionTypes

  { modulePath, commit, theirs, ours } = options

  args = [ commit ]
  args.push "-X", "ours" if ours
  args.push "-X", "theirs" if theirs

  exec "git cherry-pick", args, { cwd: modulePath }
