
require "./resetBranch"
git = require "./core"

module.exports =
git.revert = (modulePath) ->
  git.resetBranch modulePath, "HEAD^", {soft: true}
  .fail (error) ->
    if /^fatal: ambiguous argument/.test error.message
      return git.resetBranch modulePath, null, {soft: true}
    throw error
