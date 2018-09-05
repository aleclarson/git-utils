assertValid = require "assertValid"
exec = require "exec"
os = require "os"

require "./getBranch"
git = require "./core"

optionTypes =
  force: "boolean?"
  remote: "string?"
  branch: "string?"
  keyPath: "string?"
  upstream: "boolean?"
  listener: "function?"

module.exports =
git.pushBranch = (repo, opts = {}) ->
  assertValid repo, "string"
  assertValid opts, optionTypes

  branch = await git.getBranch repo
  if branch == null
    throw Error "An initial commit must exist!"

  args = []
  args.push "-f" if opts.force
  args.push "-u" if opts.upstream
  args.push opts.remote or "origin"

  if opts.branch and branch != opts.branch
  then args.push branch + ":" + opts.branch
  else args.push branch

  if opts.keyPath
    env = {}
    env.GIT_SSH_COMMAND =
      "ssh -i #{opts.keyPath} -F /dev/null" +
      if opts.debug then " -vvv" else ""

  try
    await exec "git push", args,
      cwd: repo
      env: env or process.env
      listener: opts.listener
    return

  catch err

    if !opts.force
      if /\(non-fast-forward\)/.test err.message
        throw Error "Must force push to overwrite remote commits!"

    # Detect "force updates" and normal pushes. 'git push' incorrectly prints to 'stderr'!
    regex = RegExp "(\\+|\\s)[\\s]+([a-z0-9]{7})[\\.]{2,3}([a-z0-9]{7})[\\s]+(HEAD|#{branch})[\\s]+->[\\s]+#{branch}"
    return if regex.test err.message

    # Detect new branch pushes. 'git push' incorrectly prints to 'stderr'!
    regex = RegExp "\\*[\\s]+\\[new branch\\][\\s]+#{branch}[\\s]+->[\\s]+#{branch}"
    return if regex.test err.message

    throw err
