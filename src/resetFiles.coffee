
assertValid = require "assertValid"
isValid = require "isValid"
path = require "path"
exec = require "exec"
sync = require "sync"

git = require "./core"

optionTypes =
  commit: "string?"
  dryRun: "boolean?"

module.exports =
git.resetFiles = (modulePath, files, options = {}) ->
  assertValid modulePath, "string"
  assertValid files, "string|array"
  assertValid options, optionTypes

  if isValid files, "string"
    files = [files]

  else if not files.length
    return

  files = sync.map files, (filePath) ->
    if filePath[0] is path.sep
      filePath = path.relative modulePath, filePath
      if filePath[0] is "."
        throw Error "'filePath' must be a descendant of: '#{modulePath}'"
    return filePath

  args = [
    options.commit or "HEAD"
    "--"
  ].concat files

  if options.dryRun
    args.push "-p"

  exec.async "git checkout", args, cwd: modulePath

  # TODO: Possibly parse the 'dryRun' output?
