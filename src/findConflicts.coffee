
assertTypes = require "assertTypes"
Finder = require "finder"
fs = require "io/sync"

require "./mergeFiles"
git = require "./core"

optionTypes =
  code: String.Maybe
  filePath: String.Maybe

module.exports =
git.findConflicts = (options) ->
  assertTypes options, optionTypes
  options.code ?= fs.read options.filePath
  conflicts = []
  offset = 0
  loop
    conflict = findConflict options.code, offset
    break if not conflict
    conflicts.push conflict
    offset = conflict.range.end
  return conflicts

findOurs = Finder /<<<<<<< ([^\n]*)\n/
findMiddle = Finder /=======\n/
findTheirs = Finder />>>>>>> ([^\n]*)\n/

findConflict = (contents, startOffset) ->

  ours = {}
  theirs = {}

  findOurs.target = contents
  findOurs.offset = startOffset

  ours.origin = findOurs.next()
  startOffset = findOurs.offset

  findOurs.target = null
  return null if not ours.origin?

  findMiddle.target = contents
  findMiddle.offset = startOffset

  middle = findMiddle.next()
  middleOffset = findMiddle.offset

  findMiddle.target = null
  return null if not middle

  findTheirs.target = contents
  findTheirs.offset = middleOffset

  theirs.origin = findTheirs.next()
  endOffset = findTheirs.offset

  findTheirs.target = null
  return null if not theirs.origin?

  ours.code = contents.slice startOffset, middleOffset - 8
  theirs.code = contents.slice middleOffset, endOffset - theirs.origin.length - 9

  return {
    ours
    theirs
    range: {
      start: startOffset - ours.origin.length - 9
      end: endOffset
    }
  }
