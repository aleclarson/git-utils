var CommitRange, MergeStrategy, assertType, assertTypes, exec, isClean, isType, optionTypes;

assertTypes = require("assertTypes");

assertType = require("assertType");

isType = require("isType");

exec = require("exec");

MergeStrategy = require("./MergeStrategy");

CommitRange = require("./CommitRange");

isClean = require("./isClean");

optionTypes = {
  strategy: MergeStrategy.Maybe
};

module.exports = function(modulePath, commit, options) {
  var args;
  if (options == null) {
    options = {};
  }
  assertType(modulePath, String);
  assertType(commit, String.or(CommitRange));
  assertTypes(options, optionTypes);
  if (isType(commit, Object)) {
    args = [commit.from + ".." + commit.to];
  } else {
    args = [commit];
  }
  if (options.strategy) {
    args.push("-X", options.strategy);
  }
  return exec.async("git cherry-pick", args, {
    cwd: modulePath
  }).then(function() {
    return isClean(modulePath);
  }).fail(function(error) {
    if (/error: could not apply/.test(error.message)) {
      return false;
    }
    throw error;
  }).then(function(clean) {
    if (!clean) {
      return;
    }
    return exec.async("git cherry-pick --continue", {
      cwd: modulePath
    });
  });
};

//# sourceMappingURL=map/pick.map
