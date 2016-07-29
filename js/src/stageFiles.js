var assertType, exec;

assertType = require("assertType");

exec = require("exec");

module.exports = function(modulePath, files) {
  assertType(modulePath, String);
  assertType(files, [String, Array]);
  if (!Array.isArray(files)) {
    files = [files];
  }
  return exec.async("git add", files, {
    cwd: modulePath
  }).fail(function(error) {
    if (/The following paths are ignored/.test(error.message)) {
      return;
    }
    throw error;
  });
};

//# sourceMappingURL=../../map/src/stageFiles.map
