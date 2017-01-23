var Finder, assertType, assertTypes, exec, getRemotes, isType, optionTypes, os;

assertTypes = require("assertTypes");

assertType = require("assertType");

Finder = require("finder");

isType = require("isType");

exec = require("exec");

os = require("os");

getRemotes = require("./getRemotes");

optionTypes = {
  raw: Boolean.Maybe
};

module.exports = function(modulePath, remoteName, options) {
  if (options == null) {
    options = {};
  }
  if (isType(remoteName, Object)) {
    options = remoteName;
    remoteName = null;
  } else {
    if (options == null) {
      options = {};
    }
  }
  assertType(modulePath, String);
  assertType(remoteName, String.Maybe);
  assertTypes(options, optionTypes);
  if (remoteName) {
    return getRemotes(modulePath).then(function(remotes) {
      var remoteUri;
      remoteUri = remotes[remoteName].push;
      return exec.async("git ls-remote --heads " + remoteUri, {
        cwd: modulePath
      });
    }).then(function(stdout) {
      var branches, findName, i, len, line, name, ref;
      if (options.raw) {
        return stdout;
      }
      findName = Finder(/refs\/heads\/(.+)$/);
      branches = [];
      ref = stdout.split(os.EOL);
      for (i = 0, len = ref.length; i < len; i++) {
        line = ref[i];
        name = findName(line);
        if (!name) {
          continue;
        }
        branches.push(name);
      }
      return branches;
    });
  }
  return exec.async("git branch", {
    cwd: modulePath
  }).then(function(stdout) {
    var branches, findName, i, len, line, name, ref;
    if (options.raw) {
      return stdout;
    }
    findName = Finder(/^[\*\s]+([a-zA-Z0-9_\-\.]+)$/);
    branches = [];
    ref = stdout.split(os.EOL);
    for (i = 0, len = ref.length; i < len; i++) {
      line = ref[i];
      name = findName(line);
      if (!name) {
        continue;
      }
      branches.push(name);
      if (line[0] === "*") {
        branches.current = name;
      }
    }
    return branches;
  });
};

//# sourceMappingURL=map/getBranches.map
