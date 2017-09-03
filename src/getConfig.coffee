
assertValid = require "assertValid"
exec = require "exec"
log = require "log"

git = require "./core"

module.exports =
git.getConfig = (keyPath) ->
  assertValid keyPath, "string?"

  args =
    if keyPath
    then ["--get", keyPath]
    else ["--list"]

  exec.async "git config", args

  .then (stdout) ->

    if keyPath
      return stdout

    config = Object.create null
    stdout
      .split log.ln
      .forEach (entry) ->
        [key, value] = entry.split "="
        config[key] = value

    return config
