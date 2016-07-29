
assertType = require "assertType"
exec = require "exec"

module.exports = (modulePath, files) ->

  assertType modulePath, String
  assertType files, [ String, Array ]

  if not Array.isArray files
    files = [ files ]

  exec.async "git add", files, cwd: modulePath

  .fail (error) ->

    if /The following paths are ignored/.test error.message
      return # 'git add' complains when ignored files are added (eg: 'git add *').

    throw error
