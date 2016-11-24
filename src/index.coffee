
define = require "define"

define exports,

  addBranch: lazy: ->
    require "./addBranch"

  addTag: lazy: ->
    require "./addTag"

  assertRepo: lazy: ->
    require "./assertRepo"

  blame: lazy: ->
    require "./blame"

  commit: lazy: ->
    require "./commit"

  deleteBranch: lazy: ->
    require "./deleteBranch"

  deleteFile: lazy: ->
    require "./deleteFile"

  deleteTag: lazy: ->
    require "./deleteTag"

  diff: lazy: ->
    require "./diff"

  diffConflicts: lazy: ->
    require "./diffConflicts"

  findConflicts: lazy: ->
    require "./findConflicts"

  findVersion: lazy: ->
    require "./findVersion"

  getBranch: lazy: ->
    require "./getBranch"

  getBranches: lazy: ->
    require "./getBranches"

  getConfig: lazy: ->
    require "./getConfig"

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

  popStash: lazy: ->
    require "./popStash"

  pushBranch: lazy: ->
    require "./pushBranch"

  pushStash: lazy: ->
    require "./pushStash"

  pushTags: lazy: ->
    require "./pushTags"

  pushVersion: lazy: ->
    require "./pushVersion"

  renameFile: lazy: ->
    require "./renameFile"

  resetBranch: lazy: ->
    require "./resetBranch"

  resetFiles: lazy: ->
    require "./resetFiles"

  setBranch: lazy: ->
    require "./setBranch"

  stageFiles: lazy: ->
    require "./stageFiles"

  unstageFiles: lazy: ->
    require "./unstageFiles"
