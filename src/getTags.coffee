# TODO: Add `remote` option
assertValid = require "assertValid"
exec = require "exec"
os = require "os"

git = require "./core"

optionTypes =
  remote: "string?"
  commits: "boolean?"

module.exports =
git.getTags = (repo, opts = {}) ->
  assertValid repo, "string"
  assertValid opts, optionTypes

  if opts.remote
    tags = await exec "git ls-remote -t", opts.remote, {cwd: repo}
    return tags.split(os.EOL).map (line) ->
      [commit, tag] = line.split "\trefs/tags/"
      opts.commits and { tag, commit } or tag

  if tags = await exec "git tag", {cwd: repo}
    tags = tags.split os.EOL
    return tags if !opts.commits

    commits = await exec "git rev-list --tags --reverse", {cwd: repo}
    commits = commits.split os.EOL

    return tags.map (tag, i) ->
      { tag, commit: commits[i] }

  return []
