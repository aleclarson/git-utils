
define = require "define"

define exports,

  addBranch: lazy: ->
    require "./addBranch"

  addTag: lazy: ->
    require "./addTag"

  assertClean: lazy: ->
    require "./assertClean"

  assertRepo: lazy: ->
    require "./assertRepo"

  assertStaged: lazy: ->
    require "./assertStaged"

  blame: lazy: ->
    require "./blame"

  diff: lazy: ->
    require "./diff"

  findConflicts: lazy: ->
    require "./findConflicts"

  findVersion: lazy: ->
    require "./findVersion"

  getBranches: lazy: ->
    require "./getBranches"

  getBranch: lazy: ->
    require "./getBranch"

  getHead: lazy: ->
    require "./getHead"

  getRemotes: lazy: ->
    require "./getRemotes"

  getStatus: lazy: ->
    require "./getStatus"

  getTags: lazy: ->
    require "./getTags"

  getVersions: lazy: ->
    require "./getVersions"

  hasBranch: lazy: ->
    require "./hasBranch"

  isClean: lazy: ->
    require "./isClean"

  isRepo: lazy: ->
    require "./isRepo"

  isStaged: lazy: ->
    require "./isStaged"

  mergeBranch: lazy: ->
    require "./mergeBranch"

  mergeFiles: lazy: ->
    require "./mergeFiles"

  pick: lazy: ->
    require "./pick"

  popCommit: lazy: ->
    require "./popCommit"

  popStash: lazy: ->
    require "./popStash"

  pushCommit: lazy: ->
    require "./pushCommit"

  pushHead: lazy: ->
    require "./pushHead"

  pushStash: lazy: ->
    require "./pushStash"

  pushTags: lazy: ->
    require "./pushTags"

  pushVersion: lazy: ->
    require "./pushVersion"

  removeBranch: lazy: ->
    require "./removeBranch"

  removeFile: lazy: ->
    require "./removeFile"

  removeTag: lazy: ->
    require "./removeTag"

  renameFile: lazy: ->
    require "./renameFile"

  resetFile: lazy: ->
    require "./resetFile"

  setBranch: lazy: ->
    require "./setBranch"

  setHead: lazy: ->
    require "./setHead"

  stageAll: lazy: ->
    require "./stageAll"

  unstageAll: lazy: ->
    require "./unstageAll"
