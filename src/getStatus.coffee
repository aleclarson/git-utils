escapeStringRegExp = require "escape-string-regexp"
assertValid = require "assertValid"
Finder = require "finder"
exec = require "exec"
os = require "os"

git = require "./core"

optionTypes =
  raw: "boolean?"
  remote: "boolean?"

module.exports =
git.getStatus = (repo, opts = {}) ->
  assertValid repo, String
  assertValid opts, optionTypes

  if opts.remote
  then getRemoteStatus repo
  else getLocalStatus repo, opts

getRemoteStatus = (repo) ->
  stdout = await exec "git status --short --branch", {cwd: repo}
  stdout = stdout.split("\n")[0]

  findRemoteBranch = Finder /\.\.\.([^\s]+)/
  findAhead = Finder "ahead ([0-9]+)"
  findBehind = Finder "behind ([0-9]+)"

  branch: findRemoteBranch stdout
  ahead: Number findAhead stdout
  behind: Number findBehind stdout

getLocalStatus = (repo, opts) ->
  stdout = await exec "git status --porcelain", {cwd: repo}
  return stdout if opts.raw

  results =
    staged: {}
    tracked: {}
    untracked: []
    unmerged: []

  if !stdout.length
    return results

  for line in stdout.split os.EOL

    file = { path: findPath line }
    stagingStatus = findStagingStatus line
    workingStatus = findWorkingStatus line

    # Pretend "copied" files are simply "added".
    if stagingStatus is "C"
      stagingStatus = "A"
      file.path = findNewPath line

    if (stagingStatus is "?") and (workingStatus is "?")
      results.untracked.push file
      continue

    if (stagingStatus is "U") and (workingStatus is "U")
      results.unmerged.push file
      continue

    if (stagingStatus is "R") or (workingStatus is "R")
      file.newPath = findNewPath line
      file.oldPath = file.path
      delete file.path

    if (stagingStatus isnt " ") and (stagingStatus isnt "?")
      status = statusMap[stagingStatus]
      if not status
        throw Error "Unrecognized status!"
      files = results.staged[status] ?= []
      files.push file

    if (workingStatus isnt " ") and (workingStatus isnt "?")
      status = statusMap[workingStatus]
      if not status
        throw Error "Unrecognized status!"
      files = results.tracked[status] ?= []
      files.push file

  return results

statusMap =
  "A": "added"
  "C": "copied"
  "R": "renamed"
  "M": "modified"
  "D": "deleted"
  "U": "unmerged"
  "?": "untracked"

{ findStagingStatus, findWorkingStatus, findPath, findNewPath } = do ->

  chars = Object.keys statusMap
  charRegex = "([" + escapeStringRegExp(chars.join "") + "\\s]{1})"

  regex = RegExp [
    "^[\\s]*"
    charRegex          # The 'staging status'
    charRegex          # The 'working status'
    " "
    "([^\\s]+)"        # The 'path'
    "( -> ([^\\s]+))?" # The 'new path' (optional)
  ].join ""

  findStagingStatus: Finder { regex, group: 1 }
  findWorkingStatus: Finder { regex, group: 2 }
  findPath: Finder { regex, group: 3 }
  findNewPath: Finder { regex, group: 5 }
