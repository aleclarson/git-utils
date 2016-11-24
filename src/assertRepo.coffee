
Promise = require "Promise"
path = require "path"
exec = require "exec"
log = require "log"

isRepo = require "./isRepo"

module.exports =
assertRepo = (modulePath) ->

  if isRepo modulePath
    return Promise()

  moduleName = path.resolve modulePath
  log.moat 1
  log.red moduleName
  log.white " is not a git repository!"
  log.moat 1

  log.gray.dim "Want to call "
  log.yellow "git init"
  log.gray.dim "?"

  shouldInit = prompt.sync { parseBool: yes }
  log.moat 1

  if not shouldInit
    return Promise()

  exec.async "git init", cwd: modulePath
