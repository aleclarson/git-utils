
assertValid = require "assertValid"
exec = require "exec"

git = require "./core"

optionTypes =
  force: "boolean?"

module.exports =
git.addTag = (modulePath, tagName, options = {}) ->
  assertValid modulePath, "string"
  assertValid tagName, "string"
  assertValid options, optionTypes

  args = [ tagName ]
  args.unshift "-f" if options.force

  exec.async "git tag", args, cwd: modulePath

  .fail (error) ->

    if not options.force
      expected = "fatal: tag '#{tagName}' already exists"
      if error.message is expected
        throw Error "Tag already exists!"

    throw error
