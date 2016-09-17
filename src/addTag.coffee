
assertTypes = require "assertTypes"
assertType = require "assertType"
exec = require "exec"

optionTypes =
  force: Boolean.Maybe

module.exports = (modulePath, tagName, options = {}) ->

  assertType modulePath, String
  assertType tagName, String
  assertTypes options, optionTypes

  args = [ tagName ]
  args.unshift "-f" if options.force

  exec.async "git tag", args, cwd: modulePath

  .fail (error) ->

    if not options.force
      expected = "fatal: tag '#{tagName}' already exists"
      if error.message is expected
        throw Error "Tag already exists!"

    throw error
