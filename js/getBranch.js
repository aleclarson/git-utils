var assertType, exec, git;

assertType = require("assertType");

exec = require("exec");

git = require("./core");

module.exports = git.getBranch = function(modulePath) {
  assertType(modulePath, String);
  return exec.async("git rev-parse --abbrev-ref HEAD", {
    cwd: modulePath
  }).fail(function(error) {
    if (/ambiguous argument 'HEAD'/.test(error.message)) {
      return null;
    }
    throw error;
  });
};

//# sourceMappingURL=map/getBranch.map
