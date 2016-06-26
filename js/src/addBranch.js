var assertTypes, exec, isType, log, optionTypes;

assertTypes = require("assertTypes");

isType = require("isType");

exec = require("exec");

log = require("log");

optionTypes = {
  modulePath: String,
  branchName: String
};

module.exports = function(options) {
  var branchName, modulePath;
  if (isType(options, String)) {
    options = {
      modulePath: arguments[0],
      branchName: arguments[1]
    };
  }
  assertTypes(options, optionTypes);
  modulePath = options.modulePath, branchName = options.branchName;
  return exec("git checkout -b " + branchName, {
    cwd: modulePath
  }).fail(function(error) {
    if (/Switched to a new branch/.test(error.message)) {
      return;
    }
    throw error;
  });
};

//# sourceMappingURL=../../map/src/addBranch.map
