
{ find } = require "finder"

assertTypes = require "assertTypes"
isType = require "isType"
exec = require "exec"

optionTypes =
  modulePath: String
  from: String
  to: String.Maybe

# TODO: Test against an empty diff.
module.exports = (options) ->

  if isType options, String
    options =
      modulePath: arguments[0]
      from: arguments[1]
      to: arguments[2]

  assertTypes options, optionTypes

  { modulePath, from, to } = options

  to ?= "HEAD"

  exec "git diff --raw #{from}..#{to}",  { cwd: modulePath }

  .then (stdout) ->
    lines = stdout.split "\n"
    regex = /^:[0-9]{6} [0-9]{6} [0-9a-z]{7}\.\.\. [0-9a-z]{7}\.\.\. (.)\t(.+)$/
    return lines.map (line) ->
      status = find regex, line, 1
      path = find regex, line, 2
      return { status, path }

  .fail (error) ->

    if /unknown revision or path not in the working tree/.test error.message
      throw Error "Unknown revision (or path not in the working tree)!"

    throw error
