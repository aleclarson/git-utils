assertValid = require "assertValid"
isValid = require "isValid"
Finder = require "finder"
exec = require "exec"
os = require "os"

git = require "./core"

optionTypes =
  raw: "boolean?"
  remote: "string?"

module.exports =
git.getBranches = (repo, opts) ->
  assertValid repo, "string"
  assertValid opts, optionTypes

  if opts.remote
  then getRemoteBranches repo, opts
  else getLocalBranches repo, opts

getRemoteBranches = (repo, opts) ->
  stdout = await exec "git ls-remote -h #{opts.remote}", {cwd: repo}
  return stdout if opts.raw

  findName = Finder /refs\/heads\/(.+)$/
  branches = []
  for line in stdout.split os.EOL
    if name = findName line
      branches.push name

  return branches

getLocalBranches = (repo, opts) ->
  stdout = await exec "git branch", {cwd: repo}
  return stdout if opts.raw

  findName = Finder /^[\*\s]+([a-zA-Z0-9_\-\.]+)$/
  branches = []
  for line in stdout.split os.EOL
    if name = findName line
      branches.push name
      if line[0] is "*"
        branches.current = name

  return branches
