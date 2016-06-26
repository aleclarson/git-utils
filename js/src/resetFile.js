var Path, assertTypes, exec, isType, optionTypes;

assertTypes = require("assertTypes");

isType = require("isType");

Path = require("path");

exec = require("exec");

optionTypes = {
  modulePath: String,
  filePath: String,
  commit: String.Maybe,
  dryRun: Boolean.Maybe
};

module.exports = function(options) {
  var args, commit, dryRun, filePath, modulePath;
  if (isType(optionTypes, String)) {
    options = {
      modulePath: arguments[0],
      filePath: arguments[1]
    };
  }
  assertTypes(options, optionTypes);
  modulePath = options.modulePath, filePath = options.filePath, commit = options.commit, dryRun = options.dryRun;
  if (filePath[0] === Path.sep) {
    filePath = Path.relative(modulePath, filePath);
  }
  if (!commit) {
    commit = "HEAD";
  }
  args = [commit, "--", filePath];
  if (dryRun) {
    args.push("-p");
  }
  return exec("git checkout", args, {
    cwd: modulePath
  });
};

//# sourceMappingURL=../../map/src/resetFile.map
