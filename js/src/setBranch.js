var assertTypes, exec, git, isType, optionTypes;

assertTypes = require("assertTypes");

isType = require("isType");

exec = require("exec");

git = {
  getBranch: require("./getBranch"),
  hasBranch: require("./hasBranch"),
  isClean: require("./isClean")
};

optionTypes = {
  modulePath: String,
  branchName: String,
  force: Boolean.Maybe
};

module.exports = function(options) {
  var branchName, force, modulePath;
  if (isType(options, String)) {
    options = {
      modulePath: arguments[0],
      branchName: arguments[1]
    };
  }
  assertTypes(options, optionTypes);
  modulePath = options.modulePath, branchName = options.branchName, force = options.force;
  return git.getBranch(modulePath).then(function(currentBranch) {
    if (currentBranch === branchName) {
      return currentBranch;
    }
    return git.isClean(modulePath).then(function(clean) {
      if (!clean) {
        throw Error("The current branch has uncommitted changes!");
      }
      return git.hasBranch({
        modulePath: modulePath,
        branchName: branchName
      });
    }).then(function(branchExists) {
      var args;
      args = [branchName];
      if (!branchExists) {
        if (!force) {
          throw Error("Invalid branch name!");
        }
        args.unshift("-b");
      }
      return exec("git checkout", args, {
        cwd: modulePath
      }).fail(function(error) {
        if (/Switched to branch/.test(error.message)) {
          return;
        }
        throw error;
      });
    });
  });
};

//# sourceMappingURL=../../map/src/setBranch.map
