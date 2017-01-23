
# TODO: Test against an empty diff.
# TODO: Test with non-existent commits.
# TODO: Test with branches.

{find} = require "finder"

assertType   = require "assertType"
exec = require "exec"
os = require "os"

git = require "./core"

module.exports =
git.diff = (modulePath, firstCommit, lastCommit = "HEAD") ->

  assertType modulePath, String
  assertType firstCommit, String
  assertType lastCommit, String

  exec.async "git diff --raw #{firstCommit}..#{lastCommit}",  cwd: modulePath

  .then (stdout) ->
    lines = stdout.split os.EOL
    regex = /^:[0-9]{6} [0-9]{6} [0-9a-z]{7}\.\.\. [0-9a-z]{7}\.\.\. (.)\t(.+)$/
    return lines.map (line) ->
      status = find regex, line, 1
      path = find regex, line, 2
      return { status, path }

  .fail (error) ->

    if /unknown revision or path not in the working tree/.test error.message
      throw Error "Unknown revision (or path not in the working tree)!"

    throw error
