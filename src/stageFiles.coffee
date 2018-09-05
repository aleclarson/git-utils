assertValid = require "assertValid"
exec = require "exec"

git = require "./core"

module.exports =
git.stageFiles = (repo, files) ->
  assertValid repo, "string"
  assertValid files, "string|array"

  if typeof files == "string"
    files = [files]

  else if !files.length
    return

  try
    await exec "git add --", files, {cwd: repo}
    return

  catch err

    if /The following paths are ignored/.test err.message
      return # 'git add' complains when ignored files are added (eg: 'git add *').

    throw err
