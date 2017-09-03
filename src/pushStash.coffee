
assertValid = require "assertValid"
exec = require "exec"

git = require "./core"

optionTypes =
  keepIndex: "boolean?"
  includeUntracked: "boolean?"

module.exports =
git.pushStash = (modulePath, options = {}) ->
  assertValid modulePath, "string"
  assertValid options, optionTypes

  args = []
  args.push "--keep-index" if options.keepIndex
  args.push "--include-untracked" if options.includeUntracked

  exec.async "git stash", args, cwd: modulePath

  .fail (error) ->

    if /bad revision 'HEAD'/.test error.message
      throw Error "Cannot stash unless an initial commit exists!"

    throw error
