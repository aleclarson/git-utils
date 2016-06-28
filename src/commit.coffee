
{ find } = require "finder"

assertType = require "assertType"
Promise = require "Promise"
exec = require "exec"
os = require "os"

isStaged = require "./isStaged"

quoteWrap = (s) -> "\"#{s}\""

module.exports = (modulePath, message) ->

  assertType modulePath, String
  assertType message, String

  Promise.assert "No changes were staged!", ->
    isStaged modulePath

  .then ->

    message = message.replace "'", "\\'"

    newline = message.indexOf os.EOL

    if newline >= 0
      paragraph = message.slice newline + 1
      message = message.slice 0, newline

    args = [ "-m", quoteWrap(message) ]
    args.push "-m", quoteWrap(paragraph) if paragraph

    exec.async "git commit", args, cwd: modulePath

    .then (stdout) ->
      firstLine = stdout.slice 0, stdout.indexOf os.EOL
      regex = /^\[.+ ([0-9a-z]{7})\]/
      return find regex, firstLine, 1
