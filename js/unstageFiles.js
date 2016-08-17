var assertType, exec;

assertType = require("assertType");

exec = require("exec");

module.exports = function(modulePath, files) {
  assertType(modulePath, String);
  assertType(files, String.or(Array));
  if (!Array.isArray(files)) {
    files = [files];
  }
  return exec.async("git reset --", files, {
    cwd: modulePath
  });
};

//# sourceMappingURL=map/unstageFiles.map
