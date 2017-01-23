var assertType, exec, git, os;

assertType = require("assertType");

exec = require("exec");

os = require("os");

git = require("./core");

module.exports = git.getTags = function(modulePath) {
  assertType(modulePath, String);
  return exec.async("git tag", {
    cwd: modulePath
  }).then(function(stdout) {
    if (stdout.length === 0) {
      return [];
    }
    return stdout.split(os.EOL);
  });
};

//# sourceMappingURL=map/getTags.map
