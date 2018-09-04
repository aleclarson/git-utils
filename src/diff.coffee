# TODO: Test against an empty diff.
# TODO: Test with non-existent commits.
# TODO: Test with branches.
{find} = require "finder"

assertValid = require "assertValid"
exec = require "exec"
os = require "os"

git = require "./core"

module.exports =
git.diff = (repo, firstCommit, lastCommit = "HEAD") ->
  assertValid repo, "string"
  assertValid firstCommit, "string"
  assertValid lastCommit, "string"

  try
    range = firstCommit + ".." + lastCommit
    stdout = await exec "git diff --raw #{range}", {cwd: repo}
    lines = stdout.split os.EOL
    regex = /^:[0-9]{6} [0-9]{6} [0-9a-z]{7}\.\.\. [0-9a-z]{7}\.\.\. (.)\t(.+)$/
    return lines.map (line) ->
      status = find regex, line, 1
      path = find regex, line, 2
      return { status, path }

  catch err

    if /unknown revision or path not in the working tree/.test err.message
      throw Error "Unknown revision (or path not in the working tree)!"

    throw err
