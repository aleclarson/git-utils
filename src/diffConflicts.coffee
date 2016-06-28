
{ diffLines } = require "diff"

fs = require "io/sync"
os = require "os"

findConflicts = require "./findConflicts"

module.exports = (filePath, options = {}) ->

  code = fs.read filePath
  conflicts = findConflicts { code }
  return null if not conflicts.length

  offset = 0 # The end offset of the last conflict.
  merged = conflicts.map ({ ours, theirs, range }) ->

    results = []

    before = code.slice offset, range.start
    if before.trim().length
      results.push before
      offset = range.end

    conflict = []
    resolveConflict = ->
      return if not conflict.length

      if not conflict[0]
        conflict[0] = [
          "<<<<<<< "
          ours.origin
          os.EOL
        ].join ""

      else if not conflict[1]
        conflict[1] = [
          "======="
          os.EOL
          ">>>>>>> "
          theirs.origin
          os.EOL
        ].join ""

      results.push conflict.join ""
      conflict.length = 0
      return

    for chunk in diffLines theirs.code, ours.code

      # This chunk was removed by our code.
      if chunk.removed
        conflict[1] = [
          "======="
          os.EOL
          chunk.value
          ">>>>>>> "
          theirs.origin
          os.EOL
        ].join ""

      # This chunk was added by our code.
      else if chunk.added
        conflict[0] = [
          "<<<<<<< "
          ours.origin
          os.EOL
          chunk.value
        ].join ""
        resolveConflict()

      else # This chunk has no differences.
        resolveConflict()
        results.push chunk.value

    return results.join ""

  after = code.slice offset
  if after.length
    merged.push after

  code = merged.join ""
  if options.overwrite isnt no
    fs.write filePath, code

  return code
