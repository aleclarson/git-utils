var Promise, assertType, assertTypes, exec, git, optionTypes;

assertTypes = require("assertTypes");

assertType = require("assertType");

Promise = require("Promise");

exec = require("exec");

git = {
  getBranch: require("./getBranch"),
  hasBranch: require("./hasBranch")
};

optionTypes = {
  remote: String.Maybe,
  message: Boolean.Maybe
};

module.exports = function(modulePath, branchName, options) {
  if (options == null) {
    options = {};
  }
  assertType(modulePath, String);
  assertType(branchName, String.Maybe);
  assertTypes(options, optionTypes);
  return Promise["try"](function() {
    if (branchName) {
      return git.hasBranch(modulePath, branchName).then(function(hasBranch) {
        if (hasBranch) {
          return;
        }
        return branchName = null;
      });
    }
    return git.getBranch(modulePath).then(function(currentBranch) {
      return branchName = currentBranch;
    });
  }).then(function() {
    var args;
    if (branchName === null) {
      return null;
    }
    args = ["-1", "--pretty=oneline", (options.remote || "origin") + "/" + branchName];
    return exec.async("git log", args, {
      cwd: modulePath
    }).then(function(stdout) {
      var id, separator;
      separator = stdout.indexOf(" ");
      id = stdout.slice(0, separator);
      if (options.message) {
        return {
          id: id,
          message: stdout.slice(separator + 1)
        };
      }
      return id;
    });
  });
};

//# sourceMappingURL=../../map/src/getHead.map
