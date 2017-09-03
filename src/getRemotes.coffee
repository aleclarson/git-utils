
assertValid = require "assertValid"
Finder = require "finder"
exec = require "exec"
os = require "os"

git = require "./core"

regex = /^([^\s]+)\s+([^\s]+)/g
findName = Finder { regex, group: 1 }
findUri = Finder { regex, group: 2 }

module.exports =
git.getRemotes = (modulePath) ->
  assertValid modulePath, "string"

  exec.async "git remote --verbose", cwd: modulePath
  .then (stdout) ->

    remotes = Object.create null

    if stdout.length is 0
      return remotes

    for line in stdout.split os.EOL
      name = findName line
      remote = remotes[name] ?= {}
      if /\(push\)$/.test line
        remote.push = findUri line
      else remote.fetch = findUri line

    return remotes
