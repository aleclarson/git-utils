
resetBranch = require "./resetBranch"

revertCommit = (modulePath) ->
  resetBranch modulePath, "HEAD^"
  .fail (error) ->
    if /^fatal: ambiguous argument/.test error.message
      return resetBranch modulePath, null
    throw error

module.exports = revertCommit
