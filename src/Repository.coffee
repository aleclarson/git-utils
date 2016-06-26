
getArgProp = require "getArgProp"
assert = require "assert"
Type = require "Type"

git = require "."

type = Type "GitRepository"

type.argumentTypes =
  modulePath: String

type.defineFrozenValues

  modulePath: getArgProp "modulePath"

type.initInstance (modulePath) ->
  assert git.isRepo(modulePath), "Invalid repository path!"

type.defineMethods

  addBranch: (branchName) ->
    git.addBranch { @modulePath, branchName }

  pushCommit: (message) ->
    git.pushCommit { @modulePath, message }

  addTag: (tagName, force) ->
    git.addTag { @modulePath, tagName, force }

# TODO: Add the other methods...

module.exports = type.build()
