
assertTypes = require "assertTypes"
assertType = require "assertType"
path = require "path"
exec = require "exec"

optionTypes =
  commit: String.Maybe
  dryRun: Boolean.Maybe

module.exports = (modulePath, files, options) ->

  assertType modulePath, String
  assertType files, [ String, Array ]
  assertTypes options, optionTypes

  if not Array.isArray files
    files = [ files ]

  else if not files.length
    return

  files = sync.map files, (filePath) ->
    if filePath[0] is path.sep
      filePath = path.relative modulePath, filePath
      assert filePath[0] isnt ".", "'filePath' must be a descendant of: '#{modulePath}'"
    return filePath

  args = [
    options.commit or "HEAD"
    "--"
  ].concat files

  if options.dryRun
    args.push "-p"

  exec.async "git checkout", args, cwd: modulePath

  # TODO: Possibly parse the 'dryRun' output?
