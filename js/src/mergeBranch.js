var MergeStrategy, Promise, assertType, assertTypes, exec, git, optionTypes;

assertTypes = require("assertTypes");

assertType = require("assertType");

Promise = require("Promise");

exec = require("exec");

MergeStrategy = require("./MergeStrategy");

git = {
  isClean: require("./isClean"),
  getBranch: require("./getBranch"),
  setBranch: require("./setBranch")
};

optionTypes = {
  ours: String.Maybe,
  theirs: String,
  strategy: MergeStrategy.Maybe
};

module.exports = function(modulePath, options) {
  var startBranch;
  assertType(modulePath, String);
  assertTypes(options, optionTypes);
  startBranch = null;
  return git.isClean(modulePath).assert("The current branch cannot have any uncommitted changes!").then(function() {
    return git.getBranch(modulePath).then(function(currentBranch) {
      return startBranch = currentBranch;
    });
  }).then(function() {
    if (!options.ours) {
      return;
    }
    return git.setBranch(modulePath, options.ours);
  }).then(function() {
    var args;
    args = [options.theirs, "--no-commit", "--no-ff"];
    if (options.strategy) {
      args.push("-X", options.strategy);
    }
    return exec.async("git merge", args, {
      cwd: modulePath
    }).fail(function(error) {
      if (/Automatic merge went well/.test(error.message)) {
        return;
      }
      throw error;
    });
  }).always(function() {
    if (!options.ours) {
      return;
    }
    return git.setBranch(modulePath, startBranch);
  });
};

//# sourceMappingURL=../../map/src/mergeBranch.map
