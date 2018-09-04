assertValid = require "assertValid"
Finder = require "finder"
exec = require "exec"
os = require "os"

git = require "./core"

regex = /^([^\s]+)\s+([^\s]+)/g
findName = Finder { regex, group: 1 }
findUri = Finder { regex, group: 2 }

module.exports =
git.getRemotes = (repo) ->
  assertValid repo, "string"

  remotes = Object.create null

  stdout = await exec "git remote --verbose", {cwd: repo}
  return remotes if !stdout.length

  for line in stdout.split os.EOL
    name = findName line
    remote = remotes[name] or= {}
    if /\(push\)$/.test line
    then remote.push = findUri line
    else remote.fetch = findUri line

  return remotes
