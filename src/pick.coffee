assertValid = require "assertValid"
isValid = require "isValid"
valido = require "valido"
exec = require "exec"

MergeStrategy = require "./MergeStrategy"

require "./isClean"
git = require "./core"

commitTypes = valido [
  "string"
  {from: "string", to: "string"}
]

optionTypes =
  strategy: [MergeStrategy, "?"]

module.exports =
git.pick = (repo, commit, opts = {}) ->
  assertValid repo, "string"
  assertValid commit, commitTypes
  assertValid opts, optionTypes

  args =
    if isValid commit, "object"
    then [ commit.from + ".." + commit.to ]
    else [ commit ]

  if opts.strategy
    args.push "-X", opts.strategy

  try
    await exec "git cherry-pick", args, {cwd: repo}
    clean = await git.isClean repo

  catch err
    # `cherry-pick` prints to stderr for merge conflicts
    if !clean = /error: could not apply/.test err.message
      throw err

  if !clean
    await exec "git cherry-pick --continue", {cwd: repo}

  return
