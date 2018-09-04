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
git.getBranches = (repo, remoteName, opts) ->
  assertValid repo, "string"

  if isValid remoteName, "object"
    opts = remoteName
    remoteName = null
  else
    opts or= {}

  assertValid remoteName, "string?"
  assertValid opts, optionTypes

  if remoteName
  then getRemoteBranches repo, remoteName, opts
  else getLocalBranches repo, opts

getRemoteBranches = (repo, remoteName, opts) ->
  remotes = await git.getRemotes repo
  remoteUri = remotes[remoteName].push

  stdout = await exec "git ls-remote --heads #{remoteUri}", {cwd: repo}
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
