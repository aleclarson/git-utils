var Null, assertType, assertTypes, exec, optionTypes;

assertTypes = require("assertTypes");

assertType = require("assertType");

Null = require("Null");

exec = require("exec");

optionTypes = {
  clean: Boolean.Maybe
};

module.exports = function(modulePath, commit, options) {
  var args;
  if (options == null) {
    options = {};
  }
  if (commit === void 0) {
    commit = "HEAD";
  }
  assertType(modulePath, String);
  assertType(commit, [String, Null]);
  assertTypes(options, optionTypes);
  if (commit === null) {
    return exec.async("git update-ref -d HEAD", {
      cwd: modulePath
    }).then(function() {
      if (!options.clean) {
        return;
      }
      return exec.async("git reset --hard", {
        cwd: modulePath
      });
    });
  }
  args = [options.clean ? "--hard" : "--soft", commit || HEAD];
  return exec.async("git reset", args, {
    cwd: modulePath
  });
};

//# sourceMappingURL=../../map/src/resetBranch.map
