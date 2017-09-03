
assertValid = require "assertValid"
isValid = require "isValid"
Finder = require "finder"
exec = require "exec"
os = require "os"

require "./getRemotes"
git = require "./core"

optionTypes =
  raw: "boolean?"

module.exports =
git.getBranches = (modulePath, remoteName, options) ->

  if isValid remoteName, "object"
    options = remoteName
    remoteName = null
  else options ?= {}

  assertValid modulePath, "string"
  assertValid remoteName, "string|null"
  assertValid options, optionTypes

  if remoteName

    return git.getRemotes modulePath

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
