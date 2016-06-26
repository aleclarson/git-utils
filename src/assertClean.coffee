
assertType = require "assertType"
prompt = require "prompt"
exec = require "exec"
log = require "log"

git =
  getBranch: require "./getBranch"
  isClean: require "./isClean"
  pushStash: require "./pushStash"

module.exports = (modulePath) ->

  assertType modulePath, String

  git.isClean modulePath

  .then (clean) ->

    return if clean

    git.getBranch modulePath

    .then (branchName) ->

      if branchName is null
        throw Error "An initial commit must exist!"

      moduleName = lotus.relative modulePath
      log.moat 1
      log.red moduleName + "/" + branchName
      log.white " has uncommitted changes!"
      log.moat 1

      log.gray.dim "Want to call "
      log.yellow "git stash"
      log.gray.dim "?"

      shouldStash = prompt.sync { parseBool: yes }
      log.moat 1

      if not shouldStash
        throw Error "The current branch has uncommitted changes!"

      git.pushStash modulePath
