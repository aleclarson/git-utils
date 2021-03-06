assertValid = require "assertValid"
exec = require "exec"

git = require "./core"

optionTypes =
  remote: "string?"
  remoteOnly: "boolean?"

module.exports =
git.deleteTag = (repo, tag, opts = {}) ->
  assertValid repo, "string"
  assertValid tag, "string"
  assertValid opts, optionTypes

  if !opts.remoteOnly
    await exec "git tag -d #{tag}", {cwd: repo}
  if opts.remote
    await exec "git push #{opts.remote} :#{tag}", {cwd: repo}
  return
