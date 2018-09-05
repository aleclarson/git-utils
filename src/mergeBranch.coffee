assertValid = require "assertValid"
exec = require "exec"

MergeStrategy = require "./MergeStrategy"

require "./isClean"
require "./getBranch"
require "./setBranch"
git = require "./core"

optionTypes =
  ours: "string?"
  theirs: "string"
  strategy: [MergeStrategy, "?"]

module.exports =
git.mergeBranch = (repo, opts) ->
  assertValid repo, "string"
  assertValid opts, optionTypes

  unless await git.isClean repo
    throw Error "The current branch cannot have any uncommitted changes!"

  if opts.ours
    startBranch = await git.getBranch repo
    if opts.ours != startBranch
      await git.setBranch repo, opts.ours

  args = [
    opts.theirs
    "--no-commit"
    "--no-ff"
  ]

  if opts.strategy
    args.push "-X", opts.strategy

  try
    await exec "git merge", args, {cwd: repo}
    return

  catch err

    if /Automatic merge went well/.test err.message
      return # 'git merge' incorrectly prints to 'stderr'

    # TODO: Fail gracefully if the merge was empty.
    throw err

  finally
    if opts.ours and opts.ours != startBranch
      await git.setBranch repo, startBranch
