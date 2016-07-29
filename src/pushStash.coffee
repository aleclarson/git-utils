
assertTypes = require "assertTypes"
assertType = require "assertType"
exec = require "exec"

optionTypes =
  keepIndex: Boolean.Maybe

module.exports = (modulePath, options = {}) ->

  assertType modulePath, String
  assertTypes options, optionTypes

  args = []
  args.push "--keep-index" if options.keepIndex

  exec.async "git stash", args, cwd: modulePath

  .fail (error) ->

    if /bad revision 'HEAD'/.test error.message
      throw Error "Cannot stash unless an initial commit exists!"

    throw error
