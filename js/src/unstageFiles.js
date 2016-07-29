var assertType, exec;

assertType = require("assertType");

exec = require("exec");

module.exports = function(modulePath, files) {
  assertType(modulePath, String);
  assertType(files, [String, Array]);
  if (!Array.isArray(files)) {
    files = [files];
  }
  return exec.async("git reset --", files, {
    cwd: modulePath
  });
};

//# sourceMappingURL=../../map/src/unstageFiles.map
