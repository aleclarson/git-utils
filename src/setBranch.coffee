assertValid = require "assertValid"
exec = require "exec"

require "./getBranch"
require "./hasBranch"
require "./isClean"
git = require "./core"

optionTypes =
  force: "boolean?"
  ifExists: "boolean?"
  mustExist: "boolean?"

module.exports =
git.setBranch = (repo, branch, opts = {}) ->
  assertValid repo, "string"
  assertValid branch, "string"
  assertValid opts, optionTypes

  currentBranch = await git.getBranch repo
  if branch == currentBranch
    return branch

  # Check if the branch is clean (or force was used).
  if !opts.force and !await git.isClean repo
    throw Error "The current branch has uncommitted changes!"

  args = [ branch ]

  # Check if the branch exists.
  if !await git.hasBranch repo, branch

    if opts.ifExists
      return currentBranch

    if opts.mustExist
      throw Error "Unknown branch: '#{branch}'"

    args.unshift "-b"

  try
    await exec "git checkout", args, {cwd: repo}
    return branch

  catch err
    msg = err.message

    # 'git checkout' incorrectly prints to 'stderr'
    if msg.startsWith "Switched to branch"
      return branch
    if msg.startsWith "Switched to a new branch"
      return branch

    throw error
