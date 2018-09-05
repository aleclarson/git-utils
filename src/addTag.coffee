assertValid = require "assertValid"
exec = require "exec"

git = require "./core"

optionTypes =
  force: "boolean?"

module.exports =
git.addTag = (repo, tag, opts = {}) ->
  assertValid repo, "string"
  assertValid tag, "string"
  assertValid opts, optionTypes

  args = [ tag ]
  args.push "-f" if opts.force

  try
    await exec "git tag", args, {cwd: repo}
    return

  catch err

    if !opts.force
      if err.message is "fatal: tag '#{tag}' already exists"
        throw Error "Tag already exists!"

    throw err
