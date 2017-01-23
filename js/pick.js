var CommitRange, MergeStrategy, assertType, assertTypes, exec, git, isType, optionTypes;

assertTypes = require("assertTypes");

assertType = require("assertType");

isType = require("isType");

exec = require("exec");

MergeStrategy = require("./MergeStrategy");

CommitRange = require("./CommitRange");

require("./isClean");

git = require("./core");

optionTypes = {
  strategy: MergeStrategy.Maybe
};

module.exports = git.pick = function(modulePath, commit, options) {
  var args;
  if (options == null) {
    options = {};
  }
  assertType(modulePath, String);
  assertType(commit, String.or(CommitRange));
  assertTypes(options, optionTypes);
  args = isType(commit, Object) ? [commit.from + ".." + commit.to] : [commit];
  if (options.strategy) {
    args.push("-X", options.strategy);
  }
  return exec.async("git cherry-pick", args, {
    cwd: modulePath
  }).then(function() {
    return git.isClean(modulePath);
  }).fail(function(error) {
    if (/error: could not apply/.test(error.message)) {
      return true;
    }
    throw error;
  }).then(function(clean) {
    if (clean) {
      return;
    }
    return exec.async("git cherry-pick --continue", {
      cwd: modulePath
    });
  });
};

//# sourceMappingURL=map/pick.map
