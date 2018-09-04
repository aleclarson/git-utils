assertValid = require "assertValid"
exec = require "exec"

require "./getBranch"
require "./hasBranch"
require "./isClean"
git = require "./core"

optionTypes =
  force: "boolean?"

module.exports =
git.setBranch = (repo, branch, opts = {}) ->
  assertValid repo, "string"
  assertValid branch, "string"
  assertValid opts, optionTypes

  currentBranch = await git.getBranch repo
  if branch == currentBranch
    return currentBranch

  # The branch must be clean. (unless `opts.force` is used)
  if !opts.force and !await git.isClean repo
    throw Error "The current branch has uncommitted changes!"

  args = [ branch ]

  # The branch must exist. (unless `opts.force` is used)
  if !await git.hasBranch repo, branch
    if !opts.force
      throw Error "Unknown branch: '#{branch}'"
    args.unshift "-b"

  try await exec "git checkout", args, {cwd: repo}
  catch err
    {message} = err

    # 'git checkout' incorrectly prints to 'stderr'
    return if message.startsWith "Switched to branch"
    return if message.startsWith "Switched to a new branch"

    throw error
