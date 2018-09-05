
require "./resetBranch"
git = require "./core"

module.exports =
git.revertHead = (repo) ->

  try
    await git.resetBranch repo, "HEAD^", {mode: "soft"}
    return # TODO: return the new HEAD commit?

  catch err

    # Undo the initial commit if necessary.
    if /^fatal: ambiguous argument/.test err.message
      return git.resetBranch repo, null, {mode: "soft"}

    throw err
