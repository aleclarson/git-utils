
{ find } = require "finder"

assertType = require "assertType"
Promise = require "Promise"
exec = require "exec"
os = require "os"

require "./isStaged"
git = require "./core"

module.exports =
git.commit = (modulePath, message) ->

  assertType modulePath, String
  assertType message, String

  git.isStaged modulePath
  .assert "No changes were staged!"

  .then ->
    newline = message.indexOf os.EOL
    if newline >= 0
      paragraph = message.slice newline + 1
      message = message.slice 0, newline

    args = [ "-m", message ]
    paragraph and args.push "-m", paragraph

    exec.async "git commit", args, cwd: modulePath

    .then (stdout) ->
      firstLine = stdout.slice 0, stdout.indexOf os.EOL
      regex = /^\[.+ ([0-9a-z]{7})\]/
      return find regex, firstLine, 1
