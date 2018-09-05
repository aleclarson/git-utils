assertValid = require "assertValid"
path = require "path"
exec = require "exec"

git = require "./core"

optionTypes =
  commit: "string?"
  dryRun: "boolean?"

module.exports =
git.revertFiles = (repo, files, opts = {}) ->
  assertValid repo, "string"
  assertValid files, "string|array"
  assertValid opts, optionTypes

  if typeof files == "string"
    files = [files]

  else if !files.length
    return

  files = files.map (file) ->
    return file if !path.isAbsolute file

    name = path.relative repo, file
    return name if name[0] != "."

    throw Error "Absolute path '#{file}' cannot be outside '#{repo}'"

  args = [ opts.commit or "HEAD" ]
  args.push "-p" if opts.dryRun

  # TODO: Possibly parse the 'dryRun' output?
  await exec "git checkout", args, "--", files, {cwd: repo}
