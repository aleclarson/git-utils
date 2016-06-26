
define = require "define"

define exports,

  addBranch: lazy: ->
    require "./addBranch"

  addCommit: lazy: ->
    require "./addCommit"

  addTag: lazy: ->
    require "./addTag"

  assertClean: lazy: ->
    require "./assertClean"

  assertRepo: lazy: ->
    require "./assertRepo"

  assertStaged: lazy: ->
    require "./assertStaged"

  changeBranch: lazy: ->
    require "./changeBranch"

  diff: lazy: ->
    require "./diff"

  findVersion: lazy: ->
    require "./findVersion"

  getBranches: lazy: ->
    require "./getBranches"

  getCurrentBranch: lazy: ->
    require "./getCurrentBranch"

  getLatestCommit: lazy: ->
    require "./getLatestCommit"

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

  hasChanges: lazy: ->
    require "./hasChanges"

  isRepo: lazy: ->
    require "./isRepo"

  mergeBranch: lazy: ->
    require "./mergeBranch"

  pick: lazy: ->
    require "./pick"

  popStash: lazy: ->
    require "./popStash"

  pushChanges: lazy: ->
    require "./pushChanges"

  pushStash: lazy: ->
    require "./pushStash"

  pushTags: lazy: ->
    require "./pushTags"

  pushVersion: lazy: ->
    require "./pushVersion"

  removeBranch: lazy: ->
    require "./removeBranch"

  removeTag: lazy: ->
    require "./removeTag"

  stageAll: lazy: ->
    require "./stageAll"

  undoLatestCommit: lazy: ->
    require "./undoLatestCommit"

  unstageAll: lazy: ->
    require "./unstageAll"
