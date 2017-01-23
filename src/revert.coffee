
require "./resetBranch"
git = require "./core"

module.exports =
git.revert = (modulePath) ->
  git.resetBranch modulePath, "HEAD^"
  .fail (error) ->
    if /^fatal: ambiguous argument/.test error.message
      return git.resetBranch modulePath, null
    throw error
