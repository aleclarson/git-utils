var assertTypes, exec, fs, isType, optionTypes;

assertTypes = require("assertTypes");

isType = require("isType");

exec = require("exec");

fs = require("io/sync");

optionTypes = {
  modulePath: String,
  commit: String.Maybe
};

module.exports = function(options) {
  var commit, modulePath;
  if (isType(options, String)) {
    options = {
      modulePath: arguments[0],
      commit: arguments[1]
    };
  }
  assertTypes(options, optionTypes);
  modulePath = options.modulePath, commit = options.commit;
  if (commit == null) {
    commit = "HEAD";
  }
  return exec("git reset --hard " + commit, {
    cwd: modulePath
  });
};

//# sourceMappingURL=../../map/src/setHead.map
