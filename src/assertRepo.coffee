
Promise = require "Promise"
path = require "path"
exec = require "exec"
log = require "log"

git = require "./core"

module.exports =
git.assertRepo = (modulePath) ->

  if git.isRepo modulePath
    return Promise()

  moduleName = path.resolve modulePath
  log.moat 1
  log.red moduleName
  log.white " is not a git repository!"
  log.moat 1

  log.gray.dim "Should I call "
  log.yellow "git init"
  log.gray.dim "? "

  shouldInit = prompt.sync {bool: yes}
  log.moat 1

  if shouldInit
  then exec.async "git init", cwd: modulePath
  else Promise()
