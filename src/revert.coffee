
require "./resetBranch"
git = require "./core"

module.exports =
git.revert = (cwd) ->

  try await git.resetBranch cwd, "HEAD^", {soft: true}
  catch err

    # Undo the initial commit if necessary.
    if /^fatal: ambiguous argument/.test err.message
      return git.resetBranch cwd, null, {soft: true}

    throw err
