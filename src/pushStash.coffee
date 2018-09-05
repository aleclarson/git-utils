assertValid = require "assertValid"
exec = require "exec"

git = require "./core"

optionTypes =
  keepStaged: "boolean?"
  keepUntracked: "boolean?"

module.exports =
git.pushStash = (repo, opts = {}) ->
  assertValid repo, "string"
  assertValid opts, optionTypes

  args = []
  args.push "--keep-index" if opts.keepStaged
  args.push "--include-untracked" if !opts.keepUntracked

  try
    await exec "git stash", args, {cwd: repo}
    return

  catch err

    if /bad revision 'HEAD'/.test err.message
      throw Error "Cannot stash unless an initial commit exists!"

    throw err
