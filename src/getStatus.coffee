
escapeStringRegExp = require "escape-string-regexp"
assertTypes = require "assertTypes"
assertType = require "assertType"
Finder = require "finder"
isType = require "isType"
assert = require "assert"
exec = require "exec"

optionTypes =
  raw: Boolean.Maybe

module.exports = (modulePath, options = {}) ->

  assertType modulePath, String
  assertTypes options, optionTypes

  exec.async "git status --porcelain", cwd: modulePath

  .then (stdout) ->

    if options.raw
      return stdout

    results = {
      staged: {}
      tracked: {}
      untracked: []
      unmerged: []
    }

    if stdout.length is 0
      return results

    for line in stdout.split "\n"

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
