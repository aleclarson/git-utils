{find} = require "finder"

assertValid = require "assertValid"
exec = require "exec"
os = require "os"

require "./isStaged"
git = require "./core"

commitishRE = /^\[.+ ([0-9a-z]{7})\]/

module.exports =
git.commit = (repo, message) ->
  assertValid repo, "string"
  assertValid message, "string"

  unless await git.isStaged repo
    throw Error "No changes were staged!"

  newline = message.indexOf os.EOL
  if newline >= 0
    paragraph = message.slice newline + 1
    message = message.slice 0, newline

  args = [ "-m", message ]
  paragraph and args.push "-m", paragraph

  stdout = await exec "git commit", args, {cwd: repo}
  firstLine = stdout.slice 0, stdout.indexOf os.EOL
  return find commitishRE, firstLine, 1
