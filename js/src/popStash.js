var assertType, exec;

assertType = require("assertType");

exec = require("exec");

module.exports = function(modulePath) {
  assertType(modulePath, String);
  return exec.async("git stash pop", {
    cwd: modulePath
  });
};

//# sourceMappingURL=../../map/src/popStash.map
