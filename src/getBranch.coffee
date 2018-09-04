assertValid = require "assertValid"
exec = require "exec"

git = require "./core"

module.exports =
git.getBranch = (repo) ->
  assertValid repo, "string"

  try await exec "git rev-parse --abbrev-ref HEAD", {cwd: repo}
  catch err

    if /ambiguous argument 'HEAD'/.test err.message
      return null

    throw err
