var assertType, exec, os;

assertType = require("assertType");

exec = require("exec");

os = require("os");

module.exports = function(modulePath) {
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

//# sourceMappingURL=../../map/src/getTags.map
