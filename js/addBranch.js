var assertType, exec;

assertType = require("assertType");

exec = require("exec");

module.exports = function(modulePath, branchName) {
  assertType(modulePath, String);
  assertType(branchName, String);
  return exec.async("git checkout -b " + branchName, {
    cwd: modulePath
  }).then(function() {
    return branchName;
  }).fail(function(error) {
    if (/Switched to a new branch/.test(error.message)) {
      return;
    }
    throw error;
  });
};

//# sourceMappingURL=map/addBranch.map
