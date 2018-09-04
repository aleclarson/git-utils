assertValid = require "assertValid"
exec = require "exec"

require "./getBranch"
require "./hasBranch"
git = require "./core"

optionTypes =
  remote: "string?"
  message: "boolean?"

module.exports =
git.getHead = (repo, branch, opts = {}) ->
  assertValid repo, "string"
  assertValid branch, "string?"
  assertValid opts, optionTypes

  if !branch
    branch = await git.getBranch repo

  else if !git.hasBranch repo, branch
    return null

  stdout = await exec "git log", [
    "-1"
    "--pretty=oneline"
    if opts.remote
    then opts.remote + "/" + branch
    else branch
  ], {cwd: repo}

  separator = stdout.indexOf " "
  id = stdout.slice 0, separator

  if opts.message
  then { id, message: stdout.slice separator + 1 }
  else id
