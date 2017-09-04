
{ diffLines } = require "diff"

fs = require "fsx"
os = require "os"

require "./findConflicts"
git = require "./core"

module.exports =
git.diffConflicts = (filePath, options = {}) ->

  code = fs.readFile filePath

  # The end offset of the previous conflict.
  offset = 0

  results = []

  git.findConflicts {code}

  .forEach ({ ours, theirs, range }) ->

    before = code.slice offset, range.start
    if before.trim().length
      results.push before
      offset = range.end

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
        continue

      # This chunk was added by our code.
      if chunk.added
        conflict[0] = [
          "<<<<<<< "
          ours.origin
          os.EOL
          chunk.value
        ].join ""

        # Since a 'removed' chunk will never follow an 'added'
        # chunk, we can safely resolve the conflict here!
        conflicted = conflict.resolve ours, theirs
        results.push conflicted if conflicted
        continue

      # This chunk has no conflicts.
      conflicted = conflict.resolve ours, theirs
      results.push conflicted if conflicted
      results.push chunk.value

    # Wrap up any unresolved conflicts.
    conflicted = conflict.resolve ours, theirs
    results.push conflicted if conflicted

  # Append any cleanly merged code that has no conflicts under it.
  after = code.slice offset
  if after.length
    results.push after

  if options.overwrite isnt no
    fs.writeFile filePath, results.join ""

  return results

# `diffConflicts` uses this to track the opening
# and closing of the git conflict markers.
conflict = []
conflict.resolve = (ours, theirs) ->
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

  conflicted = conflict.join ""
  conflict.length = 0
  return conflicted
