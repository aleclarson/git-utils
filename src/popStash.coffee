assertValid = require "assertValid"
exec = require "exec"

git = require "./core"

module.exports =
git.popStash = (repo) ->
  assertValid repo, "string"
  await exec "git stash pop", {cwd: repo}
  return
