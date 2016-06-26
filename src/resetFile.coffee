
assertTypes = require "assertTypes"
isType = require "isType"
Path = require "path"
exec = require "exec"

optionTypes =
  modulePath: String
  filePath: String
  commit: String.Maybe
  dryRun: Boolean.Maybe

module.exports = (options) ->

  if isType optionTypes, String
    options =
      modulePath: arguments[0]
      filePath: arguments[1]

  assertTypes options, optionTypes

  { modulePath, filePath, commit, dryRun } = options

  if filePath[0] is Path.sep
    filePath = Path.relative modulePath, filePath

  commit = "HEAD" if not commit
  args = [ commit, "--", filePath ]
  args.push "-p" if dryRun

  exec "git checkout", args, cwd: modulePath

  # TODO: Possibly parse the 'dryRun' output?
