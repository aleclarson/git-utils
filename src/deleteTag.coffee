
assertValid = require "assertValid"
exec = require "exec"

git = require "./core"

optionTypes =
  remote: "string?"

module.exports =
git.deleteTag = (modulePath, tagName, options = {}) ->
  assertValid modulePath, "string"
  assertValid tagName, "string"
  assertValid options, optionTypes

  exec.async "git tag -d #{tagName}", cwd: modulePath

  .then ->
    return if not options.remote
    exec.async "git push #{options.remote} :#{tagName}", cwd: modulePath
