
assertTypes = require "assertTypes"
assertType = require "assertType"
exec = require "exec"

optionTypes =
  remote: String.Maybe

module.exports = (modulePath, tagName, options = {}) ->

  assertType modulePath, String
  assertType tagName, String
  assertTypes options, optionTypes

  exec.async "git tag -d #{tagName}", cwd: modulePath

  .then ->
    return if not options.remote
    exec.async "git push #{options.remote} :#{tagName}", cwd: modulePath
