assertValid = require "assertValid"
exec = require "exec"
os = require "os"

git = require "./core"

module.exports =
git.getConfig = (keyPath) ->
  assertValid keyPath, "string?"

  args =
    if keyPath
    then ["--get", keyPath]
    else ["--list"]

  stdout = await exec "git config", args
  return stdout if keyPath

  config = Object.create null
  stdout.split(os.EOL).forEach (entry) ->
    [key, value] = entry.split "="
    config[key] = value

  return config
