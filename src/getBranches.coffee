
assertTypes = require "assertTypes"
assertType = require "assertType"
Finder = require "finder"
isType = require "isType"
exec = require "exec"
os = require "os"

getRemotes = require "./getRemotes"

optionTypes =
  raw: Boolean.Maybe

module.exports = (modulePath, remoteName, options) ->

  if isType remoteName, Object
    options = remoteName
    remoteName = null
  else options ?= {}

  assertType modulePath, String
  assertType remoteName, String.Maybe
  assertTypes options, optionTypes

  if remoteName

    return getRemotes modulePath

    .then (remotes) ->
      remoteUri = remotes[remoteName].push
      exec.async "git ls-remote --heads #{remoteUri}", cwd: modulePath

    .then (stdout) ->

      if options.raw
        return stdout

      findName = Finder /refs\/heads\/(.+)$/
      branches = []
      for line in stdout.split os.EOL
        name = findName line
        continue if not name
        branches.push name

      return branches

  return exec.async "git branch", cwd: modulePath

  .then (stdout) ->

    if options.raw
      return stdout

    findName = Finder /^[\*\s]+([a-zA-Z0-9_\-\.]+)$/
    branches = []
    for line in stdout.split os.EOL
      name = findName line
      continue if not name
      branches.push name
      if line[0] is "*"
        branches.current = name

    return branches
