var Null, assertType, assertTypes, exec, git, isType, optionTypes;

assertTypes = require("assertTypes");

assertType = require("assertType");

isType = require("isType");

Null = require("Null");

exec = require("exec");

git = require("./core");

optionTypes = {
  clean: Boolean.Maybe
};

module.exports = git.resetBranch = function(modulePath, commit, options) {
  var hardness;
  if (isType(commit, Object)) {
    options = commit;
    commit = "HEAD";
  } else {
    if (options == null) {
      options = {};
    }
  }
  assertType(modulePath, String);
  assertType(commit, String.or(Null));
  assertTypes(options, optionTypes);
  if (commit === null) {
    return exec.async("git update-ref -d HEAD", {
      cwd: modulePath
    }).then(function() {
      return options.clean && exec.async("git reset --hard", {
        cwd: modulePath
      });
    });
  } else {
    hardness = options.clean ? "--hard" : "--soft";
    return exec.async("git reset", [hardness, commit], {
      cwd: modulePath
    });
  }
};

//# sourceMappingURL=map/resetBranch.map
