var Promise, assertType, assertTypes, exec, git, optionTypes;

assertTypes = require("assertTypes");

assertType = require("assertType");

Promise = require("Promise");

exec = require("exec");

require("./getBranch");

require("./hasBranch");

require("./isClean");

git = require("./core");

optionTypes = {
  force: Boolean.Maybe
};

module.exports = git.setBranch = function(modulePath, branchName, options) {
  if (options == null) {
    options = {};
  }
  assertType(modulePath, String);
  assertType(branchName, String);
  assertTypes(options, optionTypes);
  return git.getBranch(modulePath).then(function(currentBranch) {
    if (currentBranch === branchName) {
      return currentBranch;
    }
    return Promise["try"](function() {
      if (options.force) {
        return;
      }
      return git.isClean(modulePath).then(function(clean) {
        return clean || (function() {
          throw Error("The current branch has uncommitted changes!");
        })();
      });
    }).then(function() {
      return git.hasBranch(modulePath, branchName);
    }).then(function(branchExists) {
      var args;
      args = [branchName];
      if (!branchExists) {
        options.force || (function() {
          throw Error("Invalid branch name!");
        })();
        args.unshift("-b");
      }
      return exec.async("git checkout", args, {
        cwd: modulePath
      }).fail(function(error) {
        var message;
        message = error.message;
        if (message.startsWith("Switched to branch")) {
          return;
        }
        if (message.startsWith("Switched to a new branch")) {
          return;
        }
        throw error;
      });
    });
  });
};

//# sourceMappingURL=map/setBranch.map
