# TODO: Add `remote` option
assertValid = require "assertValid"
exec = require "exec"
os = require "os"

git = require "./core"

module.exports =
git.getTags = (repo) ->
  assertValid repo, "string"

  stdout = await exec "git tag", {cwd: repo}

  if stdout.length
  then stdout.split os.EOL
  else []
